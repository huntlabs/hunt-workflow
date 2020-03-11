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
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class MybatisEventDeploymentDataManager : EntityRepository!( EventDeploymentEntityImpl , string), EventDeploymentDataManager {

    public EventRegistryEngineConfiguration eventRegistryConfiguration;

    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        //super(eventRegistryConfiguration);
        this.eventRegistryConfiguration = eventRegistryConfiguration;
        super(entityManagerFactory.createEntityManager());
    }

    //
    //class<? extends EventDeploymentEntity> getManagedEntityClass() {
    //    return EventDeploymentEntityImpl.class;
    //}


    public EventDeploymentEntity create() {
        return new EventDeploymentEntityImpl();
    }


    public long findDeploymentCountByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectEventDeploymentCountByQueryCriteria", deploymentQuery);
    }


    public List!EventDeployment findDeploymentsByQueryCriteria(EventDeploymentQueryImpl deploymentQuery) {
      implementationMissing(false);
      return null;
        //return getDbSqlSession().selectList("selectEventDeploymentsByQueryCriteria", deploymentQuery);
    }


    public List!string getDeploymentResourceNames(string deploymentId) {
      implementationMissing(false);
        return null;
        //return getDbSqlSession().getSqlSession().selectList("selectEventResourceNamesByDeploymentId", deploymentId);
    }


    public List!EventDeployment findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
          return null;
        //return getDbSqlSession().selectListWithRawParameter("selectEventDeploymentByNativeQuery", parameterMap);
    }


    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
      return 0;
        //return (Long) getDbSqlSession().selectOne("selectEventDeploymentCountByNativeQuery", parameterMap);
    }

}
