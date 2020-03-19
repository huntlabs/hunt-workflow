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
module flow.task.service.impl.HistoricTaskLogEntryQueryImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.scop.ScopeTypes;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.service.impl.util.CommandContextUtil;
import flow.task.service.impl.HistoricTaskLogEntryQueryProperty;

/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryQueryImpl : AbstractQuery!(HistoricTaskLogEntryQuery, HistoricTaskLogEntry) , HistoricTaskLogEntryQuery {

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

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public HistoricTaskLogEntryQuery taskId(string taskId) {
        this.taskId = taskId;
        return this;
    }


    public HistoricTaskLogEntryQuery type(string type) {
        this.type = type;
        return this;
    }


    public HistoricTaskLogEntryQuery userId(string userId) {
        this.userId = userId;
        return this;
    }


    public HistoricTaskLogEntryQuery processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }


    public HistoricTaskLogEntryQuery processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryQuery caseInstanceId(string caseInstanceId) {
        this.scopeId = caseInstanceId;
        this.scopeType = ScopeTypes.CMMN;
        return this;
    }


    public HistoricTaskLogEntryQuery caseDefinitionId(string caseDefinitionId) {
        this.scopeDefinitionId = caseDefinitionId;
        this.scopeType = ScopeTypes.CMMN;
        return this;
    }


    public HistoricTaskLogEntryQuery subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }


    public HistoricTaskLogEntryQuery from(Date fromDate) {
        this.fromDate = fromDate;
        return this;
    }


    public HistoricTaskLogEntryQuery to(Date toDate) {
        this.toDate = toDate;
        return this;
    }


    public HistoricTaskLogEntryQuery tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }


    public HistoricTaskLogEntryQuery fromLogNumber(long fromLogNumber) {
        this.fromLogNumber = fromLogNumber;
        return this;
    }


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


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoricTaskLogEntryEntityManager(commandContext).findHistoricTaskLogEntriesCountByQueryCriteria(this);
    }


    public List!HistoricTaskLogEntry executeList(CommandContext commandContext) {
        return CommandContextUtil.getHistoricTaskLogEntryEntityManager(commandContext).findHistoricTaskLogEntriesByQueryCriteria(this);
    }


    public HistoricTaskLogEntryQuery orderByLogNumber() {
        orderBy(HistoricTaskLogEntryQueryProperty.LOG_NUMBER);
        return this;
    }

    public HistoricTaskLogEntryQuery orderByTimeStamp() {
        orderBy(HistoricTaskLogEntryQueryProperty.TIME_STAMP);
        return this;
    }
}
