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


import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

import flow.common.api.query.Query;
import flow.engine.ProcessEngineConfiguration;

/**
 * Allows programmatic querying of {@link ProcessInstance}s.
 * 
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Frederik Heremans
 * @author Falko Menge
 */
interface ProcessInstanceQuery extends Query<ProcessInstanceQuery, ProcessInstance> {

    /** Select the process instance with the given id */
    ProcessInstanceQuery processInstanceId(string processInstanceId);

    /** Select process instances whose id is in the given set of ids */
    ProcessInstanceQuery processInstanceIds(Set<string> processInstanceIds);

    /** Select process instances with the given business key */
    ProcessInstanceQuery processInstanceBusinessKey(string processInstanceBusinessKey);

    /**
     * Select process instance with the given business key, unique for the given process definition
     */
    ProcessInstanceQuery processInstanceBusinessKey(string processInstanceBusinessKey, string processDefinitionKey);

    /**
     * Select process instances with a business key like the given value.
     */
    ProcessInstanceQuery processInstanceBusinessKeyLike(string businessKeyLike);

    /**
     * Only select process instances that have the given tenant id.
     */
    ProcessInstanceQuery processInstanceTenantId(string tenantId);

    /**
     * Only select process instances with a tenant id like the given one.
     */
    ProcessInstanceQuery processInstanceTenantIdLike(string tenantIdLike);

    /**
     * Only select process instances that do not have a tenant id.
     */
    ProcessInstanceQuery processInstanceWithoutTenantId();

    /** Only select process instances whose process definition category is processDefinitionCategory. */
    ProcessInstanceQuery processDefinitionCategory(string processDefinitionCategory);

    /**
     * Select process instances whose process definition name is processDefinitionName
     */
    ProcessInstanceQuery processDefinitionName(string processDefinitionName);

    /**
     * Only select process instances with a certain process definition version. Particularly useful when used in combination with {@link #processDefinitionKey(string)}
     */
    ProcessInstanceQuery processDefinitionVersion(Integer processDefinitionVersion);

    /**
     * Select the process instances which are defined by a process definition with the given key.
     */
    ProcessInstanceQuery processDefinitionKey(string processDefinitionKey);

    /**
     * Select the process instances which are defined by process definitions with the given keys.
     */
    ProcessInstanceQuery processDefinitionKeys(Set<string> processDefinitionKeys);

    /**
     * Select the process instances which are defined by a process definition with the given id.
     */
    ProcessInstanceQuery processDefinitionId(string processDefinitionId);

    /**
     * Select the process instances which are defined by process definitions with the given ids.
     */
    ProcessInstanceQuery processDefinitionIds(Set<string> processDefinitionIds);

    /**
     * Select the process instances which are defined by a process definition with the given engine version.
     */
    ProcessInstanceQuery processDefinitionEngineVersion(string processDefinitionEngineVersion);

    /**
     * Select the process instances which are defined by a deployment with the given id.
     */
    ProcessInstanceQuery deploymentId(string deploymentId);

    /**
     * Select the process instances which are defined by one of the given deployment ids
     */
    ProcessInstanceQuery deploymentIdIn(List<string> deploymentIds);

    /**
     * Select the process instances which are a sub process instance of the given super process instance.
     */
    ProcessInstanceQuery superProcessInstanceId(string superProcessInstanceId);

    /**
     * Select the process instance that have as sub process instance the given process instance. Note that there will always be maximum only <b>one</b> such process instance that can be the result of
     * this query.
     */
    ProcessInstanceQuery subProcessInstanceId(string subProcessInstanceId);

    /**
     * Exclude sub processes from the query result;
     */
    ProcessInstanceQuery excludeSubprocesses(bool excludeSubprocesses);

    /**
     * Select the process instances with which the user with the given id is involved.
     */
    ProcessInstanceQuery involvedUser(string userId);

    /**
     * Select the process instances with which the {@link org.flowable.idm.api.Group}s with the given ids are involved.
     */
    ProcessInstanceQuery involvedGroups(Set<string> groupIds);

    /**
     * Only select process instances which have a global variable with the given value. The type of variable is determined based on the value, using types configured in
     * {@link ProcessEngineConfiguration#getVariableTypes()}. Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     * 
     * @param name
     *            name of the variable, cannot be null.
     */
    ProcessInstanceQuery variableValueEquals(string name, Object value);

    /**
     * Only select process instances which have at least one global variable with the given value. The type of variable is determined based on the value, using types configured in
     * {@link ProcessEngineConfiguration#getVariableTypes()}. Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not supported.
     */
    ProcessInstanceQuery variableValueEquals(Object value);

