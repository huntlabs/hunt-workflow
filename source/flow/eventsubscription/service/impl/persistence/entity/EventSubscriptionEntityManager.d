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
module flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityManager;

import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.GenericEventSubscriptionEntity;

/**
 * @author Joram Barrez
 */
interface EventSubscriptionEntityManager : EntityManager!EventSubscriptionEntity {

    /* Create entity */

    MessageEventSubscriptionEntity createMessageEventSubscription();

    SignalEventSubscriptionEntity createSignalEventSubscription();

    CompensateEventSubscriptionEntity createCompensateEventSubscription();

    GenericEventSubscriptionEntity createGenericEventSubscription();

    /* Create and insert */

    EventSubscription createEventSubscription(EventSubscriptionBuilder eventSubscriptionBuilder);

    /* Update */

    void updateEventSubscriptionTenantId(string oldTenantId, string newTenantId);

    /* Delete */

    void deleteEventSubscriptionsForProcessDefinition(string processDefinitionId);

    void deleteEventSubscriptionsByExecutionId(string executionId);

    void deleteEventSubscriptionsForScopeIdAndType(string scopeId, string scopeType);

    void deleteEventSubscriptionsForScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

    /* Find (generic) */

    List!EventSubscriptionEntity findEventSubscriptionsByName(string type, string eventName, string tenantId);

    List!EventSubscriptionEntity findEventSubscriptionsByNameAndExecution(string type, string eventName, string executionId);

    List!EventSubscriptionEntity findEventSubscriptionsByExecution(string executionId);

    List!EventSubscriptionEntity findEventSubscriptionsByExecutionAndType(string executionId, string type);

    List!EventSubscriptionEntity findEventSubscriptionsBySubScopeId(final string subScopeId);

    List!EventSubscriptionEntity findEventSubscriptionsByProcessInstanceAndActivityId(string processInstanceId, string activityId, string type);

    List!EventSubscriptionEntity findEventSubscriptionsByTypeAndProcessDefinitionId(string type, string processDefinitionId, string tenantId);

    List!EventSubscription findEventSubscriptionsByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl);

    long findEventSubscriptionCountByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl);

    /* Find (signal) */

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByEventName(string eventName, string tenantId);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByScopeAndEventName(string scopeId, string scopeType, string eventName);

    List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByNameAndExecution(string name, string executionId);

    /* Find (message) */

    MessageEventSubscriptionEntity findMessageStartEventSubscriptionByName(string messageName, string tenantId);

    List!MessageEventSubscriptionEntity findMessageEventSubscriptionsByProcessInstanceAndEventName(string processInstanceId, string eventName);

    /* Find (compensation) */

    List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionId(string executionId);

    List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByExecutionIdAndActivityId(string executionId, string activityId);

    List!CompensateEventSubscriptionEntity findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(string processInstanceId, string activityId);

}
