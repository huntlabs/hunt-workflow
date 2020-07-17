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
module flow.engine.impl.persistence.entity.data.impl.MybatisResourceDataManager;
import flow.common.context.Context;
import hunt.logging;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ResourceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ResourceDataManager;
import hunt.entity;
import hunt.collection.ArrayList;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
/**
 * @author Joram Barrez
 */
//class MybatisResourceDataManager : AbstractProcessDataManager!ResourceEntity implements ResourceDataManager {
class MybatisResourceDataManager : EntityRepository!(ResourceEntityImpl , string) , ResourceDataManager {

    alias findById = CrudRepository!(ResourceEntityImpl , string).findById;
    alias insert = CrudRepository!(ResourceEntityImpl , string).insert;
    alias update = CrudRepository!(ResourceEntityImpl , string).update;
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

  public ResourceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(ResourceEntity entity) {
    if (entity.getId() is null)
    {
      string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
      //if (dbSqlSessionFactory.isUsePrefixId()) {
      //    id = entity.getIdPrefix() + id;
      //}
      entity.setId(id);
    }

   // insert(cast(ResourceEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public ResourceEntity update(ResourceEntity entity) {
    return  update(cast(ResourceEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ResourceEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(ResourceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ResourceEntity entity) {
    if (entity !is null)
    {
      remove(cast(ResourceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    public ResourceEntity create() {
        logInfo("ResourceEntity create");
        return new ResourceEntityImpl();
    }


    public void deleteResourcesByDeploymentId(string deploymentId) {
      scope(exit)
      {
        _manager.close();
      }

      auto update = _manager.createQuery!(ResourceEntityImpl)("DELETE FROM ResourceEntityImpl u WHERE u.deploymentId = :deploymentId");
      update.setParameter("deploymentId",deploymentId);
      try{
        update.exec();
      }
      catch(Exception e)
      {
        logError("deleteHistoricIdentityLinksByScopeIdAndType error : %s",e.msg);
      }
        //getDbSqlSession().delete("deleteResourcesByDeploymentId", deploymentId, ResourceEntityImpl.class);
    }


    public ResourceEntity findResourceByDeploymentIdAndResourceName(string deploymentId, string resourceName) {
      ResourceEntityImpl  obj =  find(new Condition("%s = %s and %s = %s" , Field.deploymentId , deploymentId, Field.name , resourceName));
      return obj ;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("resourceName", resourceName);
        //return (ResourceEntity) getDbSqlSession().selectOne("selectResourceByDeploymentIdAndResourceName", params);
    }


    public List!ResourceEntity findResourcesByDeploymentId(string deploymentId) {
       // return getDbSqlSession().selectList("selectResourcesByDeploymentId", deploymentId);


      scope(exit)
      {
        _manager.close();
      }

      ResourceEntityImpl[] array =  _manager.createQuery!(ResourceEntityImpl)("SELECT * FROM ResourceEntityImpl u WHERE u.deploymentId = :deploymentId order by name asc")
      .setParameter("deploymentId",deploymentId)
      .getResultList();
      List!ResourceEntity list = new ArrayList!ResourceEntity;
      foreach(ResourceEntityImpl r; array)
      {
          list.add(cast(ResourceEntity)r);
      }
      return list;
      //return new ArrayList!ResourceEntityImpl(array);
    }

}
