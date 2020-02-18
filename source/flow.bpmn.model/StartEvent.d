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
class StartEvent extends Event {

    protected string initiator;
    protected string formKey;
    protected bool isInterrupting = true;
    protected string validateFormFields;
    protected List<FormProperty> formProperties = new ArrayList<>();

    public string getInitiator() {
        return initiator;
    }

    public void setInitiator(string initiator) {
        this.initiator = initiator;
    }

    public string getFormKey() {
        return formKey;
    }

    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    public bool isInterrupting() {
        return isInterrupting;
    }

    public void setInterrupting(bool isInterrupting) {
        this.isInterrupting = isInterrupting;
    }

    public List<FormProperty> getFormProperties() {
        return formProperties;
    }

    public void setFormProperties(List<FormProperty> formProperties) {
        this.formProperties = formProperties;
    }

    public string getValidateFormFields() {
        return validateFormFields;
    }

    public void setValidateFormFields(string validateFormFields) {
        this.validateFormFields = validateFormFields;
    }

    @Override
    public StartEvent clone() {
        StartEvent clone = new StartEvent();
        clone.setValues(this);
        return clone;
    }

    public void setValues(StartEvent otherEvent) {
        super.setValues(otherEvent);
        setInitiator(otherEvent.getInitiator());
        setFormKey(otherEvent.getFormKey());
        setInterrupting(otherEvent.isInterrupting);
        setValidateFormFields(otherEvent.validateFormFields);

        formProperties = new ArrayList<>();
        if (otherEvent.getFormProperties() !is null && !otherEvent.getFormProperties().isEmpty()) {
            for (FormProperty property : otherEvent.getFormProperties()) {
                formProperties.add(property.clone());
            }
        }
    }
}
