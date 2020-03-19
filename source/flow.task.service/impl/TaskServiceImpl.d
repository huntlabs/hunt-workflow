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

module flow.task.service.impl.TaskServiceImpl;
import hunt.collection.List;

import flow.common.service.CommonServiceImpl;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.api.TaskQuery;
import flow.task.service.TaskService;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntityManager;
import flow.task.service.impl.TaskQueryImpl;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TaskServiceImpl : CommonServiceImpl!TaskServiceConfiguration , TaskService {

    this(TaskServiceConfiguration taskServiceConfiguration) {
        super(taskServiceConfiguration);
    }


    public TaskEntity getTask(string id) {
        return getTaskEntityManager().findById(id);
    }


    public List!TaskEntity findTasksByExecutionId(string executionId) {
        return getTaskEntityManager().findTasksByExecutionId(executionId);
    }


    public List!TaskEntity findTasksByProcessInstanceId(string processInstanceId) {
        return getTaskEntityManager().findTasksByProcessInstanceId(processInstanceId);
    }


    public List!Task findTasksByParentTaskId(string parentTaskId) {
        return getTaskEntityManager().findTasksByParentTaskId(parentTaskId);
    }


    public List!TaskEntity findTasksBySubScopeIdScopeType(string subScopeId, string scopeType) {
        return getTaskEntityManager().findTasksBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public TaskQuery createTaskQuery() {
        return new TaskQueryImpl();
    }


    public void changeTaskAssignee(TaskEntity taskEntity, string userId) {
        getTaskEntityManager().changeTaskAssignee(taskEntity, userId);
    }


    public void changeTaskOwner(TaskEntity taskEntity, string ownerId) {
        getTaskEntityManager().changeTaskOwner(taskEntity, ownerId);
    }


    public void updateTaskTenantIdForDeployment(string deploymentId, string tenantId) {
        getTaskEntityManager().updateTaskTenantIdForDeployment(deploymentId, tenantId);
    }


    public void updateTask(TaskEntity taskEntity, bool fireUpdateEvent) {
        getTaskEntityManager().update(taskEntity, fireUpdateEvent);
    }


    public void updateAllTaskRelatedEntityCountFlags(bool configProperty) {
        getTaskEntityManager().updateAllTaskRelatedEntityCountFlags(configProperty);
    }


    public TaskEntity createTask() {
        return getTaskEntityManager().create();
    }


    public void insertTask(TaskEntity taskEntity, bool fireCreateEvent) {
        getTaskEntityManager().insert(taskEntity, fireCreateEvent);
    }


    public void deleteTask(TaskEntity task, bool fireEvents) {
        getTaskEntityManager().dele(task, fireEvents);
    }


    public void deleteTasksByExecutionId(string executionId) {
        getTaskEntityManager().deleteTasksByExecutionId(executionId);
    }

    public TaskEntityManager getTaskEntityManager() {
        return configuration.getTaskEntityManager();
    }


    public TaskEntity createTask(TaskBuilder taskBuilder) {
        return getTaskEntityManager().createTask(taskBuilder);
    }
}
