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
module flow.engine.impl.persistence.entity.data.impl.MybatisProcessDefinitionDataManager;

import flow.engine.impl.util.CommandContextUtil;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import std.array;
import flow.common.api.FlowableException;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionDataManager;
import flow.engine.repository.ProcessDefinition;
import hunt.entity;
import hunt.collection.ArrayList;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
/**
 * @author Joram Barrez
 */
//class MybatisProcessDefinitionDataManager : AbstractProcessDataManager!ProcessDefinitionEntity implements ProcessDefinitionDataManager {
class MybatisProcessDefinitionDataManager : EntityRepository!(ProcessDefinitionEntityImpl , string) , ProcessDefinitionDataManager , DataManger  {
    private ProcessEngineConfigurationImpl processEngineConfiguration;

    alias findById = CrudRepository!(ProcessDefinitionEntityImpl , string).findById;
    alias insert = CrudRepository!(ProcessDefinitionEntityImpl , string).insert;
    alias update = CrudRepository!(ProcessDefinitionEntityImpl , string).update;

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
        return typeid(MybatisProcessDefinitionDataManager);
    }
    //class<? : ResourceEntity> getManagedEntityClass() {
    //    return ResourceEntityImpl.class;
    //}

  public ProcessDefinitionEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    //return find(entityId);
    auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(ProcessDefinitionEntityImpl),entityId);

    if (entity !is null)
    {
      return cast(ProcessDefinitionEntity)entity;
    }

    ProcessDefinitionEntity dbData = cast(ProcessDefinitionEntity)(find(entityId));
    if (dbData !is null)
    {
      CommandContextUtil.getEntityCache().put(dbData, true , typeid(ProcessDefinitionEntityImpl));
    }

    return dbData;
  }
  //
  public void insert(ProcessDefinitionEntity entity) {
    //insert(cast(ProcessDefinitionEntityImpl)entity);
    //getDbSqlSession().insert(entity);
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
    CommandContextUtil.getEntityCache().put(entity, false, typeid(ProcessDefinitionEntityImpl));
    //insert(cast(ProcessDefinitionEntityImpl)entity);
    //CommandContext commandContext = Context.getCommandContext();
    //if (commandContext !is null)
    //{
    //  CommandContext.insertJob[entity] = this;
    //}
  }

  public void insertTrans(Entity entity , EntityManager db)
  {
    //auto em = _manager ? _manager : createEntityManager;
    ProcessDefinitionEntityImpl tmp = cast(ProcessDefinitionEntityImpl)entity;
    db.persist!ProcessDefinitionEntityImpl(tmp);
  }


  public ProcessDefinitionEntity update(ProcessDefinitionEntity entity) {
    return  update(cast(ProcessDefinitionEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ProcessDefinitionEntity entity = findById(id);
    if (entity !is null)
    {
      CommandContext.deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(ProcessDefinitionEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ProcessDefinitionEntity entity) {
    if (entity !is null)
    {
      CommandContext.deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(ProcessDefinitionEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!ProcessDefinitionEntityImpl(cast(ProcessDefinitionEntityImpl)entity);
    }

    public ProcessDefinitionEntity create() {
        return new ProcessDefinitionEntityImpl();
    }


    public ProcessDefinitionEntity findLatestProcessDefinitionByKey(string processDefinitionKey) {

      scope(exit)
      {
        _manager.close();
      }
      ProcessDefinitionEntityImpl[] array =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.key = :key AND (u.tenantId = '' or u.tenantId is null) AND
       (u.derivedFrom is null or u.derivedFrom = '') and u.ver = (select max(VERSION_) from testworkflow.ACT_RE_PROCDEF where KEY_ = :processDefinitionKey and (TENANT_ID_ = '' or TENANT_ID_ is null))")
      .setParameter("key",processDefinitionKey)
      .setParameter("processDefinitionKey",processDefinitionKey)
      .getResultList();

      //logErrorf("ProcessDefinitionEntityImpl ...... %s",array[0].getTenantId());
       return array.length == 0? null : cast(ProcessDefinitionEntity)array[0];
        //implementationMissing(false);
        //return null;
       // return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestProcessDefinitionByKey", processDefinitionKey);
    }


    public ProcessDefinitionEntity findLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("processDefinitionKey", processDefinitionKey);
        //params.put("tenantId", tenantId);
        //return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestProcessDefinitionByKeyAndTenantId", params);
    }


    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKey(string processDefinitionKey) {
        implementationMissing(false);
        return null;
        //return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestDerivedProcessDefinitionByKey", processDefinitionKey);
    }


    public ProcessDefinitionEntity findLatestDerivedProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("processDefinitionKey", processDefinitionKey);
        //params.put("tenantId", tenantId);
        //return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectLatestDerivedProcessDefinitionByKeyAndTenantId", params);
    }


    public void deleteProcessDefinitionsByDeploymentId(string deploymentId) {
      scope(exit)
      {
        _manager.close();
      }

      auto update = _manager.createQuery!(ProcessDefinitionEntityImpl)("DELETE FROM ProcessDefinitionEntityImpl u WHERE u.deploymentId = :deploymentId");
      update.setParameter("deploymentId",deploymentId);
      try{
        update.exec();
      }
      catch(Exception e)
      {
        logError("deleteProcessDefinitionsByDeploymentId error : %s",e.msg);
      }
       // getDbSqlSession().delete("deleteProcessDefinitionsByDeploymentId", deploymentId, ProcessDefinitionEntityImpl.class);
    }


    public List!ProcessDefinition findProcessDefinitionsByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        scope(exit)
        {
          _manager.close();
        }

         ProcessDefinitionEntityImpl[] array;

        if(processDefinitionQuery.getDeploymentIds !is null && processDefinitionQuery.getDeploymentIds.size() != 0)
        {
           array =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl a WHERE a.deploymentId IN (" ~ processDefinitionQuery.getDeploymentIds.toArray.join(",") ~ ");")
          .getResultList();
        }else
        {
          array =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.deploymentId = :deploymentId")
          .setParameter("deploymentId",processDefinitionQuery.getDeploymentId)
          .getResultList();
        }
        List!ProcessDefinition rt = new ArrayList!ProcessDefinition;
        foreach(ProcessDefinitionEntityImpl p ; array)
        {
              rt.add(cast(ProcessDefinition)p);
        }
        return rt;
        //implementationMissing(false);
       // return getDbSqlSession().selectList("selectProcessDefinitionsByQueryCriteria", processDefinitionQuery);
    }


    public long findProcessDefinitionCountByQueryCriteria(ProcessDefinitionQueryImpl processDefinitionQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectProcessDefinitionCountByQueryCriteria", processDefinitionQuery);
    }


    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKey(string deploymentId, string processDefinitionKey) {
        scope(exit)
        {
          _manager.close();
        }

        ProcessDefinitionEntityImpl[] array =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.deploymentId = :deploymentId AND u.key = :processDefinitionKey AND (u.tenantId = \"\" OR u.tenantId is null)")
        .setParameter("deploymentId",deploymentId)
        .setParameter("processDefinitionKey",processDefinitionKey)
        .getResultList();
        return array.length == 0? null : cast(ProcessDefinitionEntity)array[0];
        //return new ArrayList!ProcessDefinitionEntityImpl(array);
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("processDefinitionKey", processDefinitionKey);
        //return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectProcessDefinitionByDeploymentAndKey", parameters);
    }


    public ProcessDefinitionEntity findProcessDefinitionByDeploymentAndKeyAndTenantId(string deploymentId, string processDefinitionKey, string tenantId) {
        scope(exit)
        {
          _manager.close();
        }

        ProcessDefinitionEntityImpl[] array =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.deploymentId = :deploymentId AND u.key = :processDefinitionKey AND u.tenantId = :tenantId")
        .setParameter("deploymentId",deploymentId)
        .setParameter("processDefinitionKey",processDefinitionKey)
        .setParameter("tenantId",tenantId)
        .getResultList();
        return array.length == 0 ? null : array[0];
        //return new ArrayList!ProcessDefinitionEntityImpl(array);
        //Map!(string, Object) parameters = new HashMap<>();
        //parameters.put("deploymentId", deploymentId);
        //parameters.put("processDefinitionKey", processDefinitionKey);
        //parameters.put("tenantId", tenantId);
        //return (ProcessDefinitionEntity) getDbSqlSession().selectOne("selectProcessDefinitionByDeploymentAndKeyAndTenantId", parameters);
    }


    public ProcessDefinitionEntity findProcessDefinitionByKeyAndVersion(string processDefinitionKey, int processDefinitionVersion) {
        scope(exit)
        {
          _manager.close();
        }

        ProcessDefinitionEntityImpl[] results =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.key = :processDefinitionKey AND u.ver = :ver AND (u.tenantId = \"\" OR u.tenantId is null)")
        .setParameter("processDefinitionKey",processDefinitionKey)
        .setParameter("ver",processDefinitionVersion)
        .getResultList();
        //Map!(string, Object) params = new HashMap<>();
        //params.put("processDefinitionKey", processDefinitionKey);
        //params.put("processDefinitionVersion", processDefinitionVersion);
        //List!ProcessDefinitionEntity results = getDbSqlSession().selectList("selectProcessDefinitionsByKeyAndVersion", params);
        if (results.length == 1) {
            return results[0];
        } else if (results.length > 1) {
            implementationMissing(false);
           // throw new FlowableException("There are "  results.size() + " process definitions with key = '" + processDefinitionKey + "' and version = '" + processDefinitionVersion + "'.");
        }
        return null;
    }


    public ProcessDefinitionEntity findProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, int processDefinitionVersion, string tenantId) {
        scope(exit)
        {
          _manager.close();
        }

        ProcessDefinitionEntityImpl[] results =  _manager.createQuery!(ProcessDefinitionEntityImpl)("SELECT * FROM ProcessDefinitionEntityImpl u WHERE u.key = :processDefinitionKey AND u.ver = :ver AND u.tenantId = :tenantId")
        .setParameter("processDefinitionKey",processDefinitionKey)
        .setParameter("ver",processDefinitionVersion)
        .setParameter("tenantId",tenantId)
        .getResultList();
        //Map!(string, Object) params = new HashMap<>();
        //params.put("processDefinitionKey", processDefinitionKey);
        //params.put("processDefinitionVersion", processDefinitionVersion);
        //params.put("tenantId", tenantId);
        //List!ProcessDefinitionEntity results = getDbSqlSession().selectList("selectProcessDefinitionsByKeyAndVersionAndTenantId", params);
        if (results.length == 1) {
            return results[0];
        } else if (results.length > 1) {
            implementationMissing(false);
            //throw new FlowableException("There are " + results.size() + " process definitions with key = '" + processDefinitionKey + "' and version = '" + processDefinitionVersion + "'.");
        }
        return null;
    }


    public List!ProcessDefinition findProcessDefinitionsByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectListWithRawParameter("selectProcessDefinitionByNativeQuery", parameterMap);
    }


    public long findProcessDefinitionCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectProcessDefinitionCountByNativeQuery", parameterMap);
    }


    public void updateProcessDefinitionTenantIdForDeployment(string deploymentId, string newTenantId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(ProcessDefinitionEntityImpl)("update ProcessDefinitionEntityImpl u set u.tenantId = :tenantId where u.deploymentId = :deploymentId");
        update.setParameter("tenantId",newTenantId);
        update.setParameter("deploymentId",deploymentId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("updateProcessDefinitionTenantIdForDeployment error : %s",e.msg);
        }
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateProcessDefinitionTenantIdForDeploymentId", params);
    }


    public void updateProcessDefinitionVersionForProcessDefinitionId(string processDefinitionId, int ver) {

        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(ProcessDefinitionEntityImpl)("update ProcessDefinitionEntityImpl u set u.ver = :ver where u.id = :id");
        update.setParameter("ver",ver);
        update.setParameter("id",processDefinitionId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("updateProcessDefinitionVersionForProcessDefinitionId error : %s",e.msg);
        }
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("processDefinitionId", processDefinitionId);
        //params.put("version", version);
        //getDbSqlSession().update("updateProcessDefinitionVersionForProcessDefinitionId", params);
    }

}
