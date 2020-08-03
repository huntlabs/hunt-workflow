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
module flow.task.service.impl.persistence.entity.data.impl.MybatisTaskDataManager;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.AbstractDataManager;
//import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.task.api.Task;
import flow.task.service.impl.TaskQueryImpl;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntityImpl;
import flow.task.service.impl.persistence.entity.data.TaskDataManager;
//import flow.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByExecutionIdMatcher;
//import flow.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByProcessInstanceIdMatcher;
//import flow.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByScopeIdAndScopeTypeMatcher;
//import flow.task.service.impl.persistence.entity.data.impl.cachematcher.TasksBySubScopeIdAndScopeTypeMatcher;
//import flow.task.service.impl.util.CommandContextUtil;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.engine.impl.util.CommandContextUtil;
import flow.common.persistence.entity.Entity;
import flow.common.context.Context;
import std.array;
/**
 * @author Joram Barrez
 */
class MybatisTaskDataManager : EntityRepository!( TaskEntityImpl , string) , TaskDataManager , DataManger{

    //protected CachedEntityMatcher!TaskEntity tasksByExecutionIdMatcher = new TasksByExecutionIdMatcher();
    //
    //protected CachedEntityMatcher!TaskEntity tasksByProcessInstanceIdMatcher = new TasksByProcessInstanceIdMatcher();
    //
    //protected CachedEntityMatcher!TaskEntity tasksBySubScopeIdAndScopeTypeMatcher = new TasksBySubScopeIdAndScopeTypeMatcher();
    //
    //protected CachedEntityMatcher!TaskEntity tasksByScopeIdAndScopeTypeMatcher = new TasksByScopeIdAndScopeTypeMatcher();
    //
    //
    //class<? extends TaskEntity> getManagedEntityClass() {
    //    return TaskEntityImpl.class;
    //}
    alias findById = CrudRepository!( TaskEntityImpl , string).findById;
    alias insert = CrudRepository!( TaskEntityImpl , string).insert;
    alias update = CrudRepository!( TaskEntityImpl , string).update;

  this()
    {
      super(entityManagerFactory.currentEntityManager());
    }


    TypeInfo getTypeInfo()
    {
      return typeid(MybatisTaskDataManager);
    }


  public TaskEntity findById(string entityId) {
    //if (entityId is null) {
    //  return null;
    //}
    //
    //return find(entityId);

      if (entityId is null) {
        return null;
      }

      //return find(entityId);
      auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(TaskEntityImpl),entityId);

      if (entity !is null)
      {
        return cast(TaskEntity)entity;
      }

      TaskEntity dbData = cast(TaskEntity)(find(entityId));
      if (dbData !is null)
      {
        CommandContextUtil.getEntityCache().put(dbData, true , typeid(TaskEntityImpl));
      }

      return dbData;


    // Cache
    //EntityImpl cachedEntity = getEntityCache().findInCache(getManagedEntityClass(), entityId);
    //if (cachedEntity !is null) {
    //  return cachedEntity;
    //}

