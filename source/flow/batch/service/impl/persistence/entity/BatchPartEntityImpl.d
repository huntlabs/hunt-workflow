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
module flow.batch.service.impl.persistence.entity.BatchPartEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.batch.service.impl.persistence.entity.AbstractBatchServiceEntity;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;
import flow.batch.service.impl.persistence.entity.BatchByteArrayRef;
alias Date = LocalDateTime;
import hunt.entity;
import flow.common.persistence.entity.Entity;

@Table("FLW_RU_BATCH_PART")
class BatchPartEntityImpl : AbstractBatchServiceEntity , Model, BatchPartEntity {
     mixin MakeModel;
     private string BATCH_RESULT_LABEL = "batchPartResult";
     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("REV_")
     int rev;

     @Column("TYPE_")
     string batchType;

     @Column("BATCH_ID_")
     string batchId;

     @Column("SCOPE_ID_")
     string scopeId;

     @Column("SUB_SCOPE_ID_")
     string subScopeId;

     @Column("SCOPE_TYPE_")
     string scopeType;

     @Column("SEARCH_KEY_")
     string batchSearchKey;

     @Column("SEARCH_KEY2_")
     string batchSearchKey2;

     @Column("CREATE_TIME_")
     long createTime;

     @Column("COMPLETE_TIME_")
     long completeTime;

     @Column("STATUS_")
     string status;

     @Column("TENANT_ID_")
     string tenantId;
     private BatchByteArrayRef resultDocRefId;

    this()
    {
        rev = 1;
    }

    public Object getPersistentState() {
        return this;
        //Map<string, Object> persistentState = new HashMap<>();
        //persistentState.put("batchId", batchId);
        //persistentState.put("batchType", batchType);
        //persistentState.put("scopeId", scopeId);
        //persistentState.put("subScopeId", subScopeId);
        //persistentState.put("scopeType", scopeType);
        //persistentState.put("createTime", createTime);
        //persistentState.put("completeTime", completeTime);
        //persistentState.put("batchSearchKey", batchSearchKey);
        //persistentState.put("batchSearchKey2", batchSearchKey2);
        //persistentState.put("status", status);
        //persistentState.put("tenantId", tenantId);
        //
        //if (resultDocRefId !is null) {
        //    persistentState.put("resultDocRefId", resultDocRefId);
        //}
        //
        //return persistentState;
    }


    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }


    public string getBatchType() {
        return batchType;
    }


    public void setBatchType(string batchType) {
        this.batchType = batchType;
    }


    public string getBatchId() {
        return batchId;
    }


    public void setBatchId(string batchId) {
        this.batchId = batchId;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(createTime * 1000);
    }


    public void setCreateTime(Date time) {
        this.createTime = time.toEpochMilli() / 1000;
    }


    public Date getCompleteTime() {
        return Date.ofEpochMilli(completeTime *1000);
    }


    public void setCompleteTime(Date time) {
        this.completeTime = time.toEpochMilli() / 1000;
    }


    public bool isCompleted() {
        return completeTime != 0;
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


    public string getBatchSearchKey() {
        return batchSearchKey;
    }


    public void setBatchSearchKey(string batchSearchKey) {
        this.batchSearchKey = batchSearchKey;
    }


    public string getBatchSearchKey2() {
        return batchSearchKey2;
    }


    public void setBatchSearchKey2(string batchSearchKey2) {
        this.batchSearchKey2 = batchSearchKey2;
    }


    public string getStatus() {
        return status;
    }


    public void setStatus(string status) {
        this.status = status;
    }


    public BatchByteArrayRef getResultDocRefId() {
        return resultDocRefId;
    }

    public void setResultDocRefId(BatchByteArrayRef resultDocRefId) {
        this.resultDocRefId = resultDocRefId;
    }


    public string getResultDocumentJson() {
        if (resultDocRefId !is null && resultDocRefId.getEntity() !is null) {
            byte[] bytes = resultDocRefId.getEntity().getBytes();
            if (bytes !is null) {
                return cast(string)bytes;
               // return new string(bytes, StandardCharsets.UTF_8);
            }
        }
        return null;
    }


    public void setResultDocumentJson(string resultDocumentJson) {
        this.resultDocRefId = setByteArrayRef(this.resultDocRefId, BATCH_RESULT_LABEL, resultDocumentJson);
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    private static BatchByteArrayRef setByteArrayRef(BatchByteArrayRef byteArrayRef, string name, string value) {
        if (byteArrayRef is null) {
            byteArrayRef = new BatchByteArrayRef();
        }
        byte[] bytes = null;
        if (value !is null) {
           // bytes = value.getBytes(StandardCharsets.UTF_8);
            bytes = cast(byte[])value;
        }
        byteArrayRef.setValue(name, bytes);
        return byteArrayRef;
    }


    override string getIdPrefix()
    {
        return super.getIdPrefix();
    }

  override int getRevisionNext() {
    return super.getRevisionNext;
  }


  override int getRevision() {
    return super.getRevision;
  }


  override void setRevision(int revision) {
      super.setRevision(revision);
  }


  override bool isInserted() {
    return super.isInserted;
  }


  override void setInserted(bool isInserted) {
      super.setInserted(isInserted);
  }


  override bool isUpdated() {
      return super.isUpdated;
  }


  override void setUpdated(bool isUpdated) {
      super.setUpdated(isUpdated);
  }


  override bool isDeleted() {
    return super.isDeleted();
  }


  override void setDeleted(bool isDeleted) {
      super.setDeleted(isDeleted);
  }


  override Object getOriginalPersistentState() {
    return super.getOriginalPersistentState;
  }


  override void setOriginalPersistentState(Object persistentState) {
      super.setOriginalPersistentState(persistentState);
  }

  int opCmp(Entity o)
  {
    return cast(int)(hashOf(this.id) - hashOf((cast(BatchPartEntityImpl)o).getId));
  }
}
