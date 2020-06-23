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
module flow.task.service.impl.persistence.entity.data.impl.MybatisHistoricTaskInstanceDataManager;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.AbstractDataManager;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityImpl;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.persistence.entity.data.HistoricTaskInstanceDataManager;
import flow.task.service.impl.util.CommandContextUtil;
import hunt.logging;
import hunt.entity;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
/**
 * @author Joram Barrez
 */
class MybatisHistoricTaskInstanceDataManager : AbstractDataManager!HistoricTaskInstanceEntity , HistoricTaskInstanceDataManager {

    //
    //class<? extends HistoricTaskInstanceEntity> getManagedEntityClass() {
    //    return HistoricTaskInstanceEntityImpl.class;
    //}
   this()
   {
     super(entityManagerFactory.currentEntityManager());
   }


    override
    public HistoricTaskInstanceEntity findById(string entityId) {
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
      override
      public void insert(HistoricTaskInstanceEntity entity) {
        insert(cast(HistoricTaskInstanceEntityImpl)entity);
        //getDbSqlSession().insert(entity);
      }

      override
      public HistoricTaskInstanceEntity update(HistoricTaskInstanceEntity entity) {
        return  update(cast(HistoricTaskInstanceEntityImpl)entity);
        //getDbSqlSession().update(entity);
        //return entity;
      }

      override
      public void dele(string id) {
        HistoricTaskInstanceEntity entity = findById(id);
        if (entity !is null)
        {
          remove(cast(HistoricTaskInstanceEntityImpl)entity);
        }
        //delete(entity);
      }

      override
      public void dele(HistoricTaskInstanceEntity entity) {
        if (entity !is null)
        {
          remove(cast(HistoricTaskInstanceEntityImpl)entity);
        }
        //getDbSqlSession().delete(entity);
      }

    override
    public HistoricTaskInstanceEntity create() {
        return new HistoricTaskInstanceEntityImpl();
    }


    public HistoricTaskInstanceEntity create(TaskEntity task) {
        return new HistoricTaskInstanceEntityImpl(task);
    }



    public List!HistoricTaskInstanceEntity findHistoricTasksByParentTaskId(string parentTaskId) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(HistoricTaskInstanceEntityImpl)("SELECT * FROM HistoricTaskInstanceEntityImpl u where u.parentTaskId = :parentTaskId");
        select.setParameter("parentTaskId",parentTaskId);
        HistoricTaskInstanceEntityImpl[] ls = select.getResultList();
        return new ArrayList!HistoricTaskInstanceEntity(ls);
       // return getDbSqlSession().selectList("selectHistoricTasksByParentTaskId", parentTaskId);
    }



    public List!HistoricTaskInstanceEntity findHistoricTasksByProcessInstanceId(string processInstanceId) {
        scope(exit)
        {
          _manager.close();
        }
        auto select = _manager.createQuery!(HistoricTaskInstanceEntityImpl)("SELECT * FROM HistoricTaskInstanceEntityImpl u where u.processInstanceId = :processInstanceId");
        select.setParameter("processInstanceId",processInstanceId);
        HistoricTaskInstanceEntityImpl[] ls = select.getResultList();
        return new ArrayList!HistoricTaskInstanceEntity(ls);
        //return getDbSqlSession().selectList("selectHistoricTaskInstancesByProcessInstanceId", processInstanceId);
    }


    public long findHistoricTaskInstanceCountByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoricTaskInstanceCountByQueryCriteria", historicTaskInstanceQuery);
    }



    public List!HistoricTaskInstance findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        implementationMissing(false);
        return null;
      //return getDbSqlSession().selectList("selectHistoricTaskInstancesByQueryCriteria", historicTaskInstanceQuery, getManagedEntityClass());
    }



    public List!HistoricTaskInstance findHistoricTaskInstancesAndRelatedEntitiesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        // paging doesn't work for combining task instances and variables
        // due to an outer join, so doing it in-memory
        implementationMissing(false);
        return null;
        //int firstResult = historicTaskInstanceQuery.getFirstResult();
        //int maxResults = historicTaskInstanceQuery.getMaxResults();
        //
        //// setting max results, limit to 20000 results for performance reasons
        //if (historicTaskInstanceQuery.getTaskVariablesLimit() !is null) {
        //    historicTaskInstanceQuery.setMaxResults(historicTaskInstanceQuery.getTaskVariablesLimit());
        //} else {
        //    historicTaskInstanceQuery.setMaxResults(CommandContextUtil.getTaskServiceConfiguration().getHistoricTaskQueryLimit());
        //}
        //historicTaskInstanceQuery.setFirstResult(0);
        //
        //List!HistoricTaskInstance instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(
        //                "selectHistoricTaskInstancesWithRelatedEntitiesByQueryCriteria", historicTaskInstanceQuery, getManagedEntityClass());
        //
        //if (instanceList !is null && !instanceList.isEmpty()) {
        //    if (firstResult > 0) {
        //        if (firstResult <= instanceList.size()) {
        //            int toIndex = firstResult + Math.min(maxResults, instanceList.size() - firstResult);
        //            return instanceList.subList(firstResult, toIndex);
        //        } else {
        //            return Collections.EMPTY_LIST;
        //        }
        //    } else {
        //        int toIndex = maxResults > 0 ?  Math.min(maxResults, instanceList.size()) : instanceList.size();
        //        return instanceList.subList(0, toIndex);
        //    }
        //}
        //
        //return instanceList;
    }



    public List!HistoricTaskInstance findHistoricTaskInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectListWithRawParameter("selectHistoricTaskInstanceByNativeQuery", parameterMap);
    }


    public long findHistoricTaskInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
      //  return (Long) getDbSqlSession().selectOne("selectHistoricTaskInstanceCountByNativeQuery", parameterMap);
    }


    public void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricTaskInstances", historicTaskInstanceQuery, HistoricTaskInstanceEntityImpl.class);
    }


    public void deleteHistoricTaskInstancesForNonExistingProcessInstances() {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricTaskInstancesForNonExistingProcessInstances", null, HistoricTaskInstanceEntityImpl.class);
    }


    public void deleteHistoricTaskInstancesForNonExistingCaseInstances() {
        implementationMissing(false);
       // getDbSqlSession().delete("bulkDeleteHistoricTaskInstancesForNonExistingCaseInstances", null, HistoricTaskInstanceEntityImpl.class);
    }
}
