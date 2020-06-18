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
module flow.engine.impl.persistence.entity.data.ProcessDefinitionDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Joram Barrez
 */
interface ProcessDefinitionDataManager : DataManager!ProcessDefinitionEntity {

    ProcessDefinitionEntity findLatestProcessDefinitionByKey(string processDefinitionKey);

    ProcessDefinitionEntity findLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId);

    ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKey(string processDefinitionKey);

    ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId);

    void deleteProcessDefinitionsByDeploymentId(string deploymentId);

    List!ProcessDefinition findProcessDefinitionsByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery);

    long findProcessDefinitionCountByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery);

    ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKey(string deploymentId, string processDefinitionKey);

    ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string processDefinitionKey, string tenantId);

    ProcessDefinitionEntity findProcessDefinitionByKeyAndVersion(string processDefinitionKey, int processDefinitionVersion);

    ProcessDefinitionEntity findProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, int processDefinitionVersion, string tenantId);

    List!ProcessDefinition findProcessDefinitionsByNativeQuery(Map!(string, Object) parameterMap);

    long findProcessDefinitionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateProcessDefinitionTenantIdForDeployment(string deploymentId, string newTenantId);

    void updateProcessDefinitionVersionForProcessDefinitionId(string processDefinitionId, int ver);

}
