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

import flow.common.persistence.entity.Entity;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import hunt.Long;
import flow.common.api.FlowableException;
import flow.identitylink.service.impl.persistence.entity.AbstractIdentityLinkServiceNoRevisionEntity;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import hunt.entity;
import hunt.String;
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
   long createTime;

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
        Map!(string, Object) persistentState = new HashMap!(string, Object)();
        persistentState.put("id", new String(id));
        persistentState.put("type", new String(type));

        //if (this.userId !is null) {
            persistentState.put("userId", new String(userId));
        //}

        //if (this.groupId !is null) {
            persistentState.put("groupId", new String(groupId));
        //}

        //if (this.taskId !is null) {
            persistentState.put("taskId", new String(taskId));
        //}

        //if (this.processInstanceId !is null) {
            persistentState.put("processInstanceId", new String(processInstanceId));
        //}

        //if (this.scopeId !is null) {
            persistentState.put("scopeId", new String(scopeId));
        //}

        //if (this.subScopeId !is null) {
            persistentState.put("subScopeId", new String(subScopeId));
        //}

        //if (this.scopeType!is null) {
            persistentState.put("scopeType", new String(scopeType));
        //}

        //if (this.scopeDefinitionId !is null) {
            persistentState.put("scopeDefinitionId", new String(scopeDefinitionId));
        //}

        //if (this.createTime !is null) {
            persistentState.put("createTime", new Long(createTime));
        //}

        return cast(Object)persistentState;
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
        return Date.ofEpochMilli(createTime * 1000);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime.toEpochMilli / 1000;
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

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.id) - hashOf((cast(HistoricIdentityLinkEntityImpl)o).getId));
    }
}
