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
module flow.engine.impl.bpmn.data.SimpleStructureDefinition;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.engine.impl.bpmn.data.FieldBaseStructureDefinition;
import flow.engine.impl.bpmn.data.StructureInstance;
import flow.engine.impl.bpmn.data.FieldBaseStructureInstance;
import hunt.Object;
/**
 * Represents a simple in memory structure
 *
 * @author Esteban Robles Luna
 */
class SimpleStructureDefinition : FieldBaseStructureDefinition {

    protected string id;

    protected List!string fieldNames;

    //protected List<Class<?>> fieldTypes;
    protected List!TypeInfo fieldTypes;

    this(string id) {
        this.id = id;
        this.fieldNames = new ArrayList!string();
        this.fieldTypes = new ArrayList!TypeInfo();
    }

    override
    public int getFieldSize() {
        return this.fieldNames.size();
    }

    override
    public string getId() {
        return this.id;
    }

    public void setFieldName(int index, string fieldName, TypeInfo type) {
        this.growListToContain(index, this.fieldNames);
        this.growListToContain(index, this.fieldTypes);
        this.fieldNames.set(index, fieldName);
        this.fieldTypes.set(index, type);
    }

    private void growListToContain(int index, IObject lst) {
        List!string list =  cast(List!string)lst;
        if (list !is null )
        {
          if (!(list.size() - 1 >= index)) {
            for (int i = list.size(); i <= index; i++) {
              list.add(null);
            }
          }
        }

        List!TypeInfo ls = cast(List!TypeInfo)lst;
        if (ls !is null)
        {
            if (!(ls.size() - 1 >= index)) {
              for (int i = ls.size(); i <= index; i++) {
                ls.add(null);
              }
            }
        }
    }

    override
    public string getFieldNameAt(int index) {
        return this.fieldNames.get(index);
    }

    override
    TypeInfo getFieldTypeAt(int index) {
        return this.fieldTypes.get(index);
    }

    override
    public StructureInstance createInstance() {
        return new FieldBaseStructureInstance(this);
    }
}
