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

module flow.bpmn.model.InclusiveGateway;
import flow.bpmn.model.Gateway;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
/**
 * @author Tijs Rademakers
 */
class InclusiveGateway : Gateway {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Gateway.setValues;

    override
    public InclusiveGateway clone() {
        InclusiveGateway clone = new InclusiveGateway();
        clone.setValues(this);
        return clone;
    }
    override
    string getClassType()
    {
      return "inclusiveGateway";
    }

    public void setValues(InclusiveGateway otherElement) {
        super.setValues(otherElement);
    }
}
