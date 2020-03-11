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

module flow.task.service.delegate.DelegateTask;




import hunt.collection;
import java.util.Date;
import hunt.collection.Set;

import flow.common.api.FlowableObjectNotFoundException;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.task.api.DelegationState;
import org.flowable.variable.api.delegate.VariableScope;

/**
 * @author Joram Barrez
 */
interface DelegateTask : VariableScope {

    /** DB id of the task. */
    string getId();

    /** Name or title of the task. */
    string getName();

    /** Change the name of the task. */
    void setName(string name);

    /** Free text description of the task. */
    string getDescription();

    /** Change the description of the task */
    void setDescription(string description);

    /**
     * indication of how important/urgent this task is with a number between 0 and 100 where higher values mean a higher priority and lower values mean lower priority: [0..19] lowest, [20..39] low,
     * [40..59] normal, [60..79] high [80..100] highest
     */
    int getPriority();

    /**
     * indication of how important/urgent this task is with a number between 0 and 100 where higher values mean a higher priority and lower values mean lower priority: [0..19] lowest, [20..39] low,
     * [40..59] normal, [60..79] high [80..100] highest
     */
    void setPriority(int priority);

    /**
     * Reference to the process instance or null if it is not related to a process instance.
     */
    string getProcessInstanceId();

    /**
     * Reference to the path of execution or null if it is not related to a process instance.
     */
    string getExecutionId();

    /**
     * Reference to the process definition or null if it is not related to a process.
     */
    string getProcessDefinitionId();

    /** The date/time when this task was created */
    Date getCreateTime();

    /**
     * The id of the activity in the process defining this task or null if this is not related to a process
     */
    string getTaskDefinitionKey();

    /** Indicated whether this task is suspended or not. */
    bool isSuspended();

    /** The tenant identifier of this task */
    @Override
    string getTenantId();

    /** The form key for the user task */
    string getFormKey();

    /** Change the form key of the task */
    void setFormKey(string formKey);

    /**
     * Returns the event name which triggered the task listener to fire for this task.
     */
    string getEventName();

    /**
     * Returns the event handler identifier which triggered the task listener to fire for this task.
     */
    string getEventHandlerId();

    /**
     * The current {@link org.flowable.engine.task.DelegationState} for this task.
     */
    DelegationState getDelegationState();

    /** Adds the given user as a candidate user to this task. */
    void addCandidateUser(string userId);

    /** Adds multiple users as candidate user to this task. */
    void addCandidateUsers(Collection!string candidateUsers);

    /** Adds the given group as candidate group to this task */
    void addCandidateGroup(string groupId);

    /** Adds multiple groups as candidate group to this task. */
    void addCandidateGroups(Collection!string candidateGroups);

    /** The {@link User.getId() userId} of the person responsible for this task. */
    string getOwner();

    /** The {@link User.getId() userId} of the person responsible for this task. */
    void setOwner(string owner);

    /**
     * The {@link User.getId() userId} of the person to which this task is delegated.
     */
    string getAssignee();

    /**
     * The {@link User.getId() userId} of the person to which this task is delegated.
     */
    void setAssignee(string assignee);

    /** Due date of the task. */
    Date getDueDate();

    /** Change due date of the task. */
    void setDueDate(Date dueDate);

    /**
     * The category of the task. This is an optional field and allows to 'tag' tasks as belonging to a certain category.
     */
    string getCategory();

    /**
     * Change the category of the task. This is an optional field and allows to 'tag' tasks as belonging to a certain category.
     */
    void setCategory(string category);

    /**
     * Involves a user with a task. The type of identity link is defined by the given identityLinkType.
     *
     * @param userId
     *            id of the user involve, cannot be null.
     * @param identityLinkType
     *            type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void addUserIdentityLink(string userId, string identityLinkType);

    /**
     * Involves a group with group task. The type of identityLink is defined by the given identityLink.
     *
     * @param groupId
     *            id of the group to involve, cannot be null.
     * @param identityLinkType
     *            type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void addGroupIdentityLink(string groupId, string identityLinkType);

    /**
     * Convenience shorthand for {@link #deleteUserIdentityLink(string, string)} ; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param userId
     *            id of the user to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void deleteCandidateUser(string userId);

    /**
     * Convenience shorthand for {@link #deleteGroupIdentityLink(string, string, string)}; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param groupId
     *            id of the group to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void deleteCandidateGroup(string groupId);

    /**
     * Removes the association between a user and a task for the given identityLinkType.
     *
     * @param userId
     *            id of the user involve, cannot be null.
     * @param identityLinkType
     *            type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void deleteUserIdentityLink(string userId, string identityLinkType);

    /**
     * Removes the association between a group and a task for the given identityLinkType.
     *
     * @param groupId
     *            id of the group to involve, cannot be null.
     * @param identityLinkType
     *            type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void deleteGroupIdentityLink(string groupId, string identityLinkType);

    /**
     * Retrieves the candidate users and groups associated with the task.
     *
     * @return set of {@link IdentityLink}s of type {@link IdentityLinkType#CANDIDATE}.
     */
    Set!IdentityLink getCandidates();

}
