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
module flow.identitylink.service.impl.persistence.entity.data.impl.MybatisHistoricIdentityLinkDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.AbstractDataManager;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityImpl;
import flow.identitylink.service.impl.persistence.entity.data.HistoricIdentityLinkDataManager;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.HistoricIdentityLinksByProcInstMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.HistoricIdentityLinksByScopeIdAndTypeMatcher;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.HistoricIdentityLinksBySubScopeIdAndTypeMatcher;
import hunt.collection.ArrayList;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import hunt.logging;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import flow.engine.impl.util.CommandContextUtil;
/**
 * @author Joram Barrez
 */
class MybatisHistoricIdentityLinkDataManager : EntityRepository!( HistoricIdentityLinkEntityImpl , string) ,  HistoricIdentityLinkDataManager ,DataManger{
//class MybatisHistoricIdentityLinkDataManager extends AbstractDataManager!HistoricIdentityLinkEntity implements HistoricIdentityLinkDataManager {

    //protected CachedEntityMatcher!HistoricIdentityLinkEntity historicIdentityLinksByProcInstMatcher = new HistoricIdentityLinksByProcInstMatcher();
    //protected CachedEntityMatcher!HistoricIdentityLinkEntity historicIdentityLinksByScopeIdAndTypeMatcher = new HistoricIdentityLinksByScopeIdAndTypeMatcher();
    //protected CachedEntityMatcher!HistoricIdentityLinkEntity historicIdentityLinksBySubScopeIdAndTypeMatcher = new HistoricIdentityLinksBySubScopeIdAndTypeMatcher();

    //
    //class<? extends HistoricIdentityLinkEntity> getManagedEntityClass() {
    //    return HistoricIdentityLinkEntityImpl.class;
    //}

    alias findById = CrudRepository!( HistoricIdentityLinkEntityImpl , string).findById;
    alias insert = CrudRepository!( HistoricIdentityLinkEntityImpl , string).insert;
    alias update = CrudRepository!( HistoricIdentityLinkEntityImpl , string).update;

    TypeInfo getTypeInfo()
    {
      return typeid(MybatisHistoricIdentityLinkDataManager);
    }

    public HistoricIdentityLinkEntity findById(string entityId) {


      if (entityId is null) {
        return null;
      }

      //return find(entityId);
      auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(HistoricIdentityLinkEntityImpl),entityId);

      if (entity !is null)
      {
        return cast(HistoricIdentityLinkEntity)entity;
      }

      HistoricIdentityLinkEntity dbData = cast(HistoricIdentityLinkEntity)(find(entityId));
      if (dbData !is null)
      {
        CommandContextUtil.getEntityCache().put(dbData, true , typeid(HistoricIdentityLinkEntityImpl), this);
      }

