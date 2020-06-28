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

module flow.engine.impl.ActivityInstanceQueryImpl;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.ActivityInstance;
import flow.engine.runtime.ActivityInstanceQuery;
import flow.engine.impl.ActivityInstanceQueryProperty;
/**
 * @author martin.grofcik
 */
class ActivityInstanceQueryImpl : AbstractQuery!(ActivityInstanceQuery, ActivityInstance) , ActivityInstanceQuery {

    protected string _activityInstanceId;
    protected string _processInstanceId;
    protected string _executionId;
    protected string _processDefinitionId;
    protected string _activityId;
    protected string _activityName;
    protected string _activityType;
    protected string assignee;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool _finished;
    protected bool _unfinished;
    protected string _deleteReason;
    protected string _deleteReasonLike;

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
        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstanceCountByQueryCriteria(this);
    }

    override
    public List!ActivityInstance executeList(CommandContext commandContext) {
        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstancesByQueryCriteria(this);
    }

    public ActivityInstanceQueryImpl processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }

    public ActivityInstanceQueryImpl executionId(string executionId) {
        this._executionId = executionId;
        return this;
    }

    public ActivityInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }

    public ActivityInstanceQueryImpl activityId(string activityId) {
        this._activityId = activityId;
        return this;
    }

    public ActivityInstanceQueryImpl activityName(string activityName) {
        this._activityName = activityName;
        return this;
    }

    public ActivityInstanceQueryImpl activityType(string activityType) {
        this._activityType = activityType;
        return this;
    }

    public ActivityInstanceQueryImpl taskAssignee(string assignee) {
        this.assignee = assignee;
        return this;
    }

    public ActivityInstanceQueryImpl finished() {
        this._finished = true;
        this._unfinished = false;
        return this;
    }

    public ActivityInstanceQueryImpl unfinished() {
        this._unfinished = true;
        this._finished = false;
        return this;
    }

    public ActivityInstanceQuery deleteReason(string deleteReason) {
        this._deleteReason = deleteReason;
        return this;
    }

    public ActivityInstanceQuery deleteReasonLike(string deleteReasonLike) {
        this._deleteReasonLike = deleteReasonLike;
        return this;
    }

    public ActivityInstanceQueryImpl activityTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("activity tenant id is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    public string getTenantId() {
        return tenantId;
    }

    public ActivityInstanceQueryImpl activityTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("activity tenant id is null");
        }
        this.tenantIdLike = tenantIdLike;
        return this;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public ActivityInstanceQueryImpl activityWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    // ordering
    // /////////////////////////////////////////////////////////////////

    public ActivityInstanceQueryImpl orderByActivityInstanceDuration() {
        orderBy(ActivityInstanceQueryProperty.DURATION);
        return this;
    }

    public ActivityInstanceQueryImpl orderByActivityInstanceEndTime() {
        orderBy(ActivityInstanceQueryProperty.END);
        return this;
    }

    public ActivityInstanceQueryImpl orderByExecutionId() {
        orderBy(ActivityInstanceQueryProperty.EXECUTION_ID);
        return this;
    }

    public ActivityInstanceQueryImpl orderByActivityInstanceId() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_INSTANCE_ID);
        return this;
    }

    public ActivityInstanceQueryImpl orderByProcessDefinitionId() {
        orderBy(ActivityInstanceQueryProperty.PROCESS_DEFINITION_ID);
        return this;
    }

    public ActivityInstanceQueryImpl orderByProcessInstanceId() {
        orderBy(ActivityInstanceQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }

    public ActivityInstanceQueryImpl orderByActivityInstanceStartTime() {
        orderBy(ActivityInstanceQueryProperty.START);
        return this;
    }

    public ActivityInstanceQuery orderByActivityId() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_ID);
        return this;
    }

    public ActivityInstanceQueryImpl orderByActivityName() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_NAME);
        return this;
    }

    public ActivityInstanceQueryImpl orderByActivityType() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_TYPE);
        return this;
    }

    public ActivityInstanceQueryImpl orderByTenantId() {
        orderBy(ActivityInstanceQueryProperty.TENANT_ID);
        return this;
    }

    public ActivityInstanceQueryImpl activityInstanceId(string activityInstanceId) {
        this._activityInstanceId = activityInstanceId;
        return this;
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
}
