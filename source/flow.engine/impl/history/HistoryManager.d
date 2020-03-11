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


import hunt.time.LocalDateTime;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.common.history.HistoryLevel;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.runtime.ActivityInstance;
import org.flowable.entitylink.api.EntityLink;
import org.flowable.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import flow.identitylink.api.IdentityLink;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;

interface HistoryManager {

    /**
     * @return true, if the configured history-level is equal to OR set to a higher value than the given level.
     */
    bool isHistoryLevelAtLeast(HistoryLevel level);

    /**
     * @return true, if the configured process definition history-level is equal to OR set to a higher value than the given level.
     */
    bool isHistoryLevelAtLeast(HistoryLevel level, string processDefinitionId);

    /**
     * @return true, if history-level is configured to level other than "none".
     */
    bool isHistoryEnabled();

    /**
     * @return true, if process definition history-level is configured to level other than "none".
     */
    bool isHistoryEnabled(string processDefinitionId);

    /**
     * Record a process-instance ended. Updates the historic process instance if activity history is enabled.
     */
    void recordProcessInstanceEnd(ExecutionEntity processInstance, string deleteReason, string activityId, Date endTime);

    /**
     * Record a process-instance started and record start-event if activity history is enabled.
     */
    void recordProcessInstanceStart(ExecutionEntity processInstance);

    /**
     * Record a process-instance name change.
     */
    void recordProcessInstanceNameChange(ExecutionEntity processInstanceExecution, string newName);

    /**
     * Deletes a historic process instance and all historic data included
     */
    void recordProcessInstanceDeleted(string processInstanceId, string processDefinitionId, string processTenantId);

    /**
     * Deletes historic process instances for a provided process definition id
     */
    void recordDeleteHistoricProcessInstancesByProcessDefinitionId(string processDefinitionId);

    /**
     * Record the start of an activity, if activity history is enabled.
     *
     * @param activityInstance activity instance template
     */
    void recordActivityStart(ActivityInstance activityInstance);

    /**
     * Record the end of an activity, if activity history is enabled.
     *
     * @param activityInstance activity instance template
     */
    void recordActivityEnd(ActivityInstance activityInstance);

    /**
     * Record activity end in the case when runtime activity instance does not exist.
     */
    void recordActivityEnd(ExecutionEntity executionEntity, string deleteReason, Date endTime);

    /**
     * Finds the {@link HistoricActivityInstanceEntity} that is active in the given execution.
     */
    HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, bool validateEndTimeNull);

    /**
     * Record a change of the process-definition id of a process instance, if activity history is enabled.
     */
    void recordProcessDefinitionChange(string processInstanceId, string processDefinitionId);

    /**
     * Record the creation of a task, if audit history is enabled.
     */
    void recordTaskCreated(TaskEntity task, ExecutionEntity execution);

    /**
     * Record task as ended, if audit history is enabled.
     */
    void recordTaskEnd(TaskEntity task, ExecutionEntity execution, string deleteReason, Date endTime);

    /**
     * Record task name change, if audit history is enabled.
     */
    void recordTaskInfoChange(TaskEntity taskEntity, string activityInstanceId, Date changeTime);

    /**
     * Record a variable has been created, if audit history is enabled.
     */
    void recordVariableCreate(VariableInstanceEntity variable, Date createTime);

    /**
     * Record a variable has been created, if audit history is enabled.
     */
    void recordHistoricDetailVariableCreate(VariableInstanceEntity variable, ExecutionEntity sourceActivityExecution, bool useActivityId,
        string activityInstanceId, Date createTime);

    /**
     * Record a variable has been updated, if audit history is enabled.
     */
    void recordVariableUpdate(VariableInstanceEntity variable, Date updateTime);

    /**
     * Record a variable has been deleted, if audit history is enabled.
     */
    void recordVariableRemoved(VariableInstanceEntity variable);

    /**
     * Creates a new comment to indicate a new {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createIdentityLinkComment(TaskEntity task, string userId, string groupId, string type, bool create);

    /**
     * Creates a new comment to indicate a new user {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createUserIdentityLinkComment(TaskEntity task, string userId, string type, bool create);

    /**
     * Creates a new comment to indicate a new group {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createGroupIdentityLinkComment(TaskEntity task, string groupId, string type, bool create);

    /**
     * Creates a new comment to indicate a new {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createIdentityLinkComment(TaskEntity task, string userId, string groupId, string type, bool create, bool forceNullUserId);

    /**
     * Creates a new comment to indicate a new user {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createUserIdentityLinkComment(TaskEntity task, string userId, string type, bool create, bool forceNullUserId);

    /**
     * Creates a new comment to indicate a new {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create);

    /**
     * Creates a new comment to indicate a new {@link IdentityLink} has been created or deleted, if history is enabled.
     */
    void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create, bool forceNullUserId);

    /**
     * Creates a new comment to indicate a new attachment has been created or deleted, if history is enabled.
     */
    void createAttachmentComment(TaskEntity task, ExecutionEntity processInstance, string attachmentName, bool create);

    /**
     * Report form properties submitted, if audit history is enabled.
     */
    void recordFormPropertiesSubmitted(ExecutionEntity processInstance, Map!(string, string) properties, string taskId, Date createTime);

    /**
     * Record the creation of a new {@link IdentityLink}, if audit history is enabled.
     */
    void recordIdentityLinkCreated(IdentityLinkEntity identityLink);

    /**
     * Record the deletion of a {@link IdentityLink}, if audit history is enabled
     */
    void recordIdentityLinkDeleted(IdentityLinkEntity identityLink);

    /**
     * Record the creation of a new {@link EntityLink}, if audit history is enabled.
     */
    void recordEntityLinkCreated(EntityLinkEntity entityLink);

    /**
     * Record the deletion of a {@link EntityLink}, if audit history is enabled
     */
    void recordEntityLinkDeleted(EntityLinkEntity entityLink);

    void updateProcessBusinessKeyInHistory(ExecutionEntity processInstance);

    /**
     * Record the update of a process definition for historic process instance, task, and activity instance, if history is enabled.
     */
    void updateProcessDefinitionIdInHistory(ProcessDefinitionEntity processDefinitionEntity, ExecutionEntity processInstance);

    /**
     * Synchronize historic data with the current user task execution
     *
     * @param executionEntity entity which executes user task
     * @param oldActivityId previous activityId
     * @param newFlowElement new flowElement
     * @param task new user task
     * @param updateTime
     */
    void updateActivity(ExecutionEntity executionEntity, string oldActivityId, FlowElement newFlowElement, TaskEntity task, Date updateTime);

    /**
     * Update historic activity instance according to changes done in the runtime activity
     * @param activityInstance
     */
    void updateHistoricActivityInstance(ActivityInstance activityInstance);

    /**
     * Create new historic activity instance from runtime activity instance
     *
     * @param activityInstance activity instance template
     */
    void createHistoricActivityInstance(ActivityInstance activityInstance);

    /**
     * Record historic user task log entry
     * @param taskLogEntryBuilder historic user task log entry description
     */
    void recordHistoricUserTaskLogEntry(HistoricTaskLogEntryBuilder taskLogEntryBuilder);

    /**
     * Delete historic user task log entry
     * @param logNumber log identifier
     */
    void deleteHistoryUserTaskLog(long logNumber);
}
