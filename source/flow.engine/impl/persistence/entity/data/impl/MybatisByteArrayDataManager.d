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
/**
 * @author Joram Barrez
 */
//class MybatisByteArrayDataManager : AbstractProcessDataManager!ByteArrayEntity implements ByteArrayDataManager {
class MybatisByteArrayDataManager : EntityRepository!(ByteArrayEntityImpl , string) , ByteArrayDataManager {

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

  public ByteArrayEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(ByteArrayEntity entity) {
    insert(cast(ByteArrayEntityImpl)entity);
    //getDbSqlSession().insert(entity);
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
      remove(cast(ByteArrayEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(ByteArrayEntity entity) {
    if (entity !is null)
    {
      remove(cast(ByteArrayEntityImpl)entity);
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
