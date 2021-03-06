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

module flow.bpmn.model.Escalation;

import flow.bpmn.model.BaseElement;

/**
 * @author Tijs Rademakers
 */
class Escalation : BaseElement {

  alias setValues = BaseElement.setValues;

  protected string name;
    protected string escalationCode;

    this() {
    }

    this(string id, string name, string escalationCode) {
        this.id = id;
        this.name = name;
        this.escalationCode = escalationCode;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getEscalationCode() {
        return escalationCode;
    }

    public void setEscalationCode(string escalationCode) {
        this.escalationCode = escalationCode;
    }

    override
    public Escalation clone() {
        Escalation clone = new Escalation();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Escalation otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setEscalationCode(otherElement.getEscalationCode());
    }
}
