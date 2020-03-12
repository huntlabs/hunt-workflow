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

import flow.bpmn.model.CallActivity;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowElementsContainer;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clock;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.history.DeleteReason;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Joram Barrez
 */
class TerminateEndEventActivityBehavior extends FlowNodeActivityBehavior {

    private static final Logger LOGGER = LoggerFactory.getLogger(TerminateEndEventActivityBehavior.class);

    private static final long serialVersionUID = 1L;

    protected bool terminateAll;
    protected bool terminateMultiInstance;

    public TerminateEndEventActivityBehavior() {

    }

    @Override
    public void execute(DelegateExecution execution) {

        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        // The current execution always stops here
        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        executionEntityManager.deleteExecutionAndRelatedData(executionEntity, createDeleteReason(executionEntity.getCurrentActivityId()), false);

        if (terminateAll) {
            terminateAllBehaviour(executionEntity, commandContext, executionEntityManager);
        } else if (terminateMultiInstance) {
            terminateMultiInstanceRoot(executionEntity, commandContext, executionEntityManager);
        } else {
            defaultTerminateEndEventBehaviour(executionEntity, commandContext, executionEntityManager);
        }
    }

    protected void terminateAllBehaviour(ExecutionEntity execution, CommandContext commandContext, ExecutionEntityManager executionEntityManager) {
        ExecutionEntity rootExecutionEntity = executionEntityManager.findByRootProcessInstanceId(execution.getRootProcessInstanceId());
        string deleteReason = createDeleteReason(execution.getCurrentActivityId());
        deleteExecutionEntities(executionEntityManager, rootExecutionEntity, execution, deleteReason);
        endAllHistoricActivities(rootExecutionEntity.getId(), deleteReason);
        CommandContextUtil.getHistoryManager(commandContext).recordProcessInstanceEnd(rootExecutionEntity,
                deleteReason, execution.getCurrentActivityId(), commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());
    }

