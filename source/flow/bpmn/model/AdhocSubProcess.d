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

module flow.bpmn.model.AdhocSubProcess;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;
/**
 * @author Tijs Rademakers
 */
class AdhocSubProcess : SubProcess {

    alias setValues = BaseElement.setValues;
    alias setValues = FlowElement.setValues;
    alias setValues = FlowNode.setValues;
    alias setValues = Activity.setValues;
    alias setValues = SubProcess.setValues;

    public static  string ORDERING_PARALLEL = "Parallel";
    public static  string ORDERING_SEQUENTIALL = "Sequential";

    protected string completionCondition;
    protected string ordering = "Parallel";
    protected bool cancelRemainingInstances = true;

    override
    string getClassType()
    {
      return "adhocSubProcess";
    }

    public string getCompletionCondition() {
        return completionCondition;
    }

    public void setCompletionCondition(string completionCondition) {
        this.completionCondition = completionCondition;
    }

    public string getOrdering() {
        return ordering;
    }

    public void setOrdering(string ordering) {
        this.ordering = ordering;
    }

    public bool hasParallelOrdering() {
        return ORDERING_SEQUENTIALL != ordering;
    }

    public bool hasSequentialOrdering() {
        return ORDERING_SEQUENTIALL == ordering;
    }

    public bool isCancelRemainingInstances() {
        return cancelRemainingInstances;
    }

    public void setCancelRemainingInstances(bool cancelRemainingInstances) {
        this.cancelRemainingInstances = cancelRemainingInstances;
    }
}
