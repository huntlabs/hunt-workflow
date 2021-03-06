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
module flow.task.service.impl.persistence.entity.data.TaskDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.task.api.Task;
import flow.task.service.impl.TaskQueryImpl;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tijs Rademakers
 */
interface TaskDataManager : DataManager!TaskEntity {

    List!TaskEntity findTasksByExecutionId( string executionId);

    List!TaskEntity findTasksByProcessInstanceId(string processInstanceId);

    List!TaskEntity findTasksByScopeIdAndScopeType(string scopeId, string scopeType);

    List!TaskEntity findTasksBySubScopeIdAndScopeType(string subScopeId, string scopeType);

    List!Task findTasksByQueryCriteria(TaskQueryImpl taskQuery);

    List!Task findTasksWithRelatedEntitiesByQueryCriteria(TaskQueryImpl taskQuery);

    long findTaskCountByQueryCriteria(TaskQueryImpl taskQuery);

    List!Task findTasksByNativeQuery(Map!(string, Object) parameterMap);

    long findTaskCountByNativeQuery(Map!(string, Object) parameterMap);

    List!Task findTasksByParentTaskId(string parentTaskId);

    void updateTaskTenantIdForDeployment(string deploymentId, string newTenantId);

    void updateAllTaskRelatedEntityCountFlags(bool newValue);

    void deleteTasksByExecutionId(string executionId);

}
