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
module flow.event.registry.persistence.entity.data.impl.MybatisChannelDefinitionDataManager;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.event.registry.api.ChannelDefinition;
import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityImpl;
import flow.event.registry.persistence.entity.data.AbstractEventDataManager;
import flow.event.registry.persistence.entity.data.ChannelDefinitionDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
//class MybatisChannelDefinitionDataManager : AbstractEventDataManager<ChannelDefinitionEntity> implements ChannelDefinitionDataManager {
class MybatisChannelDefinitionDataManager : EntityRepository!( ChannelDefinitionEntityImpl , string) , ChannelDefinitionDataManager {
    public EventRegistryEngineConfiguration eventRegistryConfiguration;

    alias insert = CrudRepository!( ChannelDefinitionEntityImpl , string).insert;
    alias update = CrudRepository!( ChannelDefinitionEntityImpl , string).update;
    this(EventRegistryEngineConfiguration eventRegistryConfiguration) {
        //super(eventRegistryConfiguration);
        this.eventRegistryConfiguration = eventRegistryConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //
    //class<? extends ChannelDefinitionEntity> getManagedEntityClass() {
    //    return ChannelDefinitionEntityImpl.class;
    //}

    public void insert(ChannelDefinitionEntity entity) {
      super.insert(cast(ChannelDefinitionEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public ChannelDefinitionEntity update(ChannelDefinitionEntity entity) {
      return  super.update(cast(ChannelDefinitionEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    //
    //@Override
    public void dele(string id) {
      ChannelDefinitionEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(ChannelDefinitionEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(ChannelDefinitionEntity entity) {
      if (entity !is null)
      {
        remove(cast(ChannelDefinitionEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    public ChannelDefinitionEntity create() {
        return new ChannelDefinitionEntityImpl();
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKey(string channelDefinitionKey) {
        implementationMissing(false);
        return null;
        //return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectLatestChannelDefinitionByKey", channelDefinitionKey);
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndTenantId(string channelDefinitionKey, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("channelDefinitionKey", channelDefinitionKey);
        //params.put("tenantId", tenantId);
        //return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectLatestChannelDefinitionByKeyAndTenantId", params);
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKeyAndParentDeploymentId(string channelDefinitionKey, string parentDeploymentId) {
      implementationMissing(false);
      return null;
    //    Map!(string, Object) params = new HashMap<>(2);
    //    params.put("channelDefinitionKey", channelDefinitionKey);
    //    params.put("parentDeploymentId", parentDeploymentId);
    //    return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectChannelDefinitionByKeyAndParentDeploymentId", params);
    }


    public ChannelDefinitionEntity findLatestChannelDefinitionByKeyParentDeploymentIdAndTenantId(string channelDefinitionKey, string parentDeploymentId, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("channelDefinitionKey", channelDefinitionKey);
        //params.put("parentDeploymentId", parentDeploymentId);
        //params.put("tenantId", tenantId);
        //return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectChannelDefinitionByKeyParentDeploymentIdAndTenantId", params);
    }


    public void deleteChannelDefinitionsByDeploymentId(string deploymentId) {
      implementationMissing(false);
      //  getDbSqlSession().delete("deleteChannelDefinitionsByDeploymentId", deploymentId, getManagedEntityClass());
    }


    public List!ChannelDefinition findChannelDefinitionsByQueryCriteria(ChannelDefinitionQueryImpl ChannelDefinitionQuery) {
      implementationMissing(false);
      return new ArrayList!ChannelDefinition;
        //return getDbSqlSession().selectList("selectChannelDefinitionsByQueryCriteria", ChannelDefinitionQuery);
    }


    public long findChannelDefinitionCountByQueryCriteria(ChannelDefinitionQueryImpl ChannelDefinitionQuery) {
      implementationMissing(false);
      return 0;
       // return (Long) getDbSqlSession().selectOne("selectChannelDefinitionCountByQueryCriteria", ChannelDefinitionQuery);
    }


    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKey(string deploymentId, string channelDefinitionKey) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("channelDefinitionKey", channelDefinitionKey);
        //return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectChannelDefinitionByDeploymentAndKey", parameters);
    }


    public ChannelDefinitionEntity findChannelDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string channelDefinitionKey, string tenantId) {
      implementationMissing(false);
      return null;
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("channelDefinitionKey", channelDefinitionKey);
        //parameters.put("tenantId", tenantId);
        //return (ChannelDefinitionEntity) getDbSqlSession().selectOne("selectChannelDefinitionByDeploymentAndKeyAndTenantId", parameters);
    }


    public ChannelDefinitionEntity findChannelDefinitionByKeyAndVersion(string channelDefinitionKey, int eventVersion) {
      implementationMissing(false);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("channelDefinitionKey", channelDefinitionKey);
        //params.put("eventVersion", eventVersion);
        //List<ChannelDefinitionEntity> results = getDbSqlSession().selectList("selectChannelDefinitionsByKeyAndVersion", params);
        //if (results.size() == 1) {
        //    return results.get(0);
        //} else if (results.size() > 1) {
        //    throw new FlowableException("There are " + results.size() + " event definitions with key = '" + channelDefinitionKey + "' and version = '" + eventVersion + "'.");
        //}
        return null;
    }


    public ChannelDefinitionEntity findChannelDefinitionByKeyAndVersionAndTenantId(string channelDefinitionKey, int eventVersion, string tenantId) {
        //Map!(string, Object) params = new HashMap<>();
        //params.put("channelDefinitionKey", channelDefinitionKey);
        //params.put("eventVersion", eventVersion);
        //params.put("tenantId", tenantId);
        //List<ChannelDefinitionEntity> results = getDbSqlSession().selectList("selectChannelDefinitionsByKeyAndVersionAndTenantId", params);
        //if (results.size() == 1) {
        //    return results.get(0);
        //} else if (results.size() > 1) {
        //    throw new FlowableException("There are " + results.size() + " event definitions with key = '" + channelDefinitionKey + "' and version = '" + eventVersion + "'.");
        //}
        //return null;

      implementationMissing(false);
      return null;
    }


    public List!ChannelDefinition findChannelDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
      return null;
       // return getDbSqlSession().selectListWithRawParameter("selectChannelDefinitionByNativeQuery", parameterMap);
    }


    public long findChannelDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
      implementationMissing(false);
      return 0;
        //return (Long) getDbSqlSession().selectOne("selectChannelDefinitionCountByNativeQuery", parameterMap);
    }


    public void updateChannelDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
      implementationMissing(false);
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateChannelDefinitionTenantIdForDeploymentId", params);
    }

}
