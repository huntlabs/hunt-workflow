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
module flow.engine.impl.persistence.entity.data.impl.MybatisHistoricProcessInstanceDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.HistoricProcessInstanceDataManager;
import hunt.entity;
import hunt.collection.ArrayList;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.runtime.Clock;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class MybatisHistoricProcessInstanceDataManager : EntityRepository!(HistoricProcessInstanceEntityImpl , string) , HistoricProcessInstanceDataManager {

    private ProcessEngineConfigurationImpl processEngineConfiguration;


    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
      return processEngineConfiguration;
    }

    public Clock getClock() {
      return processEngineConfiguration.getClock();
    }

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
      this.processEngineConfiguration = processEngineConfiguration;
      super(entityManagerFactory.createEntityManager());
    }


    //class<? : ResourceEntity> getManagedEntityClass() {
    //    return ResourceEntityImpl.class;
    //}

  public HistoricProcessInstanceEntity findById(string entityId) {
    if (entityId is null) {
      return null;
    }

    return find(entityId);
  }
  //
  public void insert(HistoricProcessInstanceEntity entity) {
    insert(cast(HistoricProcessInstanceEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public HistoricProcessInstanceEntity update(HistoricProcessInstanceEntity entity) {
    return  update(cast(HistoricProcessInstanceEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    HistoricProcessInstanceEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(HistoricProcessInstanceEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(HistoricProcessInstanceEntity entity) {
    if (entity !is null)
    {
      remove(cast(HistoricProcessInstanceEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

    //
    //class<? : HistoricProcessInstanceEntity> getManagedEntityClass() {
    //    return HistoricProcessInstanceEntityImpl.class;
    //}


    public HistoricProcessInstanceEntity create() {
        return new HistoricProcessInstanceEntityImpl();
    }


    public HistoricProcessInstanceEntity create(ExecutionEntity processInstanceExecutionEntity) {
        return new HistoricProcessInstanceEntityImpl(processInstanceExecutionEntity);
    }


    public List!string findHistoricProcessInstanceIdsByProcessDefinitionId(string processDefinitionId) {
      scope(exit)
      {
        _manager.close();
      }

      string[] array =  _manager.createQuery!(string)("SELECT id FROM HistoricProcessInstanceEntityImpl u WHERE u.processDefinitionId = :processDefinitionId")
      .setParameter("processDefinitionId",processDefinitionId)
      .getResultList();
      return new ArrayList!string(array);
      //  return getDbSqlSession().selectList("selectHistoricProcessInstanceIdsByProcessDefinitionId", processDefinitionId);
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesBySuperProcessInstanceId(string superProcessInstanceId) {
        scope(exit)
        {
          _manager.close();
        }

        HistoricProcessInstanceEntityImpl[] array =  _manager.createQuery!(HistoricProcessInstanceEntityImpl)("SELECT * FROM HistoricProcessInstanceEntityImpl u WHERE u.superProcessInstanceId = :superProcessInstanceId")
        .setParameter("superProcessInstanceId",superProcessInstanceId)
        .getResultList();
        return new ArrayList!HistoricProcessInstanceEntityImpl(array);
        //return getDbSqlSession().selectList("selectHistoricProcessInstanceIdsBySuperProcessInstanceId", superProcessInstanceId);
    }


    public long findHistoricProcessInstanceCountByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoricProcessInstanceCountByQueryCriteria", historicProcessInstanceQuery);
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
         implementationMissing(false);
         return null;
       // return getDbSqlSession().selectList("selectHistoricProcessInstancesByQueryCriteria", historicProcessInstanceQuery, getManagedEntityClass());
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesAndVariablesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        // paging doesn't work for combining process instances and variables
        // due to an outer join, so doing it in-memory
        implementationMissing(false);
        return null;
        //int firstResult = historicProcessInstanceQuery.getFirstResult();
        //int maxResults = historicProcessInstanceQuery.getMaxResults();
        //
        //// setting max results, limit to 20000 results for performance reasons
        //if (historicProcessInstanceQuery.getProcessInstanceVariablesLimit() !is null) {
        //    historicProcessInstanceQuery.setMaxResults(historicProcessInstanceQuery.getProcessInstanceVariablesLimit());
        //} else {
        //    historicProcessInstanceQuery.setMaxResults(getProcessEngineConfiguration().getHistoricProcessInstancesQueryLimit());
        //}
        //historicProcessInstanceQuery.setFirstResult(0);
        //
        //List!HistoricProcessInstance instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(
        //                "selectHistoricProcessInstancesWithVariablesByQueryCriteria", historicProcessInstanceQuery, getManagedEntityClass());
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


    public List!HistoricProcessInstance findHistoricProcessInstancesByNativeQuery(Map!(string, Object) parameterMap) {
          implementationMissing(false);
          return null;
        //return getDbSqlSession().selectListWithRawParameter("selectHistoricProcessInstanceByNativeQuery", parameterMap);
    }


    public long findHistoricProcessInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        implementationMissing(false);
        return null;
       // return (Long) getDbSqlSession().selectOne("selectHistoricProcessInstanceCountByNativeQuery", parameterMap);
    }


    public void deleteHistoricProcessInstances(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        implementationMissing(false);
        //getDbSqlSession().delete("bulkDeleteHistoricProcessInstances", historicProcessInstanceQuery, HistoricProcessInstanceEntityImpl.class);
    }

}
