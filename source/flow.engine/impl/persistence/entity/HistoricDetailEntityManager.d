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
module flow.engine.impl.persistence.entity.HistoricDetailEntityManager;

import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.engine.history.HistoricDetail;
import flow.engine.impl.HistoricDetailQueryImpl;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricDetailEntity;
import flow.engine.impl.persistence.entity.HistoricFormPropertyEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;

/**
 * @author Joram Barrez
 */
interface HistoricDetailEntityManager : EntityManager!HistoricDetailEntity {

    HistoricFormPropertyEntity insertHistoricFormPropertyEntity(ExecutionEntity execution, string propertyId, string propertyValue, string taskId,
        Date createTime);

    HistoricDetailVariableInstanceUpdateEntity copyAndInsertHistoricDetailVariableInstanceUpdateEntity(VariableInstanceEntity variableInstance,
        Date createTime);

    long findHistoricDetailCountByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    List!HistoricDetail findHistoricDetailsByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    void deleteHistoricDetailsByTaskId(string taskId);

    List!HistoricDetail findHistoricDetailsByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricDetailCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricDetailsByProcessInstanceId(string historicProcessInstanceId);

    void deleteHistoricDetailForNonExistingProcessInstances();
}
