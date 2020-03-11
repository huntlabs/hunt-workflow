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
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.repository.Deployment;

/**
 * @author Joram Barrez
 */
interface DeploymentDataManager extends DataManager<DeploymentEntity> {

    long findDeploymentCountByQueryCriteria(DeploymentQueryImpl deploymentQuery);

    List<Deployment> findDeploymentsByQueryCriteria(DeploymentQueryImpl deploymentQuery);

    List!string getDeploymentResourceNames(string deploymentId);

    List<Deployment> findDeploymentsByNativeQuery(Map!(string, Object) parameterMap);

    long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap);

}
