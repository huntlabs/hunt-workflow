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


import java.util.List;
import java.util.Map;

import flow.common.persistence.entity.EntityManager;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.HistoricProcessInstanceQueryImpl;

/**
 * @author Joram Barrez
 */
interface HistoricProcessInstanceEntityManager extends EntityManager<HistoricProcessInstanceEntity> {

    @Override
    HistoricProcessInstanceEntity create();
  
    HistoricProcessInstanceEntity create(ExecutionEntity processInstanceExecutionEntity);

    long findHistoricProcessInstanceCountByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List<HistoricProcessInstance> findHistoricProcessInstancesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List<HistoricProcessInstance> findHistoricProcessInstancesAndVariablesByQueryCriteria(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

    List<HistoricProcessInstance> findHistoricProcessInstancesByNativeQuery(Map<string, Object> parameterMap);

    List<HistoricProcessInstance> findHistoricProcessInstancesBySuperProcessInstanceId(string historicProcessInstanceId);
    
    List<string> findHistoricProcessInstanceIdsByProcessDefinitionId(string processDefinitionId);
    
    long findHistoricProcessInstanceCountByNativeQuery(Map<string, Object> parameterMap);
    
    void deleteHistoricProcessInstances(HistoricProcessInstanceQueryImpl historicProcessInstanceQuery);

}