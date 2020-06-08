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
module flow.engine.impl.bpmn.behavior.IntermediateCatchEventActivityBehavior;

import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Set;

import flow.bpmn.model.EventGateway;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.SequenceFlow;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;


class IntermediateCatchEventActivityBehavior : AbstractBpmnActivityBehavior {

    override
    public void execute(DelegateExecution execution) {
        // Do nothing: waitstate behavior
    }

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        leaveIntermediateCatchEvent(execution);
    }

    /**
     * Specific leave method for intermediate events: does a normal leave(), except when behind an event based gateway. In that case, the other events are cancelled (we're only supporting the
     * exclusive event based gateway type currently). and the process instance is continued through the triggered event.
     */
    public void leaveIntermediateCatchEvent(DelegateExecution execution) {
        EventGateway eventGateway = getPrecedingEventBasedGateway(execution);
        if (eventGateway !is null) {
            deleteOtherEventsRelatedToEventBasedGateway(execution, eventGateway);
        }

        leave(execution); // Normal leave
    }

    /**
     * Should be subclassed by the more specific types. For an intermediate catch without type, it's simply leaving the event.
     */
    public void eventCancelledByEventGateway(DelegateExecution execution) {
        CommandContextUtil.getExecutionEntityManager().deleteExecutionAndRelatedData(cast(ExecutionEntity) execution,
                DeleteReason.EVENT_BASED_GATEWAY_CANCEL, false);
    }

    protected EventGateway getPrecedingEventBasedGateway(DelegateExecution execution) {
        FlowElement currentFlowElement = execution.getCurrentFlowElement();
        if (cast(IntermediateCatchEvent)currentFlowElement !is null) {
            IntermediateCatchEvent intermediateCatchEvent = cast(IntermediateCatchEvent) currentFlowElement;
            List!SequenceFlow incomingSequenceFlow = intermediateCatchEvent.getIncomingFlows();

            // If behind an event based gateway, there is only one incoming sequence flow that originates from said gateway
            if (incomingSequenceFlow !is null && incomingSequenceFlow.size() == 1) {
                SequenceFlow sequenceFlow = incomingSequenceFlow.get(0);
                FlowElement sourceFlowElement = sequenceFlow.getSourceFlowElement();
                if (cast(EventGateway)sourceFlowElement !is null) {
                    return cast(EventGateway) sourceFlowElement;
                }
            }

        }
        return null;
    }

    protected void deleteOtherEventsRelatedToEventBasedGateway(DelegateExecution execution, EventGateway eventGateway) {

        // To clean up the other events behind the event based gateway, we must gather the
        // activity ids of said events and check the _sibling_ executions of the incoming execution.
        // Note that it can happen that there are multiple such execution in those activity ids,
        // (for example a parallel gw going twice to the event based gateway, kinda silly, but valid)
        // so we only take _one_ result of such a query for deletion.

        // Gather all activity ids for the events after the event based gateway that need to be destroyed
        List!SequenceFlow outgoingSequenceFlows = eventGateway.getOutgoingFlows();
        Set!string eventActivityIds = new HashSet!string(outgoingSequenceFlows.size() - 1); // -1, the event being triggered does not need to be deleted
        foreach (SequenceFlow outgoingSequenceFlow ; outgoingSequenceFlows) {
            if (outgoingSequenceFlow.getTargetFlowElement() !is null
                    && outgoingSequenceFlow.getTargetFlowElement().getId() != (execution.getCurrentActivityId())) {
                eventActivityIds.add(outgoingSequenceFlow.getTargetFlowElement().getId());
            }
        }

        if (!eventActivityIds.isEmpty()) {
            CommandContext commandContext = Context.getCommandContext();
            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

            // Find the executions
            List!ExecutionEntity executionEntities = executionEntityManager
                    .findExecutionsByParentExecutionAndActivityIds(execution.getParentId(), eventActivityIds);

            // Execute the cancel behaviour of the IntermediateCatchEvent
            foreach (ExecutionEntity executionEntity ; executionEntities) {
                if (eventActivityIds.contains(executionEntity.getActivityId()) && cast(IntermediateCatchEvent) execution.getCurrentFlowElement() !is null) {
                    IntermediateCatchEvent intermediateCatchEvent = cast(IntermediateCatchEvent) execution.getCurrentFlowElement();
                    if (cast(IntermediateCatchEventActivityBehavior) intermediateCatchEvent.getBehavior() !is null) {
                        (cast(IntermediateCatchEventActivityBehavior) intermediateCatchEvent.getBehavior()).eventCancelledByEventGateway(executionEntity);
                        eventActivityIds.remove(executionEntity.getActivityId()); // We only need to delete ONE execution at the event.
                    }
                }
            }
        }
    }

}
