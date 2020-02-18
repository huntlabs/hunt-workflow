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
 
module flow.task.api.TaskInfoQuery;
 
 
 


import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.Query;
import org.flowable.identitylink.api.IdentityLink;
import org.flowable.task.api.history.HistoricTaskInstanceQuery;

/**
 * Interface containing shared methods between the {@link TaskQuery} and the {@link HistoricTaskInstanceQuery}.
 * 
 * @author Joram Barrez
 */
interface TaskInfoQuery<T extends TaskInfoQuery<?, ?>, V extends TaskInfo> extends Query<T, V> {

    /**
     * Only select tasks with the given task id (in practice, there will be maximum one of this kind)
     */
    T taskId(string taskId);

    /** Only select tasks with the given name */
    T taskName(string name);

    /**
     * Only select tasks with a name that is in the given list
     * 
     * @throws FlowableIllegalArgumentException
     *             When passed name list is empty or <code>null</code> or contains <code>null string</code>.
     */
    T taskNameIn(Collection<string> nameList);

    /**
     * Only select tasks with a name that is in the given list
     * 
     * This method, unlike the {@link #taskNameIn(Collection)} method will not take in account the upper/lower case: both the input parameters as the column value are lowercased when the query is executed.
     * 
     * @throws FlowableIllegalArgumentException
     *             When passed name list is empty or <code>null</code> or contains <code>null string</code>.
     */
    T taskNameInIgnoreCase(Collection<string> nameList);

    /**
     * Only select tasks with a name matching the parameter. The syntax is that of SQL: for example usage: nameLike(%test%)
     */
    T taskNameLike(string nameLike);

    /**
     * Only select tasks with a name matching the parameter. The syntax is that of SQL: for example usage: nameLike(%test%)
     * 
     * This method, unlike the {@link #taskNameLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when the query is
     * executed.
     */
    T taskNameLikeIgnoreCase(string nameLike);

    /** Only select tasks with the given description. */
    T taskDescription(string description);

    /**
     * Only select tasks with a description matching the parameter . The syntax is that of SQL: for example usage: descriptionLike(%test%)
     */
    T taskDescriptionLike(string descriptionLike);

    /**
     * Only select tasks with a description matching the parameter . The syntax is that of SQL: for example usage: descriptionLike(%test%)
     * 
     * This method, unlike the {@link #taskDescriptionLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when the query is
     * executed.
     */
    T taskDescriptionLikeIgnoreCase(string descriptionLike);

    /** Only select tasks with the given priority. */
    T taskPriority(Integer priority);

    /** Only select tasks with the given priority or higher. */
    T taskMinPriority(Integer minPriority);

    /** Only select tasks with the given priority or lower. */
    T taskMaxPriority(Integer maxPriority);

    /** Only select tasks which are assigned to the given user. */
    T taskAssignee(string assignee);

    /**
     * Only select tasks which were last assigned to an assignee like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     */
    T taskAssigneeLike(string assigneeLike);

    /**
     * Only select tasks which were last assigned to an assignee like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     * 
     * This method, unlike the {@link #taskAssigneeLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when the query is
     * executed.
     */
    T taskAssigneeLikeIgnoreCase(string assigneeLikeIgnoreCase);

    /**
     * Only select tasks with an assignee that is in the given list
     * 
     * @throws FlowableIllegalArgumentException
     *             When passed name list is empty or <code>null</code> or contains <code>null string</code>.
     */
    T taskAssigneeIds(Collection<string> assigneeListIds);

    /** Only select tasks for which the given user is the owner. */
    T taskOwner(string owner);

    /**
     * Only select tasks which were last assigned to an owner like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     */
    T taskOwnerLike(string ownerLike);

    /**
     * Only select tasks which were last assigned to an owner like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     * 
     * This method, unlike the {@link #taskOwnerLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when the query is
     * executed.
     */
    T taskOwnerLikeIgnoreCase(string ownerLikeIgnoreCase);

    /** Only select tasks for which the given user is a candidate. */
    T taskCandidateUser(string candidateUser);

    /**
     * Only select tasks for which there exist an {@link IdentityLink} with the given user, including tasks which have been assigned to the given user (assignee) or owned by the given user (owner).
     */
    T taskInvolvedUser(string involvedUser);

    /**
     * Only select tasks for which there exist an {@link IdentityLink} with the given Groups.
     */
    T taskInvolvedGroups(Collection<string> involvedGroup);

    /**
     * Allows to select a task using {@link #taskCandidateGroup(string)} {@link #taskCandidateGroupIn(Collection)} or {@link #taskCandidateUser(string)} but ignore the assignee value instead of querying for an empty assignee.
     */
    T ignoreAssigneeValue();

    /** Only select tasks for which users in the given group are candidates. */
    T taskCandidateGroup(string candidateGroup);

