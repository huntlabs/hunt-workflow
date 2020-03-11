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
module flow.event.registry.persistence.entity.EventDefinitionEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.EventDefinitionQueryImpl;
import flow.event.registry.persistence.entity.EventDefinitionEntity;

/**
 * @author Joram Barrez
 */
interface EventDefinitionEntityManager : EntityManager!EventDefinitionEntity {

    EventDefinitionEntity findLatestEventDefinitionByKey(string eventDefinitionKey);

    EventDefinitionEntity findLatestEventDefinitionByKeyAndTenantId(string eventDefinitionKey, string tenantId);

    List!EventDefinition findEventDefinitionsByQueryCriteria(EventDefinitionQueryImpl eventQuery);

    long findEventDefinitionCountByQueryCriteria(EventDefinitionQueryImpl eventQuery);

    EventDefinitionEntity findEventDefinitionByDeploymentAndKey(string deploymentId, string eventDefinitionKey);

    EventDefinitionEntity findEventDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string eventDefinitionKey, string tenantId);

    EventDefinitionEntity findEventDefinitionByKeyAndVersionAndTenantId(string eventDefinitionKey, int eventVersion, string tenantId);

    List!EventDefinition findEventDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findEventDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateEventDefinitionTenantIdForDeployment(string deploymentId, string newTenantId);

    void deleteEventDefinitionsByDeploymentId(string deploymentId);

}
