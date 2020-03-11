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


import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionDataManager;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Joram Barrez
 */
class MybatisProcessDefinitionDataManager extends AbstractProcessDataManager<ProcessDefinitionEntity> implements ProcessDefinitionDataManager {

    public MybatisProcessDefinitionDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends ProcessDefinitionEntity> getManagedEntityClass() {
        return ProcessDefinitionEntityImpl.class;
    }

    @Override
    public ProcessDefinitionEntity create() {
        return new ProcessDefinitionEntityImpl();
    }

    @Override
    public ProcessDefinitionEntity findLatestProcessDefinitionByKey(string processDefinitionKey) {
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestProcessDefinitionByKey", processDefinitionKey);
    }

    @Override
    public ProcessDefinitionEntity findLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        Map!(string, Object) params = new HashMap<>(2);
        params.put("processDefinitionKey", processDefinitionKey);
        params.put("tenantId", tenantId);
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestProcessDefinitionByKeyAndTenantId", params);
    }

    @Override
    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKey(string processDefinitionKey) {
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestDerivedProcessDefinitionByKey", processDefinitionKey);
    }

    @Override
    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        Map!(string, Object) params = new HashMap<>(2);
        params.put("processDefinitionKey", processDefinitionKey);
        params.put("tenantId", tenantId);
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestDerivedProcessDefinitionByKeyAndTenantId", params);
    }

    @Override
    public void deleteProcessDefinitionsByDeploymentId(string deploymentId) {
        getDbSqlSession().delete("deleteProcessDefinitionsByDeploymentId", deploymentId, ProcessDefinitionEntityImpl.class);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ProcessDefinition> findProcessDefinitionsByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return getDbSqlSession().selectList("selectProcessDefinitionsByQueryCriteria", processDefinitionQuery);
    }

    @Override
    public long findProcessDefinitionCountByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        return (Long) getDbSqlSession().selectOne("selectProcessDefinitionCountByQueryCriteria", processDefinitionQuery);
    }

    @Override
    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKey(string deploymentId, string processDefinitionKey) {
        Map!(string, Object) parameters = new HashMap<>();
        parameters.put("deploymentId", deploymentId);
        parameters.put("processDefinitionKey", processDefinitionKey);
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectProcessDefinitionByDeploymentAndKey", parameters);
    }

    @Override
    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string processDefinitionKey, string tenantId) {
        Map!(string, Object) parameters = new HashMap<>();
        parameters.put("deploymentId", deploymentId);
        parameters.put("processDefinitionKey", processDefinitionKey);
        parameters.put("tenantId", tenantId);
        return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectProcessDefinitionByDeploymentAndKeyAndTenantId", parameters);
    }

    @Override
    public ProcessDefinitionEntity findProcessDefinitionByKeyAndVersion(string processDefinitionKey, Integer processDefinitionVersion) {
        Map!(string, Object) params = new HashMap<>();
        params.put("processDefinitionKey", processDefinitionKey);
        params.put("processDefinitionVersion", processDefinitionVersion);
        List<ProcessDefinitionEntity> results = getDbSqlSession().selectList("selectProcessDefinitionsByKeyAndVersion", params);
        if (results.size() == 1) {
            return results.get(0);
        } else if (results.size() > 1) {
            throw new FlowableException("There are " + results.size() + " process definitions with key = '" + processDefinitionKey + "' and version = '" + processDefinitionVersion + "'.");
        }
        return null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public ProcessDefinitionEntity findProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, Integer processDefinitionVersion, string tenantId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("processDefinitionKey", processDefinitionKey);
        params.put("processDefinitionVersion", processDefinitionVersion);
        params.put("tenantId", tenantId);
        List<ProcessDefinitionEntity> results = getDbSqlSession().selectList("selectProcessDefinitionsByKeyAndVersionAndTenantId", params);
        if (results.size() == 1) {
            return results.get(0);
        } else if (results.size() > 1) {
            throw new FlowableException("There are " + results.size() + " process definitions with key = '" + processDefinitionKey + "' and version = '" + processDefinitionVersion + "'.");
        }
        return null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ProcessDefinition> findProcessDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectProcessDefinitionByNativeQuery", parameterMap);
    }

    @Override
    public long findProcessDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectProcessDefinitionCountByNativeQuery", parameterMap);
    }

    @Override
    public void updateProcessDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateProcessDefinitionTenantIdForDeploymentId", params);
    }

    @Override
    public void updateProcessDefinitionVersionForProcessDefinitionId(string processDefinitionId, int version) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("processDefinitionId", processDefinitionId);
        params.put("version", version);
        getDbSqlSession().update("updateProcessDefinitionVersionForProcessDefinitionId", params);
    }

}
