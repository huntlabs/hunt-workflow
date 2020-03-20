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

module flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

import hunt.time.LocalDateTime;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.eventsubscription.service.api.EventSubscription;

alias Date =  LocalDateTime;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface EventSubscriptionEntity : EventSubscription, Entity, HasRevision {

    void setEventType(string eventType);

    void setEventName(string eventName);

    void setExecutionId(string executionId);

    void setProcessInstanceId(string processInstanceId);

    void setConfiguration(string configuration);

    void setActivityId(string activityId);

    void setCreated(Date created);

    void setProcessDefinitionId(string processDefinitionId);

    void setSubScopeId(string subScopeId);

    void setScopeId(string scopeId);

    void setScopeDefinitionId(string scopeDefinitionId);

    void setScopeType(string scopeType);

    void setTenantId(string tenantId);
}
