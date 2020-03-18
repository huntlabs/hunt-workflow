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
module flow.variable.service.impl.persistence.entity.data.HistoricVariableInstanceDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

/**
 * @author Joram Barrez
 */
interface HistoricVariableInstanceDataManager : DataManager!HistoricVariableInstanceEntity {

    List!HistoricVariableInstanceEntity findHistoricVariableInstancesByProcessInstanceId(string processInstanceId);

    List!HistoricVariableInstanceEntity findHistoricVariableInstancesByTaskId(string taskId);

    long findHistoricVariableInstanceCountByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery);

    List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery);

    HistoricVariableInstanceEntity findHistoricVariableInstanceByVariableInstanceId(string variableInstanceId);

    List!HistoricVariableInstanceEntity findHistoricalVariableInstancesByScopeIdAndScopeType(string scopeId, string scopeType);

    List!HistoricVariableInstanceEntity findHistoricalVariableInstancesBySubScopeIdAndScopeType(string subScopeId, string scopeType);

    List!HistoricVariableInstance findHistoricVariableInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricVariableInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricVariableInstancesForNonExistingProcessInstances();

    void deleteHistoricVariableInstancesForNonExistingCaseInstances();
}
