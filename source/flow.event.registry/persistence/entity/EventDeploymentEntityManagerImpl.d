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

module flow.event.registry.persistence.entity.EventDeploymentEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.EventDeploymentQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.data.EventDeploymentDataManager;
import flow.event.registry.persistence.entity.EventDeploymentEntity;
import flow.event.registry.persistence.entity.EventDeploymentEntityManager;
import flow.event.registry.persistence.entity.EventResourceEntityManager;
import flow.event.registry.persistence.entity.EventDefinitionEntityManager;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityManager;
import flow.event.registry.persistence.entity.EventResourceEntity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class EventDeploymentEntityManagerImpl
        : AbstractEngineEntityManager!(EventRegistryEngineConfiguration, EventDeploymentEntity, EventDeploymentDataManager)
        , EventDeploymentEntityManager {

    this(EventRegistryEngineConfiguration eventRegistryConfiguration, EventDeploymentDataManager deploymentDataManager) {
        super(eventRegistryConfiguration, deploymentDataManager);
    }

    override
    public void insert(EventDeploymentEntity deployment) {
        insert(deployment, true);
    }

    override
    public void insert(EventDeploymentEntity deployment, bool fireEvent) {
        super.insert(deployment, fireEvent);

        foreach (EventResourceEntity resource ; deployment.getResources().values()) {
            resource.setDeploymentId(deployment.getId());
            getResourceEntityManager().insert(resource);
        }
    }


    public void deleteDeployment(string deploymentId) {
        deleteEventDefinitionsForDeployment(deploymentId);
        deleteChannelDefinitionsForDeployment(deploymentId);
        getResourceEntityManager().deleteResourcesByDeploymentId(deploymentId);
        dele(findById(deploymentId));
    }

    protected void deleteEventDefinitionsForDeployment(string deploymentId) {
        getEventDefinitionEntityManager().deleteEventDefinitionsByDeploymentId(deploymentId);
    }

    protected void deleteChannelDefinitionsForDeployment(string deploymentId) {
        getChannelDefinitionEntityManager().deleteChannelDefinitionsByDeploymentId(deploymentId);
    }


    public long findDeploymentCountByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentCountByQueryCriteria(deploymentQuery);
    }


    public List!EventDeployment findDeploymentsByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
        return dataManager.findDeploymentsByQueryCriteria(deploymentQuery);
    }


    public List!string getDeploymentResourceNames(string deploymentId) {
        return dataManager.getDeploymentResourceNames(deploymentId);
    }


    public List!EventDeployment findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findDeploymentsByNativeQuery(parameterMap);
    }


    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findDeploymentCountByNativeQuery(parameterMap);
    }

    protected EventResourceEntityManager getResourceEntityManager() {
        return engineConfiguration.getResourceEntityManager();
    }

    protected EventDefinitionEntityManager getEventDefinitionEntityManager() {
        return engineConfiguration.getEventDefinitionEntityManager();
    }

    protected ChannelDefinitionEntityManager getChannelDefinitionEntityManager() {
        return engineConfiguration.getChannelDefinitionEntityManager();
    }
}
