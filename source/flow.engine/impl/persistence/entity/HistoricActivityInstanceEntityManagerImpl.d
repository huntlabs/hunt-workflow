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



import hunt.collection.List;
import hunt.collection.Map;

import flow.common.history.HistoryLevel;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.HistoricActivityInstanceDataManager;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricActivityInstanceEntityManagerImpl
    extends AbstractProcessEngineEntityManager<HistoricActivityInstanceEntity, HistoricActivityInstanceDataManager>
    implements HistoricActivityInstanceEntityManager {

    public HistoricActivityInstanceEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, HistoricActivityInstanceDataManager historicActivityInstanceDataManager) {
        super(processEngineConfiguration, historicActivityInstanceDataManager);
    }

    @Override
    public List<HistoricActivityInstanceEntity> findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(string executionId, string activityId) {
        return dataManager.findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(executionId, activityId);
    }

    @Override
    public List<HistoricActivityInstanceEntity> findHistoricActivityInstancesByExecutionAndActivityId(string executionId, string activityId) {
        return dataManager.findHistoricActivityInstancesByExecutionIdAndActivityId(executionId, activityId);
    }

    @Override
    public List<HistoricActivityInstanceEntity> findUnfinishedHistoricActivityInstancesByProcessInstanceId(string processInstanceId) {
        return dataManager.findUnfinishedHistoricActivityInstancesByProcessInstanceId(processInstanceId);
    }

    @Override
    public void deleteHistoricActivityInstancesByProcessInstanceId(string historicProcessInstanceId) {
        if (getHistoryManager().isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            dataManager.deleteHistoricActivityInstancesByProcessInstanceId(historicProcessInstanceId);
        }
    }

    @Override
    public long findHistoricActivityInstanceCountByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return dataManager.findHistoricActivityInstanceCountByQueryCriteria(historicActivityInstanceQuery);
    }

    @Override
    public List<HistoricActivityInstance> findHistoricActivityInstancesByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return dataManager.findHistoricActivityInstancesByQueryCriteria(historicActivityInstanceQuery);
    }

    @Override
    public List<HistoricActivityInstance> findHistoricActivityInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricActivityInstancesByNativeQuery(parameterMap);
    }

    @Override
    public long findHistoricActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricActivityInstanceCountByNativeQuery(parameterMap);
    }

    @Override
    public void deleteHistoricActivityInstances(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery) {
        dataManager.deleteHistoricActivityInstances(historicActivityInstanceQuery);
    }

    @Override
    public void deleteHistoricActivityInstancesForNonExistingProcessInstances() {
        dataManager.deleteHistoricActivityInstancesForNonExistingProcessInstances();
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

}
