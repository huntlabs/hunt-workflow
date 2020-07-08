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

module flow.event.registry.persistence.entity.data.impl.MybatisEventResourceDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.EventResourceEntity;
import flow.event.registry.persistence.entity.EventResourceEntityImpl;
import flow.event.registry.persistence.entity.data.AbstractEventDataManager;
import flow.event.registry.persistence.entity.data.EventResourceDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;

/**
 * @author Joram Barrez
 */
class MybatisEventResourceDataManager : EntityRepository!( EventResourceEntityImpl , string), EventResourceDataManager {
//class MybatisEventResourceDataManager : AbstractEventDataManager<EventResourceEntity> implements EventResourceDataManager {
    public EventRegistryEngineConfiguration eventRegistryConfiguration;

    alias insert = CrudRepository!( EventResourceEntityImpl , string).insert;
    alias update = CrudRepository!( EventResourceEntityImpl , string).update;
    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        //super(eventRegistryConfiguration);
        this.eventRegistryConfiguration = eventRegistryConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //
    //class<? extends EventResourceEntity> getManagedEntityClass() {
    //    return EventResourceEntityImpl.class;
    //}
    public void insert(EventResourceEntity entity) {
      super.insert(cast(EventResourceEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public EventResourceEntity update(EventResourceEntity entity) {
      return  super.update(cast(EventResourceEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    //
    //@Override
    public void dele(string id) {
      EventResourceEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(EventResourceEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(EventResourceEntity entity) {
      if (entity !is null)
      {
        remove(cast(EventResourceEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    public EventResourceEntity create() {
        return new EventResourceEntityImpl();
    }


    public void deleteResourcesByDeploymentId(string deploymentId) {
        implementationMissing(false);
       // getDbSqlSession().delete("deleteEventResourcesByDeploymentId", deploymentId, getManagedEntityClass());
    }


    public EventResourceEntity findResourceByDeploymentIdAndResourceName(string deploymentId, string resourceName) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("resourceName", resourceName);
        //return (EventResourceEntity) getDbSqlSession().selectOne("selectEventResourceByDeploymentIdAndResourceName", params);
    }


    public List!EventResourceEntity findResourcesByDeploymentId(string deploymentId) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectEventResourcesByDeploymentId", deploymentId);
    }

}
