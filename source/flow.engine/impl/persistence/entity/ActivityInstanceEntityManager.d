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


import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.common.persistence.entity.EntityManager;
import flow.engine.impl.ActivityInstanceQueryImpl;
import flow.engine.runtime.ActivityInstance;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author martin.grofcik
 */
interface ActivityInstanceEntityManager extends EntityManager<ActivityInstanceEntity> {

    ActivityInstanceEntity findUnfinishedActivityInstance(ExecutionEntity execution);

    List<ActivityInstanceEntity> findActivityInstancesByExecutionAndActivityId(string executionId, string activityId);

    long findActivityInstanceCountByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery);

    List<ActivityInstance> findActivityInstancesByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery);

    List<ActivityInstance> findActivityInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteActivityInstancesByProcessInstanceId(string processInstanceId);

    /**
     * Record Activity end, if activity event logging is enabled.
     *
     * @param executionEntity
     *     execution entity during which execution activity was ended
     * @param deleteReason
     *     the reason why activity was ended
     */
    void recordActivityEnd(ExecutionEntity executionEntity, string deleteReason);

    /**
     * Record the start of an activity, if activity event logging is enabled.
     *
     * @param executionEntity
     *     execution which is starting activityz
     */
    void recordActivityStart(ExecutionEntity executionEntity);

    /**
     * Record the sub process instance start
     */
    void recordSubProcessInstanceStart(ExecutionEntity parentExecution, ExecutionEntity subProcessInstance);

    /**
     * Record task created
     *
     * @param task the task which was created
     * @param execution execution which created the task
     */
    void recordTaskCreated(TaskEntity task, ExecutionEntity execution);

    /**
     * Record task information change
     *
     * @param taskEntity task entity which was changed
     * @param changeTime the time of the change
     */
    void recordTaskInfoChange(TaskEntity taskEntity, Date changeTime);

    /**
     * Synchronize data with the new user task execution
     *
     * @param executionEntity execution which executes user task
     * @param newFlowElement user task flow element
     * @param oldActivityId previous activity id
     * @param task the user task
     */
    void syncUserTaskExecution(ExecutionEntity executionEntity, FlowElement newFlowElement, string oldActivityId, TaskEntity task);

    /**
     * Update process definition reference in all activity instances for a given process instance
     *
     * @param newProcessDefinitionId new process definition id
     * @param processInstanceId process instance which activities are transformed
     */
    void updateActivityInstancesProcessDefinitionId(string newProcessDefinitionId, string processInstanceId);

    /**
     * record that sequence flow was taken
     *
     * @param execution execution which executed sequence flow
     */
    void recordSequenceFlowTaken(ExecutionEntity execution);
}
