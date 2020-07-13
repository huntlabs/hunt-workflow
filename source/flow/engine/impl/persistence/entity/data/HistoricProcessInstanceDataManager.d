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
module flow.engine.impl.persistence.entity.data.HistoricProcessInstanceDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;

/**
 * @author Joram Barrez
 */
interface HistoricProcessInstanceDataManager : DataManager!HistoricProcessInstanceEntity {

    HistoricProcessInstanceEntity create(ExecutionEntity processInstanceExecutionEntity);

    List!string findHistoricProcessInstanceIdsByProcessDefinitionId(string processDefinitionId);

    List!HistoricProcessInstance findHistoricProcessInstancesBySuperProcessInstanceId(string superProcessInstanceId);

    long findHistoricProcessInstanceCountByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List!HistoricProcessInstance findHistoricProcessInstancesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List!HistoricProcessInstance findHistoricProcessInstancesAndVariablesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List!HistoricProcessInstance findHistoricProcessInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricProcessInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricProcessInstances(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

}
