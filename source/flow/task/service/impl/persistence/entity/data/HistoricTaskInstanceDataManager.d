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

module flow.task.service.impl.persistence.entity.data.HistoricTaskInstanceDataManager;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
interface HistoricTaskInstanceDataManager : DataManager!HistoricTaskInstanceEntity {

    HistoricTaskInstanceEntity create(TaskEntity task);

    HistoricTaskInstanceEntity create();

    List!HistoricTaskInstanceEntity findHistoricTasksByParentTaskId(string parentTaskId);

    List!HistoricTaskInstanceEntity findHistoricTasksByProcessInstanceId(string processInstanceId);

    long findHistoricTaskInstanceCountByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    List!HistoricTaskInstance findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    List!HistoricTaskInstance findHistoricTaskInstancesAndRelatedEntitiesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    List!HistoricTaskInstance findHistoricTaskInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricTaskInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    void deleteHistoricTaskInstancesForNonExistingProcessInstances();

    void deleteHistoricTaskInstancesForNonExistingCaseInstances();
}
