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
module flow.engine.impl.util.TaskHelper;


import flow.engine.impl.util.CommandContextUtil;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scop.ScopeTypes;
import flow.common.api.variable.VariableContainer;
import flow.common.el.ExpressionManager;
import flow.common.history.HistoryLevel;
//import flow.common.identity.Authentication;
import flow.common.interceptor.CommandContext;
//import flow.common.logging.LoggingSessionConstants;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.TaskListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.identitylink.service.event.impl.FlowableIdentityLinkEventBuilder;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.DelegationState;
import flow.task.api.Task;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskLogEntryType;
import flow.task.service.HistoricTaskService;
import flow.task.service.TaskService;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.event.impl.FlowableVariableEventBuilder;
import flow.variable.service.impl.persistence.entity.VariableByteArrayRef;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class TaskHelper {

    public static void completeTask(TaskEntity taskEntity, Map!(string, Object) variables,
            Map!(string, Object) transientVariables, bool localScope, CommandContext commandContext) {

        // Task complete logic

        if (taskEntity.getDelegationState() !is null && taskEntity.getDelegationState() == DelegationState.PENDING) {
            throw new FlowableException("A delegated task cannot be completed, but should be resolved instead.");
        }

        if (variables !is null) {
            if (localScope) {
                taskEntity.setVariablesLocal(variables);

            } else if (taskEntity.getExecutionId() !is null) {
                ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(taskEntity.getExecutionId());
                if (execution !is null) {
                    execution.setVariables(variables);
                }

            } else {
                taskEntity.setVariables(variables);
            }
        }

        if (transientVariables !is null) {
            if (localScope) {
                taskEntity.setTransientVariablesLocal(transientVariables);
            } else {
                taskEntity.setTransientVariables(transientVariables);
            }
        }

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        processEngineConfiguration.getListenerNotificationHelper().executeTaskListeners(taskEntity, TaskListener.EVENTNAME_COMPLETE);

        if (processEngineConfiguration.getIdentityLinkInterceptor() !is null) {
            processEngineConfiguration.getIdentityLinkInterceptor().handleCompleteTask(taskEntity);
        }

        logUserTaskCompleted(taskEntity);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            if (variables !is null) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityWithVariablesEvent(
                        FlowableEngineEventType.TASK_COMPLETED, taskEntity, variables, localScope));
            } else {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_COMPLETED, taskEntity));
            }
        }

        if (processEngineConfiguration.isLoggingSessionEnabled() && taskEntity.getExecutionId() !is null) {
            string taskLabel = null;
            if (StringUtils.isNotEmpty(taskEntity.getName())) {
                taskLabel = taskEntity.getName();
            } else {
                taskLabel = taskEntity.getId();
            }

            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(taskEntity.getExecutionId());
            if (execution !is null) {
                BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_USER_TASK_COMPLETE,
                                "User task '" + taskLabel + "' completed", taskEntity, execution);
            }
        }

        deleteTask(taskEntity, null, false, true, true);

        // Continue process (if not a standalone task)
        if (taskEntity.getExecutionId() !is null) {
            ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(taskEntity.getExecutionId());
            CommandContextUtil.getAgenda(commandContext).planTriggerExecutionOperation(executionEntity);
        }
    }

    protected static void logUserTaskCompleted(TaskEntity taskEntity) {
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration();
        if (taskServiceConfiguration.isEnableHistoricTaskLogging()) {
            BaseHistoricTaskLogEntryBuilderImpl taskLogEntryBuilder = new BaseHistoricTaskLogEntryBuilderImpl(taskEntity);
            ObjectNode data = taskServiceConfiguration.getObjectMapper().createObjectNode();
            taskLogEntryBuilder.timeStamp(taskServiceConfiguration.getClock().getCurrentTime());
            taskLogEntryBuilder.userId(Authentication.getAuthenticatedUserId());
            taskLogEntryBuilder.data(data.toString());
            taskLogEntryBuilder.type(HistoricTaskLogEntryType.USER_TASK_COMPLETED.name());
            taskServiceConfiguration.getInternalHistoryTaskManager().recordHistoryUserTaskLog(taskLogEntryBuilder);
        }
    }

    public static void changeTaskAssignee(TaskEntity taskEntity, string assignee) {
        if ((taskEntity.getAssignee().length != 0 && taskEntity.getAssignee() != (assignee))
                || (taskEntity.getAssignee().length == 0 && assignee.length == 0)) {

            CommandContextUtil.getTaskService().changeTaskAssignee(taskEntity, assignee);
            fireAssignmentEvents(taskEntity);

            if (taskEntity.getId() !is null) {
                addAssigneeIdentityLinks(taskEntity);
            }
        }
    }

    public static void changeTaskOwner(TaskEntity taskEntity, string owner) {
        if ((taskEntity.getOwner() !is null && !taskEntity.getOwner().equals(owner))
                || (taskEntity.getOwner() is null && owner !is null)) {

            CommandContextUtil.getTaskService().changeTaskOwner(taskEntity, owner);
            if (taskEntity.getId() !is null) {
                addOwnerIdentityLink(taskEntity, taskEntity.getOwner());
            }
        }
    }

    public static void insertTask(TaskEntity taskEntity, ExecutionEntity execution, bool fireCreateEvent, bool addEntityLinks) {
        // Inherit tenant id (if applicable)
        if (execution !is null && execution.getTenantId() !is null) {
            taskEntity.setTenantId(execution.getTenantId());
        }

        if (execution !is null) {
            execution.getTasks().add(taskEntity);
            taskEntity.setExecutionId(execution.getId());
            taskEntity.setProcessInstanceId(execution.getProcessInstanceId());
            taskEntity.setProcessDefinitionId(execution.getProcessDefinitionId());
        }

        insertTask(taskEntity, fireCreateEvent);

        if (execution !is null) {

            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(execution)) {
                CountingExecutionEntity countingExecutionEntity = (CountingExecutionEntity) execution;
                countingExecutionEntity.setTaskCount(countingExecutionEntity.getTaskCount() + 1);
            }

            if (addEntityLinks) {
                EntityLinkUtil.copyExistingEntityLinks(execution.getProcessInstanceId(), taskEntity.getId(), ScopeTypes.TASK);
                EntityLinkUtil.createNewEntityLink(execution.getProcessInstanceId(), taskEntity.getId(), ScopeTypes.TASK);
            }

        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (fireCreateEvent && eventDispatcher !is null && eventDispatcher.isEnabled()) {
            if (taskEntity.getAssignee() !is null) {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_ASSIGNED, taskEntity));
            }
        }

        CommandContextUtil.getActivityInstanceEntityManager().recordTaskCreated(taskEntity, execution);
    }

    public static void insertTask(TaskEntity taskEntity, bool fireCreateEvent) {
        if (taskEntity.getOwner() !is null) {
            addOwnerIdentityLink(taskEntity, taskEntity.getOwner());
        }
        if (taskEntity.getAssignee() !is null) {
            addAssigneeIdentityLinks(taskEntity);
        }

        CommandContextUtil.getTaskService().insertTask(taskEntity, fireCreateEvent);
    }

    public static void addAssigneeIdentityLinks(TaskEntity taskEntity) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (processEngineConfiguration.getIdentityLinkInterceptor() !is null) {
            processEngineConfiguration.getIdentityLinkInterceptor().handleAddAssigneeIdentityLinkToTask(taskEntity, taskEntity.getAssignee());
        }
    }

    public static void addOwnerIdentityLink(TaskEntity taskEntity, string owner) {
        if (owner is null && taskEntity.getOwner() is null) {
            return;
        }

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (processEngineConfiguration.getIdentityLinkInterceptor() !is null) {
            processEngineConfiguration.getIdentityLinkInterceptor().handleAddOwnerIdentityLinkToTask(taskEntity, owner);
        }
    }

    /**
     * Deletes all tasks that relate to the same execution.
     *
     * @param executionEntity The {@link ExecutionEntity} to which the {@link TaskEntity} relate to.
     * @param taskEntities Tasks to be deleted. It is assumed that all {@link TaskEntity} instances need to be related to the same execution.
     */
    public static void deleteTasksForExecution(ExecutionEntity executionEntity, Collection!TaskEntity taskEntities, string deleteReason) {

        CommandContext commandContext = CommandContextUtil.getCommandContext();

        // Delete all entities related to the task entities
        for (TaskEntity taskEntity : taskEntities) {
            internalDeleteTask(taskEntity, deleteReason, false, false, true, true);
        }

        // Delete the task entities itself
        CommandContextUtil.getTaskService(commandContext).deleteTasksByExecutionId(executionEntity.getId());

    }

    /**
     * @param task
     *            The task to be deleted.
     * @param deleteReason
     *            A delete reason that will be stored in the history tables.
     * @param cascade
     *            If true, the historical counterpart will be deleted, otherwise
     *            it will be updated with an end time.
     * @param fireTaskListener
     *            If true, the delete event of the task listener will be called.
     * @param fireEvents
     *            If true, the event dispatcher will be used to fire an event
     *            for the deletion.
     */
    public static void deleteTask(TaskEntity task, string deleteReason, bool cascade, bool fireTaskListener, bool fireEvents) {
        internalDeleteTask(task, deleteReason, cascade, true, fireTaskListener, fireEvents);
    }

    protected static void internalDeleteTask(TaskEntity task, string deleteReason,
            bool cascade, bool executeTaskDelete, bool fireTaskListener, bool fireEvents) {

        if (!task.isDeleted()) {

            CommandContext commandContext = CommandContextUtil.getCommandContext();
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
            fireEvents = fireEvents && eventDispatcher !is null && eventDispatcher.isEnabled();

            if (fireTaskListener) {
                CommandContextUtil.getProcessEngineConfiguration(commandContext).getListenerNotificationHelper()
                        .executeTaskListeners(task, TaskListener.EVENTNAME_DELETE);
            }

            task.setDeleted(true);

            handleRelatedEntities(commandContext, task, deleteReason, cascade, fireTaskListener, fireEvents, eventDispatcher);
            handleTaskHistory(commandContext, task, deleteReason, cascade);

            if (executeTaskDelete) {
                executeTaskDelete(task, commandContext);
            }

            if (fireEvents) {
                fireTaskDeletedEvent(task, commandContext, eventDispatcher);
            }

        }
    }

    protected static void handleRelatedEntities(CommandContext commandContext, TaskEntity task, string deleteReason, bool cascade,
            bool fireTaskListener, bool fireEvents, FlowableEventDispatcher eventDispatcher) {

        bool isTaskRelatedEntityCountEnabled = CountingEntityUtil.isTaskRelatedEntityCountEnabled(task);

        if (!isTaskRelatedEntityCountEnabled
                || (isTaskRelatedEntityCountEnabled && ((CountingTaskEntity) task).getSubTaskCount() > 0)) {
            TaskService taskService = CommandContextUtil.getTaskService(commandContext);
            List!Task subTasks = taskService.findTasksByParentTaskId(task.getId());
            for (Task subTask : subTasks) {
                internalDeleteTask((TaskEntity) subTask, deleteReason, cascade, true, fireTaskListener, fireEvents); // Sub tasks are always immediately deleted
            }
        }

        if (!isTaskRelatedEntityCountEnabled
                || (isTaskRelatedEntityCountEnabled && ((CountingTaskEntity) task).getIdentityLinkCount() > 0)) {

            bool deleteIdentityLinks = true;
            if (fireEvents) {
                List!IdentityLinkEntity identityLinks = CommandContextUtil.getIdentityLinkService(commandContext).findIdentityLinksByTaskId(task.getId());
                for (IdentityLinkEntity identityLinkEntity : identityLinks) {
                    eventDispatcher.dispatchEvent(FlowableIdentityLinkEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, identityLinkEntity));
                }
                deleteIdentityLinks = !identityLinks.isEmpty();
            }

            if (deleteIdentityLinks) {
                CommandContextUtil.getIdentityLinkService(commandContext).deleteIdentityLinksByTaskId(task.getId());
            }

        }

        if (!isTaskRelatedEntityCountEnabled
                || (isTaskRelatedEntityCountEnabled && ((CountingTaskEntity) task).getVariableCount() > 0)) {

            Map!(string, VariableInstanceEntity) taskVariables = task.getVariableInstanceEntities();
            ArrayList!VariableByteArrayRef variableByteArrayRefs = new ArrayList<>();
            for (VariableInstanceEntity variableInstanceEntity : taskVariables.values()) {
                if (fireEvents) {
                    eventDispatcher.dispatchEvent(FlowableVariableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, variableInstanceEntity));
                }
                if (variableInstanceEntity.getByteArrayRef() !is null && variableInstanceEntity.getByteArrayRef().getId() !is null) {
                    variableByteArrayRefs.add(variableInstanceEntity.getByteArrayRef());
                }
            }

            for (VariableByteArrayRef variableByteArrayRef : variableByteArrayRefs) {
                CommandContextUtil.getByteArrayEntityManager(commandContext).deleteByteArrayById(variableByteArrayRef.getId());
            }

            if (!taskVariables.isEmpty()) {
                CommandContextUtil.getVariableService(commandContext).deleteVariablesByTaskId(task.getId());
            }
        }
    }

    protected static void handleTaskHistory(CommandContext commandContext, TaskEntity task, string deleteReason, bool cascade) {
        if (cascade) {
            deleteHistoricTask(task.getId());
            deleteHistoricTaskEventLogEntries(task.getId());
        } else {
            ExecutionEntity execution = null;
            if (task.getExecutionId() !is null) {
                execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(task.getExecutionId());
            }
            CommandContextUtil.getHistoryManager(commandContext)
                .recordTaskEnd(task, execution, deleteReason, commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());
        }
    }

    protected static void executeTaskDelete(TaskEntity task, CommandContext commandContext) {
        CommandContextUtil.getTaskService(commandContext).deleteTask(task, false); // false: event will be sent out later

        if (task.getExecutionId() !is null && CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            CountingExecutionEntity countingExecutionEntity = (CountingExecutionEntity) CommandContextUtil
                    .getExecutionEntityManager(commandContext).findById(task.getExecutionId());
            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(countingExecutionEntity)) {
                countingExecutionEntity.setTaskCount(countingExecutionEntity.getTaskCount() - 1);
            }
        }
    }

    protected static void fireTaskDeletedEvent(TaskEntity task, CommandContext commandContext, FlowableEventDispatcher eventDispatcher) {
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            CommandContextUtil.getEventDispatcher(commandContext).dispatchEvent(
                FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, task));
        }
    }

    public static void deleteTask(string taskId, string deleteReason, bool cascade) {

        CommandContext commandContext = CommandContextUtil.getCommandContext();
        TaskEntity task = CommandContextUtil.getTaskService(commandContext).getTask(taskId);

        if (task !is null) {
            if (task.getExecutionId() !is null) {
                throw new FlowableException("The task cannot be deleted because is part of a running process");
            } else if (task.getScopeId() !is null && ScopeTypes.CMMN.equals(task.getScopeType())) {
                throw new FlowableException("The task cannot be deleted because is part of a running case");
            }

            if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext,task.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                compatibilityHandler.deleteTask(taskId, deleteReason, cascade);
                return;
            }

            deleteTask(task, deleteReason, cascade, true, true);
        } else if (cascade) {
            deleteHistoricTask(taskId);
            deleteHistoricTaskEventLogEntries(taskId);
        }
    }

    public static void deleteTasksByProcessInstanceId(string processInstanceId, string deleteReason, bool cascade) {
        List!TaskEntity tasks = CommandContextUtil.getTaskService().findTasksByProcessInstanceId(processInstanceId);

        for (TaskEntity task : tasks) {
            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled() && !task.isCanceled()) {
                task.setCanceled(true);

                ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(task.getExecutionId());
                eventDispatcher
                        .dispatchEvent(flow.engine.deleg.event.impl.FlowableEventBuilder
                                .createActivityCancelledEvent(execution.getActivityId(), task.getName(),
                                        task.getExecutionId(), task.getProcessInstanceId(),
                                        task.getProcessDefinitionId(), "userTask", deleteReason));
            }

            deleteTask(task, deleteReason, cascade, true, true);
        }
    }

    public static void deleteHistoricTaskInstancesByProcessInstanceId(string processInstanceId) {
        if (CommandContextUtil.getHistoryManager().isHistoryLevelAtLeast(HistoryLevel.AUDIT)) {
            HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
            List!HistoricTaskInstanceEntity taskInstances = historicTaskService.findHistoricTasksByProcessInstanceId(processInstanceId);
            for (HistoricTaskInstanceEntity historicTaskInstanceEntity : taskInstances) {
                deleteHistoricTask(historicTaskInstanceEntity.getId());
            }
        }
    }

    public static void deleteHistoricTask(string taskId) {
        if (CommandContextUtil.getHistoryManager().isHistoryEnabled()) {
            CommandContextUtil.getCommentEntityManager().deleteCommentsByTaskId(taskId);
            CommandContextUtil.getAttachmentEntityManager().deleteAttachmentsByTaskId(taskId);

            HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
            HistoricTaskInstanceEntity historicTaskInstance = historicTaskService.getHistoricTask(taskId);
            if (historicTaskInstance !is null) {

                if (historicTaskInstance.getProcessDefinitionId() !is null
                        && Flowable5Util.isFlowable5ProcessDefinitionId(CommandContextUtil.getCommandContext(), historicTaskInstance.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteHistoricTask(taskId);
                    return;
                }

                List!HistoricTaskInstanceEntity subTasks = historicTaskService.findHistoricTasksByParentTaskId(historicTaskInstance.getId());
                for (HistoricTaskInstance subTask : subTasks) {
                    deleteHistoricTask(subTask.getId());
                }

                CommandContextUtil.getHistoricDetailEntityManager().deleteHistoricDetailsByTaskId(taskId);
                CommandContextUtil.getHistoricVariableService().deleteHistoricVariableInstancesByTaskId(taskId);
                CommandContextUtil.getHistoricIdentityLinkService().deleteHistoricIdentityLinksByTaskId(taskId);

                historicTaskService.deleteHistoricTask(historicTaskInstance);
            }
        }
    }

    public static void deleteHistoricTaskEventLogEntries(string taskId) {
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration();
        if (taskServiceConfiguration.isEnableHistoricTaskLogging()) {
            CommandContextUtil.getHistoricTaskService().deleteHistoricTaskLogEntriesForTaskId(taskId);
        }
    }

    public static bool isFormFieldValidationEnabled(VariableContainer variableContainer,
        ProcessEngineConfigurationImpl processEngineConfiguration, string formFieldValidationExpression) {
        if (StringUtils.isNotEmpty(formFieldValidationExpression)) {
            bool formFieldValidation = getBoolean(formFieldValidationExpression);
            if (formFieldValidation !is null) {
                return formFieldValidation;
            }

            if (variableContainer !is null) {
                ExpressionManager expressionManager = processEngineConfiguration.getExpressionManager();
                bool formFieldValidationValue = getBoolean(
                    expressionManager.createExpression(formFieldValidationExpression).getValue(variableContainer)
                );
                if (formFieldValidationValue is null) {
                    throw new FlowableException("Unable to resolve formFieldValidationExpression to bool value");
                }
                return formFieldValidationValue;
            }
            throw new FlowableException("Unable to resolve formFieldValidationExpression without variable container");
        }
        return true;
    }

    protected static bool getBoolean(Object booleanObject) {
        if (booleanObject instanceof bool) {
            return (bool) booleanObject;
        }
        if (booleanObject instanceof string) {
            if ("true".equalsIgnoreCase((string) booleanObject)) {
                return bool.TRUE;
            }
            if ("false".equalsIgnoreCase((string) booleanObject)) {
                return bool.FALSE;
            }
        }
        return null;
    }

    protected static void fireAssignmentEvents(TaskEntity taskEntity) {
        CommandContextUtil.getProcessEngineConfiguration().getListenerNotificationHelper().executeTaskListeners(taskEntity, TaskListener.EVENTNAME_ASSIGNMENT);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_ASSIGNED, taskEntity));
        }
    }
}
