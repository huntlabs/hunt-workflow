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


import java.util.ArrayList;
import java.util.List;

/**
 * @author Tijs Rademakers
 */
class FormProperty extends BaseElement {

    protected string name;
    protected string expression;
    protected string variable;
    protected string type;
    protected string defaultExpression;
    protected string datePattern;
    protected boolean readable = true;
    protected boolean writeable = true;
    protected boolean required;
    protected List<FormValue> formValues = new ArrayList<>();

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getExpression() {
        return expression;
    }

    public void setExpression(string expression) {
        this.expression = expression;
    }

    public string getVariable() {
        return variable;
    }

    public void setVariable(string variable) {
        this.variable = variable;
    }

    public string getType() {
        return type;
    }

    public string getDefaultExpression() {
        return defaultExpression;
    }

    public void setDefaultExpression(string defaultExpression) {
        this.defaultExpression = defaultExpression;
    }

    public void setType(string type) {
        this.type = type;
    }

    public string getDatePattern() {
        return datePattern;
    }

    public void setDatePattern(string datePattern) {
        this.datePattern = datePattern;
    }

    public boolean isReadable() {
        return readable;
    }

    public void setReadable(boolean readable) {
        this.readable = readable;
    }

    public boolean isWriteable() {
        return writeable;
    }

    public void setWriteable(boolean writeable) {
        this.writeable = writeable;
    }

    public boolean isRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }

    public List<FormValue> getFormValues() {
        return formValues;
    }

    public void setFormValues(List<FormValue> formValues) {
        this.formValues = formValues;
    }

    @Override
    public FormProperty clone() {
        FormProperty clone = new FormProperty();
        clone.setValues(this);
        return clone;
    }

    public void setValues(FormProperty otherProperty) {
        super.setValues(otherProperty);
        setName(otherProperty.getName());
        setExpression(otherProperty.getExpression());
        setVariable(otherProperty.getVariable());
        setType(otherProperty.getType());
        setDefaultExpression(otherProperty.getDefaultExpression());
        setDatePattern(otherProperty.getDatePattern());
        setReadable(otherProperty.isReadable());
        setWriteable(otherProperty.isWriteable());
        setRequired(otherProperty.isRequired());

        formValues = new ArrayList<>();
        if (otherProperty.getFormValues() != null && !otherProperty.getFormValues().isEmpty()) {
            for (FormValue formValue : otherProperty.getFormValues()) {
                formValues.add(formValue.clone());
            }
        }
    }
}
