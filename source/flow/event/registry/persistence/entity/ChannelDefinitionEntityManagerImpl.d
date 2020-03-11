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

module flow.event.registry.persistence.entity.ChannelDefinitionEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.data.ChannelDefinitionDataManager;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityManager;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ChannelDefinitionEntityManagerImpl
        : AbstractEngineEntityManager!(EventRegistryEngineConfiguration, ChannelDefinitionEntity, ChannelDefinitionDataManager)
        , ChannelDefinitionEntityManager {

    this(EventRegistryEngineConfiguration eventRegistryEngineConfiguration, ChannelDefinitionDataManager channelDefinitionDataManager) {
        super(eventRegistryEngineConfiguration, channelDefinitionDataManager);
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKey(string channelDefinitionKey) {
        return dataManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
    }


    public void deleteChannelDefinitionsByDeploymentId(string deploymentId) {
        dataManager.deleteChannelDefinitionsByDeploymentId(deploymentId);
    }


    public List!ChannelDefinition findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl channelQuery) {
        return dataManager.findChannelDefinitionsByQueryCriteria(channelQuery);
    }


    public long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl channelQuery) {
        return dataManager.findChannelDefinitionCountByQueryCriteria(channelQuery);
    }


    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(string deploymentId, string channelDefinitionKey) {
        return dataManager.findChannelDefinitionByDeploymentAndKey(deploymentId, channelDefinitionKey);
    }


    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string channelDefinitionKey, string tenantId) {
        return dataManager.findChannelDefinitionByDeploymentAndKeyAndTenantId(deploymentId, channelDefinitionKey, tenantId);
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(string channelDefinitionKey, string tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            return dataManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
        } else {
            return dataManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, tenantId);
        }
    }


    public ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(string channelDefinitionKey, int eventVersion, string tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            return dataManager.findChannelDefinitionByKeyAndVersion(channelDefinitionKey, eventVersion);
        } else {
            return dataManager.findChannelDefinitionByKeyAndVersionAndTenantId(channelDefinitionKey, eventVersion, tenantId);
        }
    }


    public List!ChannelDefinition findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findChannelDefinitionsByNativeQuery(parameterMap);
    }


    public long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findChannelDefinitionCountByNativeQuery(parameterMap);
    }


    public void updateChannelDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateChannelDefinitionTenantIdForDeployment(deploymentId, newTenantId);
    }

}
