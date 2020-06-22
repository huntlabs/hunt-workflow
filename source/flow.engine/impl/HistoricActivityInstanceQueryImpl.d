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

module flow.engine.impl.HistoricActivityInstanceQueryImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.history.HistoricActivityInstanceQuery;
import flow.engine.impl.cmd.DeleteHistoricActivityInstancesCmd;
import flow.engine.impl.context.Context;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.HistoricActivityInstanceQueryProperty;
/**
 * @author Tom Baeyens
 * @author Zheng Ji
 */
class HistoricActivityInstanceQueryImpl : AbstractQuery!(HistoricActivityInstanceQuery, HistoricActivityInstance) , HistoricActivityInstanceQuery {

    protected string _activityInstanceId;
    protected string _processInstanceId;
    protected string _executionId;
    protected string _processDefinitionId;
    protected string _activityId;
    protected string _activityName;
    protected string _activityType;
    protected Set!string _activityTypes;
    protected string assignee;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool _finished;
    protected bool _unfinished;
    protected string _deleteReason;
    protected string _deleteReasonLike;
    protected Date _startedBefore;
    protected Date _startedAfter;
    protected Date _finishedBefore;
    protected Date _finishedAfter;
    protected List!string tenantIds;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findHistoricActivityInstanceCountByQueryCriteria(this);
    }

    override
    public List!HistoricActivityInstance executeList(CommandContext commandContext) {
        return CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findHistoricActivityInstancesByQueryCriteria(this);
    }

    public HistoricActivityInstanceQueryImpl processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl executionId(string executionId) {
        this._executionId = executionId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityId(string activityId) {
        this._activityId = activityId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityName(string activityName) {
        this._activityName = activityName;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityType(string activityType) {
        this._activityType = activityType;
        return this;
    }
    public HistoricActivityInstanceQueryImpl startedAfter(Date date) {
        this._startedAfter = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl startedBefore(Date date) {
        this._startedBefore = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl finishedAfter(Date date) {
        this._finishedAfter = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl finishedBefore(Date date) {
        this._finishedBefore = date;
        return this;
    }

    public HistoricActivityInstanceQuery activityTypes(Set!string activityTypes) {
        this._activityTypes=activityTypes;
        return this;
    }

    public HistoricActivityInstanceQueryImpl taskAssignee(string assignee) {
        this.assignee = assignee;
        return this;
    }

    public HistoricActivityInstanceQueryImpl finished() {
        this._finished = true;
        this._unfinished = false;
        return this;
    }

    public HistoricActivityInstanceQueryImpl unfinished() {
        this._unfinished = true;
        this._finished = false;
        return this;
    }

    public HistoricActivityInstanceQuery deleteReason(string deleteReason) {
        this._deleteReason = deleteReason;
        return this;
    }

    public HistoricActivityInstanceQuery deleteReasonLike(string deleteReasonLike) {
        this._deleteReasonLike = deleteReasonLike;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("activity tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    public string getTenantId() {
        return tenantId;
    }

    public HistoricActivityInstanceQueryImpl activityTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("activity tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    public HistoricActivityInstanceQuery tenantIdIn(List!string tenantIds) {
        this.tenantIds = tenantIds;
        return this;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public HistoricActivityInstanceQueryImpl activityWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    // ordering
    // /////////////////////////////////////////////////////////////////

    public HistoricActivityInstanceQueryImpl orderByHistoricActivityInstanceDuration() {
        orderBy(HistoricActivityInstanceQueryProperty.DURATION);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByHistoricActivityInstanceEndTime() {
        orderBy(HistoricActivityInstanceQueryProperty.END);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByExecutionId() {
        orderBy(HistoricActivityInstanceQueryProperty.EXECUTION_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByHistoricActivityInstanceId() {
        orderBy(HistoricActivityInstanceQueryProperty.HISTORIC_ACTIVITY_INSTANCE_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByProcessDefinitionId() {
        orderBy(HistoricActivityInstanceQueryProperty.PROCESS_DEFINITION_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByProcessInstanceId() {
        orderBy(HistoricActivityInstanceQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByHistoricActivityInstanceStartTime() {
        orderBy(HistoricActivityInstanceQueryProperty.START);
        return this;
    }

    public HistoricActivityInstanceQuery orderByActivityId() {
        orderBy(HistoricActivityInstanceQueryProperty.ACTIVITY_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByActivityName() {
        orderBy(HistoricActivityInstanceQueryProperty.ACTIVITY_NAME);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByActivityType() {
        orderBy(HistoricActivityInstanceQueryProperty.ACTIVITY_TYPE);
        return this;
    }

    public HistoricActivityInstanceQueryImpl orderByTenantId() {
        orderBy(HistoricActivityInstanceQueryProperty.TENANT_ID);
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityInstanceId(string activityInstanceId) {
        this._activityInstanceId = activityInstanceId;
        return this;
    }

    public void dele() {
        if (commandExecutor !is null) {
            commandExecutor.execute(new DeleteHistoricActivityInstancesCmd(this));
        } else {
            new DeleteHistoricActivityInstancesCmd(this).execute(Context.getCommandContext());
        }
    }

    public void deleteWithRelatedData() {
        dele();
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getExecutionId() {
        return _executionId;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getActivityId() {
        return _activityId;
    }

    public string getActivityName() {
        return _activityName;
    }

    public string getActivityType() {
        return _activityType;
    }

    public Set!string getActivityTypes() {
        return _activityTypes;
    }

    public string getAssignee() {
        return assignee;
    }

    public bool isFinished() {
        return _finished;
    }

    public bool isUnfinished() {
        return _unfinished;
    }

    public string getActivityInstanceId() {
        return _activityInstanceId;
    }

    public string getDeleteReason() {
        return _deleteReason;
    }

    public string getDeleteReasonLike() {
        return _deleteReasonLike;
    }

    public Date getStartedAfter() {
        return _startedAfter;
    }

    public Date getStartedBefore() {
        return _startedBefore;
    }

    public Date getFinishedAfter() {
        return _finishedAfter;
    }

    public Date getFinishedBefore() {
        return _finishedBefore;
    }

    public List!string getTenantIds() {
        return tenantIds;
    }
}
