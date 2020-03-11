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


module flow.event.registry.persistence.entity.data.impl.MybatisEventDeploymentDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.event.registry.api.EventDeployment;
import flow.event.registry.EventDeploymentQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.EventDeploymentEntity;
import flow.event.registry.persistence.entity.EventDeploymentEntityImpl;
import flow.event.registry.persistence.entity.data.AbstractEventDataManager;
import flow.event.registry.persistence.entity.data.EventDeploymentDataManager;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class MybatisEventDeploymentDataManager : AbstractEventDataManager!EventDeploymentEntity , EventDeploymentDataManager {

    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        super(eventRegistryConfiguration);
    }

    @Override
    class<? extends EventDeploymentEntity> getManagedEntityClass() {
        return EventDeploymentEntityImpl.class;
    }

    @Override
    public EventDeploymentEntity create() {
        return new EventDeploymentEntityImpl();
    }

    @Override
    public long findDeploymentCountByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
        return (Long) getDbSqlSession().selectOne("selectEventDeploymentCountByQueryCriteria", deploymentQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EventDeployment> findDeploymentsByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
        return getDbSqlSession().selectList("selectEventDeploymentsByQueryCriteria", deploymentQuery);
    }

    @Override
    public List!String getDeploymentResourceNames(String deploymentId) {
        return getDbSqlSession().getSqlSession().selectList("selectEventResourceNamesByDeploymentId", deploymentId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EventDeployment> findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectEventDeploymentByNativeQuery", parameterMap);
    }

    @Override
    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectEventDeploymentCountByNativeQuery", parameterMap);
    }

}
