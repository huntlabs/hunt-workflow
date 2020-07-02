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

module flow.event.registry.event.FlowableEventRegistryEvent;

import flow.event.registry.api.EventRegistryEvent;
import flow.event.registry.api.runtime.EventInstance;

/**
 * @author Joram Barrez
 */
class FlowableEventRegistryEvent : EventRegistryEvent {

    protected string type;
    protected EventInstance eventInstance;

    this(EventInstance eventInstance) {
        this.type = eventInstance.getEventModel().getKey();
        this.eventInstance = eventInstance;
    }

    public EventInstance getEventInstance() {
        return eventInstance;
    }

    public void setEventInstance(EventInstance eventInstance) {
        this.eventInstance = eventInstance;
    }

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

    public Object getEventObject() {
        return cast(Object)eventInstance;
    }
}
