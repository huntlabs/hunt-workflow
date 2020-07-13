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

module flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManagerImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.history.HistoryLevel;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.data.HistoricVariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
/**
 * @author Christian Lipphardt (camunda)
 * @author Joram Barrez
 */
class HistoricVariableInstanceEntityManagerImpl
    : AbstractServiceEngineEntityManager!(VariableServiceConfiguration, HistoricVariableInstanceEntity, HistoricVariableInstanceDataManager)
    , HistoricVariableInstanceEntityManager {

    this(VariableServiceConfiguration variableServiceConfiguration, HistoricVariableInstanceDataManager historicVariableInstanceDataManager) {
        super(variableServiceConfiguration, historicVariableInstanceDataManager);
    }


    public HistoricVariableInstanceEntity createAndInsert(VariableInstanceEntity variableInstance, Date createTime) {
        HistoricVariableInstanceEntity historicVariableInstance = dataManager.create();
        historicVariableInstance.setId(variableInstance.getId());
        historicVariableInstance.setProcessInstanceId(variableInstance.getProcessInstanceId());
        historicVariableInstance.setExecutionId(variableInstance.getExecutionId());
        historicVariableInstance.setTaskId(variableInstance.getTaskId());
        historicVariableInstance.setRevision(variableInstance.getRevision());
        historicVariableInstance.setName(variableInstance.getName());
        historicVariableInstance.setVariableType(variableInstance.getType());
        historicVariableInstance.setScopeId(variableInstance.getScopeId());
        historicVariableInstance.setSubScopeId(variableInstance.getSubScopeId());
        historicVariableInstance.setScopeType(variableInstance.getScopeType());

        copyVariableValue(historicVariableInstance, variableInstance, createTime);

        historicVariableInstance.setCreateTime(createTime);
        historicVariableInstance.setLastUpdatedTime(createTime);

        insert(historicVariableInstance);

        return historicVariableInstance;
    }


    public void copyVariableValue(HistoricVariableInstanceEntity historicVariableInstance, VariableInstanceEntity variableInstance, Date updateTime) {
        historicVariableInstance.setTextValue(variableInstance.getTextValue());
        historicVariableInstance.setTextValue2(variableInstance.getTextValue2());
        historicVariableInstance.setDoubleValue(variableInstance.getDoubleValue());
        historicVariableInstance.setLongValue(variableInstance.getLongValue());

        historicVariableInstance.setVariableType(variableInstance.getType());
        if (variableInstance.getByteArrayRef() !is null) {
            historicVariableInstance.setBytes(variableInstance.getBytes());
        }

        historicVariableInstance.setLastUpdatedTime(updateTime);
    }

    override
    public void dele(HistoricVariableInstanceEntity entity, bool fireDeleteEvent) {
        super.dele(entity, fireDeleteEvent);

        if (entity.getByteArrayRef() !is null) {
            entity.getByteArrayRef().dele();
        }
    }


    public void deleteHistoricVariableInstanceByProcessInstanceId( string historicProcessInstanceId) {
        if (serviceConfiguration.isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            List!HistoricVariableInstanceEntity historicProcessVariables = dataManager.findHistoricVariableInstancesByProcessInstanceId(historicProcessInstanceId);
            foreach (HistoricVariableInstanceEntity historicProcessVariable ; historicProcessVariables) {
                super.dele(historicProcessVariable);
            }
        }
    }


    public long findHistoricVariableInstanceCountByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery) {
        return dataManager.findHistoricVariableInstanceCountByQueryCriteria(historicProcessVariableQuery);
    }


    public List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery) {
        return dataManager.findHistoricVariableInstancesByQueryCriteria(historicProcessVariableQuery);
    }


    public HistoricVariableInstanceEntity findHistoricVariableInstanceByVariableInstanceId(string variableInstanceId) {
        return dataManager.findHistoricVariableInstanceByVariableInstanceId(variableInstanceId);
    }


    public List!HistoricVariableInstanceEntity findHistoricalVariableInstancesByScopeIdAndScopeType(string scopeId, string scopeType) {
        return dataManager.findHistoricalVariableInstancesByScopeIdAndScopeType(scopeId, scopeType);
    }


    public List!HistoricVariableInstanceEntity findHistoricalVariableInstancesBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return dataManager.findHistoricalVariableInstancesBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public void deleteHistoricVariableInstancesByTaskId(string taskId) {
        if (serviceConfiguration.isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            List!HistoricVariableInstanceEntity historicProcessVariables = dataManager.findHistoricVariableInstancesByTaskId(taskId);
            foreach (HistoricVariableInstanceEntity historicProcessVariable ; historicProcessVariables) {
                super.dele(historicProcessVariable);
            }
        }
    }


    public void deleteHistoricVariableInstancesForNonExistingProcessInstances() {
        if (serviceConfiguration.isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            dataManager.deleteHistoricVariableInstancesForNonExistingProcessInstances();
        }
    }


    public void deleteHistoricVariableInstancesForNonExistingCaseInstances() {
        if (serviceConfiguration.isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            dataManager.deleteHistoricVariableInstancesForNonExistingCaseInstances();
        }
    }


    public List!HistoricVariableInstance findHistoricVariableInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricVariableInstancesByNativeQuery(parameterMap);
    }


    public long findHistoricVariableInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricVariableInstanceCountByNativeQuery(parameterMap);
    }

}
