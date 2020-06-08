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
module flow.engine.impl.bpmn.behavior.IntermediateCatchSignalEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import hunt.String;
import flow.engine.impl.bpmn.behavior.IntermediateCatchEventActivityBehavior;

class IntermediateCatchSignalEventActivityBehavior : IntermediateCatchEventActivityBehavior {

    protected SignalEventDefinition signalEventDefinition;
    protected Signal signal;

    this(SignalEventDefinition signalEventDefinition, Signal signal) {
        this.signalEventDefinition = signalEventDefinition;
        this.signal = signal;
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        string signalName = null;
        if (signalEventDefinition.getSignalRef() !is null && signalEventDefinition.getSignalRef().length != 0) {
            signalName = signalEventDefinition.getSignalRef();
        } else {
            Expression signalExpression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager()
                    .createExpression(signalEventDefinition.getSignalExpression());
            signalName = (cast(String)signalExpression.getValue(execution)).value;
        }

        EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                        .eventType(SignalEventSubscriptionEntity.EVENT_TYPE)
                        .eventName(signalName)
                        .signal(signal)
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
                    .dispatchEvent(FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNAL_WAITING, executionEntity.getActivityId(), signalName,
                            null, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = deleteSignalEventSubscription(execution);
        leaveIntermediateCatchEvent(executionEntity);
    }

    override
    public void eventCancelledByEventGateway(DelegateExecution execution) {
        deleteSignalEventSubscription(execution);
        CommandContextUtil.getExecutionEntityManager().deleteExecutionAndRelatedData(cast(ExecutionEntity) execution,
                DeleteReason.EVENT_BASED_GATEWAY_CANCEL, false);
    }

    protected ExecutionEntity deleteSignalEventSubscription(DelegateExecution execution) {
        ExecutionEntity executionEntity = cast (ExecutionEntity) execution;

        string eventName = null;
        if (signal !is null) {
            eventName = signal.getName();
        } else {
            eventName = signalEventDefinition.getSignalRef();
        }

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
        List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();
        foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
            if (cast(SignalEventSubscriptionEntity)eventSubscription !is null && eventSubscription.getEventName() == (eventName)) {

                eventSubscriptionService.deleteEventSubscription(eventSubscription);
                CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
            }
        }
        return executionEntity;
    }
}
