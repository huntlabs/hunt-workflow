/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import java.io.Serializable;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author martin.grofcik
 */
class ActivityInstanceEntityImpl extends AbstractBpmnEngineEntity implements ActivityInstanceEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processInstanceId;
    protected string processDefinitionId;
    protected Date startTime;
    protected Date endTime;
    protected Long durationInMillis;
    protected string deleteReason;

    protected string activityId;
    protected string activityName;
    protected string activityType;
    protected string executionId;
    protected string assignee;
    protected string taskId;
    protected string calledProcessInstanceId;
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;

    public ActivityInstanceEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("endTime", endTime);
        persistentState.put("durationInMillis", durationInMillis);
        persistentState.put("deleteReason", deleteReason);
        persistentState.put("executionId", executionId);
        persistentState.put("taskId", taskId);
        persistentState.put("assignee", assignee);
        persistentState.put("calledProcessInstanceId", calledProcessInstanceId);
        persistentState.put("activityId", activityId);
        persistentState.put("activityName", activityName);
        return persistentState;
    }

    @Override
    public void markEnded(string deleteReason) {
        if (this.endTime is null) {
            this.deleteReason = deleteReason;
            this.endTime = CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime();
            if (endTime !is null && startTime !is null) {
                this.durationInMillis = endTime.getTime() - startTime.getTime();
            }
        }
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public Date getStartTime() {
        return startTime;
    }

    @Override
    public Date getEndTime() {
        return endTime;
    }

    @Override
    public Long getDurationInMillis() {
        return durationInMillis;
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
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    @Override
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Override
    public void setDurationInMillis(Long durationInMillis) {
        this.durationInMillis = durationInMillis;
    }

    @Override
    public string getDeleteReason() {
        return deleteReason;
    }

    @Override
    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
    }

    @Override
    public string getActivityId() {
        return activityId;
    }

    @Override
    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }

    @Override
    public string getActivityName() {
        return activityName;
    }

    @Override
    public void setActivityName(string activityName) {
        this.activityName = activityName;
    }

    @Override
    public string getActivityType() {
        return activityType;
    }

    @Override
    public void setActivityType(string activityType) {
        this.activityType = activityType;
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
    public string getAssignee() {
        return assignee;
    }

    @Override
    public void setAssignee(string assignee) {
        this.assignee = assignee;
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
    public string getCalledProcessInstanceId() {
        return calledProcessInstanceId;
    }

    @Override
    public void setCalledProcessInstanceId(string calledProcessInstanceId) {
        this.calledProcessInstanceId = calledProcessInstanceId;
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public Date getTime() {
        return getStartTime();
    }

    @Override
    public string toString() {
        return "ActivityInstanceEntity[id=" + id + ", activityId=" + activityId + ", activityName=" + activityName + ", executionId= " + executionId + "]";
    }

}
