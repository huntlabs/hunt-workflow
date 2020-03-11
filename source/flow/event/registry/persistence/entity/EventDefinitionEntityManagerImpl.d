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

module flow.event.registry.persistence.entity.EventDefinitionEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.EventDefinitionQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.data.EventDefinitionDataManager;
import flow.event.registry.persistence.entity.EventDefinitionEntity;
import flow.event.registry.persistence.entity.EventDefinitionEntityManager;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class EventDefinitionEntityManagerImpl
        : AbstractEngineEntityManager!(EventRegistryEngineConfiguration, EventDefinitionEntity, EventDefinitionDataManager)
        , EventDefinitionEntityManager {

    this(EventRegistryEngineConfiguration eventRegistryEngineConfiguration, EventDefinitionDataManager eventDefinitionDataManager) {
        super(eventRegistryEngineConfiguration, eventDefinitionDataManager);
    }


    public EventDefinitionEntity findLatestEventDefinitionByKey(string eventDefinitionKey) {
        return dataManager.findLatestEventDefinitionByKey(eventDefinitionKey);
    }


    public void deleteEventDefinitionsByDeploymentId(string deploymentId) {
        dataManager.deleteEventDefinitionsByDeploymentId(deploymentId);
    }


    public List!EventDefinition findEventDefinitionsByQueryCriteria(EventDefinitionQueryImpl eventQuery) {
        return dataManager.findEventDefinitionsByQueryCriteria(eventQuery);
    }


    public long findEventDefinitionCountByQueryCriteria(EventDefinitionQueryImpl eventQuery) {
        return dataManager.findEventDefinitionCountByQueryCriteria(eventQuery);
    }


    public EventDefinitionEntity findEventDefinitionByDeploymentAndKey(string deploymentId, string eventDefinitionKey) {
        return dataManager.findEventDefinitionByDeploymentAndKey(deploymentId, eventDefinitionKey);
    }


    public EventDefinitionEntity findEventDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string eventDefinitionKey, string tenantId) {
        return dataManager.findEventDefinitionByDeploymentAndKeyAndTenantId(deploymentId, eventDefinitionKey, tenantId);
    }


    public EventDefinitionEntity findLatestEventDefinitionByKeyAndTenantId(string eventDefinitionKey, string tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            return dataManager.findLatestEventDefinitionByKey(eventDefinitionKey);
        } else {
            return dataManager.findLatestEventDefinitionByKeyAndTenantId(eventDefinitionKey, tenantId);
        }
    }


    public EventDefinitionEntity findEventDefinitionByKeyAndVersionAndTenantId(string eventDefinitionKey, int eventVersion, string tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            return dataManager.findEventDefinitionByKeyAndVersion(eventDefinitionKey, eventVersion);
        } else {
            return dataManager.findEventDefinitionByKeyAndVersionAndTenantId(eventDefinitionKey, eventVersion, tenantId);
        }
    }


    public List!EventDefinition findEventDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findEventDefinitionsByNativeQuery(parameterMap);
    }


    public long findEventDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findEventDefinitionCountByNativeQuery(parameterMap);
    }


    public void updateEventDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateEventDefinitionTenantIdForDeployment(deploymentId, newTenantId);
    }

}
