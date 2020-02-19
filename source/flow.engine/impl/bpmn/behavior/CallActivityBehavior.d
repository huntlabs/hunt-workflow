/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.model.CallActivity;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.IOParameter;
import org.flowable.bpmn.model.MapExceptionEntry;
import org.flowable.bpmn.model.Process;
import org.flowable.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scope.ScopeTypes;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.context.Context;
import flow.engine.impl.delegate.SubProcessActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EntityLinkUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.interceptor.StartSubProcessInstanceAfterContext;
import flow.engine.interceptor.StartSubProcessInstanceBeforeContext;
import flow.engine.repository.ProcessDefinition;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static flow.engine.impl.bpmn.helper.DynamicPropertyUtil.getActiveValue;

/**
 * Implementation of the BPMN 2.0 call activity (limited currently to calling a subprocess and not (yet) a global task).
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class CallActivityBehavior extends AbstractBpmnActivityBehavior implements SubProcessActivityBehavior {

    private static final Logger LOGGER = LoggerFactory.getLogger(CallActivityBehavior.class);

    private static final long serialVersionUID = 1L;

    private static final string EXPRESSION_REGEX = "\\$+\\{+.+\\}";
    public static final string CALLED_ELEMENT_TYPE_KEY = "key";
    public static final string CALLED_ELEMENT_TYPE_ID = "id";

    protected CallActivity callActivity;
    protected string calledElementType;
    protected bool fallbackToDefaultTenant;
    protected List<MapExceptionEntry> mapExceptions;

    public CallActivityBehavior(CallActivity callActivity) {
        this.callActivity = callActivity;
        this.calledElementType = callActivity.getCalledElementType();
        this.mapExceptions = callActivity.getMapExceptions();
        this.fallbackToDefaultTenant = callActivity.getFallbackToDefaultTenant();
    }

    @Override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        CallActivity callActivity = (CallActivity) executionEntity.getCurrentFlowElement();
        
        CommandContext commandContext = CommandContextUtil.getCommandContext();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        ProcessDefinition processDefinition = getProcessDefinition(execution, callActivity, processEngineConfiguration);

        // Get model from cache
        Process subProcess = ProcessDefinitionUtil.getProcess(processDefinition.getId());
        if (subProcess is null) {
            throw new FlowableException("Cannot start a sub process instance. Process model " + processDefinition.getName() + " (id = " + processDefinition.getId() + ") could not be found");
        }

        FlowElement initialFlowElement = subProcess.getInitialFlowElement();
        if (initialFlowElement is null) {
            throw new FlowableException("No start element found for process definition " + processDefinition.getId());
        }

        // Do not start a process instance if the process definition is suspended
        if (ProcessDefinitionUtil.isProcessDefinitionSuspended(processDefinition.getId())) {
            throw new FlowableException("Cannot start process instance. Process definition " + processDefinition.getName() + " (id = " + processDefinition.getId() + ") is suspended");
        }

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

        string businessKey = null;
        if (!StringUtils.isEmpty(callActivity.getBusinessKey())) {
            Expression expression = expressionManager.createExpression(callActivity.getBusinessKey());
            businessKey = expression.getValue(execution).toString();

        } else if (callActivity.isInheritBusinessKey()) {
            ExecutionEntity processInstance = executionEntityManager.findById(execution.getProcessInstanceId());
            businessKey = processInstance.getBusinessKey();
        }
        
        Map<string, Object> variables = new HashMap<>();
        
        StartSubProcessInstanceBeforeContext instanceBeforeContext = new StartSubProcessInstanceBeforeContext(businessKey, callActivity.getProcessInstanceName(), 
                        variables, executionEntity, callActivity.getInParameters(), callActivity.isInheritVariables(), 
                        initialFlowElement.getId(), initialFlowElement, subProcess, processDefinition);
        
        if (processEngineConfiguration.getStartProcessInstanceInterceptor() !is null) {
            processEngineConfiguration.getStartProcessInstanceInterceptor().beforeStartSubProcessInstance(instanceBeforeContext);
        }

        ExecutionEntity subProcessInstance = CommandContextUtil.getExecutionEntityManager(commandContext).createSubprocessInstance(
                        instanceBeforeContext.getProcessDefinition(), instanceBeforeContext.getCallActivityExecution(), 
                        instanceBeforeContext.getBusinessKey(), instanceBeforeContext.getInitialActivityId());

        FlowableEventDispatcher eventDispatcher = processEngineConfiguration.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_CREATED, subProcessInstance));
        }

        // process template-defined data objects
        subProcessInstance.setVariables(processDataObjects(subProcess.getDataObjects()));

        if (instanceBeforeContext.isInheritVariables()) {
            Map<string, Object> executionVariables = execution.getVariables();
            for (Map.Entry<string, Object> entry : executionVariables.entrySet()) {
                instanceBeforeContext.getVariables().put(entry.getKey(), entry.getValue());
            }
        }
        
        // copy process variables
        for (IOParameter inParameter : instanceBeforeContext.getInParameters()) {

            Object value = null;
            if (StringUtils.isNotEmpty(inParameter.getSourceExpression())) {
                Expression expression = expressionManager.createExpression(inParameter.getSourceExpression().trim());
                value = expression.getValue(execution);

            } else {
                value = execution.getVariable(inParameter.getSource());
            }

            string variableName = null;
            if (StringUtils.isNotEmpty(inParameter.getTargetExpression())) {
                Expression expression = expressionManager.createExpression(inParameter.getTargetExpression());
                Object variableNameValue = expression.getValue(execution);
                if (variableNameValue !is null) {
                    variableName = variableNameValue.toString();
                } else {
                    LOGGER.warn("In parameter target expression {} did not resolve to a variable name, this is most likely a programmatic error",
                        inParameter.getTargetExpression());
                }

            } else if (StringUtils.isNotEmpty(inParameter.getTarget())){
                variableName = inParameter.getTarget();

            }

            instanceBeforeContext.getVariables().put(variableName, value);
        }

        if (!instanceBeforeContext.getVariables().isEmpty()) {
            initializeVariables(subProcessInstance, instanceBeforeContext.getVariables());
        }
        
        // Process instance name is resolved after setting the variables on the process instance, so they can be used in the expression
        string processInstanceName = null;
        if (StringUtils.isNotEmpty(instanceBeforeContext.getProcessInstanceName())) {
            Expression processInstanceNameExpression = expressionManager.createExpression(instanceBeforeContext.getProcessInstanceName());
            processInstanceName = processInstanceNameExpression.getValue(subProcessInstance).toString();
            subProcessInstance.setName(processInstanceName);
        }

        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, subProcessInstance));
        }
        
        if (processEngineConfiguration.isEnableEntityLinks()) {
            EntityLinkUtil.copyExistingEntityLinks(execution.getProcessInstanceId(), subProcessInstance.getId(), ScopeTypes.BPMN);
            EntityLinkUtil.createNewEntityLink(execution.getProcessInstanceId(), subProcessInstance.getId(), ScopeTypes.BPMN);
        }

        if (StringUtils.isNotEmpty(callActivity.getProcessInstanceIdVariableName())) {
            Expression expression = expressionManager.createExpression(callActivity.getProcessInstanceIdVariableName());
            string idVariableName = (string) expression.getValue(execution);
            if (StringUtils.isNotEmpty(idVariableName)) {
                execution.setVariable(idVariableName, subProcessInstance.getId());
            }
        }

        // Create the first execution that will visit all the process definition elements
        ExecutionEntity subProcessInitialExecution = executionEntityManager.createChildExecution(subProcessInstance);
        subProcessInitialExecution.setCurrentFlowElement(instanceBeforeContext.getInitialFlowElement());

        if (processEngineConfiguration.getStartProcessInstanceInterceptor() !is null) {
            StartSubProcessInstanceAfterContext instanceAfterContext = new StartSubProcessInstanceAfterContext(subProcessInstance, subProcessInitialExecution,
                instanceBeforeContext.getVariables(), instanceBeforeContext.getCallActivityExecution(), instanceBeforeContext.getInParameters(),
                instanceBeforeContext.getInitialFlowElement(), instanceBeforeContext.getProcess(), instanceBeforeContext.getProcessDefinition());

            processEngineConfiguration.getStartProcessInstanceInterceptor().afterStartSubProcessInstance(instanceAfterContext);
        }

        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordSubProcessInstanceStart(executionEntity, subProcessInstance);

        CommandContextUtil.getAgenda().planContinueProcessOperation(subProcessInitialExecution);

        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createProcessStartedEvent(subProcessInitialExecution, instanceBeforeContext.getVariables(), false));
        }
        
    }

    protected ProcessDefinition getProcessDefinition(DelegateExecution execution, CallActivity callActivity, ProcessEngineConfigurationImpl processEngineConfiguration) {
        ProcessDefinition processDefinition;
        switch (StringUtils.isNotEmpty(calledElementType) ? calledElementType : CALLED_ELEMENT_TYPE_KEY) {
            case CALLED_ELEMENT_TYPE_ID:
                processDefinition = getProcessDefinitionById(execution, processEngineConfiguration);
                break;
            case CALLED_ELEMENT_TYPE_KEY:
                processDefinition = getProcessDefinitionByKey(execution, callActivity.isSameDeployment(), processEngineConfiguration);
                break;
            default:
                throw new FlowableException("Unrecognized calledElementType [" + calledElementType + "]");
        }
        return processDefinition;
    }

    @Override
    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) throws Exception {
        // only data. no control flow available on this execution.

        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();

        // copy process variables
        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        CallActivity callActivity = (CallActivity) executionEntity.getCurrentFlowElement();

        for (IOParameter outParameter : callActivity.getOutParameters()) {

            Object value = null;
            if (StringUtils.isNotEmpty(outParameter.getSourceExpression())) {
                Expression expression = expressionManager.createExpression(outParameter.getSourceExpression().trim());
                value = expression.getValue(subProcessInstance);

            } else {
                value = subProcessInstance.getVariable(outParameter.getSource());
            }

            string variableName = null;
            if (StringUtils.isNotEmpty(outParameter.getTarget()))  {
                variableName = outParameter.getTarget();

            } else if (StringUtils.isNotEmpty(outParameter.getTargetExpression())) {
                Expression expression = expressionManager.createExpression(outParameter.getTargetExpression());

                Object variableNameValue = expression.getValue(subProcessInstance);
                if (variableNameValue !is null) {
                    variableName = variableNameValue.toString();
                } else {
                    LOGGER.warn("Out parameter target expression {} did not resolve to a variable name, this is most likely a programmatic error",
                        outParameter.getTargetExpression());
                }

            }

            if (callActivity.isUseLocalScopeForOutParameters()) {
                execution.setVariableLocal(variableName, value);
            } else {
                execution.setVariable(variableName, value);
            }
        }
    }

    @Override
    public void completed(DelegateExecution execution) throws Exception {
        // only control flow. no sub process instance data available
        leave(execution);
    }

    protected ProcessDefinition getProcessDefinitionById(DelegateExecution execution, ProcessEngineConfigurationImpl processEngineConfiguration) {
        return CommandContextUtil.getProcessEngineConfiguration().getDeploymentManager()
            .findDeployedProcessDefinitionById(getCalledElementValue(execution, processEngineConfiguration));
    }

    protected ProcessDefinition getProcessDefinitionByKey(DelegateExecution execution, bool isSameDeployment, ProcessEngineConfigurationImpl processEngineConfiguration) {
        string processDefinitionKey = getCalledElementValue(execution, processEngineConfiguration);
        string tenantId = execution.getTenantId();

        ProcessDefinitionEntityManager processDefinitionEntityManager = Context.getProcessEngineConfiguration().getProcessDefinitionEntityManager();
        ProcessDefinitionEntity processDefinition;

        if (isSameDeployment) {
            string deploymentId = ProcessDefinitionUtil.getProcessDefinition(execution.getProcessDefinitionId()).getDeploymentId();
            if (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
                processDefinition = processDefinitionEntityManager.findProcessDefinitionByDeploymentAndKey(deploymentId, processDefinitionKey);
            } else {
                processDefinition = processDefinitionEntityManager.findProcessDefinitionByDeploymentAndKeyAndTenantId(deploymentId, processDefinitionKey, tenantId);
            }

            if (processDefinition !is null) {
                return processDefinition;
            }
        }

        if (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
        } else {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
            if (processDefinition is null && ((this.fallbackToDefaultTenant !is null && this.fallbackToDefaultTenant) || processEngineConfiguration.isFallbackToDefaultTenant())) {

                string defaultTenant = processEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.BPMN, processDefinitionKey);
                if (StringUtils.isNotEmpty(defaultTenant)) {
                    processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(
                                    processDefinitionKey, defaultTenant);
                } else {
                    processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
                }
            }
        }

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Process definition " + processDefinitionKey + " was not found in sameDeployment["+ isSameDeployment +
                "] tenantId["+ tenantId+ "] fallbackToDefaultTenant["+ this.fallbackToDefaultTenant + "]");
        }
        return processDefinition;
    }

    protected string getCalledElementValue(DelegateExecution execution, ProcessEngineConfigurationImpl processEngineConfiguration) {
        string calledElementValue = callActivity.getCalledElement();
        if (Context.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()){
            ObjectNode taskElementProperties = BpmnOverrideContext
                    .getBpmnOverrideElementProperties(callActivity.getId(), execution.getProcessDefinitionId());
            calledElementValue = getActiveValue(callActivity.getCalledElement(), DynamicBpmnConstants.CALL_ACTIVITY_CALLED_ELEMENT, taskElementProperties);
        }
        if (StringUtils.isNotEmpty(calledElementValue) && calledElementValue.matches(EXPRESSION_REGEX)) {
            calledElementValue = (string) processEngineConfiguration.getExpressionManager().createExpression(calledElementValue).getValue(execution);
        }
        return calledElementValue;
    }

    protected Map<string, Object> processDataObjects(Collection<ValuedDataObject> dataObjects) {
        Map<string, Object> variablesMap = new HashMap<>();
        // convert data objects to process variables
        if (dataObjects !is null) {
            variablesMap = new HashMap<>(dataObjects.size());
            for (ValuedDataObject dataObject : dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }

    // Allow a subclass to override how variables are initialized.
    protected void initializeVariables(ExecutionEntity subProcessInstance, Map<string, Object> variables) {
        subProcessInstance.setVariables(variables);
    }
}