    /**
     * Only select tasks for which the 'candidateGroup' is one of the given groups.
     * 
     * @throws FlowableIllegalArgumentException
     *             When query is executed and {@link #taskCandidateGroup(string)} or {@link #taskCandidateUser(string)} has been executed on the query instance. When passed group list is empty or
     *             <code>null</code>.
     */
    T taskCandidateGroupIn(Collection<string> candidateGroups);

    /**
     * Only select tasks that have the given tenant id.
     */
    T taskTenantId(string tenantId);

    /**
     * Only select tasks with a tenant id like the given one.
     */
    T taskTenantIdLike(string tenantIdLike);

    /**
     * Only select tasks that do not have a tenant id.
     */
    T taskWithoutTenantId();

    /**
     * Only select tasks for the given process instance id.
     */
    T processInstanceId(string processInstanceId);

    /**
     * Only select tasks for the given process ids.
     */
    T processInstanceIdIn(Collection<string> processInstanceIds);

    /** Only select tasks foe the given business key */
    T processInstanceBusinessKey(string processInstanceBusinessKey);

    /**
     * Only select tasks with a business key like the given value The syntax is that of SQL: for example usage: processInstanceBusinessKeyLike("%test%").
     */
    T processInstanceBusinessKeyLike(string processInstanceBusinessKeyLike);

    /**
     * Only select tasks with a business key like the given value The syntax is that of SQL: for example usage: processInstanceBusinessKeyLike("%test%").
     * 
     * This method, unlike the {@link #processInstanceBusinessKeyLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when
     * the query is executed.
     */
    T processInstanceBusinessKeyLikeIgnoreCase(string processInstanceBusinessKeyLikeIgnoreCase);

    /**
     * Only select tasks for the given execution.
     */
    T executionId(string executionId);
    
    /**
     * Only select tasks for the given case instance.
     */
    T caseInstanceId(string caseInstanceId);
    
    /**
     * Only select tasks for the given case definition.
     */
    T caseDefinitionId(string caseDefinitionId);
    
    /**
     * Only select tasks for the given plan item instance. 
     */
    T planItemInstanceId(string planItemInstanceId);
    
    /**
     * Only select tasks for the given scope identifier. 
     */
    T scopeId(string scopeId);
    
    /**
     * Only select tasks for the given sub scope identifier. 
     */
    T subScopeId(string subScopeId);
    
    /**
     * Only select tasks for the given scope type. 
     */
    T scopeType(string scopeType);
    
    /**
     * Only select tasks for the given scope definition identifier. 
     */
    T scopeDefinitionId(string scopeDefinitionId);

    /**
     * Only select tasks for the given stage, defined through its stage instance id.
     */
    T propagatedStageInstanceId(string propagatedStageInstanceId);
    
    /**
     * Select all tasks for the given process instance id and its children.
     */
    T processInstanceIdWithChildren(string processInstanceId);
    
    /**
     * Select all tasks for the given case instance id and its children.
     */
    T caseInstanceIdWithChildren(string caseInstanceId);

    /**
     * Only select tasks that are created on the given date.
     */
    T taskCreatedOn(Date createTime);

    /**
     * Only select tasks that are created before the given date.
     */
    T taskCreatedBefore(Date before);

    /**
     * Only select tasks that are created after the given date.
     */
    T taskCreatedAfter(Date after);

    /**
     * Only select tasks with the given category.
     */
    T taskCategory(string category);
    
    /**
     * Only select tasks with form key.
     */
    T taskWithFormKey();

    /**
     * Only select tasks with the given formKey.
     */
    T taskFormKey(string formKey);

    /**
     * Only select tasks with the given taskDefinitionKey. The task definition key is the id of the userTask: &lt;userTask id="xxx" .../&gt;
     **/
    T taskDefinitionKey(string key);

    /**
     * Only select tasks with a taskDefinitionKey that match the given parameter. The syntax is that of SQL: for example usage: taskDefinitionKeyLike("%test%"). The task definition key is the id of
     * the userTask: &lt;userTask id="xxx" .../&gt;
     **/
    T taskDefinitionKeyLike(string keyLike);

    /**
     * Only select tasks with the given taskDefinitionKeys. The task definition key is the id of the userTask: &lt;userTask id="xxx" .../&gt;
     **/
    T taskDefinitionKeys(Collection<string> keys);

    /**
     * Only select tasks with the given due date.
     */
    T taskDueDate(Date dueDate);

    /**
     * Only select tasks which have a due date before the given date.
     */
    T taskDueBefore(Date dueDate);

    /**
     * Only select tasks which have a due date after the given date.
     */
    T taskDueAfter(Date dueDate);

    /**
     * Only select tasks with no due date.
     */
    T withoutTaskDueDate();

