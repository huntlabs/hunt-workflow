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

module flow.engine.history.HistoricProcessInstanceQuery;





import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.query.DeleteQuery;
import flow.common.api.query.Query;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.runtime.ProcessInstanceQuery;
import flow.engine.history.HistoricProcessInstance;



/**
 * Allows programmatic querying of {@link HistoricProcessInstance}s.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Falko Menge
 */
interface HistoricProcessInstanceQuery : Query!(HistoricProcessInstanceQuery, HistoricProcessInstance), DeleteQuery!(HistoricProcessInstanceQuery, HistoricProcessInstance) {

    /**
     * Only select historic process instances with the given process instance. {@link ProcessInstance) ids and {@link HistoricProcessInstance} ids match.
     */
    HistoricProcessInstanceQuery processInstanceId(string processInstanceId);

    /**
     * Only select historic process instances whose id is in the given set of ids. {@link ProcessInstance) ids and {@link HistoricProcessInstance} ids match.
     */
    HistoricProcessInstanceQuery processInstanceIds(Set!string processInstanceIds);

    /** Only select historic process instances for the given process definition */
    HistoricProcessInstanceQuery processDefinitionId(string processDefinitionId);

    /**
     * Only select historic process instances that are defined by a process definition with the given key.
     */
    HistoricProcessInstanceQuery processDefinitionKey(string processDefinitionKey);

    /**
     * Only select historic process instances that are defined by a process definition with one of the given process definition keys.
     */
    HistoricProcessInstanceQuery processDefinitionKeyIn(List!string processDefinitionKeys);

    /**
     * Only select historic process instances that don't have a process-definition of which the key is present in the given list
     */
    HistoricProcessInstanceQuery processDefinitionKeyNotIn(List!string processDefinitionKeys);

    /** Only select historic process instances whose process definition category is processDefinitionCategory. */
    HistoricProcessInstanceQuery processDefinitionCategory(string processDefinitionCategory);

    /** Select process historic instances whose process definition name is processDefinitionName */
    HistoricProcessInstanceQuery processDefinitionName(string processDefinitionName);

    /**
     * Only select historic process instances with a certain process definition version. Particularly useful when used in combination with {@link #processDefinitionKey(string)}
     */
    HistoricProcessInstanceQuery processDefinitionVersion(int processDefinitionVersion);

    /** Only select historic process instances with the given business key */
    HistoricProcessInstanceQuery processInstanceBusinessKey(string processInstanceBusinessKey);

    /**
     * Only select historic process instances with a business key like the given value.
     */
    HistoricProcessInstanceQuery processInstanceBusinessKeyLike(string businessKeyLike);

    /**
     * Only select historic process instances that are defined by a process definition with the given deployment identifier.
     */
    HistoricProcessInstanceQuery deploymentId(string deploymentId);

    /**
     * Only select historic process instances that are defined by a process definition with one of the given deployment identifiers.
     */
    HistoricProcessInstanceQuery deploymentIdIn(List!string deploymentIds);

    /** Only select historic process instances that are completely finished. */
    HistoricProcessInstanceQuery finished();

    /** Only select historic process instance that are not yet finished. */
    HistoricProcessInstanceQuery unfinished();

    /** Only select historic process instances that are deleted. */
    HistoricProcessInstanceQuery deleted();

    /** Only select historic process instance that are not deleted. */
    HistoricProcessInstanceQuery notDeleted();

    /**
     * Only select the historic process instances with which the user with the given id is involved.
     */
    HistoricProcessInstanceQuery involvedUser(string userId);

    /**
     * Only select the historic process instances with which the group with the given ids are involved.
     */
    HistoricProcessInstanceQuery involvedGroups(Set!string groups);

    /**
     * Only select process instances which had a global variable with the given value when they ended. The type only applies to already ended process instances, otherwise use a
     * {@link ProcessInstanceQuery} instead! of variable is determined based on the value, using types configured in {@link ProcessEngineConfiguration#getVariableTypes()}. Byte-arrays and
     * {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     *
     * @param name
     *            of the variable, cannot be null.
     */
    HistoricProcessInstanceQuery variableValueEquals(string name, Object value);

    /**
     * Only select process instances which had at least one global variable with the given value when they ended. The type only applies to already ended process instances, otherwise use a
     * {@link ProcessInstanceQuery} instead! of variable is determined based on the value, using types configured in {@link ProcessEngineConfiguration#getVariableTypes()}. Byte-arrays and
     * {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     */
    HistoricProcessInstanceQuery variableValueEquals(Object value);

