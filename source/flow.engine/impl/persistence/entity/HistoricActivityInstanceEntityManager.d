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
module flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
/**
 * @author Joram Barrez
 */
interface HistoricActivityInstanceEntityManager : EntityManager!HistoricActivityInstanceEntity {

    List!HistoricActivityInstanceEntity findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(string executionId, string activityId);

    List!HistoricActivityInstanceEntity findHistoricActivityInstancesByExecutionAndActivityId(string executionId, string activityId);

    List!HistoricActivityInstanceEntity findUnfinishedHistoricActivityInstancesByProcessInstanceId(string processInstanceId);

    long findHistoricActivityInstanceCountByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery);

    List!HistoricActivityInstance findHistoricActivityInstancesByQueryCriteria(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery);

    List!HistoricActivityInstance findHistoricActivityInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findHistoricActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap);

    void deleteHistoricActivityInstancesByProcessInstanceId(string historicProcessInstanceId);

    void deleteHistoricActivityInstances(HistoricActivityInstanceQueryImpl historicActivityInstanceQuery);

    void deleteHistoricActivityInstancesForNonExistingProcessInstances();
}
