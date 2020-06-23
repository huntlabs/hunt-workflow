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
module flow.identitylink.service.impl.persistence.entity.data.impl.MybatisIdentityLinkDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.scop.ScopeTypes;
import flow.common.db.AbstractDataManager;
import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityImpl;
import flow.identitylink.service.impl.persistence.entity.data.IdentityLinkDataManager;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByProcessInstanceMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByProcessInstanceUserGroupAndTypeMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByScopeIdAndTypeMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByScopeIdScopeTypeUserGroupAndTypeMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksBySubScopeIdAndTypeMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByTaskIdMatcher;
import hunt.collection.ArrayList;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class MybatisIdentityLinkDataManager : EntityRepository!( IdentityLinkEntityImpl , string) , IdentityLinkDataManager {
    //
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinksByTaskIdMatcher = new IdentityLinksByTaskIdMatcher();
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinkByProcessInstanceMatcher = new IdentityLinksByProcessInstanceMatcher();
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinksByScopeIdAndTypeMatcher = new IdentityLinksByScopeIdAndTypeMatcher();
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinksBySubScopeIdAndTypeMatcher = new IdentityLinksBySubScopeIdAndTypeMatcher();
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinksByProcessInstanceUserGroupAndTypeMatcher = new IdentityLinksByProcessInstanceUserGroupAndTypeMatcher();
    //protected CachedEntityMatcher!IdentityLinkEntity identityLinksByScopeIdScopeTypeUserGroupAndTypeMatcher = new IdentityLinksByScopeIdScopeTypeUserGroupAndTypeMatcher();

    //
    //class<? extends IdentityLinkEntity> getManagedEntityClass() {
    //    return IdentityLinkEntityImpl.class;
    //}

    public IdentityLinkEntity findById(string entityId) {
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
    //@Override
    public void insert(IdentityLinkEntity entity) {
        insert(cast(IdentityLinkEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public IdentityLinkEntity update(IdentityLinkEntity entity) {
        return  update(cast(IdentityLinkEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
    }
    //
    //@Override
    public void dele(string id) {
        IdentityLinkEntity entity = findById(id);
        if (entity !is null)
        {
           remove(cast(IdentityLinkEntityImpl)entity);
        }
        //delete(entity);
    }

    this()
    {
      super(entityManagerFactory.currentEntityManager());
    }


    public IdentityLinkEntity create() {
        return new IdentityLinkEntityImpl();
    }


    public List!IdentityLinkEntity findIdentityLinksByTaskId(string taskId) {
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //if (isEntityInserted(dbSqlSession, "task", taskId)) {
        //    return getListFromCache(identityLinksByTaskIdMatcher, taskId);
        //}

        //return getList("selectIdentityLinksByTaskId", taskId, identityLinkByProcessInstanceMatcher, true);
        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.taskId , taskId));
        lst.addAll(lst);
        return objs;
    }


    public List!IdentityLinkEntity findIdentityLinksByProcessInstanceId(string processInstanceId) {
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the process instance has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
        //    return getListFromCache(identityLinkByProcessInstanceMatcher, processInstanceId);
        //}

        //return getList("selectIdentityLinksByProcessInstance", processInstanceId, identityLinkByProcessInstanceMatcher, true);

        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.processInstanceId , processInstanceId));
        lst.addAll(lst);
        return objs;
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeIdAndType(string scopeId, string scopeType) {

        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s" , Field.scopeId , scopeId , Field.scopeType , scopeType));
        lst.addAll(lst);
        return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeId", scopeId);
        //parameters.put("scopeType", scopeType);
        //return getList("selectIdentityLinksByScopeIdAndType", parameters, identityLinksByScopeIdAndTypeMatcher, true);
    }


    public List!IdentityLinkEntity findIdentityLinksBySubScopeIdAndType(string subScopeId, string scopeType) {

        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s" , Field.subScopeId , subScopeId , Field.scopeType , scopeType));
        lst.addAll(lst);
        return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("subScopeId", subScopeId);
        //parameters.put("scopeType", scopeType);
        //return getList("selectIdentityLinksBySubScopeIdAndType", parameters, identityLinksBySubScopeIdAndTypeMatcher, true);
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {

        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s" , Field.scopeDefinitionId , scopeDefinitionId , Field.scopeType , scopeType));
        lst.addAll(lst);
        return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeDefinitionId", scopeDefinitionId);
        //parameters.put("scopeType", scopeType);
        //return getDbSqlSession().selectList("selectIdentityLinksByScopeDefinitionAndType", parameters);
    }



    public List!IdentityLinkEntity findIdentityLinksByProcessDefinitionId(string processDefinitionId) {
        //return getDbSqlSession().selectList("selectIdentityLinksByProcessDefinition", processDefinitionId);
        List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s" , Field.processDefId , processDefinitionId));
        lst.addAll(lst);
        return objs;
    }



    public List!IdentityLinkEntity findIdentityLinkByTaskUserGroupAndType(string taskId, string userId, string groupId, string type) {
        implementationMissing(false);
        return null;
        //List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        //IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s and %s = %s and %s = %s and  %s = %s" , Field.taskId , taskId , Field.userId , userId,Field.groupId , groupId,Field.type , type));
        //lst.addAll(lst);
        //return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("taskId", taskId);
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //parameters.put("type", type);
        //return getDbSqlSession().selectList("selectIdentityLinkByTaskUserGroupAndType", parameters);
    }



    public List!IdentityLinkEntity findIdentityLinkByProcessInstanceUserGroupAndType(string processInstanceId, string userId, string groupId, string type) {
         implementationMissing(false);
        return null;
        //List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        //IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s and %s = %s and %s = %s and %s = %s" , Field.processInstanceId , processInstanceId , Field.userId , userId,Field.groupId , groupId,Field.type , type));
        //lst.addAll(lst);
        //return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("processInstanceId", processInstanceId);
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //parameters.put("type", type);
        //return getList("selectIdentityLinkByProcessInstanceUserGroupAndType", parameters, identityLinksByProcessInstanceUserGroupAndTypeMatcher);
    }



    public List!IdentityLinkEntity findIdentityLinkByProcessDefinitionUserAndGroup(string processDefinitionId, string userId, string groupId) {
         implementationMissing(false);
        return null;
        //List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        //IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s and %s = %s and %s = %s" , Field.processDefId , processDefinitionId , Field.userId , userId,Field.groupId , groupId));
        //lst.addAll(lst);
        //return objs;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("processDefinitionId", processDefinitionId);
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //return getDbSqlSession().selectList("selectIdentityLinkByProcessDefinitionUserAndGroup", parameters);
    }




    public List!IdentityLinkEntity findIdentityLinkByScopeIdScopeTypeUserGroupAndType(string scopeId, string scopeType, string userId, string groupId, string type) {
          implementationMissing(false);
         return null;
        //List!IdentityLinkEntity  lst = new ArrayList!IdentityLinkEntity;
        //IdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s and %s = %s and %s = %s" , Field.processDefId , processDefinitionId , Field.userId , userId,Field.groupId , groupId));
        //lst.addAll(lst);
        //return objs;
         //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeId", scopeId);
        //parameters.put("scopeType", scopeType);
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //parameters.put("type", type);
        //return getList("selectIdentityLinkByScopeIdScopeTypeUserGroupAndType", parameters, identityLinksByScopeIdScopeTypeUserGroupAndTypeMatcher);
    }



    public List!IdentityLinkEntity findIdentityLinkByScopeDefinitionScopeTypeUserAndGroup(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        implementationMissing( false);
        return null;
      //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeDefinitionId", scopeDefinitionId);
        //parameters.put("scopeType", scopeType);
        //parameters.put("userId", userId);
        //parameters.put("groupId", groupId);
        //return getDbSqlSession().selectList("selectIdentityLinkByScopeDefinitionScopeTypeUserAndGroup", parameters);
    }


    public void deleteIdentityLinksByTaskId(string taskId) {
        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(IdentityLinkEntityImpl)("DELETE FROM IdentityLinkEntityImpl u WHERE u.taskId = :taskId");
        update.setParameter("taskId",taskId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteIdentityLinksByTaskId error : %s",e.msg);
        }

        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "task", taskId)) {
        //    deleteCachedEntities(dbSqlSession, identityLinksByTaskIdMatcher, taskId);
        //} else {
        //    bulkDelete("deleteIdentityLinksByTaskId", identityLinksByTaskIdMatcher, taskId);
        //}
    }


    public void deleteIdentityLinksByProcDef(string processDefId) {
        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(IdentityLinkEntityImpl)("DELETE FROM IdentityLinkEntityImpl u WHERE u.processDefId = :processDefId");
        update.setParameter("processDefId",processDefId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteIdentityLinksByProcDef error : %s",e.msg);
        }
        //getDbSqlSession().delete("deleteIdentityLinksByProcDef", processDefId, IdentityLinkEntityImpl.class);
    }


    public void deleteIdentityLinksByProcessInstanceId(string processInstanceId) {

        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(IdentityLinkEntityImpl)("DELETE FROM IdentityLinkEntityImpl u WHERE u.processInstanceId = :processInstanceId");
        update.setParameter("processInstanceId",processInstanceId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteIdentityLinksByProcessInstanceId error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
        //    deleteCachedEntities(dbSqlSession, identityLinkByProcessInstanceMatcher, processInstanceId);
        //} else {
        //    bulkDelete("deleteIdentityLinksByProcessInstanceId", identityLinkByProcessInstanceMatcher, processInstanceId);
        //}
    }


    public void deleteIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {

        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(IdentityLinkEntityImpl)("DELETE FROM IdentityLinkEntityImpl u WHERE u.scopeId = :scopeId and u.scopeType = :scopeType");
        update.setParameter("scopeId",scopeId);
        update.setParameter("scopeType",scopeType);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteIdentityLinksByScopeIdAndScopeType error : %s",e.msg);
        }
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeId", scopeId);
        //
        //if (ScopeTypes.CMMN.equals(scopeType) && isEntityInserted(dbSqlSession, "caseInstance", scopeId)) {
        //    deleteCachedEntities(dbSqlSession, identityLinksByScopeIdAndTypeMatcher, parameters);
        //} else {
        //
        //    parameters.put("scopeType", scopeType);
        //    bulkDelete("deleteIdentityLinksByScopeIdAndScopeType", identityLinksByScopeIdAndTypeMatcher, parameters);
        //}
    }


    public void deleteIdentityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType) {

        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(IdentityLinkEntityImpl)("DELETE FROM IdentityLinkEntityImpl u WHERE u.scopeDefinitionId = :scopeDefinitionId and u.scopeType = :scopeType");
        update.setParameter("scopeDefinitionId",scopeDefinitionId);
        update.setParameter("scopeType",scopeType);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteIdentityLinksByScopeDefinitionIdAndScopeType error : %s",e.msg);
        }
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeDefinitionId", scopeDefinitionId);
        //parameters.put("scopeType", scopeType);
        //getDbSqlSession().delete("deleteIdentityLinksByScopeDefinitionIdAndScopeType", parameters, IdentityLinkEntityImpl.class);
    }

}
