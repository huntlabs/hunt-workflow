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

module flow.event.registry.runtime.EventInstanceImpl;

import hunt.collection.ArrayList;
import hunt.collection;

import flow.event.registry.api.runtime.EventCorrelationParameterInstance;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.api.runtime.EventPayloadInstance;
import flow.event.registry.model.EventModel;

/**
 * @author Joram Barrez
 */
class EventInstanceImpl : EventInstance {

    protected EventModel eventModel;
    protected Collection!EventPayloadInstance payloadInstances ;//= new ArrayList<>();
    protected Collection!EventCorrelationParameterInstance correlationParameterInstances ;//= new ArrayList<>();
    protected string tenantId;

    this() {

    }

    this(EventModel eventModel,
            Collection!EventCorrelationParameterInstance correlationParameterInstances,
            Collection!EventPayloadInstance payloadInstances) {

        this.eventModel = eventModel;
        this.correlationParameterInstances = correlationParameterInstances;
        this.payloadInstances = payloadInstances;
    }

    this(EventModel eventModel,
            Collection!EventCorrelationParameterInstance correlationParameterInstances,
            Collection!EventPayloadInstance payloadInstances,
            string tenantId) {

        this.eventModel = eventModel;
        this.correlationParameterInstances = correlationParameterInstances;
        this.payloadInstances = payloadInstances;
        this.tenantId = tenantId;
    }


    public EventModel getEventModel() {
        return eventModel;
    }
    public void setEventModel(EventModel eventModel) {
        this.eventModel = eventModel;
    }

    public Collection!EventPayloadInstance getPayloadInstances() {
        return payloadInstances;
    }
    public void setPayloadInstances(Collection!EventPayloadInstance payloadInstances) {
        this.payloadInstances = payloadInstances;
    }

    public Collection!EventCorrelationParameterInstance getCorrelationParameterInstances() {
        return correlationParameterInstances;
    }
    public void setCorrelationParameterInstances(
        Collection!EventCorrelationParameterInstance correlationParameterInstances) {
        this.correlationParameterInstances = correlationParameterInstances;
    }

    public string getTenantId() {
        return tenantId;
    }
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }
}
