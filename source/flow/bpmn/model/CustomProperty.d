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

module flow.bpmn.model.CustomProperty;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ComplexDataType;
import flow.bpmn.model.DataGrid;
/**
 * @author Tijs Rademakers
 */
class CustomProperty : BaseElement {

    alias setValues = BaseElement.setValues;

    protected string name;
    protected string simpleValue;
    protected ComplexDataType complexValue;

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getSimpleValue() {
        return simpleValue;
    }

    public void setSimpleValue(string simpleValue) {
        this.simpleValue = simpleValue;
    }

    public ComplexDataType getComplexValue() {
        return complexValue;
    }

    public void setComplexValue(ComplexDataType complexValue) {
        this.complexValue = complexValue;
    }

    override
    public CustomProperty clone() {
        CustomProperty clone = new CustomProperty();
        clone.setValues(this);
        return clone;
    }

    public void setValues(CustomProperty otherProperty) {
        setName(otherProperty.getName());
        setSimpleValue(otherProperty.getSimpleValue());

        DataGrid c = cast(DataGrid)(otherProperty.getComplexValue());

        if (otherProperty.getComplexValue() !is null && c !is null) {
            setComplexValue(c.clone());
        }
    }
}
