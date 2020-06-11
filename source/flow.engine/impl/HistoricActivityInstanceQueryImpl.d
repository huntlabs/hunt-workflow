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

    protected string activityInstanceId;
    protected string processInstanceId;
    protected string executionId;
    protected string processDefinitionId;
    protected string activityId;
    protected string activityName;
    protected string activityType;
    protected Set!string activityTypes;
    protected string assignee;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool finished;
    protected bool unfinished;
    protected string deleteReason;
    protected string deleteReasonLike;
    protected Date startedBefore;
    protected Date startedAfter;
    protected Date finishedBefore;
    protected Date finishedAfter;
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
        this.processInstanceId = processInstanceId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityId(string activityId) {
        this.activityId = activityId;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityName(string activityName) {
        this.activityName = activityName;
        return this;
    }

    public HistoricActivityInstanceQueryImpl activityType(string activityType) {
        this.activityType = activityType;
        return this;
    }
    public HistoricActivityInstanceQueryImpl startedAfter(Date date) {
        this.startedAfter = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl startedBefore(Date date) {
        this.startedBefore = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl finishedAfter(Date date) {
        this.finishedAfter = date;
        return this;
    }
    public HistoricActivityInstanceQueryImpl finishedBefore(Date date) {
        this.finishedBefore = date;
        return this;
    }

    public HistoricActivityInstanceQuery activityTypes(Set!string activityTypes) {
        this.activityTypes=activityTypes;
        return this;
    }

    public HistoricActivityInstanceQueryImpl taskAssignee(string assignee) {
        this.assignee = assignee;
        return this;
    }

    public HistoricActivityInstanceQueryImpl finished() {
        this.finished = true;
        this.unfinished = false;
        return this;
    }

    public HistoricActivityInstanceQueryImpl unfinished() {
        this.unfinished = true;
        this.finished = false;
        return this;
    }

    public HistoricActivityInstanceQuery deleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
        return this;
    }

    public HistoricActivityInstanceQuery deleteReasonLike(string deleteReasonLike) {
        this.deleteReasonLike = deleteReasonLike;
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
        this.activityInstanceId = activityInstanceId;
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

    public Set!string getActivityTypes() {
        return activityTypes;
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

    public Date getStartedAfter() {
        return startedAfter;
    }

    public Date getStartedBefore() {
        return startedBefore;
    }

    public Date getFinishedAfter() {
        return finishedAfter;
    }

    public Date getFinishedBefore() {
        return finishedBefore;
    }

    public List!string getTenantIds() {
        return tenantIds;
    }
}
