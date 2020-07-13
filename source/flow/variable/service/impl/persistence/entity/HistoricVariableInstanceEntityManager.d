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
module flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 */
interface HistoricVariableInstanceEntityManager : EntityManager!HistoricVariableInstanceEntity {

    HistoricVariableInstanceEntity createAndInsert(VariableInstanceEntity variableInstance, Date createTime);

    void copyVariableValue(HistoricVariableInstanceEntity historicVariableInstance, VariableInstanceEntity variableInstance, Date updateTime);

    List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery);

    HistoricVariableInstanceEntity findHistoricVariableInstanceByVariableInstanceId(string variableInstanceId);

    List!HistoricVariableInstanceEntity findHistoricalVariableInstancesByScopeIdAndScopeType(string subScopeId, string scopeType);

    List!HistoricVariableInstanceEntity findHistoricalVariableInstancesBySubScopeIdAndScopeType(string scopeId, string scopeType);

    long findHistoricVariableInstanceCountByQueryCriteria(HistoricVariableInstanceQueryImpl historicProcessVariableQuery);

    List!HistoricVariableInstance findHistoricVariableInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricVariableInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricVariableInstancesByTaskId(string taskId);

    void deleteHistoricVariableInstanceByProcessInstanceId(string historicProcessInstanceId);

    void deleteHistoricVariableInstancesForNonExistingProcessInstances();

    void deleteHistoricVariableInstancesForNonExistingCaseInstances();
}
