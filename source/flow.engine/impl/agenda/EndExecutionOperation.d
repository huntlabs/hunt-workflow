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
module flow.engine.impl.agenda.EndExecutionOperation;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.EndEvent;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Process;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.Transaction;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.CommandContext;
//import flow.common.util.CollectionUtil;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.jobexecutor.AsyncCompleteCallActivityJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.agenda.AbstractOperation;
import hunt.logging;
import hunt.Exceptions;
/**
 * This operations ends an execution and follows the typical BPMN rules to continue the process (if possible).
 *
 * This operations is typically not scheduled from an {@link ActivityBehavior}, but rather from another operation.
 * This happens when the conditions are so that the process can't continue via the
 * regular ways and an execution cleanup needs to happen, potentially opening up new ways of continuing the process instance.
 *
 * @author Joram Barrez
 */
class EndExecutionOperation : AbstractOperation {

    protected bool forceSynchronous;

    this(CommandContext commandContext, ExecutionEntity execution) {
        super(commandContext, execution);
    }

    this(CommandContext commandContext, ExecutionEntity execution, bool forceSynchronous) {
        this(commandContext, execution);
        this.forceSynchronous = forceSynchronous;
    }

    public void run() {
        if (execution.isProcessInstanceType()) {
            handleProcessInstanceExecution(execution);
        } else {
            handleRegularExecution();
        }
    }

    protected void handleProcessInstanceExecution(ExecutionEntity processInstanceExecution) {
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        string processInstanceId = processInstanceExecution.getId(); // No parent execution == process instance id
       // LOGGER.debug("No parent execution found. Verifying if process instance {} can be stopped.", processInstanceId);
         logInfo("No parent execution found. Verifying if process instance {%s} can be stopped. ",processInstanceId);

        ExecutionEntity superExecution = processInstanceExecution.getSuperExecution();
        if (!forceSynchronous && isAsyncCompleteCallActivity(superExecution)) {
            scheduleAsyncCompleteCallActivity(superExecution, processInstanceExecution);
            return;
        }

        // copy variables before destroying the ended sub process instance (call activity)
        SubProcessActivityBehavior subProcessActivityBehavior = null;
        if (superExecution !is null) {
            FlowNode superExecutionElement = cast(FlowNode) superExecution.getCurrentFlowElement();
            subProcessActivityBehavior = cast(SubProcessActivityBehavior) superExecutionElement.getBehavior();
            try {
                subProcessActivityBehavior.completing(superExecution, processInstanceExecution);
            } catch (RuntimeException e) {
                logError("Error while completing sub process of execution {%s}", e.msg);
                throw e;
            } catch (Exception e) {
              logError("Error while completing sub process of execution {%s}", e.msg);
                throw new FlowableException("Error while completing sub process of execution " ~  e.msg);
            }
        }

        int activeExecutions = getNumberOfActiveChildExecutionsForProcessInstance(executionEntityManager, processInstanceId);
        if (activeExecutions == 0) {
            logInfo("No active executions found. Ending process instance {%s}", processInstanceId);

            // note the use of execution here vs processinstance execution for getting the flow element
            executionEntityManager.deleteProcessInstanceExecutionEntity(processInstanceId,
                    execution.getCurrentFlowElement() !is null ? execution.getCurrentFlowElement().getId() : null, null, false, false, true);
        } else {
          logInfo("Active executions found. Process instance {%s} will not be ended.", processInstanceId);
        }

        Process process = ProcessDefinitionUtil.getProcess(processInstanceExecution.getProcessDefinitionId());

        // Execute execution listeners for process end.
        if (!(process.getExecutionListeners().isEmpty())) {
            executeExecutionListeners(process, processInstanceExecution, ExecutionListener.EVENTNAME_END);
        }

        // and trigger execution afterwards if doing a call activity
        if (superExecution !is null) {
            superExecution.setSubProcessInstance(null);
            try {
                subProcessActivityBehavior.completed(superExecution);
            } catch (RuntimeException e) {
              logError("Error while completing sub process of execution {%s}", e.msg);
                throw e;
            } catch (Exception e) {
              logError("Error while completing sub process of execution {%s}", e.msg);
                throw new FlowableException("Error while completing sub process of execution " ~ e.msg);
            }

        }
    }

