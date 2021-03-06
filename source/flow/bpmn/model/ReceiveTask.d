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

module flow.bpmn.model.ReceiveTask;

import flow.bpmn.model.Task;
import flow.bpmn.model.ManualTask;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;

/**
 * @author Tijs Rademakers
 */
class ReceiveTask : Task {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;

    override
    public ReceiveTask clone() {
        ReceiveTask clone = new ReceiveTask();
        clone.setValues(this);
        return clone;
    }

    override
    string getClassType()
    {
      return "receiveTask";
    }

    override
    public void setValues(Activity otherElement)
    {
        super.setValues(otherElement);
    }

    public void setValues(ManualTask otherElement) {
        super.setValues(otherElement);
    }
}
