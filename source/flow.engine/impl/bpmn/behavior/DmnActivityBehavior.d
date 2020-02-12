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


import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.model.FieldExtension;
import org.flowable.bpmn.model.Task;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.delegate.Expression;
import flow.common.el.ExpressionManager;
import org.flowable.dmn.api.DecisionExecutionAuditContainer;
import org.flowable.dmn.api.DmnRuleService;
import org.flowable.dmn.api.ExecuteDecisionBuilder;
import flow.engine.DynamicBpmnConstants;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.DelegateHelper;
import flow.engine.impl.bpmn.helper.DynamicPropertyUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class DmnActivityBehavior extends TaskActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected static final string EXPRESSION_DECISION_TABLE_REFERENCE_KEY = "decisionTableReferenceKey";
    protected static final string EXPRESSION_DECISION_TABLE_THROW_ERROR_FLAG = "decisionTaskThrowErrorOnNoHits";
    protected static final string EXPRESSION_DECISION_TABLE_FALLBACK_TO_DEFAULT_TENANT = "fallbackToDefaultTenant";

    protected Task task;

    public DmnActivityBehavior(Task task) {
        this.task = task;
    }

    @Override
    public void execute(DelegateExecution execution) {
        FieldExtension fieldExtension = DelegateHelper.getFlowElementField(execution, EXPRESSION_DECISION_TABLE_REFERENCE_KEY);
        if (fieldExtension == null || ((fieldExtension.getStringValue() == null || fieldExtension.getStringValue().length() == 0) &&
                (fieldExtension.getExpression() == null || fieldExtension.getExpression().length() == 0))) {

            throw new FlowableException("decisionTableReferenceKey is a required field extension for the dmn task " + task.getId());
        }

        string activeDecisionTableKey = null;
        if (fieldExtension.getExpression() != null && fieldExtension.getExpression().length() > 0) {
            activeDecisionTableKey = fieldExtension.getExpression();

        } else {
            activeDecisionTableKey = fieldExtension.getStringValue();
        }

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();

        if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(task.getId(), execution.getProcessDefinitionId());
            activeDecisionTableKey = DynamicPropertyUtil.getActiveValue(activeDecisionTableKey, DynamicBpmnConstants.DMN_TASK_DECISION_TABLE_KEY, taskElementProperties);
        }

        string finaldecisionTableKeyValue = null;
        Object decisionTableKeyValue = expressionManager.createExpression(activeDecisionTableKey).getValue(execution);
        if (decisionTableKeyValue != null) {
            if (decisionTableKeyValue instanceof string) {
                finaldecisionTableKeyValue = (string) decisionTableKeyValue;
            } else {
                throw new FlowableIllegalArgumentException("decisionTableReferenceKey expression does not resolve to a string: " + decisionTableKeyValue);
            }
        }

        if (finaldecisionTableKeyValue == null || finaldecisionTableKeyValue.length() == 0) {
            throw new FlowableIllegalArgumentException("decisionTableReferenceKey expression resolves to an empty value: " + decisionTableKeyValue);
        }

        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(execution.getProcessDefinitionId());
        Deployment deployment = CommandContextUtil.getDeploymentEntityManager().findById(processDefinition.getDeploymentId());

        DmnRuleService ruleService = CommandContextUtil.getDmnRuleService();

        ExecuteDecisionBuilder executeDecisionBuilder = ruleService.createExecuteDecisionBuilder()
            .decisionKey(finaldecisionTableKeyValue)
            .parentDeploymentId(deployment.getParentDeploymentId())
            .instanceId(execution.getProcessInstanceId())
            .executionId(execution.getId())
            .activityId(task.getId())
            .variables(execution.getVariables())
            .tenantId(execution.getTenantId());

        applyFallbackToDefaultTenant(execution, executeDecisionBuilder);

        DecisionExecutionAuditContainer decisionExecutionAuditContainer = executeDecisionBuilder.executeWithAuditTrail();

        if (decisionExecutionAuditContainer.isFailed()) {
            throw new FlowableException("DMN decision table with key " + finaldecisionTableKeyValue + " execution failed. Cause: " + decisionExecutionAuditContainer.getExceptionMessage());
        }

        /*Throw error if there were no rules hit when the flag indicates to do this.*/
        FieldExtension throwErrorFieldExtension = DelegateHelper.getFlowElementField(execution, EXPRESSION_DECISION_TABLE_THROW_ERROR_FLAG);
        if (throwErrorFieldExtension != null) {
            string throwErrorString = null;
            if (StringUtils.isNotEmpty(throwErrorFieldExtension.getStringValue())) {
                throwErrorString = throwErrorFieldExtension.getStringValue();
                
            } else if (StringUtils.isNotEmpty(throwErrorFieldExtension.getExpression())) {
                throwErrorString = throwErrorFieldExtension.getExpression();
            }
            
            if (decisionExecutionAuditContainer.getDecisionResult().isEmpty() && throwErrorString != null) {
                if ("true".equalsIgnoreCase(throwErrorString)) {
                    throw new FlowableException("DMN decision table with key " + finaldecisionTableKeyValue + " did not hit any rules for the provided input.");
                    
                } else if (!"false".equalsIgnoreCase(throwErrorString)) {
                    Expression expression = expressionManager.createExpression(throwErrorString);
                    Object expressionValue = expression.getValue(execution);
                    
                    if (expressionValue instanceof Boolean && ((Boolean) expressionValue)) {
                        throw new FlowableException("DMN decision table with key " + finaldecisionTableKeyValue + " did not hit any rules for the provided input.");
                    }
                }
            }
        }

        if (processEngineConfiguration.getDecisionTableVariableManager() != null) {
            processEngineConfiguration.getDecisionTableVariableManager().setVariablesOnExecution(decisionExecutionAuditContainer.getDecisionResult(), 
                            finaldecisionTableKeyValue, execution, processEngineConfiguration.getObjectMapper());
            
        } else {
            setVariablesOnExecution(decisionExecutionAuditContainer.getDecisionResult(), finaldecisionTableKeyValue, 
                            execution, processEngineConfiguration.getObjectMapper());
        }

        leave(execution);
    }

    protected void applyFallbackToDefaultTenant(DelegateExecution execution, ExecuteDecisionBuilder executeDecisionBuilder) {
        FieldExtension fallbackfieldExtension = DelegateHelper.getFlowElementField(execution, EXPRESSION_DECISION_TABLE_FALLBACK_TO_DEFAULT_TENANT);
        if (fallbackfieldExtension != null && ((fallbackfieldExtension.getStringValue() != null && fallbackfieldExtension.getStringValue().length() != 0))) {
            string fallbackToDefaultTenant = fallbackfieldExtension.getStringValue();
            if (StringUtils.isNotEmpty(fallbackToDefaultTenant) && Boolean.parseBoolean(fallbackToDefaultTenant)) {
                executeDecisionBuilder.fallbackToDefaultTenant();
            }
        }
    }

    protected void setVariablesOnExecution(List<Map<string, Object>> executionResult, string decisionKey, DelegateExecution execution, ObjectMapper objectMapper) {
        if (executionResult == null || executionResult.isEmpty()) {
            return;
        }

        // multiple rule results
        // put on execution as JSON array; each entry contains output id (key) and output value (value)
        if (executionResult.size() > 1) {
            ArrayNode ruleResultNode = objectMapper.createArrayNode();

            for (Map<string, Object> ruleResult : executionResult) {
                ObjectNode outputResultNode = objectMapper.createObjectNode();

                for (Map.Entry<string, Object> outputResult : ruleResult.entrySet()) {
                    outputResultNode.set(outputResult.getKey(), objectMapper.convertValue(outputResult.getValue(), JsonNode.class));
                }

                ruleResultNode.add(outputResultNode);
            }

            execution.setVariable(decisionKey, ruleResultNode);
        } else {
            // single rule result
            // put on execution output id (key) and output value (value)
            Map<string, Object> ruleResult = executionResult.get(0);

            for (Map.Entry<string, Object> outputResult : ruleResult.entrySet()) {
                execution.setVariable(outputResult.getKey(), outputResult.getValue());
            }
        }
    }
}
