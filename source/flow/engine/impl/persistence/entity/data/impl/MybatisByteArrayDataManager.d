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
module flow.engine.impl.persistence.entity.data.impl.MybatisByteArrayDataManager;

import hunt.collection.List;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ByteArrayEntity;
import flow.engine.impl.persistence.entity.ByteArrayEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ByteArrayDataManager;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clockm;
import hunt.logging;
import hunt.collection.ArrayList;
import hunt.entity;
import flow.engine.impl.util.CommandContextUtil;
import flow.common.persistence.entity.Entity;
import flow.common.interceptor.CommandContext;
import flow.common.api.DataManger;
import flow.common.context.Context;
/**
 * @author Joram Barrez
 */
//class MybatisByteArrayDataManager : AbstractProcessDataManager!ByteArrayEntity implements ByteArrayDataManager {
class MybatisByteArrayDataManager : EntityRepository!(ByteArrayEntityImpl , string) , ByteArrayDataManager, DataManger {

    alias findAll = CrudRepository!(ByteArrayEntityImpl , string).findAll;
    alias findById = CrudRepository!(ByteArrayEntityImpl , string).findById;
    alias insert = CrudRepository!(ByteArrayEntityImpl , string).insert;
    alias update = CrudRepository!(ByteArrayEntityImpl , string).update;
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
      return typeid(MybatisByteArrayDataManager);
    }

  public ByteArrayEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    //return find(entityId);
    auto entity =  CommandContextUtil.getEntityCache().findInCache(typeid(ByteArrayEntityImpl),entityId);

    if (entity !is null)
    {
      return cast(ByteArrayEntity)entity;
    }

    ByteArrayEntity dbData = cast(ByteArrayEntity)(find(entityId));
    if (dbData !is null)
    {
      CommandContextUtil.getEntityCache().put(dbData, true , typeid(ByteArrayEntityImpl),this);
    }

    return dbData;
  }
  //
  public void insert(ByteArrayEntity entity) {
    //insert(cast(ByteArrayEntityImpl)entity);
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
    insertJob[entity] = this;
    CommandContextUtil.getEntityCache().put(entity, false, typeid(ByteArrayEntityImpl),this);
  }

  public void insertTrans(Entity entity , EntityManager db)
  {
    //auto em = _manager ? _manager : createEntityManager;
    ByteArrayEntityImpl tmp = cast(ByteArrayEntityImpl)entity;
    db.persist!ByteArrayEntityImpl(tmp);
  }

  public void updateTrans(Entity entity , EntityManager db)
  {
    db.merge!ByteArrayEntityImpl(cast(ByteArrayEntityImpl)entity);
  }

  public ByteArrayEntity update(ByteArrayEntity entity) {
    return  update(cast(ByteArrayEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    ByteArrayEntity entity = findById(id);
    if (entity !is null)
    {
      deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(DeploymentEntityImpl)entity);
    }
    //delete(entity);
  }

  void deleteTrans(Entity entity , EntityManager db)
  {
    db.remove!ByteArrayEntityImpl(cast(ByteArrayEntityImpl)entity);
  }

  public void dele(ByteArrayEntity entity) {
    if (entity !is null)
    {
      deleteJob[entity] = this;
      entity.setDeleted(true);
      //remove(cast(DeploymentEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    public ByteArrayEntity create() {
        return new ByteArrayEntityImpl();
    }


    //class<? : ByteArrayEntity> getManagedEntityClass() {
    //    return ByteArrayEntityImpl.class;
    //}


    public List!ByteArrayEntity findAll() {
       // return getDbSqlSession().selectList("selectByteArrays");
        return new ArrayList!ByteArrayEntity( findAll());
    }


    public void deleteByteArrayNoRevisionCheck(string byteArrayEntityId) {
        removeById(byteArrayEntityId);
        //getDbSqlSession().delete("deleteByteArrayNoRevisionCheck", byteArrayEntityId, ByteArrayEntityImpl.class);
    }

}
