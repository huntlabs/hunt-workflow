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
module flow.event.registry.persistence.entity.data.impl.MybatisEventDefinitionDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.event.registry.api.EventDefinition;
import flow.event.registry.EventDefinitionQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.EventDefinitionEntity;
import flow.event.registry.persistence.entity.EventDefinitionEntityImpl;
import flow.event.registry.persistence.entity.data.AbstractEventDataManager;
import flow.event.registry.persistence.entity.data.EventDefinitionDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisEventDefinitionDataManager : EntityRepository!( EventDefinitionEntityImpl , string) , EventDefinitionDataManager {
//class MybatisEventDefinitionDataManager extends AbstractEventDataManager<EventDefinitionEntity> implements EventDefinitionDataManager {

    public EventRegistryEngineConfiguration eventRegistryConfiguration;
    alias insert = CrudRepository!( EventDefinitionEntityImpl , string).insert;
    alias update = CrudRepository!( EventDefinitionEntityImpl , string).update;

    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        this.eventRegistryConfiguration = eventRegistryConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //@Override
    //class<? extends EventDefinitionEntity> getManagedEntityClass() {
    //    return EventDefinitionEntityImpl.class;
    //}
    public void insert(EventDefinitionEntity entity) {
      super.insert(cast(EventDefinitionEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public EventDefinitionEntity update(EventDefinitionEntity entity) {
      return  super.update(cast(EventDefinitionEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    //
    //@Override
    public void dele(string id) {
      EventDefinitionEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(EventDefinitionEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(EventDefinitionEntity entity) {
      if (entity !is null)
      {
        remove(cast(EventDefinitionEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    public EventDefinitionEntity create() {
        return new EventDefinitionEntityImpl();
    }


    public EventDefinitionEntity findLatestEventDefinitionByKey(string eventDefinitionKey) {
        implementationMissing(false);
        return null;
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectLatestEventDefinitionByKey", eventDefinitionKey);
    }


    public EventDefinitionEntity findLatestEventDefinitionByKeyAndTenantId(string eventDefinitionKey, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("eventDefinitionKey", eventDefinitionKey);
        //params.put("tenantId", tenantId);
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectLatestEventDefinitionByKeyAndTenantId", params);
    }


    public EventDefinitionEntity findLatestEventDefinitionByKeyAndParentDeploymentId(string eventDefinitionKey, string parentDeploymentId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("eventDefinitionKey", eventDefinitionKey);
        //params.put("parentDeploymentId", parentDeploymentId);
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectEventDefinitionByKeyAndParentDeploymentId", params);
    }


    public EventDefinitionEntity findLatestEventDefinitionByKeyParentDeploymentIdAndTenantId(string eventDefinitionKey, string parentDeploymentId, string tenantId) {
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("eventDefinitionKey", eventDefinitionKey);
        //params.put("parentDeploymentId", parentDeploymentId);
        //params.put("tenantId", tenantId);
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectEventDefinitionByKeyParentDeploymentIdAndTenantId", params);
      implementationMissing(false);
      return null;
    }


    public void deleteEventDefinitionsByDeploymentId(string deploymentId) {
        //getDbSqlSession().delete("deleteEventDefinitionsByDeploymentId", deploymentId, getManagedEntityClass());
      implementationMissing(false);
    }


    public List!EventDefinition findEventDefinitionsByQueryCriteria(EventDefinitionQueryImpl eventDefinitionQuery) {
     implementationMissing(false);
      return null;
        //return getDbSqlSession().selectList("selectEventDefinitionsByQueryCriteria", eventDefinitionQuery);
    }


    public long findEventDefinitionCountByQueryCriteria(EventDefinitionQueryImpl eventDefinitionQuery) {
      implementationMissing(false);
      return 0;
       // return (Long) getDbSqlSession().selectOne("selectEventDefinitionCountByQueryCriteria", eventDefinitionQuery);
    }


    public EventDefinitionEntity findEventDefinitionByDeploymentAndKey(string deploymentId, string eventDefinitionKey) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("eventDefinitionKey", eventDefinitionKey);
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectEventDefinitionByDeploymentAndKey", parameters);
    }


    public EventDefinitionEntity findEventDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string eventDefinitionKey, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("eventDefinitionKey", eventDefinitionKey);
        //parameters.put("tenantId", tenantId);
        //return (EventDefinitionEntity) getDbSqlSession().selectOne("selectEventDefinitionByDeploymentAndKeyAndTenantId", parameters);
    }


    public EventDefinitionEntity findEventDefinitionByKeyAndVersion(string eventDefinitionKey, int eventVersion) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("eventDefinitionKey", eventDefinitionKey);
        //params.put("eventVersion", eventVersion);
        //List<EventDefinitionEntity> results = getDbSqlSession().selectList("selectEventDefinitionsByKeyAndVersion", params);
        //if (results.size() == 1) {
        //    return results.get(0);
        //} else if (results.size() > 1) {
        //    throw new FlowableException("There are " + results.size() + " event definitions with key = '" + eventDefinitionKey + "' and version = '" + eventVersion + "'.");
        //}
        //return null;
    }


    public EventDefinitionEntity findEventDefinitionByKeyAndVersionAndTenantId(string eventDefinitionKey, int eventVersion, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("eventDefinitionKey", eventDefinitionKey);
        //params.put("eventVersion", eventVersion);
        //params.put("tenantId", tenantId);
        //List<EventDefinitionEntity> results = getDbSqlSession().selectList("selectEventDefinitionsByKeyAndVersionAndTenantId", params);
        //if (results.size() == 1) {
        //    return results.get(0);
        //} else if (results.size() > 1) {
        //    throw new FlowableException("There are " + results.size() + " event definitions with key = '" + eventDefinitionKey + "' and version = '" + eventVersion + "'.");
        //}
        //return null;
    }


    public List!EventDefinition findEventDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
      return null;
        //return getDbSqlSession().selectListWithRawParameter("selectEventDefinitionByNativeQuery", parameterMap);
    }


    public long findEventDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
      return 0;
       // return (Long) getDbSqlSession().selectOne("selectEventDefinitionCountByNativeQuery", parameterMap);
    }


    public void updateEventDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
      implementationMissing(false);
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateEventDefinitionTenantIdForDeploymentId", params);
    }

}
