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

class Interface extends BaseElement {

    protected string name;
    protected string implementationRef;
    protected List<Operation> operations = new ArrayList<>();

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

    public List<Operation> getOperations() {
        return operations;
    }

    public void setOperations(List<Operation> operations) {
        this.operations = operations;
    }

    @Override
    interface clone() {
        Interface clone = new Interface();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Interface otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setImplementationRef(otherElement.getImplementationRef());

        operations = new ArrayList<>();
        if (otherElement.getOperations() !is null && !otherElement.getOperations().isEmpty()) {
            for (Operation operation : otherElement.getOperations()) {
                operations.add(operation.clone());
            }
        }
    }
}
