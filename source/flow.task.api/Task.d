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
 
module flow.task.api.Task;
 
 
 


import java.util.Date;

/**
 * Represents one task for a human user.
 * 
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
 interface Task : TaskInfo {

    /**
     * Default value used for priority when a new {@link Task} is created.
     */
    int DEFAULT_PRIORITY = 50;

    /** Name or title of the task. */
    void setName(string name);

    /** Sets an optional localized name for the task. */
    void setLocalizedName(string name);

    /** Change the description of the task */
    void setDescription(string description);

    /** Sets an optional localized description for the task. */
    void setLocalizedDescription(string description);

    /** Sets the indication of how important/urgent this task is */
    void setPriority(int priority);

    /**
     * The {@link org.flowable.idm.api.User userId} of the person that is responsible for this task.
     */
    void setOwner(string owner);

    /**
     * The {@link org.flowable.idm.api.User userId} of the person to which this task is delegated.
     */
    void setAssignee(string assignee);

    /** The current {@link DelegationState} for this task. */
    DelegationState getDelegationState();

    /** The current {@link DelegationState} for this task. */
    void setDelegationState(DelegationState delegationState);

    /** Change due date of the task. */
    void setDueDate(Date dueDate);

    /**
     * Change the category of the task. This is an optional field and allows to 'tag' tasks as belonging to a certain category.
     */
    void setCategory(string category);

    /** the parent task for which this task is a subtask */
    void setParentTaskId(string parentTaskId);

    /** Change the tenantId of the task */
    void setTenantId(string tenantId);

    /** Change the form key of the task */
    void setFormKey(string formKey);

    /** Indicates whether this task is suspended or not. */
    boolean isSuspended();

}
