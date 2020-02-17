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


import java.util.Collections;
import java.util.List;
import java.util.Map;

import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.HistoricProcessInstanceDataManager;

/**
 * @author Joram Barrez
 */
class MybatisHistoricProcessInstanceDataManager extends AbstractProcessDataManager<HistoricProcessInstanceEntity> implements HistoricProcessInstanceDataManager {

    public MybatisHistoricProcessInstanceDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends HistoricProcessInstanceEntity> getManagedEntityClass() {
        return HistoricProcessInstanceEntityImpl.class;
    }

    @Override
    public HistoricProcessInstanceEntity create() {
        return new HistoricProcessInstanceEntityImpl();
    }

    @Override
    public HistoricProcessInstanceEntity create(ExecutionEntity processInstanceExecutionEntity) {
        return new HistoricProcessInstanceEntityImpl(processInstanceExecutionEntity);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<string> findHistoricProcessInstanceIdsByProcessDefinitionId(string processDefinitionId) {
        return getDbSqlSession().selectList("selectHistoricProcessInstanceIdsByProcessDefinitionId", processDefinitionId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricProcessInstance> findHistoricProcessInstancesBySuperProcessInstanceId(string superProcessInstanceId) {
        return getDbSqlSession().selectList("selectHistoricProcessInstanceIdsBySuperProcessInstanceId", superProcessInstanceId);
    }

    @Override
    public long findHistoricProcessInstanceCountByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        return (Long) getDbSqlSession().selectOne("selectHistoricProcessInstanceCountByQueryCriteria", historicProcessInstanceQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricProcessInstance> findHistoricProcessInstancesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        return getDbSqlSession().selectList("selectHistoricProcessInstancesByQueryCriteria", historicProcessInstanceQuery, getManagedEntityClass());
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricProcessInstance> findHistoricProcessInstancesAndVariablesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        // paging doesn't work for combining process instances and variables
        // due to an outer join, so doing it in-memory

        int firstResult = historicProcessInstanceQuery.getFirstResult();
        int maxResults = historicProcessInstanceQuery.getMaxResults();

        // setting max results, limit to 20000 results for performance reasons
        if (historicProcessInstanceQuery.getProcessInstanceVariablesLimit() != null) {
            historicProcessInstanceQuery.setMaxResults(historicProcessInstanceQuery.getProcessInstanceVariablesLimit());
        } else {
            historicProcessInstanceQuery.setMaxResults(getProcessEngineConfiguration().getHistoricProcessInstancesQueryLimit());
        }
        historicProcessInstanceQuery.setFirstResult(0);

        List<HistoricProcessInstance> instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(
                        "selectHistoricProcessInstancesWithVariablesByQueryCriteria", historicProcessInstanceQuery, getManagedEntityClass());

        if (instanceList != null && !instanceList.isEmpty()) {
            if (firstResult > 0) {
                if (firstResult <= instanceList.size()) {
                    int toIndex = firstResult + Math.min(maxResults, instanceList.size() - firstResult);
                    return instanceList.subList(firstResult, toIndex);
                } else {
                    return Collections.EMPTY_LIST;
                }
            } else {
                int toIndex = maxResults > 0 ?  Math.min(maxResults, instanceList.size()) : instanceList.size();
                return instanceList.subList(0, toIndex);
            }
        }

        return instanceList;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricProcessInstance> findHistoricProcessInstancesByNativeQuery(Map<string, Object> parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectHistoricProcessInstanceByNativeQuery", parameterMap);
    }

    @Override
    public long findHistoricProcessInstanceCountByNativeQuery(Map<string, Object> parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectHistoricProcessInstanceCountByNativeQuery", parameterMap);
    }

    @Override
    public void deleteHistoricProcessInstances(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        getDbSqlSession().delete("bulkDeleteHistoricProcessInstances", historicProcessInstanceQuery, HistoricProcessInstanceEntityImpl.class);
    }

}
