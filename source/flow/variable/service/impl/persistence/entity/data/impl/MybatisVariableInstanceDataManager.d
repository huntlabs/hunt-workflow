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
module flow.variable.service.impl.persistence.entity.data.impl.MybatisVariableInstanceDataManager;

import std.array;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
import hunt.collection.ArrayList;
import flow.common.db.AbstractDataManager;
//import flow.common.db.DbSqlSession;
import flow.common.db.SingleCachedEntityMatcher;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityImpl;
import flow.variable.service.impl.persistence.entity.data.VariableInstanceDataManager;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceByExecutionIdMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceByScopeIdAndScopeTypeAndVariableNameMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceByScopeIdAndScopeTypeAndVariableNamesMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceByScopeIdAndScopeTypeMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceBySubScopeIdAndScopeTypeAndVariableNameMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceBySubScopeIdAndScopeTypeAndVariableNamesMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceBySubScopeIdAndScopeTypeMatcher;
//import flow.variable.service.impl.persistence.entity.data.impl.cachematcher.VariableInstanceByTaskIdMatcher;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisVariableInstanceDataManager : EntityRepository!( VariableInstanceEntityImpl , string), VariableInstanceDataManager {


    alias findById = CrudRepository!( VariableInstanceEntityImpl , string).findById;
    alias insert = CrudRepository!( VariableInstanceEntityImpl , string).insert;
    alias update = CrudRepository!( VariableInstanceEntityImpl , string).update;
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceByExecutionIdMatcher
    //    = new VariableInstanceByExecutionIdMatcher();
    //
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceByTaskIdMatcher
    //    = new VariableInstanceByTaskIdMatcher();
    //
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceByScopeIdAndScopeTypeMatcher
    //    = new VariableInstanceByScopeIdAndScopeTypeMatcher();
    //protected SingleCachedEntityMatcher!VariableInstanceEntity variableInstanceByScopeIdAndScopeTypeAndVariableNameMatcher
    //    = new VariableInstanceByScopeIdAndScopeTypeAndVariableNameMatcher();
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceByScopeIdAndScopeTypeAndVariableNamesMatcher
    //    = new VariableInstanceByScopeIdAndScopeTypeAndVariableNamesMatcher();
    //
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceBySubScopeIdAndScopeTypeMatcher
    //    = new VariableInstanceBySubScopeIdAndScopeTypeMatcher();
    //protected SingleCachedEntityMatcher!VariableInstanceEntity variableInstanceBySubScopeIdAndScopeTypeAndVariableNameMatcher
    //    = new VariableInstanceBySubScopeIdAndScopeTypeAndVariableNameMatcher();
    //protected CachedEntityMatcher!VariableInstanceEntity variableInstanceBySubScopeIdAndScopeTypeAndVariableNamesMatcher
    //    = new VariableInstanceBySubScopeIdAndScopeTypeAndVariableNamesMatcher();
    //
    //
    //public Class<? extends VariableInstanceEntity> getManagedEntityClass() {
    //    return VariableInstanceEntityImpl.class;
    //}
    this()
    {
      super(entityManagerFactory.currentEntityManager());
    }

       public VariableInstanceEntity findById(string entityId) {
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
      public void insert(VariableInstanceEntity entity) {
        insert(cast(VariableInstanceEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      public VariableInstanceEntity update(VariableInstanceEntity entity) {
        return  update(cast(VariableInstanceEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      public void dele(string id) {
        VariableInstanceEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(VariableInstanceEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(VariableInstanceEntity entity) {
        if (entity !is null)
        {
          remove(cast(VariableInstanceEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }


    public VariableInstanceEntity create() {
        VariableInstanceEntityImpl variableInstanceEntity = new VariableInstanceEntityImpl();
        variableInstanceEntity.setRevision(0); // For backwards compatibility, variables / HistoricVariableUpdate assumes revision 0 for the first time
        return variableInstanceEntity;
    }


    public List!VariableInstanceEntity findVariableInstancesByTaskId(string taskId) {
      VariableInstanceEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.taskId , taskId));

      List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
      foreach(VariableInstanceEntityImpl v ; objs)
      {
          list.add(cast(VariableInstanceEntity)v);
      }
      return list;
      //return new ArrayList!VariableInstanceEntity(objs);
       // return getList("selectVariablesByTaskId", taskId, variableInstanceByTaskIdMatcher, true);
    }



    public List!VariableInstanceEntity findVariableInstancesByTaskIds(Set!string taskIds) {
        List!VariableInstanceEntity lts = new ArrayList!VariableInstanceEntity;
        foreach (string taskId ; taskIds)
        {
            List!VariableInstanceEntity ls  = findVariableInstancesByTaskId(taskId);
            if (ls.size != 0)
            {
               lts.addAll(ls);
            }
        }
        return lts;
        //return getDbSqlSession().selectList("selectVariablesByTaskIds", taskIds);
    }


    public List!VariableInstanceEntity findVariableInstancesByExecutionId(string executionId) {
        //return getList("selectVariablesByExecutionId", executionId, variableInstanceByExecutionIdMatcher, true);
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.executionId = :executionId and u.taskId is null ");
        select.setParameter("executionId",executionId);
        VariableInstanceEntityImpl[] ls = select.getResultList();
        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list;
        //return new ArrayList!VariableInstanceEntity(ls);
    }



    public List!VariableInstanceEntity findVariableInstancesByExecutionIds(Set!string executionIds) {
        if (executionIds.size == 0)
        {
            return null;
        }
        scope(exit)
        {
          _manager.close();
        }

        VariableInstanceEntityImpl[] ls =  _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl a WHERE a.executionId IN (" ~ executionIds.toArray().join(",") ~ ") and u.taskId is null;")
        .getResultList();

        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list;
        //return new ArrayList!VariableInstanceEntity(ls);
       // return getDbSqlSession().selectList("selectVariablesByExecutionIds", executionIds);
    }


    public VariableInstanceEntity findVariableInstanceByExecutionAndName(string executionId, string variableName) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.executionId = :executionId and u.name = :variableName and u.taskId is null ");
        select.setParameter("executionId",executionId);
        select.setParameter("variableName",variableName);
        VariableInstanceEntityImpl[] ls = select.getResultList();

        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list.isEmpty()? null : list.get(0);
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(2);
        //params.put("executionId", executionId);
        //params.put("name", variableName);
        //return (VariableInstanceEntity) getDbSqlSession().selectOne("selectVariableInstanceByExecutionAndName", params);
    }



    public List!VariableInstanceEntity findVariableInstancesByExecutionAndNames(string executionId, Collection!string names) {
        implementationMissing(false);
        return null;
        //Map<string, Object> params = new HashMap<>(2);
        //params.put("executionId", executionId);
        //params.put("names", names);
        //return getDbSqlSession().selectList("selectVariableInstancesByExecutionAndNames", params);
    }


    public VariableInstanceEntity findVariableInstanceByTaskAndName(string taskId, string variableName) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.name = :variableName and u.taskId = :taskId ");
        select.setParameter("variableName",variableName);
        select.setParameter("taskId",taskId);
        VariableInstanceEntityImpl[] ls = select.getResultList();

        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list.isEmpty()? null : list.get(0);
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(2);
        //params.put("taskId", taskId);
        //params.put("name", variableName);
        //return (VariableInstanceEntity) getDbSqlSession().selectOne("selectVariableInstanceByTaskAndName", params);
    }



    public List!VariableInstanceEntity findVariableInstancesByTaskAndNames(string taskId, Collection!string names) {
        implementationMissing(false);
        return null;
        //Map<string, Object> params = new HashMap<>(2);
        //params.put("taskId", taskId);
        //params.put("names", names);
        //return getDbSqlSession().selectList("selectVariableInstancesByTaskAndNames", params);
    }


    public List!VariableInstanceEntity findVariableInstanceByScopeIdAndScopeType(string scopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.scopeId = :scopeId and u.scopeType = :scopeType and u.subScopeId is null");
        select.setParameter("scopeId",scopeId);
        select.setParameter("scopeType",scopeType);
        VariableInstanceEntityImpl[] ls = select.getResultList();
        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list;
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, Object> params = new HashMap<>(2);
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectVariableInstancesByScopeIdAndScopeType", params, variableInstanceByScopeIdAndScopeTypeMatcher, true);
    }


    public VariableInstanceEntity findVariableInstanceByScopeIdAndScopeTypeAndName(string scopeId, string scopeType, string variableName) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.scopeId = :scopeId and u.scopeType = :scopeType and u.name = :variableName and u.subScopeId is null");
        select.setParameter("scopeId",scopeId);
        select.setParameter("scopeType",scopeType);
        select.setParameter("variableName",variableName);
        VariableInstanceEntityImpl[] ls = select.getResultList();
        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list.isEmpty() ? null : list.get(0);
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(3);
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //params.put("variableName", variableName);
        //return getEntity("selectVariableInstanceByScopeIdAndScopeTypeAndName", params, variableInstanceByScopeIdAndScopeTypeAndVariableNameMatcher, true);
    }


    public List!VariableInstanceEntity findVariableInstancesByScopeIdAndScopeTypeAndNames(string scopeId, string scopeType, Collection!string variableNames) {
         implementationMissing(false);
         return null;
        //Map<string, Object> params = new HashMap<>(3);
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //params.put("variableNames", variableNames);
        //return getList("selectVariableInstanceByScopeIdAndScopeTypeAndNames", params, variableInstanceByScopeIdAndScopeTypeAndVariableNamesMatcher, true);
    }


    public List!VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.subScopeId = :subScopeId and u.scopeType = :scopeType");
        select.setParameter("subScopeId",subScopeId);
        select.setParameter("scopeType",scopeType);
        VariableInstanceEntityImpl[] ls = select.getResultList();

        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list;
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, Object> params = new HashMap<>(2);
        //params.put("subScopeId", subScopeId);
        //params.put("scopeType", scopeType);
        //return getList("selectVariableInstancesBySubScopeIdAndScopeType", params, variableInstanceBySubScopeIdAndScopeTypeMatcher, true);
    }


    public VariableInstanceEntity findVariableInstanceBySubScopeIdAndScopeTypeAndName(string subScopeId, string scopeType, string variableName) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableInstanceEntityImpl)("SELECT * FROM VariableInstanceEntityImpl u where u.subScopeId = :subScopeId and u.scopeType = :scopeType and u.name = :variableName ");
        select.setParameter("subScopeId",subScopeId);
        select.setParameter("scopeType",scopeType);
        select.setParameter("variableName",variableName);
        VariableInstanceEntityImpl[] ls = select.getResultList();
        List!VariableInstanceEntity list = new ArrayList!VariableInstanceEntity;
        foreach(VariableInstanceEntityImpl v ; ls)
        {
          list.add(cast(VariableInstanceEntity)v);
        }
        return list.isEmpty() ? null : list.get(0);
        //return new ArrayList!VariableInstanceEntity(ls);
        //Map<string, string> params = new HashMap<>(3);
        //params.put("subScopeId", subScopeId);
        //params.put("scopeType", scopeType);
        //params.put("variableName", variableName);
        //return getEntity("selectVariableInstanceBySubScopeIdAndScopeTypeAndName", params, variableInstanceBySubScopeIdAndScopeTypeAndVariableNameMatcher, true);
    }


    public List!VariableInstanceEntity findVariableInstancesBySubScopeIdAndScopeTypeAndNames(string subScopeId, string scopeType, Collection!string variableNames) {
        implementationMissing(false);
        return null;
        //Map<string, Object> params = new HashMap<>(3);
        //params.put("subScopeId", subScopeId);
        //params.put("scopeType", scopeType);
        //params.put("variableNames", variableNames);
        //return getList("selectVariableInstanceBySubScopeIdAndScopeTypeAndNames", params, variableInstanceBySubScopeIdAndScopeTypeAndVariableNamesMatcher, true);
    }


    public void deleteVariablesByTaskId(string taskId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(VariableInstanceEntityImpl)("DELETE FROM VariableInstanceEntityImpl u WHERE u.taskId = :taskId");
        update.setParameter("taskId",taskId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteVariablesByTaskId error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "task", taskId)) {
        //    deleteCachedEntities(dbSqlSession, variableInstanceByTaskIdMatcher, taskId);
        //} else {
        //    bulkDelete("deleteVariableInstancesByTaskId", variableInstanceByTaskIdMatcher, taskId);
        //}
    }


    public void deleteVariablesByExecutionId(string executionId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(VariableInstanceEntityImpl)("DELETE FROM VariableInstanceEntityImpl u WHERE u.executionId = :executionId");
        update.setParameter("executionId",executionId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteVariablesByExecutionId error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    deleteCachedEntities(dbSqlSession, variableInstanceByExecutionIdMatcher, executionId);
        //} else {
        //    bulkDelete("deleteVariableInstancesByExecutionId", variableInstanceByExecutionIdMatcher, executionId);
        //}
    }


    public void deleteByScopeIdAndScopeType(string scopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(VariableInstanceEntityImpl)("DELETE FROM VariableInstanceEntityImpl u WHERE u.scopeId = :scopeId and u.scopeType = :scopeType");
        update.setParameter("scopeId",scopeId);
        update.setParameter("scopeType",scopeType);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteByScopeIdAndScopeType error : %s",e.msg);
        }
        //Map<string, Object> params = new HashMap<>(3);
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //bulkDelete("deleteVariablesByScopeIdAndScopeType", variableInstanceByScopeIdAndScopeTypeMatcher, params);
    }

}
