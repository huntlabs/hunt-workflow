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

module flow.job.service.impl.HistoryJobQueryImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.job.service.api.HistoryJob;
import flow.job.service.api.HistoryJobQuery;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.JobQueryProperty;
/**
 * @author Joram Barrez
 * @author Tom Baeyens
 * @author Falko Menge
 */
class HistoryJobQueryImpl : AbstractQuery!(HistoryJobQuery, HistoryJob) , HistoryJobQuery {

    protected string id;
    protected string handlerType;
    protected bool withException;
    protected string exceptionMessage;
    protected string scopeType;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string lockOwner;
    protected bool onlyLocked;
    protected bool onlyUnlocked;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public HistoryJobQuery jobId(string jobId) {
        if (jobId is null) {
            throw new FlowableIllegalArgumentException("Provided job id is null");
        }
        this.id = jobId;
        return this;
    }


    public HistoryJobQuery handlerType(string handlerType) {
        if (handlerType is null) {
            throw new FlowableIllegalArgumentException("Provided handlerType is null");
        }
        this.handlerType = handlerType;
        return this;
    }


    public HistoryJobQuery withException() {
        this.withException = true;
        return this;
    }


    public HistoryJobQuery exceptionMessage(string exceptionMessage) {
        if (exceptionMessage is null) {
            throw new FlowableIllegalArgumentException("Provided exception message is null");
        }
        this.exceptionMessage = exceptionMessage;
        return this;
    }


    public HistoryJobQuery scopeType(string scopeType) {
        if (scopeType is null) {
            throw new FlowableIllegalArgumentException("Provided scope type is null");
        }
        this.scopeType = scopeType;
        return this;
    }


    public HistoryJobQuery jobTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public HistoryJobQuery jobTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public HistoryJobQuery jobWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }


    public HistoryJobQuery lockOwner(string lockOwner) {
        this.lockOwner = lockOwner;
        return this;
    }


    public HistoryJobQuery locked() {
        this.onlyLocked = true;
        return this;
    }


    public HistoryJobQuery unlocked() {
        this.onlyUnlocked = true;
        return this;
    }

    // sorting //////////////////////////////////////////


    public HistoryJobQuery orderByJobDuedate() {
        return orderBy(JobQueryProperty.DUEDATE);
    }


    public HistoryJobQuery orderByExecutionId() {
        return orderBy(JobQueryProperty.EXECUTION_ID);
    }


    public HistoryJobQuery orderByJobId() {
        return orderBy(JobQueryProperty.JOB_ID);
    }


    public HistoryJobQuery orderByProcessInstanceId() {
        return orderBy(JobQueryProperty.PROCESS_INSTANCE_ID);
    }


    public HistoryJobQuery orderByJobRetries() {
        return orderBy(JobQueryProperty.RETRIES);
    }


    public HistoryJobQuery orderByTenantId() {
        return orderBy(JobQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoryJobEntityManager(commandContext).findHistoryJobCountByQueryCriteria(this);
    }


    public List!HistoryJob executeList(CommandContext commandContext) {
        return CommandContextUtil.getHistoryJobEntityManager(commandContext).findHistoryJobsByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////

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

    public string getScopeType() {
        return scopeType;
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
