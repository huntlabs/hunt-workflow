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


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.delegate.Expression;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.delegate.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.util.CommandContextUtil;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class SkipExpressionUtil {

    public static boolean isSkipExpressionEnabled(string skipExpression, string activityId, DelegateExecution execution, CommandContext commandContext) {
        if (skipExpression == null) {
            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
            
            if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
                ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(activityId, execution.getProcessDefinitionId());
                string overrideSkipExpression = DynamicPropertyUtil.getActiveValue(null, DynamicBpmnConstants.TASK_SKIP_EXPRESSION, taskElementProperties);
                if (overrideSkipExpression == null) {
                    return false;
                }
                
            } else {
                return false;
            }
        }
        return checkSkipExpressionVariable(activityId, execution, commandContext);
    }

    protected static boolean checkSkipExpressionVariable(string activityId, DelegateExecution execution, CommandContext commandContext) {
        if (CommandContextUtil.getProcessEngineConfiguration(commandContext).isEnableProcessDefinitionInfoCache()) {
            ObjectNode globalProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(
                            DynamicBpmnConstants.GLOBAL_PROCESS_DEFINITION_PROPERTIES, execution.getProcessDefinitionId());
            if (isEnableSkipExpression(globalProperties)) {
                return true;
            }
        }
        
        string skipExpressionEnabledVariable = "_ACTIVITI_SKIP_EXPRESSION_ENABLED";
        Object isSkipExpressionEnabled = execution.getVariable(skipExpressionEnabledVariable);

        if (isSkipExpressionEnabled instanceof Boolean) {
            return ((Boolean) isSkipExpressionEnabled).booleanValue();
        }

        skipExpressionEnabledVariable = "_FLOWABLE_SKIP_EXPRESSION_ENABLED";
        isSkipExpressionEnabled = execution.getVariable(skipExpressionEnabledVariable);

        if (isSkipExpressionEnabled == null) {
            return false;

        } else if (isSkipExpressionEnabled instanceof Boolean) {
            return ((Boolean) isSkipExpressionEnabled).booleanValue();

        } else {
            throw new FlowableIllegalArgumentException("Skip expression variable does not resolve to a boolean. " + isSkipExpressionEnabled);
        }
    }

    public static boolean shouldSkipFlowElement(string skipExpressionString, string activityId, DelegateExecution execution, CommandContext commandContext) {
        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager();
        Expression skipExpression = expressionManager.createExpression(resolveActiveSkipExpression(skipExpressionString, activityId, 
                        execution.getProcessDefinitionId(), commandContext));
        
        Object value = skipExpression.getValue(execution);

        if (value instanceof Boolean) {
            return ((Boolean) value).booleanValue();

        } else {
            throw new FlowableIllegalArgumentException("Skip expression does not resolve to a boolean: " + skipExpression.getExpressionText());
        }
    }
    
    protected static boolean isEnableSkipExpression(ObjectNode globalProperties) {
        if (globalProperties != null) {
            JsonNode overrideValueNode = globalProperties.get(DynamicBpmnConstants.ENABLE_SKIP_EXPRESSION);
            if (overrideValueNode != null && !overrideValueNode.isNull() && "true".equalsIgnoreCase(overrideValueNode.asText())) {
                return true;
            }
        }
        return false;
    }
    
    protected static string resolveActiveSkipExpression(string skipExpression, string activityId, string processDefinitionId, CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        
        string activeTaskSkipExpression = null;
        if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
            ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(activityId, processDefinitionId);
            activeTaskSkipExpression = DynamicPropertyUtil.getActiveValue(skipExpression, DynamicBpmnConstants.TASK_SKIP_EXPRESSION, taskElementProperties);
        } else {
            activeTaskSkipExpression = skipExpression;
        }
        
        return activeTaskSkipExpression;
    }
}
