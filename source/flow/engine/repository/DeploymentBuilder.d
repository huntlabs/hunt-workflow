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

module flow.engine.repository.DeploymentBuilder;




import hunt.stream.Common;
import flow.engine.repository.Deployment;
import hunt.time.LocalDateTime;

alias Date = LocalDateTime;
//import flow.bpmn.model.BpmnModel;

/**
 * Builder for creating new deployments.
 *
 * A builder instance can be obtained through {@link flow.engine.RepositoryService#createDeployment()}.
 *
 * Multiple resources can be added to one deployment before calling the {@link #deploy()} operation.
 *
 * After deploying, no more changes can be made to the returned deployment and the builder instance can be disposed.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface DeploymentBuilder {

    DeploymentBuilder addInputStream(string resourceName, string inputStream);

    DeploymentBuilder addClasspathResource(string resource);

    DeploymentBuilder addString(string resourceName, string text);

    DeploymentBuilder addBytes(string resourceName, byte[] bytes);

    //DeploymentBuilder addZipInputStream(ZipInputStream zipInputStream);

   // DeploymentBuilder addBpmnModel(string resourceName, BpmnModel bpmnModel);

    /**
     * If called, no XML schema validation against the BPMN 2.0 XSD.
     *
     * Not recommended in general.
     */
    DeploymentBuilder disableSchemaValidation();

    /**
     * If called, no validation that the process definition is executable on the engine will be done against the process definition.
     *
     * Not recommended in general.
     */
    DeploymentBuilder disableBpmnValidation();

    /**
     * Gives the deployment the given name.
     */
    DeploymentBuilder name(string name);

    /**
     * Gives the deployment the given category.
     */
    DeploymentBuilder category(string category);

    /**
     * Gives the deployment the given key.
     */
    DeploymentBuilder key(string key);

    /**
     * Gives the deployment the given parent deployment id.
     */
    DeploymentBuilder parentDeploymentId(string parentDeploymentId);

    /**
     * Gives the deployment the given tenant id.
     */
    DeploymentBuilder tenantId(string tenantId);

    /**
     * If set, this deployment will be compared to any previous deployment. This means that every (non-generated) resource will be compared with the provided resources of this deployment.
     */
    DeploymentBuilder enableDuplicateFiltering();

    /**
     * Sets the date on which the process definitions contained in this deployment will be activated. This means that all process definitions will be deployed as usual, but they will be suspended from
     * the start until the given activation date.
     */
    DeploymentBuilder activateProcessDefinitionsOn(Date date);

    /**
     * Allows to add a property to this {@link DeploymentBuilder} that influences the deployment.
     */
    DeploymentBuilder deploymentProperty(string propertyKey, Object propertyValue);

    /**
     * Deploys all provided sources to the process engine.
     */
    Deployment deploy();

}
