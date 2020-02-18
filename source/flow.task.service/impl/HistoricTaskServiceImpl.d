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


import java.util.Date;
import java.util.List;
import java.util.Objects;

import flow.common.identity.Authentication;
import flow.common.interceptor.CommandExecutor;
import flow.common.service.CommonServiceImpl;
import org.flowable.identitylink.api.IdentityLinkType;
import org.flowable.identitylink.service.HistoricIdentityLinkService;
import org.flowable.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import org.flowable.task.api.TaskInfo;
import org.flowable.task.api.history.HistoricTaskInstance;
import org.flowable.task.api.history.HistoricTaskLogEntryBuilder;
import org.flowable.task.api.history.HistoricTaskLogEntryQuery;
import org.flowable.task.api.history.NativeHistoricTaskLogEntryQuery;
import org.flowable.task.service.HistoricTaskService;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManager;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManager;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.task.service.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricTaskServiceImpl extends CommonServiceImpl<TaskServiceConfiguration> implements HistoricTaskService {

    public HistoricTaskServiceImpl(TaskServiceConfiguration taskServiceConfiguration) {
        super(taskServiceConfiguration);
    }

    @Override
    public HistoricTaskInstanceEntity getHistoricTask(string id) {
        return getHistoricTaskInstanceEntityManager().findById(id);
    }

    @Override
    public List<HistoricTaskInstanceEntity> findHistoricTasksByParentTaskId(string parentTaskId) {
        return getHistoricTaskInstanceEntityManager().findHistoricTasksByParentTaskId(parentTaskId);
    }

    @Override
    public List<HistoricTaskInstanceEntity> findHistoricTasksByProcessInstanceId(string processInstanceId) {
        return getHistoricTaskInstanceEntityManager().findHistoricTasksByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<HistoricTaskInstance> findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        return getHistoricTaskInstanceEntityManager().findHistoricTaskInstancesByQueryCriteria(historicTaskInstanceQuery);
    }

    @Override
    public HistoricTaskInstanceEntity createHistoricTask() {
        return getHistoricTaskInstanceEntityManager().create();
    }

    @Override
    public HistoricTaskInstanceEntity createHistoricTask(TaskEntity taskEntity) {
        return getHistoricTaskInstanceEntityManager().create(taskEntity);
    }
    
    @Override
    public void updateHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireUpdateEvent) {
        getHistoricTaskInstanceEntityManager().update(historicTaskInstanceEntity, fireUpdateEvent);
    }

    @Override
    public void insertHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireCreateEvent) {
        getHistoricTaskInstanceEntityManager().insert(historicTaskInstanceEntity, fireCreateEvent);
    }

    @Override
    public void deleteHistoricTask(HistoricTaskInstanceEntity HistoricTaskInstance) {
        getHistoricTaskInstanceEntityManager().delete(HistoricTaskInstance);
    }

    @Override
    public HistoricTaskInstanceEntity recordTaskCreated(TaskEntity task) {
        HistoricTaskInstanceEntityManager historicTaskInstanceEntityManager = getHistoricTaskInstanceEntityManager();
        HistoricTaskInstanceEntity historicTaskInstanceEntity = historicTaskInstanceEntityManager.create(task);
        historicTaskInstanceEntityManager.insert(historicTaskInstanceEntity, true);
        return historicTaskInstanceEntity;
    }

    @Override
    public HistoricTaskInstanceEntity recordTaskEnd(TaskEntity task, string deleteReason, Date endTime) {
        HistoricTaskInstanceEntity historicTaskInstanceEntity = getHistoricTaskInstanceEntityManager().findById(task.getId());
        if (historicTaskInstanceEntity !is null) {
            historicTaskInstanceEntity.markEnded(deleteReason, endTime);
        }
        return historicTaskInstanceEntity;
    }

    @Override
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

            if (!Objects.equals(historicTaskInstance.getAssignee(), taskEntity.getAssignee())) {
                historicTaskInstance.setAssignee(taskEntity.getAssignee());
                createHistoricIdentityLink(historicTaskInstance.getId(), IdentityLinkType.ASSIGNEE, historicTaskInstance.getAssignee());
            }

            if (!Objects.equals(historicTaskInstance.getOwner(), taskEntity.getOwner())) {
                historicTaskInstance.setOwner(taskEntity.getOwner());
                createHistoricIdentityLink(historicTaskInstance.getId(), IdentityLinkType.OWNER, historicTaskInstance.getOwner());
            }
        }
        return historicTaskInstance;
    }

    @Override
    public void deleteHistoricTaskLogEntry(long logNumber) {
        getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntry(logNumber);
    }

    @Override
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
            taskLogEntry.setUserId(Authentication.getAuthenticatedUserId());
            getHistoricTaskLogEntryEntityManager().insert(taskLogEntry);
        }
    }

    @Override
    public void createHistoricTaskLogEntry(HistoricTaskLogEntryBuilder historicTaskLogEntryBuilder) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().createHistoricTaskLogEntry(historicTaskLogEntryBuilder);
        }
    }

    @Override
    public HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery(CommandExecutor commandExecutor) {
        return new HistoricTaskLogEntryQueryImpl(commandExecutor);
    }

    @Override
    public void deleteHistoricTaskLogEntriesForProcessDefinition(string processDefinitionId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForProcessDefinition(processDefinitionId);
        }
    }

    @Override
    public void deleteHistoricTaskLogEntriesForScopeDefinition(string scopeType, string scopeDefinitionId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForScopeDefinition(scopeType, scopeDefinitionId);
        }
    }

    @Override
    public void deleteHistoricTaskLogEntriesForTaskId(string taskId) {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForTaskId(taskId);
        }
    }
    
    @Override
    public void deleteHistoricTaskLogEntriesForNonExistingProcessInstances() {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForNonExistingProcessInstances();
        }
    }
    
    @Override
    public void deleteHistoricTaskLogEntriesForNonExistingCaseInstances() {
        if (this.configuration.isEnableHistoricTaskLogging()) {
            getHistoricTaskLogEntryEntityManager().deleteHistoricTaskLogEntriesForNonExistingCaseInstances();
        }
    }
    
    @Override
    public void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstances(historicTaskInstanceQuery);
    }
    
    @Override
    public void deleteHistoricTaskInstancesForNonExistingProcessInstances() {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstancesForNonExistingProcessInstances();
    }
    
    @Override
    public void deleteHistoricTaskInstancesForNonExistingCaseInstances() {
        getHistoricTaskInstanceEntityManager().deleteHistoricTaskInstancesForNonExistingCaseInstances();
    }

    @Override
    public NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery(CommandExecutor commandExecutor) {
        return new NativeHistoricTaskLogEntryQueryImpl(commandExecutor);
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
