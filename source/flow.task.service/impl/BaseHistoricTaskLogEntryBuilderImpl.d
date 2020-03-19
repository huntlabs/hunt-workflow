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

    protected string type;
    protected Date timeStamp;
    protected string userId;
    protected string data;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string executionId;
    protected string scopeId;
    protected string scopeDefinitionId;
    protected string subScopeId;
    protected string scopeType;
    protected string tenantId;
    protected string taskId;

    this(TaskInfo task) {
        this.processInstanceId = task.getProcessInstanceId();
        this.processDefinitionId = task.getProcessDefinitionId();
        this.executionId = task.getExecutionId();
        this.tenantId = task.getTenantId();
        this.scopeId = task.getScopeId();
        this.scopeDefinitionId = task.getScopeDefinitionId();
        this.subScopeId = task.getSubScopeId();
        this.scopeType = task.getScopeType();
        this.taskId = task.getId();
    }

    this() {
    }


    public HistoricTaskLogEntryBuilder taskId(string taskId) {
        this.taskId = taskId;
        return this;
    }


    public HistoricTaskLogEntryBuilder type(string type) {
        this.type = type;
        return this;
    }


    public HistoricTaskLogEntryBuilder timeStamp(Date timeStamp) {
        this.timeStamp = timeStamp;
        return this;
    }


    public HistoricTaskLogEntryBuilder userId(string userId) {
        this.userId = userId;
        return this;
    }


    public HistoricTaskLogEntryBuilder data(string data) {
        this.data = data;
        return this;
    }


    public HistoricTaskLogEntryBuilder processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }


    public HistoricTaskLogEntryBuilder processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }


    public HistoricTaskLogEntryBuilder subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }


    public HistoricTaskLogEntryBuilder scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }


    public HistoricTaskLogEntryBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }


    public string getType() {
        return type;
    }


    public string getTaskId() {
        return taskId;
    }

    public Date getTimeStamp() {
        return timeStamp;
    }


    public string getUserId() {
        return userId;
    }


    public string getData() {
        return data;
    }


    public string getExecutionId() {
        return executionId;
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


    public string getTenantId() {
        return tenantId;
    }


    public void create() {
        // add is not supported by default
        throw new RuntimeException("Operation is not supported");
    }
}
