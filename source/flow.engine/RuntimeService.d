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
 
module flow.engine.RuntimeService;
 
 
 


import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.flowable.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.engine.runtime.ActivityInstance;
import flow.engine.runtime.ActivityInstanceQuery;
import flow.engine.runtime.ChangeActivityStateBuilder;
import flow.engine.runtime.DataObject;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ExecutionQuery;
import flow.engine.runtime.NativeActivityInstanceQuery;
import flow.engine.runtime.NativeExecutionQuery;
import flow.engine.runtime.NativeProcessInstanceQuery;
import flow.engine.runtime.ProcessInstance;
import flow.engine.runtime.ProcessInstanceBuilder;
import flow.engine.runtime.ProcessInstanceQuery;
import flow.engine.task.Event;
import org.flowable.entitylink.api.EntityLink;
import org.flowable.eventregistry.api.EventRegistryEventConsumer;
import org.flowable.eventsubscription.api.EventSubscriptionQuery;
import org.flowable.form.api.FormInfo;
import org.flowable.identitylink.api.IdentityLink;
import org.flowable.identitylink.api.IdentityLinkType;
import org.flowable.variable.api.delegate.VariableScope;
import org.flowable.variable.api.persistence.entity.VariableInstance;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Daniel Meyer
 */
interface RuntimeService {

    /**
     * Create a {@link ProcessInstanceBuilder}, that allows to set various options for starting a process instance, as an alternative to the various startProcessInstanceByXX methods.
     */
    ProcessInstanceBuilder createProcessInstanceBuilder();

