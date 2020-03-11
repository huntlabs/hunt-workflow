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
import hunt.collection.HashMap;
import hunt.collection.Map;

import org.apache.commons.lang3.StringUtils;
import org.flowable.job.api.JobInfo;
import org.flowable.job.service.JobServiceConfiguration;

/**
 * Abstract job entity class.
 *
 * @author Tijs Rademakers
 */
abstract class AbstractJobEntityImpl extends AbstractJobServiceEntity implements AbstractRuntimeJobEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected Date createTime;
    protected Date duedate;

    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;

    protected string elementId;
    protected string elementName;

    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;

    protected bool isExclusive = DEFAULT_EXCLUSIVE;

    protected int retries;

    protected int maxIterations;
    protected string repeat;
    protected Date endDate;

    protected string jobHandlerType;
    protected string jobHandlerConfiguration;
    protected JobByteArrayRef customValuesByteArrayRef;

    protected JobByteArrayRef exceptionByteArrayRef;
    protected string exceptionMessage;

    protected string tenantId = JobServiceConfiguration.NO_TENANT_ID;
    protected string jobType;

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("retries", retries);
        persistentState.put("createTime", createTime);
        persistentState.put("duedate", duedate);
        persistentState.put("exceptionMessage", exceptionMessage);
        persistentState.put("jobHandlerType", jobHandlerType);
        persistentState.put("processDefinitionId", processDefinitionId);
        persistentState.put("elementId", elementId);
        persistentState.put("elementName", elementName);

        if (customValuesByteArrayRef !is null) {
            persistentState.put("customValuesByteArrayRef", customValuesByteArrayRef);
        }

        if (exceptionByteArrayRef !is null) {
            persistentState.put("exceptionByteArrayRef", exceptionByteArrayRef);
        }

        return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public Date getCreateTime() {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public Date getDuedate() {
        return duedate;
    }

    @Override
    public void setDuedate(Date duedate) {
        this.duedate = duedate;
    }

    @Override
    public string getExecutionId() {
        return executionId;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public int getRetries() {
        return retries;
    }

    @Override
    public void setRetries(int retries) {
        this.retries = retries;
    }

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public bool isExclusive() {
        return isExclusive;
    }

    @Override
    public void setExclusive(bool isExclusive) {
        this.isExclusive = isExclusive;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string getElementId() {
        return elementId;
    }

    @Override
    public void setElementId(string elementId) {
        this.elementId = elementId;
    }

    @Override
    public string getElementName() {
        return elementName;
    }

    @Override
    public void setElementName(string elementName) {
        this.elementName = elementName;
    }

    @Override
    public string getScopeId() {
        return scopeId;
    }

    @Override
    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }

    @Override
    public string getSubScopeId() {
        return subScopeId;
    }

    @Override
    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }

    @Override
    public string getScopeType() {
        return scopeType;
    }

    @Override
    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    @Override
    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    @Override
    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }

    @Override
    public string getRepeat() {
        return repeat;
    }

    @Override
    public void setRepeat(string repeat) {
        this.repeat = repeat;
    }

    @Override
    public Date getEndDate() {
        return endDate;
    }

    @Override
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Override
    public int getMaxIterations() {
        return maxIterations;
    }

    @Override
    public void setMaxIterations(int maxIterations) {
        this.maxIterations = maxIterations;
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
    public JobByteArrayRef getCustomValuesByteArrayRef() {
        return customValuesByteArrayRef;
    }

    @Override
    public string getCustomValues() {
        return getJobByteArrayRefAsString(customValuesByteArrayRef);
    }

    @Override
    public void setCustomValues(string customValues) {
        if(customValuesByteArrayRef is null) {
            customValuesByteArrayRef = new JobByteArrayRef();
        }
        customValuesByteArrayRef.setValue("jobCustomValues", customValues);
    }

    @Override
    public string getJobType() {
        return jobType;
    }

    @Override
    public void setJobType(string jobType) {
        this.jobType = jobType;
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
    public JobByteArrayRef getExceptionByteArrayRef() {
        return exceptionByteArrayRef;
    }

    private string getJobByteArrayRefAsString(JobByteArrayRef jobByteArrayRef) {
        if (jobByteArrayRef is null) {
            return null;
        }
        return jobByteArrayRef.asString();
    }

    @Override
    public string toString() {
        return getClass().getName() + " [id=" + id + "]";
    }

}
