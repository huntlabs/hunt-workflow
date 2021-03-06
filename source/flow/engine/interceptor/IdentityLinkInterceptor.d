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

module flow.engine.interceptor.IdentityLinkInterceptor;

import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;

interface IdentityLinkInterceptor {

    void handleCompleteTask(TaskEntity task);

    void handleAddIdentityLinkToTask(TaskEntity taskEntity, IdentityLinkEntity identityLinkEntity);

    void handleAddAssigneeIdentityLinkToTask(TaskEntity taskEntity, string assignee);

    void handleAddOwnerIdentityLinkToTask(TaskEntity taskEntity, string owner);

    void handleCreateProcessInstance(ExecutionEntity processInstanceExecution);

    void handleCreateSubProcessInstance(ExecutionEntity subProcessInstanceExecution, ExecutionEntity superExecution);
}
