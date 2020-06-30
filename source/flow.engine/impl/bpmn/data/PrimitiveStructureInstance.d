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
module flow.engine.impl.bpmn.data.PrimitiveStructureInstance;

import flow.engine.impl.bpmn.data.StructureInstance;
import  flow.engine.impl.bpmn.data.PrimitiveStructureDefinition;
/**
 * An instance of {@link PrimitiveStructureDefinition}
 *
 * @author Esteban Robles Luna
 */
class PrimitiveStructureInstance : StructureInstance {

    protected Object primitive;
    protected PrimitiveStructureDefinition definition;

    private TypeInfo type;

    this(PrimitiveStructureDefinition definition) {
        this(definition, null);
        type = null;
    }

    this(PrimitiveStructureDefinition definition, Object primitive , TypeInfo typeStr = null)  {
        this.definition = definition;
        this.primitive = primitive;
        type  = typeStr;
    }

    public Object getPrimitive() {
        return this.primitive;
    }

    override
    public Object[] toArray() {
        Object[] rt;
        rt ~= this.primitive;
        return rt;
       // return new Object[this.primitive ];
    }

    override
    public void loadFrom(Object[] array) {
        for (int i = 0; i < array.length; i++) {
            Object object = array[i];
            if (this.definition.getPrimitiveClass() == type) {
                this.primitive = object;
                return;
            }
        }
    }
}
