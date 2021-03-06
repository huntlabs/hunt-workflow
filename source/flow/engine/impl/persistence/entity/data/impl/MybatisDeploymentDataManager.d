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
module flow.engine.impl.persistence.entity.data.impl.MybatisDeploymentDataManager;

import flow.engine.impl.util.CommandContextUtil;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.DeploymentEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.DeploymentDataManager;
import flow.engine.repository.Deployment;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
import hunt.collection.ArrayList;
import hunt.entity;
/**
 * @author Joram Barrez
 */
class MybatisDeploymentDataManager : EntityRepository!(DeploymentEntityImpl , string) , DeploymentDataManager , DataManger {

    alias findById = CrudRepository!(DeploymentEntityImpl , string).findById;
    alias insert = CrudRepository!(DeploymentEntityImpl , string).insert;
    alias update = CrudRepository!(DeploymentEntityImpl , string).update;
    private ProcessEngineConfigurationImpl processEngineConfiguration;

    TypeInfo getTypeInfo()
    {
      return typeid(MybatisDeploymentDataManager);
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

    //
    //class<? : DeploymentEntity> getManagedEntityClass() {
    //    return DeploymentEntityImpl.class;
    //}

  public DeploymentEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    //return find(entityId);
    auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(DeploymentEntityImpl),entityId);

    if (entity !is null)
    {
      return cast(DeploymentEntity)entity;
    }

    DeploymentEntity dbData = cast(DeploymentEntity)(find(entityId));
    if (dbData !is null)
    {
      CommandContextUtil.getEntityCache().put(dbData, true , typeid(DeploymentEntityImpl),this);
    }

    return dbData;
    //if (entityId is null) {
    //  return null;
    //}
    //
    //return find(entityId);
  }
  //
  public void insert(DeploymentEntity entity) {
    //insert(cast(DeploymentEntityImpl)entity);
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
    CommandContextUtil.getEntityCache().put(entity, false, typeid(DeploymentEntityImpl),this);
  }

  public void insertTrans(Entity entity , EntityManager db)
  {
    //auto em = _manager ? _manager : createEntityManager;
    DeploymentEntityImpl tmp = cast(DeploymentEntityImpl)entity;
    db.persist!DeploymentEntityImpl(tmp);
  }

  public DeploymentEntity update(DeploymentEntity entity) {
    return  update(cast(DeploymentEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    DeploymentEntity entity = findById(id);
    if (entity !is null)
    {
      deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(DeploymentEntityImpl)entity);
    }
    //delete(entity);
  }

  public void updateTrans(Entity entity , EntityManager db)
  {
    db.merge!DeploymentEntityImpl(cast(DeploymentEntityImpl)entity);
  }

  public void dele(DeploymentEntity entity) {
    if (entity !is null)
    {
      deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(DeploymentEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    void deleteTrans(Entity entity , EntityManager db)
    {
      db.remove!DeploymentEntityImpl(cast(DeploymentEntityImpl)entity);
    }

    public DeploymentEntity create() {
        return new DeploymentEntityImpl();
    }


    public long findDeploymentCountByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectDeploymentCountByQueryCriteria", deploymentQuery);
    }


    public List!Deployment findDeploymentsByQueryCriteria(DeploymentQueryImpl deploymentQuery) {
        implementationMissing(false);
        return null;
        //final string query = "selectDeploymentsByQueryCriteria";
        //return getDbSqlSession().selectList(query, deploymentQuery);
    }


    public List!string getDeploymentResourceNames(string deploymentId) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().getSqlSession().selectList("selectResourceNamesByDeploymentId", deploymentId);
      //scope(exit)
      //{
      //  _manager.close();
      //}
      //
      //string[] array =  _manager.createQuery!(string)("SELECT name FROM DeploymentEntityImpl u WHERE u.deploymentId = :deploymentId order by name asc")
      //.setParameter("deploymentId",deploymentId);
      //.getResultList();
      //return new ArrayList!ResourceEntityImpl(array);
    }


    public List!Deployment findDeploymentsByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectListWithRawParameter("selectDeploymentByNativeQuery", parameterMap);
    }


    public long findDeploymentCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectDeploymentCountByNativeQuery", parameterMap);
    }

}
