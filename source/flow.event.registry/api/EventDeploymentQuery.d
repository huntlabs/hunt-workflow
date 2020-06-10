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

module flow.event.registry.api.EventDeploymentQuery;

import flow.common.api.query.Query;
import flow.event.registry.api.EventDeployment;
import hunt.string;
/**
 * Allows programmatic querying of {@link EventDeployment}s.
 *
 * Note that it is impossible to retrieve the deployment resources through the results of this operation, since that would cause a huge transfer of (possibly) unneeded bytes over the wire.
 *
 * To retrieve the actual bytes of a deployment resource use the operations on the {@link EventRepositoryService#getDeploymentResourceNames(string)} and
 * {@link RepositoryService#getResourceAsStream(string, string)}
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface EventDeploymentQuery : Query!(EventDeploymentQuery, EventDeployment) {

    /**
     * Only select deployments with the given deployment id.
     */
    EventDeploymentQuery deploymentId(string deploymentId);

    /**
     * Only select deployments with the given name.
     */
    EventDeploymentQuery deploymentName(string name);

    /**
     * Only select deployments with a name like the given string.
     */
    EventDeploymentQuery deploymentNameLike(string nameLike);

    /**
     * Only select deployments with the given category.
     *
     * @see DeploymentBuilder#category(string)
     */
    EventDeploymentQuery deploymentCategory(string category);

    /**
     * Only select deployments that have a different category then the given one.
     *
     * @see DeploymentBuilder#category(string)
     */
    EventDeploymentQuery deploymentCategoryNotEquals(string categoryNotEquals);

    /**
     * Only select deployment that have the given tenant id.
     */
    EventDeploymentQuery deploymentTenantId(string tenantId);

    /**
     * Only select deployments with a tenant id like the given one.
     */
    EventDeploymentQuery deploymentTenantIdLike(string tenantIdLike);

    /**
     * Only select deployments that do not have a tenant id.
     */
    EventDeploymentQuery deploymentWithoutTenantId();

    /** Only select deployments with the given event definition key. */
    EventDeploymentQuery eventDefinitionKey(string key);

    /**
     * Only select deployments with an event definition key like the given string.
     */
    EventDeploymentQuery eventDefinitionKeyLike(string keyLike);

    /** Only select deployments with the given channel definition key. */
    EventDeploymentQuery channelDefinitionKey(string key);

    /**
     * Only select deployments with a channel definition key like the given string.
     */
    EventDeploymentQuery channelDefinitionKeyLike(string keyLike);

    /**
     * Only select deployment that have the given deployment parent id.
     */
    EventDeploymentQuery parentDeploymentId(string deploymentParentId);

    /**
     * Only select deployments with a deployment parent id like the given one.
     */
    EventDeploymentQuery parentDeploymentIdLike(string deploymentParentIdLike);

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by deployment id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventDeploymentQuery orderByDeploymentId();

    /**
     * Order by deployment name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventDeploymentQuery orderByDeploymentName();

    /**
     * Order by deployment time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventDeploymentQuery orderByDeploymentTime();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    EventDeploymentQuery orderByTenantId();
}
