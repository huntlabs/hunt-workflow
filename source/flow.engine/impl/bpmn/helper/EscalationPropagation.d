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
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import org.apache.commons.lang3.StringUtils;
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
import flow.common.util.CollectionUtil;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;

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
        Map<string, List!Event> eventMap = new HashMap<>();
        Set!string rootProcessDefinitionIds = new HashSet<>();
        if (!execution.getProcessInstanceId().equals(execution.getRootProcessInstanceId())) {
            ExecutionEntity parentExecution = (ExecutionEntity) execution;
            while (parentExecution.getParentId() !is null || parentExecution.getSuperExecutionId() !is null) {
                if (parentExecution.getParentId() !is null) {
                    parentExecution = parentExecution.getParent();
                } else {
                    parentExecution = parentExecution.getSuperExecution();
                    rootProcessDefinitionIds.add(parentExecution.getProcessDefinitionId());
                }
            }
        }

        if (rootProcessDefinitionIds.size() > 0) {
            for (string processDefinitionId : rootProcessDefinitionIds) {
                eventMap.putAll(findCatchingEventsForProcess(processDefinitionId, escalationCode));
            }
        }

        eventMap.putAll(findCatchingEventsForProcess(execution.getProcessDefinitionId(), escalationCode));
        if (eventMap.size() > 0) {
            executeCatch(eventMap, execution, escalationCode, escalationName);
        }
    }

    protected static void executeCatch(Map<string, List!Event> eventMap, DelegateExecution delegateExecution, string escalationCode, string escalationName) {
        Set!string toDeleteProcessInstanceIds = new HashSet<>();

        Event matchingEvent = null;
        ExecutionEntity currentExecution = (ExecutionEntity) delegateExecution;
        ExecutionEntity parentExecution = null;

        if (eventMap.containsKey(currentExecution.getActivityId() + "#" + currentExecution.getProcessDefinitionId())) {
            // Check for multi instance
            if (currentExecution.getParentId() !is null && currentExecution.getParent().isMultiInstanceRoot()) {
                parentExecution = currentExecution.getParent();
            } else {
                parentExecution = currentExecution;
            }

            matchingEvent = getCatchEventFromList(eventMap.get(currentExecution.getActivityId() +
                            "#" + currentExecution.getProcessDefinitionId()), parentExecution);

        } else {
            parentExecution = currentExecution.getParent();

            // Traverse parents until one is found that is a scope and matches the activity the boundary event is defined on
            while (matchingEvent is null && parentExecution !is null) {
                FlowElementsContainer currentContainer = null;
                if (parentExecution.getCurrentFlowElement() instanceof FlowElementsContainer) {
                    currentContainer = (FlowElementsContainer) parentExecution.getCurrentFlowElement();
                } else if (parentExecution.getId().equals(parentExecution.getProcessInstanceId())) {
                    currentContainer = ProcessDefinitionUtil.getProcess(parentExecution.getProcessDefinitionId());
                }

                if (currentContainer !is null) {
                    for (string refId : eventMap.keySet()) {
                        List!Event events = eventMap.get(refId);
                        if (CollectionUtil.isNotEmpty(events) && events.get(0) instanceof StartEvent) {
                            string refActivityId = refId.substring(0, refId.indexOf('#'));
                            string refProcessDefinitionId = refId.substring(refId.indexOf('#') + 1);
                            if (parentExecution.getProcessDefinitionId().equals(refProcessDefinitionId) &&
                                            currentContainer.getFlowElement(refActivityId) !is null) {

                                matchingEvent = getCatchEventFromList(events, parentExecution);
                                EscalationEventDefinition escalationEventDef = getEscalationEventDefinition(matchingEvent);
                                if (StringUtils.isNotEmpty(escalationEventDef.getEscalationCode())) {
                                    break;
                                }
                            }
                        }
                    }
                }

                if (matchingEvent is null) {
                    if (eventMap.containsKey(parentExecution.getActivityId() + "#" + parentExecution.getProcessDefinitionId())) {
                        // Check for multi instance
                        if (parentExecution.getParentId() !is null && parentExecution.getParent().isMultiInstanceRoot()) {
                            parentExecution = parentExecution.getParent();
                        }

                        matchingEvent = getCatchEventFromList(eventMap.get(parentExecution.getActivityId() +
                                        "#" + parentExecution.getProcessDefinitionId()), parentExecution);

                    } else if (StringUtils.isNotEmpty(parentExecution.getParentId())) {
                        parentExecution = parentExecution.getParent();

                    } else {
                        if (parentExecution.getProcessInstanceId().equals(parentExecution.getRootProcessInstanceId()) == false) {
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

            for (string processInstanceId : toDeleteProcessInstanceIds) {
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
                            .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_COMPLETED_WITH_ESCALATION_END_EVENT, processInstanceEntity));
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

        if (event instanceof StartEvent) {
            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

            ExecutionEntity eventSubProcessExecution = executionEntityManager.createChildExecution(parentExecution);
            eventSubProcessExecution.setCurrentFlowElement(event.getSubProcess() !is null ? event.getSubProcess() : event);
            CommandContextUtil.getAgenda().planContinueProcessOperation(eventSubProcessExecution);

        } else {
            ExecutionEntity boundaryExecution = null;
            List<? : ExecutionEntity> childExecutions = parentExecution.getExecutions();
            for (ExecutionEntity childExecution : childExecutions) {
                if (childExecution !is null
                        && childExecution.getActivityId() !is null
                        && childExecution.getActivityId().equals(event.getId())) {
                    boundaryExecution = childExecution;
                }
            }

            CommandContextUtil.getAgenda().planTriggerExecutionOperation(boundaryExecution);
        }
    }

    protected static Map<string, List!Event> findCatchingEventsForProcess(string processDefinitionId, string escalationCode) {
        Map<string, List!Event> eventMap = new HashMap<>();
        Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        List!EventSubProcess subProcesses = process.findFlowElementsOfType(EventSubProcess.class, true);
        for (EventSubProcess eventSubProcess : subProcesses) {
            for (FlowElement flowElement : eventSubProcess.getFlowElements()) {
                if (flowElement instanceof StartEvent) {
                    StartEvent startEvent = (StartEvent) flowElement;
                    if (CollectionUtil.isNotEmpty(startEvent.getEventDefinitions()) && startEvent.getEventDefinitions().get(0) instanceof EscalationEventDefinition) {
                        EscalationEventDefinition escalationEventDef = (EscalationEventDefinition) startEvent.getEventDefinitions().get(0);
                        string eventEscalationCode = null;
                        if (StringUtils.isNotEmpty(escalationEventDef.getEscalationCode()) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                            eventEscalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                        } else {
                            eventEscalationCode = escalationEventDef.getEscalationCode();
                        }

                        if (eventEscalationCode is null || escalationCode is null || eventEscalationCode.equals(escalationCode)) {
                            List!Event startEvents = new ArrayList<>();
                            startEvents.add(startEvent);
                            eventMap.put(eventSubProcess.getId() + "#" + processDefinitionId, startEvents);
                        }
                    }
                }
            }
        }

        List!BoundaryEvent boundaryEvents = process.findFlowElementsOfType(BoundaryEvent.class, true);
        for (BoundaryEvent boundaryEvent : boundaryEvents) {
            if (boundaryEvent.getAttachedToRefId() !is null && CollectionUtil.isNotEmpty(boundaryEvent.getEventDefinitions()) && boundaryEvent.getEventDefinitions().get(0) instanceof EscalationEventDefinition) {

                EscalationEventDefinition escalationEventDef = (EscalationEventDefinition) boundaryEvent.getEventDefinitions().get(0);
                string eventEscalationCode = null;
                if (StringUtils.isNotEmpty(escalationEventDef.getEscalationCode()) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                    eventEscalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                } else {
                    eventEscalationCode = escalationEventDef.getEscalationCode();
                }

                if (eventEscalationCode is null || escalationCode is null || eventEscalationCode.equals(escalationCode)) {
                    List!Event elementBoundaryEvents = null;
                    if (!eventMap.containsKey(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId)) {
                        elementBoundaryEvents = new ArrayList<>();
                        eventMap.put(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId, elementBoundaryEvents);
                    } else {
                        elementBoundaryEvents = eventMap.get(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId);
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
        for (Event event : events) {
            EscalationEventDefinition escalationEventDef = getEscalationEventDefinition(event);
            string escalationCode = escalationEventDef.getEscalationCode();
            if (bpmnModel !is null) {
                if (StringUtils.isNotEmpty(escalationEventDef.getEscalationCode()) && bpmnModel.containsEscalationRef(escalationEventDef.getEscalationCode())) {
                    escalationCode = bpmnModel.getEscalation(escalationEventDef.getEscalationCode()).getEscalationCode();
                } else {
                    escalationCode = escalationEventDef.getEscalationCode();
                }
            }

            if (selectedEvent is null || (StringUtils.isEmpty(selectedEventEscalationCode) && StringUtils.isNotEmpty(escalationCode))) {
                selectedEvent = event;
                selectedEventEscalationCode = escalationCode;
            }
        }

        return selectedEvent;
    }

    protected static EscalationEventDefinition getEscalationEventDefinition(Event event) {
        for (EventDefinition eventDefinition : event.getEventDefinitions()) {
            if (eventDefinition instanceof EscalationEventDefinition) {
                return (EscalationEventDefinition) eventDefinition;
            }
        }

        return null;
    }
}
