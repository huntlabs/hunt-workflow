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
import flow.event.registry.api.EventDefinition;
import flow.event.registry.EventDefinitionQueryImpl;

/**
 * @author Joram Barrez
 */
interface EventDefinitionEntityManager extends EntityManager<EventDefinitionEntity> {

    EventDefinitionEntity findLatestEventDefinitionByKey(String eventDefinitionKey);

    EventDefinitionEntity findLatestEventDefinitionByKeyAndTenantId(String eventDefinitionKey, String tenantId);

    List<EventDefinition> findEventDefinitionsByQueryCriteria(EventDefinitionQueryImpl eventQuery);

    long findEventDefinitionCountByQueryCriteria(EventDefinitionQueryImpl eventQuery);

    EventDefinitionEntity findEventDefinitionByDeploymentAndKey(String deploymentId, String eventDefinitionKey);

    EventDefinitionEntity findEventDefinitionByDeploymentAndKeyAndTenantId(String deploymentId, String eventDefinitionKey, String tenantId);

    EventDefinitionEntity findEventDefinitionByKeyAndVersionAndTenantId(String eventDefinitionKey, Integer eventVersion, String tenantId);

    List<EventDefinition> findEventDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findEventDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateEventDefinitionTenantIdForDeployment(String deploymentId, String newTenantId);

    void deleteEventDefinitionsByDeploymentId(String deploymentId);

}
