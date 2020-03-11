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
module flow.event.registry.model.EventPayload;

/**
 * @author Joram Barrez
 */
class EventPayload {

    protected string name;
    protected string type;

    this() {}

    this(string name, string type) {
        this.name = name;
        this.type = type;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

}
