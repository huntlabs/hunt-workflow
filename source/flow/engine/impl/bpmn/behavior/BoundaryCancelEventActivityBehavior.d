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

module flow.engine.impl.bpmn.behavior.BoundaryCancelEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
/**
 * @author Tijs Rademakers
 */
class BoundaryCancelEventActivityBehavior : BoundaryEventActivityBehavior {

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        BoundaryEvent boundaryEvent = cast(BoundaryEvent) execution.getCurrentFlowElement();

        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        ExecutionEntity subProcessExecution = null;
        // TODO: this can be optimized. A full search in the all executions shouldn't be needed
        List!ExecutionEntity processInstanceExecutions = executionEntityManager.findChildExecutionsByProcessInstanceId(execution.getProcessInstanceId());
        foreach (ExecutionEntity childExecution ; processInstanceExecutions) {
            if (childExecution.getCurrentFlowElement() !is null
                    && childExecution.getCurrentFlowElement().getId() == (boundaryEvent.getAttachedToRefId())) {
                subProcessExecution = childExecution;
                break;
            }
        }

        if (subProcessExecution is null) {
            throw new FlowableException("No execution found for sub process of boundary cancel event " ~ boundaryEvent.getId());
        }

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        List!CompensateEventSubscriptionEntity eventSubscriptions = eventSubscriptionService.findCompensateEventSubscriptionsByExecutionId(subProcessExecution.getParentId());

        if (eventSubscriptions.isEmpty()) {
            leave(execution);
        } else {

            string deleteReason = DeleteReason.BOUNDARY_EVENT_INTERRUPTING ~ "(" ~ boundaryEvent.getId() ~ ")";

            // cancel boundary is always sync
            ScopeUtil.throwCompensationEvent(eventSubscriptions, execution, false);
            executionEntityManager.deleteExecutionAndRelatedData(subProcessExecution, deleteReason, false);
            if (cast(Activity)subProcessExecution.getCurrentFlowElement() !is null) {
                Activity activity = cast(Activity) subProcessExecution.getCurrentFlowElement();
                if (activity.getLoopCharacteristics() !is null) {
                    ExecutionEntity miExecution = subProcessExecution.getParent();
                    List!ExecutionEntity miChildExecutions = executionEntityManager.findChildExecutionsByParentExecutionId(miExecution.getId());
                    foreach (ExecutionEntity miChildExecution ; miChildExecutions) {
                        if (subProcessExecution.getId() != (miChildExecution.getId()) && activity.getId() == (miChildExecution.getCurrentActivityId())) {
                            executionEntityManager.deleteExecutionAndRelatedData(miChildExecution, deleteReason, false);
                        }
                    }
                }
            }
            leave(execution);
        }
    }
}
