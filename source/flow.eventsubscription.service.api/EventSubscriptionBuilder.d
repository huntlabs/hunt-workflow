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
module flow.eventsubscription.service.api.EventSubscriptionBuilder;

import flow.bpmn.model.Signal;
import flow.eventsubscription.service.api.EventSubscription;

interface EventSubscriptionBuilder {

    EventSubscriptionBuilder eventType(string eventType);

    EventSubscriptionBuilder eventName(string eventName);

    EventSubscriptionBuilder signal(Signal signal);

    EventSubscriptionBuilder executionId(string executionId);

    EventSubscriptionBuilder processInstanceId(string processInstanceId);

    EventSubscriptionBuilder processDefinitionId(string processDefinitionId);

    EventSubscriptionBuilder activityId(string activityId);

    EventSubscriptionBuilder subScopeId(string subScopeId);

    EventSubscriptionBuilder scopeId(string scopeId);

    EventSubscriptionBuilder scopeDefinitionId(string scopeDefinitionId);

    EventSubscriptionBuilder scopeType(string scopeType);

    EventSubscriptionBuilder tenantId(string tenantId);

    EventSubscriptionBuilder configuration(string configuration);

    EventSubscription create();

    string getEventType();

    string getEventName();

    Signal getSignal();

    string getExecutionId();

    string getProcessInstanceId();

    string getProcessDefinitionId();

    string getActivityId();

    string getSubScopeId();

    string getScopeId();

    string getScopeDefinitionId();

    string getScopeType();

    string getTenantId();

    string getConfiguration();
}
