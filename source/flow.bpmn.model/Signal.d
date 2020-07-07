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
module flow.bpmn.model.Signal;
import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class Signal : BaseElement {

    alias setValues = BaseElement.setValues;
    public static  string SCOPE_GLOBAL = "global";
    public static  string SCOPE_PROCESS_INSTANCE = "processInstance";

    protected string name;

    protected string _scope;

    this() {
    }

    this(string id, string name) {
        this.id = id;
        this.name = name;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getScope() {
        return _scope;
    }

    public void setScope(string s) {
        this._scope = s;
    }

    override
    public Signal clone() {
        Signal clone = new Signal();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Signal otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setScope(otherElement.getScope());
    }
}
