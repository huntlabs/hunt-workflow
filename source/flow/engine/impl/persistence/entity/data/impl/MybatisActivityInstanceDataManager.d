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

//import flow.common.db.DbSqlSession;
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
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import flow.engine.impl.util.CommandContextUtil;
/**
 * @author martin.grofcik
 */
class MybatisActivityInstanceDataManager : EntityRepository!(ActivityInstanceEntityImpl , string) , ActivityInstanceDataManager, DataManger {

    //protected CachedEntityMatcher!ActivityInstanceEntity unfinishedActivityInstanceMatcher = new UnfinishedActivityInstanceMatcher();
    //protected CachedEntityMatcher!ActivityInstanceEntity activityInstanceMatcher = new ActivityInstanceMatcher();
    //protected CachedEntityMatcher!ActivityInstanceEntity activitiesByProcessInstanceIdMatcher = new ActivityByProcessInstanceIdMatcher();

     alias findById = CrudRepository!(ActivityInstanceEntityImpl , string).findById;
     alias insert = CrudRepository!(ActivityInstanceEntityImpl , string).insert;
     alias update = CrudRepository!(ActivityInstanceEntityImpl , string).update;

     private ProcessEngineConfigurationImpl processEngineConfiguration;

    TypeInfo getTypeInfo()
    {
      return typeid(MybatisActivityInstanceDataManager);
    }

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

    //return find(entityId);
    auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(ActivityInstanceEntityImpl),entityId);

    if (entity !is null)
    {
      return cast(ActivityInstanceEntity)entity;
    }

    ActivityInstanceEntity dbData = cast(ActivityInstanceEntity)(find(entityId));
    if (dbData !is null)
    {
      CommandContextUtil.getEntityCache().put(dbData, true , typeid(ActivityInstanceEntityImpl),this);
    }

    return dbData;
  }
  //
  public void insert(ActivityInstanceEntity entity) {
    //insert(cast(ActivityInstanceEntityImpl)entity);
    //getDbSqlSession().insert(entity);
      if (entity.getId() is null) {
        string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
        //if (dbSqlSessionFactory.isUsePrefixId()) {
        //    id = entity.getIdPrefix() + id;
        //}
        entity.setId(id);
      }
      entity.setInserted(true);
      insertJob[entity] = this;
      CommandContextUtil.getEntityCache().put(entity, false, typeid(ActivityInstanceEntityImpl),this);
  }

    public void insertTrans(Entity entity , EntityManager db)
    {
      //auto em = _manager ? _manager : createEntityManager;
      ActivityInstanceEntityImpl tmp = cast(ActivityInstanceEntityImpl)entity;
      db.persist!ActivityInstanceEntityImpl(tmp);
    }

    public void updateTrans(Entity entity , EntityManager db)
    {
      db.merge!ActivityInstanceEntityImpl(cast(ActivityInstanceEntityImpl)entity);
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
      deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(ActivityInstanceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ActivityInstanceEntity entity) {
    if (entity !is null)
    {
      deleteJob[entity] = this;
      entity.setDeleted(true);
     // remove(cast(ActivityInstanceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!ActivityInstanceEntityImpl(cast(ActivityInstanceEntityImpl)entity);
    }

    public ActivityInstanceEntity create() {
        return new ActivityInstanceEntityImpl();
    }


    public List!ActivityInstanceEntity findUnfinishedActivityInstancesByExecutionAndActivityId( string executionId,  string activityId) {
      scope(exit)
      {
        _manager.close();
      }

      ActivityInstanceEntityImpl[] array =  _manager.createQuery!(ActivityInstanceEntityImpl)("SELECT * FROM ActivityInstanceEntityImpl u WHERE u.executionId = :executionId AND u.activityId = :activityId AND u.endTime = 0")
      .setParameter("executionId",executionId)
      .setParameter("activityId",activityId)
      .getResultList();

      List!ActivityInstanceEntity rt = new ArrayList!ActivityInstanceEntity;

      foreach(ActivityInstanceEntityImpl a; array)
      {
          rt.add(cast(ActivityInstanceEntity)a);
          CommandContextUtil.getEntityCache().put(cast(ActivityInstanceEntity)a, false, typeid(ActivityInstanceEntityImpl),this);
      }

      foreach(ActivityInstanceEntityImpl task ; array)
      {
        foreach (k ,v ; deleteJob)
        {
          if (cast(ActivityInstanceEntityImpl)k !is null && (cast(ActivityInstanceEntityImpl)k).getId == task.getId)
          {
            rt.remove(cast(ActivityInstanceEntityImpl)task);
          }
        }
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
