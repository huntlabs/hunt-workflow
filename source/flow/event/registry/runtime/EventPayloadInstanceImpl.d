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
module flow.event.registry.runtime.EventPayloadInstanceImpl;

import flow.event.registry.api.runtime.EventPayloadInstance;
import flow.event.registry.model.EventPayload;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
class EventPayloadInstanceImpl : EventPayloadInstance {

    protected EventPayload eventPayloadDefinition;
    protected Object value;

    this(EventPayload eventPayloadDefinition, Object value) {
        this.eventPayloadDefinition = eventPayloadDefinition;
        this.value = value;
    }


    public EventPayload getEventPayloadDefinition() {
        return eventPayloadDefinition;
    }

    public void setEventPayloadDefinition(EventPayload eventPayloadDefinition) {
        this.eventPayloadDefinition = eventPayloadDefinition;
    }


    public string getDefinitionName() {
        return eventPayloadDefinition.getName();
    }


    public string getDefinitionType() {
        return eventPayloadDefinition.getType();
    }


    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

}
