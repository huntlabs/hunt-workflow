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
module flow.job.service.impl.persistence.entity.JobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.Map;
import flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;
import flow.job.service.impl.persistence.entity.JobEntity;
import hunt.entity;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;
import flow.common.persistence.entity.Entity;
alias Date =LocalDateTime;

/**
 * Job entity.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
@Table("ACT_RU_JOB")
class JobEntityImpl : AbstractJobEntityImpl , Model,JobEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("LOCK_OWNER_")
    string lockOwner;

    @Column("LOCK_EXP_TIME_")
    long lockExpirationTime;

    override
    public Object getPersistentState() {
        //Map!(string, Object) persistentState = cast(Map!(string, Object)) super.getPersistentState();
        //persistentState.put("lockOwner", lockOwner);
        //persistentState.put("lockExpirationTime", lockExpirationTime);

        return this;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getLockOwner() {
        return lockOwner;
    }


    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }


    public Date getLockExpirationTime() {
        return Date.ofEpochMilli(lockExpirationTime*1000);
    }


    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = claimedUntil.toEpochMilli / 1000;
    }

    override
    void setRetries(int retries)
    {
      super.setRetries(retries);
    }

    override
    void setJobHandlerType(string jobHandlerType)
    {
      super.setJobHandlerType(jobHandlerType);
    }

    override
    void setJobHandlerConfiguration(string jobHandlerConfiguration)
    {
      super.setJobHandlerConfiguration(jobHandlerConfiguration);
    }

    override
    string getCustomValues()
    {
      return super.getCustomValues;
    }

    override
    void setCustomValues(string customValues)
    {
      super.setCustomValues(customValues);
    }


    override
    JobByteArrayRef getCustomValuesByteArrayRef()
    {
      return super.getCustomValuesByteArrayRef;
    }


    override
    string getExceptionStacktrace()
    {
      return super.getExceptionStacktrace;
    }

    override
    void setExceptionStacktrace(string exception)
    {
      super.setExceptionStacktrace(exception);
    }

    override
    void setExceptionMessage(string exceptionMessage)
    {
      super.setExceptionMessage(exceptionMessage);
    }

    override
    JobByteArrayRef getExceptionByteArrayRef()
    {
      return super.getExceptionByteArrayRef;
    }


    override
    void setTenantId(string tenantId)
    {
      super.setTenantId(tenantId);
    }


    override
    LocalDateTime getCreateTime()
    {
      return super.getCreateTime();
    }


    override
    void setRevision(int revision)
    {
      super.setRevision(revision);
    }

    override  int getRevision()
    {
      return super.getRevision();
    }

    override
    int getRevisionNext()
    {
      return super.getRevisionNext;
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
     string getId()
     {
        return id;
     }

     override void setId(string id)
     {
        this.id = id;
     }

      override
      void setExecutionId(string executionId)
      {
          super.setExecutionId(executionId);
      }

      override void setProcessInstanceId(string processInstanceId)
      {
          super.setProcessInstanceId(processInstanceId);
      }

      override
      void setProcessDefinitionId(string processDefinitionId)
      {
          super.setProcessDefinitionId(processDefinitionId);
      }


      override
     void setElementId(string elementId)
     {
        super.setElementId(elementId);
     }

     override
     void setElementName(string elementName)
     {
        super.setElementName(elementName);
     }

     override
     void setScopeId(string scopeId)
     {
        super.setScopeId(scopeId);
     }

      override
      void setSubScopeId(string subScopeId)
      {
          super.setSubScopeId(subScopeId);
      }

      override
      void setScopeType(string scopeType)
      {
          super.setScopeType(scopeType);
      }

      override
      void setScopeDefinitionId(string scopeDefinitionId)
      {
          super.setScopeDefinitionId(scopeDefinitionId);
      }

      override
      void setDuedate(LocalDateTime duedate)
      {
          super.setDuedate(duedate);
      }

      override
      void setExclusive(bool isExclusive)
      {
          super.setExclusive(isExclusive);
      }

      override
     string getRepeat()
     {
         return super.getRepeat;
     }

      override
       void setRepeat(string repeat)
       {
          super.setRepeat(repeat);
       }

      override
      LocalDateTime getEndDate()
      {
          return super.getEndDate;
      }

      override
      void setEndDate(LocalDateTime endDate)
      {
          super.setEndDate(endDate);
      }

      override
      int getMaxIterations()
      {
          return super.getMaxIterations;
      }

      override
      void setMaxIterations(int maxIterations)
      {
          super.setMaxIterations(maxIterations);
      }

      override
      void setJobType(string jobType)
      {
          super.setJobType(jobType);
      }

      override
      void setCreateTime(LocalDateTime createTime)
      {
          super.setCreateTime(createTime);
      }

      override
      public string toString() {
          return "JobEntity [id=" ~ id ~ "]";
      }

    override
  int opCmp(Entity o)
  {
    return cast(int)(hashOf(this.id) - hashOf((cast(JobEntityImpl)o).getId));
  }
}
