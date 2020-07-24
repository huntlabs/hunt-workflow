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
module flow.engine.impl.persistence.entity.data.impl.MybatisExecutionDataManager;
import flow.common.context.Context;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableOptimisticLockingException;
import flow.common.db.SingleCachedEntityMatcher;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.cfg.PerformanceSettings;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ExecutionDataManager;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionByProcessInstanceMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByParentExecutionIdAndActivityIdEntityMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByParentExecutionIdEntityMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByProcessInstanceIdEntityMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByRootProcessInstanceMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsWithSameRootProcessInstanceIdMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsByProcInstMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsInActivityAndProcInstMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsInActivityMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.ProcessInstancesByProcessDefinitionMatcher;
//import flow.engine.impl.persistence.entity.data.impl.cachematcher.SubProcessInstanceExecutionBySuperExecutionIdMatcher;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
import hunt.collection.ArrayList;
import hunt.entity;
/**
 * @author Joram Barrez
 */
class MybatisExecutionDataManager : EntityRepository!(ExecutionEntityImpl , string) , ExecutionDataManager {
//class MybatisExecutionDataManager : AbstractProcessDataManager!ExecutionEntity implements ExecutionDataManager {

    alias findById = CrudRepository!(ExecutionEntityImpl , string).findById;
    alias insert = CrudRepository!(ExecutionEntityImpl , string).insert;
    alias update = CrudRepository!(ExecutionEntityImpl , string).update;
    protected PerformanceSettings performanceSettings;

