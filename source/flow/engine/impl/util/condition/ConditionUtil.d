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
module flow.engine.impl.util.condition.ConditionUtil;

import flow.bpmn.model.SequenceFlow;
import flow.common.api.deleg.Expression;
import flow.engine.DynamicBpmnConstants;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.Condition;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.el.UelExpressionCondition;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
import std.string;
import std.array;
import hunt.collection.Map;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.api.persistence.entity.VariableInstance;
import flow.engine.impl.persistence.entity.ExecutionEntityImpl;
import hunt.Boolean;
import hunt.logging;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ConditionUtil {

    public static bool hasTrueCondition(SequenceFlow sequenceFlow, DelegateExecution execution) {
        string conditionExpression = null;
        if (CommandContextUtil.getProcessEngineConfiguration().isEnableProcessDefinitionInfoCache()) {
            implementationMissing(false);
            //ObjectNode elementProperties = BpmnOverrideContext.getBpmnOverrideElementProperties(sequenceFlow.getId(), execution.getProcessDefinitionId());
            //conditionExpression = getActiveValue(sequenceFlow.getConditionExpression(), DynamicBpmnConstants.SEQUENCE_FLOW_CONDITION, elementProperties);
        } else {
            conditionExpression = sequenceFlow.getConditionExpression();
        }

        if (conditionExpression !is null && conditionExpression.length != 0) {
             bool reversed = (conditionExpression.indexOf("!") != -1 ? true : false);
             conditionExpression = strip(conditionExpression, "$","}");
             conditionExpression = strip(conditionExpression,"{");
             conditionExpression = strip(conditionExpression,"!");
             ExecutionEntityImpl exec = cast(ExecutionEntityImpl)execution;
             VariableScopeImpl perent =  exec.getParentVariableScope();
             if (perent is null )
             {
                return true;
             }else
             {
                Map!(string, VariableInstanceEntity) v = perent.variableInstances;
                VariableInstanceEntity entity = v.get(conditionExpression);
                if (entity is null)
                {
                    logError("no key %s" , conditionExpression);
                    return true;
                }else
                {
                    Object obj = (cast(VariableInstance)entity).getValue();
                    if (reversed)
                    {
                        return !(cast(Boolean)obj).booleanValue();
                    }else
                    {
                        return (cast(Boolean)obj).booleanValue();
                    }
                }
             }
            //Expression expression = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(conditionExpression);
            //Condition condition = new UelExpressionCondition(expression);
            //return condition.evaluate(sequenceFlow.getId(), execution);
        } else {
            return true;
        }

    }

    //protected static string getActiveValue(string originalValue, string propertyName, ObjectNode elementProperties) {
    //    string activeValue = originalValue;
    //    if (elementProperties !is null) {
    //        JsonNode overrideValueNode = elementProperties.get(propertyName);
    //        if (overrideValueNode !is null) {
    //            if (overrideValueNode.isNull()) {
    //                activeValue = null;
    //            } else {
    //                activeValue = overrideValueNode.asText();
    //            }
    //        }
    //    }
    //    return activeValue;
    //}

}
