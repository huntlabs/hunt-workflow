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



import hunt.collection.HashMap;
import hunt.collection.Map;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.IOParameter;
import flow.common.api.FlowableException;
import flow.common.api.constant.ReferenceTypes;
import flow.common.api.deleg.Expression;
import flow.common.api.scop.ScopeTypes;
import flow.common.api.variable.VariableContainer;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmmn.CaseInstanceService;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EntityLinkUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Start a CMMN case with the case service task
 *
 * @author Tijs Rademakers
 */
class CaseTaskActivityBehavior extends AbstractBpmnActivityBehavior implements SubProcessActivityBehavior {

    private static final Logger LOGGER = LoggerFactory.getLogger(CaseTaskActivityBehavior.class);

    private static final long serialVersionUID = 1L;

    @Override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        CaseServiceTask caseServiceTask = (CaseServiceTask) executionEntity.getCurrentFlowElement();

        CommandContext commandContext = CommandContextUtil.getCommandContext();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();
        CaseInstanceService caseInstanceService = processEngineConfiguration.getCaseInstanceService();

        if (caseInstanceService is null) {
            throw new FlowableException("To use the case service task a CaseInstanceService implementation needs to be available in the process engine configuration");
        }

        string businessKey = null;
        if (!StringUtils.isEmpty(caseServiceTask.getBusinessKey())) {
            Expression expression = expressionManager.createExpression(caseServiceTask.getBusinessKey());
            businessKey = expression.getValue(execution).toString();

        } else if (caseServiceTask.isInheritBusinessKey()) {
            ExecutionEntity processInstance = executionEntityManager.findById(execution.getProcessInstanceId());
            businessKey = processInstance.getBusinessKey();
        }

        string caseInstanceName = null;
        if (StringUtils.isNotEmpty(caseServiceTask.getCaseInstanceName())) {
            Expression caseInstanceNameExpression = expressionManager.createExpression(caseServiceTask.getCaseInstanceName());
            caseInstanceName = caseInstanceNameExpression.getValue(execution).toString();
        }

        Map!(string, Object) inParameters = new HashMap<>();

        // copy process variables
        for (IOParameter inParameter : caseServiceTask.getInParameters()) {

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

            inParameters.put(variableName, value);
        }

        string caseInstanceId = caseInstanceService.generateNewCaseInstanceId();

        if (StringUtils.isNotEmpty(caseServiceTask.getCaseInstanceIdVariableName())) {
            Expression expression = expressionManager.createExpression(caseServiceTask.getCaseInstanceIdVariableName());
            string idVariableName = (string) expression.getValue(execution);
            if (StringUtils.isNotEmpty(idVariableName)) {
                execution.setVariable(idVariableName, caseInstanceId);
            }
        }

        if (processEngineConfiguration.isEnableEntityLinks()) {
            EntityLinkUtil.copyExistingEntityLinks(execution.getProcessInstanceId(), caseInstanceId, ScopeTypes.CMMN);
            EntityLinkUtil.createNewEntityLink(execution.getProcessInstanceId(), caseInstanceId, ScopeTypes.CMMN);
        }

        string caseDefinitionKey = getCaseDefinitionKey(caseServiceTask.getCaseDefinitionKey(), execution, expressionManager);

        caseInstanceService.startCaseInstanceByKey(caseDefinitionKey, caseInstanceId,
                        caseInstanceName, businessKey, execution.getId(), execution.getTenantId(), caseServiceTask.isFallbackToDefaultTenant(), inParameters);

        // Bidirectional storing of reference to avoid queries later on
        executionEntity.setReferenceId(caseInstanceId);
        executionEntity.setReferenceType(ReferenceTypes.EXECUTION_CHILD_CASE);
    }

    protected string getCaseDefinitionKey(string caseDefinitionKeyExpression, VariableContainer variableContainer, ExpressionManager expressionManager) {
        if (StringUtils.isNotEmpty(caseDefinitionKeyExpression)) {
            return (string) expressionManager.createExpression(caseDefinitionKeyExpression).getValue(variableContainer);
        } else {
            return caseDefinitionKeyExpression;
        }
    }

    @Override
    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance) throws Exception {
        // not used
    }

    @Override
    public void completed(DelegateExecution execution) throws Exception {
        // not used
    }

    public void triggerCaseTask(DelegateExecution execution, Map!(string, Object) variables) {
        execution.setVariables(variables);
        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        // Set the reference id and type to null since the execution could be reused
        executionEntity.setReferenceId(null);
        executionEntity.setReferenceType(null);
        leave(execution);
    }
}
