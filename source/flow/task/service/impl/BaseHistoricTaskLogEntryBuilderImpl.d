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
module flow.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;

import hunt.time.LocalDateTime;

import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import hunt.Exceptions;
/**
 * Base implementation of the {@link HistoricTaskLogEntryBuilder} interface
 *
 * @author martin.grofcik
 */
class BaseHistoricTaskLogEntryBuilderImpl : HistoricTaskLogEntryBuilder {

    protected string _type;
    protected Date _timeStamp;
    protected string _userId;
    protected string _data;
    protected string _processInstanceId;
    protected string _processDefinitionId;
    protected string _executionId;
    protected string _scopeId;
    protected string _scopeDefinitionId;
    protected string _subScopeId;
    protected string _scopeType;
    protected string _tenantId;
    protected string _taskId;

    this(TaskInfo task) {
        this._processInstanceId = task.getProcessInstanceId();
        this._processDefinitionId = task.getProcessDefinitionId();
        this._executionId = task.getExecutionId();
        this._tenantId = task.getTenantId();
        this._scopeId = task.getScopeId();
        this._scopeDefinitionId = task.getScopeDefinitionId();
        this._subScopeId = task.getSubScopeId();
        this._scopeType = task.getScopeType();
        this._taskId = task.getId();
    }

    this() {
    }


    public HistoricTaskLogEntryBuilder taskId(string taskId) {
        this._taskId = taskId;
        return this;
    }


    public HistoricTaskLogEntryBuilder type(string type) {
        this._type = type;
        return this;
    }


    public HistoricTaskLogEntryBuilder timeStamp(Date timeStamp) {
        this._timeStamp = timeStamp;
        return this;
    }


    public HistoricTaskLogEntryBuilder userId(string userId) {
        this._userId = userId;
        return this;
    }


    public HistoricTaskLogEntryBuilder data(string data) {
        this._data = data;
        return this;
    }


    public HistoricTaskLogEntryBuilder processInstanceId(string processInstanceId) {
        this._processInstanceId = processInstanceId;
        return this;
    }


    public HistoricTaskLogEntryBuilder processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder executionId(string executionId) {
        this._executionId = executionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeId(string scopeId) {
        this._scopeId = scopeId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeDefinitionId(string scopeDefinitionId) {
        this._scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder subScopeId(string subScopeId) {
        this._subScopeId = subScopeId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeType(string scopeType) {
        this._scopeType = scopeType;
        return this;
    }


    public HistoricTaskLogEntryBuilder tenantId(string tenantId) {
        this._tenantId = tenantId;
        return this;
    }


    public string getType() {
        return _type;
    }


    public string getTaskId() {
        return _taskId;
    }

    public Date getTimeStamp() {
        return _timeStamp;
    }


    public string getUserId() {
        return _userId;
    }


    public string getData() {
        return _data;
    }


    public string getExecutionId() {
        return _executionId;
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


    public string getTenantId() {
        return _tenantId;
    }


    public void create() {
        // add is not supported by default
        throw new RuntimeException("Operation is not supported");
    }
}
