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

module flow.engine.impl.bpmn.helper.EscalationPropagation;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import std.string;
/**
 * This class is responsible for finding and executing escalation handlers for BPMN Errors.
 *
 * Possible escalation handlers include Escalation Intermediate Events and Escalation Event Sub-Processes.
 *
 * @author Tijs Rademakers
 */
class EscalationPropagation {

    public static void propagateEscalation(Escalation escalation, DelegateExecution execution) {
        propagateEscalation(escalation.getEscalationCode(), escalation.getName(), execution);
    }

    public static void propagateEscalation(string escalationCode, string escalationName, DelegateExecution execution) {
        Map!(string, List!Event) eventMap = new HashMap!(string, List!Event)();
        Set!string rootProcessDefinitionIds = new HashSet!string();
        if (execution.getProcessInstanceId() != (execution.getRootProcessInstanceId())) {
            ExecutionEntity parentExecution = cast(ExecutionEntity) execution;
            while ((parentExecution.getParentId() !is null && parentExecution.getParentId().length != 0) || (parentExecution.getSuperExecutionId() !is null && parentExecution.getSuperExecutionId().length !=0)) {
                if (parentExecution.getParentId() !is null) {
                    parentExecution = parentExecution.getParent();
                } else {
                    parentExecution = parentExecution.getSuperExecution();
                    rootProcessDefinitionIds.add(parentExecution.getProcessDefinitionId());
                }
            }
        }

        if (rootProcessDefinitionIds.size() > 0) {
            foreach (string processDefinitionId ; rootProcessDefinitionIds) {
                eventMap.putAll(findCatchingEventsForProcess(processDefinitionId, escalationCode));
            }
        }

        eventMap.putAll(findCatchingEventsForProcess(execution.getProcessDefinitionId(), escalationCode));
        if (eventMap.size() > 0) {
            executeCatch(eventMap, execution, escalationCode, escalationName);
        }
    }

