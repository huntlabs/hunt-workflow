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
module flow.eventsubscription.service.impl.EventSubscriptionBuilderImpl;

import flow.bpmn.model.Signal;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionBuilder;
import flow.eventsubscription.service.impl.EventSubscriptionServiceImpl;

class EventSubscriptionBuilderImpl : EventSubscriptionBuilder {

    protected EventSubscriptionServiceImpl eventSubscriptionService;

    protected string eventType;
    protected string eventName;
    protected Signal signal;
    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string activityId;
    protected string subScopeId;
    protected string scopeId;
    protected string scopeDefinitionId;
    protected string scopeType;
    protected string tenantId;
    protected string configuration;

    this() {

    }

    this(EventSubscriptionServiceImpl eventSubscriptionService) {
        this.eventSubscriptionService = eventSubscriptionService;
    }


    public EventSubscriptionBuilder eventType(string eventType) {
        this.eventType = eventType;
        return this;
    }


    public EventSubscriptionBuilder eventName(string eventName) {
        this.eventName = eventName;
        return this;
    }


    public EventSubscriptionBuilder signal(Signal signal) {
        this.signal = signal;
        return this;
    }


    public EventSubscriptionBuilder executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }


    public EventSubscriptionBuilder processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }


    public EventSubscriptionBuilder processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }


    public EventSubscriptionBuilder activityId(string activityId) {
        this.activityId = activityId;
        return this;
    }


    public EventSubscriptionBuilder subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }


    public EventSubscriptionBuilder scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }


    public EventSubscriptionBuilder scopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public EventSubscriptionBuilder scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }


    public EventSubscriptionBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }


    public EventSubscriptionBuilder configuration(string configuration) {
        this.configuration = configuration;
        return this;
    }


    public EventSubscription create() {
        return eventSubscriptionService.createEventSubscription(this);
    }


    public string getEventType() {
        return eventType;
    }


    public string getEventName() {
        return eventName;
    }


    public Signal getSignal() {
        return signal;
    }


    public string getExecutionId() {
        return executionId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public string getActivityId() {
        return activityId;
    }


    public string getSubScopeId() {
        return subScopeId;
    }


    public string getScopeId() {
        return scopeId;
    }


    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }


    public string getScopeType() {
        return scopeType;
    }


    public string getTenantId() {
        return tenantId;
    }


    public string getConfiguration() {
        return configuration;
    }
}