    protected bool isAsyncCompleteCallActivity(ExecutionEntity superExecution) {
        if (superExecution !is null) {
            FlowNode superExecutionFlowNode = cast(FlowNode) superExecution.getCurrentFlowElement();
             CallActivity callActivity = cast(CallActivity) superExecutionFlowNode;
            if (callActivity !is null) {
                return callActivity.isCompleteAsync();
            }
        }
        return false;
    }

    protected void scheduleAsyncCompleteCallActivity(ExecutionEntity superExecutionEntity, ExecutionEntity childProcessInstanceExecutionEntity) {
        JobService jobService = CommandContextUtil.getJobService(commandContext);

        JobEntity job = jobService.createJob();

        // Needs to be the parent process instance, as the parent needs to be locked to avoid concurrency when multiple call activities are ended
        job.setExecutionId(superExecutionEntity.getId());

        // Child execution of subprocess is passed as configuration
        job.setJobHandlerConfiguration(childProcessInstanceExecutionEntity.getId());

        string processInstanceId = superExecutionEntity.getProcessInstanceId().length != 0 ? superExecutionEntity.getProcessInstanceId() : superExecutionEntity.getId();
        job.setProcessInstanceId(processInstanceId);
        job.setProcessDefinitionId(childProcessInstanceExecutionEntity.getProcessDefinitionId());
        job.setElementId(superExecutionEntity.getCurrentFlowElement().getId());
        job.setElementName(superExecutionEntity.getCurrentFlowElement().getName());
        job.setTenantId(childProcessInstanceExecutionEntity.getTenantId());
        job.setJobHandlerType(AsyncCompleteCallActivityJobHandler.TYPE);

        superExecutionEntity.getJobs().add(job);

        jobService.createAsyncJob(job, true); // Always exclusive to avoid concurrency problems
        jobService.scheduleAsyncJob(job);
    }

    protected void handleRegularExecution() {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        // There will be a parent execution (or else we would be in the process instance handling method)
        ExecutionEntity parentExecution = executionEntityManager.findById(execution.getParentId());

        // If the execution is a scope, all the child executions must be deleted first.
        if (execution.isScope()) {
            executionEntityManager.deleteChildExecutions(execution, null, false);
        }

        // Delete current execution
        logInfo("Ending execution {%s}", execution.getId());
        executionEntityManager.deleteExecutionAndRelatedData(execution, null, false);

        logInfo("Parent execution found. Continuing process using execution {%s}", parentExecution.getId());

        // When ending an execution in a multi instance subprocess , special care is needed
        if (isEndEventInMultiInstanceSubprocess(execution)) {
            handleMultiInstanceSubProcess(executionEntityManager, parentExecution);
            return;
        }

        SubProcess subProcess = execution.getCurrentFlowElement().getSubProcess();
        EventSubProcess eventSubProcess = cast(EventSubProcess) subProcess;
        if (eventSubProcess !is null) {
            bool hasNonInterruptingStartEvent = false;
            foreach (FlowElement eventSubElement ; eventSubProcess.getFlowElements()) {
                 StartEvent subStartEvent = cast(StartEvent) eventSubElement;
                if (subStartEvent !is null) {
                    if (!subStartEvent.isInterrupting()) {
                        hasNonInterruptingStartEvent = true;
                        break;
                    }
                }
            }

            if (hasNonInterruptingStartEvent) {
                executionEntityManager.deleteChildExecutions(parentExecution, null, false);
                executionEntityManager.deleteExecutionAndRelatedData(parentExecution, null, false);

                CommandContextUtil.getEventDispatcher(commandContext).dispatchEvent(
                        FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_COMPLETED, subProcess.getId(), subProcess.getName(),
                                parentExecution.getId(), parentExecution.getProcessInstanceId(), parentExecution.getProcessDefinitionId(), subProcess));

                ExecutionEntity subProcessParentExecution = parentExecution.getParent();
                if (getNumberOfActiveChildExecutionsForExecution(executionEntityManager, subProcessParentExecution.getId()) == 0) {
                    SubProcess parentSubProcess = cast(SubProcess) subProcessParentExecution.getCurrentFlowElement();
                    if (parentSubProcess !is null) {
                        if (parentSubProcess.getOutgoingFlows().size() > 0) {
                            ExecutionEntity executionToContinue = handleSubProcessEnd(executionEntityManager, subProcessParentExecution, parentSubProcess);
                            agenda.planTakeOutgoingSequenceFlowsOperation(executionToContinue, true);
                            return;
                        }

                    }

                    agenda.planEndExecutionOperation(subProcessParentExecution);
                }

                return;
            }
        }