    /**
     * Only select tasks which are part of a process instance which has the given process definition key.
     */
    T processDefinitionKey(string processDefinitionKey);

    /**
     * Only select tasks which are part of a process instance which has a process definition key like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     */
    T processDefinitionKeyLike(string processDefinitionKeyLike);

    /**
     * Only select tasks which are part of a process instance which has a process definition key like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     * 
     * This method, unlike the {@link #processDefinitionKeyLike(string)} method will not take in account the upper/lower case: both the input parameter as the column value are lowercased when the
     * query is executed.
     */
    T processDefinitionKeyLikeIgnoreCase(string processDefinitionKeyLikeIgnoreCase);

    /** Only select tasks that have a process definition for which the key is present in the given list **/
    T processDefinitionKeyIn(Collection<string> processDefinitionKeys);

    /**
     * Only select tasks which created from the given task definition referenced by id.
     */
    T taskDefinitionId(string taskDefinitionId);

    /**
     * Only select tasks which are part of a process instance which has the given process definition id.
     */
    T processDefinitionId(string processDefinitionId);

    /**
     * Only select tasks which are part of a process instance which has the given process definition name.
     */
    T processDefinitionName(string processDefinitionName);

    /**
     * Only select tasks which are part of a process instance which has a process definition name like the given value. The syntax that should be used is the same as in SQL, eg. %test%.
     */
    T processDefinitionNameLike(string processDefinitionNameLike);

    /**
     * Only select tasks which are part of a process instance whose definition belongs to the category which is present in the given list.
     * 
     * @throws FlowableIllegalArgumentException
     *             When passed category list is empty or <code>null</code> or contains <code>null string</code>.
     * @param processCategoryInList
     */
    T processCategoryIn(Collection<string> processCategoryInList);

    /**
     * Only select tasks which are part of a process instance whose definition does not belong to the category which is present in the given list.
     * 
     * @throws FlowableIllegalArgumentException
     *             When passed category list is empty or <code>null</code> or contains <code>null string</code>.
     * @param processCategoryNotInList
     */
    T processCategoryNotIn(Collection<string> processCategoryNotInList);

    /**
     * Only select tasks which are part of a process instance which has the given deployment id.
     */
    T deploymentId(string deploymentId);

    /**
     * Only select tasks which are part of a process instance which has the given deployment id.
     */
    T deploymentIdIn(Collection<string> deploymentIds);
    
    /**
     * Only select tasks which are related to a case instance for to the given deployment id.
     */
    T cmmnDeploymentId(string cmmnDeploymentId);
    
    /**
     * Only select tasks which are related to a case instances for the given deployment id.
     */
    T cmmnDeploymentIdIn(Collection<string> cmmnDeploymentIds);

    /**
     * Only select tasks which have a local task variable with the given name set to the given value.
     */
    T taskVariableValueEquals(string variableName, Object variableValue);

    /**
     * Only select tasks which have at least one local task variable with the given value.
     */
    T taskVariableValueEquals(Object variableValue);

    /**
     * Only select tasks which have a local string variable with the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     */
    T taskVariableValueEqualsIgnoreCase(string name, string value);

    /**
     * Only select tasks which have a local task variable with the given name, but with a different value than the passed value. Byte-arrays and {@link Serializable} objects (which are not primitive
     * type wrappers) are not supported.
     */
    T taskVariableValueNotEquals(string variableName, Object variableValue);

    /**
     * Only select tasks which have a local string variable with is not the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     */
    T taskVariableValueNotEqualsIgnoreCase(string name, string value);

    /**
     * Only select tasks which have a local variable value greater than the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers)
     * are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T taskVariableValueGreaterThan(string name, Object value);

    /**
     * Only select tasks which have a local variable value greater than or equal to the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive
     * type wrappers) are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T taskVariableValueGreaterThanOrEqual(string name, Object value);

    /**
     * Only select tasks which have a local variable value less than the passed value when the ended.Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are
     * not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T taskVariableValueLessThan(string name, Object value);

    /**
     * Only select tasks which have a local variable value less than or equal to the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T taskVariableValueLessThanOrEqual(string name, Object value);

    /**
     * Only select tasks which have a local variable value like the given value when they ended. This can be used on string variables only.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    T taskVariableValueLike(string name, string value);

    /**
     * Only select tasks which have a local variable value like the given value (case insensitive) when they ended. This can be used on string variables only.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    T taskVariableValueLikeIgnoreCase(string name, string value);
    
    /**
     * Only select tasks which have a local variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    T taskVariableExists(string name);
    
    /**
     * Only select tasks which does not have a local variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    T taskVariableNotExists(string name);

    /**
     * Only select tasks which are part of a process that has a variable with the given name set to the given value.
     */
    T processVariableValueEquals(string variableName, Object variableValue);

