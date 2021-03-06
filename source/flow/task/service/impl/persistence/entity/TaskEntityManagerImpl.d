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

module flow.task.service.impl.persistence.entity.TaskEntityManagerImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
//import flow.common.identity.Authentication;
import flow.identitylink.service.IdentityLinkService;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryType;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.event.impl.FlowableTaskEventBuilder;
import flow.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;
import flow.task.service.impl.TaskQueryImpl;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.data.TaskDataManager;
import flow.task.service.impl.util.CommandContextUtil;
import flow.task.service.impl.persistence.entity.AbstractTaskServiceEntityManager;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntityManager;
import flow.identitylink.api.IdentityLinkInfo;
import hunt.Exceptions;
import hunt.String;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TaskEntityManagerImpl
    : AbstractTaskServiceEntityManager!(TaskEntity, TaskDataManager)
    , TaskEntityManager {

    this(TaskServiceConfiguration taskServiceConfiguration, TaskDataManager taskDataManager) {
        super(taskServiceConfiguration, taskDataManager);
    }

    override
    public TaskEntity create() {
        TaskEntity taskEntity = super.create();
        taskEntity.setCreateTime(getClock().getCurrentTime());
        if (serviceConfiguration.isEnableTaskRelationshipCounts()) {
            (cast(CountingTaskEntity) taskEntity).setCountEnabled(true);
        }
        return taskEntity;
    }


    public TaskEntity createTask(TaskBuilder taskBuilder) {
        // create and insert task
        TaskEntity taskEntity = create();
        taskEntity.setId(taskBuilder.getId());
        taskEntity.setName(taskBuilder.getName());
        taskEntity.setDescription(taskBuilder.getDescription());
        taskEntity.setPriority(taskBuilder.getPriority());
        taskEntity.setOwner(taskBuilder.getOwner());
        taskEntity.setAssignee(taskBuilder.getAssignee());
        taskEntity.setDueDate(taskBuilder.getDueDate());
        taskEntity.setCategory(taskBuilder.getCategory());
        taskEntity.setParentTaskId(taskBuilder.getParentTaskId());
        taskEntity.setTenantId(taskBuilder.getTenantId());
        taskEntity.setFormKey(taskBuilder.getFormKey());
        taskEntity.setTaskDefinitionId(taskBuilder.getTaskDefinitionId());
        taskEntity.setTaskDefinitionKey(taskBuilder.getTaskDefinitionKey());
        taskEntity.setScopeId(taskBuilder.getScopeId());
        taskEntity.setScopeType(taskBuilder.getScopeType());
        super.insert(taskEntity);

        TaskEntity enrichedTaskEntity = serviceConfiguration.getTaskPostProcessor().enrich(taskEntity);
        update(enrichedTaskEntity, false);
        //Set!IdentityLinkInfo identityLinks  taskBuilder.getIdentityLinks();
        foreach(IdentityLinkInfo identityLink;  taskBuilder.getIdentityLinks())
        {
            if (identityLink.getGroupId() !is null) {
                enrichedTaskEntity.addGroupIdentityLink(identityLink.getGroupId(), identityLink.getType());
            } else if (identityLink.getUserId() !is null) {
                enrichedTaskEntity.addUserIdentityLink(identityLink.getUserId(), identityLink.getType());
            }
        }
        //taskBuilder.getIdentityLinks().forEach(
        //        identityLink -> {
        //            if (identityLink.getGroupId() !is null) {
        //                enrichedTaskEntity.addGroupIdentityLink(identityLink.getGroupId(), identityLink.getType());
        //            } else if (identityLink.getUserId() !is null) {
        //                enrichedTaskEntity.addUserIdentityLink(identityLink.getUserId(), identityLink.getType());
        //            }
        //        }
        //);

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled() && taskEntity.getAssignee() !is null) {
            getEventDispatcher().dispatchEvent(
                    FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_ASSIGNED, cast(Object)taskEntity));
        }

        serviceConfiguration.getInternalHistoryTaskManager().recordTaskCreated(taskEntity);

        return enrichedTaskEntity;
    }

    override
    public void insert(TaskEntity taskEntity, bool fireCreatedEvent) {
        super.insert(taskEntity, fireCreatedEvent);
        if (fireCreatedEvent) {
            logTaskCreatedEvent(taskEntity);
        }
    }

    override
    public TaskEntity update(TaskEntity taskEntity, bool fireUpdateEvents) {
        if (fireUpdateEvents) {
            logTaskUpdateEvents(taskEntity);
        }
        return super.update(taskEntity, fireUpdateEvents);
    }

    protected IdentityLinkService getIdentityLinkService() {
        return CommandContextUtil.getIdentityLinkServiceConfiguration().getIdentityLinkService();
    }


    public void changeTaskAssignee(TaskEntity taskEntity, string assignee) {
        if ((taskEntity.getAssignee() !is null && taskEntity.getAssignee() != (assignee))
                || (taskEntity.getAssignee() is null && assignee !is null)) {

            taskEntity.setAssignee(assignee);

            if (taskEntity.getId() !is null) {
                serviceConfiguration.getInternalHistoryTaskManager().recordTaskInfoChange(taskEntity, getClock().getCurrentTime());
                super.update(taskEntity);
            }
        }
    }


    public void changeTaskOwner(TaskEntity taskEntity, string owner) {
        if ((taskEntity.getOwner() !is null && taskEntity.getOwner() != (owner))
                || (taskEntity.getOwner() is null && owner !is null)) {

            taskEntity.setOwner(owner);

            if (taskEntity.getId() !is null) {
                serviceConfiguration.getInternalHistoryTaskManager().recordTaskInfoChange(taskEntity, getClock().getCurrentTime());
                super.update(taskEntity);
            }
        }
    }


    public List!TaskEntity findTasksByExecutionId(string executionId) {
        return dataManager.findTasksByExecutionId(executionId);
    }


    public List!TaskEntity findTasksByProcessInstanceId(string processInstanceId) {
        return dataManager.findTasksByProcessInstanceId(processInstanceId);
    }


    public List!TaskEntity findTasksByScopeIdAndScopeType(string scopeId, string scopeType) {
        return dataManager.findTasksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public List!TaskEntity findTasksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return dataManager.findTasksBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public List!Task findTasksByQueryCriteria(TaskQueryImpl taskQuery) {
        return dataManager.findTasksByQueryCriteria(taskQuery);
    }


    public List!Task findTasksWithRelatedEntitiesByQueryCriteria(TaskQueryImpl taskQuery) {
        return dataManager.findTasksWithRelatedEntitiesByQueryCriteria(taskQuery);
    }


    public long findTaskCountByQueryCriteria(TaskQueryImpl taskQuery) {
        return dataManager.findTaskCountByQueryCriteria(taskQuery);
    }


    public List!Task findTasksByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findTasksByNativeQuery(parameterMap);
    }


    public long findTaskCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findTaskCountByNativeQuery(parameterMap);
    }


    public List!Task findTasksByParentTaskId(string parentTaskId) {
        return dataManager.findTasksByParentTaskId(parentTaskId);
    }


    public void updateTaskTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateTaskTenantIdForDeployment(deploymentId, newTenantId);
    }


    public void updateAllTaskRelatedEntityCountFlags(bool configProperty) {
        dataManager.updateAllTaskRelatedEntityCountFlags(configProperty);
    }


    public void deleteTasksByExecutionId(string executionId) {
        dataManager.deleteTasksByExecutionId(executionId);
    }

    protected void logAssigneeChanged(TaskEntity taskEntity, string previousAssignee, string newAssignee) {
        implementationMissing(false);
        //if (serviceConfiguration.isEnableHistoricTaskLogging()) {
        //    ObjectNode dataNode = serviceConfiguration.getObjectMapper().createObjectNode();
        //    dataNode.put("newAssigneeId", newAssignee);
        //    dataNode.put("previousAssigneeId", previousAssignee);
        //    recordHistoryUserTaskLog(HistoricTaskLogEntryType.USER_TASK_ASSIGNEE_CHANGED, taskEntity, dataNode);
        //}
    }

    protected void logOwnerChanged(TaskEntity taskEntity, string previousOwner, string newOwner) {
        implementationMissing(false);
        //if (serviceConfiguration.isEnableHistoricTaskLogging()) {
        //    ObjectNode dataNode = serviceConfiguration.getObjectMapper().createObjectNode();
        //    dataNode.put("newOwnerId", newOwner);
        //    dataNode.put("previousOwnerId", previousOwner);
        //    recordHistoryUserTaskLog(HistoricTaskLogEntryType.USER_TASK_OWNER_CHANGED, taskEntity, dataNode);
        //}
    }

    protected void logPriorityChanged(TaskEntity taskEntity, int previousPriority, int newPriority) {
        implementationMissing(false);
        //if (serviceConfiguration.isEnableHistoricTaskLogging()) {
        //    ObjectNode dataNode = serviceConfiguration.getObjectMapper().createObjectNode();
        //    dataNode.put("newPriority", newPriority);
        //    dataNode.put("previousPriority", previousPriority);
        //    recordHistoryUserTaskLog(HistoricTaskLogEntryType.USER_TASK_PRIORITY_CHANGED, taskEntity, dataNode);
        //}
    }

    protected void logDueDateChanged(TaskEntity taskEntity, Date previousDueDate, Date newDueDate) {
        implementationMissing(false);
        //if (serviceConfiguration.isEnableHistoricTaskLogging()) {
        //    ObjectNode dataNode = serviceConfiguration.getObjectMapper().createObjectNode();
        //    dataNode.put("newDueDate", newDueDate !is null ? newDueDate.getTime() : null);
        //    dataNode.put("previousDueDate", previousDueDate !is null ? previousDueDate.getTime() : null);
        //    recordHistoryUserTaskLog(HistoricTaskLogEntryType.USER_TASK_DUEDATE_CHANGED, taskEntity, dataNode);
        //}
    }

    protected void logNameChanged(TaskEntity taskEntity, string previousName, string newName) {
        implementationMissing(false);
        //if (serviceConfiguration.isEnableHistoricTaskLogging()) {
        //    ObjectNode dataNode = serviceConfiguration.getObjectMapper().createObjectNode();
        //    dataNode.put("newName", newName);
        //    dataNode.put("previousName", previousName);
        //    recordHistoryUserTaskLog(HistoricTaskLogEntryType.USER_TASK_NAME_CHANGED, taskEntity, dataNode);
        //}
    }

    protected void logTaskCreatedEvent(TaskInfo task) {
        if (serviceConfiguration.isEnableHistoricTaskLogging()) {
            HistoricTaskLogEntryBuilder taskLogEntryBuilder = createHistoricTaskLogEntryBuilder(task, HistoricTaskLogEntryType.USER_TASK_CREATED);
            taskLogEntryBuilder.timeStamp(task.getCreateTime());
            serviceConfiguration.getInternalHistoryTaskManager().recordHistoryUserTaskLog(taskLogEntryBuilder);
        }
    }

    protected HistoricTaskLogEntryBuilder createHistoricTaskLogEntryBuilder(TaskInfo task, HistoricTaskLogEntryType userTaskCreated) {
        HistoricTaskLogEntryBuilder taskLogEntryBuilder = new BaseHistoricTaskLogEntryBuilderImpl(task);
        taskLogEntryBuilder.timeStamp(serviceConfiguration.getClock().getCurrentTime());
        //taskLogEntryBuilder.userId(Authentication.getAuthenticatedUserId());
        taskLogEntryBuilder.type(userTaskCreated.name());
        return taskLogEntryBuilder;
    }

    protected void logTaskUpdateEvents(TaskEntity task) {
          implementationMissing(false);
        //if (wasPersisted(task)) {
        //    if (!Objects.equals(task.getAssignee(), getOriginalState(task, "assignee"))) {
        //        logAssigneeChanged(task, (string) getOriginalState(task, "assignee"), task.getAssignee());
        //    }
        //    if (!Objects.equals(task.getOwner(), getOriginalState(task, "owner"))) {
        //        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
        //            getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_OWNER_CHANGED, task));
        //        }
        //
        //        logOwnerChanged(task, (string) getOriginalState(task, "owner"), task.getOwner());
        //    }
        //    if (!Objects.equals(task.getPriority(), getOriginalState(task, "priority"))) {
        //        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
        //            getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_PRIORITY_CHANGED, task));
        //        }
        //        logPriorityChanged(task, (Integer) getOriginalState(task, "priority"), task.getPriority());
        //    }
        //    if (!Objects.equals(task.getDueDate(), getOriginalState(task, "dueDate"))) {
        //        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
        //            getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_DUEDATE_CHANGED, task));
        //        }
        //        logDueDateChanged(task, (Date) getOriginalState(task, "dueDate"), task.getDueDate());
        //    }
        //    if (!Objects.equals(task.getName(), getOriginalState(task, "name"))) {
        //        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
        //            getEventDispatcher().dispatchEvent(FlowableTaskEventBuilder.createEntityEvent(FlowableEngineEventType.TASK_NAME_CHANGED, task));
        //        }
        //        logNameChanged(task, (string) getOriginalState(task, "name"), task.getName());
        //    }
        //}
    }


    protected bool wasPersisted(TaskEntity task) {
        if (task.getOriginalPersistentState() !is null && (cast(Map!(string, Object)) task.getOriginalPersistentState()).size() > 0) {
            return true;
        } else {
            return false;
        }
    }


    protected Object getOriginalState(TaskEntity task, string stateKey) {
        if (task.getOriginalPersistentState() !is null) {
            return (cast(Map!(string, Object)) task.getOriginalPersistentState()).get(stateKey);
        }
        return null;
    }

    //protected void recordHistoryUserTaskLog(HistoricTaskLogEntryType logEntryType, TaskInfo task, ObjectNode dataNode) {
    //    HistoricTaskLogEntryBuilder taskLogEntryBuilder = createHistoricTaskLogEntryBuilder(task, logEntryType);
    //    taskLogEntryBuilder.data( dataNode.toString());
    //    serviceConfiguration.getInternalHistoryTaskManager().recordHistoryUserTaskLog(taskLogEntryBuilder);
    //}

}
