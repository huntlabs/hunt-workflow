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

module flow.event.registry.persistence.entity.EventResourceEntityManagerImpl;

import hunt.collection.List;

import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.data.EventResourceDataManager;
import flow.event.registry.persistence.entity.EventResourceEntity;
import flow.event.registry.persistence.entity.EventResourceEntityManager;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class EventResourceEntityManagerImpl
        : AbstractEngineEntityManager!(EventRegistryEngineConfiguration, EventResourceEntity, EventResourceDataManager)
        , EventResourceEntityManager {

    this(EventRegistryEngineConfiguration eventRegistryConfiguration, EventResourceDataManager resourceDataManager) {
        super(eventRegistryConfiguration, resourceDataManager);
    }


    public void deleteResourcesByDeploymentId(string deploymentId) {
        dataManager.deleteResourcesByDeploymentId(deploymentId);
    }


    public EventResourceEntity findResourceByDeploymentIdAndResourceName(string deploymentId, string resourceName) {
        return dataManager.findResourceByDeploymentIdAndResourceName(deploymentId, resourceName);
    }


    public List!EventResourceEntity findResourcesByDeploymentId(string deploymentId) {
        return dataManager.findResourcesByDeploymentId(deploymentId);
    }

}
