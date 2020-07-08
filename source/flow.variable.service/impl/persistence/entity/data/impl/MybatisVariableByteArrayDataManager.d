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
module flow.variable.service.impl.persistence.entity.data.impl.MybatisVariableByteArrayDataManager;

import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.db.AbstractDataManager;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntity;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntityImpl;
import flow.variable.service.impl.persistence.entity.data.VariableByteArrayDataManager;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisVariableByteArrayDataManager : EntityRepository!(VariableByteArrayEntityImpl , string) , VariableByteArrayDataManager {

    alias findAll = CrudRepository!(VariableByteArrayEntityImpl , string).findAll;
    alias findById = CrudRepository!(VariableByteArrayEntityImpl , string).findById;
    alias insert = CrudRepository!(VariableByteArrayEntityImpl , string).insert;
    alias update = CrudRepository!(VariableByteArrayEntityImpl , string).update;
    public VariableByteArrayEntity create() {
        return new VariableByteArrayEntityImpl();
    }

    this()
    {
      super(entityManagerFactory.currentEntityManager());
    }


  public VariableByteArrayEntity findById(string entityId) {
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
    public void insert(VariableByteArrayEntity entity) {
      insert(cast(VariableByteArrayEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    public VariableByteArrayEntity update(VariableByteArrayEntity entity) {
      return  update(cast(VariableByteArrayEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }
    public void dele(string id) {
      VariableByteArrayEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(VariableByteArrayEntityImpl)entity);
      }
      //delete(entity);
    }

    public void dele(VariableByteArrayEntity entity) {
      if (entity !is null)
      {
        remove(cast(VariableByteArrayEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    //public Class<? extends VariableByteArrayEntity> getManagedEntityClass() {
    //    return VariableByteArrayEntityImpl.class;
    //}


    public List!VariableByteArrayEntity findAll() {
        //return getDbSqlSession().selectList("selectVariableByteArrays");
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(VariableByteArrayEntityImpl)("SELECT * FROM VariableByteArrayEntityImpl").getResultList();
        List!VariableByteArrayEntity list = new ArrayList!VariableByteArrayEntity;
        foreach(VariableByteArrayEntityImpl v ; select)
        {
            list.add(cast(VariableByteArrayEntity)v);
        }
        return list;
        //return new ArrayList!VariableByteArrayEntity(select);
    }


    public void deleteByteArrayNoRevisionCheck(string byteArrayEntityId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(VariableByteArrayEntityImpl)("DELETE FROM VariableByteArrayEntityImpl u WHERE u.id = :byteArrayEntityId");
        update.setParameter("byteArrayEntityId",byteArrayEntityId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteByteArrayNoRevisionCheck error : %s",e.msg);
        }
        //getDbSqlSession().delete("deleteVariableByteArrayNoRevisionCheck", byteArrayEntityId, VariableByteArrayEntityImpl.class);
    }

}
