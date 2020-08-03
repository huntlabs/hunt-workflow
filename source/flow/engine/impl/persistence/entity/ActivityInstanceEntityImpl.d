/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module flow.engine.impl.persistence.entity.ActivityInstanceEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.util.CommandContextUtil;
import hunt.entity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
import hunt.time.LocalDateTime;
import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
import hunt.Exceptions;
import flow.common.persistence.entity.Entity;
alias Date = LocalDateTime;
/**
 * @author martin.grofcik
 */
@Table("ACT_RU_ACTINST")
class ActivityInstanceEntityImpl : AbstractBpmnEngineEntity , Model, ActivityInstanceEntity {

     mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("REV_")
    int rev;

    @Column("PROC_INST_ID_")
    string processInstanceId;

    @Column("PROC_DEF_ID_")
    string processDefinitionId;

    @Column("START_TIME_")
    long startTime;

    @Column("END_TIME_")
    long endTime;

    @Column("DURATION_")
    long durationInMillis;

    @Column("DELETE_REASON_")
    string deleteReason;

    @Column("ACT_ID_")
    string activityId;

    @Column("ACT_NAME_")
    string activityName;

    @Column("ACT_TYPE_")
    string activityType;

    @Column("EXECUTION_ID_")
    string executionId;

    @Column("ASSIGNEE_")
    string assignee;

    @Column("TASK_ID_")
    string taskId;

    @Column("CALL_PROC_INST_ID_")
    string calledProcessInstanceId;

    @Column("TENANT_ID_")
    string tenantId ;// = ProcessEngineConfiguration.NO_TENANT_ID;

    this() {
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
      rev = 1;
    }

    public Object getPersistentState() {
          implementationMissing(false);
        return null;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("endTime", endTime);
        //persistentState.put("durationInMillis", durationInMillis);
        //persistentState.put("deleteReason", deleteReason);
        //persistentState.put("executionId", executionId);
        //persistentState.put("taskId", taskId);
        //persistentState.put("assignee", assignee);
        //persistentState.put("calledProcessInstanceId", calledProcessInstanceId);
        //persistentState.put("activityId", activityId);
        //persistentState.put("activityName", activityName);
        //return persistentState;
    }

    public void markEnded(string deleteReason) {
        if (this.endTime  == 0) {
            this.deleteReason = deleteReason;
            this.endTime = CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime().toEpochMilli / 1000;
            if (endTime != 0 && startTime != 0) {
                this.durationInMillis = endTime - startTime;
            }
        }
    }

     string getId()
     {
        return id;
     }

     void setId(string id)
     {
        this.id = id;
     }
    // getters and setters ////////////////////////////////////////////////////////

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public Date getStartTime() {
        return startTime == 0 ? null :Date.ofEpochMilli(startTime *1000);
    }

    public Date getEndTime() {
        return  endTime == 0? null : Date.ofEpochMilli(endTime* 1000);
    }

    public long getDurationInMillis() {
        return durationInMillis;
    }

    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime.toEpochMilli / 1000;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime.toEpochMilli / 1000;
    }

    public void setDurationInMillis(long durationInMillis) {
        this.durationInMillis = durationInMillis;
    }

    public string getDeleteReason() {
        return deleteReason;
    }

    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
    }

    public string getActivityId() {
        return activityId;
    }

    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }

    public string getActivityName() {
        return activityName;
    }

    public void setActivityName(string activityName) {
        this.activityName = activityName;
    }

    public string getActivityType() {
        return activityType;
    }

    public void setActivityType(string activityType) {
        this.activityType = activityType;
    }

    public string getExecutionId() {
        return executionId;
    }

    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    public string getAssignee() {
        return assignee;
    }

    public void setAssignee(string assignee) {
        this.assignee = assignee;
    }

    public string getTaskId() {
        return taskId;
    }

    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    public string getCalledProcessInstanceId() {
        return calledProcessInstanceId;
    }

    public void setCalledProcessInstanceId(string calledProcessInstanceId) {
        this.calledProcessInstanceId = calledProcessInstanceId;
    }

    public string getTenantId() {
        return tenantId;
    }

    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    public Date getTime() {
        return getStartTime();
    }

    override
    public string toString() {
        return "ActivityInstanceEntity[id=" ~ id ~ ", activityId=" ~ activityId ~ ", activityName=" ~ activityName ~ ", executionId= " ~ executionId ~ "]";
    }

    override
   string getIdPrefix()
   {
      return super.getIdPrefix;
   }

    override
    bool isInserted()
    {
        return super.isInserted();
    }

    override
    void setInserted(bool inserted)
    {
        return super.setInserted(inserted);
    }

    override
     bool isUpdated()
     {
        return super.isUpdated;
     }

    override
     void setUpdated(bool updated)
     {
        super.setUpdated(updated);
     }

     override
     bool isDeleted()
     {
        return super.isDeleted;
     }

    override
    void setDeleted(bool deleted)
    {
        super.setDeleted(deleted);
    }

      override
     Object getOriginalPersistentState()
     {
          return super.getOriginalPersistentState;
     }

    override
     void setOriginalPersistentState(Object persistentState)
     {
        super.setOriginalPersistentState(persistentState);
     }

    override
    void setRevision(int revision)
    {
        super.setRevision(revision);
    }

    override
    int getRevision()
    {
        return super.getRevision;
    }

    override
   int getRevisionNext()
   {
        return super.getRevisionNext;
   }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.id) - hashOf((cast(ActivityInstanceEntityImpl)o).getId));
    }
}
