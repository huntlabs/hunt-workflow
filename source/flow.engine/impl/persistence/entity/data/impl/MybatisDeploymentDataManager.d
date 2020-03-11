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

import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.DeploymentEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.DeploymentDataManager;
import flow.engine.repository.Deployment;

/**
 * @author Joram Barrez
 */
class MybatisDeploymentDataManager extends AbstractProcessDataManager<DeploymentEntity> implements DeploymentDataManager {

    public MybatisDeploymentDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends DeploymentEntity> getManagedEntityClass() {
        return DeploymentEntityImpl.class;
    }

    @Override
    public DeploymentEntity create() {
        return new DeploymentEntityImpl();
    }

    @Override
    public long findDeploymentCountByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        return (Long) getDbSqlSession().selectOne("selectDeploymentCountByQueryCriteria", deploymentQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Deployment> findDeploymentsByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        final string query = "selectDeploymentsByQueryCriteria";
        return getDbSqlSession().selectList(query, deploymentQuery);
    }

    @Override
    public List!string getDeploymentResourceNames(string deploymentId) {
        return getDbSqlSession().getSqlSession().selectList("selectResourceNamesByDeploymentId", deploymentId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Deployment> findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectDeploymentByNativeQuery", parameterMap);
    }

    @Override
    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectDeploymentCountByNativeQuery", parameterMap);
    }

}
