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
module flow.engine.impl.persistence.entity.data.impl.MybatisActivityInstanceDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.impl.ActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
import flow.engine.impl.persistence.entity.ActivityInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ActivityInstanceDataManager;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ActivityInstanceMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.UnfinishedActivityInstanceMatcher;
import flow.engine.runtime.ActivityInstance;
import hunt.entity;
import hunt.collection.ArrayList;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
/**
 * @author martin.grofcik
 */
class MybatisActivityInstanceDataManager : EntityRepository!(ActivityInstanceEntityImpl , string) , ActivityInstanceDataManager {

    //protected CachedEntityMatcher!ActivityInstanceEntity unfinishedActivityInstanceMatcher = new UnfinishedActivityInstanceMatcher();
    //protected CachedEntityMatcher!ActivityInstanceEntity activityInstanceMatcher = new ActivityInstanceMatcher();
    //protected CachedEntityMatcher!ActivityInstanceEntity activitiesByProcessInstanceIdMatcher = new ActivityByProcessInstanceIdMatcher();

     private ProcessEngineConfigurationImpl processEngineConfiguration;


    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
      return processEngineConfiguration;
    }

    public Clockm getClock() {
      return processEngineConfiguration.getClock();
    }

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
      this.processEngineConfiguration = processEngineConfiguration;
      super(entityManagerFactory.currentEntityManager());
    }


    //class<? : ResourceEntity> getManagedEntityClass() {
    //    return ResourceEntityImpl.class;
    //}

  public ActivityInstanceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(ActivityInstanceEntity entity) {
    insert(cast(ActivityInstanceEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public ActivityInstanceEntity update(ActivityInstanceEntity entity) {
    return  update(cast(ActivityInstanceEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ActivityInstanceEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(ActivityInstanceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ActivityInstanceEntity entity) {
    if (entity !is null)
    {
      remove(cast(ActivityInstanceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }


    public ActivityInstanceEntity create() {
        return new ActivityInstanceEntityImpl();
    }


    public List!ActivityInstanceEntity findUnfinishedActivityInstancesByExecutionAndActivityId( string executionId,  string activityId) {
      scope(exit)
      {
        _manager.close();
      }

      ActivityInstanceEntityImpl[] array =  _manager.createQuery!(ActivityInstanceEntityImpl)("SELECT * FROM ActivityInstanceEntityImpl u WHERE u.executionId = :executionId AND u.activityId = :activityId AND endTime is null")
      .setParameter("executionId",executionId)
      .setParameter("activityId",activityId)
      .getResultList();

      List!ActivityInstanceEntity rt = new ArrayList!ActivityInstanceEntity;

      foreach(ActivityInstanceEntityImpl a; array)
      {
          rt.add(cast(ActivityInstanceEntity)a);
      }
      return rt;
      //return new ArrayList!ActivityInstanceEntityImpl(array);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("activityId", activityId);
        //return getList("selectUnfinishedActivityInstanceExecutionIdAndActivityId", params, unfinishedActivityInstanceMatcher, true);
    }


    public List!ActivityInstanceEntity findActivityInstancesByExecutionIdAndActivityId( string executionId,  string activityId) {
        scope(exit)
        {
          _manager.close();
        }

        ActivityInstanceEntityImpl[] array =  _manager.createQuery!(ActivityInstanceEntityImpl)("SELECT * FROM ActivityInstanceEntityImpl u WHERE u.executionId = :executionId AND u.activityId = :activityId")
        .setParameter("executionId",executionId)
        .setParameter("activityId",activityId)
        .getResultList();

        List!ActivityInstanceEntity list = new ArrayList!ActivityInstanceEntity;

        foreach(ActivityInstanceEntityImpl a; array)
        {
            list.add(cast(ActivityInstanceEntity)a);
        }

        return list;

        //return new ArrayList!ActivityInstanceEntityImpl(array);
        //Map!(string, Object) params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("activityId", activityId);
        //return getList("selectActivityInstanceExecutionIdAndActivityId", params, activityInstanceMatcher, true);
    }


    public void deleteActivityInstancesByProcessInstanceId(string processInstanceId) {

        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(ActivityInstanceEntityImpl)("DELETE FROM ActivityInstanceEntityImpl u WHERE u.processInstanceId = :processInstanceId");
        update.setParameter("processInstanceId",processInstanceId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteActivityInstancesByProcessInstanceId error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //deleteCachedEntities(dbSqlSession, activitiesByProcessInstanceIdMatcher, processInstanceId);
        //if (!isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
        //    dbSqlSession.delete("deleteActivityInstancesByProcessInstanceId", processInstanceId, ActivityInstanceEntityImpl.class);
        //}
    }


    public long findActivityInstanceCountByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectActivityInstanceCountByQueryCriteria", activityInstanceQuery);
    }


    public List!ActivityInstance findActivityInstancesByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectActivityInstancesByQueryCriteria", activityInstanceQuery);
    }


    public List!ActivityInstance findActivityInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectActivityInstanceByNativeQuery", parameterMap);
    }


    public long findActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectActivityInstanceCountByNativeQuery", parameterMap);
    }

}
