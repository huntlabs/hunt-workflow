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


import java.util.Date;
import hunt.collection.List;

import flow.common.api.scope.ScopeTypes;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import org.flowable.task.service.impl.util.CommandContextUtil;

/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryQueryImpl extends AbstractQuery<HistoricTaskLogEntryQuery, HistoricTaskLogEntry> implements HistoricTaskLogEntryQuery {

    protected string taskId;
    protected string type;
    protected string userId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string scopeId;
    protected string scopeDefinitionId;
    protected string subScopeId;
    protected string scopeType;
    protected Date fromDate;
    protected Date toDate;
    protected string tenantId;
    protected long fromLogNumber = -1;
    protected long toLogNumber = -1;

    public HistoricTaskLogEntryQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public HistoricTaskLogEntryQuery taskId(string taskId) {
        this.taskId = taskId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery type(string type) {
        this.type = type;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery userId(string userId) {
        this.userId = userId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery scopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery caseInstanceId(string caseInstanceId) {
        this.scopeId = caseInstanceId;
        this.scopeType = ScopeTypes.CMMN;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery caseDefinitionId(string caseDefinitionId) {
        this.scopeDefinitionId = caseDefinitionId;
        this.scopeType = ScopeTypes.CMMN;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery from(Date fromDate) {
        this.fromDate = fromDate;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery to(Date toDate) {
        this.toDate = toDate;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery fromLogNumber(long fromLogNumber) {
        this.fromLogNumber = fromLogNumber;
        return this;
    }

    @Override
    public HistoricTaskLogEntryQuery toLogNumber(long toLogNumber) {
        this.toLogNumber = toLogNumber;
        return this;
    }

    public string getTaskId() {
        return taskId;
    }

    public string getType() {
        return type;
    }

    public string getUserId() {
        return userId;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getScopeId() {
        return scopeId;
    }

    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    public string getSubScopeId() {
        return subScopeId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public string getTenantId() {
        return tenantId;
    }

    public long getFromLogNumber() {
        return fromLogNumber;
    }

    public long getToLogNumber() {
        return toLogNumber;
    }

    @Override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoricTaskLogEntryEntityManager(commandContext).findHistoricTaskLogEntriesCountByQueryCriteria(this);
    }

    @Override
    public List<HistoricTaskLogEntry> executeList(CommandContext commandContext) {
        return CommandContextUtil.getHistoricTaskLogEntryEntityManager(commandContext).findHistoricTaskLogEntriesByQueryCriteria(this);
    }

    @Override
    public HistoricTaskLogEntryQuery orderByLogNumber() {
        orderBy(HistoricTaskLogEntryQueryProperty.LOG_NUMBER);
        return this;
    }
    @Override
    public HistoricTaskLogEntryQuery orderByTimeStamp() {
        orderBy(HistoricTaskLogEntryQueryProperty.TIME_STAMP);
        return this;
    }
}
