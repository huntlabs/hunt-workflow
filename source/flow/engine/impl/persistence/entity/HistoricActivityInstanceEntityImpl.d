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

module flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.ProcessEngineConfiguration;
import hunt.entity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
import hunt.Exceptions;
import hunt.time.LocalDateTime;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Long;
import hunt.String;
alias Date = LocalDateTime;

/**
 * @author Christian Stettler
 * @author Joram Barrez
 */
//class HistoricActivityInstanceEntityImpl : HistoricScopeInstanceEntityImpl implements HistoricActivityInstanceEntity {
@Table("ACT_HI_ACTINST")
class HistoricActivityInstanceEntityImpl : AbstractBpmnEngineEntity, Model ,HistoricActivityInstanceEntity  {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("REV_")
    int rev;

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
    string tenantId ;//= ProcessEngineConfiguration.NO_TENANT_ID;

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

    this() {
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
      rev = 1;
    }

    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap!(string, Object)();
        persistentState.put("endTime", new Long(endTime));
        persistentState.put("durationInMillis", new Long(durationInMillis));
        persistentState.put("deleteReason", new String(deleteReason));
        persistentState.put("executionId", new String(executionId));
        persistentState.put("taskId", new String(taskId));
        persistentState.put("assignee", new String(assignee));
        persistentState.put("calledProcessInstanceId", new String(calledProcessInstanceId));
        persistentState.put("activityId", new String(activityId));
        persistentState.put("activityName", new String(activityName));
        return cast(Object)persistentState;
    }

    // getters and setters //////////////////////////////////////////////////////
    string getId()
    {
        return id;
    }

    void setId(string id)
    {
        this.id = id;
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
        return Date.ofEpochMilli(startTime * 1000);
    }

    // common methods //////////////////////////////////////////////////////////
    public void markEnded(string deleteReason, Date endTime) {
        implementationMissing(false);
      if (this.endTime  == 0) {
        this.deleteReason = deleteReason;
        if (endTime !is null) {
          this.endTime = endTime.toEpochMilli / 1000;
        } else {
          this.endTime = CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime().toEpochMilli / 1000;
        }
        if (endTime !is null && this.startTime != 0) {
          this.durationInMillis = endTime.toEpochMilli / 1000 - startTime;
        }
      }
    }


  override
    public string toString() {
        return "HistoricActivityInstanceEntity[id=" ~ id ~ ", activityId=" ~ activityId ~ ", activityName=" ~ activityName ~ ", executionId= " ~ executionId ~ "]";
    }


    string getProcessDefinitionId()
    {
        return processDefinitionId;
    }

    LocalDateTime getStartTime()
    {
        return Date.ofEpochMilli(startTime * 1000);
    }

     LocalDateTime getEndTime()
     {
       return Date.ofEpochMilli(endTime * 1000);
     }

    long getDurationInMillis()
    {
        return durationInMillis;
    }

    string getDeleteReason()
    {
        return deleteReason;
    }

    string getProcessInstanceId()
    {
        return processInstanceId;
    }

     void setProcessInstanceId(string processInstanceId)
     {
        this.processInstanceId = processInstanceId;
     }

    void setProcessDefinitionId(string processDefinitionId)
    {
        this.processDefinitionId = processDefinitionId;
    }

    void setEndTime(LocalDateTime endTime)
    {
        this.endTime = endTime is null ? 0:  endTime.toEpochMilli / 1000;
    }

    void setStartTime(LocalDateTime startTime)
    {
        this.startTime = startTime is null ? 0 : startTime.toEpochMilli / 1000;
    }

     void setDurationInMillis(long durationInMillis)
     {
        this.durationInMillis = durationInMillis;
     }

    void setDeleteReason(string deleteReason)
    {
        this.deleteReason = deleteReason;
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
      return cast(int)(hashOf(this.id) - hashOf((cast(HistoricActivityInstanceEntityImpl)o).getId));
    }
}