    /**
     * Only select historic process instances which have a local string variable with the given value, case insensitive.
     *
     * @param name
     *            name of the variable, cannot be null.
     * @param value
     *            value of the variable, cannot be null.
     */
    HistoricProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value);

    /**
     * Only select process instances which had a global variable with the given name, but with a different value than the passed value when they ended. Only select process instances which have a
     * variable value greater than the passed value. Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     *
     * @param name
     *            of the variable, cannot be null.
     */
    HistoricProcessInstanceQuery variableValueNotEquals(string name, Object value);

    /**
     * Only select process instances which had a global variable value greater than the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive
     * type wrappers) are not supported. Only select process instances which have a variable value greater than the passed value.
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableValueGreaterThan(string name, Object value);

    /**
     * Only select process instances which had a global variable value greater than or equal to the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not
     * primitive type wrappers) are not supported. Only applies to already ended process instances, otherwise use a {@link ProcessInstanceQuery} instead!
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value);

    /**
     * Only select process instances which had a global variable value less than the passed value when the ended. Only applies to already ended process instances, otherwise use a
     * {@link ProcessInstanceQuery} instead! Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableValueLessThan(string name, Object value);

    /**
     * Only select process instances which has a global variable value less than or equal to the passed value when they ended. Only applies to already ended process instances, otherwise use a
     * {@link ProcessInstanceQuery} instead! Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value);

    /**
     * Only select process instances which had global variable value like the given value when they ended. Only applies to already ended process instances, otherwise use a {@link ProcessInstanceQuery}
     * instead! This can be used on string variables only.
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    HistoricProcessInstanceQuery variableValueLike(string name, string value);

    /**
     * Only select process instances which had global variable value like (case insensitive) the given value when they ended. Only applies to already ended process instances, otherwise use a
     * {@link ProcessInstanceQuery} instead! This can be used on string variables only.
     *
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    HistoricProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value);

    /**
     * Only select process instances which have a variable with the given name.
     *
     * @param name
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableExists(string name);

    /**
     * Only select process instances which does not have a variable with the given name.
     *
     * @param name
     *            cannot be null.
     */
    HistoricProcessInstanceQuery variableNotExists(string name);

    /**
     * Only select historic process instances that were started before the given date.
     */
    HistoricProcessInstanceQuery startedBefore(Date date);

    /**
     * Only select historic process instances that were started after the given date.
     */
    HistoricProcessInstanceQuery startedAfter(Date date);

    /**
     * Only select historic process instances that were finished before the given date.
     */
    HistoricProcessInstanceQuery finishedBefore(Date date);

    /**
     * Only select historic process instances that were finished after the given date.
     */
    HistoricProcessInstanceQuery finishedAfter(Date date);

    /**
     * Only select historic process instance that are started by the given user.
     */
    HistoricProcessInstanceQuery startedBy(string userId);

    /** Only select process instances that have the given tenant id. */
    HistoricProcessInstanceQuery processInstanceTenantId(string tenantId);

    /** Only select process instances with a tenant id like the given one. */
    HistoricProcessInstanceQuery processInstanceTenantIdLike(string tenantIdLike);

    /** Only select process instances that do not have a tenant id. */
    HistoricProcessInstanceQuery processInstanceWithoutTenantId();

    /**
     * Begin an OR statement. Make sure you invoke the endOr method at the end of your OR statement. Only one OR statement is allowed, for the second call to this method an exception will be thrown.
     */
    HistoricProcessInstanceQuery or();

    /**
     * End an OR statement. Only one OR statement is allowed, for the second call to this method an exception will be thrown.
     */
    HistoricProcessInstanceQuery endOr();

    /**
     * Order by the process instance id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessInstanceId();

    /**
     * Order by the process definition id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessDefinitionId();

    /**
     * Order by the business key (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessInstanceBusinessKey();

    /**
     * Order by the start time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessInstanceStartTime();

    /**
     * Order by the end time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessInstanceEndTime();

    /**
     * Order by the duration of the process instance (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByProcessInstanceDuration();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    HistoricProcessInstanceQuery orderByTenantId();

    /**
     * Only select historic process instances started by the given process instance. {@link ProcessInstance) ids and {@link HistoricProcessInstance} ids match.
     */
    HistoricProcessInstanceQuery superProcessInstanceId(string superProcessInstanceId);

    /**
     * Exclude sub processes from the query result;
     */
    HistoricProcessInstanceQuery excludeSubprocesses(bool excludeSubprocesses);

    /**
     * Include process variables in the process query result
     */
    HistoricProcessInstanceQuery includeProcessVariables();

    /**
     * Limit process instance variables
     */
    HistoricProcessInstanceQuery limitProcessInstanceVariables(int processInstanceVariablesLimit);

    /**
     * Only select process instances that failed due to an exception happening during a job execution.
     */
    HistoricProcessInstanceQuery withJobException();

    /**
     * Only select process instances with the given name.
     */
    HistoricProcessInstanceQuery processInstanceName(string name);

    /**
     * Only select process instances with a name like the given value.
     */
    HistoricProcessInstanceQuery processInstanceNameLike(string nameLike);

    /**
     * Only select process instances with a name like the given value, ignoring upper/lower case.
     */
    HistoricProcessInstanceQuery processInstanceNameLikeIgnoreCase(string nameLikeIgnoreCase);

    /**
     * Only select process instances with the given callback identifier.
     */
    HistoricProcessInstanceQuery processInstanceCallbackId(string callbackId);

    /**
     * Only select process instances with the given callback type.
     */
    HistoricProcessInstanceQuery processInstanceCallbackType(string callbackType);

    /**
     * Only select process instances with the given reference identifier.
     */
    HistoricProcessInstanceQuery processInstanceReferenceId(string referenceId);

    /**
     * Only select process instances with the given reference type.
     */
    HistoricProcessInstanceQuery processInstanceReferenceType(string referenceType);

    /**
     * Localize historic process name and description to specified locale.
     */
    HistoricProcessInstanceQuery locale(string locale);

    /**
     * Instruct localization to fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     */
    HistoricProcessInstanceQuery withLocalizationFallback();
}
