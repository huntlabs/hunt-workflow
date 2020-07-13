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
module flow.batch.service.impl.persistence.entity.BatchEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.batch.service.impl.persistence.entity.AbstractBatchServiceEntity;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.impl.persistence.entity.BatchByteArrayRef;
import hunt.entity;
alias Date = LocalDateTime;

@Table("FLW_RU_BATCH")
class BatchEntityImpl : AbstractBatchServiceEntity , Model, BatchEntity {
     mixin MakeModel;
     private string BATCH_DOCUMENT_JSON_LABEL = "batchDocumentJson";
     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("REV_")
     int rev;

     @Column("TYPE_")
     string batchType;

     @Column("CREATE_TIME_")
     int createTime;

     @Column("COMPLETE_TIME_")
     int completeTime;

     @Column("SEARCH_KEY_")
     string batchSearchKey;

     @Column("SEARCH_KEY2_")
     string batchSearchKey2;

     @Column("STATUS_")
     string status;

     @Column("TENANT_ID_")
     string tenantId;
     private BatchByteArrayRef batchDocRefId;

    this()
    {
      rev = 1;
    }


    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public Object getPersistentState() {
        return this;
        //Map<string, Object> persistentState = new HashMap<>();
        //persistentState.put("batchType", batchType);
        //persistentState.put("createTime", createTime);
        //persistentState.put("completeTime", completeTime);
        //persistentState.put("batchSearchKey", batchSearchKey);
        //persistentState.put("batchSearchKey2", batchSearchKey2);
        //persistentState.put("status", status);
        //persistentState.put("tenantId", tenantId);
        //
        //if (batchDocRefId !is null) {
        //    persistentState.put("batchDocRefId", batchDocRefId);
        //}
        //
        //return persistentState;
    }


    public string getBatchType() {
        return batchType;
    }


    public void setBatchType(string batchType) {
        this.batchType = batchType;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(cast(long)createTime);
    }

    public void setCreateTime(Date time) {
        this.createTime = cast(int)time.toEpochMilli();
    }


    public Date getCompleteTime() {
        return Date.ofEpochMilli(cast(long)completeTime);
    }

    public void setCompleteTime(Date completeTime) {
        this.completeTime = cast(int)completeTime.toEpochMilli();
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


    public BatchByteArrayRef getBatchDocRefId() {
        return batchDocRefId;
    }

    public void setBatchDocRefId(BatchByteArrayRef batchDocRefId) {
        this.batchDocRefId = batchDocRefId;
    }


    public string getBatchDocumentJson() {
        if (batchDocRefId !is null) {
            byte[] bytes = batchDocRefId.getBytes();
            if (bytes !is null) {
                 return cast(string) bytes;
                //return new string(bytes, StandardCharsets.UTF_8);
            }
        }
        return null;
    }


    public void setBatchDocumentJson(string batchDocumentJson) {
        this.batchDocRefId = setByteArrayRef(this.batchDocRefId, BATCH_DOCUMENT_JSON_LABEL, batchDocumentJson);
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
            bytes = cast(byte[])value;
            //bytes = value.getBytes(StandardCharsets.UTF_8);
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

}

