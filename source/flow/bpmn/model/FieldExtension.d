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

module flow.bpmn.model.FieldExtension;

import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class FieldExtension : BaseElement {


    alias setValues = BaseElement.setValues;
    protected string fieldName;
    protected string stringValue;
    protected string expression;

    this() {

    }

    public string getFieldName() {
        return fieldName;
    }

    public void setFieldName(string fieldName) {
        this.fieldName = fieldName;
    }

    public string getStringValue() {
        return stringValue;
    }

    public void setStringValue(string stringValue) {
        this.stringValue = stringValue;
    }

    public string getExpression() {
        return expression;
    }

    public void setExpression(string expression) {
        this.expression = expression;
    }

    override
    public FieldExtension clone() {
        FieldExtension clone = new FieldExtension();
        clone.setValues(this);
        return clone;
    }

    public void setValues(FieldExtension otherExtension) {
        setFieldName(otherExtension.getFieldName());
        setStringValue(otherExtension.getStringValue());
        setExpression(otherExtension.getExpression());
    }
}
