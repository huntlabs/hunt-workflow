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

module flow.engine.impl.bpmn.behavior.CaseTaskActivityBehavior;

import hunt.collection.HashMap;
import hunt.collection.Map;

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
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import std.string;
import hunt.String;
import hunt.logging;
import hunt.Exceptions;
/**
 * Start a CMMN case with the case service task
 *
 * @author Tijs Rademakers
 */
class CaseTaskActivityBehavior : AbstractBpmnActivityBehavior , SubProcessActivityBehavior {

    override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        CaseServiceTask caseServiceTask = cast(CaseServiceTask) executionEntity.getCurrentFlowElement();

        CommandContext commandContext = CommandContextUtil.getCommandContext();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();
        CaseInstanceService caseInstanceService = processEngineConfiguration.getCaseInstanceService();

        if (caseInstanceService is null) {
            throw new FlowableException("To use the case service task a CaseInstanceService implementation needs to be available in the process engine configuration");
        }

        string businessKey = null;
        if (caseServiceTask.getBusinessKey() !is null && caseServiceTask.getBusinessKey().length != 0) {
            Expression expression = expressionManager.createExpression(caseServiceTask.getBusinessKey());
            businessKey = expression.getValue(execution).toString();

        } else if (caseServiceTask.isInheritBusinessKey()) {
            ExecutionEntity processInstance = executionEntityManager.findById(execution.getProcessInstanceId());
            businessKey = processInstance.getBusinessKey();
        }

        string caseInstanceName = null;
        if (caseServiceTask.getCaseInstanceName() !is null && caseServiceTask.getCaseInstanceName().length != 0) {
            Expression caseInstanceNameExpression = expressionManager.createExpression(caseServiceTask.getCaseInstanceName());
            caseInstanceName = caseInstanceNameExpression.getValue(execution).toString();
        }

        Map!(string, Object) inParameters = new HashMap!(string, Object);

        // copy process variables
        foreach (IOParameter inParameter ; caseServiceTask.getInParameters()) {

            Object value = null;
            if (inParameter.getSourceExpression() !is null && inParameter.getSourceExpression().length != 0) {
                Expression expression = expressionManager.createExpression(strip(inParameter.getSourceExpression()));
                value = expression.getValue(execution);

            } else {
                value = execution.getVariable(inParameter.getSource());
            }

            string variableName = null;
            if (inParameter.getTargetExpression() !is null && inParameter.getTargetExpression().length != 0) {
                Expression expression = expressionManager.createExpression(inParameter.getTargetExpression());
                Object variableNameValue = expression.getValue(execution);
                if (variableNameValue !is null) {
                    variableName = variableNameValue.toString();
                } else {
                    logWarning("In parameter target expression {%s} did not resolve to a variable name, this is most likely a programmatic error",
                        inParameter.getTargetExpression());
                }

            } else if (inParameter.getTarget() !is null && inParameter.getTarget().length != 0){
                variableName = inParameter.getTarget();

            }

            inParameters.put(variableName, value);
        }

        string caseInstanceId = caseInstanceService.generateNewCaseInstanceId();

        if (caseServiceTask.getCaseInstanceIdVariableName() !is null && caseServiceTask.getCaseInstanceIdVariableName().length != 0) {
            Expression expression = expressionManager.createExpression(caseServiceTask.getCaseInstanceIdVariableName());
            String idVariableName = cast(String) expression.getValue(execution);
            if (idVariableName !is null && idVariableName.value.length != 0) {
                execution.setVariable(idVariableName.value, new String(caseInstanceId));
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
        if (caseDefinitionKeyExpression !is null  && caseDefinitionKeyExpression.length != 0) {
            return (cast(String) expressionManager.createExpression(caseDefinitionKeyExpression).getValue(variableContainer)).value;
        } else {
            return caseDefinitionKeyExpression;
        }
    }

    public void completing(DelegateExecution execution, DelegateExecution subProcessInstance){
        // not used
    }

    public void completed(DelegateExecution execution)  {
        // not used
    }

    public void triggerCaseTask(DelegateExecution execution, Map!(string, Object) variables) {
        execution.setVariables(variables);
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        // Set the reference id and type to null since the execution could be reused
        executionEntity.setReferenceId(null);
        executionEntity.setReferenceType(null);
        leave(execution);
    }
}
