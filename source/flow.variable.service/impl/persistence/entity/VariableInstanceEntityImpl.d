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
module flow.variable.service.impl.persistence.entity.VariableInstanceEntityImpl;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.variable.service.api.types.ValueFields;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.impl.persistence.entity.AbstractVariableServiceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import hunt.Long;
import hunt.Double;
import hunt.entity;
import hunt.util.StringBuilder;
import hunt.Exceptions;
import flow.variable.service.impl.persistence.entity.VariableByteArrayRef;
/**
 * @author Tom Baeyens
 * @author Marcus Klimstra (CGI)
 * @author Joram Barrez
 */
@Table("ACT_RU_VARIABLE")
class VariableInstanceEntityImpl : AbstractVariableServiceEntity , Model, VariableInstanceEntity, ValueFields {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

     @Column("NAME_")
     string name;

     @Column("TYPE_")
     string typeName;

     @Column("EXECUTION_ID_")
     string executionId;

     @Column("PROC_INST_ID_")
     string processInstanceId;

     @Column("TASK_ID_")
     string taskId;

     @Column("SCOPE_ID_")
     string scopeId;

     @Column("SUB_SCOPE_ID_")
     string subScopeId;

     @Column("SCOPE_TYPE_")
     string scopeType;

     @Column("LONG_")
     long longValue;

     @Column("DOUBLE_")
     double doubleValue;

     @Column("TEXT_")
     string textValue;

     @Column("TEXT2_")
     string textValue2;

      @Column("REV_")
      int rev;

     private bool forcedUpdate;
     private bool deleted;

     private VariableByteArrayRef byteArrayRef;
     private VariableType type;
     private Object cachedValue;
     private string processDefinitionId;

    this() {
        rev = 1;
    }

    public Object getPersistentState() {
        return this;
        //Map<string, Object> persistentState = new HashMap<>();
        //persistentState.put("name", name);
        //if (type !is null) {
        //    persistentState.put("typeName", type.getTypeName());
        //}
        //persistentState.put("executionId", executionId);
        //persistentState.put("scopeId", scopeId);
        //persistentState.put("subScopeId", subScopeId);
        //persistentState.put("scopeType", scopeType);
        //persistentState.put("longValue", longValue);
        //persistentState.put("doubleValue", doubleValue);
        //persistentState.put("textValue", textValue);
        //persistentState.put("textValue2", textValue2);
        //if (byteArrayRef !is null && byteArrayRef.getId() !is null) {
        //    persistentState.put("byteArrayValueId", byteArrayRef.getId());
        //}
        //if (forcedUpdate) {
        //    persistentState.put("forcedUpdate", Boolean.TRUE);
        //}
        //return persistentState;
    }

    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public void forceUpdate() {
        forcedUpdate = true;
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

    // byte array value ///////////////////////////////////////////////////////////


    public byte[] getBytes() {
        ensureByteArrayRefInitialized();
        return byteArrayRef.getBytes();
    }


    public void setBytes(byte[] bytes) {
        implementationMissing(false);
        //ensureByteArrayRefInitialized();
        //byteArrayRef.setValue("var-" + name, bytes);
    }


    public VariableByteArrayRef getByteArrayRef() {
        return byteArrayRef;
    }

    protected void ensureByteArrayRefInitialized() {
        if (byteArrayRef is null) {
            byteArrayRef = new VariableByteArrayRef();
        }
    }

    // value //////////////////////////////////////////////////////////////////////


    public Object getValue() {
        if (!type.isCachable() || cachedValue is null) {
            cachedValue = type.getValue(this);
        }
        return cachedValue;
    }


    public void setValue(Object value) {
        type.setValue(value, this);
        typeName = type.getTypeName();
        cachedValue = value;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public void setName(string name) {
        this.name = name;
    }


    public string getName() {
        return name;
    }


    public string getTypeName() {
        if (typeName !is null) {
            return typeName;
        } else if (type !is null) {
            return type.getTypeName();
        } else {
            return typeName;
        }
    }


    public void setTypeName(string typeName) {
        this.typeName = typeName;
    }


    public VariableType getType() {
        return type;
    }


    public void setType(VariableType type) {
        this.type = type;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public string getTaskId() {
        return taskId;
    }


    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }


    public string getExecutionId() {
        return executionId;
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


    public Long getLongValue() {
        return longValue;
    }


    public void setLongValue(Long longValue) {
        this.longValue = longValue;
    }


    public Double getDoubleValue() {
        return doubleValue;
    }


    public void setDoubleValue(Double doubleValue) {
        this.doubleValue = doubleValue;
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

    // misc methods ///////////////////////////////////////////////////////////////

    override
    public string toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("VariableInstanceEntity[");
        sb.append("id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", type=").append(type !is null ? type.getTypeName() : "null");
        if (longValue !is null) {
            sb.append(", longValue=").append(longValue);
        }
        if (doubleValue !is null) {
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

}
