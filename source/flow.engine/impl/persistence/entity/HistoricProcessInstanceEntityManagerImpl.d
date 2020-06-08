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

module flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Collections;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.HistoricProcessInstanceDataManager;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricProcessInstanceEntityManagerImpl
    : AbstractProcessEngineEntityManager!(HistoricProcessInstanceEntity, HistoricProcessInstanceDataManager)
    , HistoricProcessInstanceEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, HistoricProcessInstanceDataManager historicProcessInstanceDataManager) {
        super(processEngineConfiguration, historicProcessInstanceDataManager);
    }


    public HistoricProcessInstanceEntity create(ExecutionEntity processInstanceExecutionEntity) {
        return dataManager.create(processInstanceExecutionEntity);
    }


    public long findHistoricProcessInstanceCountByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        if (getHistoryManager().isHistoryEnabled()) {
            return dataManager.findHistoricProcessInstanceCountByQueryCriteria(historicProcessInstanceQuery);
        }
        return 0;
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        if (getHistoryManager().isHistoryEnabled()) {
            return dataManager.findHistoricProcessInstancesByQueryCriteria(historicProcessInstanceQuery);
        }
        return Collections.emptyList!HistoricProcessInstance;
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesAndVariablesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        if (getHistoryManager().isHistoryEnabled()) {
            return dataManager.findHistoricProcessInstancesAndVariablesByQueryCriteria(historicProcessInstanceQuery);
        }
        return Collections.emptyList!HistoricProcessInstance;
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricProcessInstancesByNativeQuery(parameterMap);
    }


    public List!HistoricProcessInstance findHistoricProcessInstancesBySuperProcessInstanceId(string historicProcessInstanceId) {
        return dataManager.findHistoricProcessInstancesBySuperProcessInstanceId(historicProcessInstanceId);
    }


    public List!string findHistoricProcessInstanceIdsByProcessDefinitionId(string processDefinitionId) {
        return dataManager.findHistoricProcessInstanceIdsByProcessDefinitionId(processDefinitionId);
    }


    public long findHistoricProcessInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricProcessInstanceCountByNativeQuery(parameterMap);
    }


    public void deleteHistoricProcessInstances(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery) {
        dataManager.deleteHistoricProcessInstances(historicProcessInstanceQuery);
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

}
