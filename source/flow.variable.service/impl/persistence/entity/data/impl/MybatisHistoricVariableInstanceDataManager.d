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
module flow.variable.service.impl.persistence.entity.data.impl.MybatisHistoricVariableInstanceDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.ArrayList;
import flow.common.db.AbstractDataManager;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityImpl;
import flow.variable.service.impl.persistence.entity.data.HistoricVariableInstanceDataManager;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.HistoricVariableInstanceByProcInstMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.HistoricVariableInstanceByScopeIdAndScopeTypeMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.HistoricVariableInstanceBySubScopeIdAndScopeTypeMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.HistoricVariableInstanceByTaskIdMatcher;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisHistoricVariableInstanceDataManager : EntityRepository!(HistoricVariableInstanceEntityImpl , string) , HistoricVariableInstanceDataManager {

     this()
     {
       super(entityManagerFactory.currentEntityManager());
     }
    //protected CachedEntityMatcher!HistoricVariableInstanceEntity historicVariableInstanceByTaskIdMatcher
    //    = new HistoricVariableInstanceByTaskIdMatcher();
    //
    //protected CachedEntityMatcher!HistoricVariableInstanceEntity historicVariableInstanceByProcInstMatcher
    //    = new HistoricVariableInstanceByProcInstMatcher();
    //
    //protected CachedEntityMatcher!HistoricVariableInstanceEntity historicVariableInstanceByScopeIdAndScopeTypeMatcher
    //    = new HistoricVariableInstanceByScopeIdAndScopeTypeMatcher();
    //
    //protected CachedEntityMatcher!HistoricVariableInstanceEntity historicVariableInstanceBySubScopeIdAndScopeTypeMatcher
    //    = new HistoricVariableInstanceBySubScopeIdAndScopeTypeMatcher();
    //
    //
    //public Class<? extends HistoricVariableInstanceEntity> getManagedEntityClass() {
    //    return HistoricVariableInstanceEntityImpl.class;
    //}
  public HistoricVariableInstanceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);

    // Cache
    //EntityImpl cachedEntity = getEntityCache().findInCache(getManagedEntityClass(), entityId);
    //if (cachedEntity !is null) {
    //  return cachedEntity;
    //}

    // Database
    //return getDbSqlSession().selectById(getManagedEntityClass(), entityId, false);
  }
  //
    public void insert(HistoricVariableInstanceEntity entity) {
      insert(cast(HistoricVariableInstanceEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    public HistoricVariableInstanceEntity update(HistoricVariableInstanceEntity entity) {
      return  update(cast(HistoricVariableInstanceEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    public void dele(string id) {
      HistoricVariableInstanceEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(HistoricVariableInstanceEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(HistoricVariableInstanceEntity entity) {
      if (entity !is null)
      {
        remove(cast(HistoricVariableInstanceEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }


    public HistoricVariableInstanceEntity create() {
        return new HistoricVariableInstanceEntityImpl();
    }


    //public void insert(HistoricVariableInstanceEntity entity) {
    //    super.insert(entity);
    //}


    public List!HistoricVariableInstanceEntity findHistoricVariableInstancesByProcessInstanceId( string processInstanceId) {
       // return getList("selectHistoricVariableInstanceByProcessInstanceId", processInstanceId, historicVariableInstanceByProcInstMatcher, true);
        HistoricVariableInstanceEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.processInstanceId , processInstanceId));
        return new ArrayList!HistoricVariableInstanceEntity(objs);
    }


    public List!HistoricVariableInstanceEntity findHistoricVariableInstancesByTaskId( string taskId) {
        //return getList("selectHistoricVariableInstanceByTaskId", taskId, historicVariableInstanceByTaskIdMatcher, true);
        HistoricVariableInstanceEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.taskId , taskId));
        return new ArrayList!HistoricVariableInstanceEntity(objs);
    }


    public long findHistoricVariableInstanceCountByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectHistoricVariableInstanceCountByQueryCriteria", historicProcessVariableQuery);
    }


    public List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery) {
        implementationMissing(false);
        return null;
      // return getDbSqlSession().selectList("selectHistoricVariableInstanceByQueryCriteria", historicProcessVariableQuery);
    }


    public HistoricVariableInstanceEntity findHistoricVariableInstanceByVariableInstanceId(string variableInstanceId) {
       HistoricVariableInstanceEntityImpl obj =  find(new Condition("%s = %s" , Field.id , variableInstanceId));
       return obj;
        //return (HistoricVariableInstanceEntity) getDbSqlSession().selectOne("selectHistoricVariableInstanceByVariableInstanceId", variableInstanceId);
    }


    public List!HistoricVariableInstanceEntity findHistoricalVariableInstancesByScopeIdAndScopeType(string scopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(HistoricVariableInstanceEntityImpl)("SELECT * FROM HistoricVariableInstanceEntityImpl u where u.scopeId = :scopeId and u.scopeType = :scopeType");
        select.setParameter("scopeId",scopeId);
        select.setParameter("scopeType",scopeType);
        HistoricVariableInstanceEntityImpl[] ls = select.getResultList();
        return new ArrayList!HistoricVariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(2);
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectHistoricVariableInstanceByScopeIdAndScopeType", params, historicVariableInstanceByScopeIdAndScopeTypeMatcher, true);
    }


    public List!HistoricVariableInstanceEntity findHistoricalVariableInstancesBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(HistoricVariableInstanceEntityImpl)("SELECT * FROM HistoricVariableInstanceEntityImpl u where u.scopeId = :scopeId and u.scopeType = :scopeType");
        select.setParameter("scopeId",subScopeId);
        select.setParameter("scopeType",scopeType);
        HistoricVariableInstanceEntityImpl[] ls = select.getResultList();
        return new ArrayList!HistoricVariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(2);
        //params.put("subScopeId", subScopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectHistoricVariableInstanceByScopeIdAndScopeType", params, historicVariableInstanceByScopeIdAndScopeTypeMatcher, true);
    }


    public List!HistoricVariableInstance findHistoricVariableInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectHistoricVariableInstanceByNativeQuery", parameterMap);
    }


    public long findHistoricVariableInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectHistoricVariableInstanceCountByNativeQuery", parameterMap);
    }


    public void deleteHistoricVariableInstancesForNonExistingProcessInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricVariableInstancesForNonExistingProcessInstances", null, HistoricVariableInstanceEntity.class);
    }


    public void deleteHistoricVariableInstancesForNonExistingCaseInstances() {
        implementationMissing(false);

      //getDbSqlSession().delete("bulkDeleteHistoricVariableInstancesForNonExistingCaseInstances", null, HistoricVariableInstanceEntity.class);
    }
}
