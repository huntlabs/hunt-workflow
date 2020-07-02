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
module flow.eventsubscription.service.impl.EventSubscriptionServiceImpl;

import hunt.collection.List;
import flow.eventsubscription.service.impl.EventSubscriptionBuilderImpl;
import flow.common.service.CommonServiceImpl;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManager;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
/**
 * @author Tijs Rademakers
 */
class EventSubscriptionServiceImpl : CommonServiceImpl!EventSubscriptionServiceConfiguration , EventSubscriptionService {

    this(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
        super(eventSubscriptionServiceConfiguration);
    }


    public EventSubscriptionEntity findById(string eventSubscriptionId) {
        return getEventSubscriptionEntityManager().findById(eventSubscriptionId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByName(string type, string eventName, string tenantId) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByName(type, eventName, tenantId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecution(string executionId) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByExecution(executionId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByNameAndExecution(string type, string eventName, string executionId) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByNameAndExecution(type, eventName, executionId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsBySubScopeId(string subScopeId) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsBySubScopeId(subScopeId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByProcessInstanceAndActivityId(string processInstanceId, string activityId, string type) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByProcessInstanceAndActivityId(processInstanceId, activityId, type);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByTypeAndProcessDefinitionId(string type, string processDefinitionId, string tenantId) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByTypeAndProcessDefinitionId(type, processDefinitionId, tenantId);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecutionAndType(string executionId, string type) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByExecutionAndType(executionId, type);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName) {
        return getEventSubscriptionEntityManager().findSignalEventSubscriptionsByProcessInstanceAndEventName(processInstanceId, eventName);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByScopeAndEventName(string scopeId, string scopeType, string eventName) {
        return getEventSubscriptionEntityManager().findSignalEventSubscriptionsByScopeAndEventName(scopeId, scopeType, eventName);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByEventName(string eventName, string tenantId) {
        return getEventSubscriptionEntityManager().findSignalEventSubscriptionsByEventName(eventName, tenantId);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByNameAndExecution(string eventName, string executionId) {
        return getEventSubscriptionEntityManager().findSignalEventSubscriptionsByNameAndExecution(eventName, executionId);
    }


    public List!MessageEventSubscriptionEntity findMessageEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName) {
        return getEventSubscriptionEntityManager().findMessageEventSubscriptionsByProcessInstanceAndEventName(processInstanceId, eventName);
    }


    public MessageEventSubscriptionEntity findMessageStartEventSubscriptionByName(string eventName, string tenantId) {
        return getEventSubscriptionEntityManager().findMessageStartEventSubscriptionByName(eventName, tenantId);
    }


    public List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionId(string executionId) {
        return getEventSubscriptionEntityManager().findCompensateEventSubscriptionsByExecutionId(executionId);
    }


    public List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(string processInstanceId, string activityId) {
        return getEventSubscriptionEntityManager().findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(processInstanceId, activityId);
    }


    public List!EventSubscription findEventSubscriptionsByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQuery) {
        return getEventSubscriptionEntityManager().findEventSubscriptionsByQueryCriteria(eventSubscriptionQuery);
    }


    public SignalEventSubscriptionEntity createSignalEventSubscription() {
        return getEventSubscriptionEntityManager().createSignalEventSubscription();
    }


    public MessageEventSubscriptionEntity createMessageEventSubscription() {
        return getEventSubscriptionEntityManager().createMessageEventSubscription();
    }


    public EventSubscriptionBuilder createEventSubscriptionBuilder() {
        return new EventSubscriptionBuilderImpl(this);
    }


    public void insertEventSubscription(EventSubscriptionEntity eventSubscription) {
        getEventSubscriptionEntityManager().insert(eventSubscription);
    }


    public void updateEventSubscriptionTenantId(string oldTenantId, string newTenantId) {
        getEventSubscriptionEntityManager().updateEventSubscriptionTenantId(oldTenantId, newTenantId);
    }


    public void updateEventSubscription(EventSubscriptionEntity eventSubscription) {
        getEventSubscriptionEntityManager().update(eventSubscription);
    }


    public void deleteEventSubscription(EventSubscriptionEntity eventSubscription) {
        getEventSubscriptionEntityManager().dele(eventSubscription);
    }


    public void deleteEventSubscriptionsByExecutionId(string executionId) {
        getEventSubscriptionEntityManager().deleteEventSubscriptionsByExecutionId(executionId);
    }


    public void deleteEventSubscriptionsForScopeIdAndType(string scopeId, string scopeType) {
        getEventSubscriptionEntityManager().deleteEventSubscriptionsForScopeIdAndType(scopeId, scopeType);
    }


    public void deleteEventSubscriptionsForProcessDefinition(string processDefinitionId) {
        getEventSubscriptionEntityManager().deleteEventSubscriptionsForProcessDefinition(processDefinitionId);
    }


    public void deleteEventSubscriptionsForScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        getEventSubscriptionEntityManager().deleteEventSubscriptionsForScopeDefinitionIdAndType(scopeDefinitionId, scopeType);
    }

    public EventSubscription createEventSubscription(EventSubscriptionBuilder builder) {
        return getEventSubscriptionEntityManager().createEventSubscription(builder);
    }

    public EventSubscriptionEntityManager getEventSubscriptionEntityManager() {
        return configuration.getEventSubscriptionEntityManager();
    }
}