        // If there are no more active child executions, the process can be continued
        // If not (eg an embedded subprocess still has active elements, we cannot continue)
        List!ExecutionEntity eventScopeExecutions = getEventScopeExecutions(executionEntityManager, parentExecution);

        // Event scoped executions need to be deleted when there are no active siblings anymore,
        // unless instances of the event subprocess itself. If there are no active siblings anymore,
        // the current scope had ended and the event subprocess start event should stop listening to any trigger.
        if (!eventScopeExecutions.isEmpty()) {
            List!ExecutionEntity childExecutions = parentExecution.getExecutions();
            bool activeSiblings = false;
            foreach (ExecutionEntity childExecutionEntity ; childExecutions) {
                if (!isInEventSubProcess(childExecutionEntity) && childExecutionEntity.isActive() && !childExecutionEntity.isEnded()) {
                    activeSiblings = true;
                }
            }

            if (!activeSiblings) {
                foreach (ExecutionEntity eventScopeExecution ; eventScopeExecutions) {
                    executionEntityManager.deleteExecutionAndRelatedData(eventScopeExecution, null, false);
                }
            }
        }

        if (getNumberOfActiveChildExecutionsForExecution(executionEntityManager, parentExecution.getId()) == 0) {

            ExecutionEntity executionToContinue = null;

            if (subProcess !is null) {

                // In case of ending a subprocess: go up in the scopes and continue via the parent scope
                // unless its a compensation, then we don't need to do anything and can just end it

                if (subProcess.isForCompensation()) {
                    agenda.planEndExecutionOperation(parentExecution);
                } else {
                    executionToContinue = handleSubProcessEnd(executionEntityManager, parentExecution, subProcess);
                }

            } else {

                // In the 'regular' case (not being in a subprocess), we use the parent execution to
                // continue process instance execution

                executionToContinue = handleRegularExecutionEnd(executionEntityManager, parentExecution);
            }

            if (executionToContinue !is null) {
                // only continue with outgoing sequence flows if the execution is
                // not the process instance root execution (otherwise the process instance is finished)
                if (executionToContinue.isProcessInstanceType()) {
                    handleProcessInstanceExecution(executionToContinue);

                } else {
                    agenda.planTakeOutgoingSequenceFlowsOperation(executionToContinue, true);
                }
            }

        }
    }

    protected ExecutionEntity handleSubProcessEnd(ExecutionEntityManager executionEntityManager, ExecutionEntity parentExecution, SubProcess subProcess) {

        ExecutionEntity executionToContinue = null;
        // create a new execution to take the outgoing sequence flows
        executionToContinue = executionEntityManager.createChildExecution(parentExecution.getParent());
        executionToContinue.setCurrentFlowElement(subProcess);
        executionToContinue.setActive(false);

        bool hasCompensation = false;
        if ( cast(Transaction)subProcess !is null) {
            hasCompensation = true;
        } else {
            foreach (FlowElement subElement ; subProcess.getFlowElements()) {
                Activity subActivity = cast(Activity) subElement;
                if (subActivity !is null) {
                    if (!subActivity.getBoundaryEvents().isEmpty) {
                        foreach (BoundaryEvent boundaryEvent ; subActivity.getBoundaryEvents()) {
                            if (!boundaryEvent.getEventDefinitions().isEmpty &&
                            (cast (CompensateEventDefinition)boundaryEvent.getEventDefinitions().get(0)) !is null) {

                                hasCompensation = true;
                                break;
                            }
                        }
                    }
                }
            }
        }

        // All executions will be cleaned up afterwards. However, for compensation we need
        // a copy of these executions so we can use them later on when the compensation is thrown.
        // The following method does exactly that, and moves the executions beneath the process instance.
        if (hasCompensation) {
            ScopeUtil.createCopyOfSubProcessExecutionForCompensation(parentExecution);
        }

        executionEntityManager.deleteChildExecutions(parentExecution, null, false);
        executionEntityManager.deleteExecutionAndRelatedData(parentExecution, null, false);

        CommandContextUtil.getEventDispatcher(commandContext).dispatchEvent(
                FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_COMPLETED, subProcess.getId(), subProcess.getName(),
                        parentExecution.getId(), parentExecution.getProcessInstanceId(), parentExecution.getProcessDefinitionId(), subProcess));
        return executionToContinue;
    }

    protected ExecutionEntity handleRegularExecutionEnd(ExecutionEntityManager executionEntityManager, ExecutionEntity parentExecution) {
        ExecutionEntity executionToContinue = null;

        if (!parentExecution.isProcessInstanceType()
                && cast(SubProcess)(parentExecution.getCurrentFlowElement()) is null) {
            parentExecution.setCurrentFlowElement(execution.getCurrentFlowElement());
        }

         SubProcess currentSubProcess = cast(SubProcess) execution.getCurrentFlowElement();
        if (currentSubProcess !is null) {
            if (currentSubProcess.getOutgoingFlows().size() > 0) {
                // create a new execution to take the outgoing sequence flows
                executionToContinue = executionEntityManager.createChildExecution(parentExecution);
                executionToContinue.setCurrentFlowElement(execution.getCurrentFlowElement());

            } else {
                if (parentExecution.getId() != (parentExecution.getProcessInstanceId())) {
                    // create a new execution to take the outgoing sequence flows
                    executionToContinue = executionEntityManager.createChildExecution(parentExecution.getParent());
                    executionToContinue.setCurrentFlowElement(parentExecution.getCurrentFlowElement());

                    executionEntityManager.deleteChildExecutions(parentExecution, null, false);
                    executionEntityManager.deleteExecutionAndRelatedData(parentExecution, null, false);

                } else {
                    executionToContinue = parentExecution;
                }
            }

        } else {
            executionToContinue = parentExecution;
        }
        return executionToContinue;
    }

    protected void handleMultiInstanceSubProcess(ExecutionEntityManager executionEntityManager, ExecutionEntity parentExecution) {
        List!ExecutionEntity activeChildExecutions = getActiveChildExecutionsForExecution(executionEntityManager, parentExecution.getId());
        bool containsOtherChildExecutions = false;
        foreach (ExecutionEntity activeExecution ; activeChildExecutions) {
            if (activeExecution.getId() != (execution.getId())) {
                containsOtherChildExecutions = true;
            }
        }

        if (!containsOtherChildExecutions) {

            // Destroy the current scope (subprocess) and leave via the subprocess

            ScopeUtil.createCopyOfSubProcessExecutionForCompensation(parentExecution);
            agenda.planDestroyScopeOperation(parentExecution);

            SubProcess subProcess = execution.getCurrentFlowElement().getSubProcess();
            MultiInstanceActivityBehavior multiInstanceBehavior = cast(MultiInstanceActivityBehavior) subProcess.getBehavior();
            parentExecution.setCurrentFlowElement(subProcess);
            multiInstanceBehavior.leave(parentExecution);
        }
    }

    protected bool isEndEventInMultiInstanceSubprocess(ExecutionEntity executionEntity) {
        EndEvent e =  cast(EndEvent)executionEntity.getCurrentFlowElement();
        if (e !is null) {
            SubProcess subProcess = e.getSubProcess();
            return !executionEntity.getParent().isProcessInstanceType()
                    && subProcess !is null
                    && subProcess.getLoopCharacteristics() !is null
                    && cast(MultiInstanceActivityBehavior)subProcess.getBehavior() !is null;
        }
        return false;
    }

    protected int getNumberOfActiveChildExecutionsForProcessInstance(ExecutionEntityManager executionEntityManager, string processInstanceId) {
        Collection!ExecutionEntity executions = executionEntityManager.findChildExecutionsByProcessInstanceId(processInstanceId);
        int activeExecutions = 0;
        foreach (ExecutionEntity execution ; executions) {
            if (execution.isActive() && processInstanceId != (execution.getId())) {
                activeExecutions++;
            }
        }
        return activeExecutions;
    }

    protected int getNumberOfActiveChildExecutionsForExecution(ExecutionEntityManager executionEntityManager, string executionId) {
        List!ExecutionEntity executions = executionEntityManager.findChildExecutionsByParentExecutionId(executionId);
        int activeExecutions = 0;

        // Filter out the boundary events
        foreach (ExecutionEntity activeExecution ; executions) {
            if (cast(BoundaryEvent)(activeExecution.getCurrentFlowElement()) is null) {
                activeExecutions++;
            }
        }

        return activeExecutions;
    }

    protected List!ExecutionEntity getActiveChildExecutionsForExecution(ExecutionEntityManager executionEntityManager, string executionId) {
        List!ExecutionEntity activeChildExecutions = new ArrayList!ExecutionEntity();
        List!ExecutionEntity executions = executionEntityManager.findChildExecutionsByParentExecutionId(executionId);

        foreach (ExecutionEntity activeExecution ; executions) {
            if (cast(BoundaryEvent)(activeExecution.getCurrentFlowElement()) is null) {
                activeChildExecutions.add(activeExecution);
            }
        }

        return activeChildExecutions;
    }

    protected List!ExecutionEntity getEventScopeExecutions(ExecutionEntityManager executionEntityManager, ExecutionEntity parentExecution) {
        List!ExecutionEntity eventScopeExecutions = new ArrayList!ExecutionEntity(1);
        List!ExecutionEntity executions = executionEntityManager.findChildExecutionsByParentExecutionId(parentExecution.getId());
        foreach (ExecutionEntity childExecution ; executions) {
            if (childExecution.isEventScope()) {
                eventScopeExecutions.add(childExecution);

            }
        }
        return eventScopeExecutions;
    }

    protected bool allChildExecutionsEnded(ExecutionEntity parentExecutionEntity, ExecutionEntity executionEntityToIgnore) {
        foreach (ExecutionEntity childExecutionEntity ; parentExecutionEntity.getExecutions()) {
            if (executionEntityToIgnore is null || executionEntityToIgnore.getId() != (childExecutionEntity.getId())) {
                if (!childExecutionEntity.isEnded()) {
                    return false;
                }
                if (childExecutionEntity.getExecutions() !is null && childExecutionEntity.getExecutions().size() > 0) {
                    if (!allChildExecutionsEnded(childExecutionEntity, executionEntityToIgnore)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    protected bool isInEventSubProcess(ExecutionEntity executionEntity) {
        ExecutionEntity currentExecutionEntity = executionEntity;
        while (currentExecutionEntity !is null) {
            if (cast(EventSubProcess)(currentExecutionEntity.getCurrentFlowElement()) !is null) {
                return true;
            }
            currentExecutionEntity = currentExecutionEntity.getParent();
        }
        return false;
    }

}
