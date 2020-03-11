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



import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.ActivityInstance;
import flow.engine.runtime.ActivityInstanceQuery;

/**
 * @author martin.grofcik
 */
class ActivityInstanceQueryImpl extends AbstractQuery<ActivityInstanceQuery, ActivityInstance> implements ActivityInstanceQuery {

    private static final long serialVersionUID = 1L;
    protected string activityInstanceId;
    protected string processInstanceId;
    protected string executionId;
    protected string processDefinitionId;
    protected string activityId;
    protected string activityName;
    protected string activityType;
    protected string assignee;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool finished;
    protected bool unfinished;
    protected string deleteReason;
    protected string deleteReasonLike;

    public ActivityInstanceQueryImpl() {
    }

    public ActivityInstanceQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public ActivityInstanceQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstanceCountByQueryCriteria(this);
    }

    @Override
    public List<ActivityInstance> executeList(CommandContext commandContext) {
        return CommandContextUtil.getActivityInstanceEntityManager(commandContext).findActivityInstancesByQueryCriteria(this);
    }

    @Override
    public ActivityInstanceQueryImpl processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl activityId(string activityId) {
        this.activityId = activityId;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl activityName(string activityName) {
        this.activityName = activityName;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl activityType(string activityType) {
        this.activityType = activityType;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl taskAssignee(string assignee) {
        this.assignee = assignee;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl finished() {
        this.finished = true;
        this.unfinished = false;
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl unfinished() {
        this.unfinished = true;
        this.finished = false;
        return this;
    }

    @Override
    public ActivityInstanceQuery deleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
        return this;
    }

    @Override
    public ActivityInstanceQuery deleteReasonLike(string deleteReasonLike) {
        this.deleteReasonLike = deleteReasonLike;
        return this;
    }

    @Override
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

    @Override
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

    @Override
    public ActivityInstanceQueryImpl activityWithoutTenantId() {
        this.withoutTenantId = true;
        return this;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    // ordering
    // /////////////////////////////////////////////////////////////////

    @Override
    public ActivityInstanceQueryImpl orderByActivityInstanceDuration() {
        orderBy(ActivityInstanceQueryProperty.DURATION);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByActivityInstanceEndTime() {
        orderBy(ActivityInstanceQueryProperty.END);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByExecutionId() {
        orderBy(ActivityInstanceQueryProperty.EXECUTION_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByActivityInstanceId() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_INSTANCE_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByProcessDefinitionId() {
        orderBy(ActivityInstanceQueryProperty.PROCESS_DEFINITION_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByProcessInstanceId() {
        orderBy(ActivityInstanceQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByActivityInstanceStartTime() {
        orderBy(ActivityInstanceQueryProperty.START);
        return this;
    }

    @Override
    public ActivityInstanceQuery orderByActivityId() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByActivityName() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_NAME);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByActivityType() {
        orderBy(ActivityInstanceQueryProperty.ACTIVITY_TYPE);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl orderByTenantId() {
        orderBy(ActivityInstanceQueryProperty.TENANT_ID);
        return this;
    }

    @Override
    public ActivityInstanceQueryImpl activityInstanceId(string activityInstanceId) {
        this.activityInstanceId = activityInstanceId;
        return this;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getExecutionId() {
        return executionId;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getActivityId() {
        return activityId;
    }

    public string getActivityName() {
        return activityName;
    }

    public string getActivityType() {
        return activityType;
    }

    public string getAssignee() {
        return assignee;
    }

    public bool isFinished() {
        return finished;
    }

    public bool isUnfinished() {
        return unfinished;
    }

    public string getActivityInstanceId() {
        return activityInstanceId;
    }

    public string getDeleteReason() {
        return deleteReason;
    }

    public string getDeleteReasonLike() {
        return deleteReasonLike;
    }
}
