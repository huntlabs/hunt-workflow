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

/**
 * An event log entry can only be inserted (and maybe deleted).
 * 
 * @author Joram Barrez
 */
class EventLogEntryEntityImpl extends AbstractBpmnEngineNoRevisionEntity implements EventLogEntryEntity {

    protected long logNumber; // cant use id here, it would clash with entity
    protected string type;
    protected string processDefinitionId;
    protected string processInstanceId;
    protected string executionId;
    protected string taskId;
    protected Date timeStamp;
    protected string userId;
    protected byte[] data;
    protected string lockOwner;
    protected string lockTime;
    protected int isProcessed;

    public EventLogEntryEntityImpl() {
    }

    @Override
    public Object getPersistentState() {
        return null; // Not updatable
    }

    @Override
    public long getLogNumber() {
        return logNumber;
    }

    @Override
    public void setLogNumber(long logNumber) {
        this.logNumber = logNumber;
    }

    @Override
    public string getType() {
        return type;
    }

    @Override
    public void setType(string type) {
        this.type = type;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getExecutionId() {
        return executionId;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public string getTaskId() {
        return taskId;
    }

    @Override
    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public Date getTimeStamp() {
        return timeStamp;
    }

    @Override
    public void setTimeStamp(Date timeStamp) {
        this.timeStamp = timeStamp;
    }

    @Override
    public string getUserId() {
        return userId;
    }

    @Override
    public void setUserId(string userId) {
        this.userId = userId;
    }

    @Override
    public byte[] getData() {
        return data;
    }

    @Override
    public void setData(byte[] data) {
        this.data = data;
    }

    @Override
    public string getLockOwner() {
        return lockOwner;
    }

    @Override
    public void setLockOwner(string lockOwner) {
        this.lockOwner = lockOwner;
    }

    @Override
    public string getLockTime() {
        return lockTime;
    }

    @Override
    public void setLockTime(string lockTime) {
        this.lockTime = lockTime;
    }

    @Override
    public int getProcessed() {
        return isProcessed;
    }

    @Override
    public void setProcessed(int isProcessed) {
        this.isProcessed = isProcessed;
    }

    @Override
    public string toString() {
        return timeStamp.toString() + " : " + type;
    }

}
