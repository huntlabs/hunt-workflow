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
module flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.impl.BatchQueryImpl;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.batch.service.impl.persistence.entity.BatchEntityImpl;
import flow.batch.service.impl.persistence.entity.data.BatchDataManager;
import flow.common.db.AbstractDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;

class MybatisBatchDataManager : EntityRepository!( BatchEntityImpl , string) , BatchDataManager {

    //
    //public Class<? extends BatchEntity> getManagedEntityClass() {
    //    return BatchEntityImpl.class;
    //}
    alias findById = CrudRepository!(BatchEntityImpl, string).findById;
    alias insert = CrudRepository!(BatchEntityImpl, string).insert;
    alias update = CrudRepository!(BatchEntityImpl, string).update;

    this()
    {
      super(entityManagerFactory.currentEntityManager());
    }

    public BatchEntity create() {
        return new BatchEntityImpl();
    }


        public BatchEntity findById(string entityId) {
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
      public void insert(BatchEntity entity) {
        super.insert(cast(BatchEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      //
      //@Override
      public BatchEntity update(BatchEntity entity) {
        return  super.update(cast(BatchEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      //
      //@Override
      public void dele(string id) {
        BatchEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(BatchEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(BatchEntity entity) {
        if (entity !is null)
        {
          remove(cast(BatchEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }



    public List!Batch findBatchesBySearchKey(string searchKey) {
        implementationMissing(false);
        return null;
        //HashMap<string, Object> params = new HashMap<>();
        //params.put("searchKey", searchKey);
        //params.put("searchKey2", searchKey);
        //
        //return getDbSqlSession().selectList("selectBatchesBySearchKey", params);
    }



    public List!Batch findAllBatches() {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectAllBatches");
    }



    public List!Batch findBatchesByQueryCriteria(BatchQueryImpl batchQuery) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectBatchByQueryCriteria", batchQuery, getManagedEntityClass());
    }


    public long findBatchCountByQueryCriteria(BatchQueryImpl batchQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectBatchCountByQueryCriteria", batchQuery);
    }
}
