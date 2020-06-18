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

module flow.engine.TaskService;





import hunt.stream.Common;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.query.NativeQuery;
import flow.engine.runtime.DataObject;
import flow.engine.task.Attachment;
import flow.engine.task.Comment;
import flow.engine.task.Event;
import flow.form.api.FormInfo;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.task.api.DelegationState;
import flow.task.api.NativeTaskQuery;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.api.TaskQuery;
import flow.variable.service.api.persistence.entity.VariableInstance;

/**
 * Service which provides access to {@link Task} and form related operations.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface TaskService {

    /**
     * Creates a new task that is not related to any process instance.
     *
     * The returned task is transient and must be saved with {@link #saveTask(Task)} 'manually'.
     */
    Task newTask();

    /** create a new task with a user defined task id */
    Task newTask(string taskId);

    /**
     * Create a builder for the task
     *
     * @return task builder
     */
    TaskBuilder createTaskBuilder();

    /**
     * Saves the given task to the persistent data store. If the task is already present in the persistent store, it is updated. After a new task has been saved, the task instance passed into this
     * method is updated with the id of the newly created task.
     *
     * @param task
     *            the task, cannot be null.
     */
    void saveTask(Task task);

    /**
     * Deletes the given task, not deleting historic information that is related to this task.
     *
     * @param taskId
     *            The id of the task that will be deleted, cannot be null. If no task exists with the given taskId, the operation is ignored.
     * @throws FlowableObjectNotFoundException
     *             when the task with given id does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the task or in case the task is part of a running process.
     */
    void deleteTask(string taskId);

    /**
     * Deletes all tasks of the given collection, not deleting historic information that is related to these tasks.
     *
     * @param taskIds
     *            The id's of the tasks that will be deleted, cannot be null. All id's in the list that don't have an existing task will be ignored.
     * @throws FlowableObjectNotFoundException
     *             when one of the task does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the tasks or in case one of the tasks is part of a running process.
     */
    void deleteTasks(Collection!string taskIds);

    /**
     * Deletes the given task.
     *
     * @param taskId
     *            The id of the task that will be deleted, cannot be null. If no task exists with the given taskId, the operation is ignored.
     * @param cascade
     *            If cascade is true, also the historic information related to this task is deleted.
     * @throws FlowableObjectNotFoundException
     *             when the task with given id does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the task or in case the task is part of a running process.
     */
    void deleteTask(string taskId, bool cascade);

    /**
     * Deletes all tasks of the given collection.
     *
     * @param taskIds
     *            The id's of the tasks that will be deleted, cannot be null. All id's in the list that don't have an existing task will be ignored.
     * @param cascade
     *            If cascade is true, also the historic information related to this task is deleted.
     * @throws FlowableObjectNotFoundException
     *             when one of the tasks does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the tasks or in case one of the tasks is part of a running process.
     */
    void deleteTasks(Collection!string taskIds, bool cascade);

    /**
     * Deletes the given task, not deleting historic information that is related to this task..
     *
     * @param taskId
     *            The id of the task that will be deleted, cannot be null. If no task exists with the given taskId, the operation is ignored.
     * @param deleteReason
     *            reason the task is deleted. Is recorded in history, if enabled.
     * @throws FlowableObjectNotFoundException
     *             when the task with given id does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the task or in case the task is part of a running process
     */
    void deleteTask(string taskId, string deleteReason);

    /**
     * Deletes all tasks of the given collection, not deleting historic information that is related to these tasks.
     *
     * @param taskIds
     *            The id's of the tasks that will be deleted, cannot be null. All id's in the list that don't have an existing task will be ignored.
     * @param deleteReason
     *            reason the task is deleted. Is recorded in history, if enabled.
     * @throws FlowableObjectNotFoundException
     *             when one of the tasks does not exist.
     * @throws FlowableException
     *             when an error occurs while deleting the tasks or in case one of the tasks is part of a running process.
     */
    void deleteTasks(Collection!string taskIds, string deleteReason);

    /**
     * Claim responsibility for a task: the given user is made assignee for the task. The difference with {@link #setAssignee(string, string)} is that here a check is done if the task already has a
     * user assigned to it. No check is done whether the user is known by the identity component.
     *
     * @param taskId
     *            task to claim, cannot be null.
     * @param userId
     *            user that claims the task. When userId is null the task is unclaimed, assigned to no one.
     * @throws FlowableObjectNotFoundException
     *             when the task doesn't exist.
     * @throws flow.common.api.FlowableTaskAlreadyClaimedException
     *             when the task is already claimed by another user
     */
    void claim(string taskId, string userId);

    /**
     * A shortcut to {@link #claim} with null user in order to unclaim the task
     *
     * @param taskId
     *            task to unclaim, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task doesn't exist.
     */
    void unclaim(string taskId);

    /**
     * Called when the task is successfully executed.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     * @throws FlowableException
     *             when this task is {@link DelegationState#PENDING} delegation.
     */
    void complete(string taskId);

    /**
     * Delegates the task to another user. This means that the assignee is set and the delegation state is set to {@link DelegationState#PENDING}. If no owner is set on the task, the owner is set to
     * the current assignee of the task.
     *
     * @param taskId
     *            The id of the task that will be delegated.
     * @param userId
     *            The id of the user that will be set as assignee.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void delegateTask(string taskId, string userId);

    /**
     * Marks that the assignee is done with this task and that it can be send back to the owner. Can only be called when this task is {@link DelegationState#PENDING} delegation. After this method
     * returns, the {@link Task#getDelegationState() delegationState} is set to {@link DelegationState#RESOLVED}.
     *
     * @param taskId
     *            the id of the task to resolve, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void resolveTask(string taskId);

    /**
     * Marks that the assignee is done with this task providing the required variables and that it can be sent back to the owner. Can only be called when this task is {@link DelegationState#PENDING}
     * delegation. After this method returns, the {@link Task#getDelegationState() delegationState} is set to {@link DelegationState#RESOLVED}.
     *
     * @param taskId
     * @param variables
     * @throws ProcessEngineException
     *             When no task exists with the given id.
     */
    void resolveTask(string taskId, Map!(string, Object) variables);

    /**
     * Similar to {@link #resolveTask(string, Map)}, but allows to set transient variables too.
     */
    void resolveTask(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables);

    /**
     * Called when the task is successfully executed, and the required task parameters are given by the end-user.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @param variables
     *            task parameters. May be null or empty.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void complete(string taskId, Map!(string, Object) variables);

    /**
     * Similar to {@link #complete(string, Map)}, but allows to set transient variables too.
     */
    void complete(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables);

    /**
     * Called when the task is successfully executed, and the required task parameters are given by the end-user.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @param variables
     *            task parameters. May be null or empty.
     * @param localScope
     *            If true, the provided variables will be stored task-local, instead of process instance wide (which is the default for {@link #complete(string, Map)}).
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void complete(string taskId, Map!(string, Object) variables, bool localScope);

    /**
     * Called when the task is successfully executed, and the task form has been submitted.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @param formDefinitionId
     *            the id of the form definition that is filled-in to complete the task, cannot be null.
     * @param outcome
     *            the outcome of the completed form, can be null.
     * @param variables
     *            values of the completed form. May be null or empty.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void completeTaskWithForm(string taskId, string formDefinitionId, string outcome, Map!(string, Object) variables);

    /**
     * Called when the task is successfully executed, and the task form has been submitted.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @param formDefinitionId
     *            the id of the form definition that is filled-in to complete the task, cannot be null.
     * @param outcome
     *            the outcome of the completed form, can be null.
     * @param variables
     *            values of the completed form. May be null or empty.
     * @param transientVariables
     *            additional transient values that need to added to the process instance transient variables. May be null or empty.
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, Map!(string, Object) transientVariables);

    /**
     * Called when the task is successfully executed, and the task form has been submitted.
     *
     * @param taskId
     *            the id of the task to complete, cannot be null.
     * @param formDefinitionId
     *            the id of the form definition that is filled-in to complete the task, cannot be null.
     * @param outcome
     *            the outcome of the completed form, can be null.
     * @param variables
     *            values of the completed form. May be null or empty.
     * @param localScope
     *            If true, the provided variables will be stored task-local, instead of process instance wide (which is the default for {@link #complete(string, Map)}).
     * @throws FlowableObjectNotFoundException
     *             when no task exists with the given id.
     */
    void completeTaskWithForm(string taskId, string formDefinitionId, string outcome,
            Map!(string, Object) variables, bool localScope);

    /**
     * Gets a Form model instance of the task form of a specific task
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or form definition doesn't exist.
     */
    FormInfo getTaskFormModel(string taskId);

    /**
     * Gets a Form model instance of the task form of a specific task without any variable handling
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param ignoreVariables
     *            should the variables be ignored when fetching the form model?
     * @throws FlowableObjectNotFoundException
     *             when the task or form definition doesn't exist.
     */
    FormInfo getTaskFormModel(string taskId, bool ignoreVariables);

    /**
     * Changes the assignee of the given task to the given userId. No check is done whether the user is known by the identity component.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            id of the user to use as assignee.
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void setAssignee(string taskId, string userId);

    /**
     * Transfers ownership of this task to another user. No check is done whether the user is known by the identity component.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            of the person that is receiving ownership.
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void setOwner(string taskId, string userId);

    /**
     * Retrieves the {@link IdentityLink}s associated with the given task. Such an {@link IdentityLink} informs how a certain identity (eg. group or user) is associated with a certain task (eg. as
     * candidate, assignee, etc.)
     */
    List!IdentityLink getIdentityLinksForTask(string taskId);

    /**
     * Convenience shorthand for {@link #addUserIdentityLink(string, string, string)}; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            id of the user to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void addCandidateUser(string taskId, string userId);

    /**
     * Convenience shorthand for {@link #addGroupIdentityLink(string, string, string)}; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param groupId
     *            id of the group to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void addCandidateGroup(string taskId, string groupId);

    /**
     * Involves a user with a task. The type of identity link is defined by the given identityLinkType.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            id of the user involve, cannot be null.
     * @param identityLinkType
     *            type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void addUserIdentityLink(string taskId, string userId, string identityLinkType);

    /**
     * Involves a group with a task. The type of identityLink is defined by the given identityLink.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param groupId
     *            id of the group to involve, cannot be null.
     * @param identityLinkType
     *            type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void addGroupIdentityLink(string taskId, string groupId, string identityLinkType);

    /**
     * Convenience shorthand for {@link #deleteUserIdentityLink(string, string, string)}; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            id of the user to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void deleteCandidateUser(string taskId, string userId);

    /**
     * Convenience shorthand for {@link #deleteGroupIdentityLink(string, string, string)}; with type {@link IdentityLinkType#CANDIDATE}
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param groupId
     *            id of the group to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void deleteCandidateGroup(string taskId, string groupId);

    /**
     * Removes the association between a user and a task for the given identityLinkType.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param userId
     *            id of the user involve, cannot be null.
     * @param identityLinkType
     *            type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or user doesn't exist.
     */
    void deleteUserIdentityLink(string taskId, string userId, string identityLinkType);

    /**
     * Removes the association between a group and a task for the given identityLinkType.
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param groupId
     *            id of the group to involve, cannot be null.
     * @param identityLinkType
     *            type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *             when the task or group doesn't exist.
     */
    void deleteGroupIdentityLink(string taskId, string groupId, string identityLinkType);

    /**
     * Changes the priority of the task.
     *
     * Authorization: actual owner / business admin
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param priority
     *            the new priority for the task.
     * @throws FlowableObjectNotFoundException
     *             when the task doesn't exist.
     */
    void setPriority(string taskId, int priority);

    /**
     * Changes the due date of the task
     *
     * @param taskId
     *            id of the task, cannot be null.
     * @param dueDate
     *            the new due date for the task
     * @throws FlowableException
     *             when the task doesn't exist.
     */
    void setDueDate(string taskId, Date dueDate);

    /**
     * Returns a new {@link TaskQuery} that can be used to dynamically query tasks.
     */
    TaskQuery createTaskQuery();

    /**
     * Returns a new {@link NativeQuery} for tasks.
     */
    NativeTaskQuery createNativeTaskQuery();

    /**
     * set variable on a task. If the variable is not already existing, it will be created in the most outer scope. This means the process instance in case this task is related to an execution.
     */
    void setVariable(string taskId, string variableName, Object value);

    /**
     * set variables on a task. If the variable is not already existing, it will be created in the most outer scope. This means the process instance in case this task is related to an execution.
     */
    void setVariables(string taskId, Map!(string,Object) variables);

    /**
     * set variable on a task. If the variable is not already existing, it will be created in the task.
     */
    void setVariableLocal(string taskId, string variableName, Object value);

    /**
     * set variables on a task. If the variable is not already existing, it will be created in the task.
     */
    void setVariablesLocal(string taskId, Map!(string,Object) variables);

    /**
     * get a variables and search in the task scope and if available also the execution scopes.
     */
    Object getVariable(string taskId, string variableName);

    /**
     * get a variables and search in the task scope and if available also the execution scopes.
     */
    Object getVariable(string taskId, string variableName, TypeInfo variableClass);

    /**
     * The variable. Searching for the variable is done in all scopes that are visible to the given task (including parent scopes). Returns null when no variable value is found with the given name.
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param variableName
     *            name of variable, cannot be null.
     * @return the variable or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *             when no execution is found for the given taskId.
     */
    VariableInstance getVariableInstance(string taskId, string variableName);

    /**
     * checks whether or not the task has a variable defined with the given name, in the task scope and if available also the execution scopes.
     */
    bool hasVariable(string taskId, string variableName);

    /**
     * checks whether or not the task has a variable defined with the given name.
     */
    Object getVariableLocal(string taskId, string variableName);

    /**
     * checks whether or not the task has a variable defined with the given name.
     */
    Object getVariableLocal(string taskId, string variableName, TypeInfo variableClass);

    /**
     * The variable for a task. Returns the variable when it is set for the task (and not searching parent scopes). Returns null when no variable is found with the given name.
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param variableName
     *            name of variable, cannot be null.
     * @return the variable or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    VariableInstance getVariableInstanceLocal(string taskId, string variableName);

    /**
     * checks whether or not the task has a variable defined with the given name, local task scope only.
     */
    bool hasVariableLocal(string taskId, string variableName);

    /**
     * get all variables and search in the task scope and if available also the execution scopes. If you have many variables and you only need a few, consider using
     * {@link #getVariables(string, Collection)} for better performance.
     */
    Map!(string, Object) getVariables(string taskId);

    /**
     * All variables visible from the given task scope (including parent scopes).
     *
     * @param taskId
     *            id of task, cannot be null.
     * @return the variable instances or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    Map!(string, VariableInstance) getVariableInstances(string taskId);

    /**
     * The variable values for all given variableNames, takes all variables into account which are visible from the given task scope (including parent scopes).
     *
     * @param taskId
     *            id of taskId, cannot be null.
     * @param variableNames
     *            the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *             when no taskId is found for the given taskId.
     */
    Map!(string, VariableInstance) getVariableInstances(string taskId, Collection!string variableNames);

    /**
     * get all variables and search only in the task scope. If you have many task local variables and you only need a few, consider using {@link #getVariablesLocal(string, Collection)} for better
     * performance.
     */
    Map!(string, Object) getVariablesLocal(string taskId);

    /**
     * get values for all given variableNames and search only in the task scope.
     */
    Map!(string, Object) getVariables(string taskId, Collection!string variableNames);

    /** get a variable on a task */
    Map!(string, Object) getVariablesLocal(string taskId, Collection!string variableNames);

    /** get all variables and search only in the task scope. */
    List!VariableInstance getVariableInstancesLocalByTaskIds(Set!string taskIds);

    /**
     * All variable values that are defined in the task scope, without taking outer scopes into account. If you have many task local variables and you only need a few, consider using
     * {@link #getVariableInstancesLocal(string, Collection)} for better performance.
     *
     * @param taskId
     *            id of task, cannot be null.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    Map!(string, VariableInstance) getVariableInstancesLocal(string taskId);

    /**
     * The variable values for all given variableNames that are defined in the given task's scope. (Does not searching parent scopes).
     *
     * @param taskId
     *            id of taskId, cannot be null.
     * @param variableNames
     *            the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *             when no taskId is found for the given taskId.
     */
    Map!(string, VariableInstance) getVariableInstancesLocal(string taskId, Collection!string variableNames);

    /**
     * Removes the variable from the task. When the variable does not exist, nothing happens.
     */
    void removeVariable(string taskId, string variableName);

    /**
     * Removes the variable from the task (not considering parent scopes). When the variable does not exist, nothing happens.
     */
    void removeVariableLocal(string taskId, string variableName);

    /**
     * Removes all variables in the given collection from the task. Non existing variable names are simply ignored.
     */
    void removeVariables(string taskId, Collection!string variableNames);

    /**
     * Removes all variables in the given collection from the task (not considering parent scopes). Non existing variable names are simply ignored.
     */
    void removeVariablesLocal(string taskId, Collection!string variableNames);

    /**
     * All DataObjects visible from the given execution scope (including parent scopes).
     *
     * @param taskId
     *            id of task, cannot be null.
     * @return the DataObjects or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    Map!(string, DataObject) getDataObjects(string taskId);

    /**
     * All DataObjects visible from the given task scope (including parent scopes).
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param locale
     *            locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *            When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given task.
     */
    Map!(string, DataObject) getDataObjects(string taskId, string locale, bool withLocalizationFallback);

    /**
     * The DataObjects for all given dataObjectNames, takes all dataObjects into account which are visible from the given task scope (including parent scopes).
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param dataObjectNames
     *            the collection of DataObject names that should be retrieved.
     * @return the DataObject or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    Map!(string, DataObject) getDataObjects(string taskId, Collection!string dataObjectNames);

    /**
     * The DataObjects for all given dataObjectNames, takes all dataObjects into account which are visible from the given task scope (including parent scopes).
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param dataObjectNames
     *            the collection of DataObject names that should be retrieved.
     * @param locale
     *            locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *            When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no such dataObjects are found.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given task.
     */
    Map!(string, DataObject) getDataObjects(string taskId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback);

    /**
     * The DataObject. Searching for the DataObject is done in all scopes that are visible to the given task (including parent scopes). Returns null when no DataObject value is found with the given
     * name.
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param dataObject
     *            name of DataObject, cannot be null.
     * @return the DataObject or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    DataObject getDataObject(string taskId, string dataObject);

    /**
     * The DataObject. Searching for the DataObject is done in all scopes that are visible to the given task (including parent scopes). Returns null when no DataObject value is found with the given
     * name.
     *
     * @param taskId
     *            id of task, cannot be null.
     * @param dataObjectName
     *            name of DataObject, cannot be null.
     * @param locale
     *            locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *            When true localization will fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     * @return the DataObject or null if the DataObject is undefined.
     * @throws FlowableObjectNotFoundException
     *             when no task is found for the given taskId.
     */
    DataObject getDataObject(string taskId, string dataObjectName, string locale, bool withLocalizationFallback);

    /** Add a comment to a task and/or process instance. */
    Comment addComment(string taskId, string processInstanceId, string message);

    /** Add a comment to a task and/or process instance with a custom type. */
    Comment addComment(string taskId, string processInstanceId, string type, string message);

    /** Update a comment to a task and/or process instance. */
    void saveComment(Comment comment);

    /**
     * Returns an individual comment with the given id. Returns null if no comment exists with the given id.
     */
    Comment getComment(string commentId);

    /** Removes all comments from the provided task and/or process instance */
    void deleteComments(string taskId, string processInstanceId);

    /**
     * Removes an individual comment with the given id.
     *
     * @throws FlowableObjectNotFoundException
     *             when no comment exists with the given id.
     */
    void deleteComment(string commentId);

    /** The comments related to the given task. */
    List!Comment getTaskComments(string taskId);

    /** The comments related to the given task of the given type. */
    List!Comment getTaskComments(string taskId, string type);

    /** All comments of a given type. */
    List!Comment getCommentsByType(string type);

    /** The all events related to the given task. */
    List!Event getTaskEvents(string taskId);

    /**
     * Returns an individual event with the given id. Returns null if no event exists with the given id.
     */
    Event getEvent(string eventId);

    /** The comments related to the given process instance. */
    List!Comment getProcessInstanceComments(string processInstanceId);

    /** The comments related to the given process instance. */
    List!Comment getProcessInstanceComments(string processInstanceId, string type);

    /**
     * Add a new attachment to a task and/or a process instance and use an input stream to provide the content
     */
    Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, InputStream content);

    /**
     * Add a new attachment to a task and/or a process instance and use an url as the content
     */
    Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, string url);

    /** Update the name and description of an attachment */
    void saveAttachment(Attachment attachment);

    /** Retrieve a particular attachment */
    Attachment getAttachment(string attachmentId);

    /** Retrieve stream content of a particular attachment */
    InputStream getAttachmentContent(string attachmentId);

    /** The list of attachments associated to a task */
    List!Attachment getTaskAttachments(string taskId);

    /** The list of attachments associated to a process instance */
    List!Attachment getProcessInstanceAttachments(string processInstanceId);

    /** Delete an attachment */
    void deleteAttachment(string attachmentId);

    /** The list of subtasks for this parent task */
    List!Task getSubTasks(string parentTaskId);
}
