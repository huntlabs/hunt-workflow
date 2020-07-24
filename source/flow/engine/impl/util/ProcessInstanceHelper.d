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
module flow.engine.impl.util.ProcessInstanceHelper;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;
import flow.variable.service.api.deleg.VariableScope;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.Process;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.bpmn.model.ValuedDataObject;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scop.ScopeTypes;
//import flow.common.callback.CallbackData;
//import flow.common.callback.RuntimeInstanceStateChangeCallback;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.jobexecutor.TimerEventHandler;
import flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.runtime.callback.ProcessInstanceState;
import flow.engine.interceptor.StartProcessInstanceAfterContext;
import flow.engine.interceptor.StartProcessInstanceBeforeContext;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.constant.EventConstants;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventInstanceBpmnUtil;
import flow.engine.impl.util.CorrelationUtil;
import flow.engine.impl.util.CountingEntityUtil;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ProcessInstanceHelper {

    public ProcessInstance createProcessInstance(ProcessDefinition processDefinition, string businessKey, string processInstanceName,
                    Map!(string, Object) variables, Map!(string, Object) transientVariables) {

        return createProcessInstance(processDefinition, businessKey, processInstanceName, null, null ,
            variables, transientVariables, null, null, null, null, null, false);
    }

    public ProcessInstance createProcessInstance(ProcessDefinition processDefinition, string businessKey, string processInstanceName,
                    string overrideDefinitionTenantId, string predefinedProcessInstanceId, Map!(string, Object) variables, Map!(string, Object) transientVariables,
                    string callbackId, string callbackType, string referenceId, string referenceType, string stageInstanceId, bool startProcessInstance) {

        CommandContext commandContext = Context.getCommandContext();
        //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    return compatibilityHandler.startProcessInstance(processDefinition.getKey(), processDefinition.getId(),
        //            variables, transientVariables, businessKey, processDefinition.getTenantId(), processInstanceName);
        //}

        // Do not start process a process instance if the process definition is suspended
        //if (ProcessDefinitionUtil.isProcessDefinitionSuspended(processDefinition.getId())) {
        //    throw new FlowableException("Cannot start process instance. Process definition " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") is suspended");
        //}

        // Get model from cache
        Process process = ProcessDefinitionUtil.getProcess(processDefinition.getId());
        if (process is null) {
            throw new FlowableException("Cannot start process instance. Process model " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") could not be found");
        }

        FlowElement initialFlowElement = process.getInitialFlowElement();
        if (initialFlowElement is null) {
            throw new FlowableException("No start element found for process definition " ~ processDefinition.getId());
        }

        return createAndStartProcessInstanceWithInitialFlowElement(processDefinition, businessKey, processInstanceName, overrideDefinitionTenantId,
                        predefinedProcessInstanceId, initialFlowElement, process, variables, transientVariables,
                        callbackId, callbackType, referenceId, referenceType, stageInstanceId, startProcessInstance);
    }

    public ProcessInstance createAndStartProcessInstanceByMessage(ProcessDefinition processDefinition, string messageName, string businessKey,
            Map!(string, Object) variables, Map!(string, Object) transientVariables,
            string callbackId, string callbackType, string referenceId, string referenceType) {

        CommandContext commandContext = Context.getCommandContext();
        //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
        //    return CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler().startProcessInstanceByMessage(
        //            messageName, variables, transientVariables, businessKey, processDefinition.getTenantId());
        //}

        // Do not start process a process instance if the process definition is suspended
        if (ProcessDefinitionUtil.isProcessDefinitionSuspended(processDefinition.getId())) {
            throw new FlowableException("Cannot start process instance. Process definition " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") is suspended");
        }

        // Get model from cache
        Process process = ProcessDefinitionUtil.getProcess(processDefinition.getId());
        if (process is null) {
            throw new FlowableException("Cannot start process instance. Process model " ~ processDefinition.getName() ~ " (id = " ~ processDefinition.getId() ~ ") could not be found");
        }

        FlowElement initialFlowElement = null;
        foreach (FlowElement flowElement ; process.getFlowElements()) {
            if (cast(StartEvent)flowElement !is null) {
                StartEvent startEvent = cast(StartEvent) flowElement;
                if ((startEvent.getEventDefinitions() !is null && startEvent.getEventDefinitions().size != 0) && cast(MessageEventDefinition)(startEvent.getEventDefinitions().get(0)) !is null) {

                    MessageEventDefinition messageEventDefinition = cast(MessageEventDefinition) startEvent.getEventDefinitions().get(0);
                    if (messageEventDefinition.getMessageRef() == (messageName)) {
                        initialFlowElement = flowElement;
                        break;
                    }
                }
            }
        }
        if (initialFlowElement is null) {
            throw new FlowableException("No message start event found for process definition " ~ processDefinition.getId() ~ " and message name " ~ messageName);
        }

        return createAndStartProcessInstanceWithInitialFlowElement(processDefinition, businessKey, null, null, null, initialFlowElement,
                        process, variables, transientVariables, callbackId, callbackType, referenceId, referenceType, null, true);
    }

    public ProcessInstance createAndStartProcessInstanceWithInitialFlowElement(ProcessDefinition processDefinition,
            string businessKey, string processInstanceName, FlowElement initialFlowElement, Process process, Map!(string, Object) variables,
            Map!(string, Object) transientVariables, bool startProcessInstance) {

        return createAndStartProcessInstanceWithInitialFlowElement(processDefinition, businessKey, processInstanceName, null, null, initialFlowElement,
                        process, variables, transientVariables, null, null, null, null, null, startProcessInstance);
    }

    public ProcessInstance createAndStartProcessInstanceWithInitialFlowElement(ProcessDefinition processDefinition,
            string businessKey, string processInstanceName,
            string overrideDefinitionTenantId, string predefinedProcessInstanceId,
            FlowElement initialFlowElement, Process process,
            Map!(string, Object) variables, Map!(string, Object) transientVariables,
            string callbackId, string callbackType, string referenceId, string referenceType,
            string stageInstanceId, bool startProcessIns) {

        CommandContext commandContext = Context.getCommandContext();

        // Create the process instance
        string initiatorVariableName = null;
        if (cast(StartEvent)initialFlowElement !is null) {
            initiatorVariableName = (cast(StartEvent) initialFlowElement).getInitiator();
        }

        string tenantId;
        if (overrideDefinitionTenantId !is null && overrideDefinitionTenantId.length != 0) {
            tenantId = overrideDefinitionTenantId;
        } else {
            tenantId = processDefinition.getTenantId();
        }

        StartProcessInstanceBeforeContext startInstanceBeforeContext = new StartProcessInstanceBeforeContext(businessKey, processInstanceName,
            callbackId, callbackType, referenceId, referenceType,
            variables, transientVariables, tenantId, initiatorVariableName, initialFlowElement.getId(),
            initialFlowElement, process, processDefinition, overrideDefinitionTenantId, predefinedProcessInstanceId);

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (processEngineConfiguration.getStartProcessInstanceInterceptor() !is null) {
            processEngineConfiguration.getStartProcessInstanceInterceptor().beforeStartProcessInstance(startInstanceBeforeContext);
        }

        ExecutionEntity processInstance = CommandContextUtil.getExecutionEntityManager(commandContext)
                .createProcessInstanceExecution(startInstanceBeforeContext.getProcessDefinition(), startInstanceBeforeContext.getPredefinedProcessInstanceId(),
                        startInstanceBeforeContext.getBusinessKey(), startInstanceBeforeContext.getProcessInstanceName(),
                        startInstanceBeforeContext.getCallbackId(), startInstanceBeforeContext.getCallbackType(),
                        startInstanceBeforeContext.getReferenceId(), startInstanceBeforeContext.getReferenceType(),
                        stageInstanceId,
                        startInstanceBeforeContext.getTenantId(), startInstanceBeforeContext.getInitiatorVariableName(),
                        startInstanceBeforeContext.getInitialActivityId());

        CommandContextUtil.getHistoryManager(commandContext).recordProcessInstanceStart(processInstance);

        //if (processEngineConfiguration.isLoggingSessionEnabled()) {
        //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_PROCESS_STARTED, "Started process instance with id " + processInstance.getId(), processInstance);
        //}

        FlowableEventDispatcher eventDispatcher = processEngineConfiguration.getEventDispatcher();
        bool eventDispatcherEnabled = eventDispatcher !is null && eventDispatcher.isEnabled();
        if (eventDispatcherEnabled) {
            eventDispatcher.dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_CREATED, cast(Object)processInstance));
        }

        processInstance.setVariables(processDataObjects(process.getDataObjects()));

        // Set the variables passed into the start command
        if (startInstanceBeforeContext.getVariables() !is null) {
            foreach (MapEntry!(string,Object) varName ; startInstanceBeforeContext.getVariables()) {
              (cast(VariableScope)processInstance).setVariable(varName.getKey(), startInstanceBeforeContext.getVariables().get(varName.getKey()));
            }
        }

        if (startInstanceBeforeContext.getTransientVariables() !is null) {

            Object eventInstance = startInstanceBeforeContext.getTransientVariables().get(EventConstants.EVENT_INSTANCE);
            if (cast(EventInstance)eventInstance !is null) {
                EventInstanceBpmnUtil.handleEventInstanceOutParameters(processInstance, startInstanceBeforeContext.getInitialFlowElement(),
                                cast(EventInstance) eventInstance);
            }

            foreach (MapEntry!(string,Object) varName ; startInstanceBeforeContext.getTransientVariables()) {
                processInstance.setTransientVariable(varName.getKey(), startInstanceBeforeContext.getTransientVariables().get(varName.getKey()));
            }
        }

        // Fire events
        if (eventDispatcherEnabled) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityWithVariablesEvent(FlowableEngineEventType.ENTITY_INITIALIZED,
                            cast(Object)processInstance, startInstanceBeforeContext.getVariables(), false));
        }

        // Create the first execution that will visit all the process definition elements
        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(processInstance);
        execution.setCurrentFlowElement(startInstanceBeforeContext.getInitialFlowElement());

        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(execution);

        if (startProcessIns) {
            startProcessInstance(processInstance, commandContext, startInstanceBeforeContext.getVariables());
        }

        if (callbackId !is null) {
            callCaseInstanceStateChangeCallbacks(commandContext, processInstance, null, ProcessInstanceState.RUNNING);
        }

        if (processEngineConfiguration.getStartProcessInstanceInterceptor() !is null) {
            StartProcessInstanceAfterContext startInstanceAfterContext = new StartProcessInstanceAfterContext(processInstance, execution,
                            startInstanceBeforeContext.getVariables(), startInstanceBeforeContext.getTransientVariables(),
                            startInstanceBeforeContext.getInitialFlowElement(), startInstanceBeforeContext.getProcess(),
                            startInstanceBeforeContext.getProcessDefinition());

            processEngineConfiguration.getStartProcessInstanceInterceptor().afterStartProcessInstance(startInstanceAfterContext);
        }

        return processInstance;
    }

    public void startProcessInstance(ExecutionEntity processInstance, CommandContext commandContext, Map!(string, Object) variables) {

        Process process = ProcessDefinitionUtil.getProcess(processInstance.getProcessDefinitionId());

        processAvailableEventSubProcesses(processInstance, process, commandContext);

        ExecutionEntity execution = processInstance.getExecutions().get(0); // There will always be one child execution created
        CommandContextUtil.getAgenda(commandContext).planContinueProcessOperation(execution);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createProcessStartedEvent(cast(Object)execution, variables, false));
        }
    }

    public void processAvailableEventSubProcesses(ExecutionEntity parentExecution, FlowElementsContainer parentContainer, CommandContext commandContext) {

        foreach (FlowElement flowElement ; parentContainer.getFlowElements()) {
            if (cast(EventSubProcess)flowElement is null) {
                continue;
            }
            processEventSubProcess(parentExecution, cast(EventSubProcess) flowElement, commandContext);
        }
    }

    public void processEventSubProcess(ExecutionEntity parentExecution, EventSubProcess eventSubProcess, CommandContext commandContext) {
        List!EventSubscriptionEntity messageEventSubscriptions = new LinkedList!EventSubscriptionEntity();
        List!EventSubscriptionEntity signalEventSubscriptions = new LinkedList!EventSubscriptionEntity();

        foreach (FlowElement subElement ; eventSubProcess.getFlowElements()) {
            if (cast(StartEvent)subElement is null) {
                continue;
            }

            StartEvent startEvent = cast(StartEvent) subElement;
            if (startEvent.getEventDefinitions() is null || startEvent.getEventDefinitions().size() == 0) {
                List!ExtensionElement eventTypeElements = startEvent.getExtensionElements().get("eventType");
                if (eventTypeElements !is null && !eventTypeElements.isEmpty()) {
                    string eventType = eventTypeElements.get(0).getElementText();
                    if (eventType !is null && eventType.length != 0) {
                        ExecutionEntity eventRegistryExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parentExecution);
                        eventRegistryExecution.setCurrentFlowElement(startEvent);
                        eventRegistryExecution.setEventScope(true);
                        eventRegistryExecution.setActive(false);

                        EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                                        .eventType(eventType)
                                        .executionId(eventRegistryExecution.getId())
                                        .processInstanceId(eventRegistryExecution.getProcessInstanceId())
                                        .activityId(eventRegistryExecution.getCurrentActivityId())
                                        .processDefinitionId(eventRegistryExecution.getProcessDefinitionId())
                                        .scopeType(ScopeTypes.BPMN)
                                        .tenantId(eventRegistryExecution.getTenantId())
                                        .configuration(CorrelationUtil.getCorrelationKey(BpmnXMLConstants.ELEMENT_EVENT_CORRELATION_PARAMETER, commandContext, eventRegistryExecution))
                                        .create();

                        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
                    }
                }

                continue;
            }

            EventDefinition eventDefinition = startEvent.getEventDefinitions().get(0);
            if (cast(MessageEventDefinition)eventDefinition !is null) {
                MessageEventDefinition messageEventDefinition = cast(MessageEventDefinition) eventDefinition;
                BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(parentExecution.getProcessDefinitionId());
                if (bpmnModel.containsMessageId(messageEventDefinition.getMessageRef())) {
                    messageEventDefinition.setMessageRef(bpmnModel.getMessage(messageEventDefinition.getMessageRef()).getName());
                }

                ExecutionEntity messageExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parentExecution);
                messageExecution.setCurrentFlowElement(startEvent);
                messageExecution.setEventScope(true);
                messageExecution.setActive(false);

                EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                                .eventType(MessageEventSubscriptionEntity.EVENT_TYPE)
                                .eventName(messageEventDefinition.getMessageRef())
                                .executionId(messageExecution.getId())
                                .processInstanceId(messageExecution.getProcessInstanceId())
                                .activityId(messageExecution.getCurrentActivityId())
                                .processDefinitionId(messageExecution.getProcessDefinitionId())
                                .tenantId(messageExecution.getTenantId())
                                .create();

                CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
                messageEventSubscriptions.add(eventSubscription);
                implementationMissing(false);
               // messageExecution.getEventSubscriptions().add(eventSubscription);

            } else if (cast(SignalEventDefinition)eventDefinition !is null) {
                SignalEventDefinition signalEventDefinition = cast(SignalEventDefinition) eventDefinition;
                BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(parentExecution.getProcessDefinitionId());
                Signal signal = null;
                if (bpmnModel.containsSignalId(signalEventDefinition.getSignalRef())) {
                    signal = bpmnModel.getSignal(signalEventDefinition.getSignalRef());
                    signalEventDefinition.setSignalRef(signal.getName());
                }

                ExecutionEntity signalExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parentExecution);
                signalExecution.setCurrentFlowElement(startEvent);
                signalExecution.setEventScope(true);
                signalExecution.setActive(false);

                EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                                .eventType(SignalEventSubscriptionEntity.EVENT_TYPE)
                                .eventName(signalEventDefinition.getSignalRef())
                                .signal(signal)
                                .executionId(signalExecution.getId())
                                .processInstanceId(signalExecution.getProcessInstanceId())
                                .activityId(signalExecution.getCurrentActivityId())
                                .processDefinitionId(signalExecution.getProcessDefinitionId())
                                .tenantId(signalExecution.getTenantId())
                                .create();

                CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
                signalEventSubscriptions.add(eventSubscription);
                implementationMissing(false);
                //signalExecution.getEventSubscriptions().add(eventSubscription);

            } else if (cast(TimerEventDefinition)eventDefinition !is null) {
                implementationMissing(false);
                //TimerEventDefinition timerEventDefinition = cast(TimerEventDefinition) eventDefinition;
                //
                //ExecutionEntity timerExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parentExecution);
                //timerExecution.setCurrentFlowElement(startEvent);
                //timerExecution.setEventScope(true);
                //timerExecution.setActive(false);
                //
                //TimerJobEntity timerJob = TimerUtil.createTimerEntityForTimerEventDefinition(timerEventDefinition, false, timerExecution, TriggerTimerEventJobHandler.TYPE,
                //    TimerEventHandler.createConfiguration(startEvent.getId(), timerEventDefinition.getEndDate(), timerEventDefinition.getCalendarName()));
                //
                //if (timerJob !is null) {
                //    CommandContextUtil.getTimerJobService().scheduleTimerJob(timerJob);
                //}
            }
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            foreach (EventSubscriptionEntity messageEventSubscription ; messageEventSubscriptions) {
                CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher()
                    .dispatchEvent(FlowableEventBuilder.createMessageEvent(FlowableEngineEventType.ACTIVITY_MESSAGE_WAITING, messageEventSubscription.getActivityId(),
                        messageEventSubscription.getEventName(), null, messageEventSubscription.getExecutionId(),
                        messageEventSubscription.getProcessInstanceId(), messageEventSubscription.getProcessDefinitionId()));
            }

            foreach (EventSubscriptionEntity signalEventSubscription ; signalEventSubscriptions) {
                CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher()
                    .dispatchEvent(FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNAL_WAITING, signalEventSubscription.getActivityId(),
                        signalEventSubscription.getEventName(), null, signalEventSubscription.getExecutionId(),
                        signalEventSubscription.getProcessInstanceId(), signalEventSubscription.getProcessDefinitionId()));
            }
        }
    }

    protected Map!(string, Object) processDataObjects(Collection!ValuedDataObject dataObjects) {
        Map!(string, Object) variablesMap = new HashMap!(string, Object)();
        // convert data objects to process variables
        if (dataObjects !is null) {
            foreach (ValuedDataObject dataObject ; dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }

    public void callCaseInstanceStateChangeCallbacks(CommandContext commandContext, ProcessInstance processInstance, string oldState, string newState) {
        //if (processInstance.getCallbackId() !is null && processInstance.getCallbackType() !is null) {
        //    Map!(string, List!RuntimeInstanceStateChangeCallback) caseInstanceCallbacks = CommandContextUtil
        //            .getProcessEngineConfiguration(commandContext).getProcessInstanceStateChangedCallbacks();
        //
        //    if (caseInstanceCallbacks !is null && caseInstanceCallbacks.containsKey(processInstance.getCallbackType())) {
        //        for (RuntimeInstanceStateChangeCallback caseInstanceCallback : caseInstanceCallbacks.get(processInstance.getCallbackType())) {
        //
        //            caseInstanceCallback.stateChanged(new CallbackData(processInstance.getCallbackId(),
        //                processInstance.getCallbackType(), processInstance.getId(), oldState, newState));
        //
        //        }
        //    }
        //}
        implementationMissing(false);
    }

}
