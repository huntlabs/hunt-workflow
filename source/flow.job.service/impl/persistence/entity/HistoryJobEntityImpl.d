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
module flow.job.service.impl.persistence.entity.HistoryJobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import hunt.entity;
import hunt.String;

alias Date = LocalDateTime;
/**
 * History Job entity.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
@Table("ACT_RU_HISTORY_JOB")
class HistoryJobEntityImpl : AbstractJobServiceEntity , Model, HistoryJobEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

     @Column("RETRIES_")
     int retries;

      @Column("HANDLER_TYPE_")
     string jobHandlerType;

     @Column("HANDLER_CFG_")
     string jobHandlerConfiguration;

     private JobByteArrayRef customValuesByteArrayRef;
     private JobByteArrayRef advancedJobHandlerConfigurationByteArrayRef;

     private JobByteArrayRef exceptionByteArrayRef;

    @Column("EXCEPTION_MSG_")
     string exceptionMessage;

     @Column("LOCK_OWNER_")
     string lockOwner;

     @Column("LOCK_EXP_TIME_")
     int lockExpirationTime;

     @Column("CREATE_TIME_")
     int createTime;

     @Column("SCOPE_TYPE_")
     string scopeType;

     @Column("TENANT_ID_")
     string tenantId;

     @Column("REV_")
     string rev;

    public Object getPersistentState() {
        return this;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("retries", retries);
        //persistentState.put("exceptionMessage", exceptionMessage);
        //persistentState.put("jobHandlerType", jobHandlerType);
        //
        //putByteArrayRefIdToMap("exceptionByteArrayId", exceptionByteArrayRef, persistentState);
        //putByteArrayRefIdToMap("customValuesByteArrayRef", customValuesByteArrayRef, persistentState);
        //putByteArrayRefIdToMap("advancedJobHandlerConfigurationByteArrayRef", advancedJobHandlerConfigurationByteArrayRef, persistentState);
        //
        //persistentState.put("lockOwner", lockOwner);
        //persistentState.put("lockExpirationTime", lockExpirationTime);
        //
        //persistentState.put("scopeType", scopeType);
        //
        //return persistentState;
    }

    private void putByteArrayRefIdToMap(string key, JobByteArrayRef jobByteArrayRef, Map!(string, Object) map) {
        if(jobByteArrayRef !is null) {
            map.put(key, new String(jobByteArrayRef.getId()));
        }
    }

    // getters and setters
    // ////////////////////////////////////////////////////////


    public int getRetries() {
        return retries;
    }


    public void setRetries(int retries) {
        this.retries = retries;
    }


    public string getJobHandlerType() {
        return jobHandlerType;
    }


    public void setJobHandlerType(string jobHandlerType) {
        this.jobHandlerType = jobHandlerType;
    }


    public string getJobHandlerConfiguration() {
        return jobHandlerConfiguration;
    }


    public void setJobHandlerConfiguration(string jobHandlerConfiguration) {
        this.jobHandlerConfiguration = jobHandlerConfiguration;
    }


    public string getCustomValues() {
        return getJobByteArrayRefAsString(customValuesByteArrayRef);
    }


    public void setCustomValues(string customValues) {
        if (customValuesByteArrayRef is null) {
            customValuesByteArrayRef = new JobByteArrayRef();
        }
        customValuesByteArrayRef.setValue("jobCustomValues", customValues);
    }


    public JobByteArrayRef getCustomValuesByteArrayRef() {
        return customValuesByteArrayRef;
    }


    public void setCustomValuesByteArrayRef(JobByteArrayRef customValuesByteArrayRef) {
        this.customValuesByteArrayRef = customValuesByteArrayRef;
    }


    public JobByteArrayRef getAdvancedJobHandlerConfigurationByteArrayRef() {
        return advancedJobHandlerConfigurationByteArrayRef;
    }


    public string getAdvancedJobHandlerConfiguration() {
        return getJobByteArrayRefAsString(advancedJobHandlerConfigurationByteArrayRef);
    }


    public void setAdvancedJobHandlerConfigurationByteArrayRef(JobByteArrayRef configurationByteArrayRef) {
         this.advancedJobHandlerConfigurationByteArrayRef = configurationByteArrayRef;
    }


    public void setAdvancedJobHandlerConfiguration(string jobHandlerConfiguration) {
        if (advancedJobHandlerConfigurationByteArrayRef is null) {
            advancedJobHandlerConfigurationByteArrayRef = new JobByteArrayRef();
        }
        advancedJobHandlerConfigurationByteArrayRef.setValue("cfg", jobHandlerConfiguration);
    }


    public void setAdvancedJobHandlerConfigurationBytes(byte[] bytes) {
        if (advancedJobHandlerConfigurationByteArrayRef is null) {
            advancedJobHandlerConfigurationByteArrayRef = new JobByteArrayRef();
        }
        advancedJobHandlerConfigurationByteArrayRef.setValue("cfg", bytes);
    }


    public void setExceptionByteArrayRef(JobByteArrayRef exceptionByteArrayRef) {
        this.exceptionByteArrayRef = exceptionByteArrayRef;
    }


    public JobByteArrayRef getExceptionByteArrayRef() {
        return exceptionByteArrayRef;
    }


    public string getExceptionStacktrace() {
        return getJobByteArrayRefAsString(exceptionByteArrayRef);
    }


    public void setExceptionStacktrace(string exception) {
        if (exceptionByteArrayRef is null) {
            exceptionByteArrayRef = new JobByteArrayRef();
        }
        exceptionByteArrayRef.setValue("stacktrace", exception);
    }


    public string getExceptionMessage() {
        return exceptionMessage;
    }


    public void setExceptionMessage(string exceptionMessage) {
        this.exceptionMessage = exceptionMessage;
       // this.exceptionMessage = StringUtils.abbreviate(exceptionMessage, JobInfo.MAX_EXCEPTION_MESSAGE_LENGTH);
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(cast(long)createTime);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = cast(int)createTime.toEpochMilli();
    }


    public string getLockOwner() {
        return lockOwner;
    }


    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }


    public Date getLockExpirationTime() {
        //return lockExpirationTime;
        return Date.ofEpochMilli(cast(long)lockExpirationTime);
    }


    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = cast(int)claimedUntil.toEpochMilli();
    }


    public string getScopeType() {
        return scopeType;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    private string getJobByteArrayRefAsString(JobByteArrayRef jobByteArrayRef) {
        if (jobByteArrayRef is null) {
            return null;
        }
        return jobByteArrayRef.asString();
    }


    override
    public string toString() {
        return "HistoryJobEntity [id=" ~ id ~ "]";
    }

}
