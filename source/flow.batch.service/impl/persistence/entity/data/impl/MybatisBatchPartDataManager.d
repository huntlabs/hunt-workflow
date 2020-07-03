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
module flow.batch.service.impl.persistence.entity.data.impl.MybatisBatchPartDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;

import flow.batch.service.api.BatchPart;
import flow.batch.service.impl.persistence.entity.BatchPartEntity;
import flow.batch.service.impl.persistence.entity.BatchPartEntityImpl;
import flow.batch.service.impl.persistence.entity.data.BatchPartDataManager;
import flow.common.db.AbstractDataManager;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;


class MybatisBatchPartDataManager : EntityRepository!( BatchPartEntityImpl , string) , BatchPartDataManager {
    //
    //
    //public Class<? extends BatchPartEntity> getManagedEntityClass() {
    //    return BatchPartEntityImpl.class;
    //}
    alias findById = CrudRepository!(BatchPartEntityImpl, string).findById;
    alias insert = CrudRepository!(BatchPartEntityImpl, string).insert;
    alias update = CrudRepository!(BatchPartEntityImpl, string).update;
    this()
    {
      super(entityManagerFactory.currentEntityManager());
    }

    public BatchPartEntity create() {
        return new BatchPartEntityImpl();
    }


        public BatchPartEntity findById(string entityId) {
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
      public void insert(BatchPartEntity entity) {
        super.insert(cast(BatchPartEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      //
      //@Override
      public BatchPartEntity update(BatchPartEntity entity) {
        return  super.update(cast(BatchPartEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      //
      //@Override
      public void dele(string id) {
        BatchPartEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(BatchPartEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(BatchPartEntity entity) {
        if (entity !is null)
        {
          remove(cast(BatchPartEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }


    public List!BatchPart findBatchPartsByBatchId(string batchId) {
        implementationMissing(false);
        return null;
        //HashMap<string, Object> params = new HashMap<>();
        //params.put("batchId", batchId);
        //
        //return getDbSqlSession().selectList("selectBatchPartsByBatchId", params);
    }



    public List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status) {
        implementationMissing(false);
        return null;
        //HashMap<string, Object> params = new HashMap<>();
        //params.put("batchId", batchId);
        //params.put("status", status);
        //
        //return getDbSqlSession().selectList("selectBatchPartsByBatchIdAndStatus", params);
    }



    public List!BatchPart findBatchPartsByScopeIdAndType(string scopeId, string scopeType) {
        implementationMissing(false);
        return null;
        //HashMap<string, Object> params = new HashMap<>();
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //
        //return getDbSqlSession().selectList("selectBatchPartsByScopeIdAndType", params);
    }
}