    protected void defaultTerminateEndEventBehaviour(ExecutionEntity execution, CommandContext commandContext,
            ExecutionEntityManager executionEntityManager) {

        ExecutionEntity scopeExecutionEntity = executionEntityManager.findFirstScope(execution);

        // If the scope is the process instance, we can just terminate it all
        // Special treatment is needed when the terminated activity is a subprocess (embedded/callactivity/..)
        // The subprocess is destroyed, but the execution calling it, continues further on.
        // In case of a multi-instance subprocess, only one instance is terminated, the other instances continue to exist.

        string deleteReason = createDeleteReason(execution.getCurrentActivityId());

        if (scopeExecutionEntity.isProcessInstanceType() && scopeExecutionEntity.getSuperExecutionId() is null) {
            endAllHistoricActivities(scopeExecutionEntity.getId(), deleteReason);
            deleteExecutionEntities(executionEntityManager, scopeExecutionEntity, execution, deleteReason);
            CommandContextUtil.getHistoryManager(commandContext).recordProcessInstanceEnd(scopeExecutionEntity, deleteReason, execution.getCurrentActivityId(),
                commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());

        } else if (scopeExecutionEntity.getCurrentFlowElement() !is null
                && scopeExecutionEntity.getCurrentFlowElement() instanceof SubProcess) { // SubProcess

            SubProcess subProcess = (SubProcess) scopeExecutionEntity.getCurrentFlowElement();

            scopeExecutionEntity.setDeleteReason(deleteReason);
            if (subProcess.hasMultiInstanceLoopCharacteristics()) {
                CommandContextUtil.getAgenda(commandContext).planDestroyScopeOperation(scopeExecutionEntity);
                MultiInstanceActivityBehavior multiInstanceBehavior = (MultiInstanceActivityBehavior) subProcess.getBehavior();
                multiInstanceBehavior.leave(scopeExecutionEntity);

            } else {
                CommandContextUtil.getAgenda(commandContext).planDestroyScopeOperation(scopeExecutionEntity);
                ExecutionEntity outgoingFlowExecution = executionEntityManager.createChildExecution(scopeExecutionEntity.getParent());
                outgoingFlowExecution.setCurrentFlowElement(scopeExecutionEntity.getCurrentFlowElement());
                CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation(outgoingFlowExecution, true);
            }

        } else if (scopeExecutionEntity.getParentId() is null
                && scopeExecutionEntity.getSuperExecutionId() !is null) { // CallActivity

            ExecutionEntity callActivityExecution = scopeExecutionEntity.getSuperExecution();
            CallActivity callActivity = (CallActivity) callActivityExecution.getCurrentFlowElement();

            SubProcessActivityBehavior subProcessActivityBehavior = null;

            // copy variables before destroying the ended sub process instance (call activity)
            subProcessActivityBehavior = (SubProcessActivityBehavior) callActivity.getBehavior();
            try {
                subProcessActivityBehavior.completing(callActivityExecution, scopeExecutionEntity);
            } catch (RuntimeException e) {
                LOGGER.error("Error while completing sub process of execution {}", scopeExecutionEntity, e);
                throw e;
            } catch (Exception e) {
                LOGGER.error("Error while completing sub process of execution {}", scopeExecutionEntity, e);
                throw new FlowableException("Error while completing sub process of execution " + scopeExecutionEntity, e);
            }

            if (callActivity.hasMultiInstanceLoopCharacteristics()) {

                sendProcessInstanceCompletedEvent(scopeExecutionEntity, execution.getCurrentFlowElement());
                MultiInstanceActivityBehavior multiInstanceBehavior = (MultiInstanceActivityBehavior) callActivity.getBehavior();
                multiInstanceBehavior.leave(callActivityExecution);
                executionEntityManager.deleteProcessInstanceExecutionEntity(scopeExecutionEntity.getId(),
                                execution.getCurrentFlowElement().getId(), "terminate end event", false, false, false);

            } else {
                sendProcessInstanceCompletedEvent(scopeExecutionEntity, execution.getCurrentFlowElement());
                executionEntityManager.deleteProcessInstanceExecutionEntity(scopeExecutionEntity.getId(),
                                execution.getCurrentFlowElement().getId(), "terminate end event", false, false, false);
                ExecutionEntity superExecutionEntity = executionEntityManager.findById(scopeExecutionEntity.getSuperExecutionId());
                CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation(superExecutionEntity, true);

            }

        }
    }

