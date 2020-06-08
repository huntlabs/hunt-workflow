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
module flow.engine.impl.bpmn.behavior.BoundaryMessageEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.MessageEventDefinition;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
import hunt.String;
/**
 * @author Tijs Rademakers
 */
class BoundaryMessageEventActivityBehavior : BoundaryEventActivityBehavior {


    protected MessageEventDefinition messageEventDefinition;

    this(MessageEventDefinition messageEventDefinition, bool interrupting) {
        super(interrupting);
        this.messageEventDefinition = messageEventDefinition;
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        string messageName = null;
        if (messageEventDefinition.getMessageRef() !is null && messageEventDefinition.getMessageRef().length != 0) {
            messageName = messageEventDefinition.getMessageRef();
        } else {
            Expression messageExpression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager()
                    .createExpression(messageEventDefinition.getMessageExpression());
            messageName = (cast(String) (messageExpression.getValue(execution))).value;
        }

        EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                        .eventType(MessageEventSubscriptionEntity.EVENT_TYPE)
                        .eventName(messageEventDefinition.getMessageRef())
                        .executionId(executionEntity.getId())
                        .processInstanceId(executionEntity.getProcessInstanceId())
                        .activityId(executionEntity.getCurrentActivityId())
                        .processDefinitionId(executionEntity.getProcessDefinitionId())
                        .tenantId(executionEntity.getTenantId())
                        .create();

        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
        executionEntity.getEventSubscriptions().add(eventSubscription);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createMessageEvent(FlowableEngineEventType.ACTIVITY_MESSAGE_WAITING, executionEntity.getActivityId(), messageName,
                            null, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        BoundaryEvent boundaryEvent = cast(BoundaryEvent) execution.getCurrentFlowElement();

        if (boundaryEvent.isCancelActivity()) {
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();
            foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
                if (cast(MessageEventSubscriptionEntity)eventSubscription !is null && eventSubscription.getEventName() == (messageEventDefinition.getMessageRef())) {

                    eventSubscriptionService.deleteEventSubscription(eventSubscription);
                    CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
                }
            }
        }

        super.trigger(executionEntity, triggerName, triggerData);
    }
}