    protected static void executeCatch(Map!(string, List!Event) eventMap, DelegateExecution delegateExecution, string escalationCode, string escalationName) {
        Set!string toDeleteProcessInstanceIds = new HashSet!string();

        Event matchingEvent = null;
        ExecutionEntity currentExecution = cast(ExecutionEntity) delegateExecution;
        ExecutionEntity parentExecution = null;

        if (eventMap.containsKey(currentExecution.getActivityId() ~ "#" ~ currentExecution.getProcessDefinitionId())) {
            // Check for multi instance
            if (currentExecution.getParentId() !is null && currentExecution.getParentId().length != 0 && currentExecution.getParent().isMultiInstanceRoot()) {
                parentExecution = currentExecution.getParent();
            } else {
                parentExecution = currentExecution;
            }

            matchingEvent = getCatchEventFromList(eventMap.get(currentExecution.getActivityId() ~
                            "#" ~ currentExecution.getProcessDefinitionId()), parentExecution);

        } else {
            parentExecution = currentExecution.getParent();

            // Traverse parents until one is found that is a scope and matches the activity the boundary event is defined on
            while (matchingEvent is null && parentExecution !is null) {
                FlowElementsContainer currentContainer = null;
                if (cast(FlowElementsContainer)parentExecution.getCurrentFlowElement() !is null) {
                    currentContainer = cast(FlowElementsContainer) parentExecution.getCurrentFlowElement();
                } else if (parentExecution.getId() == (parentExecution.getProcessInstanceId())) {
                    currentContainer = ProcessDefinitionUtil.getProcess(parentExecution.getProcessDefinitionId());
                }

                if (currentContainer !is null) {
                    foreach (MapEntry!(string, List!Event) refId ; eventMap) {
                        List!Event events = eventMap.get(refId.getKey());
                        if ((events !is null && events.size != 0) && cast(StartEvent)events.get(0) !is null) {
                            string refActivityId = refId.getKey()[0 ..  refId.getKey().indexOf('#')];
                            string refProcessDefinitionId = refId.getKey[indexOf(refId.getKey(), '#') + 1 .. $];
                            if (parentExecution.getProcessDefinitionId() == (refProcessDefinitionId) &&
                                            currentContainer.getFlowElement(refActivityId) !is null) {

                                matchingEvent = getCatchEventFromList(events, parentExecution);
                                EscalationEventDefinition escalationEventDef = getEscalationEventDefinition(matchingEvent);
                                if (escalationEventDef.getEscalationCode() !is null && escalationEventDef.getEscalationCode().length != 0) {
                                    break;
                                }
                            }
                        }
                    }
                }

                if (matchingEvent is null) {
                    if (eventMap.containsKey(parentExecution.getActivityId() ~ "#" ~ parentExecution.getProcessDefinitionId())) {
                        // Check for multi instance
                        if (parentExecution.getParentId() !is null && parentExecution.getParentId().length != 0 && parentExecution.getParent().isMultiInstanceRoot()) {
                            parentExecution = parentExecution.getParent();
                        }

                        matchingEvent = getCatchEventFromList(eventMap.get(parentExecution.getActivityId() ~
                                        "#" ~ parentExecution.getProcessDefinitionId()), parentExecution);

                    } else if (parentExecution.getParentId() !is null && parentExecution.getParentId().length != 0) {
                        parentExecution = parentExecution.getParent();

                    } else {
                        if (parentExecution.getProcessInstanceId() != parentExecution.getRootProcessInstanceId()) {
                            toDeleteProcessInstanceIds.add(parentExecution.getProcessInstanceId());
                            parentExecution = parentExecution.getSuperExecution();
                        } else {
                            parentExecution = null;
                        }
                    }
                }
            }
        }

        if (matchingEvent !is null && parentExecution !is null) {

            foreach (string processInstanceId ; toDeleteProcessInstanceIds) {
                ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
                ExecutionEntity processInstanceEntity = executionEntityManager.findById(processInstanceId);

                // Event
                ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
                FlowableEventDispatcher eventDispatcher = null;
                if (processEngineConfiguration !is null) {
                    eventDispatcher = processEngineConfiguration.getEventDispatcher();
                }
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    processEngineConfiguration.getEventDispatcher()
                            .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_COMPLETED_WITH_ESCALATION_END_EVENT, cast(Object)processInstanceEntity));
                }
            }

            executeEventHandler(matchingEvent, parentExecution, currentExecution, escalationCode, escalationName);
        }
    }

    protected static void executeEventHandler(Event event, ExecutionEntity parentExecution, ExecutionEntity currentExecution, string escalationCode, string escalationName) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        FlowableEventDispatcher eventDispatcher = null;
        if (processEngineConfiguration !is null) {
            eventDispatcher = processEngineConfiguration.getEventDispatcher();
        }

        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            processEngineConfiguration.getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEscalationEvent(FlowableEngineEventType.ACTIVITY_ESCALATION_RECEIVED, event.getId(), escalationCode,
                                    escalationName, parentExecution.getId(), parentExecution.getProcessInstanceId(), parentExecution.getProcessDefinitionId()));
        }

        if (cast(StartEvent)event !is null) {
            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

            ExecutionEntity eventSubProcessExecution = executionEntityManager.createChildExecution(parentExecution);
            eventSubProcessExecution.setCurrentFlowElement(event.getSubProcess() !is null ? event.getSubProcess() : event);
            CommandContextUtil.getAgenda().planContinueProcessOperation(eventSubProcessExecution);

        } else {
            ExecutionEntity boundaryExecution = null;
            List!ExecutionEntity childExecutions = parentExecution.getExecutionEntities();
            foreach (ExecutionEntity childExecution ; childExecutions) {
                if (childExecution !is null
                        && childExecution.getActivityId() !is null
                        && childExecution.getActivityId() == (event.getId())) {
                    boundaryExecution = childExecution;
                }
            }

            CommandContextUtil.getAgenda().planTriggerExecutionOperation(boundaryExecution);
        }
    }

    protected static Map!(string, List!Event) findCatchingEventsForProcess(string processDefinitionId, string escalationCode) {
        Map!(string, List!Event) eventMap = new HashMap!(string, List!Event)();
        Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        List!EventSubProcess subProcesses = process.findFlowElementsOfType!EventSubProcess(typeid(EventSubProcess), true);
        foreach (EventSubProcess eventSubProcess ; subProcesses) {
            foreach (FlowElement flowElement ; eventSubProcess.getFlowElements()) {
                if (cast(StartEvent)flowElement !is null) {
                    StartEvent startEvent = cast(StartEvent) flowElement;
                    if ((startEvent.getEventDefinitions() !is null && !startEvent.getEventDefinitions().isEmpty()) && cast(EscalationEventDefinition)(startEvent.getEventDefinitions().get(0)) !is null) {
                        EscalationEventDefinition escalationEventDef = cast(EscalationEventDefinition) startEvent.getEventDefinitions().get(0);
                        string eventEscalationCode = null;
                        if ((escalationEventDef.getEscalationCode() !is null && escalationEventDef.getEscalationCode().length != 0) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                            eventEscalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                        } else {
                            eventEscalationCode = escalationEventDef.getEscalationCode();
                        }

                        if (eventEscalationCode is null || escalationCode is null || eventEscalationCode == (escalationCode)) {
                            List!Event startEvents = new ArrayList!Event();
                            startEvents.add(startEvent);
                            eventMap.put(eventSubProcess.getId() ~ "#" ~ processDefinitionId, startEvents);
                        }
                    }
                }
            }
        }

        List!BoundaryEvent boundaryEvents = process.findFlowElementsOfType!BoundaryEvent(typeid(BoundaryEvent), true);
        foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {
            if (boundaryEvent.getAttachedToRefId() !is null && boundaryEvent.getAttachedToRefId().length != 0 && (boundaryEvent.getEventDefinitions() !is null && !boundaryEvent.getEventDefinitions().isEmpty()) && cast(EscalationEventDefinition)boundaryEvent.getEventDefinitions().get(0) !is null) {

                EscalationEventDefinition escalationEventDef = cast(EscalationEventDefinition) boundaryEvent.getEventDefinitions().get(0);
                string eventEscalationCode = null;
                if ((escalationEventDef.getEscalationCode() !is null && escalationEventDef.getEscalationCode().length != 0) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                    eventEscalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                } else {
                    eventEscalationCode = escalationEventDef.getEscalationCode();
                }

                if (eventEscalationCode is null || escalationCode is null || eventEscalationCode == (escalationCode)) {
                    List!Event elementBoundaryEvents = null;
                    if (!eventMap.containsKey(boundaryEvent.getAttachedToRefId() ~ "#" ~ processDefinitionId)) {
                        elementBoundaryEvents = new ArrayList!Event();
                        eventMap.put(boundaryEvent.getAttachedToRefId() ~ "#" ~ processDefinitionId, elementBoundaryEvents);
                    } else {
                        elementBoundaryEvents = eventMap.get(boundaryEvent.getAttachedToRefId() ~ "#" ~ processDefinitionId);
                    }
                    elementBoundaryEvents.add(boundaryEvent);
                }
            }
        }
        return eventMap;
    }

    protected static Event getCatchEventFromList(List!Event events, ExecutionEntity parentExecution) {
        Event selectedEvent = null;
        string selectedEventEscalationCode = null;

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(parentExecution.getProcessDefinitionId());
        foreach (Event event ; events) {
            EscalationEventDefinition escalationEventDef = getEscalationEventDefinition(event);
            string escalationCode = escalationEventDef.getEscalationCode();
            if (bpmnModel !is null) {
                if ((escalationEventDef.getEscalationCode() !is null && escalationEventDef.getEscalationCode().length != 0) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                    escalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                } else {
                    escalationCode = escalationEventDef.getEscalationCode();
                }
            }

            if (selectedEvent is null || ((selectedEventEscalationCode is null || selectedEventEscalationCode.length == 0) && (escalationCode is null || escalationCode.length == 0))) {
                selectedEvent = event;
                selectedEventEscalationCode = escalationCode;
            }
        }

        return selectedEvent;
    }

    protected static EscalationEventDefinition getEscalationEventDefinition(Event event) {
        foreach (EventDefinition eventDefinition ; event.getEventDefinitions()) {
            if (cast(EscalationEventDefinition)eventDefinition !is null) {
                return cast(EscalationEventDefinition) eventDefinition;
            }
        }

        return null;
    }
}
