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

module flow.event.registry.consumer.CorrelationKey;

import hunt.collection;

import flow.event.registry.api.runtime.EventCorrelationParameterInstance;

/**
 * A representation of a correlation key, including the
 * {@link flow.event.registry.api.runtime.EventCorrelationParameterInstance} instances
 * that were used to get to the key value.
 *
 * @author Joram Barrez
 */
class CorrelationKey {

    protected string value;
    protected Collection!EventCorrelationParameterInstance parameterInstances;

    this(string value, Collection!EventCorrelationParameterInstance parameterInstances) {
        this.value = value;
        this.parameterInstances = parameterInstances;
    }

    public string getValue() {
        return value;
    }
    public void setValue(string value) {
        this.value = value;
    }
    public Collection!EventCorrelationParameterInstance getParameterInstances() {
        return parameterInstances;
    }
    public void setParameterInstances(Collection!EventCorrelationParameterInstance parameterInstances) {
        this.parameterInstances = parameterInstances;
    }

    override
    public bool opEquals(Object o) {
        if (this is o) {
            return true;
        }
        if (o is null || cast(CorrelationKey)o is null) {
            return false;
        }
        CorrelationKey that = cast(CorrelationKey) o;
        return (value == that.value) && (parameterInstances == that.parameterInstances);
    }

    override
    public size_t toHash() {
        return hashOf(value); // The value is determined by the parameterInstance, so no need to use them in the hashcode
    }
}
