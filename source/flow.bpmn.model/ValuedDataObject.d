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


module flow.bpmn.model.ValuedDataObject;

import flow.bpmn.model.DataObject;
/**
 * @author Lori Small
 */
abstract class ValuedDataObject : DataObject {

    protected Object value;

    public Object getValue() {
        return value;
    }

    void setValue(Object value)
    {

    }

    override
     ValuedDataObject clone()
     {

     }

    public void setValues(ValuedDataObject otherElement) {
        super.setValues(otherElement);
        if (otherElement.getValue() !is null) {
            setValue(otherElement.getValue());
        }
    }

    public string getType() {
        string structureRef = itemSubjectRef.getStructureRef();
        return structureRef.substring(structureRef.indexOf(':') + 1);
    }
//override size_t toHash() @safe nothrow
    override
     size_t toHash() {
        size_t result = 0;
        result = 31 * result + (itemSubjectRef.getStructureRef() !is null ? hashOf(itemSubjectRef.getStructureRef()) : 0);
        result = 31 * result + (id !is null ? hashOf(id) : 0);
        result = 31 * result + (name !is null ? hashOf(name) : 0);
        result = 31 * result + (value !is null ? hashOf(value) : 0);
        return result;
    }

    override
     bool opEquals(Object o) {
        if (this == o)
            return true;
        if (o is null )
            return false;

        ValuedDataObject otherObject = cast(ValuedDataObject) o;

        if (otherObject.getItemSubjectRef().getStructureRef() != (this.itemSubjectRef.getStructureRef()))
            return false;
        if (otherObject.getId() != (this.id))
            return false;
        if (otherObject.getName() != (this.name))
            return false;
        return otherObject.getValue() == (this.value.toString());
    }
}
