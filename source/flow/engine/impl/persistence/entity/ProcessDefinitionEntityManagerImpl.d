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

module flow.engine.impl.persistence.entity.ProcessDefinitionEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionDataManager;
import flow.engine.repository.ProcessDefinition;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
/**
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */
class ProcessDefinitionEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ProcessDefinitionEntity, ProcessDefinitionDataManager)
    , ProcessDefinitionEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, ProcessDefinitionDataManager processDefinitionDataManager) {
        super(processEngineConfiguration, processDefinitionDataManager);
    }


    public ProcessDefinitionEntity findLatestProcessDefinitionByKey(string processDefinitionKey) {
        return dataManager.findLatestProcessDefinitionByKey(processDefinitionKey);
    }


    public ProcessDefinitionEntity findLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return dataManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
    }


    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKey(string processDefinitionKey) {
        return dataManager.findLatestDerivedProcessDefinitionByKey(processDefinitionKey);
    }


    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return dataManager.findLatestDerivedProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
    }


    public void deleteProcessDefinitionsByDeploymentId(string deploymentId) {
        dataManager.deleteProcessDefinitionsByDeploymentId(deploymentId);
    }


    public List!ProcessDefinition findProcessDefinitionsByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return dataManager.findProcessDefinitionsByQueryCriteria(processDefinitionQuery);
    }


    public long findProcessDefinitionCountByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return dataManager.findProcessDefinitionCountByQueryCriteria(processDefinitionQuery);
    }


    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKey(string deploymentId, string processDefinitionKey) {
        return dataManager.findProcessDefinitionByDeploymentAndKey(deploymentId, processDefinitionKey);
    }


    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string processDefinitionKey, string tenantId) {
        return dataManager.findProcessDefinitionByDeploymentAndKeyAndTenantId(deploymentId, processDefinitionKey, tenantId);
    }


    public ProcessDefinition findProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, int processDefinitionVersion, string tenantId) {
        if (tenantId.length == 0 || ProcessEngineConfiguration.NO_TENANT_ID == (tenantId)) {
            return dataManager.findProcessDefinitionByKeyAndVersion(processDefinitionKey, processDefinitionVersion);
        } else {
            return dataManager.findProcessDefinitionByKeyAndVersionAndTenantId(processDefinitionKey, processDefinitionVersion, tenantId);
        }
    }


    public List!ProcessDefinition findProcessDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findProcessDefinitionsByNativeQuery(parameterMap);
    }


    public long findProcessDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findProcessDefinitionCountByNativeQuery(parameterMap);
    }


    public void updateProcessDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateProcessDefinitionTenantIdForDeployment(deploymentId, newTenantId);
    }


    public void updateProcessDefinitionVersionForProcessDefinitionId(string processDefinitionId, int ver) {
        dataManager.updateProcessDefinitionVersionForProcessDefinitionId(processDefinitionId, ver);
    }

}
