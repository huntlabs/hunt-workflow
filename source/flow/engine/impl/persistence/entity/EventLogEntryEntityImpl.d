///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.time.LocalDateTime;
//
///**
// * An event log entry can only be inserted (and maybe deleted).
// *
// * @author Joram Barrez
// */
//class EventLogEntryEntityImpl : AbstractBpmnEngineNoRevisionEntity implements EventLogEntryEntity {
//
//    protected long logNumber; // cant use id here, it would clash with entity
//    protected string type;
//    protected string processDefinitionId;
//    protected string processInstanceId;
//    protected string executionId;
//    protected string taskId;
//    protected Date timeStamp;
//    protected string userId;
//    protected byte[] data;
//    protected string lockOwner;
//    protected string lockTime;
//    protected int isProcessed;
//
//    public EventLogEntryEntityImpl() {
//    }
//
//    override
//    public Object getPersistentState() {
//        return null; // Not updatable
//    }
//
//    override
//    public long getLogNumber() {
//        return logNumber;
//    }
//
//    override
//    public void setLogNumber(long logNumber) {
//        this.logNumber = logNumber;
//    }
//
//    override
//    public string getType() {
//        return type;
//    }
//
//    override
//    public void setType(string type) {
//        this.type = type;
//    }
//
//    override
//    public string getProcessDefinitionId() {
//        return processDefinitionId;
//    }
//
//    override
//    public void setProcessDefinitionId(string processDefinitionId) {
//        this.processDefinitionId = processDefinitionId;
//    }
//
//    override
//    public string getProcessInstanceId() {
//        return processInstanceId;
//    }
//
//    override
//    public void setProcessInstanceId(string processInstanceId) {
//        this.processInstanceId = processInstanceId;
//    }
//
//    override
//    public string getExecutionId() {
//        return executionId;
//    }
//
//    override
//    public void setExecutionId(string executionId) {
//        this.executionId = executionId;
//    }
//
//    override
//    public string getTaskId() {
//        return taskId;
//    }
//
//    override
//    public void setTaskId(string taskId) {
//        this.taskId = taskId;
//    }
//
//    override
//    public Date getTimeStamp() {
//        return timeStamp;
//    }
//
//    override
//    public void setTimeStamp(Date timeStamp) {
//        this.timeStamp = timeStamp;
//    }
//
//    override
//    public string getUserId() {
//        return userId;
//    }
//
//    override
//    public void setUserId(string userId) {
//        this.userId = userId;
//    }
//
//    override
//    public byte[] getData() {
//        return data;
//    }
//
//    override
//    public void setData(byte[] data) {
//        this.data = data;
//    }
//
//    override
//    public string getLockOwner() {
//        return lockOwner;
//    }
//
//    override
//    public void setLockOwner(string lockOwner) {
//        this.lockOwner = lockOwner;
//    }
//
//    override
//    public string getLockTime() {
//        return lockTime;
//    }
//
//    override
//    public void setLockTime(string lockTime) {
//        this.lockTime = lockTime;
//    }
//
//    override
//    public int getProcessed() {
//        return isProcessed;
//    }
//
//    override
//    public void setProcessed(int isProcessed) {
//        this.isProcessed = isProcessed;
//    }
//
//    override
//    public string toString() {
//        return timeStamp.toString() + " : " + type;
//    }
//
//}
