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
module flow.engine.impl.bpmn.data.PrimitiveStructureDefinition;

import flow.engine.impl.bpmn.data.StructureDefinition;
import flow.engine.impl.bpmn.data.StructureInstance;
import flow.engine.impl.bpmn.data.PrimitiveStructureInstance;

/**
 * Represents a structure based on a primitive class
 *
 * @author Esteban Robles Luna
 */
class PrimitiveStructureDefinition : StructureDefinition {

    protected string id;

    protected TypeInfo primitiveClass;

    this(string id, TypeInfo primitiveClass) {
        this.id = id;
        this.primitiveClass = primitiveClass;
    }

    public string getId() {
        return this.id;
    }

    TypeInfo getPrimitiveClass() {
        return primitiveClass;
    }

    public StructureInstance createInstance() {
        return new PrimitiveStructureInstance(this);
    }
}
