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

module flow.task.api.TaskBuilder;





import hunt.time.LocalDateTime;
import hunt.collection.Set;

import flow.identitylink.api.IdentityLinkInfo;
import flow.task.api.Task;


alias Date = LocalDateTime;
/**
 * Wraps {@link TaskInfo} to the builder.
 *
 */
interface TaskBuilder {

    /**
     * Creates task instance according values set in the builder
     *
     * @return task instance
     */
    Task create();

    /**
     * DB id of the task.
     */
    TaskBuilder id(string id);
    string getId();

    /**
     * Name or title of the task.
     */
    TaskBuilder name(string name);
    string getName();

    /**
     * Free text description of the task.
     */
    TaskBuilder description(string description);
    string getDescription();

    /**
     * Indication of how important/urgent this task is
     */
    TaskBuilder priority(int priority);
    int getPriority();

    /**
     * The userId of the person that is responsible for this task.
     */
    TaskBuilder owner(string ownerId);
    string getOwner();

    /**
     * The userId of the person to which this task is delegated.
     */
    TaskBuilder assignee(string assigneId);
    string getAssignee();
    /**
     * Change due date of the task.
     */
    TaskBuilder dueDate(Date dueDate);
    Date getDueDate();

    /**
     * Change the category of the task. This is an optional field and allows to 'tag' tasks as belonging to a certain category.
     */
    TaskBuilder category(string category);
    string getCategory();

    /**
     * the parent task for which this task is a subtask
     */
    TaskBuilder parentTaskId(string parentTaskId);
    string getParentTaskId();

    /**
     * Change the tenantId of the task
     */
    TaskBuilder tenantId(string tenantId);
    string getTenantId();

    /**
     * Change the form key of the task
     */
    TaskBuilder formKey(string formKey);
    string getFormKey();

    /**
     * task definition id to create task from
     */
    TaskBuilder taskDefinitionId(string taskDefinitionId);
    string getTaskDefinitionId();

    /**
     * task definition key to create task from
     */
    TaskBuilder taskDefinitionKey(string taskDefinitionKey);
    string getTaskDefinitionKey();

    /**
     * add identity links to the task
     */
    TaskBuilder identityLinks(Set!IdentityLinkInfo identityLinks);
    Set!IdentityLinkInfo getIdentityLinks();

    /**
     * add task scopeId
     */
    TaskBuilder scopeId(string scopeId);
    string getScopeId();

    /**
     * Add scope type
     */
    TaskBuilder scopeType(string scopeType);
    string getScopeType();
}
