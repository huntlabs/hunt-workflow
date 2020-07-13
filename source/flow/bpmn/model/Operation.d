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

module flow.bpmn.model.Operation;

import flow.bpmn.model.BaseElement;
import hunt.collection.ArrayList;
import hunt.collection.List;

class Operation : BaseElement {

    alias setValues = BaseElement.setValues;

    protected string name;
    protected string implementationRef;
    protected string inMessageRef;
    protected string outMessageRef;
    protected List!string errorMessageRef ;// = new ArrayList<>();

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getImplementationRef() {
        return implementationRef;
    }

    public void setImplementationRef(string implementationRef) {
        this.implementationRef = implementationRef;
    }

    public string getInMessageRef() {
        return inMessageRef;
    }

    public void setInMessageRef(string inMessageRef) {
        this.inMessageRef = inMessageRef;
    }

    public string getOutMessageRef() {
        return outMessageRef;
    }

    public void setOutMessageRef(string outMessageRef) {
        this.outMessageRef = outMessageRef;
    }

    public List!string getErrorMessageRef() {
        return errorMessageRef;
    }

    public void setErrorMessageRef(List!string errorMessageRef) {
        this.errorMessageRef = errorMessageRef;
    }

    override
    public Operation clone() {
        Operation clone = new Operation();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Operation otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setImplementationRef(otherElement.getImplementationRef());
        setInMessageRef(otherElement.getInMessageRef());
        setOutMessageRef(otherElement.getOutMessageRef());

        errorMessageRef = new ArrayList!string();
        if (otherElement.getErrorMessageRef() !is null && !otherElement.getErrorMessageRef().isEmpty()) {
            errorMessageRef.addAll(otherElement.getErrorMessageRef());
        }
    }
}
