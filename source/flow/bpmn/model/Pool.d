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

module flow.bpmn.model.Pool;

import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class Pool : BaseElement {

    alias setValues = BaseElement.setValues;

    protected string name;
    protected string processRef;
    protected bool executable = true;

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getProcessRef() {
        return processRef;
    }

    public void setProcessRef(string processRef) {
        this.processRef = processRef;
    }

    public bool isExecutable() {
        return this.executable;
    }

    public void setExecutable(bool executable) {
        this.executable = executable;
    }

    override
    public Pool clone() {
        Pool clone = new Pool();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Pool otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setProcessRef(otherElement.getProcessRef());
        setExecutable(otherElement.isExecutable());
    }
}
