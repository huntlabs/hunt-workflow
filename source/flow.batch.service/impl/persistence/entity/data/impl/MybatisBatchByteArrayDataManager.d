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
module flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchByteArrayDataManager;

import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntity;
import flow.batch.service.impl.persistence.entity.BatchByteArrayEntityImpl;
import flow.batch.service.impl.persistence.entity.data.BatchByteArrayDataManager;
import flow.common.db.AbstractDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;


class MybatisBatchByteArrayDataManager : EntityRepository!( BatchByteArrayEntityImpl , string), BatchByteArrayDataManager {


     this()
     {
       super(entityManagerFactory.createEntityManager());
     }

    public BatchByteArrayEntity create() {
        return new BatchByteArrayEntityImpl();
    }

        public BatchByteArrayEntity findById(string entityId) {
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
      public void insert(BatchByteArrayEntity entity) {
        insert(cast(BatchByteArrayEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      //
      //@Override
      public BatchByteArrayEntity update(BatchByteArrayEntity entity) {
        return  update(cast(BatchByteArrayEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      //
      //@Override
      public void dele(string id) {
        BatchByteArrayEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(BatchByteArrayEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(BatchByteArrayEntity entity) {
        if (entity !is null)
        {
          remove(cast(BatchByteArrayEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }

    //public Class<? extends BatchByteArrayEntity> getManagedEntityClass() {
    //    return BatchByteArrayEntityImpl.class;
    //}


    public List!BatchByteArrayEntity findAll() {
        scope(exit)
        {
          _manager.close();
        }

        BatchByteArrayEntity[] array =  _manager.createQuery!(BatchByteArrayEntity)("SELECT * FROM BatchByteArrayEntity")
        .getResultList();
        return new ArrayList!BatchByteArrayEntity(array);
        //return getDbSqlSession().selectList("selectBatchByteArrays");
    }


    public void deleteByteArrayNoRevisionCheck(string byteArrayEntityId) {
        implementationMissing(false);
      //  getDbSqlSession().delete("deleteBatchByteArrayNoRevisionCheck", byteArrayEntityId, BatchByteArrayEntityImpl.class);
    }

}
