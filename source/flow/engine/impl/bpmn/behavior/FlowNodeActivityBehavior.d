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
module flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;

import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.bpmn.behavior.BpmnActivityBehavior;
import hunt.Exceptions;
/**
 * Superclass for all 'connectable' BPMN 2.0 process elements: tasks, gateways and events. This means that any subclass can be the source or target of a sequenceflow.
 *
 * Corresponds with the notion of the 'flownode' in BPMN 2.0.
 *
 * @author Joram Barrez
 */
abstract class FlowNodeActivityBehavior : TriggerableActivityBehavior {


    protected BpmnActivityBehavior bpmnActivityBehavior ;// = new BpmnActivityBehavior();

    this()
    {
      bpmnActivityBehavior = new BpmnActivityBehavior();
    }
    /**
     * Default behaviour: just leave the activity with no extra functionality.
     */
    public void execute(DelegateExecution execution) {
        leave(execution);
    }

    /**
     * Default way of leaving a BPMN 2.0 activity: evaluate the conditions on the outgoing sequence flow and take those that evaluate to true.
     */
    public void leave(DelegateExecution execution) {
        bpmnActivityBehavior.performDefaultOutgoingBehavior(cast(ExecutionEntity) execution);
    }

    public void leaveIgnoreConditions(DelegateExecution execution) {
        bpmnActivityBehavior.performIgnoreConditionsOutgoingBehavior(cast(ExecutionEntity) execution);
    }

    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        // concrete activity behaviours that do accept signals should override this method;
        throw new FlowableException("this activity isn't waiting for a trigger");
    }

    protected string parseActivityType(FlowNode flowNode) {
        implementationMissing(false);
        return "";
        //string elementType = flowNode.getClass().getSimpleName();
        //elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        //return elementType;
    }
}
