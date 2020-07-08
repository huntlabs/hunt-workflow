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

    alias insert = CrudRepository!( EventDeploymentEntityImpl , string).insert;
    alias update = CrudRepository!( EventDeploymentEntityImpl , string).update;

    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        //super(eventRegistryConfiguration);
        this.eventRegistryConfiguration = eventRegistryConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //
    //class<? extends EventDeploymentEntity> getManagedEntityClass() {
    //    return EventDeploymentEntityImpl.class;
    //}

    public void insert(EventDeploymentEntity entity) {
      super.insert(cast(EventDeploymentEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public EventDeploymentEntity update(EventDeploymentEntity entity) {
      return  super.update(cast(EventDeploymentEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    //
    //@Override
    public void dele(string id) {
      EventDeploymentEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(EventDeploymentEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(EventDeploymentEntity entity) {
      if (entity !is null)
      {
        remove(cast(EventDeploymentEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }


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
