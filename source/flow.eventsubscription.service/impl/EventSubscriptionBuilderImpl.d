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

    protected string _eventType;
    protected string _eventName;
    protected Signal _signal;
    protected string _executionId;
    protected string _processInstanceId;
    protected string _processDefinitionId;
    protected string _activityId;
    protected string _subScopeId;
    protected string _scopeId;
    protected string _scopeDefinitionId;
    protected string _scopeType;
    protected string _tenantId;
    protected string _configuration;

    this() {

    }

    this(EventSubscriptionServiceImpl eventSubscriptionService) {
        this.eventSubscriptionService = eventSubscriptionService;
    }


    public EventSubscriptionBuilder eventType(string eventType) {
        this._eventType = eventType;
        return this;
    }


    public EventSubscriptionBuilder eventName(string eventName) {
        this._eventName = eventName;
        return this;
    }


    public EventSubscriptionBuilder signal(Signal signal) {
        this._signal = signal;
        return this;
    }


    public EventSubscriptionBuilder executionId(string executionId) {
        this._executionId = executionId;
        return this;
    }


    public EventSubscriptionBuilder processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }


    public EventSubscriptionBuilder processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }


    public EventSubscriptionBuilder activityId(string activityId) {
        this._activityId = activityId;
        return this;
    }


    public EventSubscriptionBuilder subScopeId(string subScopeId) {
        this._subScopeId = subScopeId;
        return this;
    }


    public EventSubscriptionBuilder scopeId(string scopeId) {
        this._scopeId = scopeId;
        return this;
    }


    public EventSubscriptionBuilder scopeDefinitionId(string scopeDefinitionId) {
        this._scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public EventSubscriptionBuilder scopeType(string scopeType) {
        this._scopeType = scopeType;
        return this;
    }


    public EventSubscriptionBuilder tenantId(string tenantId) {
        this._tenantId = tenantId;
        return this;
    }


    public EventSubscriptionBuilder configuration(string configuration) {
        this._configuration = configuration;
        return this;
    }


    public EventSubscription create() {
        return eventSubscriptionService.createEventSubscription(this);
    }


    public string getEventType() {
        return _eventType;
    }


    public string getEventName() {
        return _eventName;
    }


    public Signal getSignal() {
        return _signal;
    }


    public string getExecutionId() {
        return _executionId;
    }


    public string getProcessInstanceId() {
        return _processInstanceId;
    }


    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }


    public string getActivityId() {
        return _activityId;
    }


    public string getSubScopeId() {
        return _subScopeId;
    }


    public string getScopeId() {
        return _scopeId;
    }


    public string getScopeDefinitionId() {
        return _scopeDefinitionId;
    }


    public string getScopeType() {
        return _scopeType;
    }


    public string getTenantId() {
        return _tenantId;
    }


    public string getConfiguration() {
        return _configuration;
    }
}
