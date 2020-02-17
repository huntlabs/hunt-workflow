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


import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.flowable.bpmn.model.EventGateway;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.IntermediateCatchEvent;
import org.flowable.bpmn.model.SequenceFlow;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;

class IntermediateCatchEventActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    @Override
    public void execute(DelegateExecution execution) {
        // Do nothing: waitstate behavior
    }

    @Override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        leaveIntermediateCatchEvent(execution);
    }

    /**
     * Specific leave method for intermediate events: does a normal leave(), except when behind an event based gateway. In that case, the other events are cancelled (we're only supporting the
     * exclusive event based gateway type currently). and the process instance is continued through the triggered event.
     */
    public void leaveIntermediateCatchEvent(DelegateExecution execution) {
        EventGateway eventGateway = getPrecedingEventBasedGateway(execution);
        if (eventGateway != null) {
            deleteOtherEventsRelatedToEventBasedGateway(execution, eventGateway);
        }

        leave(execution); // Normal leave
    }

    /**
     * Should be subclassed by the more specific types. For an intermediate catch without type, it's simply leaving the event.
     */
    public void eventCancelledByEventGateway(DelegateExecution execution) {
        CommandContextUtil.getExecutionEntityManager().deleteExecutionAndRelatedData((ExecutionEntity) execution,
                DeleteReason.EVENT_BASED_GATEWAY_CANCEL, false);
    }

    protected EventGateway getPrecedingEventBasedGateway(DelegateExecution execution) {
        FlowElement currentFlowElement = execution.getCurrentFlowElement();
        if (currentFlowElement instanceof IntermediateCatchEvent) {
            IntermediateCatchEvent intermediateCatchEvent = (IntermediateCatchEvent) currentFlowElement;
            List<SequenceFlow> incomingSequenceFlow = intermediateCatchEvent.getIncomingFlows();

            // If behind an event based gateway, there is only one incoming sequence flow that originates from said gateway
            if (incomingSequenceFlow != null && incomingSequenceFlow.size() == 1) {
                SequenceFlow sequenceFlow = incomingSequenceFlow.get(0);
                FlowElement sourceFlowElement = sequenceFlow.getSourceFlowElement();
                if (sourceFlowElement instanceof EventGateway) {
                    return (EventGateway) sourceFlowElement;
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
        List<SequenceFlow> outgoingSequenceFlows = eventGateway.getOutgoingFlows();
        Set<string> eventActivityIds = new HashSet<>(outgoingSequenceFlows.size() - 1); // -1, the event being triggered does not need to be deleted
        for (SequenceFlow outgoingSequenceFlow : outgoingSequenceFlows) {
            if (outgoingSequenceFlow.getTargetFlowElement() != null
                    && !outgoingSequenceFlow.getTargetFlowElement().getId().equals(execution.getCurrentActivityId())) {
                eventActivityIds.add(outgoingSequenceFlow.getTargetFlowElement().getId());
            }
        }

        if (!eventActivityIds.isEmpty()) {
            CommandContext commandContext = Context.getCommandContext();
            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
    
            // Find the executions
            List<ExecutionEntity> executionEntities = executionEntityManager
                    .findExecutionsByParentExecutionAndActivityIds(execution.getParentId(), eventActivityIds);
    
            // Execute the cancel behaviour of the IntermediateCatchEvent
            for (ExecutionEntity executionEntity : executionEntities) {
                if (eventActivityIds.contains(executionEntity.getActivityId()) && execution.getCurrentFlowElement() instanceof IntermediateCatchEvent) {
                    IntermediateCatchEvent intermediateCatchEvent = (IntermediateCatchEvent) execution.getCurrentFlowElement();
                    if (intermediateCatchEvent.getBehavior() instanceof IntermediateCatchEventActivityBehavior) {
                        ((IntermediateCatchEventActivityBehavior) intermediateCatchEvent.getBehavior()).eventCancelledByEventGateway(executionEntity);
                        eventActivityIds.remove(executionEntity.getActivityId()); // We only need to delete ONE execution at the event.
                    }
                }
            }
        }
    }

}
