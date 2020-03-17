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
module flow.batch.service.impl.BatchQueryImpl;


import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchQuery;
import flow.batch.service.impl.util.CommandContextUtil;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.batch.service.impl.BatchQueryProperty;

class BatchQueryImpl : AbstractQuery!(BatchQuery, Batch) , BatchQuery, QueryCacheValues {

    protected string id;
    protected string batchType;
    protected string searchKey;
    protected string searchKey2;
    protected Date createTimeHigherThan;
    protected Date createTimeLowerThan;
    protected Date completeTimeHigherThan;
    protected Date completeTimeLowerThan;
    protected string status;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public BatchQuery batchId(string batchId) {
        if (batchId is null) {
            throw new FlowableIllegalArgumentException("Provided batch id is null");
        }
        this.id = batchId;
        return this;
    }


    public BatchQuery batchType(string batchType) {
        if (batchType is null) {
            throw new FlowableIllegalArgumentException("Provided batch type is null");
        }
        this.batchType = batchType;
        return this;
    }


    public BatchQuery searchKey(string searchKey) {
        if (searchKey is null) {
            throw new FlowableIllegalArgumentException("Provided search key is null");
        }
        this.searchKey = searchKey;
        return this;
    }


    public BatchQuery searchKey2(string searchKey) {
        if (searchKey is null) {
            throw new FlowableIllegalArgumentException("Provided search key is null");
        }
        this.searchKey2 = searchKey;
        return this;
    }


    public BatchQuery createTimeHigherThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.createTimeHigherThan = date;
        return this;
    }


    public BatchQuery createTimeLowerThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.createTimeLowerThan = date;
        return this;
    }


    public BatchQuery completeTimeHigherThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.completeTimeHigherThan = date;
        return this;
    }


    public BatchQuery completeTimeLowerThan(Date date) {
        if (date is null) {
            throw new FlowableIllegalArgumentException("Provided date is null");
        }
        this.completeTimeLowerThan = date;
        return this;
    }


    public BatchQuery status(string status) {
        if (status is null) {
            throw new FlowableIllegalArgumentException("Provided status is null");
        }
        this.status = status;
        return this;
    }


    public BatchQuery tenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }


    public BatchQuery tenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("Provided tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }


    public BatchQuery withoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    // sorting //////////////////////////////////////////


    public BatchQuery orderByBatchCreateTime() {
        return orderBy(BatchQueryProperty.CREATETIME);
    }


    public BatchQuery orderByBatchId() {
        return orderBy(BatchQueryProperty.BATCH_ID);
    }


    public BatchQuery orderByBatchTenantId() {
        return orderBy(BatchQueryProperty.TENANT_ID);
    }

    // results //////////////////////////////////////////


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getBatchEntityManager(commandContext).findBatchCountByQueryCriteria(this);
    }


    public List!Batch executeList(CommandContext commandContext) {
        return CommandContextUtil.getBatchEntityManager(commandContext).findBatchesByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////


    public string getId() {
        return id;
    }

    public string getBatchType() {
        return batchType;
    }

    public string getSearchKey() {
        return searchKey;
    }

    public string getSearchKey2() {
        return searchKey2;
    }

    public Date getCreateTimeHigherThan() {
        return createTimeHigherThan;
    }

    public Date getCreateTimeLowerThan() {
        return createTimeLowerThan;
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

}
