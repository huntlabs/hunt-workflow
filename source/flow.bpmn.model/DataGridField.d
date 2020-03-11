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

module flow.bpmn.model.DataGridField;
import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class DataGridField : BaseElement {

    protected string name;
    protected string value;

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getValue() {
        return value;
    }

    public void setValue(string value) {
        this.value = value;
    }

    override
    public DataGridField clone() {
        DataGridField clone = new DataGridField();
        clone.setValues(this);
        return clone;
    }

    public void setValues(DataGridField otherField) {
        setName(otherField.getName());
        setValue(otherField.getValue());
    }
}
