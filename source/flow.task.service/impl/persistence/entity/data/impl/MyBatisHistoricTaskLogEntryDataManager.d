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
module flow.task.service.impl.persistence.entity.data.impl.MyBatisHistoricTaskLogEntryDataManager;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.AbstractDataManager;
import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.service.impl.HistoricTaskLogEntryQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityImpl;
import flow.task.service.impl.persistence.entity.data.HistoricTaskLogEntryDataManager;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author martin.grofcik
 */
class MyBatisHistoricTaskLogEntryDataManager : EntityRepository!( HistoricTaskLogEntryEntityImpl , string) , HistoricTaskLogEntryDataManager {

    //
    //class<? extends HistoricTaskLogEntryEntity> getManagedEntityClass() {
    //    return HistoricTaskLogEntryEntityImpl.class;
    //}
    this()
    {
      super(entityManagerFactory.createEntityManager());
    }


  public HistoricTaskLogEntryEntity findById(string entityId) {
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
      public void insert(HistoricTaskLogEntryEntity entity) {
        insert(cast(HistoricTaskLogEntryEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }
      public HistoricTaskLogEntryEntity update(HistoricTaskLogEntryEntity entity) {
        return  update(cast(HistoricTaskLogEntryEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }
      public void dele(string id) {
        HistoricTaskLogEntryEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(HistoricTaskLogEntryEntityImpl)entity);
        }
        //delete(entity);
      }

      public void dele(HistoricTaskLogEntryEntity entity) {
        if (entity !is null)
        {
          remove(cast(HistoricTaskLogEntryEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }

    public HistoricTaskLogEntryEntity create() {
        return new HistoricTaskLogEntryEntityImpl();
    }


    public long findHistoricTaskLogEntriesCountByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoricTaskLogEntriesCountByQueryCriteria", taskLogEntryQuery);
    }


    public List!HistoricTaskLogEntry findHistoricTaskLogEntriesByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery) {
       // return getDbSqlSession().selectList("selectHistoricTaskLogEntriesByQueryCriteria", taskLogEntryQuery);
        implementationMissing(false);
        return null;
    }


    public void deleteHistoricTaskLogEntry(long logEntryNumber) {
        implementationMissing(false);

       // getDbSqlSession().delete("deleteHistoricTaskLogEntryByLogNumber", logEntryNumber, HistoricTaskLogEntryEntityImpl.class);
    }


    public void deleteHistoricTaskLogEntriesByProcessDefinitionId(string processDefinitionId) {
        implementationMissing(false);

       // getDbSqlSession().delete("deleteHistoricTaskLogEntriesByProcessDefinitionId", processDefinitionId, HistoricTaskLogEntryEntityImpl.class);
    }


    public void deleteHistoricTaskLogEntriesByScopeDefinitionId(string scopeType, string scopeDefinitionId) {
        implementationMissing(false);
        //Map!(string, string) params = new HashMap<>(2);
        //params.put("scopeDefinitionId", scopeDefinitionId);
        //params.put("scopeType", scopeType);
        //getDbSqlSession().delete("deleteHistoricTaskLogEntriesByScopeDefinitionId", params, HistoricTaskLogEntryEntityImpl.class);
    }


    public void deleteHistoricTaskLogEntriesByTaskId(string taskId) {
        implementationMissing(false);
       // getDbSqlSession().delete("deleteHistoricTaskLogEntriesByTaskId", taskId, HistoricTaskLogEntryEntityImpl.class);
    }


    public void deleteHistoricTaskLogEntriesForNonExistingProcessInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricTaskLogEntriesForNonExistingProcessInstances", null, HistoricTaskLogEntryEntityImpl.class);
    }


    public void deleteHistoricTaskLogEntriesForNonExistingCaseInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricTaskLogEntriesForNonExistingCaseInstances", null, HistoricTaskLogEntryEntityImpl.class);
    }


    public long findHistoricTaskLogEntriesCountByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoricTaskLogEntriesCountByNativeQueryCriteria", nativeHistoricTaskLogEntryQuery);
    }

    public List!HistoricTaskLogEntry findHistoricTaskLogEntriesByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery) {
        implementationMissing(false);
        return null;
       // return getDbSqlSession().selectListWithRawParameter("selectHistoricTaskLogEntriesByNativeQueryCriteria", nativeHistoricTaskLogEntryQuery);
    }
}
