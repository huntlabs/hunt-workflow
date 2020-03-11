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


module flow.form.api.FormDeploymentQuery;

import flow.common.api.query.Query;
import flow.form.api.FormDeployment;
/**
 * Allows programmatic querying of {@link FormDeployment}s.
 *
 * Note that it is impossible to retrieve the deployment resources through the results of this operation, since that would cause a huge transfer of (possibly) unneeded bytes over the wire.
 *
 * To retrieve the actual bytes of a deployment resource use the operations on the {@link RepositoryService#getDeploymentResourceNames(string)} and
 * {@link RepositoryService#getResourceAsStream(string, string)}
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface FormDeploymentQuery : Query!(FormDeploymentQuery, FormDeployment) {

    /**
     * Only select deployments with the given deployment id.
     */
    FormDeploymentQuery deploymentId(string deploymentId);

    /**
     * Only select deployments with the given name.
     */
    FormDeploymentQuery deploymentName(string name);

    /**
     * Only select deployments with a name like the given string.
     */
    FormDeploymentQuery deploymentNameLike(string nameLike);

    /**
     * Only select deployments with the given category.
     *
     * @see DeploymentBuilder#category(string)
     */
    FormDeploymentQuery deploymentCategory(string category);

    /**
     * Only select deployments that have a different category then the given one.
     *
     * @see DeploymentBuilder#category(string)
     */
    FormDeploymentQuery deploymentCategoryNotEquals(string categoryNotEquals);

    /**
     * Only select deployment that have the given tenant id.
     */
    FormDeploymentQuery deploymentTenantId(string tenantId);

    /**
     * Only select deployments with a tenant id like the given one.
     */
    FormDeploymentQuery deploymentTenantIdLike(string tenantIdLike);

    /**
     * Only select deployments that do not have a tenant id.
     */
    FormDeploymentQuery deploymentWithoutTenantId();

    /** Only select deployments with the given form definition key. */
    FormDeploymentQuery formDefinitionKey(string key);

    /**
     * Only select deployments with a form definition key like the given string.
     */
    FormDeploymentQuery formDefinitionKeyLike(string keyLike);

    /**
     * Only select deployment that have the given deployment parent id.
     */
    FormDeploymentQuery parentDeploymentId(string deploymentParentId);

    /**
     * Only select deployments with a deployment parent id like the given one.
     */
    FormDeploymentQuery parentDeploymentIdLike(string deploymentParentIdLike);

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by deployment id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormDeploymentQuery orderByDeploymentId();

    /**
     * Order by deployment name (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormDeploymentQuery orderByDeploymentName();

    /**
     * Order by deployment time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormDeploymentQuery orderByDeploymentTime();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    FormDeploymentQuery orderByTenantId();
}
