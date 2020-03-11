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


import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.HistoricActivityInstanceDataManager;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.HistoricActivityInstanceMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.UnfinishedHistoricActivityInstanceMatcher;

/**
 * @author Joram Barrez
 */
class MybatisHistoricActivityInstanceDataManager extends AbstractProcessDataManager<HistoricActivityInstanceEntity> implements HistoricActivityInstanceDataManager {

    protected CachedEntityMatcher<HistoricActivityInstanceEntity> unfinishedHistoricActivityInstanceMatcher = new UnfinishedHistoricActivityInstanceMatcher();
    protected CachedEntityMatcher<HistoricActivityInstanceEntity> historicActivityInstanceMatcher = new HistoricActivityInstanceMatcher();

    public MybatisHistoricActivityInstanceDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends HistoricActivityInstanceEntity> getManagedEntityClass() {
        return HistoricActivityInstanceEntityImpl.class;
    }

    @Override
    public HistoricActivityInstanceEntity create() {
        return new HistoricActivityInstanceEntityImpl();
    }

    @Override
    public List<HistoricActivityInstanceEntity> findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(final string executionId, final string activityId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("executionId", executionId);
        params.put("activityId", activityId);
        return getList("selectUnfinishedHistoricActivityInstanceExecutionIdAndActivityId", params, unfinishedHistoricActivityInstanceMatcher, true);
    }

    @Override
    public List<HistoricActivityInstanceEntity> findHistoricActivityInstancesByExecutionIdAndActivityId(final string executionId, final string activityId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("executionId", executionId);
        params.put("activityId", activityId);
        return getList("selectHistoricActivityInstanceExecutionIdAndActivityId", params, historicActivityInstanceMatcher, true);
    }

    @Override
    public List<HistoricActivityInstanceEntity> findUnfinishedHistoricActivityInstancesByProcessInstanceId(final string processInstanceId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("processInstanceId", processInstanceId);
        return getList("selectUnfinishedHistoricActivityInstanceByProcessInstanceId", params, unfinishedHistoricActivityInstanceMatcher, true);
    }

    @Override
    public void deleteHistoricActivityInstancesByProcessInstanceId(string historicProcessInstanceId) {
        getDbSqlSession().delete("deleteHistoricActivityInstancesByProcessInstanceId", historicProcessInstanceId, HistoricActivityInstanceEntityImpl.class);
    }

    @Override
    public long findHistoricActivityInstanceCountByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return (Long) getDbSqlSession().selectOne("selectHistoricActivityInstanceCountByQueryCriteria", historicActivityInstanceQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricActivityInstance> findHistoricActivityInstancesByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return getDbSqlSession().selectList("selectHistoricActivityInstancesByQueryCriteria", historicActivityInstanceQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoricActivityInstance> findHistoricActivityInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectHistoricActivityInstanceByNativeQuery", parameterMap);
    }

    @Override
    public long findHistoricActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectHistoricActivityInstanceCountByNativeQuery", parameterMap);
    }

    @Override
    public void deleteHistoricActivityInstances(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        getDbSqlSession().delete("bulkDeleteHistoricActivityInstances", historicActivityInstanceQuery, HistoricActivityInstanceEntityImpl.class);
    }

    @Override
    public void deleteHistoricActivityInstancesForNonExistingProcessInstances() {
        getDbSqlSession().delete("bulkDeleteHistoricActivityInstancesForNonExistingProcessInstances", null, HistoricActivityInstanceEntityImpl.class);
    }

}
