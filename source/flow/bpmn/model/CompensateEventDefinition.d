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

module flow.bpmn.model.CompensateEventDefinition;

import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.BaseElement;
/**
 * @author Tijs Rademakers
 */
class CompensateEventDefinition : EventDefinition {
  alias setValues = BaseElement.setValues;

    protected string activityRef;
    protected bool waitForCompletion = true;

    public string getActivityRef() {
        return activityRef;
    }

    public void setActivityRef(string activityRef) {
        this.activityRef = activityRef;
    }

    public bool isWaitForCompletion() {
        return waitForCompletion;
    }

    public void setWaitForCompletion(bool waitForCompletion) {
        this.waitForCompletion = waitForCompletion;
    }

    override
    public CompensateEventDefinition clone() {
        CompensateEventDefinition clone = new CompensateEventDefinition();
        clone.setValues(this);
        return clone;
    }

    public void setValues(CompensateEventDefinition otherDefinition) {
        super.setValues(otherDefinition);
        setActivityRef(otherDefinition.getActivityRef());
        setWaitForCompletion(otherDefinition.isWaitForCompletion());
    }
}
