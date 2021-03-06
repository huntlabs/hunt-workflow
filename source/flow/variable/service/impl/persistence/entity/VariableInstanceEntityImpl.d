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


import flow.common.persistence.entity.Entity;
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
import flow.variable.service.impl.types.IntegerType;
import flow.variable.service.impl.types.DateType;
import flow.variable.service.impl.types.StringType;
import flow.variable.service.impl.types.BooleanType;
import flow.variable.service.impl.types.ShortType;
import flow.variable.service.impl.types.DoubleType;
import flow.variable.service.impl.types.NullType;
import flow.variable.service.impl.types.LongType;
import hunt.String;
import hunt.Long;
import hunt.Double;
import hunt.Integer;
import hunt.Boolean;

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
        doubleValue = 0;
    }

    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap!(string,Object)();
        persistentState.put("name", new String(name));
        if (type !is null) {
            persistentState.put("typeName", new String(type.getTypeName()));
        }
        persistentState.put("executionId", new String(executionId));
        persistentState.put("scopeId", new String(scopeId));
        persistentState.put("subScopeId", new String(subScopeId));
        persistentState.put("scopeType", new String(scopeType));
        persistentState.put("longValue", new Long(longValue));
        persistentState.put("doubleValue", new Double(doubleValue));
        persistentState.put("textValue", new String(textValue));
        persistentState.put("textValue2", new String(textValue2));
        if (byteArrayRef !is null && byteArrayRef.getId() !is null) {
            persistentState.put("byteArrayValueId",new String(byteArrayRef.getId()));
        }
        if (forcedUpdate) {
            persistentState.put("forcedUpdate", Boolean.TRUE);
        }
        return cast(Object)persistentState;
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
  //import flow.variable.service.impl.types.IntegerType;
  //import flow.variable.service.impl.types.DateType;
  //import flow.variable.service.impl.types.StringType;
  //import flow.variable.service.impl.types.BooleanType;
  //import flow.variable.service.impl.types.ShortType;
  //import flow.variable.service.impl.types.DoubleType;
  //import flow.variable.service.impl.types.NullType;
  //import flow.variable.service.impl.types.LongType;

    public Object getValue() {
        if (type is null)
        {
            switch(typeName)
            {
              case IntegerType.TYPE_NAME :
              {
                  type = new IntegerType;
                  break;
              }
              case DateType.TYPE_NAME :
              {
                  type = new DateType;
                  break;
              }
              case StringType.TYPE_NAME :
              {
                  type = new StringType(4000);
                  break;
              }
              case BooleanType.TYPE_NAME :
              {
                  type = new BooleanType;
                  break;
              }
              case ShortType.TYPE_NAME :
              {
                  type = new ShortType;
                  break;
              }
              case DoubleType.TYPE_NAME :
              {
                  type = new DoubleType;
                  break;
              }
              case NullType.TYPE_NAME :
              {
                  type = new NullType;
                  break;
              }
              case LongType.TYPE_NAME :
              {
                  type = new LongType;
                  break;
              }
              default :
                  break;
            }
        }
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

    // misc methods ///////////////////////////////////////////////////////////////

    override
    public string toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("VariableInstanceEntity[");
        sb.append("id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", type=").append(type !is null ? type.getTypeName() : "null");
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
    return cast(int)(hashOf(this.id) - hashOf((cast(VariableInstanceEntityImpl)o).getId));
  }
}
