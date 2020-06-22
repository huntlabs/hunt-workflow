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

module flow.job.service.impl.SuspendedJobQueryImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.job.service.api.Job;
import flow.job.service.api.SuspendedJobQuery;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.JobQueryProperty;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class SuspendedJobQueryImpl : AbstractQuery!(SuspendedJobQuery, Job) , SuspendedJobQuery {

    protected string id;
    protected string _processInstanceId;
    protected string _executionId;
    protected string _handlerType;
    protected string _processDefinitionId;
    protected string _elementId;
    protected string _elementName;
    protected string _scopeId;
    protected string _subScopeId;
    protected string _scopeType;
    protected string _scopeDefinitionId;
    protected bool _executable;
    protected bool onlyTimers;
    protected bool onlyMessages;
    protected Date _duedateHigherThan;
    protected Date _duedateLowerThan;
    protected Date duedateHigherThanOrEqual;
    protected Date duedateLowerThanOrEqual;
    protected bool _withException;
    protected string _exceptionMessage;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    protected bool retriesLeft;
    protected bool _noRetriesLeft;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public SuspendedJobQueryImpl jobId(string jobId) {
        if (jobId is null) {
            throw new FlowableIllegalArgumentException("Provided job id is null");
        }
        this.id = jobId;
        return this;
    }


    public SuspendedJobQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided process instance id is null");
        }
        this._processInstanceId = processInstanceId;
        return this;
    }


    public SuspendedJobQueryImpl processDefinitionId(string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided process definition id is null");
        }
        this._processDefinitionId = processDefinitionId;
        return this;
    }


    public SuspendedJobQueryImpl elementId(string elementId) {
        if (elementId is null) {
            throw new FlowableIllegalArgumentException("Provided element id is null");
        }
        this._elementId = elementId;
        return this;
    }


    public SuspendedJobQueryImpl elementName(string elementName) {
        if (elementName is null) {
            throw new FlowableIllegalArgumentException("Provided element name is null");
        }
        this._elementName = elementName;
        return this;
    }


    public SuspendedJobQueryImpl scopeId(string scopeId) {
        if (scopeId is null) {
            throw new FlowableIllegalArgumentException("Provided scope id is null");
        }
        this._scopeId = scopeId;
        return this;
    }


    public SuspendedJobQueryImpl subScopeId(string subScopeId) {
        if (scopeId is null) {
            throw new FlowableIllegalArgumentException("Provided sub scope id is null");
        }
        this._subScopeId = subScopeId;
        return this;
    }


    public SuspendedJobQueryImpl scopeType(string scopeType) {
        if (scopeType is null) {
            throw new FlowableIllegalArgumentException("Provided scope type is null");
        }
        this._scopeType = scopeType;
        return this;
    }


    public SuspendedJobQueryImpl scopeDefinitionId(string scopeDefinitionId) {
        if (scopeDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided scope definitionid is null");
        }
        this._scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public SuspendedJobQueryImpl caseInstanceId(string caseInstanceId) {
        if (caseInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided case instance id is null");
        }
        scopeId(caseInstanceId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }


    public SuspendedJobQueryImpl caseDefinitionId(string caseDefinitionId) {
        if (caseDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Provided case definition id is null");
        }
        scopeDefinitionId(caseDefinitionId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }


    public SuspendedJobQueryImpl planItemInstanceId(string planItemInstanceId) {
        if (planItemInstanceId is null) {
            throw new FlowableIllegalArgumentException("Provided plan item instance id is null");
        }
        subScopeId(planItemInstanceId);
        scopeType(ScopeTypes.CMMN);
        return this;
    }


    public SuspendedJobQueryImpl executionId(string executionId) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("Provided execution id is null");
        }
        this._executionId = executionId;
        return this;
    }


    public SuspendedJobQueryImpl handlerType(string handlerType) {
        if (handlerType is null) {
            throw new FlowableIllegalArgumentException("Provided handlerType is null");
        }
        this._handlerType = handlerType;
        return this;
    }


    public SuspendedJobQueryImpl withRetriesLeft() {
        retriesLeft = true;
        return this;
    }


    public SuspendedJobQueryImpl executable() {
        _executable = true;
        return this;
    }


    public SuspendedJobQueryImpl timers() {
        if (onlyMessages) {
            throw new FlowableIllegalArgumentException("Cannot combine onlyTimers() with onlyMessages() in the same query");
        }
        this.onlyTimers = true;
        return this;
    }


    public SuspendedJobQueryImpl messages() {
        if (onlyTimers) {
            throw new FlowableIllegalArgumentException("Cannot combine onlyTimers() with onlyMessages() in the same query");
        }
        this.onlyMessages = true;
        return this;
    }


    public SuspendedJobQueryImpl duedateHigherThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this._duedateHigherThan = date;
        return this;
    }


    public SuspendedJobQueryImpl duedateLowerThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this._duedateLowerThan = date;
        return this;
    }

    public SuspendedJobQueryImpl duedateHigherThen(Date date) {
        return duedateHigherThan(date);
    }

    public SuspendedJobQueryImpl duedateHigherThenOrEquals(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.duedateHigherThanOrEqual = date;
        return this;
    }

    public SuspendedJobQueryImpl duedateLowerThen(Date date) {
        return duedateLowerThan(date);
    }

    public SuspendedJobQueryImpl duedateLowerThenOrEquals(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.duedateLowerThanOrEqual = date;
        return this;
    }


    public SuspendedJobQueryImpl noRetriesLeft() {
        _noRetriesLeft = true;
        return this;
    }


    public SuspendedJobQueryImpl withException() {
        this._withException = true;
        return this;
    }


    public SuspendedJobQueryImpl exceptionMessage(string exceptionMessage) {
        if (exceptionMessage is null) {
            throw new FlowableIllegalArgumentException("Provided exception message is null");
        }
        this._exceptionMessage = exceptionMessage;
        return this;
    }


    public SuspendedJobQueryImpl jobTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public SuspendedJobQueryImpl jobTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public SuspendedJobQueryImpl jobWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    // sorting //////////////////////////////////////////


    public SuspendedJobQuery orderByJobDuedate() {
        return orderBy(JobQueryProperty.DUEDATE);
    }


    public SuspendedJobQuery orderByExecutionId() {
        return orderBy(JobQueryProperty.EXECUTION_ID);
    }


    public SuspendedJobQuery orderByJobId() {
        return orderBy(JobQueryProperty.JOB_ID);
    }


    public SuspendedJobQuery orderByProcessInstanceId() {
        return orderBy(JobQueryProperty.PROCESS_INSTANCE_ID);
    }


    public SuspendedJobQuery orderByJobRetries() {
        return orderBy(JobQueryProperty.RETRIES);
    }


    public SuspendedJobQuery orderByTenantId() {
        return orderBy(JobQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getSuspendedJobEntityManager(commandContext).findJobCountByQueryCriteria(this);
    }

    override
    public List!Job executeList(CommandContext commandContext) {
        return CommandContextUtil.getSuspendedJobEntityManager(commandContext).findJobsByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getExecutionId() {
        return _executionId;
    }

    public string getHandlerType() {
        return _handlerType;
    }

    public bool getRetriesLeft() {
        return retriesLeft;
    }

    public bool getExecutable() {
        return _executable;
    }

    public Date getNow() {
        return CommandContextUtil.getJobServiceConfiguration().getClock().getCurrentTime();
    }

    public bool isWithException() {
        return _withException;
    }

    public string getExceptionMessage() {
        return _exceptionMessage;
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
        return _processDefinitionId;
    }

    public string getScopeId() {
        return _scopeId;
    }

    public string getSubScopeId() {
        return _subScopeId;
    }

    public string getScopeType() {
        return _scopeType;
    }

    public string getScopeDefinitionId() {
        return _scopeDefinitionId;
    }

    public bool isOnlyTimers() {
        return onlyTimers;
    }

    public bool isOnlyMessages() {
        return onlyMessages;
    }

    public Date getDuedateHigherThan() {
        return _duedateHigherThan;
    }

    public Date getDuedateLowerThan() {
        return _duedateLowerThan;
    }

    public Date getDuedateHigherThanOrEqual() {
        return duedateHigherThanOrEqual;
    }

    public Date getDuedateLowerThanOrEqual() {
        return duedateLowerThanOrEqual;
    }

    public bool isNoRetriesLeft() {
        return _noRetriesLeft;
    }

}
