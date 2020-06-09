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

module flow.engine.impl.bpmn.data.ClassStructureDefinition;

import flow.engine.impl.bpmn.data.FieldBaseStructureDefinition;
/**
 * Represents a structure encapsulated in a class
 *
 * @author Esteban Robles Luna
 */
class ClassStructureDefinition : FieldBaseStructureDefinition {

    protected string id;

    //protected Class<?> classStructure;
    protected TypeInfo classStructure;

    this(TypeInfo classStructure) {
        this(classStructure.toString, classStructure);
    }

    this(string id, TypeInfo classStructure) {
        this.id = id;
        this.classStructure = classStructure;
    }

    override
    public string getId() {
        return this.id;
    }

    override
    public int getFieldSize() {
        // TODO
        return 0;
    }

    override
    public string getFieldNameAt(int index) {
        // TODO
        return null;
    }

    override
    class<?> getFieldTypeAt(int index) {
        // TODO
        return null;
    }

    override
    public StructureInstance createInstance() {
        return new FieldBaseStructureInstance(this);
    }
}
