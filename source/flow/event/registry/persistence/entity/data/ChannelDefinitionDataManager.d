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

import flow.common.persistence.entity.data.DataManager;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;

interface ChannelDefinitionDataManager extends DataManager<ChannelDefinitionEntity> {

    ChannelDefinitionEntity findLatestChannelDefinitionByKey(String channelDefinitionKey);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(String channelDefinitionKey, String tenantId);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndParentDeploymentId(String channelDefinitionKey, String parentDeploymentId);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyParentDeploymentIdAndTenantId(String channelDefinitionKey, String parentDeploymentId, String tenantId);

    void deleteChannelDefinitionsByDeploymentId(String deploymentId);

    List<ChannelDefinition> findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl channelDefinitionQuery);

    long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl channelDefinitionQuery);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(String deploymentId, String channelDefinitionKey);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(String deploymentId, String channelDefinitionKey, String tenantId);

    ChannelDefinitionEntity findChannelDefinitionByKeyAndVersion(String channelDefinitionKey, Integer channelVersion);

    ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(String channelDefinitionKey, Integer eventVersion, String tenantId);

    List<ChannelDefinition> findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateChannelDefinitionTenantIdForDeployment(String deploymentId, String newTenantId);

}
