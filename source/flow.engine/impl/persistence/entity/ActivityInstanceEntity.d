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

module flow.engine.impl.persistence.entity.ActivityInstanceEntity;

import hunt.time.LocalDateTime;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.engine.runtime.ActivityInstance;

/**
 * @author martin.grofcik
 */
interface ActivityInstanceEntity : ActivityInstance, Entity, HasRevision {

    void markEnded(string deleteReason);


    string getProcessInstanceId();


    string getProcessDefinitionId();


    Date getStartTime();


    Date getEndTime();


    long getDurationInMillis();

    void setProcessInstanceId(string processInstanceId);

    void setProcessDefinitionId(string processDefinitionId);

    void setStartTime(Date startTime);

    void setEndTime(Date endTime);

    void setDurationInMillis(long durationInMillis);


    string getDeleteReason();

    void setDeleteReason(string deleteReason);

    void setActivityId(string activityId);

    void setActivityName(string activityName);

    void setActivityType(string activityType);

    void setExecutionId(string executionId);

    void setAssignee(string assignee);

    void setTaskId(string taskId);

    void setCalledProcessInstanceId(string calledProcessInstanceId);

    void setTenantId(string tenantId);

}