     private ProcessEngineConfigurationImpl processEngineConfiguration;


    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
      return processEngineConfiguration;
    }

    public Clockm getClock() {
      return processEngineConfiguration.getClock();
    }

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
      this.processEngineConfiguration = processEngineConfiguration;
      this.performanceSettings = processEngineConfiguration.getPerformanceSettings();
      super(entityManagerFactory.currentEntityManager());
    }

    //protected CachedEntityMatcher!ExecutionEntity executionsByParentIdMatcher = new ExecutionsByParentExecutionIdEntityMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity executionsByProcessInstanceIdMatcher = new ExecutionsByProcessInstanceIdEntityMatcher();
    //
    //protected SingleCachedEntityMatcher!ExecutionEntity subProcessInstanceBySuperExecutionIdMatcher = new SubProcessInstanceExecutionBySuperExecutionIdMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity executionsWithSameRootProcessInstanceIdMatcher = new ExecutionsWithSameRootProcessInstanceIdMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity inactiveExecutionsInActivityAndProcInstMatcher = new InactiveExecutionsInActivityAndProcInstMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity inactiveExecutionsByProcInstMatcher = new InactiveExecutionsByProcInstMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity inactiveExecutionsInActivityMatcher = new InactiveExecutionsInActivityMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity executionByProcessInstanceMatcher = new ExecutionByProcessInstanceMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity executionsByRootProcessInstanceMatcher = new ExecutionsByRootProcessInstanceMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity executionsByParentExecutionIdAndActivityIdEntityMatcher = new ExecutionsByParentExecutionIdAndActivityIdEntityMatcher();
    //
    //protected CachedEntityMatcher!ExecutionEntity processInstancesByProcessDefinitionMatcher = new ProcessInstancesByProcessDefinitionMatcher();

    //this(ProcessEngineConfigurationImpl processEngineConfiguration) {
    //    super(processEngineConfiguration);
    //    this.performanceSettings = processEngineConfiguration.getPerformanceSettings();
    //}

    //
    //class<? : ExecutionEntity> getManagedEntityClass() {
    //    return ExecutionEntityImpl.class;
    //}

  //
  public void insert(ExecutionEntity entity) {
    if (entity.getId() is null)
    {
      string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
      //if (dbSqlSessionFactory.isUsePrefixId()) {
      //    id = entity.getIdPrefix() + id;
      //}
      entity.setId(id);

    }
    //ResourceEntityImpl tmp = cast(ResourceEntityImpl)entity;
    insert(cast(ExecutionEntityImpl)entity);
    //insert(cast(ExecutionEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public ExecutionEntity update(ExecutionEntity entity) {
    return  update(cast(ExecutionEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ExecutionEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(ExecutionEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ExecutionEntity entity) {
    if (entity !is null)
    {
      remove(cast(ExecutionEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

  public ExecutionEntity findById(string executionId) {
    //if (isExecutionTreeFetched(executionId)) {
    //    return getEntityCache().findInCache(getManagedEntityClass(), executionId);
    //}
    //return super.findById(executionId);
    return find(executionId);
  }

    public ExecutionEntity create() {
        return ExecutionEntityImpl.createWithEmptyRelationshipCollections();
    }




    /**
     * Fetches the execution tree related to the execution (if the process definition has been configured to do so)
     * @return True if the tree has been fetched, false otherwise or if fetching is disabled.
     */
    protected bool isExecutionTreeFetched( string executionId) {
        implementationMissing(false);
        return false;
        // The setting needs to be globally enabled
        //if (!performanceSettings.isEnableEagerExecutionTreeFetching()) {
        //    return false;
        //}
        //
        //// Need to get the cache result before doing the findById
        //ExecutionEntity cachedExecutionEntity = getEntityCache().findInCache(getManagedEntityClass(), executionId);
        //
        //// Find execution in db or cache to check process definition setting for execution fetch.
        //// If not set, no extra work is done. The execution is in the cache however now as a side-effect of calling this method.
        //ExecutionEntity executionEntity = (cachedExecutionEntity !is null) ? cachedExecutionEntity : super.findById(executionId);
        //if (!ProcessDefinitionUtil.getProcess(executionEntity.getProcessDefinitionId()).isEnableEagerExecutionTreeFetching()) {
        //    return false;
        //}
        //
        //// If it's in the cache, the execution and its tree have been fetched before. No need to do anything more.
        //if (cachedExecutionEntity !is null) {
        //    return true;
        //}
        //
        //// Fetches execution tree. This will store them in the cache and thus avoind extra database calls.
        //getList("selectExecutionsWithSameRootProcessInstanceId", executionId,
        //        executionsWithSameRootProcessInstanceIdMatcher, true);
        //
        //return true;
    }


    public ExecutionEntity findSubProcessInstanceBySuperExecutionId(string superExecutionId) {
        implementationMissing(false);
        return null;
        //bool treeFetched = isExecutionTreeFetched(superExecutionId);
        //return getEntity("selectSubProcessInstanceBySuperExecutionId",
        //        superExecutionId,
        //        subProcessInstanceBySuperExecutionIdMatcher,
        //        !treeFetched);
    }


    public List!ExecutionEntity findChildExecutionsByParentExecutionId( string parentExecutionId) {
        ExecutionEntityImpl[] array = (findAll(new Condition("%s = %s" , Field.parentId , parentExecutionId)));

        List!ExecutionEntity list = new ArrayList!ExecutionEntity;
        foreach(ExecutionEntityImpl e ; array)
        {
            list.add(cast(ExecutionEntity)e);
        }
        return list;
        //if (isExecutionTreeFetched(parentExecutionId)) {
        //    return getListFromCache(executionsByParentIdMatcher, parentExecutionId);
        //} else {
        //    return getList("selectExecutionsByParentExecutionId", parentExecutionId, executionsByParentIdMatcher, true);
        //}
    }


    public List!ExecutionEntity findChildExecutionsByProcessInstanceId( string processInstanceId) {
        scope(exit)
        {
          _manager.close();
        }

        ExecutionEntityImpl[] array =  _manager.createQuery!(ExecutionEntityImpl)("SELECT * FROM ExecutionEntityImpl u WHERE u.processInstanceId = :processInstanceId and parentId is not null")
        .setParameter("processInstanceId",processInstanceId)
        .getResultList();

        List!ExecutionEntity list = new ArrayList!ExecutionEntity;

        foreach(ExecutionEntityImpl e ; array)
        {
            list.add(cast(ExecutionEntity) e);
        }
        return list;
        //return new ArrayList!ExecutionEntityImpl(array);
        //if (isExecutionTreeFetched(processInstanceId)) {
        //    return getListFromCache(executionsByProcessInstanceIdMatcher, processInstanceId);
        //} else {
        //    return getList("selectChildExecutionsByProcessInstanceId", processInstanceId, executionsByProcessInstanceIdMatcher, true);
        //}
    }


    public List!ExecutionEntity findExecutionsByParentExecutionAndActivityIds( string parentExecutionId,  Collection!string activityIds) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) parameters = new HashMap!(string, Object)(2);
        //parameters.put("parentExecutionId", parentExecutionId);
        //parameters.put("activityIds", activityIds);
        //
        //if (isExecutionTreeFetched(parentExecutionId)) {
        //    return getListFromCache(executionsByParentExecutionIdAndActivityIdEntityMatcher, parameters);
        //} else {
        //    return getList("selectExecutionsByParentExecutionAndActivityIds", parameters, executionsByParentExecutionIdAndActivityIdEntityMatcher, true);
        //}
    }


    public List!ExecutionEntity findExecutionsByRootProcessInstanceId( string rootProcessInstanceId) {
        ExecutionEntityImpl[] array =  findAll(new Condition("%s = %s" , Field.rootProcessInstanceId , rootProcessInstanceId));
        List!ExecutionEntity list = new ArrayList!ExecutionEntity;

        foreach(ExecutionEntityImpl e ; array)
        {
            list.add(cast(ExecutionEntity)e);
        }

        return list;
        //if (isExecutionTreeFetched(rootProcessInstanceId)) {
        //    return getListFromCache(executionsByRootProcessInstanceMatcher, rootProcessInstanceId);
        //} else {
        //    return getList("selectExecutionsByRootProcessInstanceId", rootProcessInstanceId, executionsByRootProcessInstanceMatcher, true);
        //}
    }


    public List!ExecutionEntity findExecutionsByProcessInstanceId( string processInstanceId) {
        ExecutionEntityImpl[] array =  findAll(new Condition("%s = %s" , Field.processInstanceId , processInstanceId));
        List!ExecutionEntity list = new ArrayList!ExecutionEntity;
        foreach(ExecutionEntityImpl e ; array)
        {
          list.add(cast(ExecutionEntity)e);
        }

        return list;

        //if (isExecutionTreeFetched(processInstanceId)) {
        //    return getListFromCache(executionByProcessInstanceMatcher, processInstanceId);
        //} else {
        //    return getList("selectExecutionsByProcessInstanceId", processInstanceId, executionByProcessInstanceMatcher, true);
        //}
    }


    public Collection!ExecutionEntity findInactiveExecutionsByProcessInstanceId( string processInstanceId) {
        ExecutionEntityImpl[] array = findAll(new Condition("%s = %s and %s = %s " , Field.processInstanceId , processInstanceId ,Field._isActive, false));
        List!ExecutionEntity list = new ArrayList!ExecutionEntity;
        foreach(ExecutionEntityImpl e ; array)
        {
          list.add(cast(ExecutionEntity)e);
        }

        return list;
        //HashMap!(string, Object) params = new HashMap<>(2);
        //params.put("processInstanceId", processInstanceId);
        //params.put("isActive", false);
        //
        //if (isExecutionTreeFetched(processInstanceId)) {
        //    return getListFromCache(inactiveExecutionsByProcInstMatcher, params);
        //} else {
        //    return getList("selectInactiveExecutionsForProcessInstance", params, inactiveExecutionsByProcInstMatcher, true);
        //}
    }


    public Collection!ExecutionEntity findInactiveExecutionsByActivityIdAndProcessInstanceId( string activityId,  string processInstanceId) {

        ExecutionEntityImpl[] array = findAll(new Condition("%s = %s and %s = %s and %s = %s" , Field.activityId , activityId ,Field.processInstanceId, processInstanceId ,Field._isActive, false));
        List!ExecutionEntity list = new ArrayList!ExecutionEntity;
        foreach(ExecutionEntityImpl e ; array)
        {
          list.add(cast(ExecutionEntity)e);
        }

        return list;
       //HashMap!(string, Object) params = new HashMap<>(3);
        //params.put("activityId", activityId);
        //params.put("processInstanceId", processInstanceId);
        //params.put("isActive", false);
        //
        //if (isExecutionTreeFetched(processInstanceId)) {
        //    return getListFromCache(inactiveExecutionsInActivityAndProcInstMatcher, params);
        //} else {
        //    return getList("selectInactiveExecutionsInActivityAndProcessInstance", params, inactiveExecutionsInActivityAndProcInstMatcher, true);
        //}
    }

    public List!string findProcessInstanceIdsByProcessDefinitionId(string processDefinitionId) {
      scope(exit)
      {
        _manager.close();
      }

      ExecutionEntityImpl[] array =  _manager.createQuery!(ExecutionEntityImpl)("SELECT id FROM ExecutionEntityImpl u WHERE u.processInstanceId = :processInstanceId and parentId is null")
      .setParameter("processInstanceId",processDefinitionId)
      .getResultList();
      List!string list = new ArrayList!string;
      foreach(ExecutionEntityImpl e ; array)
      {
          list.add(e.id);
      }
      return list;

     // return new ArrayList!string(array);
        //return getDbSqlSession().selectListNoCacheLoadAndStore("selectProcessInstanceIdsByProcessDefinitionId", processDefinitionId);
    }


    public long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectExecutionCountByQueryCriteria", executionQuery);
    }


    public List!ExecutionEntity findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery) {
        implementationMissing(false);
        return null;
        // False -> executions should not be cached if using executionTreeFetching
        //bool useCache = !performanceSettings.isEnableEagerExecutionTreeFetching();
        //if (useCache) {
        //    return getDbSqlSession().selectList("selectExecutionsByQueryCriteria", executionQuery, getManagedEntityClass());
        //} else {
        //    return getDbSqlSession().selectListNoCacheLoadAndStore("selectExecutionsByQueryCriteria", executionQuery);
        //}
    }


    public long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectProcessInstanceCountByQueryCriteria", executionQuery);
    }


    public List!ProcessInstance findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        // False -> executions should not be cached if using executionTreeFetching
        //bool useCache = !performanceSettings.isEnableEagerExecutionTreeFetching();
        //if (useCache) {
        //    return getDbSqlSession().selectList("selectProcessInstanceByQueryCriteria", executionQuery, getManagedEntityClass());
        //} else {
        //    return getDbSqlSession().selectListNoCacheLoadAndStore("selectProcessInstanceByQueryCriteria", executionQuery, getManagedEntityClass());
        //}
        implementationMissing(false);
        return null;
    }


    public List!ProcessInstance findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        // paging doesn't work for combining process instances and variables due
        // to an outer join, so doing it in-memory
        implementationMissing(false);
        return null;

        //int firstResult = executionQuery.getFirstResult();
        //int maxResults = executionQuery.getMaxResults();
        //
        //// setting max results, limit to 20000 results for performance reasons
        //if (executionQuery.getProcessInstanceVariablesLimit() !is null) {
        //    executionQuery.setMaxResults(executionQuery.getProcessInstanceVariablesLimit());
        //} else {
        //    executionQuery.setMaxResults(getProcessEngineConfiguration().getExecutionQueryLimit());
        //}
        //executionQuery.setFirstResult(0);
        //
        //List!ProcessInstance instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(
        //                "selectProcessInstanceWithVariablesByQueryCriteria", executionQuery, getManagedEntityClass());
        //
        //if (instanceList !is null && !instanceList.isEmpty()) {
        //    if (firstResult > 0) {
        //        if (firstResult <= instanceList.size()) {
        //            int toIndex = firstResult + Math.min(maxResults, instanceList.size() - firstResult);
        //            return instanceList.subList(firstResult, toIndex);
        //        } else {
        //            return Collections.EMPTY_LIST;
        //        }
        //    } else {
        //        int toIndex = maxResults > 0 ?  Math.min(maxResults, instanceList.size()) : instanceList.size();
        //        return instanceList.subList(0, toIndex);
        //    }
        //}
        //return Collections.EMPTY_LIST;
    }


    public List!Execution findExecutionsByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectExecutionByNativeQuery", parameterMap);
    }


    public List!ProcessInstance findProcessInstanceByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectExecutionByNativeQuery", parameterMap);
    }


    public long findExecutionCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectExecutionCountByNativeQuery", parameterMap);
    }


    public void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId) {
        implementationMissing(false);
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateExecutionTenantIdForDeployment", params);
    }


    public void updateProcessInstanceLockTime(string processInstanceId, Date lockDate, Date expirationTime) {
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("id", processInstanceId);
        //params.put("lockTime", lockDate);
        //params.put("expirationTime", expirationTime);
        //
        //int result = getDbSqlSession().update("updateProcessInstanceLockTime", params);
        //if (result == 0) {
        //    throw new FlowableOptimisticLockingException("Could not lock process instance");
        //}

      scope(exit)
      {
        _manager.close();
      }
      auto update = _manager.createQuery!(ExecutionEntityImpl)(" update ExecutionEntityImpl u set u.lockTime = :lockTime where  " ~
      "u.id = :id AND (lockTime is null OR u.lockTime < :expirationTime)");
      update.setParameter("lockTime",lockDate.toEpochMilli / 1000);
      update.setParameter("expirationTime",expirationTime.toEpochMilli / 1000);
      try{
        update.exec();
      }
      catch(Exception e)
      {
        logError("updateTaskTenantIdForDeployment error : %s",e.msg);
      }
    }


    public void updateAllExecutionRelatedEntityCountFlags(bool newValue) {
       // getDbSqlSession().update("updateExecutionRelatedEntityCountEnabled", newValue);
      scope(exit)
      {
        _manager.close();
      }
      auto update = _manager.createQuery!(ExecutionEntityImpl)(" update ExecutionEntityImpl u set u.isCountEnabled = :isCountEnabled");
      update.setParameter("isCountEnabled",newValue);
      try{
        update.exec();
      }
      catch(Exception e)
      {
        logError("updateAllExecutionRelatedEntityCountFlags error : %s",e.msg);
      }
    }


    public void clearProcessInstanceLockTime(string processInstanceId) {
      scope(exit)
      {
        _manager.close();
      }
      auto update = _manager.createQuery!(ExecutionEntityImpl)("update ExecutionEntityImpl u set u.lockTime = null where u.id = :id");
      update.setParameter("id",processInstanceId);
      try{
        update.exec();
      }
      catch(Exception e)
      {
        logError("clearProcessInstanceLockTime error : %s",e.msg);
      }
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("id", processInstanceId);
        //getDbSqlSession().update("clearProcessInstanceLockTime", params);
    }

}