      return dbData;
      //if (entityId is null) {
      //  return null;
      //}
      //
      //return find(entityId);

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
    public void insert(HistoricIdentityLinkEntity entity) {
      if (entity.getId() is null)
      {
        string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
        //if (dbSqlSessionFactory.isUsePrefixId()) {
        //    id = entity.getIdPrefix() + id;
        //}
        entity.setId(id);

      }
      entity.setInserted(true);
      insertJob[entity] = this;
      CommandContextUtil.getEntityCache().put(entity, false, typeid(HistoricIdentityLinkEntityImpl), this);
      //insert(cast(HistoricIdentityLinkEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }

    public void insertTrans(Entity entity , EntityManager db)
    {
      //auto em = _manager ? _manager : createEntityManager;
      HistoricIdentityLinkEntityImpl tmp = cast(HistoricIdentityLinkEntityImpl)entity;
      db.persist!HistoricIdentityLinkEntityImpl(tmp);
    }

    //
    //@Override
    public HistoricIdentityLinkEntity update(HistoricIdentityLinkEntity entity) {
      return  update(cast(HistoricIdentityLinkEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }

    public void dele(HistoricIdentityLinkEntity entity) {
      if (entity !is null)
      {
        deleteJob[entity] = this;
        entity.setDeleted(true);
        //remove(cast(HistoricIdentityLinkEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    //
    //@Override
    public void dele(string id) {
      HistoricIdentityLinkEntity entity = findById(id);
      if (entity !is null)
      {
        deleteJob[entity] = this;
        entity.setDeleted(true);
       // remove(cast(HistoricIdentityLinkEntityImpl)entity);
      }
      //delete(entity);
    }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!HistoricIdentityLinkEntityImpl(cast(HistoricIdentityLinkEntityImpl)entity);
    }

    public void updateTrans(Entity entity , EntityManager db)
    {
      db.merge!HistoricIdentityLinkEntityImpl(cast(HistoricIdentityLinkEntityImpl)entity);
    }

  this()
    {
      super(entityManagerFactory.currentEntityManager());
    }

    public HistoricIdentityLinkEntity create() {
        return new HistoricIdentityLinkEntityImpl();
    }



    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByTaskId(string taskId) {
        //return getDbSqlSession().selectList("selectHistoricIdentityLinksByTask", taskId);
        List!HistoricIdentityLinkEntity  lst = new ArrayList!HistoricIdentityLinkEntity;
        HistoricIdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s" , field.taskId , taskId));
        lst.addAll(lst);
        return lst;
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByProcessInstanceId( string processInstanceId) {
        List!HistoricIdentityLinkEntity  lst = new ArrayList!HistoricIdentityLinkEntity;
        HistoricIdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s" , field.processInstanceId , processInstanceId));
        lst.addAll(lst);
        return lst;
        //return getList("selectHistoricIdentityLinksByProcessInstance", processInstanceId, historicIdentityLinksByProcInstMatcher, true);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {

        List!HistoricIdentityLinkEntity  lst = new ArrayList!HistoricIdentityLinkEntity;
        HistoricIdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s" , field.scopeId , scopeId, field.scopeType , scopeType));
        lst.addAll(lst);
        return lst;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeId", scopeId);
        //parameters.put("scopeType", scopeType);
        //return getList("selectHistoricIdentityLinksByScopeIdAndType", parameters, historicIdentityLinksByScopeIdAndTypeMatcher, true);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        List!HistoricIdentityLinkEntity  lst = new ArrayList!HistoricIdentityLinkEntity;
        HistoricIdentityLinkEntityImpl[] objs =  findAll(new Condition("%s = %s and %s = %s" , field.subScopeId , subScopeId, field.scopeType , scopeType));
        lst.addAll(lst);
        return lst;
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("subScopeId", subScopeId);
        //parameters.put("scopeType", scopeType);
        //return getList("selectHistoricIdentityLinksBySubScopeIdAndType", parameters, historicIdentityLinksBySubScopeIdAndTypeMatcher, true);
    }


    public void deleteHistoricIdentityLinksByScopeIdAndType(string scopeId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(HistoricIdentityLinkEntityImpl)("DELETE FROM HistoricIdentityLinkEntityImpl u WHERE u.scopeId = :scopeId and u.scopeType = :scopeType");
        update.setParameter("scopeId",scopeId);
        update.setParameter("scopeType",scopeType);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteHistoricIdentityLinksByScopeIdAndType error : %s",e.msg);
        }

        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeId", scopeId);
        //parameters.put("scopeType", scopeType);
        //getDbSqlSession().delete("deleteHistoricIdentityLinksByScopeIdAndScopeType", parameters, HistoricIdentityLinkEntityImpl.class);
    }


    public void deleteHistoricIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        scope(exit)
        {
          _manager.close();
        }

        auto update = _manager.createQuery!(HistoricIdentityLinkEntityImpl)("DELETE FROM HistoricIdentityLinkEntityImpl u WHERE u.scopeDefinitionId = :scopeDefinitionId and u.scopeType = :scopeType");
        update.setParameter("scopeDefinitionId",scopeDefinitionId);
        update.setParameter("scopeType",scopeType);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteHistoricIdentityLinksByScopeDefinitionIdAndType error : %s",e.msg);
        }
        //Map<string, string> parameters = new HashMap<>();
        //parameters.put("scopeDefinitionId", scopeDefinitionId);
        //parameters.put("scopeType", scopeType);
        //getDbSqlSession().delete("deleteHistoricIdentityLinksByScopeDefinitionIdAndScopeType", parameters, HistoricIdentityLinkEntityImpl.class);
    }


    public void deleteHistoricProcessIdentityLinksForNonExistingInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricProcessIdentityLinks", null, HistoricIdentityLinkEntityImpl.class);
    }


    public void deleteHistoricCaseIdentityLinksForNonExistingInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricCaseIdentityLinks", null, HistoricIdentityLinkEntityImpl.class);
    }


    public void deleteHistoricTaskIdentityLinksForNonExistingInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricTaskIdentityLinks", null, HistoricIdentityLinkEntityImpl.class);
    }
}
