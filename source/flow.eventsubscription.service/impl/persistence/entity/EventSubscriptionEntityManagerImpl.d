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
module flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManagerImpl;


import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.Signal;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.eventsubscription.service.impl.persistence.entity.data.EventSubscriptionDataManager;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManager;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.GenericEventSubscriptionEntity;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class EventSubscriptionEntityManagerImpl
    : AbstractServiceEngineEntityManager!(EventSubscriptionServiceConfiguration, EventSubscriptionEntity, EventSubscriptionDataManager)
    , EventSubscriptionEntityManager {

    this(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration,
                    EventSubscriptionDataManager eventSubscriptionDataManager) {

        super(eventSubscriptionServiceConfiguration, eventSubscriptionDataManager);
    }


    public CompensateEventSubscriptionEntity createCompensateEventSubscription() {
        return dataManager.createCompensateEventSubscription();
    }


    public MessageEventSubscriptionEntity createMessageEventSubscription() {
        return dataManager.createMessageEventSubscription();
    }


    public SignalEventSubscriptionEntity createSignalEventSubscription() {
        return dataManager.createSignalEventSubscription();
    }


    public GenericEventSubscriptionEntity createGenericEventSubscription() {
        return dataManager.createGenericEventSubscriptionEntity();
    }


    public EventSubscription createEventSubscription(EventSubscriptionBuilder eventSubscriptionBuilder) {
        if (SignalEventSubscriptionEntity.EVENT_TYPE.equals(eventSubscriptionBuilder.getEventType())) {
            return insertSignalEvent(eventSubscriptionBuilder);

        } else if (MessageEventSubscriptionEntity.EVENT_TYPE == (eventSubscriptionBuilder.getEventType())) {
            return insertMessageEvent(eventSubscriptionBuilder);

        } else if (CompensateEventSubscriptionEntity.EVENT_TYPE == (eventSubscriptionBuilder.getEventType())) {
            return insertCompensationEvent(eventSubscriptionBuilder);

        } else {
            return insertGenericEvent(eventSubscriptionBuilder);
        }
    }


    public List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionId(string executionId) {
        return findCompensateEventSubscriptionsByExecutionIdAndActivityId(executionId, null);
    }


    public List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionIdAndActivityId(string executionId, string activityId) {
        List!EventSubscriptionEntity eventSubscriptions = findEventSubscriptionsByExecutionAndType(executionId, "compensate");
        List!CompensateEventSubscriptionEntity result = new ArrayList!CompensateEventSubscriptionEntity();
        foreach (EventSubscriptionEntity eventSubscriptionEntity ; eventSubscriptions) {
            CompensateEventSubscriptionEntity c = cast(CompensateEventSubscriptionEntity)eventSubscriptionEntity;
            if (c !is null) {
                if (activityId is null || activityId.equals(eventSubscriptionEntity.getActivityId())) {
                    result.add(c);
                }
            }
        }
        return result;
    }


    public List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(string processInstanceId, string activityId) {
        List!EventSubscriptionEntity eventSubscriptions = findEventSubscriptionsByProcessInstanceAndActivityId(processInstanceId, activityId, "compensate");
        List!CompensateEventSubscriptionEntity result = new ArrayList!CompensateEventSubscriptionEntity();
        foreach (EventSubscriptionEntity eventSubscriptionEntity ; eventSubscriptions) {
            result.add(cast(CompensateEventSubscriptionEntity) eventSubscriptionEntity);
        }
        return result;
    }


    public long findEventSubscriptionCountByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl) {
        return dataManager.findEventSubscriptionCountByQueryCriteria(eventSubscriptionQueryImpl);
    }


    public List!EventSubscription findEventSubscriptionsByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl) {
        return dataManager.findEventSubscriptionsByQueryCriteria(eventSubscriptionQueryImpl);
    }


    public List!MessageEventSubscriptionEntity findMessageEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName) {
        return dataManager.findMessageEventSubscriptionsByProcessInstanceAndEventName(processInstanceId, eventName);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByEventName(string eventName, string tenantId) {
        return dataManager.findSignalEventSubscriptionsByEventName(eventName, tenantId);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName) {
        return dataManager.findSignalEventSubscriptionsByProcessInstanceAndEventName(processInstanceId, eventName);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByScopeAndEventName(string scopeId, string scopeType, string eventName) {
        return dataManager.findSignalEventSubscriptionsByScopeAndEventName(scopeId, scopeType, eventName);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByNameAndExecution(string name, string executionId) {
        return dataManager.findSignalEventSubscriptionsByNameAndExecution(name, executionId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecutionAndType( string executionId,  string type) {
        return dataManager.findEventSubscriptionsByExecutionAndType(executionId, type);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByProcessInstanceAndActivityId(string processInstanceId, string activityId, string type) {
        return dataManager.findEventSubscriptionsByProcessInstanceAndActivityId(processInstanceId, activityId, type);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecution( string executionId) {
        return dataManager.findEventSubscriptionsByExecution(executionId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsBySubScopeId( string subScopeId) {
        return dataManager.findEventSubscriptionsBySubScopeId(subScopeId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByTypeAndProcessDefinitionId(string type, string processDefinitionId, string tenantId) {
        return dataManager.findEventSubscriptionsByTypeAndProcessDefinitionId(type, processDefinitionId, tenantId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByName(string type, string eventName, string tenantId) {
        return dataManager.findEventSubscriptionsByName(type, eventName, tenantId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByNameAndExecution(string type, string eventName, string executionId) {
        return dataManager.findEventSubscriptionsByNameAndExecution(type, eventName, executionId);
    }


    public MessageEventSubscriptionEntity findMessageStartEventSubscriptionByName(string messageName, string tenantId) {
        return dataManager.findMessageStartEventSubscriptionByName(messageName, tenantId);
    }


    public void updateEventSubscriptionTenantId(string oldTenantId, string newTenantId) {
        dataManager.updateEventSubscriptionTenantId(oldTenantId, newTenantId);
    }


    public void deleteEventSubscriptionsForProcessDefinition(string processDefinitionId) {
        dataManager.deleteEventSubscriptionsForProcessDefinition(processDefinitionId);
    }


    public void deleteEventSubscriptionsByExecutionId(string executionId) {
        dataManager.deleteEventSubscriptionsByExecutionId(executionId);
    }


    public void deleteEventSubscriptionsForScopeIdAndType(string scopeId, string scopeType) {
        dataManager.deleteEventSubscriptionsForScopeIdAndType(scopeId, scopeType);
    }


    public void deleteEventSubscriptionsForScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        dataManager.deleteEventSubscriptionsForScopeDefinitionIdAndType(scopeDefinitionId, scopeType);
    }

    protected SignalEventSubscriptionEntity insertSignalEvent(EventSubscriptionBuilder eventSubscriptionBuilder) {
        SignalEventSubscriptionEntity subscriptionEntity = createSignalEventSubscription();
        subscriptionEntity.setExecutionId(eventSubscriptionBuilder.getExecutionId());
        subscriptionEntity.setProcessInstanceId(eventSubscriptionBuilder.getProcessInstanceId());
        Signal signal = eventSubscriptionBuilder.getSignal();
        if (signal !is null) {
            subscriptionEntity.setEventName(signal.getName());
            if (signal.getScope() !is null) {
                subscriptionEntity.setConfiguration(signal.getScope());
            }
        } else {
            subscriptionEntity.setEventName(eventSubscriptionBuilder.getEventName());
        }

        subscriptionEntity.setActivityId(eventSubscriptionBuilder.getActivityId());
        subscriptionEntity.setProcessDefinitionId(eventSubscriptionBuilder.getProcessDefinitionId());
        subscriptionEntity.setSubScopeId(eventSubscriptionBuilder.getSubScopeId());
        subscriptionEntity.setScopeId(eventSubscriptionBuilder.getScopeId());
        subscriptionEntity.setScopeDefinitionId(eventSubscriptionBuilder.getScopeDefinitionId());
        subscriptionEntity.setScopeType(eventSubscriptionBuilder.getScopeType());

        if (eventSubscriptionBuilder.getTenantId() !is null) {
            subscriptionEntity.setTenantId(eventSubscriptionBuilder.getTenantId());
        }

        insert(subscriptionEntity);

        return subscriptionEntity;
    }

    protected MessageEventSubscriptionEntity insertMessageEvent(EventSubscriptionBuilder eventSubscriptionBuilder) {

        MessageEventSubscriptionEntity subscriptionEntity = createMessageEventSubscription();
        subscriptionEntity.setExecutionId(eventSubscriptionBuilder.getExecutionId());
        subscriptionEntity.setProcessInstanceId(eventSubscriptionBuilder.getProcessInstanceId());
        subscriptionEntity.setEventName(eventSubscriptionBuilder.getEventName());

        subscriptionEntity.setActivityId(eventSubscriptionBuilder.getActivityId());
        subscriptionEntity.setProcessDefinitionId(eventSubscriptionBuilder.getProcessDefinitionId());
        if (eventSubscriptionBuilder.getTenantId() !is null) {
            subscriptionEntity.setTenantId(eventSubscriptionBuilder.getTenantId());
        }

        subscriptionEntity.setConfiguration(eventSubscriptionBuilder.getConfiguration());

        insert(subscriptionEntity);

        return subscriptionEntity;
    }

    protected CompensateEventSubscriptionEntity insertCompensationEvent(EventSubscriptionBuilder eventSubscriptionBuilder) {

        CompensateEventSubscriptionEntity eventSubscription = createCompensateEventSubscription();
        eventSubscription.setExecutionId(eventSubscriptionBuilder.getExecutionId());
        eventSubscription.setProcessInstanceId(eventSubscriptionBuilder.getProcessInstanceId());
        eventSubscription.setActivityId(eventSubscriptionBuilder.getActivityId());
        if (eventSubscriptionBuilder.getTenantId() !is null) {
            eventSubscription.setTenantId(eventSubscriptionBuilder.getTenantId());
        }

        eventSubscription.setConfiguration(eventSubscriptionBuilder.getConfiguration());

        insert(eventSubscription);
        return eventSubscription;
    }

    protected GenericEventSubscriptionEntity insertGenericEvent(EventSubscriptionBuilder eventSubscriptionBuilder) {
        GenericEventSubscriptionEntity eventSubscription = createGenericEventSubscription();
        eventSubscription.setEventType(eventSubscriptionBuilder.getEventType());
        eventSubscription.setExecutionId(eventSubscriptionBuilder.getExecutionId());
        eventSubscription.setProcessInstanceId(eventSubscriptionBuilder.getProcessInstanceId());
        eventSubscription.setActivityId(eventSubscriptionBuilder.getActivityId());
        eventSubscription.setProcessDefinitionId(eventSubscriptionBuilder.getProcessDefinitionId());
        eventSubscription.setSubScopeId(eventSubscriptionBuilder.getSubScopeId());
        eventSubscription.setScopeId(eventSubscriptionBuilder.getScopeId());
        eventSubscription.setScopeDefinitionId(eventSubscriptionBuilder.getScopeDefinitionId());
        eventSubscription.setScopeType(eventSubscriptionBuilder.getScopeType());

        if (eventSubscriptionBuilder.getTenantId() !is null) {
            eventSubscription.setTenantId(eventSubscriptionBuilder.getTenantId());
        }

        eventSubscription.setConfiguration(eventSubscriptionBuilder.getConfiguration());

        insert(eventSubscription);

        return eventSubscription;
    }

    protected List!SignalEventSubscriptionEntity toSignalEventSubscriptionEntityList(List!EventSubscriptionEntity result) {
        List!SignalEventSubscriptionEntity signalEventSubscriptionEntities = new ArrayList!SignalEventSubscriptionEntity(result.size());
        foreach (EventSubscriptionEntity eventSubscriptionEntity ; result) {
            signalEventSubscriptionEntities.add(cast(SignalEventSubscriptionEntity) eventSubscriptionEntity);
        }
        return signalEventSubscriptionEntities;
    }

    protected List!MessageEventSubscriptionEntity toMessageEventSubscriptionEntityList(List!EventSubscriptionEntity result) {
        List!MessageEventSubscriptionEntity messageEventSubscriptionEntities = new ArrayList!MessageEventSubscriptionEntity(result.size());
        foreach (EventSubscriptionEntity eventSubscriptionEntity ; result) {
            messageEventSubscriptionEntities.add(cast(MessageEventSubscriptionEntity) eventSubscriptionEntity);
        }
        return messageEventSubscriptionEntities;
    }

}
