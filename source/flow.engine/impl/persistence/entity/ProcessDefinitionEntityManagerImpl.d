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

import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionDataManager;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */
class ProcessDefinitionEntityManagerImpl
    extends AbstractProcessEngineEntityManager<ProcessDefinitionEntity, ProcessDefinitionDataManager>
    implements ProcessDefinitionEntityManager {

    public ProcessDefinitionEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, ProcessDefinitionDataManager processDefinitionDataManager) {
        super(processEngineConfiguration, processDefinitionDataManager);
    }

    @Override
    public ProcessDefinitionEntity findLatestProcessDefinitionByKey(string processDefinitionKey) {
        return dataManager.findLatestProcessDefinitionByKey(processDefinitionKey);
    }

    @Override
    public ProcessDefinitionEntity findLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return dataManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
    }

    @Override
    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKey(string processDefinitionKey) {
        return dataManager.findLatestDerivedProcessDefinitionByKey(processDefinitionKey);
    }

    @Override
    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return dataManager.findLatestDerivedProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
    }

    @Override
    public void deleteProcessDefinitionsByDeploymentId(string deploymentId) {
        dataManager.deleteProcessDefinitionsByDeploymentId(deploymentId);
    }

    @Override
    public List<ProcessDefinition> findProcessDefinitionsByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return dataManager.findProcessDefinitionsByQueryCriteria(processDefinitionQuery);
    }

    @Override
    public long findProcessDefinitionCountByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return dataManager.findProcessDefinitionCountByQueryCriteria(processDefinitionQuery);
    }

    @Override
    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKey(string deploymentId, string processDefinitionKey) {
        return dataManager.findProcessDefinitionByDeploymentAndKey(deploymentId, processDefinitionKey);
    }

    @Override
    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string processDefinitionKey, string tenantId) {
        return dataManager.findProcessDefinitionByDeploymentAndKeyAndTenantId(deploymentId, processDefinitionKey, tenantId);
    }

    @Override
    public ProcessDefinition findProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, Integer processDefinitionVersion, string tenantId) {
        if (tenantId is null || ProcessEngineConfiguration.NO_TENANT_ID.equals(tenantId)) {
            return dataManager.findProcessDefinitionByKeyAndVersion(processDefinitionKey, processDefinitionVersion);
        } else {
            return dataManager.findProcessDefinitionByKeyAndVersionAndTenantId(processDefinitionKey, processDefinitionVersion, tenantId);
        }
    }

    @Override
    public List<ProcessDefinition> findProcessDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findProcessDefinitionsByNativeQuery(parameterMap);
    }

    @Override
    public long findProcessDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findProcessDefinitionCountByNativeQuery(parameterMap);
    }

    @Override
    public void updateProcessDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateProcessDefinitionTenantIdForDeployment(deploymentId, newTenantId);
    }

    @Override
    public void updateProcessDefinitionVersionForProcessDefinitionId(string processDefinitionId, int version) {
        dataManager.updateProcessDefinitionVersionForProcessDefinitionId(processDefinitionId, version);
    }

}
