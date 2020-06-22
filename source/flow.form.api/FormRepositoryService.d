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
module flow.form.api.FormRepositoryService;

import hunt.stream.Common;
import hunt.collection.List;

import flow.form.api.FormDeploymentBuilder;
import flow.form.api.FormDefinitionQuery;
import flow.form.api.NativeFormDefinitionQuery;
import flow.form.api.FormInfo;
import flow.form.api.FormDeploymentQuery;
import flow.form.api.FormDefinition;

/**
 * Service providing access to the repository of forms.
 *
 * @author Tijs Rademakers
 */
interface FormRepositoryService {

    FormDeploymentBuilder createDeployment();

    void deleteDeployment(string deploymentId);

    FormDefinitionQuery createFormDefinitionQuery();

    NativeFormDefinitionQuery createNativeFormDefinitionQuery();

    /**
     * Changes the category of a deployment.
     *
     * @param deploymentId
     *              The id of the deployment of which the category will be changed.
     * @param category
     *              The new category.
     */
    void setDeploymentCategory(string deploymentId, string category);

    /**
     * Changes the tenant id of a deployment.
     *
     * @param deploymentId
     *              The id of the deployment of which the tenant identifier will be changed.
     * @param newTenantId
     *              The new tenant identifier.
     */
    void setDeploymentTenantId(string deploymentId, string newTenantId);

    /**
     * Changes the parent deployment id of a deployment. This is used to move deployments to a different app deployment parent.
     *
     * @param deploymentId
     *              The id of the deployment of which the parent deployment identifier will be changed.
     * @param newParentDeploymentId
     *              The new parent deployment identifier.
     */
    void changeDeploymentParentDeploymentId(string deploymentId, string newParentDeploymentId);

    List!string getDeploymentResourceNames(string deploymentId);

    InputStream getResourceAsStream(string deploymentId, string resourceName);

    FormDeploymentQuery createDeploymentQuery();

   // NativeFormDeploymentQuery createNativeDeploymentQuery();

    FormDefinition getFormDefinition(string formDefinitionId);

    FormInfo getFormModelById(string formDefinitionId);

    FormInfo getFormModelByKey(string formDefinitionKey);

    FormInfo getFormModelByKey(string formDefinitionKey, string tenantId, bool fallbackToDefaultTenant);

    FormInfo getFormModelByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId);

    FormInfo getFormModelByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId, string tenantId, bool fallbackToDefaultTenant);

    InputStream getFormDefinitionResource(string formDefinitionId);

    void setFormDefinitionCategory(string formDefinitionId, string category);
}