    /**
     * Starts a new process instance in the latest version of the process definition with the given key.
     *
     * @param processDefinitionKey
     *     key of process definition, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceByKey(string processDefinitionKey);

    /**
     * Starts a new process instance in the latest version of the process definition with the given key.
     * <p>
     * A business key can be provided to associate the process instance with a certain identifier that has a clear business meaning. For example in an order process, the business key could be an order
     * id. This business key can then be used to easily look up that process instance , see {@link ProcessInstanceQuery#processInstanceBusinessKey(string)}. Providing such a business key is definitely
     * a best practice.
     *
     * @param processDefinitionKey
     *     key of process definition, cannot be null.
     * @param businessKey
     *     a key that identifies the process instance and can be used to retrieve the process instance later via the query API.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey);

    /**
     * Starts a new process instance in the latest version of the process definition with the given key
     *
     * @param processDefinitionKey
     *     key of process definition, cannot be null.
     * @param variables
     *     the variables to pass, can be null.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceByKey(string processDefinitionKey, Map<string, Object> variables);

    /**
     * Starts a new process instance in the latest version of the process definition with the given key.
     * <p>
     * A business key can be provided to associate the process instance with a certain identifier that has a clear business meaning. For example in an order process, the business key could be an order
     * id. This business key can then be used to easily look up that process instance , see {@link ProcessInstanceQuery#processInstanceBusinessKey(string)}. Providing such a business key is definitely
     * a best practice.
     *
     * @param processDefinitionKey
     *     key of process definition, cannot be null.
     * @param variables
     *     the variables to pass, can be null.
     * @param businessKey
     *     a key that identifies the process instance and can be used to retrieve the process instance later via the query API.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey, Map<string, Object> variables);

    /**
     * Similar to {@link #startProcessInstanceByKey(string)}, but using a specific tenant identifier.
     */
    ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string tenantId);

    /**
     * Similar to {@link #startProcessInstanceByKey(string, string)}, but using a specific tenant identifier.
     */
    ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, string tenantId);

    /**
     * Similar to {@link #startProcessInstanceByKey(string, Map)}, but using a specific tenant identifier.
     */
    ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, Map<string, Object> variables, string tenantId);

    /**
     * Similar to {@link #startProcessInstanceByKey(string, string, Map)}, but using a specific tenant identifier.
     */
    ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, Map<string, Object> variables, string tenantId);

    /**
     * Starts a new process instance in the exactly specified version of the process definition with the given id.
     *
     * @param processDefinitionId
     *     the id of the process definition, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceById(string processDefinitionId);

    /**
     * Starts a new process instance in the exactly specified version of the process definition with the given id.
     * <p>
     * A business key can be provided to associate the process instance with a certain identifier that has a clear business meaning. For example in an order process, the business key could be an order
     * id. This business key can then be used to easily look up that process instance , see {@link ProcessInstanceQuery#processInstanceBusinessKey(string)}. Providing such a business key is definitely
     * a best practice.
     *
     * @param processDefinitionId
     *     the id of the process definition, cannot be null.
     * @param businessKey
     *     a key that identifies the process instance and can be used to retrieve the process instance later via the query API.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey);

    /**
     * Starts a new process instance in the exactly specified version of the process definition with the given id.
     *
     * @param processDefinitionId
     *     the id of the process definition, cannot be null.
     * @param variables
     *     variables to be passed, can be null
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceById(string processDefinitionId, Map<string, Object> variables);

    /**
     * Starts a new process instance in the exactly specified version of the process definition with the given id.
     * <p>
     * A business key can be provided to associate the process instance with a certain identifier that has a clear business meaning. For example in an order process, the business key could be an order
     * id. This business key can then be used to easily look up that process instance , see {@link ProcessInstanceQuery#processInstanceBusinessKey(string)}. Providing such a business key is definitely
     * a best practice.
     *
     * @param processDefinitionId
     *     the id of the process definition, cannot be null.
     * @param variables
     *     variables to be passed, can be null
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given key.
     */
    ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey, Map<string, Object> variables);

    /**
     * Starts a new process instance in the exactly specified version of the process definition with the given id.
     * <p>
     * A business key can be provided to associate the process instance with a certain identifier that has a clear business meaning. For example in an order process, the business key could be an order
     * id. This business key can then be used to easily look up that process instance , see {@link ProcessInstanceQuery#processInstanceBusinessKey(string)}. Providing such a business key is definitely
     * a best practice.
     * <p>
     * Only use this method when a form definition is attached to the start event of the provided process definition. This will expect the Flowable Form Engine to be enabled. A new form instance will
     * be created after successfully starting a new process instance.
     *
     * @param processDefinitionId
     *     the id of the process definition, cannot be null.
     * @param outcome
     *     the form outcome of the start form, can be null.
     * @param variables
     *     variables to be passed, can be null
     * @param processInstanceName
     *     the name of the process instance to be started, can be null.
     * @throws FlowableObjectNotFoundException
     *     when no process definition is deployed with the given id.
     */
    ProcessInstance startProcessInstanceWithForm(string processDefinitionId, string outcome, Map<string, Object> variables, string processInstanceName);

    /**
     * <p>
     * Signals the process engine that a message is received and starts a new {@link ProcessInstance}.
     * </p>
     *
     * <p>
     * Calling this method can have two different outcomes:
     * <ul>
     * <li>If the message name is associated with a message start event, a new process instance is started.</li>
     * <li>If no subscription to a message with the given name exists, {@link FlowableException} is thrown</li>
     * </ul>
     * </p>
     *
     * @param messageName
     *     the 'name' of the message as specified as an attribute on the bpmn20 {@code <message name="messageName" />} element.
     * @return the {@link ProcessInstance} object representing the started process instance
     * @throws FlowableException
     *     if no subscription to a message with the given name exists
     * @since 5.9
     */
    ProcessInstance startProcessInstanceByMessage(string messageName);

    /**
     * Similar to {@link RuntimeService#startProcessInstanceByMessage(string)}, but with tenant context.
     */
    ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string tenantId);

    /**
     * <p>
     * Signals the process engine that a message is received and starts a new {@link ProcessInstance}.
     * </p>
     * <p>
     * See {@link #startProcessInstanceByMessage(string, Map)}. This method allows specifying a business key.
     *
     * @param messageName
     *     the 'name' of the message as specified as an attribute on the bpmn20 {@code <message name="messageName" />} element.
     * @param businessKey
     *     the business key which is added to the started process instance
     * @throws FlowableException
     *     if no subscription to a message with the given name exists
     * @since 5.10
     */
    ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey);

    /**
     * Similar to {@link RuntimeService#startProcessInstanceByMessage(string, string)}, but with tenant context.
     */
    ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, string tenantId);

    /**
     * <p>
     * Signals the process engine that a message is received and starts a new {@link ProcessInstance}.
     * </p>
     * <p>
     * See {@link #startProcessInstanceByMessage(string)}. In addition, this method allows specifying a the payload of the message as a map of process variables.
     *
     * @param messageName
     *     the 'name' of the message as specified as an attribute on the bpmn20 {@code <message name="messageName" />} element.
     * @param processVariables
     *     the 'payload' of the message. The variables are added as processes variables to the started process instance.
     * @return the {@link ProcessInstance} object representing the started process instance
     * @throws FlowableException
     *     if no subscription to a message with the given name exists
     * @since 5.9
     */
    ProcessInstance startProcessInstanceByMessage(string messageName, Map<string, Object> processVariables);

    /**
     * Similar to {@link RuntimeService#startProcessInstanceByMessage(string, Map<string, Object>)}, but with tenant context.
     */
    ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, Map<string, Object> processVariables, string tenantId);

    /**
     * <p>
     * Signals the process engine that a message is received and starts a new {@link ProcessInstance}.
     * </p>
     * <p>
     * See {@link #startProcessInstanceByMessage(string, Map)}. In addition, this method allows specifying a business key.
     *
     * @param messageName
     *     the 'name' of the message as specified as an attribute on the bpmn20 {@code <message name="messageName" />} element.
     * @param businessKey
     *     the business key which is added to the started process instance
     * @param processVariables
     *     the 'payload' of the message. The variables are added as processes variables to the started process instance.
     * @return the {@link ProcessInstance} object representing the started process instance
     * @throws FlowableException
     *     if no subscription to a message with the given name exists
     * @since 5.9
     */
    ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey, Map<string, Object> processVariables);

    /**
     * Similar to {@link RuntimeService#startProcessInstanceByMessage(string, string, Map<string, Object>)}, but with tenant context.
     */
    ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, Map<string, Object> processVariables, string tenantId);

    /**
     * Gets a Form model instance of the start form of a specific process definition or process instance
     *
     * @param processDefinitionId
     *     id of process definition for which the start form should be retrieved.
     * @param processInstanceId
     *     id of process instance for which the start form should be retrieved.
     */
    FormInfo getStartFormModel(string processDefinitionId, string processInstanceId);

    /**
     * Delete an existing runtime process instance.
     *
     * @param processInstanceId
     *     id of process instance to delete, cannot be null.
     * @param deleteReason
     *     reason for deleting, can be null.
     * @throws FlowableObjectNotFoundException
     *     when no process instance is found with the given id.
     */
    void deleteProcessInstance(string processInstanceId, string deleteReason);

    /**
     * Finds the activity ids for all executions that are waiting in activities. This is a list because a single activity can be active multiple times.
     *
     * @param executionId
     *     id of the execution, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when no execution exists with the given executionId.
     */
    List<string> getActiveActivityIds(string executionId);

    /**
     * Sends an external trigger to an activity instance that is waiting inside the given execution.
     *
     * @param executionId
     *     id of execution to signal, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void trigger(string executionId);

    /**
     * Sends an external trigger to an activity instance that is waiting inside the given execution.
     * The waiting execution is notified <strong>asynchronously</strong>.
     *
     * @param executionId
     *     id of execution to signal, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void triggerAsync(string executionId);

    /**
     * Sends an external trigger to an activity instance that is waiting inside the given execution.
     *
     * @param executionId
     *     id of execution to signal, cannot be null.
     * @param processVariables
     *     a map of process variables
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void trigger(string executionId, Map<string, Object> processVariables);

    /**
     * Sends an external trigger to an activity instance that is waiting inside the given execution.
     * The waiting execution is notified <strong>asynchronously</strong>.
     *
     * @param executionId
     *     id of execution to signal, cannot be null.
     * @param processVariables
     *     a map of process variables
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void triggerAsync(string executionId, Map<string, Object> processVariables);

    /**
     * Similar to {@link #trigger(string, Map)}, but with an extra parameter that allows to pass transient variables.
     */
    void trigger(string executionId, Map<string, Object> processVariables, Map<string, Object> transientVariables);

    /**
     * Evaluate waiting conditional events (boundary, intermediate catch and event sub process start events) and trigger them if a 
     * condition evaluates to true.
     *
     * @param processInstanceId
     *            id of process instance, cannot be null.
     * @throws FlowableObjectNotFoundException
     *             when no execution is found for the given processInstanceId.
     */
    void evaluateConditionalEvents(string processInstanceId);
    
    /**
     * Evaluate waiting conditional events (boundary, intermediate catch and event sub process start events) and trigger them if a 
     * condition evaluates to true.
     *
     * @param processInstanceId
     *            id of process instance, cannot be null.
     * @param processVariables
     *            a map of process variables to be set before evaluation
     * @throws FlowableObjectNotFoundException
     *             when no execution is found for the given processInstanceId.
     */
    void evaluateConditionalEvents(string processInstanceId, Map<string, Object> processVariables);
    
    /**
     * Updates the business key for the provided process instance
     *
     * @param processInstanceId
     *     id of the process instance to set the business key, cannot be null
     * @param businessKey
     *     new businessKey value
     */
    void updateBusinessKey(string processInstanceId, string businessKey);

    // Identity Links
    // ///////////////////////////////////////////////////////////////

    /**
     * Involves a user with a process instance. The type of identity link is defined by the given identityLinkType.
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param userId
     *     id of the user involve, cannot be null.
     * @param identityLinkType
     *     type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *     when the process instance doesn't exist.
     */
    void addUserIdentityLink(string processInstanceId, string userId, string identityLinkType);

    /**
     * Involves a group with a process instance. The type of identityLink is defined by the given identityLink.
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param groupId
     *     id of the group to involve, cannot be null.
     * @param identityLinkType
     *     type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *     when the process instance or group doesn't exist.
     */
    void addGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType);

    /**
     * Convenience shorthand for {@link #addUserIdentityLink(string, string, string)}; with type {@link IdentityLinkType#PARTICIPANT}
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param userId
     *     id of the user to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when the task or user doesn't exist.
     */
    void addParticipantUser(string processInstanceId, string userId);

    /**
     * Convenience shorthand for {@link #addGroupIdentityLink(string, string, string)}; with type {@link IdentityLinkType#PARTICIPANT}
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param groupId
     *     id of the group to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when the task or group doesn't exist.
     */
    void addParticipantGroup(string processInstanceId, string groupId);

    /**
     * Convenience shorthand for {@link #deleteUserIdentityLink(string, string, string)}; with type {@link IdentityLinkType#PARTICIPANT}
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param userId
     *     id of the user to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when the task or user doesn't exist.
     */
    void deleteParticipantUser(string processInstanceId, string userId);

    /**
     * Convenience shorthand for {@link #deleteGroupIdentityLink(string, string, string)}; with type {@link IdentityLinkType#PARTICIPANT}
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param groupId
     *     id of the group to use as candidate, cannot be null.
     * @throws FlowableObjectNotFoundException
     *     when the task or group doesn't exist.
     */
    void deleteParticipantGroup(string processInstanceId, string groupId);

    /**
     * Removes the association between a user and a process instance for the given identityLinkType.
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param userId
     *     id of the user involve, cannot be null.
     * @param identityLinkType
     *     type of identityLink, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *     when the task or user doesn't exist.
     */
    void deleteUserIdentityLink(string processInstanceId, string userId, string identityLinkType);

    /**
     * Removes the association between a group and a process instance for the given identityLinkType.
     *
     * @param processInstanceId
     *     id of the process instance, cannot be null.
     * @param groupId
     *     id of the group to involve, cannot be null.
     * @param identityLinkType
     *     type of identity, cannot be null (@see {@link IdentityLinkType}).
     * @throws FlowableObjectNotFoundException
     *     when the task or group doesn't exist.
     */
    void deleteGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType);

    /**
     * Retrieves the {@link IdentityLink}s associated with the given process instance. Such an {@link IdentityLink} informs how a certain user is involved with a process instance.
     */
    List<IdentityLink> getIdentityLinksForProcessInstance(string instanceId);

    /**
     * Retrieves the {@link EntityLink}s associated with the given process instance.
     */
    List<EntityLink> getEntityLinkChildrenForProcessInstance(string instanceId);

    /**
     * Retrieves the {@link EntityLink}s associated with the given task.
     */
    List<EntityLink> getEntityLinkChildrenForTask(string taskId);

    /**
     * Retrieves the {@link EntityLink}s where the given process instance is referenced.
     */
    List<EntityLink> getEntityLinkParentsForProcessInstance(string instanceId);

    /**
     * Retrieves the {@link EntityLink}s where the given task is referenced.
     */
    List<EntityLink> getEntityLinkParentsForTask(string taskId);

    // Variables
    // ////////////////////////////////////////////////////////////////////

    /**
     * All variables visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, Object> getVariables(string executionId);

    /**
     * All variables visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the variable instances or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, VariableInstance> getVariableInstances(string executionId);

    /**
     * All variables visible from the given execution scope (including parent scopes).
     *
     * @param executionIds
     *     ids of execution, cannot be null.
     * @return the variables.
     */
    List<VariableInstance> getVariableInstancesByExecutionIds(Set<string> executionIds);

    /**
     * All variable values that are defined in the execution scope, without taking outer scopes into account. If you have many task local variables and you only need a few, consider using
     * {@link #getVariablesLocal(string, Collection)} for better performance.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, Object> getVariablesLocal(string executionId);

    /**
     * All variable values that are defined in the execution scope, without taking outer scopes into account. If you have many task local variables and you only need a few, consider using
     * {@link #getVariableInstancesLocal(string, Collection)} for better performance.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, VariableInstance> getVariableInstancesLocal(string executionId);

    /**
     * The variable values for all given variableNames, takes all variables into account which are visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableNames
     *     the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, Object> getVariables(string executionId, Collection<string> variableNames);

    /**
     * The variable values for all given variableNames, takes all variables into account which are visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableNames
     *     the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, VariableInstance> getVariableInstances(string executionId, Collection<string> variableNames);

    /**
     * The variable values for the given variableNames only taking the given execution scope into account, not looking in outer scopes.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableNames
     *     the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, Object> getVariablesLocal(string executionId, Collection<string> variableNames);

    /**
     * The variable values for the given variableNames only taking the given execution scope into account, not looking in outer scopes.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableNames
     *     the collection of variable names that should be retrieved.
     * @return the variables or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, VariableInstance> getVariableInstancesLocal(string executionId, Collection<string> variableNames);

    /**
     * The variable value. Searching for the variable is done in all scopes that are visible to the given execution (including parent scopes). Returns null when no variable value is found with the
     * given name or when the value is set to null.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableName
     *     name of variable, cannot be null.
     * @return the variable value or null if the variable is undefined or the value of the variable is null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Object getVariable(string executionId, string variableName);

    /**
     * The variable. Searching for the variable is done in all scopes that are visible to the given execution (including parent scopes). Returns null when no variable value is found with the given
     * name or when the value is set to null.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableName
     *     name of variable, cannot be null.
     * @return the variable or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    VariableInstance getVariableInstance(string executionId, string variableName);

    /**
     * The variable value. Searching for the variable is done in all scopes that are visible to the given execution (including parent scopes). Returns null when no variable value is found with the
     * given name or when the value is set to null. Throws ClassCastException when cannot cast variable to given class
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableName
     *     name of variable, cannot be null.
     * @param variableClass
     *     name of variable, cannot be null.
     * @return the variable value or null if the variable is undefined or the value of the variable is null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    <T> T getVariable(string executionId, string variableName, Class<T> variableClass);

    /**
     * Check whether or not this execution has variable set with the given name, Searching for the variable is done in all scopes that are visible to the given execution (including parent scopes).
     */
    bool hasVariable(string executionId, string variableName);

    /**
     * The variable value for an execution. Returns the value when the variable is set for the execution (and not searching parent scopes). Returns null when no variable value is found with the given
     * name or when the value is set to null.
     */
    Object getVariableLocal(string executionId, string variableName);

    /**
     * The variable for an execution. Returns the variable when it is set for the execution (and not searching parent scopes). Returns null when no variable is found with the given name or when the
     * value is set to null.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param variableName
     *     name of variable, cannot be null.
     * @return the variable or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    VariableInstance getVariableInstanceLocal(string executionId, string variableName);

    /**
     * The variable value for an execution. Returns the value casted to given class when the variable is set for the execution (and not searching parent scopes). Returns null when no variable value is
     * found with the given name or when the value is set to null.
     */
    <T> T getVariableLocal(string executionId, string variableName, Class<T> variableClass);

    /**
     * Check whether or not this execution has a local variable set with the given name.
     */
    bool hasVariableLocal(string executionId, string variableName);

    /**
     * Update or create a variable for an execution.
     *
     * <p>
     * The variable is set according to the algorithm as documented for {@link VariableScope#setVariable(string, Object)}.
     *
     * @param executionId
     *     id of execution to set variable in, cannot be null.
     * @param variableName
     *     name of variable to set, cannot be null.
     * @param value
     *     value to set. When null is passed, the variable is not removed, only it's value will be set to null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     * @see VariableScope#setVariable(string, Object) {@link VariableScope#setVariable(string, Object)}
     */
    void setVariable(string executionId, string variableName, Object value);

    /**
     * Update or create a variable for an execution (not considering parent scopes). If the variable is not already existing, it will be created in the given execution.
     *
     * @param executionId
     *     id of execution to set variable in, cannot be null.
     * @param variableName
     *     name of variable to set, cannot be null.
     * @param value
     *     value to set. When null is passed, the variable is not removed, only it's value will be set to null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void setVariableLocal(string executionId, string variableName, Object value);

    /**
     * Update or create given variables for an execution (including parent scopes).
     * <p>
     * Variables are set according to the algorithm as documented for {@link VariableScope#setVariables(Map)}, applied separately to each variable.
     *
     * @param executionId
     *     id of the execution, cannot be null.
     * @param variables
     *     map containing name (key) and value of variables, can be null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     * @see VariableScope#setVariables(Map) {@link VariableScope#setVariables(Map)}
     */
    void setVariables(string executionId, Map<string, ? extends Object> variables);

    /**
     * Update or create given variables for an execution (not considering parent scopes). If the variables are not already existing, it will be created in the given execution.
     *
     * @param executionId
     *     id of the execution, cannot be null.
     * @param variables
     *     map containing name (key) and value of variables, can be null.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    void setVariablesLocal(string executionId, Map<string, ? extends Object> variables);

    /**
     * Removes a variable for an execution.
     *
     * @param executionId
     *     id of execution to remove variable in.
     * @param variableName
     *     name of variable to remove.
     */
    void removeVariable(string executionId, string variableName);

    /**
     * Removes a variable for an execution (not considering parent scopes).
     *
     * @param executionId
     *     id of execution to remove variable in.
     * @param variableName
     *     name of variable to remove.
     */
    void removeVariableLocal(string executionId, string variableName);

    /**
     * Removes variables for an execution.
     *
     * @param executionId
     *     id of execution to remove variable in.
     * @param variableNames
     *     collection containing name of variables to remove.
     */
    void removeVariables(string executionId, Collection<string> variableNames);

    /**
     * Remove variables for an execution (not considering parent scopes).
     *
     * @param executionId
     *     id of execution to remove variable in.
     * @param variableNames
     *     collection containing name of variables to remove.
     */
    void removeVariablesLocal(string executionId, Collection<string> variableNames);

    /**
     * All DataObjects visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the DataObjects or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjects(string executionId);

    /**
     * All DataObjects visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjects(string executionId, string locale, bool withLocalizationFallback);

    /**
     * All DataObject values that are defined in the execution scope, without taking outer scopes into account. If you have many local DataObjects and you only need a few, consider using
     * {@link #getDataObjectsLocal(string, Collection)} for better performance.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @return the DataObjects or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjectsLocal(string executionId);

    /**
     * All DataObject values that are defined in the execution scope, without taking outer scopes into account. If you have many local DataObjects and you only need a few, consider using
     * {@link #getDataObjectsLocal(string, Collection)} for better performance.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no such variables are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjectsLocal(string executionId, string locale, bool withLocalizationFallback);

    /**
     * The DataObjects for all given dataObjectNames, takes all dataObjects into account which are visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectNames
     *     the collection of DataObject names that should be retrieved.
     * @return the DataObject or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjects(string executionId, Collection<string> dataObjectNames);

    /**
     * The DataObjects for all given dataObjectNames, takes all dataObjects into account which are visible from the given execution scope (including parent scopes).
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectNames
     *     the collection of DataObject names that should be retrieved.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no such dataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjects(string executionId, Collection<string> dataObjectNames, string locale, bool withLocalizationFallback);

    /**
     * The DataObjects for the given dataObjectNames only taking the given execution scope into account, not looking in outer scopes.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjects
     *     the collection of DataObject names that should be retrieved.
     * @return the DataObjects or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjectsLocal(string executionId, Collection<string> dataObjects);

    /**
     * The DataObjects for the given dataObjectNames only taking the given execution scope into account, not looking in outer scopes.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectNames
     *     the collection of DataObject names that should be retrieved.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObjects or an empty map if no DataObjects are found.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    Map<string, DataObject> getDataObjectsLocal(string executionId, Collection<string> dataObjectNames, string locale, bool withLocalizationFallback);

    /**
     * The DataObject. Searching for the DataObject is done in all scopes that are visible to the given execution (including parent scopes). Returns null when no DataObject value is found with the
     * given name or when the value is set to null.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObject
     *     name of DataObject, cannot be null.
     * @return the DataObject or null if the variable is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    DataObject getDataObject(string executionId, string dataObject);

    /**
     * The DataObject. Searching for the DataObject is done in all scopes that are visible to the given execution (including parent scopes). Returns null when no DataObject value is found with the
     * given name or when the value is set to null.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectName
     *     name of DataObject, cannot be null.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     * @return the DataObject or null if the DataObject is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    DataObject getDataObject(string executionId, string dataObjectName, string locale, bool withLocalizationFallback);

    /**
     * The DataObject for an execution. Returns the DataObject when it is set for the execution (and not searching parent scopes). Returns null when no DataObject is found with the given name.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectName
     *     name of DataObject, cannot be null.
     * @return the DataObject or null if the DataObject is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    DataObject getDataObjectLocal(string executionId, string dataObjectName);

    /**
     * The DataObject for an execution. Returns the DataObject when it is set for the execution (and not searching parent scopes). Returns null when no DataObject is found with the given name.
     *
     * @param executionId
     *     id of execution, cannot be null.
     * @param dataObjectName
     *     name of DataObject, cannot be null.
     * @param locale
     *     locale the DataObject name and description should be returned in (if available).
     * @param withLocalizationFallback
     *     When true localization will fallback to more general locales if the specified locale is not found.
     * @return the DataObject or null if the DataObject is undefined.
     * @throws FlowableObjectNotFoundException
     *     when no execution is found for the given executionId.
     */
    DataObject getDataObjectLocal(string executionId, string dataObjectName, string locale, bool withLocalizationFallback);

    // Queries ////////////////////////////////////////////////////////

    /**
     * Creates a new {@link ExecutionQuery} instance, that can be used to query the executions and process instances.
     */
    ExecutionQuery createExecutionQuery();

    /**
     * creates a new {@link NativeExecutionQuery} to query {@link Execution}s by SQL directly
     */
    NativeExecutionQuery createNativeExecutionQuery();

    /**
     * Creates a new {@link ProcessInstanceQuery} instance, that can be used to query process instances.
     */
    ProcessInstanceQuery createProcessInstanceQuery();

    /**
     * creates a new {@link NativeProcessInstanceQuery} to query {@link ProcessInstance}s by SQL directly
     */
    NativeProcessInstanceQuery createNativeProcessInstanceQuery();

    /**
     * Creates a new {@link ActivityInstanceQuery} instance, that can be used to query activities in the currently running
     * process instances.
     */
    ActivityInstanceQuery createActivityInstanceQuery();

    /**
     * creates a new {@link NativeActivityInstanceQuery} to query {@link ActivityInstance}s which are included
     * in the cuby SQL directly.
     */
    NativeActivityInstanceQuery createNativeActivityInstanceQuery();

    /**
     * Creates a new {@link EventSubscriptionQuery} instance, that can be used to query the event subscriptions.
     */
    EventSubscriptionQuery createEventSubscriptionQuery();

    // Process instance state //////////////////////////////////////////

    /**
     * Suspends the process instance with the given id.
     * <p>
     * If a process instance is in state suspended, flowable will not execute jobs (timers, messages) associated with this instance.
     * <p>
     * If you have a process instance hierarchy, suspending one process instance form the hierarchy will not suspend other process instances form that hierarchy.
     *
     * @throws FlowableObjectNotFoundException
     *     if no such processInstance can be found.
     * @throws FlowableException
     *     the process instance is already in state suspended.
     */
    void suspendProcessInstanceById(string processInstanceId);

    /**
     * Activates the process instance with the given id.
     * <p>
     * If you have a process instance hierarchy, suspending one process instance form the hierarchy will not suspend other process instances form that hierarchy.
     *
     * @throws FlowableObjectNotFoundException
     *     if no such processInstance can be found.
     * @throws FlowableException
     *     if the process instance is already in state active.
     */
    void activateProcessInstanceById(string processInstanceId);

    // Events
    // ////////////////////////////////////////////////////////////////////////

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to all executions waiting on the signal.
     * <p/>
     *
     * <strong>NOTE:</strong> The waiting executions are notified synchronously.
     *
     * @param signalName
     *     the name of the signal event
     */
    void signalEventReceived(string signalName);

    /**
     * Similar to {@link #signalEventReceived(string)}, but within the context of one tenant.
     */
    void signalEventReceivedWithTenantId(string signalName, string tenantId);

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to all executions waiting on the signal.
     * <p/>
     *
     * @param signalName
     *     the name of the signal event
     */
    void signalEventReceivedAsync(string signalName);

    /**
     * Similar to {@link #signalEventReceivedAsync(string)}, but within the context of one tenant.
     */
    void signalEventReceivedAsyncWithTenantId(string signalName, string tenantId);

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to all executions waiting on the signal.
     * <p/>
     *
     * <strong>NOTE:</strong> The waiting executions are notified synchronously.
     *
     * @param signalName
     *     the name of the signal event
     * @param processVariables
     *     a map of variables added to the execution(s)
     */
    void signalEventReceived(string signalName, Map<string, Object> processVariables);

    /**
     * Similar to {@link #signalEventReceived(string, Map<string, Object>)}, but within the context of one tenant.
     */
    void signalEventReceivedWithTenantId(string signalName, Map<string, Object> processVariables, string tenantId);

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to a single execution, being the execution referenced by 'executionId'.
     * The waiting execution is notified synchronously.
     *
     * @param signalName
     *     the name of the signal event
     * @param executionId
     *     the id of the execution to deliver the signal to
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal.
     */
    void signalEventReceived(string signalName, string executionId);

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to a single execution, being the execution referenced by 'executionId'.
     * The waiting execution is notified synchronously.
     *
     * @param signalName
     *     the name of the signal event
     * @param executionId
     *     the id of the execution to deliver the signal to
     * @param processVariables
     *     a map of variables added to the execution(s)
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal
     */
    void signalEventReceived(string signalName, string executionId, Map<string, Object> processVariables);

    /**
     * Notifies the process engine that a signal event of name 'signalName' has been received. This method delivers the signal to a single execution, being the execution referenced by 'executionId'.
     * The waiting execution is notified <strong>asynchronously</strong>.
     *
     * @param signalName
     *     the name of the signal event
     * @param executionId
     *     the id of the execution to deliver the signal to
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal.
     */
    void signalEventReceivedAsync(string signalName, string executionId);

    /**
     * Notifies the process engine that a message event with name 'messageName' has been received and has been correlated to an execution with id 'executionId'.
     * <p>
     * The waiting execution is notified synchronously.
     *
     * @param messageName
     *     the name of the message event
     * @param executionId
     *     the id of the execution to deliver the message to
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal
     */
    void messageEventReceived(string messageName, string executionId);

    /**
     * Notifies the process engine that a message event with the name 'messageName' has been received and has been correlated to an execution with id 'executionId'.
     * <p>
     * The waiting execution is notified synchronously.
     *
     * <p>
     * Variables are set for the scope of the execution of the message event subscribed to the message name. For example:
     * <p>
     * <li>The scope for an intermediate message event in the main process is that of the process instance</li>
     * <li>The scope for an intermediate message event in a subprocess is that of the subprocess</li>
     * <li>The scope for a boundary message event is that of the execution for the Activity the event is attached to</li>
     * <p>
     * Variables are set according to the algorithm as documented for {@link VariableScope#setVariables(Map)}, applied separately to each variable.
     *
     * @param messageName
     *     the name of the message event
     * @param executionId
     *     the id of the execution to deliver the message to
     * @param processVariables
     *     a map of variables added to the execution
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal
     * @see VariableScope#setVariables(Map) {@link VariableScope#setVariables(Map)}
     */
    void messageEventReceived(string messageName, string executionId, Map<string, Object> processVariables);

    /**
     * Notifies the process engine that a message event with the name 'messageName' has been received and has been correlated to an execution with id 'executionId'.
     * <p>
     * The waiting execution is notified <strong>asynchronously</strong>.
     *
     * @param messageName
     *     the name of the message event
     * @param executionId
     *     the id of the execution to deliver the message to
     * @throws FlowableObjectNotFoundException
     *     if no such execution exists.
     * @throws FlowableException
     *     if the execution has not subscribed to the signal
     */
    void messageEventReceivedAsync(string messageName, string executionId);

    /**
     * Adds an event-listener which will be notified of ALL events by the dispatcher.
     *
     * @param listenerToAdd
     *     the listener to add
     */
    void addEventListener(FlowableEventListener listenerToAdd);

    /**
     * Adds an event-listener which will only be notified when an event occurs, which type is in the given types.
     *
     * @param listenerToAdd
     *     the listener to add
     * @param types
     *     types of events the listener should be notified for
     */
    void addEventListener(FlowableEventListener listenerToAdd, FlowableEngineEventType... types);

    /**
     * Removes the given listener from this dispatcher. The listener will no longer be notified, regardless of the type(s) it was registered for in the first place.
     *
     * @param listenerToRemove
     *     listener to remove
     */
    void removeEventListener(FlowableEventListener listenerToRemove);

    /**
     * Dispatches the given event to any listeners that are registered.
     *
     * @param event
     *     event to dispatch.
     * @throws FlowableException
     *     if an exception occurs when dispatching the event or when the {@link FlowableEventDispatcher} is disabled.
     * @throws FlowableIllegalArgumentException
     *     when the given event is not suitable for dispatching.
     */
    void dispatchEvent(FlowableEvent event);
    
    void addEventRegistryConsumer(EventRegistryEventConsumer eventConsumer);
    
    void removeEventRegistryConsumer(EventRegistryEventConsumer eventConsumer);

    /**
     * Sets the name for the process instance with the given id.
     *
     * @param processInstanceId
     *     id of the process instance to update
     * @param name
     *     new name for the process instance
     * @throws FlowableObjectNotFoundException
     *     when the given process instance does not exist.
     */
    void setProcessInstanceName(string processInstanceId, string name);

    /**
     * Gets executions with an adhoc sub process as current flow element
     *
     * @param processInstanceId
     *     id of the process instance that is used to search for child executions
     * @return a list of executions
     */
    List<Execution> getAdhocSubProcessExecutions(string processInstanceId);

    /**
     * Gets enabled activities from ad-hoc sub process
     *
     * @param executionId
     *     id of the execution that has an ad-hoc sub process as current flow element
     * @return a list of enabled activities
     */
    List<FlowNode> getEnabledActivitiesFromAdhocSubProcess(string executionId);

    /**
     * Executes an activity in a ad-hoc sub process
     *
     * @param executionId
     *     id of the execution that has an ad-hoc sub process as current flow element
     * @param activityId
     *     id of the activity id to enable
     * @return the newly created execution of the enabled activity
     */
    Execution executeActivityInAdhocSubProcess(string executionId, string activityId);

    /**
     * Completes the ad-hoc sub process
     *
     * @param executionId
     *     id of the execution that has an ad-hoc sub process as current flow element
     */
    void completeAdhocSubProcess(string executionId);

    /**
     * Create a {@link ChangeActivityStateBuilder}, that allows to set various options for changing the state of a process instance.
     */
    ChangeActivityStateBuilder createChangeActivityStateBuilder();

    /**
     * Adds a new execution to a running multi-instance parent execution
     *
     * @param activityId
     *     id of the multi-instance activity (id attribute in the BPMN XML)
     * @param parentExecutionId
     *     can be the process instance id, in case there's one multi-instance execution for the provided activity id.
     *     In case of multiple multi-instance executions with the same activity id this can be a specific parent execution id.
     * @param executionVariables
     *     variables to be set on as local variable on the newly created multi-instance execution
     * @return the newly created multi-instance execution
     */
    Execution addMultiInstanceExecution(string activityId, string parentExecutionId, Map<string, Object> executionVariables);

    /**
     * Deletes a multi-instance execution
     *
     * @param executionId
     *     id of the multi-instance execution to be deleted
     * @param executionIsCompleted
     *     defines if the deleted execution should be marked as completed on the parent multi-instance execution
     */
    void deleteMultiInstanceExecution(string executionId, bool executionIsCompleted);

    /**
     * The all events related to the given Process Instance.
     */
    List<Event> getProcessInstanceEvents(string processInstanceId);

}
