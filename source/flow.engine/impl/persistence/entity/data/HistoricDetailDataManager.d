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

import flow.common.persistence.entity.data.DataManager;
import flow.engine.history.HistoricDetail;
import flow.engine.impl.HistoricDetailQueryImpl;
import flow.engine.impl.persistence.entity.HistoricDetailAssignmentEntity;
import flow.engine.impl.persistence.entity.HistoricDetailEntity;
import flow.engine.impl.persistence.entity.HistoricDetailVariableInstanceUpdateEntity;
import flow.engine.impl.persistence.entity.HistoricFormPropertyEntity;

/**
 * @author Joram Barrez
 */
interface HistoricDetailDataManager extends DataManager<HistoricDetailEntity> {

    HistoricDetailAssignmentEntity createHistoricDetailAssignment();

    HistoricDetailVariableInstanceUpdateEntity createHistoricDetailVariableInstanceUpdate();

    HistoricFormPropertyEntity createHistoricFormProperty();

    List<HistoricDetailEntity> findHistoricDetailsByProcessInstanceId(string processInstanceId);

    List<HistoricDetailEntity> findHistoricDetailsByTaskId(string taskId);

    long findHistoricDetailCountByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    List<HistoricDetail> findHistoricDetailsByQueryCriteria(HistoricDetailQueryImpl historicVariableUpdateQuery);

    List<HistoricDetail> findHistoricDetailsByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricDetailCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricDetailForNonExistingProcessInstances();
}
