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
import flow.common.runtime.Clockm;
import hunt.logging;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import flow.engine.impl.util.CommandContextUtil;
/**
 * @author Joram Barrez
 */
class MybatisHistoricActivityInstanceDataManager : EntityRepository!(HistoricActivityInstanceEntityImpl , string) , HistoricActivityInstanceDataManager ,DataManger{

    //protected CachedEntityMatcher!HistoricActivityInstanceEntity unfinishedHistoricActivityInstanceMatcher = new UnfinishedHistoricActivityInstanceMatcher();
    //protected CachedEntityMatcher!HistoricActivityInstanceEntity historicActivityInstanceMatcher = new HistoricActivityInstanceMatcher();
    alias findById = CrudRepository!(HistoricActivityInstanceEntityImpl , string).findById;
    alias insert = CrudRepository!(HistoricActivityInstanceEntityImpl , string).insert;
    alias update = CrudRepository!(HistoricActivityInstanceEntityImpl , string).update;

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

    TypeInfo getTypeInfo()
    {
      return typeid(MybatisHistoricActivityInstanceDataManager);
    }

    //class<? : ResourceEntity> getManagedEntityClass() {
    //    return ResourceEntityImpl.class;
    //}

  public HistoricActivityInstanceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(HistoricActivityInstanceEntityImpl),entityId);

    if (entity !is null)
    {
        return cast(HistoricActivityInstanceEntity)entity;
    }

    HistoricActivityInstanceEntity dbData = cast(HistoricActivityInstanceEntity)(find(entityId));
    if (dbData !is null)
    {
      CommandContextUtil.getEntityCache().put(dbData, true , typeid(HistoricActivityInstanceEntityImpl), this);
    }

    return dbData;
  }
  //
  public void insert(HistoricActivityInstanceEntity entity) {
    //insert(cast(HistoricActivityInstanceEntityImpl)entity);
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
    CommandContextUtil.getEntityCache().put(entity, false, typeid(HistoricActivityInstanceEntityImpl), this);
  }

  public void insertTrans(Entity entity , EntityManager db)
  {
    //auto em = _manager ? _manager : createEntityManager;
    HistoricActivityInstanceEntityImpl tmp = cast(HistoricActivityInstanceEntityImpl)entity;
    db.persist!HistoricActivityInstanceEntityImpl(tmp);
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
        deleteJob[entity] = this;
        entity.setDeleted(true);
      //remove(cast(HistoricActivityInstanceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(HistoricActivityInstanceEntity entity) {
    if (entity !is null)
    {
        deleteJob[entity] = this;
        entity.setDeleted(true);
      //remove(cast(HistoricActivityInstanceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!HistoricActivityInstanceEntityImpl(cast(HistoricActivityInstanceEntityImpl)entity);
    }


    public void updateTrans(Entity entity , EntityManager db)
    {
      db.merge!HistoricActivityInstanceEntityImpl(cast(HistoricActivityInstanceEntityImpl)entity);
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

         List!HistoricActivityInstanceEntity list = new ArrayList!HistoricActivityInstanceEntity;

        foreach(HistoricActivityInstanceEntityImpl h ; array)
        {
            list.add(cast(HistoricActivityInstanceEntity)h);
        }
        return list;
        //return new ArrayList!string(array);
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
        List!HistoricActivityInstanceEntity list = new ArrayList!HistoricActivityInstanceEntity;
        foreach(HistoricActivityInstanceEntityImpl h ; array)
        {
            list.add(cast(HistoricActivityInstanceEntity)h);
        }
        return list;
        //return new ArrayList!string(array);
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
        List!HistoricActivityInstanceEntity list = new ArrayList!HistoricActivityInstanceEntity;
        foreach(HistoricActivityInstanceEntityImpl h ; array)
        {
          list.add(cast(HistoricActivityInstanceEntity)h);
        }
        return list;

        //return new ArrayList!string(array);
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
