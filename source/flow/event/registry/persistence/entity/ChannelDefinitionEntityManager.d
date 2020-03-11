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

import flow.common.persistence.entity.EntityManager;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;

interface ChannelDefinitionEntityManager extends EntityManager<ChannelDefinitionEntity> {

    ChannelDefinitionEntity findLatestChannelDefinitionByKey(String channelDefinitionKey);

    ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(String channelDefinitionKey, String tenantId);

    List<ChannelDefinition> findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl eventQuery);

    long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl eventQuery);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(String deploymentId, String channelDefinitionKey);

    ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(String deploymentId, String channelDefinitionKey, String tenantId);

    ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(String channelDefinitionKey, Integer channelVersion, String tenantId);

    List<ChannelDefinition> findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateChannelDefinitionTenantIdForDeployment(String deploymentId, String newTenantId);

    void deleteChannelDefinitionsByDeploymentId(String deploymentId);

}
