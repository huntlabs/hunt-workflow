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

module flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityImpl;
import hunt.time.LocalDateTime;

import flow.common.persistence.entity.AbstractEntityNoRevision;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
import hunt.entity;
import std.conv;
/**
 * @author martin.grofcik
 */

alias Date = LocalDateTime;

@Table("ACT_HI_TSK_LOG")
class HistoricTaskLogEntryEntityImpl : AbstractEntityNoRevision , Model,HistoricTaskLogEntryEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("TYPE_")
    string type;

    @Column("TASK_ID_")
    string taskId;

     @Column("TIME_STAMP_")
    long timeStamp;

     @Column("USER_ID_")
    string userId;

  @Column("DATA_")
    string data;

  @Column("EXECUTION_ID_")
    string executionId;

  @Column("PROC_INST_ID_")
    string processInstanceId;

  @Column("PROC_DEF_ID_")
    string processDefinitionId;

  @Column("SCOPE_ID_")
    string scopeId;

  @Column("SCOPE_DEFINITION_ID_")
    string scopeDefinitionId;

  @Column("SUB_SCOPE_ID_")
    string subScopeId;

  @Column("SCOPE_TYPE_")
    string scopeType;

  @Column("TENANT_ID_")
    string tenantId;
    private long logNumber;

    this() {
    }

    override
    public string getId() {
      return id;
    }

    override
    public void setId(string id) {
        this.id = id;
    }

    public Object getPersistentState() {
        return null; // Not updatable
    }


    public void setType(string type) {
        this.type = type;
    }


    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }


    public void setTimeStamp(Date timeStamp) {
        this.timeStamp = timeStamp;
    }


    public void setUserId(string userId) {
        this.userId = userId;
    }


    public void setData(string data) {
        this.data = data;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }


    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }


    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public string getIdPrefix() {
        // id prefix is empty because sequence is used instead of id prefix
        return "";
    }


    public void setLogNumber(long logNumber) {
        this.logNumber = logNumber;
    }


    public long getLogNumber() {
        return logNumber;
    }


    public string getType() {
        return type;
    }


    public string getTaskId() {
        return taskId;
    }


    public Date getTimeStamp() {
        return timeStamp;
    }


    public string getUserId() {
        return userId;
    }


    public string getData() {
        return data;
    }


    public string getExecutionId() {
        return executionId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public string getScopeId() {
        return scopeId;
    }


    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }


    public string getSubScopeId() {
        return subScopeId;
    }

    public string getScopeType() {
        return scopeType;
    }


    public string getTenantId() {
        return tenantId;
    }

    override
    public string toString() {
        return "(" ~ to!string(logNumber) ~ ", " ~ getTaskId() ~ ", " ~ type ~")";
    }
}
