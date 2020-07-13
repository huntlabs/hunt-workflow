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

module flow.engine.impl.bpmn.behavior.CallActivityBehavior;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import std.regex;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.IOParameter;
import flow.bpmn.model.MapExceptionEntry;
import flow.bpmn.model.Process;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scop.ScopeTypes;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.context.Context;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
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
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
//import  flow.engine.impl.bpmn.helper.DynamicPropertyUtil.getActiveValue;
import  std.string;
import hunt.String;
import hunt.logging;
import hunt.Exceptions;
/**
 * Implementation of the BPMN 2.0 call activity (limited currently to calling a subprocess and not (yet) a global task).
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class CallActivityBehavior : AbstractBpmnActivityBehavior , SubProcessActivityBehavior {

    enum  string EXPRESSION_REGEX = "\\$+\\{+.+\\}";
    enum  string CALLED_ELEMENT_TYPE_KEY = "key";
    enum  string CALLED_ELEMENT_TYPE_ID = "id";

    protected CallActivity callActivity;
    protected string calledElementType;
    protected bool fallbackToDefaultTenant;
    protected List!MapExceptionEntry mapExceptions;

    this(CallActivity callActivity) {
        this.callActivity = callActivity;
        this.calledElementType = callActivity.getCalledElementType();
        this.mapExceptions = callActivity.getMapExceptions();
        this.fallbackToDefaultTenant = callActivity.getFallbackToDefaultTenant();
    }

    override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        CallActivity callActivity = cast(CallActivity) executionEntity.getCurrentFlowElement();

        CommandContext commandContext = CommandContextUtil.getCommandContext();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        ProcessDefinition processDefinition = getProcessDefinition(execution, callActivity, processEngineConfiguration);

        // Get model from cache
        Process subProcess = ProcessDefinitionUtil.getProcess(processDefinition.getId());
        if (subProcess is null) {
            throw new FlowableException("Cannot start a sub process instance. Process model " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") could not be found");
        }

        FlowElement initialFlowElement = subProcess.getInitialFlowElement();
        if (initialFlowElement is null) {
            throw new FlowableException("No start element found for process definition " ~ processDefinition.getId());
        }

        // Do not start a process instance if the process definition is suspended
        if (ProcessDefinitionUtil.isProcessDefinitionSuspended(processDefinition.getId())) {
            throw new FlowableException("Cannot start process instance. Process definition " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") is suspended");
        }

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

        string businessKey = null;
        if (callActivity.getBusinessKey().length != 0) {
            Expression expression = expressionManager.createExpression(callActivity.getBusinessKey());
            businessKey = expression.getValue(execution).toString();

        } else if (callActivity.isInheritBusinessKey()) {
            ExecutionEntity processInstance = executionEntityManager.findById(execution.getProcessInstanceId());
            businessKey = processInstance.getBusinessKey();
        }

        Map!(string, Object) variables = new HashMap!(string, Object);

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
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_CREATED, cast(Object)subProcessInstance));
        }

        // process template-defined data objects
        subProcessInstance.setVariables(processDataObjects(subProcess.getDataObjects()));

        if (instanceBeforeContext.isInheritVariables()) {
            Map!(string, Object) executionVariables = execution.getVariables();
            foreach (string key ; executionVariables.byKey()) {
                instanceBeforeContext.getVariables().put(key, executionVariables[key]);
            }
        }

        // copy process variables
        foreach (IOParameter inParameter ; instanceBeforeContext.getInParameters()) {

            Object value = null;
            if (inParameter.getSourceExpression().length != 0) {
                Expression expression = expressionManager.createExpression(strip(inParameter.getSourceExpression()));
                value = expression.getValue(execution);

            } else {
                value = execution.getVariable(inParameter.getSource());
            }

            string variableName = null;
            if (inParameter.getTargetExpression().length != 0) {
                Expression expression = expressionManager.createExpression(inParameter.getTargetExpression());
                Object variableNameValue = expression.getValue(execution);
                if (variableNameValue !is null) {
                    variableName = variableNameValue.toString();
                } else {
                    logWarning("In parameter target expression {%s} did not resolve to a variable name, this is most likely a programmatic error",
                        inParameter.getTargetExpression());
                }

            } else if (inParameter.getTarget().length != 0){
                variableName = inParameter.getTarget();
            }

            instanceBeforeContext.getVariables().put(variableName, value);
        }

        if (!instanceBeforeContext.getVariables().isEmpty()) {
            initializeVariables(subProcessInstance, instanceBeforeContext.getVariables());
        }

        // Process instance name is resolved after setting the variables on the process instance, so they can be used in the expression
        string processInstanceName = null;
        if (instanceBeforeContext.getProcessInstanceName().length != 0) {
            Expression processInstanceNameExpression = expressionManager.createExpression(instanceBeforeContext.getProcessInstanceName());
            processInstanceName = processInstanceNameExpression.getValue(subProcessInstance).toString();
            subProcessInstance.setName(processInstanceName);
        }

        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, cast(Object)subProcessInstance));
        }

        if (processEngineConfiguration.isEnableEntityLinks()) {
            EntityLinkUtil.copyExistingEntityLinks(execution.getProcessInstanceId(), subProcessInstance.getId(), ScopeTypes.BPMN);
            EntityLinkUtil.createNewEntityLink(execution.getProcessInstanceId(), subProcessInstance.getId(), ScopeTypes.BPMN);
        }

        if (callActivity.getProcessInstanceIdVariableName().length != 0) {
            Expression expression = expressionManager.createExpression(callActivity.getProcessInstanceIdVariableName());
            String idVariableName = cast(String) expression.getValue(execution);
            if (idVariableName !is null && idVariableName.value.length != 0) {
                execution.setVariable(idVariableName.value, new String(subProcessInstance.getId()));
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
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createProcessStartedEvent(cast(Object)subProcessInitialExecution, instanceBeforeContext.getVariables(), false));
        }

    }

    protected ProcessDefinition getProcessDefinition(DelegateExecution execution, CallActivity callActivity, ProcessEngineConfigurationImpl processEngineConfiguration) {
        ProcessDefinition processDefinition;
        switch (calledElementType.length != 0 ? calledElementType : CALLED_ELEMENT_TYPE_KEY) {
            case CALLED_ELEMENT_TYPE_ID:
                processDefinition = getProcessDefinitionById(execution, processEngineConfiguration);
                break;
            case CALLED_ELEMENT_TYPE_KEY:
                processDefinition = getProcessDefinitionByKey(execution, callActivity.isSameDeployment(), processEngineConfiguration);
                break;
            default:
                throw new FlowableException("Unrecognized calledElementType [" ~ calledElementType ~ "]");
        }
        return processDefinition;
    }

    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) {
        // only data. no control flow available on this execution.

        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();

        // copy process variables
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        CallActivity callActivity = cast(CallActivity) executionEntity.getCurrentFlowElement();

        foreach (IOParameter outParameter ; callActivity.getOutParameters()) {

            Object value = null;
            if (outParameter.getSourceExpression().length != 0) {
                Expression expression = expressionManager.createExpression(strip(outParameter.getSourceExpression()));
                value = expression.getValue(subProcessInstance);

            } else {
                value = subProcessInstance.getVariable(outParameter.getSource());
            }

            string variableName = null;
            if (outParameter.getTarget().length != 0)  {
                variableName = outParameter.getTarget();

            } else if (outParameter.getTargetExpression().length != 0) {
                Expression expression = expressionManager.createExpression(outParameter.getTargetExpression());

                Object variableNameValue = expression.getValue(subProcessInstance);
                if (variableNameValue !is null) {
                    variableName = variableNameValue.toString();
                } else {
                    logWarning("Out parameter target expression {%s} did not resolve to a variable name, this is most likely a programmatic error",
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

    public void completed(DelegateExecution execution)  {
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
            if (tenantId.length == 0 || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId)) {
                processDefinition = processDefinitionEntityManager.findProcessDefinitionByDeploymentAndKey(deploymentId, processDefinitionKey);
            } else {
                processDefinition = processDefinitionEntityManager.findProcessDefinitionByDeploymentAndKeyAndTenantId(deploymentId, processDefinitionKey, tenantId);
            }

            if (processDefinition !is null) {
                return processDefinition;
            }
        }

        if (tenantId.length == 0 || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
        } else {
            processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
            if (processDefinition is null && (this.fallbackToDefaultTenant || processEngineConfiguration.isFallbackToDefaultTenant())) {
                implementationMissing(false);
                //string defaultTenant = processEngineConfiguration.getDefaultTenantProvider().getDefaultTenant(tenantId, ScopeTypes.BPMN, processDefinitionKey);
                //if (defaultTenant.length == 0) {
                //    processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(
                //                    processDefinitionKey, defaultTenant);
                //} else {
                //    processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);
                //}
            }
        }

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Process definition " ~ processDefinitionKey ~ " was not found in sameDeployment["~
                "] tenantId[" ~ tenantId~ "] fallbackToDefaultTenant["~ "]");
        }
        return processDefinition;
    }

    protected string getCalledElementValue(DelegateExecution execution, ProcessEngineConfigurationImpl processEngineConfiguration) {


        string calledElementValue = callActivity.getCalledElement();
        if (Context.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()){
          implementationMissing(false);
            //ObjectNode taskElementProperties = BpmnOverrideContext
            //        .getBpmnOverrideElementProperties(callActivity.getId(), execution.getProcessDefinitionId());
            //calledElementValue = getActiveValue(callActivity.getCalledElement(), DynamicBpmnConstants.CALL_ACTIVITY_CALLED_ELEMENT, taskElementProperties);
        }
        if (calledElementValue.length != 0 && !matchFirst(calledElementValue,regex(EXPRESSION_REGEX)).empty) {
            calledElementValue = (cast(String)(processEngineConfiguration.getExpressionManager().createExpression(calledElementValue).getValue(execution))).value;
        }
        return calledElementValue;
    }

    protected Map!(string, Object) processDataObjects(Collection!ValuedDataObject dataObjects) {
        Map!(string, Object) variablesMap = new HashMap!(string, Object);
        // convert data objects to process variables
        if (dataObjects !is null) {
            variablesMap = new HashMap!(string, Object)(dataObjects.size());
            foreach (ValuedDataObject dataObject ; dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }

    // Allow a subclass to override how variables are initialized.
    protected void initializeVariables(ExecutionEntity subProcessInstance, Map!(string, Object) variables) {
        subProcessInstance.setVariables(variables);
    }
}
