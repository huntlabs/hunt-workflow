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
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import org.flowable.job.api.Job;
import org.flowable.job.api.JobQuery;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 * @author Tom Baeyens
 * @author Falko Menge
 */
class JobQueryImpl extends AbstractQuery<JobQuery, Job> implements JobQuery, Serializable {

    private static final long serialVersionUID = 1L;
    protected string id;
    protected string processInstanceId;
    protected string executionId;
    protected string handlerType;
    protected string processDefinitionId;
    protected string elementId;
    protected string elementName;
    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;
    protected bool onlyTimers;
    protected bool onlyMessages;
    protected Date duedateHigherThan;
    protected Date duedateLowerThan;
    protected Date duedateHigherThanOrEqual;
    protected Date duedateLowerThanOrEqual;
    protected bool withException;
    protected string exceptionMessage;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    protected string lockOwner;
    protected bool onlyLocked;
    protected bool onlyUnlocked;

    public JobQueryImpl() {
    }

    public JobQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public JobQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public JobQuery jobId(string jobId) {
        if (jobId is null) {
            throw new FlowableIllegalArgumentException("Provided job id is null");
        }
        this.id = jobId;
        return this;
    }

    @Override
    public JobQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided process instance id is null");
        }
        this.processInstanceId = processInstanceId;
        return this;
    }

    @Override
    public JobQueryImpl processDefinitionId(string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided process definition id is null");
        }
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public JobQueryImpl elementId(string elementId) {
        if (elementId is null) {
            throw new FlowableIllegalArgumentException("Provided element id is null");
        }
        this.elementId = elementId;
        return this;
    }

    @Override
    public JobQueryImpl elementName(string elementName) {
        if (elementName is null) {
            throw new FlowableIllegalArgumentException("Provided element name is null");
        }
        this.elementName = elementName;
        return this;
    }

    @Override
    public JobQueryImpl scopeId(string scopeId) {
        if (scopeId is null) {
            throw new FlowableIllegalArgumentException("Provided scope id is null");
        }
        this.scopeId = scopeId;
        return this;
    }

    @Override
    public JobQueryImpl subScopeId(string subScopeId) {
        if (subScopeId is null) {
            throw new FlowableIllegalArgumentException("Provided sub scope id is null");
        }
        this.subScopeId = subScopeId;
        return this;
    }

    @Override
    public JobQueryImpl scopeType(string scopeType) {
        if (scopeType is null) {
            throw new FlowableIllegalArgumentException("Provided scope type is null");
        }
        this.scopeType = scopeType;
        return this;
    }

    @Override
    public JobQueryImpl scopeDefinitionId(string scopeDefinitionId) {
        if (scopeDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided scope definitionid is null");
        }
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }

    @Override
    public JobQueryImpl caseInstanceId(string caseInstanceId) {
        if (caseInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided case instance id is null");
        }
        scopeId(caseInstanceId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }

    @Override
    public JobQueryImpl caseDefinitionId(string caseDefinitionId) {
        if (caseDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided case definition id is null");
        }
        scopeDefinitionId(caseDefinitionId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }

    @Override
    public JobQueryImpl planItemInstanceId(string planItemInstanceId) {
        if (planItemInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided plan item instance id is null");
        }
        subScopeId(planItemInstanceId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }

    @Override
    public JobQueryImpl executionId(string executionId) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("Provided execution id is null");
        }
        this.executionId = executionId;
        return this;
    }

    @Override
    public JobQueryImpl handlerType(string handlerType) {
        if (handlerType is null) {
            throw new FlowableIllegalArgumentException("Provided handlerType is null");
        }
        this.handlerType = handlerType;
        return this;
    }

    @Override
    public JobQuery timers() {
        if (onlyMessages) {
            throw new FlowableIllegalArgumentException("Cannot combine onlyTimers() with onlyMessages() in the same query");
        }
        this.onlyTimers = true;
        return this;
    }

    @Override
    public JobQuery messages() {
        if (onlyTimers) {
            throw new FlowableIllegalArgumentException("Cannot combine onlyTimers() with onlyMessages() in the same query");
        }
        this.onlyMessages = true;
        return this;
    }

    @Override
    public JobQuery duedateHigherThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.duedateHigherThan = date;
        return this;
    }

    @Override
    public JobQuery duedateLowerThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.duedateLowerThan = date;
        return this;
    }

    @Override
    public JobQuery withException() {
        this.withException = true;
        return this;
    }

    @Override
    public JobQuery exceptionMessage(string exceptionMessage) {
        if (exceptionMessage is null) {
            throw new FlowableIllegalArgumentException("Provided exception message is null");
        }
        this.exceptionMessage = exceptionMessage;
        return this;
    }

    @Override
    public JobQuery jobTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public JobQuery jobTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public JobQuery jobWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    @Override
    public JobQuery lockOwner(string lockOwner) {
        this.lockOwner = lockOwner;
        return this;
    }

    @Override
    public JobQuery locked() {
        this.onlyLocked = true;
        return this;
    }

    @Override
    public JobQuery unlocked() {
        this.onlyUnlocked = true;
        return this;
    }

    // sorting //////////////////////////////////////////

    @Override
    public JobQuery orderByJobDuedate() {
        return orderBy(JobQueryProperty.DUEDATE);
    }

    @Override
    public JobQuery orderByExecutionId() {
        return orderBy(JobQueryProperty.EXECUTION_ID);
    }

    @Override
    public JobQuery orderByJobId() {
        return orderBy(JobQueryProperty.JOB_ID);
    }

    @Override
    public JobQuery orderByProcessInstanceId() {
        return orderBy(JobQueryProperty.PROCESS_INSTANCE_ID);
    }

    @Override
    public JobQuery orderByJobRetries() {
        return orderBy(JobQueryProperty.RETRIES);
    }

    @Override
    public JobQuery orderByTenantId() {
        return orderBy(JobQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getJobEntityManager(commandContext).findJobCountByQueryCriteria(this);
    }

    @Override
    public List<Job> executeList(CommandContext commandContext) {
        return CommandContextUtil.getJobEntityManager(commandContext).findJobsByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getExecutionId() {
        return executionId;
    }

    public string getHandlerType() {
        return this.handlerType;
    }

    public Date getNow() {
        return CommandContextUtil.getJobServiceConfiguration().getClock().getCurrentTime();
    }

    public bool isWithException() {
        return withException;
    }

    public string getExceptionMessage() {
        return exceptionMessage;
    }

    public string getTenantId() {
        return tenantId;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public string getId() {
        return id;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getScopeId() {
        return scopeId;
    }

    public string getSubScopeId() {
        return subScopeId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    public bool isOnlyTimers() {
        return onlyTimers;
    }

    public bool isOnlyMessages() {
        return onlyMessages;
    }

    public Date getDuedateHigherThan() {
        return duedateHigherThan;
    }

    public Date getDuedateLowerThan() {
        return duedateLowerThan;
    }

    public Date getDuedateHigherThanOrEqual() {
        return duedateHigherThanOrEqual;
    }

    public Date getDuedateLowerThanOrEqual() {
        return duedateLowerThanOrEqual;
    }

    public string getLockOwner() {
        return lockOwner;
    }

    public bool isOnlyLocked() {
        return onlyLocked;
    }

    public bool isOnlyUnlocked() {
        return onlyUnlocked;
    }

}
