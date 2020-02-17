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

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.model.Signal;
import org.flowable.bpmn.model.SignalEventDefinition;
import flow.common.api.delegate.Expression;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

class IntermediateCatchSignalEventActivityBehavior extends IntermediateCatchEventActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected SignalEventDefinition signalEventDefinition;
    protected Signal signal;

    public IntermediateCatchSignalEventActivityBehavior(SignalEventDefinition signalEventDefinition, Signal signal) {
        this.signalEventDefinition = signalEventDefinition;
        this.signal = signal;
    }

    @Override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

        string signalName = null;
        if (StringUtils.isNotEmpty(signalEventDefinition.getSignalRef())) {
            signalName = signalEventDefinition.getSignalRef();
        } else {
            Expression signalExpression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager()
                    .createExpression(signalEventDefinition.getSignalExpression());
            signalName = signalExpression.getValue(execution).toString();
        }

        EventSubscriptionEntity eventSubscription = (EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
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
        if (eventDispatcher != null && eventDispatcher.isEnabled()) {
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNAL_WAITING, executionEntity.getActivityId(), signalName,
                            null, executionEntity.getId(), executionEntity.getProcessInstanceId(), executionEntity.getProcessDefinitionId()));
        }
    }

    @Override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = deleteSignalEventSubscription(execution);
        leaveIntermediateCatchEvent(executionEntity);
    }

    @Override
    public void eventCancelledByEventGateway(DelegateExecution execution) {
        deleteSignalEventSubscription(execution);
        CommandContextUtil.getExecutionEntityManager().deleteExecutionAndRelatedData((ExecutionEntity) execution,
                DeleteReason.EVENT_BASED_GATEWAY_CANCEL, false);
    }

    protected ExecutionEntity deleteSignalEventSubscription(DelegateExecution execution) {
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

        string eventName = null;
        if (signal != null) {
            eventName = signal.getName();
        } else {
            eventName = signalEventDefinition.getSignalRef();
        }

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
        List<EventSubscriptionEntity> eventSubscriptions = executionEntity.getEventSubscriptions();
        for (EventSubscriptionEntity eventSubscription : eventSubscriptions) {
            if (eventSubscription instanceof SignalEventSubscriptionEntity && eventSubscription.getEventName().equals(eventName)) {

                eventSubscriptionService.deleteEventSubscription(eventSubscription);
                CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
            }
        }
        return executionEntity;
    }
}
