/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License foreach the specific language governing permissions and
 * limitations under the License.
 */
module flow.engine.impl.history.CompositeHistoryManager;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.common.history.HistoryLevel;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.runtime.ActivityInstance;
import flow.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.history.HistoryManager;

/**
 * @author Filip Hrisafov
 */
class CompositeHistoryManager : HistoryManager {

    protected  Collection!HistoryManager historyManagers;

    this(Collection!HistoryManager historyManagers) {
        this.historyManagers = new ArrayList!HistoryManager(historyManagers);
    }


    public bool isHistoryLevelAtLeast(HistoryLevel level) {
        foreach (HistoryManager historyManager ; historyManagers) {
            if (historyManager.isHistoryLevelAtLeast(level)) {
                return true;
            }
        }

        return false;
    }


    public bool isHistoryLevelAtLeast(HistoryLevel level, string processDefinitionId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            if (historyManager.isHistoryLevelAtLeast(level, processDefinitionId)) {
                return true;
            }
        }

        return false;
    }


    public bool isHistoryEnabled() {
        foreach (HistoryManager historyManager ; historyManagers) {
            if (historyManager.isHistoryEnabled()) {
                return true;
            }
        }

        return false;
    }


    public bool isHistoryEnabled(string processDefinitionId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            if (historyManager.isHistoryEnabled(processDefinitionId)) {
                return true;
            }
        }

        return false;
    }


    public void recordProcessInstanceEnd(ExecutionEntity processInstance, string deleteReason, string activityId, Date endTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordProcessInstanceEnd(processInstance, deleteReason, activityId, endTime);
        }
    }


    public void recordProcessInstanceStart(ExecutionEntity processInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordProcessInstanceStart(processInstance);
        }
    }


    public void recordProcessInstanceNameChange(ExecutionEntity processInstanceExecution, string newName) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordProcessInstanceNameChange(processInstanceExecution, newName);
        }
    }


    public void recordProcessInstanceDeleted(string processInstanceId, string processDefinitionId, string processTenantId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordProcessInstanceDeleted(processInstanceId, processDefinitionId, processTenantId);
        }
    }


    public void recordDeleteHistoricProcessInstancesByProcessDefinitionId(string processDefinitionId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordDeleteHistoricProcessInstancesByProcessDefinitionId(processDefinitionId);
        }
    }


    public void recordActivityStart(ActivityInstance activityInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordActivityStart(activityInstance);
        }
    }


    public void recordActivityEnd(ActivityInstance activityInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordActivityEnd(activityInstance);
        }
    }


    public void recordActivityEnd(ExecutionEntity executionEntity, string deleteReason, Date endTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordActivityEnd(executionEntity, deleteReason, endTime);
        }
    }


    public HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, bool validateEndTimeNull) {
        foreach (HistoryManager historyManager ; historyManagers) {
            HistoricActivityInstanceEntity historicActivityInstance = historyManager.findHistoricActivityInstance(execution, validateEndTimeNull);
            if (historicActivityInstance !is null) {
                return historicActivityInstance;
            }
        }

        return null;
    }


    public void recordProcessDefinitionChange(string processInstanceId, string processDefinitionId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordProcessDefinitionChange(processInstanceId, processDefinitionId);
        }
    }


    public void recordTaskCreated(TaskEntity task, ExecutionEntity execution) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordTaskCreated(task, execution);
        }
    }


    public void recordTaskEnd(TaskEntity task, ExecutionEntity execution, string deleteReason, Date endTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordTaskEnd(task, execution, deleteReason, endTime);
        }
    }


    public void recordTaskInfoChange(TaskEntity taskEntity, string activityInstanceId, Date changeTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordTaskInfoChange(taskEntity, activityInstanceId, changeTime);
        }
    }


    public void recordVariableCreate(VariableInstanceEntity variable, Date createTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordVariableCreate(variable, createTime);
        }
    }


    public void recordHistoricDetailVariableCreate(VariableInstanceEntity variable, ExecutionEntity sourceActivityExecution, bool useActivityId,
        string activityInstanceId, Date createTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordHistoricDetailVariableCreate(variable, sourceActivityExecution, useActivityId, activityInstanceId, createTime);
        }
    }


    public void recordVariableUpdate(VariableInstanceEntity variable, Date updateTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordVariableUpdate(variable, updateTime);
        }
    }


    public void recordVariableRemoved(VariableInstanceEntity variable) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordVariableRemoved(variable);
        }
    }


    public void createIdentityLinkComment(TaskEntity task, string userId, string groupId, string type, bool create) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createIdentityLinkComment(task, userId, groupId, type, create);
        }
    }


    public void createUserIdentityLinkComment(TaskEntity task, string userId, string type, bool create) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createUserIdentityLinkComment(task, userId, type, create);
        }
    }


    public void createGroupIdentityLinkComment(TaskEntity task, string groupId, string type, bool create) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createGroupIdentityLinkComment(task, groupId, type, create);
        }
    }


    public void createIdentityLinkComment(TaskEntity task, string userId, string groupId, string type, bool create, bool forceNullUserId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createIdentityLinkComment(task, userId, groupId, type, create, forceNullUserId);
        }
    }


    public void createUserIdentityLinkComment(TaskEntity task, string userId, string type, bool create, bool forceNullUserId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createUserIdentityLinkComment(task, userId, type, create, forceNullUserId);
        }
    }


    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createProcessInstanceIdentityLinkComment(processInstance, userId, groupId, type, create);
        }
    }


    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create,
        bool forceNullUserId) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createProcessInstanceIdentityLinkComment(processInstance, userId, groupId, type, create, forceNullUserId);
        }
    }


    public void createAttachmentComment(TaskEntity task, ExecutionEntity processInstance, string attachmentName, bool create) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createAttachmentComment(task, processInstance, attachmentName, create);
        }
    }


    public void recordFormPropertiesSubmitted(ExecutionEntity processInstance, Map!(string, string) properties, string taskId, Date createTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordFormPropertiesSubmitted(processInstance, properties, taskId, createTime);
        }
    }


    public void recordIdentityLinkCreated(IdentityLinkEntity identityLink) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordIdentityLinkCreated(identityLink);
        }
    }


    public void recordIdentityLinkDeleted(IdentityLinkEntity identityLink) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordIdentityLinkDeleted(identityLink);
        }
    }


    public void recordEntityLinkCreated(EntityLinkEntity entityLink) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordEntityLinkCreated(entityLink);
        }
    }


    public void recordEntityLinkDeleted(EntityLinkEntity entityLink) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordEntityLinkDeleted(entityLink);
        }
    }


    public void updateProcessBusinessKeyInHistory(ExecutionEntity processInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.updateProcessBusinessKeyInHistory(processInstance);
        }
    }


    public void updateProcessDefinitionIdInHistory(ProcessDefinitionEntity processDefinitionEntity, ExecutionEntity processInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.updateProcessDefinitionIdInHistory(processDefinitionEntity, processInstance);
        }
    }


    public void updateActivity(ExecutionEntity executionEntity, string oldActivityId, FlowElement newFlowElement, TaskEntity task, Date updateTime) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.updateActivity(executionEntity, oldActivityId, newFlowElement, task, updateTime);
        }
    }


    public void updateHistoricActivityInstance(ActivityInstance activityInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.updateHistoricActivityInstance(activityInstance);
        }
    }


    public void createHistoricActivityInstance(ActivityInstance activityInstance) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.createHistoricActivityInstance(activityInstance);
        }
    }


    public void recordHistoricUserTaskLogEntry(HistoricTaskLogEntryBuilder taskLogEntryBuilder) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.recordHistoricUserTaskLogEntry(taskLogEntryBuilder);
        }
    }


    public void deleteHistoryUserTaskLog(long logNumber) {
        foreach (HistoryManager historyManager ; historyManagers) {
            historyManager.deleteHistoryUserTaskLog(logNumber);
        }
    }

    public void addHistoryManager(HistoryManager historyManager) {
        historyManagers.add(historyManager);
    }
}
