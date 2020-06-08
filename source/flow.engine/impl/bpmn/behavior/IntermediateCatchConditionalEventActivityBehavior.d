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
module flow.engine.impl.bpmn.behavior.IntermediateCatchConditionalEventActivityBehavior;

import flow.bpmn.model.ConditionalEventDefinition;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.IntermediateCatchEventActivityBehavior;
import hunt.Boolean;

class IntermediateCatchConditionalEventActivityBehavior : IntermediateCatchEventActivityBehavior {

    protected ConditionalEventDefinition conditionalEventDefinition;
    protected string conditionExpression;

    this(ConditionalEventDefinition conditionalEventDefinition, string conditionExpression) {
        this.conditionalEventDefinition = conditionalEventDefinition;
        this.conditionExpression = conditionExpression;
    }

    override
    public void execute(DelegateExecution execution) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_WAITING,
                            executionEntity.getActivityId(), conditionExpression, executionEntity.getId(),
                            executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        Expression expression = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(conditionExpression);
        Object result = expression.getValue(execution);

        if (result !is null && cast(Boolean)result !is null && (cast(Boolean) result).booleanValue()) {
            ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_RECEIVED, executionEntity.getActivityId(),
                                conditionExpression, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
            }

            leaveIntermediateCatchEvent(execution);
        }
    }
}
