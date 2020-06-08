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
module flow.engine.impl.persistence.entity.data.impl.MybatisHistoricActivityInstanceDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.HistoricActivityInstanceDataManager;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.HistoricActivityInstanceMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.UnfinishedHistoricActivityInstanceMatcher;
import hunt.entity;
import hunt.collection.ArrayList;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clock;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class MybatisHistoricActivityInstanceDataManager : EntityRepository!(HistoricActivityInstanceEntityImpl , string) , HistoricActivityInstanceDataManager {

    //protected CachedEntityMatcher!HistoricActivityInstanceEntity unfinishedHistoricActivityInstanceMatcher = new UnfinishedHistoricActivityInstanceMatcher();
    //protected CachedEntityMatcher!HistoricActivityInstanceEntity historicActivityInstanceMatcher = new HistoricActivityInstanceMatcher();

   private ProcessEngineConfigurationImpl processEngineConfiguration;


    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
      return processEngineConfiguration;
    }

    public Clock getClock() {
      return processEngineConfiguration.getClock();
    }

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
      this.processEngineConfiguration = processEngineConfiguration;
      super(entityManagerFactory.createEntityManager());
    }


    //class<? : ResourceEntity> getManagedEntityClass() {
    //    return ResourceEntityImpl.class;
    //}

  public HistoricActivityInstanceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(HistoricActivityInstanceEntity entity) {
    insert(cast(HistoricActivityInstanceEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public HistoricActivityInstanceEntity update(HistoricActivityInstanceEntity entity) {
    return  update(cast(HistoricActivityInstanceEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    HistoricActivityInstanceEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(HistoricActivityInstanceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(HistoricActivityInstanceEntity entity) {
    if (entity !is null)
    {
      remove(cast(HistoricActivityInstanceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    //
    //class<? : HistoricActivityInstanceEntity> getManagedEntityClass() {
    //    return HistoricActivityInstanceEntityImpl.class;
    //}


    public HistoricActivityInstanceEntity create() {
        return new HistoricActivityInstanceEntityImpl();
    }


    public List!HistoricActivityInstanceEntity findUnfinishedHistoricActivityInstancesByExecutionAndActivityId( string executionId,  string activityId) {
        scope(exit)
        {
          _manager.close();
        }

        HistoricActivityInstanceEntityImpl[] array =  _manager.createQuery!(HistoricActivityInstanceEntityImpl)("SELECT * FROM HistoricActivityInstanceEntityImpl u WHERE u.executionId = :executionId and u.activityId = :activityId and u.endTime is null")
        .setParameter("executionId",executionId)
        .setParameter("activityId",activityId)
        .getResultList();
        return new ArrayList!string(array);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("activityId", activityId);
        //return getList("selectUnfinishedHistoricActivityInstanceExecutionIdAndActivityId", params, unfinishedHistoricActivityInstanceMatcher, true);
    }


    public List!HistoricActivityInstanceEntity findHistoricActivityInstancesByExecutionIdAndActivityId( string executionId,  string activityId) {

        scope(exit)
        {
          _manager.close();
        }

        HistoricActivityInstanceEntityImpl[] array =  _manager.createQuery!(HistoricActivityInstanceEntityImpl)("SELECT * FROM HistoricActivityInstanceEntityImpl u WHERE u.executionId = :executionId and u.activityId = :activityId")
        .setParameter("executionId",executionId)
        .setParameter("activityId",activityId)
        .getResultList();
        return new ArrayList!string(array);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("activityId", activityId);
        //return getList("selectHistoricActivityInstanceExecutionIdAndActivityId", params, historicActivityInstanceMatcher, true);
    }


    public List!HistoricActivityInstanceEntity findUnfinishedHistoricActivityInstancesByProcessInstanceId( string processInstanceId) {
        scope(exit)
        {
          _manager.close();
        }

        HistoricActivityInstanceEntityImpl[] array =  _manager.createQuery!(HistoricActivityInstanceEntityImpl)("SELECT * FROM HistoricActivityInstanceEntityImpl u WHERE u.processInstanceId = :processInstanceId and u.endTime is null")
        .setParameter("processInstanceId",processInstanceId)
        .getResultList();
        return new ArrayList!string(array);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("processInstanceId", processInstanceId);
        //return getList("selectUnfinishedHistoricActivityInstanceByProcessInstanceId", params, unfinishedHistoricActivityInstanceMatcher, true);
    }


    public void deleteHistoricActivityInstancesByProcessInstanceId(string historicProcessInstanceId) {
        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(HistoricActivityInstanceEntityImpl)("DELETE FROM HistoricActivityInstanceEntityImpl u WHERE u.processInstanceId = :processInstanceId");
        update.setParameter("processInstanceId",historicProcessInstanceId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteHistoricActivityInstancesByProcessInstanceId error : %s",e.msg);
        }
        //getDbSqlSession().delete("deleteHistoricActivityInstancesByProcessInstanceId", historicProcessInstanceId, HistoricActivityInstanceEntityImpl.class);
    }


    public long findHistoricActivityInstanceCountByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectHistoricActivityInstanceCountByQueryCriteria", historicActivityInstanceQuery);
    }


    public List!HistoricActivityInstance findHistoricActivityInstancesByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectList("selectHistoricActivityInstancesByQueryCriteria", historicActivityInstanceQuery);
    }


    public List!HistoricActivityInstance findHistoricActivityInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectListWithRawParameter("selectHistoricActivityInstanceByNativeQuery", parameterMap);
    }


    public long findHistoricActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoricActivityInstanceCountByNativeQuery", parameterMap);
    }


    public void deleteHistoricActivityInstances(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        implementationMissing(false);
       // getDbSqlSession().delete("bulkDeleteHistoricActivityInstances", historicActivityInstanceQuery, HistoricActivityInstanceEntityImpl.class);
    }


    public void deleteHistoricActivityInstancesForNonExistingProcessInstances() {
        implementationMissing(false);
       // getDbSqlSession().delete("bulkDeleteHistoricActivityInstancesForNonExistingProcessInstances", null, HistoricActivityInstanceEntityImpl.class);
    }

}
