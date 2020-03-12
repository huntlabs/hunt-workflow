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
module flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.identitylink.service.impl.persistence.entity.AbstractIdentityLinkServiceNoRevisionEntity;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import hunt.entity;
alias Date = LocalDateTime;

/**
 * @author Frederik Heremans
 */

@Table("ACT_HI_IDENTITYLINK")
class HistoricIdentityLinkEntityImpl : AbstractIdentityLinkServiceNoRevisionEntity , Model,HistoricIdentityLinkEntity {
  mixin MakeModel;

  @PrimaryKey
  @Column("ID_")
  string id;

  @Column("TYPE_")
   string type;

  @Column("USER_ID_")
   string userId;

  @Column("GROUP_ID_")
   string groupId;

  @Column("TASK_ID_")
   string taskId;

  @Column("PROC_INST_ID_")
   string processInstanceId;

  @Column("SCOPE_ID_")
   string scopeId;

  @Column("SUB_SCOPE_ID_")
   string subScopeId;

  @Column("SCOPE_TYPE_")
   string scopeType;

  @Column("SCOPE_DEFINITION_ID_")
   string scopeDefinitionId;

  @Column("CREATE_TIME_")
   int createTime;

    this() {

    }

  public string getId() {
    return id;
  }


  public void setId(string id) {
    this.id = id;
  }

    public Object getPersistentState() {
        return this;
        //Map!(string, Object) persistentState = new HashMap!(string, Object)();
        //persistentState.put("id", this.id);
        //persistentState.put("type", this.type);
        //
        //if (this.userId !is null) {
        //    persistentState.put("userId", this.userId);
        //}
        //
        //if (this.groupId !is null) {
        //    persistentState.put("groupId", this.groupId);
        //}
        //
        //if (this.taskId !is null) {
        //    persistentState.put("taskId", this.taskId);
        //}
        //
        //if (this.processInstanceId !is null) {
        //    persistentState.put("processInstanceId", this.processInstanceId);
        //}
        //
        //if (this.scopeId !is null) {
        //    persistentState.put("scopeId", this.scopeId);
        //}
        //
        //if (this.subScopeId !is null) {
        //    persistentState.put("subScopeId", this.subScopeId);
        //}
        //
        //if (this.scopeType!is null) {
        //    persistentState.put("scopeType", this.scopeType);
        //}
        //
        //if (this.scopeDefinitionId !is null) {
        //    persistentState.put("scopeDefinitionId", this.scopeDefinitionId);
        //}
        //
        //if (this.createTime !is null) {
        //    persistentState.put("createTime", this.createTime);
        //}
        //
        //return persistentState;
    }

    public bool isUser() {
        return userId !is null;
    }


    public bool isGroup() {
        return groupId !is null;
    }


    public string getType() {
        return type;
    }


    public void setType(string type) {
        this.type = type;
    }


    public string getUserId() {
        return userId;
    }


    public void setUserId(string userId) {
        if (this.groupId !is null && userId !is null) {
            throw new FlowableException("Cannot assign a userId to a task assignment that already has a groupId");
        }
        this.userId = userId;
    }


    public string getGroupId() {
        return groupId;
    }


    public void setGroupId(string groupId) {
        if (this.userId !is null && groupId !is null) {
            throw new FlowableException("Cannot assign a groupId to a task assignment that already has a userId");
        }
        this.groupId = groupId;
    }


    public string getTaskId() {
        return taskId;
    }


    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public string getScopeId() {
        return this.scopeId;
    }


    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }


    public string getSubScopeId() {
        return subScopeId;
    }


    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }


    public string getScopeType() {
        return this.scopeType;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public string getScopeDefinitionId() {
        return this.scopeDefinitionId;
    }


    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(createTime);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = cast(int)createTime.toEpochMilli;
    }
}
