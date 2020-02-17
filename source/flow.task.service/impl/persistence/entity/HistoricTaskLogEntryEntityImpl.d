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

import org.flowable.common.engine.impl.persistence.entity.AbstractEntityNoRevision;

/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryEntityImpl extends AbstractEntityNoRevision implements HistoricTaskLogEntryEntity {

    protected long logNumber;
    protected string type;
    protected string taskId;
    protected Date timeStamp;
    protected string userId;
    protected string data;
    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string scopeId;
    protected string scopeDefinitionId;
    protected string subScopeId;
    protected string scopeType;
    protected string tenantId;

    public HistoricTaskLogEntryEntityImpl() {
    }

    @Override
    public Object getPersistentState() {
        return null; // Not updatable
    }

    @Override
    public void setType(string type) {
        this.type = type;
    }

    @Override
    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public void setTimeStamp(Date timeStamp) {
        this.timeStamp = timeStamp;
    }

    @Override
    public void setUserId(string userId) {
        this.userId = userId;
    }

    @Override
    public void setData(string data) {
        this.data = data;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }

    @Override
    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }

    @Override
    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }

    @Override
    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public string getIdPrefix() {
        // id prefix is empty because sequence is used instead of id prefix
        return "";
    }

    @Override
    public void setLogNumber(long logNumber) {
        this.logNumber = logNumber;
    }

    @Override
    public long getLogNumber() {
        return logNumber;
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
    public string toString() {
        return this.getClass().getName() + "(" + logNumber + ", " + getTaskId() + ", " + type +")";
    }
}
