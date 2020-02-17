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


import java.util.Date;
import java.util.List;
import java.util.Map;

import flow.common.persistence.entity.EntityManager;
import flow.engine.history.HistoricDetail;
import flow.engine.impl.HistoricDetailQueryImpl;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 */
interface HistoricDetailEntityManager extends EntityManager<HistoricDetailEntity> {

    HistoricFormPropertyEntity insertHistoricFormPropertyEntity(ExecutionEntity execution, string propertyId, string propertyValue, string taskId,
        Date createTime);

    HistoricDetailVariableInstanceUpdateEntity copyAndInsertHistoricDetailVariableInstanceUpdateEntity(VariableInstanceEntity variableInstance,
        Date createTime);

    long findHistoricDetailCountByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    List<HistoricDetail> findHistoricDetailsByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    void deleteHistoricDetailsByTaskId(string taskId);

    List<HistoricDetail> findHistoricDetailsByNativeQuery(Map<string, Object> parameterMap);

    long findHistoricDetailCountByNativeQuery(Map<string, Object> parameterMap);

    void deleteHistoricDetailsByProcessInstanceId(string historicProcessInstanceId);

    void deleteHistoricDetailForNonExistingProcessInstances();
}