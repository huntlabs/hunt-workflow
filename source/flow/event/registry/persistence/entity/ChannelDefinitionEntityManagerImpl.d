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



import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.data.ChannelDefinitionDataManager;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ChannelDefinitionEntityManagerImpl
        extends AbstractEngineEntityManager<EventRegistryEngineConfiguration, ChannelDefinitionEntity, ChannelDefinitionDataManager>
        implements ChannelDefinitionEntityManager {

    public ChannelDefinitionEntityManagerImpl(EventRegistryEngineConfiguration eventRegistryEngineConfiguration, ChannelDefinitionDataManager channelDefinitionDataManager) {
        super(eventRegistryEngineConfiguration, channelDefinitionDataManager);
    }

    @Override
    public ChannelDefinitionEntity findLatestChannelDefinitionByKey(String channelDefinitionKey) {
        return dataManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
    }

    @Override
    public void deleteChannelDefinitionsByDeploymentId(String deploymentId) {
        dataManager.deleteChannelDefinitionsByDeploymentId(deploymentId);
    }

    @Override
    public List<ChannelDefinition> findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl channelQuery) {
        return dataManager.findChannelDefinitionsByQueryCriteria(channelQuery);
    }

    @Override
    public long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl channelQuery) {
        return dataManager.findChannelDefinitionCountByQueryCriteria(channelQuery);
    }

    @Override
    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(String deploymentId, String channelDefinitionKey) {
        return dataManager.findChannelDefinitionByDeploymentAndKey(deploymentId, channelDefinitionKey);
    }

    @Override
    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(String deploymentId, String channelDefinitionKey, String tenantId) {
        return dataManager.findChannelDefinitionByDeploymentAndKeyAndTenantId(deploymentId, channelDefinitionKey, tenantId);
    }

    @Override
    public ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(String channelDefinitionKey, String tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
            return dataManager.findLatestChannelDefinitionByKey(channelDefinitionKey);
        } else {
            return dataManager.findLatestChannelDefinitionByKeyAndTenantId(channelDefinitionKey, tenantId);
        }
    }

    @Override
    public ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(String channelDefinitionKey, Integer eventVersion, String tenantId) {
        if (tenantId is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
            return dataManager.findChannelDefinitionByKeyAndVersion(channelDefinitionKey, eventVersion);
        } else {
            return dataManager.findChannelDefinitionByKeyAndVersionAndTenantId(channelDefinitionKey, eventVersion, tenantId);
        }
    }

    @Override
    public List<ChannelDefinition> findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findChannelDefinitionsByNativeQuery(parameterMap);
    }

    @Override
    public long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findChannelDefinitionCountByNativeQuery(parameterMap);
    }

    @Override
    public void updateChannelDefinitionTenantIdForDeployment(String deploymentId, String newTenantId) {
        dataManager.updateChannelDefinitionTenantIdForDeployment(deploymentId, newTenantId);
    }

}
