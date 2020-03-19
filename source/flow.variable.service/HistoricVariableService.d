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
module flow.variable.service.HistoricVariableService;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * Service which provides access to historic variables.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface HistoricVariableService {

    HistoricVariableInstanceEntity getHistoricVariableInstance(string id);

    HistoricVariableInstanceEntity createHistoricVariableInstance();

    List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl query);

    void insertHistoricVariableInstance(HistoricVariableInstanceEntity variable);

    HistoricVariableInstanceEntity createAndInsert(VariableInstanceEntity variable, Date createTime);

    void recordVariableUpdate(VariableInstanceEntity variableInstanceEntity, Date updateTime);

    void recordVariableRemoved(VariableInstanceEntity variableInstanceEntity);

    void deleteHistoricVariableInstance(HistoricVariableInstanceEntity historicVariable);

    void deleteHistoricVariableInstancesByProcessInstanceId(string processInstanceId);

    void deleteHistoricVariableInstancesByTaskId(string taskId);

    void deleteHistoricVariableInstancesForNonExistingProcessInstances();

    void deleteHistoricVariableInstancesForNonExistingCaseInstances();
}