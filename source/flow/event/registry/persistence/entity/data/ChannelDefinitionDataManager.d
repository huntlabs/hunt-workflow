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
module flow.event.registry.persistence.entity.data.ChannelDefinitionDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;

interface ChannelDefinitionDataManager : DataManager!ChannelDefinitionEntity {

    ChannelDefinitionEntity findLatestChannelDefinitionByKey(string channelDefinitionKey);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(string channelDefinitionKey, string tenantId);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyParentDeploymentIdAndTenantId(string channelDefinitionKey, string parentDeploymentId, string tenantId);

    void deleteChannelDefinitionsByDeploymentId(string deploymentId);

    List!ChannelDefinition findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl channelDefinitionQuery);

    long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl channelDefinitionQuery);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(string deploymentId, string channelDefinitionKey);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string channelDefinitionKey, string tenantId);

    ChannelDefinitionEntity findChannelDefinitionByKeyAndVersion(string channelDefinitionKey, int channelVersion);

    ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(string channelDefinitionKey, int eventVersion, string tenantId);

    List!ChannelDefinition findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateChannelDefinitionTenantIdForDeployment(string deploymentId, string newTenantId);

}
