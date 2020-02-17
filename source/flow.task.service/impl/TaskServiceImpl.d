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


import java.util.List;

import org.flowable.common.engine.impl.service.CommonServiceImpl;
import org.flowable.task.api.Task;
import org.flowable.task.api.TaskBuilder;
import org.flowable.task.api.TaskQuery;
import org.flowable.task.service.TaskService;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.task.service.impl.persistence.entity.TaskEntityManager;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TaskServiceImpl extends CommonServiceImpl<TaskServiceConfiguration> implements TaskService {

    public TaskServiceImpl(TaskServiceConfiguration taskServiceConfiguration) {
        super(taskServiceConfiguration);
    }

    @Override
    public TaskEntity getTask(string id) {
        return getTaskEntityManager().findById(id);
    }

    @Override
    public List<TaskEntity> findTasksByExecutionId(string executionId) {
        return getTaskEntityManager().findTasksByExecutionId(executionId);
    }

    @Override
    public List<TaskEntity> findTasksByProcessInstanceId(string processInstanceId) {
        return getTaskEntityManager().findTasksByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<Task> findTasksByParentTaskId(string parentTaskId) {
        return getTaskEntityManager().findTasksByParentTaskId(parentTaskId);
    }
    
    @Override
    public List<TaskEntity> findTasksBySubScopeIdScopeType(string subScopeId, string scopeType) {
        return getTaskEntityManager().findTasksBySubScopeIdAndScopeType(subScopeId, scopeType);
    }

    @Override
    public TaskQuery createTaskQuery() {
        return new TaskQueryImpl();
    }

    @Override
    public void changeTaskAssignee(TaskEntity taskEntity, string userId) {
        getTaskEntityManager().changeTaskAssignee(taskEntity, userId);
    }

    @Override
    public void changeTaskOwner(TaskEntity taskEntity, string ownerId) {
        getTaskEntityManager().changeTaskOwner(taskEntity, ownerId);
    }

    @Override
    public void updateTaskTenantIdForDeployment(string deploymentId, string tenantId) {
        getTaskEntityManager().updateTaskTenantIdForDeployment(deploymentId, tenantId);
    }

    @Override
    public void updateTask(TaskEntity taskEntity, boolean fireUpdateEvent) {
        getTaskEntityManager().update(taskEntity, fireUpdateEvent);
    }
    
    @Override
    public void updateAllTaskRelatedEntityCountFlags(boolean configProperty) {
        getTaskEntityManager().updateAllTaskRelatedEntityCountFlags(configProperty);
    }

    @Override
    public TaskEntity createTask() {
        return getTaskEntityManager().create();
    }

    @Override
    public void insertTask(TaskEntity taskEntity, boolean fireCreateEvent) {
        getTaskEntityManager().insert(taskEntity, fireCreateEvent);
    }

    @Override
    public void deleteTask(TaskEntity task, boolean fireEvents) {
        getTaskEntityManager().delete(task, fireEvents);
    }
    
    @Override
    public void deleteTasksByExecutionId(string executionId) {
        getTaskEntityManager().deleteTasksByExecutionId(executionId);
    }

    public TaskEntityManager getTaskEntityManager() {
        return configuration.getTaskEntityManager();
    }

    @Override
    public TaskEntity createTask(TaskBuilder taskBuilder) {
        return getTaskEntityManager().createTask(taskBuilder);
    }
}
