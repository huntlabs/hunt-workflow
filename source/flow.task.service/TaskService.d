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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.task.service.TaskService;
 
 
 

import org.flowable.task.api.Task;
import org.flowable.task.api.TaskBuilder;
import org.flowable.task.api.TaskQuery;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

import java.util.List;

/**
 * Service which provides access to {@link Task} and form related operations.
 * 
 * @author Tom Baeyens
 * @author Joram Barrez
 */
public interface TaskService {

    TaskEntity getTask(string id);
    
    List<TaskEntity> findTasksByExecutionId(string executionId);
    
    List<TaskEntity> findTasksByProcessInstanceId(string processInstanceId);
    
    List<Task> findTasksByParentTaskId(string parentTaskId);
    
    List<TaskEntity> findTasksBySubScopeIdScopeType(string subScopeId, string scopeType);

    TaskQuery createTaskQuery();
    
    void changeTaskAssignee(TaskEntity taskEntity, string userId);
    
    void changeTaskOwner(TaskEntity taskEntity, string ownerId);
    
    void updateTaskTenantIdForDeployment(string deploymentId, string tenantId);
    
    void updateTask(TaskEntity taskEntity, boolean fireUpdateEvent);
    
    void updateAllTaskRelatedEntityCountFlags(boolean configProperty);
    
    TaskEntity createTask();
    
    TaskEntity createTask(TaskBuilder taskBuilder);
    
    void insertTask(TaskEntity taskEntity, boolean fireCreateEvent);
    
    void deleteTask(TaskEntity task, boolean fireEvents);
    
    void deleteTasksByExecutionId(string executionId);
}
