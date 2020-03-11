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



import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.Association;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import org.flowable.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Tijs Rademakers
 */
class CompensationEventHandler implements EventHandler {

    @Override
    public string getEventHandlerType() {
        return CompensateEventSubscriptionEntity.EVENT_TYPE;
    }

    @Override
    public void handleEvent(EventSubscriptionEntity eventSubscription, Object payload, CommandContext commandContext) {

        string configuration = eventSubscription.getConfiguration();
        if (configuration is null) {
            throw new FlowableException("Compensating execution not set for compensate event subscription with id " + eventSubscription.getId());
        }

        ExecutionEntity compensatingExecution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(configuration);

        string processDefinitionId = compensatingExecution.getProcessDefinitionId();
        Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        if (process is null) {
            throw new FlowableException("Cannot start process instance. Process model (id = " + processDefinitionId + ") could not be found");
        }

        FlowElement flowElement = process.getFlowElement(eventSubscription.getActivityId(), true);

        if (flowElement instanceof SubProcess && !((SubProcess) flowElement).isForCompensation()) {

            // descend into scope:
            compensatingExecution.setScope(true);
            List<CompensateEventSubscriptionEntity> eventsForThisScope = CommandContextUtil.getEventSubscriptionService(commandContext).findCompensateEventSubscriptionsByExecutionId(compensatingExecution.getId());
            ScopeUtil.throwCompensationEvent(eventsForThisScope, compensatingExecution, false);

        } else {

            try {

                FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    eventDispatcher.dispatchEvent(
                            FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_COMPENSATE, flowElement.getId(), flowElement.getName(),
                                    compensatingExecution.getId(), compensatingExecution.getProcessInstanceId(), compensatingExecution.getProcessDefinitionId(), flowElement));
                }

                Activity compensationActivity = null;
                Activity activity = (Activity) flowElement;
                if (!activity.isForCompensation() && activity.getBoundaryEvents().size() > 0) {
                    for (BoundaryEvent boundaryEvent : activity.getBoundaryEvents()) {
                        if (boundaryEvent.getEventDefinitions().size() > 0 && boundaryEvent.getEventDefinitions().get(0) instanceof CompensateEventDefinition) {
                            List<Association> associations = process.findAssociationsWithSourceRefRecursive(boundaryEvent.getId());
                            for (Association association : associations) {
                                FlowElement targetElement = process.getFlowElement(association.getTargetRef(), true);
                                if (targetElement instanceof Activity) {
                                    Activity targetActivity = (Activity) targetElement;
                                    if (targetActivity.isForCompensation()) {
                                        compensationActivity = targetActivity;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }

                if (compensationActivity !is null) {
                    flowElement = compensationActivity;
                }

                compensatingExecution.setCurrentFlowElement(flowElement);
                CommandContextUtil.getAgenda().planContinueProcessInCompensation(compensatingExecution);

            } catch (Exception e) {
                throw new FlowableException("Error while handling compensation event " + eventSubscription, e);
            }

        }
    }

}