    protected void endAllHistoricActivities(string processInstanceId, string deleteReason) {

        if (!CommandContextUtil.getProcessEngineConfiguration().getHistoryLevel().isAtLeast(HistoryLevel.ACTIVITY)) {
            return;
        }

        List<HistoricActivityInstanceEntity> historicActivityInstances = CommandContextUtil.getHistoricActivityInstanceEntityManager()
                .findUnfinishedHistoricActivityInstancesByProcessInstanceId(processInstanceId);

        Clock clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        for (HistoricActivityInstanceEntity historicActivityInstance : historicActivityInstances) {
            historicActivityInstance.markEnded(deleteReason, clock.getCurrentTime());

            // Fire event
            ProcessEngineConfigurationImpl config = CommandContextUtil.getProcessEngineConfiguration();
            FlowableEventDispatcher eventDispatcher = null;
            if (config !is null) {
                eventDispatcher = config.getEventDispatcher();
            }
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_ENDED, historicActivityInstance));
            }
        }

    }

    protected void terminateMultiInstanceRoot(ExecutionEntity execution, CommandContext commandContext,
            ExecutionEntityManager executionEntityManager) {

        // When terminateMultiInstance is 'true', we look for the multi instance root and delete it from there.
        ExecutionEntity miRootExecutionEntity = executionEntityManager.findFirstMultiInstanceRoot( execution);
        if (miRootExecutionEntity !is null) {

            // Create sibling execution to continue process instance execution before deletion
            ExecutionEntity siblingExecution = executionEntityManager.createChildExecution(miRootExecutionEntity.getParent());
            siblingExecution.setCurrentFlowElement(miRootExecutionEntity.getCurrentFlowElement());

            deleteExecutionEntities(executionEntityManager, miRootExecutionEntity, execution, createDeleteReason(miRootExecutionEntity.getActivityId()));

            CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation(siblingExecution, true);
        } else {
            defaultTerminateEndEventBehaviour(execution, commandContext, executionEntityManager);
        }
    }

    protected void deleteExecutionEntities(ExecutionEntityManager executionEntityManager, ExecutionEntity rootExecutionEntity,
                    ExecutionEntity executionAtTerminateEndEvent, string deleteReason) {

        FlowElement terminateEndEvent = executionAtTerminateEndEvent.getCurrentFlowElement();

        List<ExecutionEntity> childExecutions = executionEntityManager.collectChildren(rootExecutionEntity);
        for (ExecutionEntity childExecution : childExecutions) {
            if (childExecution.isProcessInstanceType()) {
                sendProcessInstanceCompletedEvent(childExecution, terminateEndEvent);
            }
        }

        CommandContextUtil.getExecutionEntityManager().deleteChildExecutions(rootExecutionEntity, null, null, deleteReason, true, terminateEndEvent);
        sendProcessInstanceCompletedEvent(rootExecutionEntity, terminateEndEvent);
        executionEntityManager.deleteExecutionAndRelatedData(rootExecutionEntity, deleteReason, false);
    }

    protected void sendProcessInstanceCompletedEvent(ExecutionEntity execution, FlowElement terminateEndEvent) {
        Process process = ProcessDefinitionUtil.getProcess(execution.getProcessDefinitionId());
        CommandContextUtil.getProcessEngineConfiguration().getListenerNotificationHelper()
            .executeExecutionListeners(process, execution, ExecutionListener.EVENTNAME_END);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            if ((execution.isProcessInstanceType() && execution.getSuperExecutionId() is null) ||
                    (execution.getParentId() is null && execution.getSuperExecutionId() !is null)) {

                // This event should only be fired if terminate end event is part of the process definition for the process instance execution,
                // otherwise a regular cancel event of the process instance will be fired (see above).
                bool fireEvent = true;
                if (!terminateAll) {
                    Process processForExecution = ProcessDefinitionUtil.getProcess(execution.getProcessDefinitionId());
                    Process processForTerminateEndEvent = getProcessForTerminateEndEvent(terminateEndEvent);
                    fireEvent = processForExecution.getId().equals(processForTerminateEndEvent.getId());
                }

                if (fireEvent) {
                    eventDispatcher
                        .dispatchEvent(FlowableEventBuilder.createTerminateEvent(execution, terminateEndEvent));
                }

            }
        }

    }

    protected Process getProcessForTerminateEndEvent(FlowElement terminateEndEvent) {
        FlowElementsContainer parent = terminateEndEvent.getParentContainer();
        while (!(parent instanceof Process)) {
            // FlowElementsContainer can only be Process or SubProcess (and its subtypes)
            SubProcess subProcess = (SubProcess) parent;
            parent = subProcess.getParentContainer();
        }
        return (Process) parent;
    }

    protected string createDeleteReason(string activityId) {
        return DeleteReason.TERMINATE_END_EVENT + " (" + activityId + ")";
    }

    public bool isTerminateAll() {
        return terminateAll;
    }

    public void setTerminateAll(bool terminateAll) {
        this.terminateAll = terminateAll;
    }

    public bool isTerminateMultiInstance() {
        return terminateMultiInstance;
    }

    public void setTerminateMultiInstance(bool terminateMultiInstance) {
        this.terminateMultiInstance = terminateMultiInstance;
    }

}
