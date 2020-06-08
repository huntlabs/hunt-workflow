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



import hunt.collection.ArrayList;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.Activity;
import flow.bpmn.model.Association;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.Process;
import flow.bpmn.model.ThrowEvent;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class IntermediateThrowCompensationEventActivityBehavior : FlowNodeActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected final CompensateEventDefinition compensateEventDefinition;

    public IntermediateThrowCompensationEventActivityBehavior(CompensateEventDefinition compensateEventDefinition) {
        this.compensateEventDefinition = compensateEventDefinition;
    }

    override
    public void execute(DelegateExecution execution) {
        ThrowEvent throwEvent = (ThrowEvent) execution.getCurrentFlowElement();

        /*
         * From the BPMN 2.0 spec:
         *
         * The Activity to be compensated MAY be supplied.
         *
         * If an Activity is not supplied, then the compensation is broadcast to all completed Activities in the current Sub- Process (if present), or the entire Process instance (if at the global
         * level). This “throws” the compensation.
         */
        final string activityRef = compensateEventDefinition.getActivityRef();

        CommandContext commandContext = Context.getCommandContext();
        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);

        List!CompensateEventSubscriptionEntity eventSubscriptions = new ArrayList<>();
        if (StringUtils.isNotEmpty(activityRef)) {

            // If an activity ref is provided, only that activity is compensated
            List!CompensateEventSubscriptionEntity compensationEvents = eventSubscriptionService
                    .findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(execution.getProcessInstanceId(), activityRef);

            if (compensationEvents is null || compensationEvents.size() == 0) {
                // check if compensation activity was referenced directly (backwards compatibility pre 6.4.0)

                string processDefinitionId = execution.getProcessDefinitionId();
                Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
                if (process is null) {
                    throw new FlowableException("Process model (id = " + processDefinitionId + ") could not be found");
                }

                string compensationActivityId = null;
                FlowElement flowElement = process.getFlowElement(activityRef, true);
                if (flowElement instanceof Activity) {
                    Activity activity = (Activity) flowElement;
                    if (activity.isForCompensation()) {
                        List!Association associations = process.findAssociationsWithTargetRefRecursive(activity.getId());
                        for (Association association : associations) {
                            FlowElement sourceElement = process.getFlowElement(association.getSourceRef(), true);
                            if (sourceElement instanceof BoundaryEvent) {
                                BoundaryEvent sourceBoundaryEvent = (BoundaryEvent) sourceElement;
                                if (sourceBoundaryEvent.getAttachedToRefId() !is null) {
                                    compensationActivityId = sourceBoundaryEvent.getAttachedToRefId();
                                    break;
                                }
                            }
                        }
                    }
                }

                if (compensationActivityId !is null) {
                    compensationEvents = eventSubscriptionService
                            .findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(execution.getProcessInstanceId(), compensationActivityId);
                }
            }

            eventSubscriptions.addAll(compensationEvents);

        } else {

            // If no activity ref is provided, it is broadcast to the current sub process / process instance
            Process process = ProcessDefinitionUtil.getProcess(execution.getProcessDefinitionId());

            FlowElementsContainer flowElementsContainer = null;
            if (throwEvent.getSubProcess() is null) {
                flowElementsContainer = process;
            } else {
                flowElementsContainer = throwEvent.getSubProcess();
            }

            for (FlowElement flowElement : flowElementsContainer.getFlowElements()) {
                if (flowElement instanceof Activity) {
                    eventSubscriptions.addAll(eventSubscriptionService
                            .findCompensateEventSubscriptionsByProcessInstanceIdAndActivityId(execution.getProcessInstanceId(), flowElement.getId()));
                }
            }

        }

        if (eventSubscriptions.isEmpty()) {
            leave(execution);
        } else {
            // TODO: implement async (waitForCompletion=false in bpmn)
            ScopeUtil.throwCompensationEvent(eventSubscriptions, execution, false);
            leave(execution);
        }
    }
}
