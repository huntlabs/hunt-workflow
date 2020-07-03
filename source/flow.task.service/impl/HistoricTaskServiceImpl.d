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
module flow.task.service.impl.HistoricTaskServiceImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;

//import flow.common.identity.Authentication;
import flow.common.interceptor.CommandExecutor;
import flow.common.service.CommonServiceImpl;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.api.history.NativeHistoricTaskLogEntryQuery;
import flow.task.service.HistoricTaskService;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManager;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManager;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.util.CommandContextUtil;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.HistoricTaskLogEntryQueryImpl;
import flow.common.persistence.entity.EntityManager;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricTaskServiceImpl : CommonServiceImpl!TaskServiceConfiguration , HistoricTaskService {

    this(TaskServiceConfiguration taskServiceConfiguration) {
        super(taskServiceConfiguration);
    }


    public HistoricTaskInstanceEntity getHistoricTask(string id) {
        return getHistoricTaskInstanceEntityManager().findById(id);
    }


    public List!HistoricTaskInstanceEntity findHistoricTasksByParentTaskId(string parentTaskId) {
        return getHistoricTaskInstanceEntityManager().findHistoricTasksByParentTaskId(parentTaskId);
    }


    public List!HistoricTaskInstanceEntity findHistoricTasksByProcessInstanceId(string processInstanceId) {
        return getHistoricTaskInstanceEntityManager().findHistoricTasksByProcessInstanceId(processInstanceId);
    }


    public List!HistoricTaskInstance findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        return getHistoricTaskInstanceEntityManager().findHistoricTaskInstancesByQueryCriteria(historicTaskInstanceQuery);
    }


    public HistoricTaskInstanceEntity createHistoricTask() {
        return (cast(EntityManager!HistoricTaskInstanceEntity)getHistoricTaskInstanceEntityManager()).create();
    }


    public HistoricTaskInstanceEntity createHistoricTask(TaskEntity taskEntity) {
        return getHistoricTaskInstanceEntityManager().create(taskEntity);
    }


    public void updateHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireUpdateEvent) {
        getHistoricTaskInstanceEntityManager().update(historicTaskInstanceEntity, fireUpdateEvent);
    }


    public void insertHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireCreateEvent) {
        getHistoricTaskInstanceEntityManager().insert(historicTaskInstanceEntity, fireCreateEvent);
    }


    public void deleteHistoricTask(HistoricTaskInstanceEntity HistoricTaskInstance) {
        getHistoricTaskInstanceEntityManager().dele(HistoricTaskInstance);
    }


    public HistoricTaskInstanceEntity recordTaskCreated(TaskEntity task) {
        HistoricTaskInstanceEntityManager historicTaskInstanceEntityManager = getHistoricTaskInstanceEntityManager();
        HistoricTaskInstanceEntity historicTaskInstanceEntity = historicTaskInstanceEntityManager.create(task);
        historicTaskInstanceEntityManager.insert(historicTaskInstanceEntity, true);
        return historicTaskInstanceEntity;
    }


    public HistoricTaskInstanceEntity recordTaskEnd(TaskEntity task, string deleteReason, Date endTime) {
        HistoricTaskInstanceEntity historicTaskInstanceEntity = getHistoricTaskInstanceEntityManager().findById(task.getId());
        if (historicTaskInstanceEntity !is null) {
            historicTaskInstanceEntity.markEnded(deleteReason, endTime);
        }
        return historicTaskInstanceEntity;
    }


    public HistoricTaskInstanceEntity recordTaskInfoChange(TaskEntity taskEntity, Date changeTime) {
        HistoricTaskInstanceEntity historicTaskInstance = getHistoricTaskInstanceEntityManager().findById(taskEntity.getId());
        if (historicTaskInstance !is null) {
            historicTaskInstance.setName(taskEntity.getName());
            historicTaskInstance.setDescription(taskEntity.getDescription());
            historicTaskInstance.setDueDate(taskEntity.getDueDate());
            historicTaskInstance.setPriority(taskEntity.getPriority());
            historicTaskInstance.setCategory(taskEntity.getCategory());
            historicTaskInstance.setFormKey(taskEntity.getFormKey());
            historicTaskInstance.setParentTaskId(taskEntity.getParentTaskId());
            historicTaskInstance.setTaskDefinitionKey(taskEntity.getTaskDefinitionKey());
            historicTaskInstance.setProcessDefinitionId(taskEntity.getProcessDefinitionId());
            historicTaskInstance.setClaimTime(taskEntity.getClaimTime());
            historicTaskInstance.setLastUpdateTime(changeTime);

            if ((historicTaskInstance.getAssignee() != taskEntity.getAssignee())) {
                historicTaskInstance.setAssignee(taskEntity.getAssignee());
                createHistoricIdentityLink(historicTaskInstance.getId(), IdentityLinkType.ASSIGNEE, historicTaskInstance.getAssignee());
            }

            if ((historicTaskInstance.getOwner() != taskEntity.getOwner())) {
                historicTaskInstance.setOwner(taskEntity.getOwner());
                createHistoricIdentityLink(historicTaskInstance.getId(), IdentityLinkType.OWNER, historicTaskInstance.getOwner());
            }
        }
        return historicTaskInstance;
    }


    public void deleteHistoricTaskLogEntry(long logNumber) {
        getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntry(logNumber);
    }


    public void addHistoricTaskLogEntry(TaskInfo task, string logEntryType, string data) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            HistoricTaskLogEntryEntity taskLogEntry = getHistoricTaskLogEntryEntityManager().create();
            taskLogEntry.setTaskId(task.getId());
            taskLogEntry.setExecutionId(task.getExecutionId());
            taskLogEntry.setProcessInstanceId(task.getProcessInstanceId());
            taskLogEntry.setProcessDefinitionId(task.getProcessDefinitionId());
            taskLogEntry.setScopeId(task.getScopeId());
            taskLogEntry.setScopeDefinitionId(task.getScopeDefinitionId());
            taskLogEntry.setScopeType(task.getScopeType());
            taskLogEntry.setSubScopeId(task.getSubScopeId());
            taskLogEntry.setTimeStamp(this.configuration.getClock().getCurrentTime());
            taskLogEntry.setType(logEntryType);
            taskLogEntry.setData(data);
            //taskLogEntry.setUserId(Authentication.getAuthenticatedUserId());
            getHistoricTaskLogEntryEntityManager().insert(taskLogEntry);
        }
    }


    public void createHistoricTaskLogEntry(HistoricTaskLogEntryBuilder historicTaskLogEntryBuilder) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().createHistoricTaskLogEntry(historicTaskLogEntryBuilder);
        }
    }


    public HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery(CommandExecutor commandExecutor) {
        return new HistoricTaskLogEntryQueryImpl(commandExecutor);
    }


    public void deleteHistoricTaskLogEntriesForProcessDefinition(string processDefinitionId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForProcessDefinition(processDefinitionId);
        }
    }


    public void deleteHistoricTaskLogEntriesForScopeDefinition(string scopeType, string scopeDefinitionId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForScopeDefinition(scopeType, scopeDefinitionId);
        }
    }


    public void deleteHistoricTaskLogEntriesForTaskId(string taskId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForTaskId(taskId);
        }
    }


    public void deleteHistoricTaskLogEntriesForNonExistingProcessInstances() {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForNonExistingProcessInstances();
        }
    }


    public void deleteHistoricTaskLogEntriesForNonExistingCaseInstances() {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForNonExistingCaseInstances();
        }
    }


    public void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstances(historicTaskInstanceQuery);
    }


    public void deleteHistoricTaskInstancesForNonExistingProcessInstances() {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstancesForNonExistingProcessInstances();
    }


    public void deleteHistoricTaskInstancesForNonExistingCaseInstances() {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstancesForNonExistingCaseInstances();
    }


    public NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery(CommandExecutor commandExecutor) {
        implementationMissing(false);
        return null;
        //return new NativeHistoricTaskLogEntryQueryImpl(commandExecutor);
    }

    protected HistoricTaskLogEntryEntityManager getHistoricTaskLogEntryEntityManager() {
        return configuration.getHistoricTaskLogEntryEntityManager();
    }

    protected void createHistoricIdentityLink(string taskId, string type, string userId) {
        HistoricIdentityLinkService historicIdentityLinkService =  CommandContextUtil.getHistoricIdentityLinkService();
        HistoricIdentityLinkEntity historicIdentityLinkEntity = historicIdentityLinkService.createHistoricIdentityLink();
        historicIdentityLinkEntity.setTaskId(taskId);
        historicIdentityLinkEntity.setType(type);
        historicIdentityLinkEntity.setUserId(userId);
        historicIdentityLinkEntity.setCreateTime(configuration.getClock().getCurrentTime());
        historicIdentityLinkService.insertHistoricIdentityLink(historicIdentityLinkEntity, false);
    }

    public HistoricTaskInstanceEntityManager getHistoricTaskInstanceEntityManager() {
        return configuration.getHistoricTaskInstanceEntityManager();
    }

}
