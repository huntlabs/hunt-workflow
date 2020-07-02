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
module flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEntity;
import flow.job.service.api.Job;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;

alias Date = LocalDateTime;

/**
 * Abstract job entity class.
 *
 * @author Tijs Rademakers
 */
class AbstractJobEntityImpl : AbstractJobServiceEntity , AbstractRuntimeJobEntity {


    protected Date createTime;
    protected Date duedate;

    protected string id;

    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;

    protected string elementId;
    protected string elementName;

    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;

    protected bool _isExclusive  = true;

    protected int retries;

    protected int maxIterations;
    protected string repeat;
    protected Date endDate;

    protected string jobHandlerType;
    protected string jobHandlerConfiguration;
    protected JobByteArrayRef customValuesByteArrayRef;

    protected JobByteArrayRef exceptionByteArrayRef;
    protected string exceptionMessage;

    protected string tenantId  ;//= JobServiceConfiguration.NO_TENANT_ID;
    protected string jobType;

    public Object getPersistentState() {
        return this;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("retries", retries);
        //persistentState.put("createTime", createTime);
        //persistentState.put("duedate", duedate);
        //persistentState.put("exceptionMessage", exceptionMessage);
        //persistentState.put("jobHandlerType", jobHandlerType);
        //persistentState.put("processDefinitionId", processDefinitionId);
        //persistentState.put("elementId", elementId);
        //persistentState.put("elementName", elementName);
        //
        //if (customValuesByteArrayRef !is null) {
        //    persistentState.put("customValuesByteArrayRef", customValuesByteArrayRef);
        //}
        //
        //if (exceptionByteArrayRef !is null) {
        //    persistentState.put("exceptionByteArrayRef", exceptionByteArrayRef);
        //}
        //
        //return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public Date getCreateTime() {
        return createTime;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public Date getDuedate() {
        return duedate;
    }


    public void setDuedate(Date duedate) {
        this.duedate = duedate;
    }


    public string getExecutionId() {
        return executionId;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public int getRetries() {
        return retries;
    }


    public void setRetries(int retries) {
        this.retries = retries;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public bool isExclusive() {
        return _isExclusive;
    }


    public void setExclusive(bool isExclusive) {
        this._isExclusive = isExclusive;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public string getElementId() {
        return elementId;
    }


    public void setElementId(string elementId) {
        this.elementId = elementId;
    }


    public string getElementName() {
        return elementName;
    }


    public void setElementName(string elementName) {
        this.elementName = elementName;
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


    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }


    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }


    public string getRepeat() {
        return repeat;
    }


    public void setRepeat(string repeat) {
        this.repeat = repeat;
    }


    public Date getEndDate() {
        return endDate;
    }


    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    public int getMaxIterations() {
        return maxIterations;
    }


    public void setMaxIterations(int maxIterations) {
        this.maxIterations = maxIterations;
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


    public JobByteArrayRef getCustomValuesByteArrayRef() {
        return customValuesByteArrayRef;
    }


    public string getCustomValues() {
        return getJobByteArrayRefAsString(customValuesByteArrayRef);
    }


    public void setCustomValues(string customValues) {
        if(customValuesByteArrayRef is null) {
            customValuesByteArrayRef = new JobByteArrayRef();
        }
        customValuesByteArrayRef.setValue("jobCustomValues", customValues);
    }


    public string getJobType() {
        return jobType;
    }


    public void setJobType(string jobType) {
        this.jobType = jobType;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
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
        this.exceptionMessage = exceptionMessage; //StringUtils.abbreviate(exceptionMessage, JobInfo.MAX_EXCEPTION_MESSAGE_LENGTH);
    }


    public JobByteArrayRef getExceptionByteArrayRef() {
        return exceptionByteArrayRef;
    }

    private string getJobByteArrayRefAsString(JobByteArrayRef jobByteArrayRef) {
        if (jobByteArrayRef is null) {
            return null;
        }
        return jobByteArrayRef.asString();
    }

    override
    public string toString() {
        return " [id=" ~ id ~ "]";
    }

}
