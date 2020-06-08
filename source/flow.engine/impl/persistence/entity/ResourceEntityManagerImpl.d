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

module flow.engine.impl.persistence.entity.ResourceEntityManagerImpl;

import hunt.collection.List;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ResourceDataManager;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ResourceEntityManager;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ResourceEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ResourceEntity, ResourceDataManager)
    , ResourceEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, ResourceDataManager resourceDataManager) {
        super(processEngineConfiguration, resourceDataManager);
    }

    public void deleteResourcesByDeploymentId(string deploymentId) {
        dataManager.deleteResourcesByDeploymentId(deploymentId);
    }

    public ResourceEntity findResourceByDeploymentIdAndResourceName(string deploymentId, string resourceName) {
        return dataManager.findResourceByDeploymentIdAndResourceName(deploymentId, resourceName);
    }

    public List!ResourceEntity findResourcesByDeploymentId(string deploymentId) {
        return dataManager.findResourcesByDeploymentId(deploymentId);
    }

}
