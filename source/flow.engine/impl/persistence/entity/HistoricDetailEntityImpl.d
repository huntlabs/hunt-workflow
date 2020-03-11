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



import java.io.Serializable;
import hunt.time.LocalDateTime;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
abstract class HistoricDetailEntityImpl extends AbstractBpmnEngineNoRevisionEntity implements HistoricDetailEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processInstanceId;
    protected string activityInstanceId;
    protected string taskId;
    protected string executionId;
    protected Date time;
    protected string detailType;

    @Override
    public Object getPersistentState() {
        // details are not updatable so we always provide the same object as the state
        return HistoricDetailEntityImpl.class;
    }

    // getters and setters //////////////////////////////////////////////////////

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getActivityInstanceId() {
        return activityInstanceId;
    }

    @Override
    public void setActivityInstanceId(string activityInstanceId) {
        this.activityInstanceId = activityInstanceId;
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
    public string getExecutionId() {
        return executionId;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public Date getTime() {
        return time;
    }

    @Override
    public void setTime(Date time) {
        this.time = time;
    }

    @Override
    public string getDetailType() {
        return detailType;
    }

    @Override
    public void setDetailType(string detailType) {
        this.detailType = detailType;
    }

}
