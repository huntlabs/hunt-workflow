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

    protected string _taskId;
    protected string _type;
    protected string _userId;
    protected string _processInstanceId;
    protected string _processDefinitionId;
    protected string _scopeId;
    protected string _scopeDefinitionId;
    protected string _subScopeId;
    protected string _scopeType;
    protected Date fromDate;
    protected Date toDate;
    protected string _tenantId;
    protected long _fromLogNumber = -1;
    protected long _toLogNumber = -1;

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public HistoricTaskLogEntryQuery taskId(string taskId) {
        this._taskId = taskId;
        return this;
    }


    public HistoricTaskLogEntryQuery type(string type) {
        this._type = type;
        return this;
    }


    public HistoricTaskLogEntryQuery userId(string userId) {
        this._userId = userId;
        return this;
    }


    public HistoricTaskLogEntryQuery processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }


    public HistoricTaskLogEntryQuery processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeId(string scopeId) {
        this._scopeId = scopeId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeDefinitionId(string scopeDefinitionId) {
        this._scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryQuery caseInstanceId(string caseInstanceId) {
        this._scopeId = caseInstanceId;
        this._scopeType = ScopeTypes.CMMN;
        return this;
    }


    public HistoricTaskLogEntryQuery caseDefinitionId(string caseDefinitionId) {
        this._scopeDefinitionId = caseDefinitionId;
        this._scopeType = ScopeTypes.CMMN;
        return this;
    }


    public HistoricTaskLogEntryQuery subScopeId(string subScopeId) {
        this._subScopeId = subScopeId;
        return this;
    }


    public HistoricTaskLogEntryQuery scopeType(string scopeType) {
        this._scopeType = scopeType;
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
        this._tenantId = tenantId;
        return this;
    }


    public HistoricTaskLogEntryQuery fromLogNumber(long fromLogNumber) {
        this._fromLogNumber = fromLogNumber;
        return this;
    }


    public HistoricTaskLogEntryQuery toLogNumber(long toLogNumber) {
        this._toLogNumber = toLogNumber;
        return this;
    }

    public string getTaskId() {
        return _taskId;
    }

    public string getType() {
        return _type;
    }

    public string getUserId() {
        return _userId;
    }

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getScopeId() {
        return _scopeId;
    }

    public string getScopeDefinitionId() {
        return _scopeDefinitionId;
    }

    public string getSubScopeId() {
        return _subScopeId;
    }

    public string getScopeType() {
        return _scopeType;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public string getTenantId() {
        return _tenantId;
    }

    public long getFromLogNumber() {
        return _fromLogNumber;
    }

    public long getToLogNumber() {
        return _toLogNumber;
    }

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getHistoricTaskLogEntryEntityManager(commandContext).findHistoricTaskLogEntriesCountByQueryCriteria(this);
    }

    override
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
