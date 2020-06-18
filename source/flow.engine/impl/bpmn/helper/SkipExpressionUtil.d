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
module flow.engine.impl.bpmn.helper.SkipExpressionUtil;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandContext;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
import hunt.Boolean;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

class SkipExpressionUtil {

    public static bool isSkipExpressionEnabled(string skipExpression, string activityId, DelegateExecution execution, CommandContext commandContext) {
        if (skipExpression is null) {
            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

            if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
                implementationMissing(false);
                //ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(activityId, execution.getProcessDefinitionId());
                //string overrideSkipExpression = DynamicPropertyUtil.getActiveValue(null, DynamicBpmnConstants.TASK_SKIP_EXPRESSION, taskElementProperties);
                //if (overrideSkipExpression is null) {
                //    return false;
                //}

            } else {
                return false;
            }
        }
        return checkSkipExpressionVariable(activityId, execution, commandContext);
    }

    protected static bool checkSkipExpressionVariable(string activityId, DelegateExecution execution, CommandContext commandContext) {
        if (CommandContextUtil.getProcessEngineConfiguration(commandContext).isEnableProcessDefinitionInfoCache()) {
            implementationMissing(false);
            //ObjectNode globalProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(
            //                DynamicBpmnConstants.GLOBAL_PROCESS_DEFINITION_PROPERTIES, execution.getProcessDefinitionId());
            //if (isEnableSkipExpression(globalProperties)) {
            //    return true;
            //}
        }

        string skipExpressionEnabledVariable = "_ACTIVITI_SKIP_EXPRESSION_ENABLED";
        Object isSkipExpressionEnabled = execution.getVariable(skipExpressionEnabledVariable);

        if (cast(Boolean)isSkipExpressionEnabled !is null) {
            return (cast(Boolean) isSkipExpressionEnabled).booleanValue();
        }

        skipExpressionEnabledVariable = "_FLOWABLE_SKIP_EXPRESSION_ENABLED";
        isSkipExpressionEnabled = execution.getVariable(skipExpressionEnabledVariable);

        if (isSkipExpressionEnabled is null) {
            return false;

        } else if (cast(Boolean)isSkipExpressionEnabled !is null) {
            return (cast(Boolean) isSkipExpressionEnabled).booleanValue();

        } else {
            throw new FlowableIllegalArgumentException("Skip expression variable does not resolve to a bool. ");
        }
    }

    public static bool shouldSkipFlowElement(string skipExpressionString, string activityId, DelegateExecution execution, CommandContext commandContext) {
        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager();
        Expression skipExpression = expressionManager.createExpression(resolveActiveSkipExpression(skipExpressionString, activityId,
                        execution.getProcessDefinitionId(), commandContext));

        Object value = skipExpression.getValue(execution);

        if (cast(Boolean)value !is null) {
            return (cast(Boolean) value).booleanValue();

        } else {
            throw new FlowableIllegalArgumentException("Skip expression does not resolve to a bool: " ~ skipExpression.getExpressionText());
        }
    }

    //protected static bool isEnableSkipExpression(ObjectNode globalProperties) {
    //    if (globalProperties !is null) {
    //        JsonNode overrideValueNode = globalProperties.get(DynamicBpmnConstants.ENABLE_SKIP_EXPRESSION);
    //        if (overrideValueNode !is null && !overrideValueNode.isNull() && "true".equalsIgnoreCase(overrideValueNode.asText())) {
    //            return true;
    //        }
    //    }
    //    return false;
    //}

    protected static string resolveActiveSkipExpression(string skipExpression, string activityId, string processDefinitionId, CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        string activeTaskSkipExpression = null;
        if (processEngineConfiguration.isEnableProcessDefinitionInfoCache()) {
            implementationMissing(false);
            //ObjectNode taskElementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(activityId, processDefinitionId);
            //activeTaskSkipExpression = DynamicPropertyUtil.getActiveValue(skipExpression, DynamicBpmnConstants.TASK_SKIP_EXPRESSION, taskElementProperties);
        } else {
            activeTaskSkipExpression = skipExpression;
        }

        return activeTaskSkipExpression;
    }
}
