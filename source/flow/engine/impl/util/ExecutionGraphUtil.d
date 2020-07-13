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
module flow.engine.impl.util.ExecutionGraphUtil;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.Collections;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Set;

import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.ProcessDefinitionUtil;
import hunt.Exceptions;
class ExecutionGraphUtil {

    /**
     * Takes in a collection of executions belonging to the same process instance. Orders the executions in a list, first elements are the leaf, last element is the root elements.
     */
    public static List!ExecutionEntity orderFromRootToLeaf(Collection!ExecutionEntity executions) {
        List!ExecutionEntity orderedList = new ArrayList!ExecutionEntity(executions.size());

        // Root elements
        HashSet!string previousIds = new HashSet!string();
        foreach (ExecutionEntity execution ; executions) {
            if (execution.getParentId() is null || execution.getParentId().length == 0) {
                orderedList.add(execution);
                previousIds.add(execution.getId());
            }
        }

        // Non-root elements
        while (orderedList.size() < executions.size()) {
            foreach (ExecutionEntity execution ; executions) {
                if (!previousIds.contains(execution.getId()) && previousIds.contains(execution.getParentId())) {
                    orderedList.add(execution);
                    previousIds.add(execution.getId());
                }
            }
        }

        return orderedList;
    }

    public static List!ExecutionEntity orderFromLeafToRoot(Collection!ExecutionEntity executions) {
        List!ExecutionEntity orderedList = orderFromRootToLeaf(executions);
        implementationMissing(false);
        //Collections.reverse(orderedList);
        return orderedList;
    }

    /**
     * Verifies if the element with the given source identifier can reach the element with the target identifier through following sequence flow.
     */
    public static bool isReachable(string processDefinitionId, string sourceElementId, string targetElementId) {

        // Fetch source and target elements
        Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);

        FlowElement sourceFlowElement = process.getFlowElement(sourceElementId, true);
        FlowNode sourceElement = null;
        if (cast(FlowNode)sourceFlowElement !is null) {
            sourceElement = cast(FlowNode) sourceFlowElement;
        } else if (cast(SequenceFlow)sourceFlowElement !is null) {
            sourceElement = cast(FlowNode) (cast(SequenceFlow) sourceFlowElement).getTargetFlowElement();
        }

        FlowElement targetFlowElement = process.getFlowElement(targetElementId, true);
        FlowNode targetElement = null;
        if (cast(FlowNode)targetFlowElement !is null) {
            targetElement = cast(FlowNode) targetFlowElement;
        } else if (cast(SequenceFlow)targetFlowElement !is null) {
            targetElement = cast(FlowNode) (cast(SequenceFlow) targetFlowElement).getTargetFlowElement();
        }

        if (sourceElement is null) {
            throw new FlowableException("Invalid sourceElementId '" ~ sourceElementId ~ "': no element found for this id n process definition '" ~ processDefinitionId ~ "'");
        }
        if (targetElement is null) {
            throw new FlowableException("Invalid targetElementId '" ~ targetElementId ~ "': no element found for this id n process definition '" ~ processDefinitionId ~ "'");
        }

        Set!string visitedElements = new HashSet!string();
        return isReachable(process, sourceElement, targetElement, visitedElements);
    }

    public static bool isReachable(Process process, FlowNode sourceElement, FlowNode targetElement, Set!string visitedElements) {

        // Special case: start events in an event subprocess might exist as an execution and are most likely be able to reach the target
        // when the target is in the event subprocess, but should be ignored as they are not 'real' runtime executions (but rather waiting for a trigger)
        if (cast(StartEvent)sourceElement !is null && isInEventSubprocess(sourceElement)) {
            return false;
        }

        // No outgoing seq flow: could be the end of eg . the process or an embedded subprocess
        if (sourceElement.getOutgoingFlows().size() == 0) {
            visitedElements.add(sourceElement.getId());

            FlowElementsContainer parentElement = process.findParent(sourceElement);
            if (cast(SubProcess)parentElement !is null) {
                sourceElement = cast(SubProcess) parentElement;
            } else {
                return false;
            }
        }

        if (sourceElement.getId() == (targetElement.getId())) {
            return true;
        }

        // To avoid infinite looping, we must capture every node we visit
        // and check before going further in the graph if we have already
        // visited the node.
        visitedElements.add(sourceElement.getId());

        List!SequenceFlow sequenceFlows = sourceElement.getOutgoingFlows();
        if (sequenceFlows !is null && sequenceFlows.size() > 0) {
            foreach (SequenceFlow sequenceFlow ; sequenceFlows) {
                string targetRef = sequenceFlow.getTargetRef();
                FlowNode sequenceFlowTarget = cast(FlowNode) process.getFlowElement(targetRef, true);
                if (sequenceFlowTarget !is null && !visitedElements.contains(sequenceFlowTarget.getId())) {
                    bool reachable = isReachable(process, sequenceFlowTarget, targetElement, visitedElements);

                    if (reachable) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    protected static bool isInEventSubprocess(FlowNode flowNode) {
        FlowElementsContainer flowElementsContainer = flowNode.getParentContainer();
        while (flowElementsContainer !is null) {
            if (cast(EventSubProcess)flowElementsContainer !is null) {
                return true;
            }

            if (cast(FlowElement)flowElementsContainer !is null) {
                flowElementsContainer = (cast(FlowElement) flowElementsContainer).getParentContainer();
            } else {
                flowElementsContainer = null;
            }
        }
        return false;
    }

}