    /**
     * Only select process instances which have a local string variable with the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     * 
     * @param name
     *            name of the variable, cannot be null.
     * @param value
     *            value of the variable, cannot be null.
     */
    ProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value);

    /**
     * Only select process instances which have a global variable with the given name, but with a different value than the passed value. Byte-arrays and {@link Serializable} objects (which are not
     * primitive type wrappers) are not supported.
     * 
     * @param name
     *            name of the variable, cannot be null.
     */
    ProcessInstanceQuery variableValueNotEquals(string name, Object value);

    /**
     * Only select process instances which have a local string variable which is not the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     * 
     * @param name
     *            name of the variable, cannot be null.
     * @param value
     *            value of the variable, cannot be null.
     */
    ProcessInstanceQuery variableValueNotEqualsIgnoreCase(string name, string value);

    /**
     * Only select process instances which have a variable value greater than the passed value. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are not
     * supported.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null.
     */
    ProcessInstanceQuery variableValueGreaterThan(string name, Object value);

    /**
     * Only select process instances which have a global variable value greater than or equal to the passed value. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null.
     */
    ProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value);

    /**
     * Only select process instances which have a global variable value less than the passed value. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are
     * not supported.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null.
     */
    ProcessInstanceQuery variableValueLessThan(string name, Object value);

    /**
     * Only select process instances which have a global variable value less than or equal to the passed value. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null.
     */
    ProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value);

    /**
     * Only select process instances which have a global variable value like the given value. This be used on string variables only.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    ProcessInstanceQuery variableValueLike(string name, string value);

    /**
     * Only select process instances which have a global variable value like the given value (case insensitive). This be used on string variables only.
     * 
     * @param name
     *            variable name, cannot be null.
     * @param value
     *            variable value, cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    ProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value);
    
    /**
     * Only select process instances which have a variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    ProcessInstanceQuery variableExists(string name);
    
    /**
     * Only select process instances which does not have a variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    ProcessInstanceQuery variableNotExists(string name);

    /**
     * Only select process instances which are suspended, either because the process instance itself is suspended or because the corresponding process definition is suspended
     */
    ProcessInstanceQuery suspended();

    /**
     * Only select process instances which are active, which means that neither the process instance nor the corresponding process definition are suspended.
     */
    ProcessInstanceQuery active();

    /**
     * Only select process instances with the given name.
     */
    ProcessInstanceQuery processInstanceName(string name);

    /**
     * Only select process instances with a name like the given value.
     */
    ProcessInstanceQuery processInstanceNameLike(string nameLike);

    /**
     * Only select process instances with a name like the given value, ignoring upper/lower case.
     */
    ProcessInstanceQuery processInstanceNameLikeIgnoreCase(string nameLikeIgnoreCase);
    
    /**
     * Only select process instances with the given callback id. 
     */
    ProcessInstanceQuery processInstanceCallbackId(string callbackId);
    
    /**
     * Only select process instances with the given callback type.
     */
    ProcessInstanceQuery processInstanceCallbackType(string callbackType);

    /**
     * Only select process instances with the given reference id.
     */
    ProcessInstanceQuery processInstanceReferenceId(string referenceId);

    /**
     * Only select process instances with the given callback type.
     */
    ProcessInstanceQuery processInstanceReferenceType(string referenceType);

    /**
     * Localize process name and description to specified locale.
     */
    ProcessInstanceQuery locale(string locale);

    /**
     * Instruct localization to fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     */
    ProcessInstanceQuery withLocalizationFallback();

    /**
     * Include process variables in the process query result
     */
    ProcessInstanceQuery includeProcessVariables();

    /**
     * Limit process instance variables
     */
    ProcessInstanceQuery limitProcessInstanceVariables(Integer processInstanceVariablesLimit);

    /**
     * Only select process instances that failed due to an exception happening during a job execution.
     */
    ProcessInstanceQuery withJobException();

    /**
     * Begin an OR statement. Make sure you invoke the endOr method at the end of your OR statement. Only one OR statement is allowed, for the second call to this method an exception will be thrown.
     */
    ProcessInstanceQuery or();

    /**
     * End an OR statement. Only one OR statement is allowed, for the second call to this method an exception will be thrown.
     */
    ProcessInstanceQuery endOr();

    /**
     * Only select process instances started before the given time
     */
    ProcessInstanceQuery startedBefore(Date beforeTime);

    /**
     * Only select process instances started after the given time
     */
    ProcessInstanceQuery startedAfter(Date afterTime);

    /**
     * Only select process instances started by the given user id
     */
    ProcessInstanceQuery startedBy(string userId);

    // ordering
    // /////////////////////////////////////////////////////////////////

    /** Order by id (needs to be followed by {@link #asc()} or {@link #desc()}). */
    ProcessInstanceQuery orderByProcessInstanceId();

    /**
     * Order by process definition key (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessInstanceQuery orderByProcessDefinitionKey();

    /**
     * Order by process definition id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessInstanceQuery orderByProcessDefinitionId();

    /**
     * Order by start time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessInstanceQuery orderByStartTime();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessInstanceQuery orderByTenantId();
}
