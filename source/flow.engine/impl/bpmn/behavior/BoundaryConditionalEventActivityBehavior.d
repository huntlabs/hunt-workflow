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
module flow.engine.impl.bpmn.behavior.BoundaryConditionalEventActivityBehavior;

import flow.bpmn.model.ConditionalEventDefinition;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
import hunt.Boolean;
/**
 * @author Tijs Rademakers
 */
class BoundaryConditionalEventActivityBehavior : BoundaryEventActivityBehavior {

    protected ConditionalEventDefinition conditionalEventDefinition;
    protected string conditionExpression;

    this(ConditionalEventDefinition conditionalEventDefinition, string conditionExpression, bool interrupting) {
        super(interrupting);
        this.conditionalEventDefinition = conditionalEventDefinition;
        this.conditionExpression = conditionExpression;
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_WAITING, executionEntity.getActivityId(),
                            conditionExpression, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        Expression expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(conditionExpression);
        Object result = expression.getValue(execution);
        if (result !is null && cast(Boolean)result !is null && (cast(Boolean) result).booleanValue()) {
            CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(executionEntity);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createConditionalEvent(FlowableEngineEventType.ACTIVITY_CONDITIONAL_RECEIVED, executionEntity.getActivityId(),
                                conditionExpression, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
            }

            if (interrupting) {
                executeInterruptingBehavior(executionEntity, commandContext);
            } else {
                executeNonInterruptingBehavior(executionEntity, commandContext);
            }
        }
    }
}
