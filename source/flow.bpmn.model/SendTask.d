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

/**
 * @author Tijs Rademakers
 */
class SendTask extends TaskWithFieldExtensions {

    protected string type;
    protected string implementationType;
    protected string operationRef;

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

    public string getImplementationType() {
        return implementationType;
    }

    public void setImplementationType(string implementationType) {
        this.implementationType = implementationType;
    }

    public string getOperationRef() {
        return operationRef;
    }

    public void setOperationRef(string operationRef) {
        this.operationRef = operationRef;
    }

    @Override
    public SendTask clone() {
        SendTask clone = new SendTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(SendTask otherElement) {
        super.setValues(otherElement);
        setType(otherElement.getType());
        setImplementationType(otherElement.getImplementationType());
        setOperationRef(otherElement.getOperationRef());

        fieldExtensions = new ArrayList<>();
        if (otherElement.getFieldExtensions() !is null && !otherElement.getFieldExtensions().isEmpty()) {
            for (FieldExtension extension : otherElement.getFieldExtensions()) {
                fieldExtensions.add(extension.clone());
            }
        }
    }
}
