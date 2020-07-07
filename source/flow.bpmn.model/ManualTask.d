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

module flow.bpmn.model.ManualTask;

import flow.bpmn.model.Task;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;

/**
 * @author Tijs Rademakers
 */
class ManualTask : Task {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;

    override
    public ManualTask clone() {
        ManualTask clone = new ManualTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(ManualTask otherElement) {
        super.setValues(otherElement);
    }
}
