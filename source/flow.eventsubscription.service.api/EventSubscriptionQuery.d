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
module flow.eventsubscription.service.api.EventSubscriptionQuery;

import hunt.collection;
import hunt.time.LocalDateTime;

import flow.common.api.query.Query;
import flow.eventsubscription.service.api.EventSubscription;

alias Date = LocalDateTime;

/**
 * Allows programmatic querying of {@link EventSubscription}s.
 *
 * @author Tijs Rademakers
 */
interface EventSubscriptionQuery : Query!(EventSubscriptionQuery, EventSubscription) {

    /** Only select event subscriptions with the given id. **/
    EventSubscriptionQuery id(string id);

    /** Only select event subscriptions with the given type. **/
    EventSubscriptionQuery eventType(string eventType);

    /** Only select event subscriptions with the given name. **/
    EventSubscriptionQuery eventName(string eventName);

    /** Only select event subscriptions with the given execution id. **/
    EventSubscriptionQuery executionId(string executionId);

    /** Only select event subscriptions which have the given process instance id. **/
    EventSubscriptionQuery processInstanceId(string processInstanceId);

    /** Only select event subscriptions which have the given process definition id. **/
    EventSubscriptionQuery processDefinitionId(string processDefinitionId);

    /** Only select event subscriptions which have an activity with the given id. **/
    EventSubscriptionQuery activityId(string activityId);

    /** Only select event subscriptions which have a sub scope id with the given value. **/
    EventSubscriptionQuery subScopeId(string subScopeId);

    /** Only select event subscriptions which have a scope id with the given value. **/
    EventSubscriptionQuery scopeId(string scopeId);

    /** Only select event subscriptions which have a scope definition id with the given value. **/
    EventSubscriptionQuery scopeDefinitionId(string scopeDefinitionId);

    /** Only select event subscriptions which have a scope type with the given value. **/
    EventSubscriptionQuery scopeType(string scopeType);

    /** Only select event subscriptions that were created before the given start time. **/
    EventSubscriptionQuery createdBefore(Date beforeTime);

    /** Only select event subscriptions that were created after the given start time. **/
    EventSubscriptionQuery createdAfter(Date afterTime);

    /** Only select event subscriptions with the given tenant id. **/
    EventSubscriptionQuery tenantId(string tenantId);

    /** Only select event subscriptions with the given tenant id. **/
    EventSubscriptionQuery tenantIds(Collection!string tenantIds);

    /** Only select event subscriptions without a tenant id. */
    EventSubscriptionQuery withoutTenantId();

    /** Only select event subscriptions with the given configuration. **/
    EventSubscriptionQuery configuration(string configuration);

    /** Only select event subscriptions with the given configurations. **/
    EventSubscriptionQuery configurations(Collection!string configurations);

    /** Only select event subscriptions that have no configuration. **/
    EventSubscriptionQuery withoutConfiguration();

    /**
     * Begin an OR statement. Make sure you invoke the endOr() method at the end of your OR statement.
     */
    EventSubscriptionQuery or();

    /**
     * End an OR statement.
     */
    EventSubscriptionQuery endOr();

    // ordering //////////////////////////////////////////////////////////////

    /** Order by id (needs to be followed by {@link #asc()} or {@link #desc()}). */
    EventSubscriptionQuery orderById();

    /** Order by execution id (needs to be followed by {@link #asc()} or {@link #desc()}). */
    EventSubscriptionQuery orderByExecutionId();

    /** Order by process instance id (needs to be followed by {@link #asc()} or {@link #desc()}). */
    EventSubscriptionQuery orderByProcessInstanceId();

    /**
     * Order by process definition id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventSubscriptionQuery orderByProcessDefinitionId();

    /**
     * Order by create date (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventSubscriptionQuery orderByCreateDate();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventSubscriptionQuery orderByTenantId();
}
