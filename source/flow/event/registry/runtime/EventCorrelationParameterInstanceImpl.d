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

module flow.event.registry.runtime.EventCorrelationParameterInstanceImpl;

import flow.event.registry.api.runtime.EventCorrelationParameterInstance;
import flow.event.registry.model.EventCorrelationParameter;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
class EventCorrelationParameterInstanceImpl : EventCorrelationParameterInstance {

    protected EventCorrelationParameter eventCorrelationParameterDefinition;
    protected Object value;

    this(
        EventCorrelationParameter eventCorrelationParameterDefinition, Object value) {
        this.eventCorrelationParameterDefinition = eventCorrelationParameterDefinition;
        this.value = value;
    }


    public EventCorrelationParameter getEventCorrelationParameterDefinition() {
        return eventCorrelationParameterDefinition;
    }

    public void setEventCorrelationParameterDefinition(EventCorrelationParameter eventCorrelationParameterDefinition) {
        this.eventCorrelationParameterDefinition = eventCorrelationParameterDefinition;
    }


    public string getDefinitionName() {
        return eventCorrelationParameterDefinition.getName();
    }


    public string getDefinitionType() {
        return eventCorrelationParameterDefinition.getType();
    }


    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    override
    public bool opEquals(Object o) {
        if (this is o) {
            return true;
        }
        if (o is null || cast(EventCorrelationParameterInstanceImpl)o is null) {
            return false;
        }
        EventCorrelationParameterInstanceImpl that = cast(EventCorrelationParameterInstanceImpl) o;
        return (eventCorrelationParameterDefinition == that.eventCorrelationParameterDefinition) ;//&& Objects.equals(value, that.value);
    }

    override
    public size_t toHash() {
        return hashOf!EventCorrelationParameter(eventCorrelationParameterDefinition);
        //return Objects.hash(eventCorrelationParameterDefinition, value);
    }
}