    // Database
    //return getDbSqlSession().selectById(getManagedEntityClass(), entityId, false);
  }

    public void insert(TaskEntity entity) {
      if (entity.getId() is null)
      {
        string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
        //if (dbSqlSessionFactory.isUsePrefixId()) {
        //    id = entity.getIdPrefix() + id;
        //}
        entity.setId(id);

      }
      entity.setInserted(true);
      CommandContext.insertJob[entity] = this;
      CommandContextUtil.getEntityCache().put(entity, false, typeid(TaskEntityImpl));
    }

    public void insertTrans(Entity entity , EntityManager db)
    {
      //auto em = _manager ? _manager : createEntityManager;
      TaskEntityImpl tmp = cast(TaskEntityImpl)entity;
      db.persist!TaskEntityImpl(tmp);
    }

      public TaskEntity update(TaskEntity entity) {
        return  update(cast(TaskEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      public void dele(string id) {
        TaskEntity entity = findById(id);
        if (entity !is null)
        {
          CommandContext.deleteJob[entity] = this;
          entity.setDeleted(true);
          //remove(cast(TaskEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(TaskEntity entity) {
        if (entity !is null)
        {
          CommandContext.deleteJob[entity] = this;
          entity.setDeleted(true);
          //remove(cast(TaskEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }


    void deleteTrans(Entity entity , EntityManager db)
    {
       db.remove!TaskEntityImpl(cast(TaskEntityImpl)entity);
    }

    public TaskEntity create() {
        return new TaskEntityImpl();
    }


    public List!TaskEntity findTasksByExecutionId(string executionId) {
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the process instance has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    return getListFromCache(tasksByExecutionIdMatcher, executionId);
        //}
        //
        //return getList(dbSqlSession, "selectTasksByExecutionId", executionId, tasksByExecutionIdMatcher, true);
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(TaskEntityImpl)("SELECT distinct * FROM TaskEntityImpl u where u.executionId = :executionId");
        select.setParameter("executionId",executionId);
        TaskEntityImpl[] ls = select.getResultList();
        List!TaskEntity list = new ArrayList!TaskEntity;

        foreach(TaskEntityImpl h ; ls)
        {
          list.add(cast(TaskEntity)h);
        }

        foreach(TaskEntityImpl task ; ls)
        {
            foreach (k ,v ; CommandContext.deleteJob)
            {
                if (cast(TaskEntityImpl)k !is null && (cast(TaskEntityImpl)k).getId == task.getId)
                {
                    list.remove(cast(TaskEntity)task);
                }
            }
        }

        return list;
    }



    public List!TaskEntity findTasksByProcessInstanceId(string processInstanceId) {
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the process instance has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
        //    return getListFromCache(tasksByProcessInstanceIdMatcher, processInstanceId);
        //}
        //
        //return getList(dbSqlSession, "selectTasksByProcessInstanceId", processInstanceId, tasksByProcessInstanceIdMatcher, true);
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(TaskEntityImpl)("SELECT * FROM TaskEntityImpl u where u.processInstanceId = :processInstanceId");
        select.setParameter("processInstanceId",processInstanceId);
        TaskEntityImpl[] ls = select.getResultList();
        List!TaskEntity list = new ArrayList!TaskEntity;

        foreach(TaskEntityImpl h ; ls)
        {
          list.add(cast(TaskEntity)h);
        }

        return list;
    }


    public List!TaskEntity findTasksByScopeIdAndScopeType(string scopeId, string scopeType) {
        //Map!(string, string) params = new HashMap<>();
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectTasksByScopeIdAndScopeType", params, tasksByScopeIdAndScopeTypeMatcher, true);
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(TaskEntityImpl)("SELECT * FROM TaskEntityImpl u where u.scopeId = :scopeId and u.scopeType = :scopeType");
        select.setParameter("scopeId",scopeId);
        select.setParameter("scopeType",scopeType);
        TaskEntityImpl[] ls = select.getResultList();
        List!TaskEntity list = new ArrayList!TaskEntity;

        foreach(TaskEntityImpl h ; ls)
        {
          list.add(cast(TaskEntity)h);
        }

        return list;
    }


    public List!TaskEntity findTasksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
         scope(exit)
         {
           _manager.close();
         }
        auto select = _manager.createQuery!(TaskEntityImpl)("SELECT * FROM TaskEntityImpl u where u.subScopeId = :subScopeId and u.scopeType = :scopeType");
        select.setParameter("subScopeId",subScopeId);
        select.setParameter("scopeType",scopeType);
        TaskEntityImpl[] ls = select.getResultList();
         List!TaskEntity list = new ArrayList!TaskEntity;

         foreach(TaskEntityImpl h ; ls)
         {
           list.add(cast(TaskEntity)h);
         }

         return list;
        //Map!(string, string) params = new HashMap<>();
        //params.put("subScopeId", subScopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectTasksBySubScopeIdAndScopeType", params, tasksBySubScopeIdAndScopeTypeMatcher, true);
    }



    public List!Task findTasksByQueryCriteria(TaskQueryImpl taskQuery) {
        scope(exit)
        {
          _manager.close();
        }

        string[] strArray;
        foreach(string str ; taskQuery.getCandidateGroups)
        {
            strArray ~= "\"" ~ str ~ "\"";
        }

        TaskEntityImpl[] array =  _manager.createQuery!(TaskEntityImpl)("SELECT distinct RES FROM TaskEntityImpl RES WHERE (RES.assignee is null or RES.assignee = '') AND
          exists(select ID_ from testworkflow.ACT_RU_IDENTITYLINK  where TYPE_ = 'candidate' AND TASK_ID_ = RES.id AND (GROUP_ID_ in (" ~ strArray.join(",") ~ "))) order by RES.id asc")
        //.setParameter("group","\""~ taskQuery.getCandidateGroups.array.join(",") ~ "\"")
        .getResultList();

        List!Task rt = new ArrayList!Task;
        foreach(TaskEntityImpl t ; array)
        {
            rt.add(cast(Task)t);
        }
        return rt;

        //implementationMissing(false);
        //return null;
        //final string query = "selectTaskByQueryCriteria";
        //return getDbSqlSession().selectList(query, taskQuery, getManagedEntityClass());
    }



    public List!Task findTasksWithRelatedEntitiesByQueryCriteria(TaskQueryImpl taskQuery) {
        implementationMissing(false);
        return null;
        // string query = "selectTasksWithRelatedEntitiesByQueryCriteria";
        //// paging doesn't work for combining task instances and variables due to
        //// an outer join, so doing it in-memory
        //
        //int firstResult = taskQuery.getFirstResult();
        //int maxResults = taskQuery.getMaxResults();
        //
        //// setting max results, limit to 20000 results for performance reasons
        //if (taskQuery.getTaskVariablesLimit() !is null) {
        //    taskQuery.setMaxResults(taskQuery.getTaskVariablesLimit());
        //} else {
        //    taskQuery.setMaxResults(CommandContextUtil.getTaskServiceConfiguration().getTaskQueryLimit());
        //}
        //taskQuery.setFirstResult(0);
        //
        //List!Task instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(query, taskQuery, getManagedEntityClass());
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


    public long findTaskCountByQueryCriteria(TaskQueryImpl taskQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectTaskCountByQueryCriteria", taskQuery);
    }



    public List!Task findTasksByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectTaskByNativeQuery", parameterMap);
    }


    public long findTaskCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectTaskCountByNativeQuery", parameterMap);
    }



    public List!Task findTasksByParentTaskId(string parentTaskId) {
        //return getDbSqlSession().selectList("selectTasksByParentTaskId", parentTaskId);
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(TaskEntityImpl)("SELECT * FROM TaskEntityImpl u where u.parentTaskId = :parentTaskId");
        select.setParameter("parentTaskId",parentTaskId);
        TaskEntityImpl[] ls = select.getResultList();
        List!Task list = new ArrayList!Task;

        foreach(TaskEntityImpl h ; ls)
        {
          list.add(cast(Task)h);
        }

        return list;
    }


    public void updateTaskTenantIdForDeployment(string deploymentId, string newTenantId) {
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateTaskTenantIdForDeployment", params);
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(TaskEntityImpl)(" update TaskEntityImpl u set u.tenantId = :tenantId where  " ~
        "u.id in ( SELECT tempTask.tempId from (SELECT T.id as tempId from TaskEntityImpl inner join ACT_RE_PROCDEF P ON T.processInstanceId = P.id" ~
        " inner join ACT_RE_DEPLOYMENT D on P.deloymentId = D.id WHERE D.id = :deploymentId) AS tempTask )");
        update.setParameter("tenantId",newTenantId);
        update.setParameter("deploymentId",deploymentId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("updateTaskTenantIdForDeployment error : %s",e.msg);
        }
    }


    public void updateAllTaskRelatedEntityCountFlags(bool newValue) {
        //getDbSqlSession().update("updateTaskRelatedEntityCountEnabled", newValue);
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(TaskEntityImpl)(" update TaskEntityImpl u set u.isCountEnabled = :isCountEnabled" );
        update.setParameter("isCountEnabled",newValue);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("updateAllTaskRelatedEntityCountFlags error : %s",e.msg);
        }
    }


    public void deleteTasksByExecutionId(string executionId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(TaskEntityImpl)(" DELETE FROM TaskEntityImpl u WHERE u.executionId = :executionId" );
        update.setParameter("executionId",executionId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteTasksByExecutionId error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    deleteCachedEntities(dbSqlSession, tasksByExecutionIdMatcher, executionId);
        //} else {
        //    bulkDelete("deleteTasksByExecutionId", tasksByExecutionIdMatcher, executionId);
        //}
    }

}
