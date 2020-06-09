///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import hunt.collection.ArrayList;
//import hunt.collection.HashMap;
//import hunt.collection.HashSet;
//import hunt.collection.List;
//import hunt.collection.Map;
//import hunt.collection.Set;
//
//import org.apache.commons.lang3.StringUtils;
//import org.apache.commons.lang3.exception.ExceptionUtils;
//import flow.bpmn.model.BoundaryEvent;
//import flow.bpmn.model.BpmnModel;
//import flow.bpmn.model.CallActivity;
//import flow.bpmn.model.ErrorEventDefinition;
//import flow.bpmn.model.Event;
//import flow.bpmn.model.EventDefinition;
//import flow.bpmn.model.EventSubProcess;
//import flow.bpmn.model.FlowElement;
//import flow.bpmn.model.FlowElementsContainer;
//import flow.bpmn.model.MapExceptionEntry;
//import flow.bpmn.model.Process;
//import flow.bpmn.model.StartEvent;
//import flow.common.api.FlowableException;
//import flow.common.api.deleg.event.FlowableEngineEventType;
//import flow.common.api.deleg.event.FlowableEventDispatcher;
//import flow.common.util.CollectionUtil;
//import flow.common.util.ReflectUtil;
//import flow.engine.deleg.BpmnError;
//import flow.engine.deleg.DelegateExecution;
//import flow.engine.deleg.event.impl.FlowableEventBuilder;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//import flow.engine.impl.persistence.entity.ExecutionEntityManager;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.ProcessDefinitionUtil;
//
///**
// * This class is responsible for finding and executing error handlers for BPMN Errors.
// *
// * Possible error handlers include Error Intermediate Events and Error Event Sub-Processes.
// *
// * @author Tijs Rademakers
// * @author Saeid Mirzaei
// */
//class ErrorPropagation {
//
//    public static void propagateError(BpmnError error, DelegateExecution execution) {
//        propagateError(error.getErrorCode(), execution);
//    }
//
//    public static void propagateError(string errorCode, DelegateExecution execution) {
//        Map<string, List!Event> eventMap = new HashMap<>();
//        Set!string rootProcessDefinitionIds = new HashSet<>();
//        if (!execution.getProcessInstanceId().equals(execution.getRootProcessInstanceId())) {
//            ExecutionEntity parentExecution = (ExecutionEntity) execution;
//            while (parentExecution.getParentId() !is null || parentExecution.getSuperExecutionId() !is null) {
//                if (parentExecution.getParentId() !is null) {
//                    parentExecution = parentExecution.getParent();
//                } else {
//                    parentExecution = parentExecution.getSuperExecution();
//                    rootProcessDefinitionIds.add(parentExecution.getProcessDefinitionId());
//                }
//            }
//        }
//
//        if (rootProcessDefinitionIds.size() > 0) {
//            for (string processDefinitionId : rootProcessDefinitionIds) {
//                eventMap.putAll(findCatchingEventsForProcess(processDefinitionId, errorCode));
//            }
//        }
//
//        eventMap.putAll(findCatchingEventsForProcess(execution.getProcessDefinitionId(), errorCode));
//        if (eventMap.size() > 0) {
//            executeCatch(eventMap, execution, errorCode);
//        }
//
//        if (eventMap.size() == 0) {
//            throw new BpmnError(errorCode, "No catching boundary event found for error with errorCode '" + errorCode + "', neither in same process nor in parent process");
//        }
//    }
//
//    protected static void executeCatch(Map<string, List!Event> eventMap, DelegateExecution delegateExecution, string errorId) {
//        Set!string toDeleteProcessInstanceIds = new HashSet<>();
//
//        Event matchingEvent = null;
//        ExecutionEntity currentExecution = (ExecutionEntity) delegateExecution;
//        ExecutionEntity parentExecution = null;
//
//        if (eventMap.containsKey(currentExecution.getActivityId() + "#" + currentExecution.getProcessDefinitionId())) {
//            // Check for multi instance
//            if (currentExecution.getParentId() !is null && currentExecution.getParent().isMultiInstanceRoot()) {
//                parentExecution = currentExecution.getParent();
//            } else {
//                parentExecution = currentExecution;
//            }
//
//            matchingEvent = getCatchEventFromList(eventMap.get(currentExecution.getActivityId() +
//                            "#" + currentExecution.getProcessDefinitionId()), parentExecution);
//
//        } else {
//            parentExecution = currentExecution.getParent();
//
//            // Traverse parents until one is found that is a scope and matches the activity the boundary event is defined on
//            while (matchingEvent is null && parentExecution !is null) {
//                FlowElementsContainer currentContainer = null;
//                if (parentExecution.getCurrentFlowElement() instanceof FlowElementsContainer) {
//                    currentContainer = (FlowElementsContainer) parentExecution.getCurrentFlowElement();
//                } else if (parentExecution.getId().equals(parentExecution.getProcessInstanceId())) {
//                    currentContainer = ProcessDefinitionUtil.getProcess(parentExecution.getProcessDefinitionId());
//                }
//
//                if (currentContainer !is null) {
//                    for (string refId : eventMap.keySet()) {
//                        List!Event events = eventMap.get(refId);
//                        if (CollectionUtil.isNotEmpty(events) && events.get(0) instanceof StartEvent) {
//                            string refActivityId = refId.substring(0, refId.indexOf('#'));
//                            string refProcessDefinitionId = refId.substring(refId.indexOf('#') + 1);
//                            if (parentExecution.getProcessDefinitionId().equals(refProcessDefinitionId) &&
//                                            currentContainer.getFlowElement(refActivityId) !is null) {
//
//                                matchingEvent = getCatchEventFromList(events, parentExecution);
//                                string errorCode = getErrorCodeFromErrorEventDefinition(matchingEvent);
//                                if (StringUtils.isNotEmpty(errorCode)) {
//                                    break;
//                                }
//                            }
//                        }
//                    }
//                }
//
//                if (matchingEvent is null) {
//                    if (eventMap.containsKey(parentExecution.getActivityId() + "#" + parentExecution.getProcessDefinitionId())) {
//                        // Check for multi instance
//                        if (parentExecution.getParentId() !is null && parentExecution.getParent().isMultiInstanceRoot()) {
//                            parentExecution = parentExecution.getParent();
//                        }
//
//                        matchingEvent = getCatchEventFromList(eventMap.get(parentExecution.getActivityId() +
//                                        "#" + parentExecution.getProcessDefinitionId()), parentExecution);
//
//                    } else if (StringUtils.isNotEmpty(parentExecution.getParentId())) {
//                        parentExecution = parentExecution.getParent();
//
//                    } else {
//                        if (parentExecution.getProcessInstanceId().equals(parentExecution.getRootProcessInstanceId()) == false) {
//                            toDeleteProcessInstanceIds.add(parentExecution.getProcessInstanceId());
//                            parentExecution = parentExecution.getSuperExecution();
//                        } else {
//                            parentExecution = null;
//                        }
//                    }
//                }
//            }
//        }
//
//        if (matchingEvent !is null && parentExecution !is null) {
//
//            for (string processInstanceId : toDeleteProcessInstanceIds) {
//                ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
//                ExecutionEntity processInstanceEntity = executionEntityManager.findById(processInstanceId);
//
//                // Delete
//                executionEntityManager.deleteProcessInstanceExecutionEntity(processInstanceEntity.getId(),
//                                currentExecution.getCurrentFlowElement() !is null ? currentExecution.getCurrentFlowElement().getId() : null,
//                                                "ERROR_EVENT " + errorId, false, false, false);
//
//                // Event
//                ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
//                FlowableEventDispatcher eventDispatcher = null;
//                if (processEngineConfiguration !is null) {
//                    eventDispatcher = processEngineConfiguration.getEventDispatcher();
//                }
//                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
//                    processEngineConfiguration.getEventDispatcher()
//                            .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_COMPLETED_WITH_ERROR_END_EVENT, processInstanceEntity));
//                }
//            }
//
//            executeEventHandler(matchingEvent, parentExecution, currentExecution, errorId);
//
//        } else {
//            throw new FlowableException("No matching parent execution for error code " + errorId + " found");
//        }
//    }
//
//    protected static void executeEventHandler(Event event, ExecutionEntity parentExecution, ExecutionEntity currentExecution, string errorId) {
//        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
//        FlowableEventDispatcher eventDispatcher = null;
//        if (processEngineConfiguration !is null) {
//            eventDispatcher = processEngineConfiguration.getEventDispatcher();
//        }
//        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
//            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(parentExecution.getProcessDefinitionId());
//            if (bpmnModel !is null) {
//
//                string errorCode = bpmnModel.getErrors().get(errorId);
//                if (errorCode is null) {
//                    errorCode = errorId;
//                }
//
//                processEngineConfiguration.getEventDispatcher().dispatchEvent(
//                        FlowableEventBuilder.createErrorEvent(FlowableEngineEventType.ACTIVITY_ERROR_RECEIVED, event.getId(), errorId, errorCode, parentExecution.getId(),
//                                parentExecution.getProcessInstanceId(), parentExecution.getProcessDefinitionId()));
//            }
//        }
//
//        if (event instanceof StartEvent) {
//            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
//
//            if (parentExecution.isProcessInstanceType()) {
//                executionEntityManager.deleteChildExecutions(parentExecution, null, true);
//            } else if (!currentExecution.getParentId().equals(parentExecution.getId())) {
//                CommandContextUtil.getAgenda().planDestroyScopeOperation(currentExecution);
//            } else {
//                executionEntityManager.deleteExecutionAndRelatedData(currentExecution, null, false);
//            }
//
//            ExecutionEntity eventSubProcessExecution = executionEntityManager.createChildExecution(parentExecution);
//            if (event.getSubProcess() !is null) {
//                eventSubProcessExecution.setCurrentFlowElement(event.getSubProcess());
//                ExecutionEntity subProcessStartEventExecution = executionEntityManager.createChildExecution(eventSubProcessExecution);
//                subProcessStartEventExecution.setCurrentFlowElement(event);
//                CommandContextUtil.getAgenda().planContinueProcessOperation(subProcessStartEventExecution);
//
//            } else {
//                eventSubProcessExecution.setCurrentFlowElement(event);
//                CommandContextUtil.getAgenda().planContinueProcessOperation(eventSubProcessExecution);
//            }
//
//        } else {
//            ExecutionEntity boundaryExecution = null;
//            List<? : ExecutionEntity> childExecutions = parentExecution.getExecutions();
//            for (ExecutionEntity childExecution : childExecutions) {
//                if (childExecution !is null
//                        && childExecution.getActivityId() !is null
//                        && childExecution.getActivityId().equals(event.getId())) {
//                    boundaryExecution = childExecution;
//                }
//            }
//
//            CommandContextUtil.getAgenda().planTriggerExecutionOperation(boundaryExecution);
//        }
//    }
//
//    protected static Map<string, List!Event> findCatchingEventsForProcess(string processDefinitionId, string errorCode) {
//        Map<string, List!Event> eventMap = new HashMap<>();
//        Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
//        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);
//
//        string compareErrorCode = retrieveErrorCode(bpmnModel, errorCode);
//
//        List!EventSubProcess subProcesses = process.findFlowElementsOfType(EventSubProcess.class, true);
//        for (EventSubProcess eventSubProcess : subProcesses) {
//            for (FlowElement flowElement : eventSubProcess.getFlowElements()) {
//                if (flowElement instanceof StartEvent) {
//                    StartEvent startEvent = (StartEvent) flowElement;
//                    if (CollectionUtil.isNotEmpty(startEvent.getEventDefinitions()) && startEvent.getEventDefinitions().get(0) instanceof ErrorEventDefinition) {
//                        ErrorEventDefinition errorEventDef = (ErrorEventDefinition) startEvent.getEventDefinitions().get(0);
//                        string eventErrorCode = retrieveErrorCode(bpmnModel, errorEventDef.getErrorCode());
//
//                        if (eventErrorCode is null || compareErrorCode is null || eventErrorCode.equals(compareErrorCode)) {
//                            List!Event startEvents = new ArrayList<>();
//                            startEvents.add(startEvent);
//                            eventMap.put(eventSubProcess.getId() + "#" + processDefinitionId, startEvents);
//                        }
//                    }
//                }
//            }
//        }
//
//        List!BoundaryEvent boundaryEvents = process.findFlowElementsOfType(BoundaryEvent.class, true);
//        for (BoundaryEvent boundaryEvent : boundaryEvents) {
//            if (boundaryEvent.getAttachedToRefId() !is null && CollectionUtil.isNotEmpty(boundaryEvent.getEventDefinitions()) && boundaryEvent.getEventDefinitions().get(0) instanceof ErrorEventDefinition) {
//
//                ErrorEventDefinition errorEventDef = (ErrorEventDefinition) boundaryEvent.getEventDefinitions().get(0);
//                string eventErrorCode = retrieveErrorCode(bpmnModel, errorEventDef.getErrorCode());
//
//                if (eventErrorCode is null || compareErrorCode is null || eventErrorCode.equals(compareErrorCode)) {
//                    List!Event elementBoundaryEvents = null;
//                    if (!eventMap.containsKey(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId)) {
//                        elementBoundaryEvents = new ArrayList<>();
//                        eventMap.put(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId, elementBoundaryEvents);
//                    } else {
//                        elementBoundaryEvents = eventMap.get(boundaryEvent.getAttachedToRefId() + "#" + processDefinitionId);
//                    }
//                    elementBoundaryEvents.add(boundaryEvent);
//                }
//            }
//        }
//        return eventMap;
//    }
//
//    public static bool mapException(Exception e, ExecutionEntity execution, List!MapExceptionEntry exceptionMap) {
//        string errorCode = findMatchingExceptionMapping(e, exceptionMap);
//        if (errorCode !is null) {
//            propagateError(errorCode, execution);
//            return true;
//        } else {
//            ExecutionEntity callActivityExecution = null;
//            ExecutionEntity parentExecution = execution.getParent();
//            while (parentExecution !is null && callActivityExecution is null) {
//                if (parentExecution.getId().equals(parentExecution.getProcessInstanceId())) {
//                    if (parentExecution.getSuperExecution() !is null) {
//                        callActivityExecution = parentExecution.getSuperExecution();
//                    } else {
//                        parentExecution = null;
//                    }
//                } else {
//                    parentExecution = parentExecution.getParent();
//                }
//            }
//
//            if (callActivityExecution !is null) {
//                CallActivity callActivity = (CallActivity) callActivityExecution.getCurrentFlowElement();
//                if (CollectionUtil.isNotEmpty(callActivity.getMapExceptions())) {
//                    errorCode = findMatchingExceptionMapping(e, callActivity.getMapExceptions());
//                    if (errorCode !is null) {
//                        propagateError(errorCode, callActivityExecution);
//                        return true;
//                    }
//                }
//            }
//
//            return false;
//        }
//    }
//
//    public static string findMatchingExceptionMapping(Exception e, List!MapExceptionEntry exceptionMap) {
//        string defaultExceptionMapping = null;
//
//        for (MapExceptionEntry me : exceptionMap) {
//            string exceptionClass = me.getClassName();
//            string errorCode = me.getErrorCode();
//            string rootCause = me.getRootCause();
//
//            // save the first mapping with no exception class as default map
//            if (StringUtils.isNotEmpty(errorCode) && StringUtils.isEmpty(exceptionClass) && defaultExceptionMapping is null) {
//                // if rootCause is set, check if it matches the exception
//                if (StringUtils.isNotEmpty(rootCause)) {
//                    if (ExceptionUtils.getRootCause(e).getClass().getName().equals(rootCause)) {
//                        defaultExceptionMapping = errorCode;
//                        continue;
//                    }
//                } else {
//                    defaultExceptionMapping = errorCode;
//                    continue;
//                }
//            }
//
//            // ignore if error code or class are not defined
//            if (StringUtils.isEmpty(errorCode) || StringUtils.isEmpty(exceptionClass)) {
//                continue;
//            }
//
//            if (e.getClass().getName().equals(exceptionClass)) {
//                if (StringUtils.isNotEmpty(rootCause)) {
//                    if (ExceptionUtils.getRootCause(e).getClass().getName().equals(rootCause)) {
//                        return errorCode;
//                    }
//                    continue;
//                }
//                return errorCode;
//            }
//
//            if (me.isAndChildren()) {
//                Class<?> exceptionClassClass = ReflectUtil.loadClass(exceptionClass);
//                if (exceptionClassClass.isAssignableFrom(e.getClass())) {
//                    if (StringUtils.isNotEmpty(rootCause)) {
//                        if (ExceptionUtils.getRootCause(e).getClass().getName().equals(rootCause)) {
//                            return errorCode;
//                        }
//                    } else {
//                        return errorCode;
//                    }
//                }
//            }
//        }
//
//        return defaultExceptionMapping;
//    }
//
//    protected static Event getCatchEventFromList(List!Event events, ExecutionEntity parentExecution) {
//        Event selectedEvent = null;
//        string selectedEventErrorCode = null;
//
//        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(parentExecution.getProcessDefinitionId());
//        for (Event event : events) {
//            string errorCode = getErrorCodeFromErrorEventDefinition(event);
//            if (bpmnModel !is null) {
//                errorCode = retrieveErrorCode(bpmnModel, errorCode);
//            }
//
//            if (selectedEvent is null || (StringUtils.isEmpty(selectedEventErrorCode) && StringUtils.isNotEmpty(errorCode))) {
//                selectedEvent = event;
//                selectedEventErrorCode = errorCode;
//            }
//        }
//
//        return selectedEvent;
//    }
//
//    protected static string getErrorCodeFromErrorEventDefinition(Event event) {
//        for (EventDefinition eventDefinition : event.getEventDefinitions()) {
//            if (eventDefinition instanceof ErrorEventDefinition) {
//                return ((ErrorEventDefinition) eventDefinition).getErrorCode();
//            }
//        }
//
//        return null;
//    }
//
//    protected static string retrieveErrorCode(BpmnModel bpmnModel, string errorCode) {
//        string finalErrorCode = null;
//        if (errorCode !is null && bpmnModel.containsErrorRef(errorCode)) {
//            finalErrorCode = bpmnModel.getErrors().get(errorCode);
//        } else {
//            finalErrorCode = errorCode;
//        }
//        return finalErrorCode;
//    }
//}
