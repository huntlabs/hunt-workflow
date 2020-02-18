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
 
module flow.engine.repository.ProcessDefinitionQuery;
 
 
 


import hunt.collection;
import hunt.collection.Set;
import hunt.Integer;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.Query;
import flow.engine.repository.ProcessDefinition;
/**
 * Allows programmatic querying of {@link ProcessDefinition}s.
 * 
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Daniel Meyer
 * @author Saeid Mirzaei
 */
interface ProcessDefinitionQuery : Query!(ProcessDefinitionQuery, ProcessDefinition) {

    /** Only select process definition with the given id. */
    ProcessDefinitionQuery processDefinitionId(string processDefinitionId);

    /** Only select process definitions with the given ids. */
    ProcessDefinitionQuery processDefinitionIds(Set!string processDefinitionIds);

    /** Only select process definitions with the given category. */
    ProcessDefinitionQuery processDefinitionCategory(string processDefinitionCategory);

    /**
     * Only select process definitions where the category matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ProcessDefinitionQuery processDefinitionCategoryLike(string processDefinitionCategoryLike);

    /**
     * Only select deployments that have a different category then the given one.
     * 
     * @see DeploymentBuilder#category(string)
     */
    ProcessDefinitionQuery processDefinitionCategoryNotEquals(string categoryNotEquals);

    /** Only select process definitions with the given name. */
    ProcessDefinitionQuery processDefinitionName(string processDefinitionName);

    /**
     * Only select process definitions where the name matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ProcessDefinitionQuery processDefinitionNameLike(string processDefinitionNameLike);

    /**
     * Only select process definitions that are deployed in a deployment with the given deployment id
     */
    ProcessDefinitionQuery deploymentId(string deploymentId);

    /**
     * Select process definitions that are deployed in deployments with the given set of ids
     */
    ProcessDefinitionQuery deploymentIds(Set!string deploymentIds);

    /**
     * Only select process definition with the given key.
     */
    ProcessDefinitionQuery processDefinitionKey(string processDefinitionKey);

    /**
     * Only select process definitions where the key matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ProcessDefinitionQuery processDefinitionKeyLike(string processDefinitionKeyLike);

    /**
     * Only select process definition with a certain version. Particularly useful when used in combination with {@link #processDefinitionKey(string)}
     */
    ProcessDefinitionQuery processDefinitionVersion(Integer processDefinitionVersion);

    /**
     * Only select process definitions which version are greater than a certain version.
     */
    ProcessDefinitionQuery processDefinitionVersionGreaterThan(Integer processDefinitionVersion);

    /**
     * Only select process definitions which version are greater than or equals a certain version.
     */
    ProcessDefinitionQuery processDefinitionVersionGreaterThanOrEquals(Integer processDefinitionVersion);

    /**
     * Only select process definitions which version are lower than a certain version.
     */
    ProcessDefinitionQuery processDefinitionVersionLowerThan(Integer processDefinitionVersion);

    /**
     * Only select process definitions which version are lower than or equals a certain version.
     */
    ProcessDefinitionQuery processDefinitionVersionLowerThanOrEquals(Integer processDefinitionVersion);

    /**
     * Only select the process definitions which are the latest deployed (ie. which have the highest version number for the given key).
     * 
     * Can also be used without any other criteria (ie. query.latest().list()), which will then give all the latest versions of all the deployed process definitions.
     * 
     * @throws FlowableIllegalArgumentException
     *             if used in combination with {@link #groupId(string)}, {@link #processDefinitionVersion(int)} or {@link #deploymentId(string)}
     */
    ProcessDefinitionQuery latestVersion();

    /** Only select process definition with the given resource name. */
    ProcessDefinitionQuery processDefinitionResourceName(string resourceName);

    /** Only select process definition with a resource name like the given . */
    ProcessDefinitionQuery processDefinitionResourceNameLike(string resourceNameLike);

    /**
     * Only selects process definitions which given userId is authorized to start
     */
    ProcessDefinitionQuery startableByUser(string userId);

    /**
     * Only selects process definition which the given userId or groups are authorized to start.
     */
    ProcessDefinitionQuery startableByUserOrGroups(string userId, Collection!string groups);

    /**
     * Only selects process definitions which are suspended
     */
    ProcessDefinitionQuery suspended();

    /**
     * Only selects process definitions which are active
     */
    ProcessDefinitionQuery active();

    /**
     * Only select process definitions that have the given tenant id.
     */
    ProcessDefinitionQuery processDefinitionTenantId(string tenantId);

    /**
     * Only select process definitions with a tenant id like the given one.
     */
    ProcessDefinitionQuery processDefinitionTenantIdLike(string tenantIdLike);

    /**
     * Only select process definitions that do not have a tenant id.
     */
    ProcessDefinitionQuery processDefinitionWithoutTenantId();

    /**
     * Only select process definitions that have the given engine version.
     */
    ProcessDefinitionQuery processDefinitionEngineVersion(string engineVersion);

    // Support for event subscriptions /////////////////////////////////////

    /**
     * Selects the single process definition which has a start message event with the messageName.
     */
    ProcessDefinitionQuery messageEventSubscriptionName(string messageName);

    /**
     * Localize process definition name and description to specified locale.
     */
    ProcessDefinitionQuery locale(string locale);

    /**
     * Instruct localization to fallback to more general locales including the default locale of the JVM if the specified locale is not found.
     */
    ProcessDefinitionQuery withLocalizationFallback();

    // ordering ////////////////////////////////////////////////////////////

    /**
     * Order by the category of the process definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByProcessDefinitionCategory();

    /**
     * Order by process definition key (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByProcessDefinitionKey();

    /**
     * Order by the id of the process definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByProcessDefinitionId();

    /**
     * Order by the version of the process definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByProcessDefinitionVersion();

    /**
     * Order by the name of the process definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByProcessDefinitionName();

    /**
     * Order by deployment id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByDeploymentId();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ProcessDefinitionQuery orderByTenantId();

}
