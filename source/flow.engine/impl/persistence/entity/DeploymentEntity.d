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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.impl.persistence.entity.DeploymentEntity;





import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;
import flow.common.api.repository.EngineResource;
import flow.common.persistence.entity.Entity;
import flow.engine.repository.Deployment;
import flow.engine.impl.persistence.entity.ResourceEntity;
import hunt.time.LocalDateTime;
alias Date = LocalDateTime;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface DeploymentEntity : Deployment, Entity {

    void addResource(ResourceEntity resource);

    void addDeployedArtifact(Object deployedArtifact);

   // <T> List!T getDeployedArtifacts(Class!T clazz);

    void setName(string name);

    void setCategory(string category);

    void setKey(string key);

    void setTenantId(string tenantId);

    void setResources(Map!(string, EngineResource) resources);

    void setDeploymentTime(Date deploymentTime);

    bool isNew();

    void setNew(bool isNew);

    void setDerivedFrom(string derivedFrom);

    void setDerivedFromRoot(string derivedFromRoot);

    void setParentDeploymentId(string parentDeploymentId);

    void setEngineVersion(string engineVersion);

}
