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
module flow.job.service.impl.persistence.entity.data.impl.MybatisJobByteArrayDataManager;


import hunt.logging;
import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.db.AbstractDataManager;
import flow.job.service.impl.persistence.entity.JobByteArrayEntity;
import flow.job.service.impl.persistence.entity.JobByteArrayEntityImpl;
import flow.job.service.impl.persistence.entity.data.JobByteArrayDataManager;
import hunt.entity;
import flow.common.persistence.entity.data.DataManager;
import flow.common.AbstractEngineConfiguration;
import hunt.Exceptions;

/**
 * @author Joram Barrez
 */
class MybatisJobByteArrayDataManager : EntityRepository!( JobByteArrayEntityImpl , string) , JobByteArrayDataManager {

    alias findAll = CrudRepository!( JobByteArrayEntityImpl , string).findAll;
    alias findById = CrudRepository!( JobByteArrayEntityImpl , string).findById;
    alias insert = CrudRepository!( JobByteArrayEntityImpl , string).insert;
    alias update = CrudRepository!( JobByteArrayEntityImpl , string).update;


    public JobByteArrayEntity create() {
        return new JobByteArrayEntityImpl();
    }

    this()
    {
       super(entityManagerFactory.currentEntityManager());
    }

    //class<? extends JobByteArrayEntity> getManagedEntityClass() {
    //    return JobByteArrayEntityImpl.class;
    //}

      public JobByteArrayEntity findById(string entityId) {
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
      public void insert(JobByteArrayEntity entity) {
        insert(cast(JobByteArrayEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      //
      //@Override
      public JobByteArrayEntity update(JobByteArrayEntity entity) {
        return  update(cast(JobByteArrayEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      //
      //@Override
      public void dele(string id) {
        JobByteArrayEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(JobByteArrayEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(JobByteArrayEntity entity) {
        if (entity !is null)
        {
            remove(cast(JobByteArrayEntityImpl)entity);
        }
          //getDbSqlSession().delete(entity);
      }

    public List!JobByteArrayEntity findAll() {

      scope(exit)
      {
        _manager.close();
      }

      JobByteArrayEntityImpl[] array =  _manager.createQuery!(JobByteArrayEntityImpl)("SELECT * FROM JobByteArrayEntityImpl")
      .getResultList();
      List!JobByteArrayEntity list = new ArrayList!JobByteArrayEntity;

      foreach(JobByteArrayEntityImpl j ; array)
      {
          list.add(cast(JobByteArrayEntity)j);
      }

      return list;
        //return getDbSqlSession().selectList("selectJobByteArrays");
    }


    public void deleteByteArrayNoRevisionCheck(string byteArrayEntityId) {
        scope(exit)
        {
          _manager.close();
        }
        auto update = _manager.createQuery!(JobByteArrayEntityImpl)("DELETE FROM JobByteArrayEntityImpl u WHERE u.id = :id");
        update.setParameter("id",byteArrayEntityId);
        try{
          update.exec();
        }
        catch(Exception e)
        {
          logError("deleteByteArrayNoRevisionCheck error : %s",e.msg);
        }
        //getDbSqlSession().delete("deleteJobByteArrayNoRevisionCheck", byteArrayEntityId, JobByteArrayEntityImpl.class);
    }

}
