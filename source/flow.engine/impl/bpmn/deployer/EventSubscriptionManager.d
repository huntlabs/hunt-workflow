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
module flow.engine.impl.bpmn.deployer.EventSubscriptionManager;

import hunt.collection.List;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.common.api.FlowableException;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.event.MessageEventHandler;
import flow.engine.impl.event.SignalEventHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CorrelationUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.bpmn.model.Process;

/**
 * Manages event subscriptions for newly-deployed process definitions and their previous versions.
 */
class EventSubscriptionManager {

    protected void removeObsoleteMessageEventSubscriptions(ProcessDefinitionEntity previousProcessDefinition) {
        // remove all subscriptions for the previous version
        if (previousProcessDefinition !is null) {
            removeObsoleteEventSubscriptionsImpl(previousProcessDefinition, MessageEventHandler.EVENT_HANDLER_TYPE);
        }
    }

    protected void removeObsoleteSignalEventSubScription(ProcessDefinitionEntity previousProcessDefinition) {
        // remove all subscriptions for the previous version
        if (previousProcessDefinition !is null) {
            removeObsoleteEventSubscriptionsImpl(previousProcessDefinition, SignalEventHandler.EVENT_HANDLER_TYPE);
        }
    }

    protected void removeObsoleteEventRegistryEventSubScription(ProcessDefinitionEntity previousProcessDefinition) {
        // remove all subscriptions for the previous version
        if (previousProcessDefinition !is null) {
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            EventSubscriptionQueryImpl eventSubscriptionQuery = new EventSubscriptionQueryImpl(Context.getCommandContext());
            eventSubscriptionQuery.processDefinitionId(previousProcessDefinition.getId()).scopeType(ScopeTypes.BPMN);
            if (previousProcessDefinition.getTenantId() !is null && previousProcessDefinition.getTenantId().length != 0) {
                eventSubscriptionQuery.tenantId(previousProcessDefinition.getTenantId());
            }

            List!EventSubscription subscriptionsToDelete = eventSubscriptionService.findEventSubscriptionsByQueryCriteria(eventSubscriptionQuery);
            foreach (EventSubscription eventSubscription ; subscriptionsToDelete) {
                EventSubscriptionEntity eventSubscriptionEntity = cast(EventSubscriptionEntity) eventSubscription;
                eventSubscriptionService.deleteEventSubscription(eventSubscriptionEntity);
                CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscriptionEntity);
            }
        }
    }

    protected void removeObsoleteEventSubscriptionsImpl(ProcessDefinitionEntity processDefinition, string eventHandlerType) {
        // remove all subscriptions for the previous version
        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
        List!EventSubscriptionEntity subscriptionsToDelete = eventSubscriptionService
                        .findEventSubscriptionsByTypeAndProcessDefinitionId(eventHandlerType, processDefinition.getId(), processDefinition.getTenantId());

        foreach (EventSubscriptionEntity eventSubscriptionEntity ; subscriptionsToDelete) {
            eventSubscriptionService.deleteEventSubscription(eventSubscriptionEntity);
            CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscriptionEntity);
        }
    }

    protected void addEventSubscriptions(CommandContext commandContext, ProcessDefinitionEntity processDefinition, flow.bpmn.model.Process.Process process, BpmnModel bpmnModel) {
        if (process.getFlowElements() !is null && process.getFlowElements().size() != 0) {
            foreach (FlowElement element ; process.getFlowElements()) {
                if (cast(StartEvent)element !is null) {
                    StartEvent startEvent = cast(StartEvent) element;
                    if (startEvent.getEventDefinitions() !is null && startEvent.getEventDefinitions().size() != 0) {
                        EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
                        if (cast(SignalEventDefinition)eventDefinition !is null ) {
                            SignalEventDefinition signalEventDefinition = cast(SignalEventDefinition) eventDefinition;
                            insertSignalEvent(signalEventDefinition, startEvent, processDefinition, bpmnModel);

                        } else if (cast(MessageEventDefinition)eventDefinition !is null) {
                            MessageEventDefinition messageEventDefinition = cast(MessageEventDefinition) eventDefinition;
                            insertMessageEvent(messageEventDefinition, startEvent, processDefinition, bpmnModel);
                        }

                    } else {
                        if (startEvent.getExtensionElements().get(BpmnXMLConstants.ELEMENT_EVENT_TYPE) !is null) {
                            List!ExtensionElement eventTypeElements = startEvent.getExtensionElements().get(BpmnXMLConstants.ELEMENT_EVENT_TYPE);
                            if (!eventTypeElements.isEmpty()) {
                                string eventDefinitionKey = eventTypeElements.get(0).getElementText();
                                insertEventRegistryEvent(eventDefinitionKey, startEvent, processDefinition, bpmnModel);
                            }
                        }
                    }
                }
            }
        }
    }

    protected void insertSignalEvent(SignalEventDefinition signalEventDefinition, StartEvent startEvent, ProcessDefinitionEntity processDefinition, BpmnModel bpmnModel) {
        CommandContext commandContext = Context.getCommandContext();
        SignalEventSubscriptionEntity subscriptionEntity = CommandContextUtil.getEventSubscriptionService(commandContext).createSignalEventSubscription();
        Signal signal = bpmnModel.getSignal(signalEventDefinition.getSignalRef());
        if (signal !is null) {
            subscriptionEntity.setEventName(signal.getName());
        } else {
            subscriptionEntity.setEventName(signalEventDefinition.getSignalRef());
        }
        subscriptionEntity.setActivityId(startEvent.getId());
        subscriptionEntity.setProcessDefinitionId(processDefinition.getId());
        if (processDefinition.getTenantId() !is null && processDefinition.getTenantId().length != 0) {
            subscriptionEntity.setTenantId(processDefinition.getTenantId());
        }

        CommandContextUtil.getEventSubscriptionService(commandContext).insertEventSubscription(subscriptionEntity);
        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(subscriptionEntity);
    }

    protected void insertMessageEvent(MessageEventDefinition messageEventDefinition, StartEvent startEvent, ProcessDefinitionEntity processDefinition, BpmnModel bpmnModel) {
        CommandContext commandContext = Context.getCommandContext();

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        // look for subscriptions for the same name in db:
        List!EventSubscriptionEntity subscriptionsForSameMessageName = eventSubscriptionService
                .findEventSubscriptionsByName(MessageEventHandler.EVENT_HANDLER_TYPE, messageEventDefinition.getMessageRef(), processDefinition.getTenantId());

        foreach (EventSubscriptionEntity eventSubscriptionEntity ; subscriptionsForSameMessageName) {
            // throw exception only if there's already a subscription as start event
            if (eventSubscriptionEntity.getProcessInstanceId() is null ||eventSubscriptionEntity.getProcessInstanceId().length == 0) { // processInstanceId !is null or not empty -> it's a message
                                                                                                                                      // related to an execution
                // the event subscription has no instance-id, so it's a message start event
                throw new FlowableException("Cannot deploy process definition '" ~ processDefinition.getResourceName()
                        ~ "': there already is a message event subscription for the message with name '" ~ messageEventDefinition.getMessageRef() ~ "'.");
            }
        }

        MessageEventSubscriptionEntity newSubscription = eventSubscriptionService.createMessageEventSubscription();
        newSubscription.setEventName(messageEventDefinition.getMessageRef());
        newSubscription.setActivityId(startEvent.getId());
        newSubscription.setConfiguration(processDefinition.getId());
        newSubscription.setProcessDefinitionId(processDefinition.getId());

        if (processDefinition.getTenantId() !is null && processDefinition.getTenantId().length != 0) {
            newSubscription.setTenantId(processDefinition.getTenantId());
        }

        eventSubscriptionService.insertEventSubscription(newSubscription);
        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(newSubscription);
    }

    protected void insertEventRegistryEvent(string eventDefinitionKey, StartEvent startEvent, ProcessDefinitionEntity processDefinition, BpmnModel bpmnModel) {
        CommandContext commandContext = Context.getCommandContext();
        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        EventSubscriptionBuilder eventSubscriptionBuilder = eventSubscriptionService.createEventSubscriptionBuilder()
                .eventType(eventDefinitionKey)
                .activityId(startEvent.getId())
                .processDefinitionId(processDefinition.getId())
                .scopeType(ScopeTypes.BPMN)
                .configuration(CorrelationUtil.getCorrelationKey(BpmnXMLConstants.ELEMENT_EVENT_CORRELATION_PARAMETER, commandContext, startEvent, null));

        if (processDefinition.getTenantId() !is null && processDefinition.getTenantId().length != 0) {
            eventSubscriptionBuilder.tenantId(processDefinition.getTenantId());
        }

        EventSubscription eventSubscription = eventSubscriptionBuilder.create();
        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
    }

}
