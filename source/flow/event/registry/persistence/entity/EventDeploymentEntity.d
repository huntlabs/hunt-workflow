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
module flow.event.registry.persistence.entity.EventDeploymentEntity;


import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.Entity;
import flow.event.registry.api.EventDeployment;
import flow.event.registry.persistence.entity.EventResourceEntity;


alias Date = LocalDateTime;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface EventDeploymentEntity : EventDeployment, Entity {

    void addResource(EventResourceEntity resource);

    Map!(string, EventResourceEntity) getResources();

    void addDeployedArtifact(Object deployedArtifact);

    //<T> List<T> getDeployedArtifacts(Class<T> clazz);

    void setName(string name);

    void setCategory(string category);

    void setTenantId(string tenantId);

    void setParentDeploymentId(string parentDeploymentId);

    void setResources(Map!(string, EventResourceEntity) resources);

    void setDeploymentTime(Date deploymentTime);

    bool isNew();

    void setNew(bool isNew);
}
