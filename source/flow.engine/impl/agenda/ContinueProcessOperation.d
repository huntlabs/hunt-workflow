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
module flow.engine.impl.agenda.ContinueProcessOperation;

import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Iterator;
import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
//import flow.common.logging.LoggingSessionConstants;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.bpmn.behavior.BoundaryEventRegistryEventActivityBehavior;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.jobexecutor.AsyncContinuationJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.job.service.api.Job;
import flow.bpmn.model.Process;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.agenda.AbstractOperation;
import hunt.logging;
import hunt.Exceptions;

/**
 * Operation that takes the current {@link FlowElement} set on the {@link ExecutionEntity} and executes the associated {@link ActivityBehavior}. In the case of async, schedules a {@link Job}.
 *
 * Also makes sure the {@link ExecutionListener} instances are called.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ContinueProcessOperation : AbstractOperation {


    protected bool forceSynchronousOperation;
    protected bool inCompensation;

    this(CommandContext commandContext, ExecutionEntity execution,
            bool forceSynchronousOperation, bool inCompensation) {

        super(commandContext, execution);
        this.forceSynchronousOperation = forceSynchronousOperation;
        this.inCompensation = inCompensation;
    }

    this(CommandContext commandContext, ExecutionEntity execution) {
        this(commandContext, execution, false, false);
    }

    public void run() {
        FlowElement currentFlowElement = getCurrentFlowElement(execution);
        FlowNode f = cast(FlowNode)currentFlowElement;
        SequenceFlow s = cast(SequenceFlow)currentFlowElement;
        if (f !is null) {
            continueThroughFlowNode(f);
        } else if (s !is null) {
            continueThroughSequenceFlow(s);
        } else {
            throw new FlowableException("Programmatic error: no current flow element found or invalid type: ");
        }
    }

    protected void executeProcessStartExecutionListeners() {
        flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(execution.getProcessDefinitionId());
        executeExecutionListeners(process, execution.getParent(), ExecutionListener.EVENTNAME_START);
    }

    protected void continueThroughFlowNode(FlowNode flowNode) {

        execution.setActive(true);

        // Check if it's the initial flow element. If so, we must fire the execution listeners for the process too
        if (flowNode.getIncomingFlows() !is null
                && flowNode.getIncomingFlows().size() == 0
                && flowNode.getSubProcess() is null) {

            executeProcessStartExecutionListeners();
        }

        // For a subprocess, a new child execution is created that will visit the steps of the subprocess
        // The original execution that arrived here will wait until the subprocess is finished
        // and will then be used to continue the process instance.
        if (!forceSynchronousOperation && cast(SubProcess)flowNode !is null) {
            createChildExecutionForSubProcess(cast(SubProcess) flowNode);
        }

        Activity a = cast(Activity)flowNode;
        if (a !is null && a.hasMultiInstanceLoopCharacteristics()) {
            // the multi instance execution will look at async
            executeMultiInstanceSynchronous(flowNode);

        } else if (forceSynchronousOperation || !flowNode.isAsynchronous()) {
            executeSynchronous(flowNode);

        } else {
            executeAsynchronous(flowNode);
        }
    }

    protected void createChildExecutionForSubProcess(SubProcess subProcess) {
        ExecutionEntity parentScopeExecution = findFirstParentScopeExecution(execution);

        // Create the sub process execution that can be used to set variables
        // We create a new execution and delete the incoming one to have a proper scope that
        // does not conflict anything with any existing scopes

        ExecutionEntity subProcessExecution = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parentScopeExecution);
        subProcessExecution.setCurrentFlowElement(subProcess);
        subProcessExecution.setScope(true);

        CommandContextUtil.getExecutionEntityManager(commandContext).deleteRelatedDataForExecution(execution, null);
        CommandContextUtil.getExecutionEntityManager(commandContext).dele(execution);
        execution = subProcessExecution;
    }

    protected void executeSynchronous(FlowNode flowNode) {
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(execution);

        // Execution listener: event 'start'
        if (!(flowNode.getExecutionListeners().isEmpty())) {
            executeExecutionListeners(flowNode, ExecutionListener.EVENTNAME_START);
        }

        // Create any boundary events, sub process boundary events will be created from the activity behavior
        List!ExecutionEntity boundaryEventExecutions = null;
        List!BoundaryEvent boundaryEvents = null;
        Activity a = cast(Activity)flowNode;
        if (!inCompensation && a !is null) { // Only activities can have boundary events
            boundaryEvents = a.getBoundaryEvents();
            if (!boundaryEvents.isEmpty()) {
                boundaryEventExecutions = createBoundaryEvents(boundaryEvents, execution);
            }
        }

        // Execute actual behavior
        ActivityBehavior activityBehavior = cast(ActivityBehavior) flowNode.getBehavior();

        if (activityBehavior !is null) {
            executeActivityBehavior(activityBehavior, flowNode);
            executeBoundaryEvents(boundaryEvents, boundaryEventExecutions);
        } else {
            executeBoundaryEvents(boundaryEvents, boundaryEventExecutions);
            logInfo("No activityBehavior on activity '{%s}' with execution {%s}", flowNode.getId(), execution.getId());
            CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation(execution, true);
        }
    }

    protected void executeAsynchronous(FlowNode flowNode) {
        JobService jobService = CommandContextUtil.getJobService(commandContext);

        JobEntity job = jobService.createJob();
        job.setExecutionId(execution.getId());
        job.setProcessInstanceId(execution.getProcessInstanceId());
        job.setProcessDefinitionId(execution.getProcessDefinitionId());
        job.setElementId(flowNode.getId());
        job.setElementName(flowNode.getName());
        job.setJobHandlerType(AsyncContinuationJobHandler.TYPE);

        // Inherit tenant id (if applicable)
        if (execution.getTenantId() !is null) {
            job.setTenantId(execution.getTenantId());
        }

        execution.getJobs().add(job);

        jobService.createAsyncJob(job, flowNode.isExclusive());
        jobService.scheduleAsyncJob(job);

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        //if (processEngineConfiguration.isLoggingSessionEnabled()) {
        //    BpmnLoggingSessionUtil.addAsyncActivityLoggingData("Created async job for " + flowNode.getId() + ", with job id " + job.getId(),
        //                    LoggingSessionConstants.TYPE_SERVICE_TASK_ASYNC_JOB, job, flowNode, execution);
        //}
    }

    protected void executeMultiInstanceSynchronous(FlowNode flowNode) {

        // Execution listener: event 'start'
        if (!(flowNode.getExecutionListeners().isEmpty())) {
            executeExecutionListeners(flowNode, ExecutionListener.EVENTNAME_START);
        }

        if (!hasMultiInstanceRootExecution(execution, flowNode)) {
            execution = createMultiInstanceRootExecution(execution);
        }

        // Execute the multi instance behavior
        ActivityBehavior activityBehavior = cast(ActivityBehavior) flowNode.getBehavior();

        if (activityBehavior !is null) {
            executeActivityBehavior(activityBehavior, flowNode);

            if (!execution.isDeleted() && !execution.isEnded()) {
                // Create any boundary events, sub process boundary events will be created from the activity behavior
                List!ExecutionEntity boundaryEventExecutions = null;
                List!BoundaryEvent boundaryEvents = null;
                Activity a = cast(Activity)flowNode;
                if (!inCompensation && a !is null) { // Only activities can have boundary events
                    boundaryEvents = a.getBoundaryEvents();
                    if (!boundaryEvents.isEmpty()) {
                        boundaryEventExecutions = createBoundaryEvents(boundaryEvents, execution);
                    }
                }

                executeBoundaryEvents(boundaryEvents, boundaryEventExecutions);
            }

        } else {
            throw new FlowableException("Expected an activity behavior in flow node " ~ flowNode.getId());
        }
    }

    protected bool hasMultiInstanceRootExecution(ExecutionEntity execution, FlowNode flowNode) {
        ExecutionEntity currentExecution = execution.getParent();
        while (currentExecution !is null) {
            if (currentExecution.isMultiInstanceRoot() && flowNode.getId() == (currentExecution.getActivityId())) {
                return true;
            }
            currentExecution = currentExecution.getParent();
        }
        return false;
    }

    protected ExecutionEntity createMultiInstanceRootExecution(ExecutionEntity execution) {
        ExecutionEntity parentExecution = execution.getParent();
        FlowElement flowElement = execution.getCurrentFlowElement();

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
        executionEntityManager.deleteRelatedDataForExecution(execution, null);
        executionEntityManager.dele(execution);

        ExecutionEntity multiInstanceRootExecution = executionEntityManager.createChildExecution(parentExecution);
        multiInstanceRootExecution.setCurrentFlowElement(flowElement);
        multiInstanceRootExecution.setMultiInstanceRoot(true);
        multiInstanceRootExecution.setActive(false);
        return multiInstanceRootExecution;
    }

    protected void executeActivityBehavior(ActivityBehavior activityBehavior, FlowNode flowNode) {
        logInfo("Executing activityBehavior {} on activity '{%s}' with execution {%s}",flowNode.getId(), execution.getId());

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        FlowableEventDispatcher eventDispatcher = null;
        if (processEngineConfiguration !is null) {
            eventDispatcher = processEngineConfiguration.getEventDispatcher();
        }
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            Activity a = cast(Activity)flowNode;
            if (a !is null && (a.hasMultiInstanceLoopCharacteristics())) {
                processEngineConfiguration.getEventDispatcher().dispatchEvent(
                        FlowableEventBuilder.createMultiInstanceActivityEvent(FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_STARTED, flowNode.getId(),
                                flowNode.getName(), execution.getId(), execution.getProcessInstanceId(), execution.getProcessDefinitionId(), flowNode));
            }
            else {
                processEngineConfiguration.getEventDispatcher().dispatchEvent(
                        FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_STARTED, flowNode.getId(), flowNode.getName(), execution.getId(),
                                execution.getProcessInstanceId(), execution.getProcessDefinitionId(), flowNode));
            }
        }

        //if (processEngineConfiguration.isLoggingSessionEnabled()) {
        //    BpmnLoggingSessionUtil.addExecuteActivityBehaviorLoggingData(LoggingSessionConstants.TYPE_ACTIVITY_BEHAVIOR_EXECUTE,
        //                    activityBehavior, flowNode, execution);
        //}

        try {
            activityBehavior.execute(execution);
        } catch (RuntimeException e) {
            implementationMissing(false);
            //if (LogMDC.isMDCEnabled()) {
            //    LogMDC.putMDCExecution(execution);
            //}
            throw e;
        }
    }

    protected void continueThroughSequenceFlow(SequenceFlow sequenceFlow) {
        // Execution listener. Sequenceflow only 'take' makes sense ... but we've supported all three since the beginning
        if (!(sequenceFlow.getExecutionListeners().isEmpty())) {
            executeExecutionListeners(sequenceFlow, ExecutionListener.EVENTNAME_START);
            executeExecutionListeners(sequenceFlow, ExecutionListener.EVENTNAME_TAKE);
            executeExecutionListeners(sequenceFlow, ExecutionListener.EVENTNAME_END);
        }

        // Firing event that transition is being taken
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        FlowableEventDispatcher eventDispatcher = null;
        if (processEngineConfiguration !is null) {
            eventDispatcher = processEngineConfiguration.getEventDispatcher();
            //  typeid(FlowableEventDispatcher).toString;
        }
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            FlowElement sourceFlowElement = sequenceFlow.getSourceFlowElement();
            FlowElement targetFlowElement = sequenceFlow.getTargetFlowElement();
            processEngineConfiguration.getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createSequenceFlowTakenEvent(
                            execution,
                            FlowableEngineEventType.SEQUENCEFLOW_TAKEN,
                            sequenceFlow.getId(),
                            sourceFlowElement !is null ? sourceFlowElement.getId() : "",
                            sourceFlowElement !is null ? sourceFlowElement.getName() : "",
                            sourceFlowElement !is null ? typeid(FlowElement).toString : "",
                            sourceFlowElement !is null ? (cast(FlowNode) sourceFlowElement).getBehavior() : null,
                            targetFlowElement !is null ? targetFlowElement.getId() : "",
                            targetFlowElement !is null ? targetFlowElement.getName() : "",
                            targetFlowElement !is null ?  typeid(FlowElement).toString: "",
                            targetFlowElement !is null ? (cast(FlowNode) targetFlowElement).getBehavior() : null));
        }

        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordSequenceFlowTaken(execution);

        FlowElement targetFlowElement = sequenceFlow.getTargetFlowElement();
        execution.setCurrentFlowElement(targetFlowElement);

        logInfo("Sequence flow '{%s}' encountered. Continuing process by following it using execution {%s}", sequenceFlow.getId(), execution.getId());

        execution.setActive(false);
        //agenda.planContinueProcessOperation(execution);

        FlowNode f = cast(FlowNode)targetFlowElement;
        if (f !is null) {
            continueThroughFlowNode(f);
        } else {
            agenda.planContinueProcessOperation(execution);
        }
    }

    protected List!ExecutionEntity createBoundaryEvents(List!BoundaryEvent boundaryEvents, ExecutionEntity execution) {

        List!ExecutionEntity boundaryEventExecutions = new ArrayList!ExecutionEntity(boundaryEvents.size());

        // The parent execution becomes a scope, and a child execution is created for each of the boundary events
        foreach (BoundaryEvent boundaryEvent ; boundaryEvents) {

            if (cast(BoundaryEventRegistryEventActivityBehavior)(boundaryEvent.getBehavior()) is null) {
                if (!(boundaryEvent.getEventDefinitions().isEmpty())
                        || cast(CompensateEventDefinition)(boundaryEvent.getEventDefinitions().get(0)) !is null) {
                    continue;
                }
            }

            // A Child execution of the current execution is created to represent the boundary event being active
            ExecutionEntity childExecutionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(execution);
            childExecutionEntity.setParentId(execution.getId());
            childExecutionEntity.setCurrentFlowElement(boundaryEvent);
            childExecutionEntity.setScope(false);
            boundaryEventExecutions.add(childExecutionEntity);

            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
            //if (processEngineConfiguration.isLoggingSessionEnabled()) {
            //    BpmnLoggingSessionUtil.addLoggingData(BpmnLoggingSessionUtil.getBoundaryCreateEventType(boundaryEvent),
            //                    "Creating boundary event (" + BpmnLoggingSessionUtil.getBoundaryEventType(boundaryEvent) +
            //                    ") for execution id " + childExecutionEntity.getId(), childExecutionEntity);
            //}
        }

        return boundaryEventExecutions;
    }

    protected void executeBoundaryEvents(List!BoundaryEvent boundaryEvents, List!ExecutionEntity boundaryEventExecutions) {
        if (!(boundaryEventExecutions.isEmpty())) {
            Iterator!BoundaryEvent boundaryEventsIterator = boundaryEvents.iterator();
            Iterator!ExecutionEntity boundaryEventExecutionsIterator = boundaryEventExecutions.iterator();

            while (boundaryEventsIterator.hasNext() && boundaryEventExecutionsIterator.hasNext()) {
                BoundaryEvent boundaryEvent = boundaryEventsIterator.next();
                ExecutionEntity boundaryEventExecution = boundaryEventExecutionsIterator.next();
                ActivityBehavior boundaryEventBehavior = (cast(ActivityBehavior) boundaryEvent.getBehavior());
                logInfo("Executing boundary event activityBehavior {} with execution {%s}", boundaryEventExecution.getId());
                boundaryEventBehavior.execute(boundaryEventExecution);
            }
        }
    }
}
