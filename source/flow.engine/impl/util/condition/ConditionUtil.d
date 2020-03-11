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


import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.SequenceFlow;
import flow.common.api.deleg.Expression;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.Condition;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.el.UelExpressionCondition;
import flow.engine.impl.util.CommandContextUtil;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ConditionUtil {

    public static bool hasTrueCondition(SequenceFlow sequenceFlow, DelegateExecution execution) {
        string conditionExpression = null;
        if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
            ObjectNode elementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(sequenceFlow.getId(), execution.getProcessDefinitionId());
            conditionExpression = getActiveValue(sequenceFlow.getConditionExpression(), DynamicBpmnConstants.SEQUENCE_FLOW_CONDITION, elementProperties);
        } else {
            conditionExpression = sequenceFlow.getConditionExpression();
        }

        if (StringUtils.isNotEmpty(conditionExpression)) {

            Expression expression = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(conditionExpression);
            Condition condition = new UelExpressionCondition(expression);
            return condition.evaluate(sequenceFlow.getId(), execution);
        } else {
            return true;
        }

    }

    protected static string getActiveValue(string originalValue, string propertyName, ObjectNode elementProperties) {
        string activeValue = originalValue;
        if (elementProperties !is null) {
            JsonNode overrideValueNode = elementProperties.get(propertyName);
            if (overrideValueNode !is null) {
                if (overrideValueNode.isNull()) {
                    activeValue = null;
                } else {
                    activeValue = overrideValueNode.asText();
                }
            }
        }
        return activeValue;
    }

}
