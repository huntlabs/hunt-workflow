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


import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.flowable.job.api.JobInfo;
import org.flowable.job.service.JobServiceConfiguration;

/**
 * History Job entity.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class HistoryJobEntityImpl extends AbstractJobServiceEntity implements HistoryJobEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected int retries;

    protected string jobHandlerType;
    protected string jobHandlerConfiguration;
    protected JobByteArrayRef customValuesByteArrayRef;
    protected JobByteArrayRef advancedJobHandlerConfigurationByteArrayRef;

    protected JobByteArrayRef exceptionByteArrayRef;
    protected string exceptionMessage;

    protected string lockOwner;
    protected Date lockExpirationTime;
    protected Date createTime;
    protected string scopeType;
    
    protected string tenantId = JobServiceConfiguration.NO_TENANT_ID;

    @Override
    public Object getPersistentState() {
        Map<string, Object> persistentState = new HashMap<>();
        persistentState.put("retries", retries);
        persistentState.put("exceptionMessage", exceptionMessage);
        persistentState.put("jobHandlerType", jobHandlerType);

        putByteArrayRefIdToMap("exceptionByteArrayId", exceptionByteArrayRef, persistentState);
        putByteArrayRefIdToMap("customValuesByteArrayRef", customValuesByteArrayRef, persistentState);
        putByteArrayRefIdToMap("advancedJobHandlerConfigurationByteArrayRef", advancedJobHandlerConfigurationByteArrayRef, persistentState);

        persistentState.put("lockOwner", lockOwner);
        persistentState.put("lockExpirationTime", lockExpirationTime);
        
        persistentState.put("scopeType", scopeType);

        return persistentState;
    }

    private void putByteArrayRefIdToMap(string key, JobByteArrayRef jobByteArrayRef, Map<string, Object> map) {
        if(jobByteArrayRef !is null) {
            map.put(key, jobByteArrayRef.getId());
        }
    }

    // getters and setters
    // ////////////////////////////////////////////////////////

    @Override
    public int getRetries() {
        return retries;
    }

    @Override
    public void setRetries(int retries) {
        this.retries = retries;
    }

    @Override
    public string getJobHandlerType() {
        return jobHandlerType;
    }

    @Override
    public void setJobHandlerType(string jobHandlerType) {
        this.jobHandlerType = jobHandlerType;
    }

    @Override
    public string getJobHandlerConfiguration() {
        return jobHandlerConfiguration;
    }

    @Override
    public void setJobHandlerConfiguration(string jobHandlerConfiguration) {
        this.jobHandlerConfiguration = jobHandlerConfiguration;
    }

    @Override
    public string getCustomValues() {
        return getJobByteArrayRefAsString(customValuesByteArrayRef);
    }

    @Override
    public void setCustomValues(string customValues) {
        if (customValuesByteArrayRef is null) {
            customValuesByteArrayRef = new JobByteArrayRef();
        }
        customValuesByteArrayRef.setValue("jobCustomValues", customValues);
    }

    @Override
    public JobByteArrayRef getCustomValuesByteArrayRef() {
        return customValuesByteArrayRef;
    }

    @Override
    public void setCustomValuesByteArrayRef(JobByteArrayRef customValuesByteArrayRef) {
        this.customValuesByteArrayRef = customValuesByteArrayRef;
    }

    @Override
    public JobByteArrayRef getAdvancedJobHandlerConfigurationByteArrayRef() {
        return advancedJobHandlerConfigurationByteArrayRef;
    }

    @Override
    public string getAdvancedJobHandlerConfiguration() {
        return getJobByteArrayRefAsString(advancedJobHandlerConfigurationByteArrayRef);
    }

    @Override
    public void setAdvancedJobHandlerConfigurationByteArrayRef(JobByteArrayRef configurationByteArrayRef) {
         this.advancedJobHandlerConfigurationByteArrayRef = configurationByteArrayRef;
    }

    @Override
    public void setAdvancedJobHandlerConfiguration(string jobHandlerConfiguration) {
        if (advancedJobHandlerConfigurationByteArrayRef is null) {
            advancedJobHandlerConfigurationByteArrayRef = new JobByteArrayRef();
        }
        advancedJobHandlerConfigurationByteArrayRef.setValue("cfg", jobHandlerConfiguration);
    }

    @Override
    public void setAdvancedJobHandlerConfigurationBytes(byte[] bytes) {
        if (advancedJobHandlerConfigurationByteArrayRef is null) {
            advancedJobHandlerConfigurationByteArrayRef = new JobByteArrayRef();
        }
        advancedJobHandlerConfigurationByteArrayRef.setValue("cfg", bytes);
    }

    @Override
    public void setExceptionByteArrayRef(JobByteArrayRef exceptionByteArrayRef) {
        this.exceptionByteArrayRef = exceptionByteArrayRef;
    }

    @Override
    public JobByteArrayRef getExceptionByteArrayRef() {
        return exceptionByteArrayRef;
    }

    @Override
    public string getExceptionStacktrace() {
        return getJobByteArrayRefAsString(exceptionByteArrayRef);
    }

    @Override
    public void setExceptionStacktrace(string exception) {
        if (exceptionByteArrayRef is null) {
            exceptionByteArrayRef = new JobByteArrayRef();
        }
        exceptionByteArrayRef.setValue("stacktrace", exception);
    }

    @Override
    public string getExceptionMessage() {
        return exceptionMessage;
    }

    @Override
    public void setExceptionMessage(string exceptionMessage) {
        this.exceptionMessage = StringUtils.abbreviate(exceptionMessage, JobInfo.MAX_EXCEPTION_MESSAGE_LENGTH);
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public Date getCreateTime() {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public string getLockOwner() {
        return lockOwner;
    }

    @Override
    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }

    @Override
    public Date getLockExpirationTime() {
        return lockExpirationTime;
    }

    @Override
    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = claimedUntil;
    }

    @Override
    public string getScopeType() {
        return scopeType;
    }

    @Override
    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    private string getJobByteArrayRefAsString(JobByteArrayRef jobByteArrayRef) {
        if (jobByteArrayRef is null) {
            return null;
        }
        return jobByteArrayRef.asString();
    }

    @Override
    public string toString() {
        return "HistoryJobEntity [id=" + id + "]";
    }

}
