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

module flow.engine.impl.bpmn.data.Data;
import flow.engine.impl.bpmn.data.ItemDefinition;
/**
 * Implementation of the BPMN 2.0 'dataInput' and 'dataOutput'
 *
 * @author Esteban Robles Luna
 */
class Data {

    protected string id;

    protected string name;

    protected ItemDefinition definition;

    this(string id, string name, ItemDefinition definition) {
        this.id = id;
        this.name = name;
        this.definition = definition;
    }

    public string getId() {
        return this.id;
    }

    public string getName() {
        return this.name;
    }

    public ItemDefinition getDefinition() {
        return this.definition;
    }
}
