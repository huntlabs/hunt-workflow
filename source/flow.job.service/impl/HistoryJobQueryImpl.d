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
import java.util.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import org.flowable.job.api.HistoryJob;
import org.flowable.job.api.HistoryJobQuery;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 * @author Tom Baeyens
 * @author Falko Menge
 */
class HistoryJobQueryImpl extends AbstractQuery<HistoryJobQuery, HistoryJob> implements HistoryJobQuery, Serializable {

    private static final long serialVersionUID = 1L;
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

    public HistoryJobQueryImpl() {
    }

    public HistoryJobQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public HistoryJobQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public HistoryJobQuery jobId(string jobId) {
        if (jobId == null) {
            throw new FlowableIllegalArgumentException("Provided job id is null");
        }
        this.id = jobId;
        return this;
    }

    @Override
    public HistoryJobQuery handlerType(string handlerType) {
        if (handlerType == null) {
            throw new FlowableIllegalArgumentException("Provided handlerType is null");
        }
        this.handlerType = handlerType;
        return this;
    }

    @Override
    public HistoryJobQuery withException() {
        this.withException = true;
        return this;
    }

    @Override
    public HistoryJobQuery exceptionMessage(string exceptionMessage) {
        if (exceptionMessage == null) {
            throw new FlowableIllegalArgumentException("Provided exception message is null");
        }
        this.exceptionMessage = exceptionMessage;
        return this;
    }
    
    @Override
    public HistoryJobQuery scopeType(string scopeType) {
        if (scopeType == null) {
            throw new FlowableIllegalArgumentException("Provided scope type is null"); 
        }
        this.scopeType = scopeType;
        return this;
    }

    @Override
    public HistoryJobQuery jobTenantId(string tenantId) {
        if (tenantId == null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public HistoryJobQuery jobTenantIdLike(string tenantIdLike) {
        if (tenantIdLike == null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    @Override
    public HistoryJobQuery jobWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    @Override
    public HistoryJobQuery lockOwner(string lockOwner) {
        this.lockOwner = lockOwner;
        return this;
    }

    @Override
    public HistoryJobQuery locked() {
        this.onlyLocked = true;
        return this;
    }

    @Override
    public HistoryJobQuery unlocked() {
        this.onlyUnlocked = true;
        return this;
    }

    // sorting //////////////////////////////////////////

    @Override
    public HistoryJobQuery orderByJobDuedate() {
        return orderBy(JobQueryProperty.DUEDATE);
    }

    @Override
    public HistoryJobQuery orderByExecutionId() {
        return orderBy(JobQueryProperty.EXECUTION_ID);
    }

    @Override
    public HistoryJobQuery orderByJobId() {
        return orderBy(JobQueryProperty.JOB_ID);
    }

    @Override
    public HistoryJobQuery orderByProcessInstanceId() {
        return orderBy(JobQueryProperty.PROCESS_INSTANCE_ID);
    }

    @Override
    public HistoryJobQuery orderByJobRetries() {
        return orderBy(JobQueryProperty.RETRIES);
    }

    @Override
    public HistoryJobQuery orderByTenantId() {
        return orderBy(JobQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoryJobEntityManager(commandContext).findHistoryJobCountByQueryCriteria(this);
    }

    @Override
    public List<HistoryJob> executeList(CommandContext commandContext) {
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
