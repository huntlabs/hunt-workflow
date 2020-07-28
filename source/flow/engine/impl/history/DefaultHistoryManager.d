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
module flow.engine.impl.history.DefaultHistoryManager;

import hunt.Exceptions;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scop.ScopeTypes;
import flow.common.history.HistoryLevel;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.TaskHelper;
import flow.engine.runtime.ActivityInstance;
import flow.entitylink.service.api.history.HistoricEntityLinkService;
import flow.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import flow.entitylink.service.impl.persistence.entity.HistoricEntityLinkEntity;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.service.HistoricTaskService;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.history.AbstractHistoryManager;

/**
 * Manager class that centralises recording of all history-related operations that are originated from inside the engine.
 *
 * @author Frederik Heremans
 * @author Joram Barrez
 */
class DefaultHistoryManager : AbstractHistoryManager {


    this(ProcessEngineConfigurationImpl processEngineConfiguration, HistoryLevel historyLevel, bool usePrefixId) {
        super(processEngineConfiguration, historyLevel, usePrefixId);
    }

    // Process related history

    public void recordProcessInstanceEnd(ExecutionEntity processInstance, string deleteReason, string activityId, Date endTime) {

        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processInstance.getProcessDefinitionId())) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstance.getId());

            if (historicProcessInstance !is null) {
                historicProcessInstance.markEnded(deleteReason, endTime);
                historicProcessInstance.setEndActivityId(activityId);

                // Fire event
                FlowableEventDispatcher eventDispatcher = getEventDispatcher();
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(
                            FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_ENDED, cast(Object)historicProcessInstance));
                }

            }
        }
    }

    public void recordProcessInstanceNameChange(ExecutionEntity processInstanceExecution, string newName) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processInstanceExecution.getProcessDefinitionId())) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstanceExecution.getId());

            if (historicProcessInstance !is null) {
                historicProcessInstance.setName(newName);
            }
        }
    }

    public void recordProcessInstanceStart(ExecutionEntity processInstance) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processInstance.getProcessDefinitionId())) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().create(processInstance);

            // Insert historic process-instance
            getHistoricProcessInstanceEntityManager().insert(historicProcessInstance, false);

            // Fire event
            FlowableEventDispatcher eventDispatcher = getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(
                        FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_CREATED, cast(Object)historicProcessInstance));
            }

        }
    }

    public void recordProcessInstanceDeleted(string processInstanceId, string processDefinitionId, string processTenantId) {
        if (getHistoryManager().isHistoryEnabled(processDefinitionId)) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstanceId);

            getHistoricDetailEntityManager().deleteHistoricDetailsByProcessInstanceId(processInstanceId);
            CommandContextUtil.getHistoricVariableService().deleteHistoricVariableInstancesByProcessInstanceId(processInstanceId);
            getHistoricActivityInstanceEntityManager().deleteHistoricActivityInstancesByProcessInstanceId(processInstanceId);
            TaskHelper.deleteHistoricTaskInstancesByProcessInstanceId(processInstanceId);
            CommandContextUtil.getHistoricIdentityLinkService().deleteHistoricIdentityLinksByProcessInstanceId(processInstanceId);

            if (processEngineConfiguration.isEnableEntityLinks()) {
                implementationMissing(false);
               // CommandContextUtil.getHistoricEntityLinkService().deleteHistoricEntityLinksByScopeIdAndScopeType(processInstanceId, ScopeTypes.BPMN);
            }

            getCommentEntityManager().deleteCommentsByProcessInstanceId(processInstanceId);

            if (historicProcessInstance !is null) {
                getHistoricProcessInstanceEntityManager().dele(historicProcessInstance, false);
            }

            // Also delete any sub-processes that may be active (ACT-821)

            List!HistoricProcessInstance selectList = getHistoricProcessInstanceEntityManager().findHistoricProcessInstancesBySuperProcessInstanceId(processInstanceId);
            foreach (HistoricProcessInstance child ; selectList) {
                recordProcessInstanceDeleted(child.getId(), processDefinitionId, child.getTenantId());
            }
        }
    }

    public void recordDeleteHistoricProcessInstancesByProcessDefinitionId(string processDefinitionId) {
        if (getHistoryManager().isHistoryEnabled(processDefinitionId)) {
            List!string historicProcessInstanceIds = getHistoricProcessInstanceEntityManager().findHistoricProcessInstanceIdsByProcessDefinitionId(processDefinitionId);
            foreach (string historicProcessInstanceId ; historicProcessInstanceIds) {
                // The tenantId is not important for the DefaultHistoryManager
                recordProcessInstanceDeleted(historicProcessInstanceId, processDefinitionId, null);
            }
        }
    }

    // Activity related history

    public void recordActivityStart(ActivityInstance activityInstance) {
        if (activityInstance !is null && isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, activityInstance.getProcessDefinitionId())) {
            if (activityInstance.getActivityId() !is null && activityInstance.getActivityId().length != 0) {
                // Historic activity instance could have been created (but only in cache, never persisted)
                // for example when submitting form properties
                HistoricActivityInstanceEntity historicActivityInstanceEntity = createNewHistoricActivityInstance(activityInstance);
                // Fire event
                FlowableEventDispatcher eventDispatcher = getEventDispatcher();
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    eventDispatcher.dispatchEvent(
                        FlowableEventBuilder
                            .createEntityEvent(FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_CREATED, cast(Object)historicActivityInstanceEntity));
                }
            }
        }
    }

    public void recordActivityEnd(ActivityInstance activityInstance) {
        if (activityInstance !is null && isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, activityInstance.getProcessDefinitionId())) {
            HistoricActivityInstanceEntity historicActivityInstance = getHistoricActivityInstanceEntityManager().findById(activityInstance.getId());
            historicActivityInstance.setDeleteReason(activityInstance.getDeleteReason());
            historicActivityInstance.setEndTime(activityInstance.getEndTime());
            historicActivityInstance.setDurationInMillis(activityInstance.getDurationInMillis());

            // Fire event
            FlowableEventDispatcher eventDispatcher = getEventDispatcher();
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_ENDED, cast(Object)historicActivityInstance));
            }
        }
    }

    public void recordActivityEnd(ExecutionEntity executionEntity, string deleteReason, Date endTime) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, executionEntity.getProcessDefinitionId())) {
            HistoricActivityInstanceEntity historicActivityInstance = findHistoricActivityInstance(executionEntity, true);
            if (historicActivityInstance !is null) {
                historicActivityInstance.markEnded(deleteReason, endTime);

                // Fire event
                FlowableEventDispatcher eventDispatcher = getEventDispatcher();
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_ENDED, cast(Object)historicActivityInstance));
                }
            }
        }
    }

    public void recordProcessDefinitionChange(string processInstanceId, string processDefinitionId) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processDefinitionId)) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstanceId);
            if (historicProcessInstance !is null) {
                historicProcessInstance.setProcessDefinitionId(processDefinitionId);
            }
        }
    }

    // Task related history

    public void recordTaskCreated(TaskEntity task, ExecutionEntity execution) {
        string processDefinitionId = null;
        if (execution !is null) {
            processDefinitionId = execution.getProcessDefinitionId();
        } else if (task !is null) {
            processDefinitionId = task.getProcessDefinitionId();
        }
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId)) {
            if (execution !is null) {
                task.setExecutionId(execution.getId());
                task.setProcessInstanceId(execution.getProcessInstanceId());
                task.setProcessDefinitionId(execution.getProcessDefinitionId());

                if (execution.getTenantId() !is null) {
                    task.setTenantId(execution.getTenantId());
                }
            }
            HistoricTaskInstanceEntity historicTaskInstance = CommandContextUtil.getHistoricTaskService().recordTaskCreated(task);
            historicTaskInstance.setLastUpdateTime(processEngineConfiguration.getClock().getCurrentTime());

            if (execution !is null) {
                historicTaskInstance.setExecutionId(execution.getId());
            }
        }
    }

    public void recordTaskEnd(TaskEntity task, ExecutionEntity execution, string deleteReason, Date endTime) {
        string processDefinitionId = null;
        if (execution !is null) {
            processDefinitionId = execution.getProcessDefinitionId();
        } else if (task !is null) {
            processDefinitionId = task.getProcessDefinitionId();
        }
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId)) {
            HistoricTaskInstanceEntity historicTaskInstance = CommandContextUtil.getHistoricTaskService().recordTaskEnd(task, deleteReason, endTime);
            if (historicTaskInstance !is null) {
                historicTaskInstance.setLastUpdateTime(endTime);
            }
        }
    }

    public void recordTaskInfoChange(TaskEntity taskEntity, string activityInstanceId, Date changeTime) {
        bool assigneeChanged = false;
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, taskEntity.getProcessDefinitionId())) {
            HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
            HistoricTaskInstanceEntity originalHistoricTaskInstanceEntity = historicTaskService.getHistoricTask(taskEntity.getId());
            string originalAssignee = null;
            if (originalHistoricTaskInstanceEntity !is null) {
                originalAssignee = originalHistoricTaskInstanceEntity.getAssignee();
            }

            HistoricTaskInstanceEntity historicTaskInstance = historicTaskService.recordTaskInfoChange(taskEntity, changeTime);
            if (historicTaskInstance !is null) {
                if (originalAssignee !=  taskEntity.getAssignee()) {
                    assigneeChanged = true;
                }
            }
        }

        if (assigneeChanged && isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, taskEntity.getProcessDefinitionId())) {
            if (taskEntity.getExecutionId() !is null) {
                HistoricActivityInstanceEntity historicActivityInstance;
                if (activityInstanceId !is null && activityInstanceId.length != 0) {
                    historicActivityInstance = getHistoricActivityInstanceEntityManager().findById(activityInstanceId);
                } else {
                    // backup for the case when runtime activityInstance was not created
                    ExecutionEntity executionEntity = getExecutionEntityManager().findById(taskEntity.getExecutionId());
                    historicActivityInstance = findHistoricActivityInstance(executionEntity, true);
                }
                if (historicActivityInstance !is null) {
                    historicActivityInstance.setAssignee(taskEntity.getAssignee());
                }
            }
        }
    }

    // Variables related history

    public void recordVariableCreate(VariableInstanceEntity variable, Date createTime) {
        string processDefinitionId = null;
        if (enableProcessDefinitionHistoryLevel && variable.getProcessInstanceId() !is null && variable.getProcessInstanceId().length != 0) {
            ExecutionEntity processInstanceExecution = CommandContextUtil.getExecutionEntityManager().findById(variable.getProcessInstanceId());
            processDefinitionId = processInstanceExecution.getProcessDefinitionId();
        }

        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processDefinitionId)) {
            CommandContextUtil.getHistoricVariableService().createAndInsert(variable, createTime);
        }
    }

    public void recordHistoricDetailVariableCreate(VariableInstanceEntity variable, ExecutionEntity sourceActivityExecution, bool useActivityId,
        string activityInstanceId, Date createTime) {
        string processDefinitionId = getProcessDefinitionId(variable, sourceActivityExecution);

        if (isHistoryLevelAtLeast(HistoryLevel.FULL, processDefinitionId)) {

            HistoricDetailVariableInstanceUpdateEntity historicVariableUpdate = getHistoricDetailEntityManager().copyAndInsertHistoricDetailVariableInstanceUpdateEntity(variable, createTime);

            if (activityInstanceId !is null && activityInstanceId.length != 0) {
                historicVariableUpdate.setActivityInstanceId(activityInstanceId);
            } else {
                if (useActivityId && sourceActivityExecution !is null) {
                    HistoricActivityInstanceEntity historicActivityInstance = findHistoricActivityInstance(sourceActivityExecution, false);
                    if (historicActivityInstance !is null) {
                        historicVariableUpdate.setActivityInstanceId(historicActivityInstance.getId());
                    }
                }
            }
        }
    }

    public void recordVariableUpdate(VariableInstanceEntity variableInstanceEntity, Date updateTime) {
        string processDefinitionId = null;
        if (enableProcessDefinitionHistoryLevel && variableInstanceEntity.getProcessInstanceId() !is null) {
            ExecutionEntity processInstanceExecution = CommandContextUtil.getExecutionEntityManager().findById(variableInstanceEntity.getProcessInstanceId());
            processDefinitionId = processInstanceExecution.getProcessDefinitionId();
        }

        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processDefinitionId)) {
            CommandContextUtil.getHistoricVariableService().recordVariableUpdate(variableInstanceEntity, updateTime);
        }
    }

    public void recordVariableRemoved(VariableInstanceEntity variableInstanceEntity) {
        string processDefinitionId = null;
        if (enableProcessDefinitionHistoryLevel && variableInstanceEntity.getProcessInstanceId() !is null && variableInstanceEntity.getProcessInstanceId().length != 0) {
            ExecutionEntity processInstanceExecution = CommandContextUtil.getExecutionEntityManager().findById(variableInstanceEntity.getProcessInstanceId());
            processDefinitionId = processInstanceExecution.getProcessDefinitionId();
        }

        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, processDefinitionId)) {
            CommandContextUtil.getHistoricVariableService().recordVariableRemoved(variableInstanceEntity);
        }
    }

    public void recordFormPropertiesSubmitted(ExecutionEntity processInstance, Map!(string, string) properties, string taskId, Date createTime) {
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processInstance.getProcessDefinitionId())) {
            foreach (MapEntry!(string, string) propertyId ; properties) {
                string propertyValue = properties.get(propertyId.getKey());
                getHistoricDetailEntityManager().insertHistoricFormPropertyEntity(processInstance, propertyId.getKey(), propertyValue, taskId, createTime);
            }
        }
    }

    // Identity link related history
    public void recordIdentityLinkCreated(IdentityLinkEntity identityLink) {
        string processDefinitionId = getProcessDefinitionId(identityLink);

        // It makes no sense storing historic counterpart for an identity link that is related
        // to a process definition only as this is never kept in history
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId) && ((identityLink.getProcessInstanceId() !is null && identityLink.getProcessInstanceId().length != 0) || (identityLink.getTaskId() !is null && identityLink.getTaskId().length != 0))) {
            HistoricIdentityLinkService historicIdentityLinkService = CommandContextUtil.getHistoricIdentityLinkService();
            HistoricIdentityLinkEntity historicIdentityLinkEntity = historicIdentityLinkService.createHistoricIdentityLink();
            historicIdentityLinkEntity.setId(identityLink.getId());
            historicIdentityLinkEntity.setGroupId(identityLink.getGroupId());
            historicIdentityLinkEntity.setProcessInstanceId(identityLink.getProcessInstanceId());
            historicIdentityLinkEntity.setTaskId(identityLink.getTaskId());
            historicIdentityLinkEntity.setType(identityLink.getType());
            historicIdentityLinkEntity.setUserId(identityLink.getUserId());
            historicIdentityLinkService.insertHistoricIdentityLink(historicIdentityLinkEntity, false);
        }
    }

    public void recordIdentityLinkDeleted(IdentityLinkEntity identityLink) {
        string processDefinitionId = getProcessDefinitionId(identityLink);

        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId)) {
            CommandContextUtil.getHistoricIdentityLinkService().deleteHistoricIdentityLink(identityLink.getId());
        }
    }

    // Entity link related history
    public void recordEntityLinkCreated(EntityLinkEntity entityLink) {
        string processDefinitionId = getProcessDefinitionId(entityLink);

        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId)) {
            implementationMissing(false);
            //HistoricEntityLinkService historicEntityLinkService = CommandContextUtil.getHistoricEntityLinkService();
            //HistoricEntityLinkEntity historicEntityLinkEntity = cast(HistoricEntityLinkEntity) historicEntityLinkService.createHistoricEntityLink();
            //historicEntityLinkEntity.setId(entityLink.getId());
            //historicEntityLinkEntity.setLinkType(entityLink.getLinkType());
            //historicEntityLinkEntity.setCreateTime(entityLink.getCreateTime());
            //historicEntityLinkEntity.setScopeId(entityLink.getScopeId());
            //historicEntityLinkEntity.setScopeType(entityLink.getScopeType());
            //historicEntityLinkEntity.setScopeDefinitionId(entityLink.getScopeDefinitionId());
            //historicEntityLinkEntity.setReferenceScopeId(entityLink.getReferenceScopeId());
            //historicEntityLinkEntity.setReferenceScopeType(entityLink.getReferenceScopeType());
            //historicEntityLinkEntity.setReferenceScopeDefinitionId(entityLink.getReferenceScopeDefinitionId());
            //historicEntityLinkEntity.setHierarchyType(entityLink.getHierarchyType());
            //historicEntityLinkService.insertHistoricEntityLink(historicEntityLinkEntity, false);
        }
    }

    public void recordEntityLinkDeleted(EntityLinkEntity entityLink) {
        string processDefinitionId = getProcessDefinitionId(entityLink);

        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processDefinitionId)) {
            implementationMissing(false);
           // CommandContextUtil.getHistoricEntityLinkService().deleteHistoricEntityLink(entityLink.getId());
        }
    }

    public void updateProcessBusinessKeyInHistory(ExecutionEntity processInstance) {
        if (processInstance !is null) {
            if (isHistoryEnabled(processInstance.getProcessDefinitionId())) {
                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("updateProcessBusinessKeyInHistory : {}", processInstance.getId());
                //}

                HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstance.getId());
                if (historicProcessInstance !is null) {
                    historicProcessInstance.setBusinessKey(processInstance.getProcessInstanceBusinessKey());
                    getHistoricProcessInstanceEntityManager().update(historicProcessInstance, false);
                }
            }
        }
    }

    public void updateProcessDefinitionIdInHistory(ProcessDefinitionEntity processDefinitionEntity, ExecutionEntity processInstance) {
        if (isHistoryEnabled(processDefinitionEntity.getId())) {
            HistoricProcessInstanceEntity historicProcessInstance = getHistoricProcessInstanceEntityManager().findById(processInstance.getId());
            historicProcessInstance.setProcessDefinitionId(processDefinitionEntity.getId());
            getHistoricProcessInstanceEntityManager().update(historicProcessInstance);

            HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
            HistoricTaskInstanceQueryImpl taskQuery = new HistoricTaskInstanceQueryImpl();
            taskQuery.processInstanceId(processInstance.getId());
            List!HistoricTaskInstance historicTasks = historicTaskService.findHistoricTaskInstancesByQueryCriteria(taskQuery);
            if (historicTasks !is null) {
                foreach (HistoricTaskInstance historicTaskInstance ; historicTasks) {
                    HistoricTaskInstanceEntity taskEntity = cast(HistoricTaskInstanceEntity) historicTaskInstance;
                    taskEntity.setProcessDefinitionId(processDefinitionEntity.getId());
                    historicTaskService.updateHistoricTask(taskEntity, true);
                }
            }

            // because of upgrade runtimeActivity instances can be only subset of historicActivity instances
            HistoricActivityInstanceQueryImpl historicActivityQuery = new HistoricActivityInstanceQueryImpl();
            historicActivityQuery.processInstanceId(processInstance.getId());
            List!HistoricActivityInstance historicActivities = getHistoricActivityInstanceEntityManager().findHistoricActivityInstancesByQueryCriteria(historicActivityQuery);
            if (historicActivities !is null) {
                foreach (HistoricActivityInstance historicActivityInstance ; historicActivities) {
                    HistoricActivityInstanceEntity activityEntity = cast(HistoricActivityInstanceEntity) historicActivityInstance;
                    activityEntity.setProcessDefinitionId(processDefinitionEntity.getId());
                    getHistoricActivityInstanceEntityManager().update(activityEntity);
                }
            }
        }
    }

    public void updateHistoricActivityInstance(ActivityInstance activityInstance) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, activityInstance.getProcessDefinitionId())) {
            if (activityInstance.getExecutionId() !is null && activityInstance.getExecutionId().length != 0) {
                HistoricActivityInstanceEntity historicActivityInstance = getHistoricActivityInstanceEntityManager().findById(activityInstance.getId());
                if (historicActivityInstance !is null) {
                    historicActivityInstance.setTaskId(activityInstance.getTaskId());
                    historicActivityInstance.setAssignee(activityInstance.getAssignee());
                    historicActivityInstance.setCalledProcessInstanceId(activityInstance.getCalledProcessInstanceId());
                }
            }
        }
    }

    public void recordHistoricUserTaskLogEntry(HistoricTaskLogEntryBuilder taskLogEntryBuilder) {
        CommandContextUtil.getHistoricTaskService().createHistoricTaskLogEntry(taskLogEntryBuilder);
    }

    public void deleteHistoryUserTaskLog(long logNumber) {
        CommandContextUtil.getHistoricTaskService().deleteHistoricTaskLogEntry(logNumber);
    }

    public void createHistoricActivityInstance(ActivityInstance activityInstance) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, activityInstance.getProcessDefinitionId())) {
            createNewHistoricActivityInstance(activityInstance);
        }
    }

    protected HistoricActivityInstanceEntity createNewHistoricActivityInstance(ActivityInstance activityInstance) {
        HistoricActivityInstanceEntity historicActivityInstanceEntity = getHistoricActivityInstanceEntityManager().create();

        historicActivityInstanceEntity.setId(activityInstance.getId());

        historicActivityInstanceEntity.setProcessDefinitionId(activityInstance.getProcessDefinitionId());
        historicActivityInstanceEntity.setProcessInstanceId(activityInstance.getProcessInstanceId());
        historicActivityInstanceEntity.setCalledProcessInstanceId(activityInstance.getCalledProcessInstanceId());
        historicActivityInstanceEntity.setExecutionId(activityInstance.getExecutionId());
        historicActivityInstanceEntity.setTaskId(activityInstance.getTaskId());
        historicActivityInstanceEntity.setActivityId(activityInstance.getActivityId());
        historicActivityInstanceEntity.setActivityName(activityInstance.getActivityName());
        historicActivityInstanceEntity.setActivityType(activityInstance.getActivityType());
        historicActivityInstanceEntity.setAssignee(activityInstance.getAssignee());
        historicActivityInstanceEntity.setStartTime(activityInstance.getStartTime());
        historicActivityInstanceEntity.setEndTime(activityInstance.getEndTime());
        historicActivityInstanceEntity.setDeleteReason(activityInstance.getDeleteReason());
        historicActivityInstanceEntity.setDurationInMillis(activityInstance.getDurationInMillis());
        historicActivityInstanceEntity.setTenantId(activityInstance.getTenantId());


        getHistoricActivityInstanceEntityManager().insert(historicActivityInstanceEntity);
        return historicActivityInstanceEntity;
    }

}
