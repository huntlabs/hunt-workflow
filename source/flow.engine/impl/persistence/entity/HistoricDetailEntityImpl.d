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
//
//import java.io.Serializable;
//import hunt.time.LocalDateTime;
//
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// */
//abstract class HistoricDetailEntityImpl : AbstractBpmnEngineNoRevisionEntity implements HistoricDetailEntity, Serializable {
//
//    private static final long serialVersionUID = 1L;
//
//    protected string processInstanceId;
//    protected string activityInstanceId;
//    protected string taskId;
//    protected string executionId;
//    protected Date time;
//    protected string detailType;
//
//    override
//    public Object getPersistentState() {
//        // details are not updatable so we always provide the same object as the state
//        return HistoricDetailEntityImpl.class;
//    }
//
//    // getters and setters //////////////////////////////////////////////////////
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
//    public string getActivityInstanceId() {
//        return activityInstanceId;
//    }
//
//    override
//    public void setActivityInstanceId(string activityInstanceId) {
//        this.activityInstanceId = activityInstanceId;
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
//    public Date getTime() {
//        return time;
//    }
//
//    override
//    public void setTime(Date time) {
//        this.time = time;
//    }
//
//    override
//    public string getDetailType() {
//        return detailType;
//    }
//
//    override
//    public void setDetailType(string detailType) {
//        this.detailType = detailType;
//    }
//
//}
