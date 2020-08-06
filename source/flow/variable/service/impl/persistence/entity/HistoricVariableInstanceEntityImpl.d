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

module flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;

import flow.variable.service.api.types.VariableType;
import flow.variable.service.impl.persistence.entity.AbstractVariableServiceEntity;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableByteArrayRef;
import hunt.Long;
import hunt.Double;
import hunt.String;
import hunt.entity;
import hunt.util.StringBuilder;
import flow.common.persistence.entity.Entity;
alias Date = LocalDateTime;
/**
 * @author Christian Lipphardt (camunda)
 * @author Joram Barrez
 */
@Table("ACT_HI_VARINST")
class HistoricVariableInstanceEntityImpl : AbstractVariableServiceEntity , Model, HistoricVariableInstanceEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

     @Column("NAME_")
     string name;

     @Column("PROC_INST_ID_")
     string processInstanceId;

     @Column("EXECUTION_ID_")
     string executionId;

     @Column("TASK_ID_")
     string taskId;

     @Column("SCOPE_ID_")
     string scopeId;

     @Column("SUB_SCOPE_ID_")
     string subScopeId;

     @Column("SCOPE_TYPE_")
     string scopeType;

     @Column("CREATE_TIME_")
     long createTime;

     @Column("LAST_UPDATED_TIME_")
     long lastUpdatedTime;

     @Column("LONG_")
     long longValue;

     @Column("DOUBLE_")
     double doubleValue;

     @Column("TEXT_")
     string textValue;

     @Column("TEXT2_")
     string textValue2;

     @Column("VAR_TYPE_")
     string type;

     @Column("BYTEARRAY_ID_")
     string byteArrayId;

     @Column("REV_")
     int rev;

     private VariableByteArrayRef byteArrayRef;
     private VariableType variableType;
     private Object cachedValue;

    this() {
        rev = 1;
        doubleValue = 0;
    }


    public Object getPersistentState() {
        HashMap!(string, Object) persistentState = new HashMap!(string, Object)();

        persistentState.put("name", new String(name));
        persistentState.put("scopeId", new String(scopeId));
        persistentState.put("subScopeId", new String(subScopeId));
        persistentState.put("scopeType", new String(scopeType));
        persistentState.put("textValue", new String(textValue));
        persistentState.put("textValue2", new String(textValue2));
        persistentState.put("doubleValue", new Double(doubleValue));
        persistentState.put("longValue", new Long(longValue));

        if (variableType !is null) {
            persistentState.put("typeName", new String(variableType.getTypeName()));
        }

        if (byteArrayRef !is null) {
            persistentState.put("byteArrayRef", new String(byteArrayRef.getId()));
        }

        persistentState.put("createTime", new Long(createTime));
        persistentState.put("lastUpdatedTime", new Long(lastUpdatedTime));

        return cast(Object)persistentState;
    }




    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }


    public Object getValue() {
        if (!variableType.isCachable() || cachedValue is null) {
            cachedValue = variableType.getValue(this);
        }
        return cachedValue;
    }

    // byte array value /////////////////////////////////////////////////////////


    public byte[] getBytes() {
        if (byteArrayRef !is null) {
            return byteArrayRef.getBytes();
        }
        return null;
    }


    public void setBytes(byte[] bytes) {
        if (byteArrayRef is null) {
            byteArrayRef = new VariableByteArrayRef();
        }
        byteArrayRef.setValue("hist.var-" ~ name, bytes);
        byteArrayId = byteArrayRef.getId;
    }

    // getters and setters //////////////////////////////////////////////////////


    public string getVariableTypeName() {
        return (variableType !is null ? variableType.getTypeName() : null);
    }


    public string getVariableName() {
        return name;
    }


    public VariableType getVariableType() {
        return variableType;
    }


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public Long getLongValue() {
        return new Long(longValue);
    }


    public void setLongValue(Long longValue) {
        this.longValue = longValue.longValue;
    }


    public Double getDoubleValue() {
        return new Double(doubleValue);
    }


    public void setDoubleValue(Double doubleValue) {
        this.doubleValue = doubleValue.doubleValue;
    }


    public string getTextValue() {
        return textValue;
    }


    public void setTextValue(string textValue) {
        this.textValue = textValue;
    }


    public string getTextValue2() {
        return textValue2;
    }


    public void setTextValue2(string textValue2) {
        this.textValue2 = textValue2;
    }


    public Object getCachedValue() {
        return cachedValue;
    }


    public void setCachedValue(Object cachedValue) {
        this.cachedValue = cachedValue;
    }


    public void setVariableType(VariableType variableType) {
        this.variableType = variableType;
        this.type = variableType.getTypeName;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getTaskId() {
        return taskId;
    }


    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(createTime * 1000);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime.toEpochMilli() / 1000;
    }


    public Date getLastUpdatedTime() {
        return Date.ofEpochMilli(lastUpdatedTime * 1000);
    }


    public void setLastUpdatedTime(Date lastUpdatedTime) {
        this.lastUpdatedTime = lastUpdatedTime.toEpochMilli() / 1000;
    }


    public Date getTime() {
        return Date.ofEpochMilli(createTime * 1000);
    }


    public string getExecutionId() {
        return executionId;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public string getScopeId() {
        return scopeId;
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
        return scopeType;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public VariableByteArrayRef getByteArrayRef() {
        return byteArrayRef;
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("HistoricVariableInstanceEntity[");
        sb.append("id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", revision=").append(getRevision());
        sb.append(", type=").append(variableType !is null ? variableType.getTypeName() : "null");
        if (longValue != 0) {
            sb.append(", longValue=").append(longValue);
        }
        if (doubleValue != 0) {
            sb.append(", doubleValue=").append(doubleValue);
        }
        if (textValue !is null) {
            sb.append(", textValue=").append(textValue);
        }
        if (textValue2 !is null) {
            sb.append(", textValue2=").append(textValue2);
        }
        if (byteArrayRef !is null && byteArrayRef.getId() !is null) {
            sb.append(", byteArrayValueId=").append(byteArrayRef.getId());
        }
        sb.append("]");
        return sb.toString();
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
      return cast(int)(hashOf(this.id) - hashOf((cast(HistoricVariableInstanceEntityImpl)o).getId));
    }
}
