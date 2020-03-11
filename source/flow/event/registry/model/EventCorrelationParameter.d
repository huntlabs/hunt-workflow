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

module flow.event.registry.model.EventCorrelationParameter;

import hunt.String;

/**
 * @author Joram Barrez
 */
class EventCorrelationParameter {

    protected String name;
    protected String type;

    this() {}

    this(String name, String type) {
        this.name = name;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }


    override
    public bool opEquals(Object o) {
        if (this == o) {
            return true;
        }
        if (o is null || cast(EventCorrelationParameter)o is null) {
            return false;
        }
        EventCorrelationParameter that = cast(EventCorrelationParameter) o;
        return (name.value == that.name.value) && (type.value == that.type.value);
    }

    override
    public size_t toHash() {
        return hashOf(name ~ type);
        //return Objects.hash(name, type);
    }
}
