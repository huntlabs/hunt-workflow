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
module flow.engine.impl.bpmn.behavior.BoundaryCompensateEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.Association;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
/**
 * @author Tijs Rademakers
 */
class BoundaryCompensateEventActivityBehavior : BoundaryEventActivityBehavior {

    protected CompensateEventDefinition compensateEventDefinition;

    this(CompensateEventDefinition compensateEventDefinition, bool interrupting) {
        super(interrupting);
        this.compensateEventDefinition = compensateEventDefinition;
    }

    override
    public void execute(DelegateExecution execution) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        BoundaryEvent boundaryEvent = cast(BoundaryEvent) execution.getCurrentFlowElement();

        Process process = ProcessDefinitionUtil.getProcess(execution.getProcessDefinitionId());
        if (process is null) {
            throw new FlowableException("Process model (id = " ~ execution.getId() ~ ") could not be found");
        }

        Activity sourceActivity = null;
        Activity compensationActivity = null;
        List!Association associations = process.findAssociationsWithSourceRefRecursive(boundaryEvent.getId());
        foreach (Association association ; associations) {
            sourceActivity = boundaryEvent.getAttachedToRef();
            FlowElement targetElement = process.getFlowElement(association.getTargetRef(), true);
            if (cast(Activity)targetElement !is null) {
                Activity activity = cast(Activity) targetElement;
                if (activity.isForCompensation()) {
                    compensationActivity = activity;
                    break;
                }
            }
        }

        if (sourceActivity is null) {
            throw new FlowableException("Parent activity for boundary compensation event could not be found");
        }

        if (compensationActivity is null) {
            throw new FlowableException("Compensation activity could not be found (or it is missing 'isForCompensation=\"true\"'");
        }

        // find SubProcess or Process instance execution
        ExecutionEntity scopeExecution = null;
        ExecutionEntity parentExecution = executionEntity.getParent();
        while (scopeExecution is null && parentExecution !is null) {
            if (cast(SubProcess) parentExecution.getCurrentFlowElement() !is null) {
                scopeExecution = parentExecution;

            } else if (parentExecution.isProcessInstanceType()) {
                scopeExecution = parentExecution;
            } else {
                parentExecution = parentExecution.getParent();
            }
        }

        if (scopeExecution is null) {
            throw new FlowableException("Could not find a scope execution for compensation boundary event " ~ boundaryEvent.getId());
        }

        EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService().createEventSubscriptionBuilder()
                        .eventType(CompensateEventSubscriptionEntity.EVENT_TYPE)
                        .executionId(scopeExecution.getId())
                        .processInstanceId(scopeExecution.getProcessInstanceId())
                        .activityId(sourceActivity.getId())
                        .tenantId(scopeExecution.getTenantId())
                        .create();

        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        BoundaryEvent boundaryEvent = cast(BoundaryEvent) execution.getCurrentFlowElement();

        if (boundaryEvent.isCancelActivity()) {
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();
            foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
                if (cast(CompensateEventSubscriptionEntity)eventSubscription !is null && eventSubscription.getActivityId() == (compensateEventDefinition.getActivityRef())) {
                    eventSubscriptionService.deleteEventSubscription(eventSubscription);
                    CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
                }
            }
        }

        super.trigger(executionEntity, triggerName, triggerData);
    }
}
