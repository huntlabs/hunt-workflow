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

module flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;

/**
 * Denotes an 'activity' in the sense of BPMN 2.0: a parent class for all tasks, subprocess and callActivity.
 *
 * @author Joram Barrez
 */
class AbstractBpmnActivityBehavior : FlowNodeActivityBehavior {


    protected MultiInstanceActivityBehavior multiInstanceActivityBehavior;

    /**
     * Subclasses that call leave() will first pass through this method, before the regular {@link FlowNodeActivityBehavior#leave(DelegateExecution)} is called. This way, we can check if the activity
     * has loop characteristics, and delegate to the behavior if this is the case.
     */
    override
    public void leave(DelegateExecution execution) {
        FlowElement currentFlowElement = execution.getCurrentFlowElement();
        Collection!BoundaryEvent boundaryEvents = findBoundaryEventsForFlowNode(execution.getProcessDefinitionId(), currentFlowElement);
        if (boundaryEvents !is null && boundaryEvents.size() != 0) {
            executeCompensateBoundaryEvents(boundaryEvents, execution);
        }
        if (!hasLoopCharacteristics()) {
            super.leave(execution);
        } else if (hasMultiInstanceCharacteristics()) {
            multiInstanceActivityBehavior.leave(execution);
        }
    }

    protected void executeCompensateBoundaryEvents(Collection!BoundaryEvent boundaryEvents, DelegateExecution execution) {

        // The parent execution becomes a scope, and a child execution is created for each of the boundary events
        foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {

            if (boundaryEvent.getEventDefinitions() is null || boundaryEvent.getEventDefinitions().isEmpty()) {
                continue;
            }

            if (cast(CompensateEventDefinition)(boundaryEvent.getEventDefinitions().get(0)) is null) {
                continue;
            }

            ExecutionEntity childExecutionEntity = CommandContextUtil.getExecutionEntityManager().createChildExecution(cast(ExecutionEntity) execution);
            childExecutionEntity.setParentId(execution.getId());
            childExecutionEntity.setCurrentFlowElement(boundaryEvent);
            childExecutionEntity.setScope(false);

            ActivityBehavior boundaryEventBehavior = (cast(ActivityBehavior) boundaryEvent.getBehavior());
            boundaryEventBehavior.execute(childExecutionEntity);
        }

    }

    protected Collection!BoundaryEvent findBoundaryEventsForFlowNode(string processDefinitionId, FlowElement flowElement) {
        Process process = getProcessDefinition(processDefinitionId);

        // This could be cached or could be done at parsing time
        List!BoundaryEvent results = new ArrayList!BoundaryEvent(1);
        Collection!BoundaryEvent boundaryEvents = process.findFlowElementsOfType!BoundaryEvent(typeid(BoundaryEvent), true);
        foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {
            if (boundaryEvent.getAttachedToRefId() !is null && boundaryEvent.getAttachedToRefId() == (flowElement.getId())) {
                results.add(boundaryEvent);
            }
        }
        return results;
    }

    protected Process getProcessDefinition(string processDefinitionId) {
        // TODO: must be extracted / cache should be accessed in another way
        return ProcessDefinitionUtil.getProcess(processDefinitionId);
    }

    protected bool hasLoopCharacteristics() {
        return hasMultiInstanceCharacteristics();
    }

    protected bool hasMultiInstanceCharacteristics() {
        return multiInstanceActivityBehavior !is null;
    }

    public MultiInstanceActivityBehavior getMultiInstanceActivityBehavior() {
        return multiInstanceActivityBehavior;
    }

    public void setMultiInstanceActivityBehavior(MultiInstanceActivityBehavior multiInstanceActivityBehavior) {
        this.multiInstanceActivityBehavior = multiInstanceActivityBehavior;
    }

}
