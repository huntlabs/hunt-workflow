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
module flow.job.service.impl.persistence.entity.TimerJobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.Map;
import flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;

import flow.job.service.impl.persistence.entity.TimerJobEntity;

import hunt.entity;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;
alias Date = LocalDateTime;
/**
 * TimerJob entity, necessary for persistence.
 *
 * @author Tijs Rademakers
 */
@Table("ACT_RU_TIMER_JOB")
class TimerJobEntityImpl : AbstractJobEntityImpl , Model,TimerJobEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
     string id;

    @Column("LOCK_OWNER_")
     string lockOwner;

    @Column("LOCK_EXP_TIME_")
     int lockExpirationTime;

    override
    public Object getPersistentState() {
        return this;

        //Map!(string, Object) persistentState = (Map!(string, Object)) super.getPersistentState();
        //persistentState.put("lockOwner", lockOwner);
        //persistentState.put("lockExpirationTime", lockExpirationTime);
        //
        //return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getLockOwner() {
        return lockOwner;
    }


    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }


    public Date getLockExpirationTime() {
        return Date.ofEpochMilli(cast(long)lockExpirationTime);
    }


    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = cast(int)(claimedUntil.toEpochMilli);
    }

    override
    public string toString() {
        return "TimerJobEntity [id=" ~ id ~ "]";
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
}
