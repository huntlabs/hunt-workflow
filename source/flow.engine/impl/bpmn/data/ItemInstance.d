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
module flow.engine.impl.bpmn.data.ItemInstance;
import flow.engine.impl.bpmn.data.ItemDefinition;
import flow.engine.impl.bpmn.data.StructureInstance;
import flow.engine.impl.bpmn.data.FieldBaseStructureInstance;
/**
 * An instance of {@link ItemDefinition}
 *
 * @author Esteban Robles Luna
 */
class ItemInstance {

    protected ItemDefinition item;

    protected StructureInstance structureInstance;

    this(ItemDefinition item, StructureInstance structureInstance) {
        this.item = item;
        this.structureInstance = structureInstance;
    }

    public ItemDefinition getItem() {
        return this.item;
    }

    public StructureInstance getStructureInstance() {
        return this.structureInstance;
    }

    private FieldBaseStructureInstance getFieldBaseStructureInstance() {
        return cast(FieldBaseStructureInstance) this.structureInstance;
    }

    public Object getFieldValue(string fieldName) {
        return this.getFieldBaseStructureInstance().getFieldValue(fieldName);
    }

    public void setFieldValue(string fieldName, Object value) {
        this.getFieldBaseStructureInstance().setFieldValue(fieldName, value);
    }
}