    /**
     * Only select tasks which are part of a process that has at least one variable with the given value.
     */
    T processVariableValueEquals(Object variableValue);

    /**
     * Only select tasks which are part of a process that has a local string variable which is not the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     */
    T processVariableValueEqualsIgnoreCase(string name, string value);

    /**
     * Only select tasks which have a variable with the given name, but with a different value than the passed value. Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     */
    T processVariableValueNotEquals(string variableName, Object variableValue);

    /**
     * Only select tasks which are part of a process that has a string variable with the given value, case insensitive.
     * <p>
     * This method only works if your database has encoding/collation that supports case-sensitive queries. For example, use "collate UTF-8" on MySQL and for MSSQL, select one of the case-sensitive
     * Collations available (<a href="http://msdn.microsoft.com/en-us/library/ms144250(v=sql.105).aspx" >MSDN Server Collation Reference</a>).
     * </p>
     */
    T processVariableValueNotEqualsIgnoreCase(string name, string value);

    /**
     * Only select tasks which have a global variable value greater than the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T processVariableValueGreaterThan(string name, Object value);

    /**
     * Only select tasks which have a global variable value greater than or equal to the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive
     * type wrappers) are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T processVariableValueGreaterThanOrEqual(string name, Object value);

    /**
     * Only select tasks which have a global variable value less than the passed value when the ended.Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type wrappers) are
     * not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T processVariableValueLessThan(string name, Object value);

    /**
     * Only select tasks which have a global variable value less than or equal to the passed value when they ended. Booleans, Byte-arrays and {@link Serializable} objects (which are not primitive type
     * wrappers) are not supported.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null.
     */
    T processVariableValueLessThanOrEqual(string name, Object value);

    /**
     * Only select tasks which have a global variable value like the given value when they ended. This can be used on string variables only.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    T processVariableValueLike(string name, string value);

    /**
     * Only select tasks which have a global variable value like the given value (case insensitive) when they ended. This can be used on string variables only.
     * 
     * @param name
     *            cannot be null.
     * @param value
     *            cannot be null. The string can include the wildcard character '%' to express like-strategy: starts with (string%), ends with (%string) or contains (%string%).
     */
    T processVariableValueLikeIgnoreCase(string name, string value);
    
    /**
     * Only select tasks which have a global variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    T processVariableExists(string name);
    
    /**
     * Only select tasks which does not have a global variable with the given name.
     * 
     * @param name
     *            cannot be null.
     */
    T processVariableNotExists(string name);

    /**
     * Include local task variables in the task query result
     */
    T includeTaskLocalVariables();

    /**
     * Include global task variables in the task query result
     */
    T includeProcessVariables();

    /**
     * Limit task variables
     */
    T limitTaskVariables(Integer taskVariablesLimit);

    /**
     * Include identity links in the task query result
     */
    T includeIdentityLinks();

    /**
     * Localize task name and description to specified locale.
     */
    T locale(string locale);

    /**
     * Instruct localization to fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     */
    T withLocalizationFallback();

    /**
     * All query clauses called will be added to a single or-statement. This or-statement will be included with the other already existing clauses in the query, joined by an 'and'.
     * 
     * Calling endOr() will add all clauses to the regular query again. Calling or() after or() has been called or calling endOr() after endOr() has been called will result in an exception.
     * It is possible to call or() endOr() several times if each or() has a matching endOr(), e.g.:
     * query.<ConditionA>
     *  .or().<conditionB>.<conditionC>.endOr()
     *  .<conditionD>.<conditionE>
     *  .or().<conditionF>.<conditionG>.endOr()
     * will result in: conditionA & (conditionB | conditionC) & conditionD & conditionE & (conditionF | conditionG)
     */
    T or();

    T endOr();

    // ORDERING

    /**
     * Order by task id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskId();

    /**
     * Order by task name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskName();

    /**
     * Order by description (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskDescription();

    /**
     * Order by priority (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskPriority();

    /**
     * Order by assignee (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskAssignee();

    /**
     * Order by the time on which the tasks were created (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskCreateTime();

    /**
     * Order by process instance id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByProcessInstanceId();

    /**
     * Order by execution id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByExecutionId();

    /**
     * Order by process definition id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByProcessDefinitionId();

    /**
     * Order by task due date (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskDueDate();

    /**
     * Order by task owner (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskOwner();

    /**
     * Order by task definition key (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTaskDefinitionKey();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    T orderByTenantId();

    /**
     * Order by due date (needs to be followed by {@link #asc()} or {@link #desc()}). If any of the tasks have null for the due date, these will be first in the result.
     */
    T orderByDueDateNullsFirst();

    /**
     * Order by due date (needs to be followed by {@link #asc()} or {@link #desc()}). If any of the tasks have null for the due date, these will be last in the result.
     */
    T orderByDueDateNullsLast();

}
