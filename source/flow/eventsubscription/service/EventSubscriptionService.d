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

module flow.eventsubscription.service.EventSubscriptionService;

import hunt.collection.List;

import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

/**
 * Service which provides access to eventsubscriptions.
 *
 * @author Tijs Rademakers
 */
interface EventSubscriptionService {

    EventSubscriptionEntity findById(string eventSubscriptionId);

    List!EventSubscriptionEntity findEventSubscriptionsByName(string type, string eventName, string tenantId);

    List!EventSubscriptionEntity findEventSubscriptionsByExecution(string executionId);

    List!EventSubscriptionEntity findEventSubscriptionsByNameAndExecution(string type, string eventName, string executionId);

    List!EventSubscriptionEntity findEventSubscriptionsBySubScopeId(string subScopeId);

    List!EventSubscriptionEntity findEventSubscriptionsByProcessInstanceAndActivityId(string processInstanceId, string activityId, string type);

    List!EventSubscriptionEntity findEventSubscriptionsByTypeAndProcessDefinitionId(string type, string processDefinitionId, string tenantId);

    List!EventSubscriptionEntity findEventSubscriptionsByExecutionAndType(string executionId, string type);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByScopeAndEventName(string scopeId, string scopeType, string eventName);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByEventName(string eventName, string tenantId);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByNameAndExecution(string eventName, string executionId);

    List!MessageEventSubscriptionEntity findMessageEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName);

    MessageEventSubscriptionEntity findMessageStartEventSubscriptionByName(string eventName, string tenantId);

    List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionId(string executionId);

    List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(string processInstanceId, string activityId);

    List!EventSubscription findEventSubscriptionsByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQuery);

    SignalEventSubscriptionEntity createSignalEventSubscription();

    MessageEventSubscriptionEntity createMessageEventSubscription();

    EventSubscriptionBuilder createEventSubscriptionBuilder();

    void insertEventSubscription(EventSubscriptionEntity eventSubscription);

    void updateEventSubscriptionTenantId(string oldTenantId, string newTenantId);

    void updateEventSubscription(EventSubscriptionEntity eventSubscription);

    void deleteEventSubscription(EventSubscriptionEntity eventSubscription);

    void deleteEventSubscriptionsByExecutionId(string executionId);

    void deleteEventSubscriptionsForScopeIdAndType(string scopeId, string scopeType);

    void deleteEventSubscriptionsForProcessDefinition(string processDefinitionId);

    void deleteEventSubscriptionsForScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

}
