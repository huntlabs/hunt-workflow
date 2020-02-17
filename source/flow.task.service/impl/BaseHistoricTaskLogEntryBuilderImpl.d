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

import org.flowable.task.api.TaskInfo;
import org.flowable.task.api.history.HistoricTaskLogEntryBuilder;

/**
 * Base implementation of the {@link HistoricTaskLogEntryBuilder} interface
 *
 * @author martin.grofcik
 */
class BaseHistoricTaskLogEntryBuilderImpl implements HistoricTaskLogEntryBuilder {

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

    public BaseHistoricTaskLogEntryBuilderImpl(TaskInfo task) {
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

    public BaseHistoricTaskLogEntryBuilderImpl() {
    }

    @Override
    public HistoricTaskLogEntryBuilder taskId(string taskId) {
        this.taskId = taskId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder type(string type) {
        this.type = type;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder timeStamp(Date timeStamp) {
        this.timeStamp = timeStamp;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder userId(string userId) {
        this.userId = userId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder data(string data) {
        this.data = data;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder processInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder executionId(string executionId) {
        this.executionId = executionId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder scopeId(string scopeId) {
        this.scopeId = scopeId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder scopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder subScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder scopeType(string scopeType) {
        this.scopeType = scopeType;
        return this;
    }

    @Override
    public HistoricTaskLogEntryBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }

    @Override
    public string getType() {
        return type;
    }

    @Override
    public string getTaskId() {
        return taskId;
    }
    @Override
    public Date getTimeStamp() {
        return timeStamp;
    }

    @Override
    public string getUserId() {
        return userId;
    }

    @Override
    public string getData() {
        return data;
    }

    @Override
    public string getExecutionId() {
        return executionId;
    }

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public string getScopeId() {
        return scopeId;
    }

    @Override
    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    @Override
    public string getSubScopeId() {
        return subScopeId;
    }

    @Override
    public string getScopeType() {
        return scopeType;
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void create() {
        // add is not supported by default
        throw new RuntimeException("Operation is not supported");
    }
}
