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


import java.util.HashMap;
import java.util.Map;

/**
 * An instance of {@link FieldBaseStructureDefinition}
 * 
 * @author Esteban Robles Luna
 */
class FieldBaseStructureInstance implements StructureInstance {

    protected FieldBaseStructureDefinition structureDefinition;

    protected Map<string, Object> fieldValues;

    public FieldBaseStructureInstance(FieldBaseStructureDefinition structureDefinition) {
        this.structureDefinition = structureDefinition;
        this.fieldValues = new HashMap<>();
    }

    public Object getFieldValue(string fieldName) {
        return this.fieldValues.get(fieldName);
    }

    public void setFieldValue(string fieldName, Object value) {
        this.fieldValues.put(fieldName, value);
    }

    public int getFieldSize() {
        return this.structureDefinition.getFieldSize();
    }

    public string getFieldNameAt(int index) {
        return this.structureDefinition.getFieldNameAt(index);
    }

    @Override
    public Object[] toArray() {
        int fieldSize = this.getFieldSize();
        Object[] arguments = new Object[fieldSize];
        for (int i = 0; i < fieldSize; i++) {
            string fieldName = this.getFieldNameAt(i);
            Object argument = this.getFieldValue(fieldName);
            arguments[i] = argument;
        }
        return arguments;
    }

    @Override
    public void loadFrom(Object[] array) {
        int fieldSize = this.getFieldSize();
        for (int i = 0; i < fieldSize; i++) {
            string fieldName = this.getFieldNameAt(i);
            Object fieldValue = array[i];
            this.setFieldValue(fieldName, fieldValue);
        }
    }
}
