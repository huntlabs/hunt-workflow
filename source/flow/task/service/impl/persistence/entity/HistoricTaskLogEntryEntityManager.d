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
module flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.service.impl.HistoricTaskLogEntryQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;

/**
 * @author martin.grofcik
 */
interface HistoricTaskLogEntryEntityManager : EntityManager!HistoricTaskLogEntryEntity {

    void deleteHistoricTaskLogEntry(long logNr);

    void createHistoricTaskLogEntry(HistoricTaskLogEntryBuilder historicTaskLogEntryBuilder);

    List!HistoricTaskLogEntry findHistoricTaskLogEntriesByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery);

    long findHistoricTaskLogEntriesCountByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery);

    List!HistoricTaskLogEntry findHistoricTaskLogEntriesByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery);

    long findHistoricTaskLogEntriesCountByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery);

    void deleteHistoricTaskLogEntriesForProcessDefinition(string processDefinitionId);

    void deleteHistoricTaskLogEntriesForScopeDefinition(string scopeType, string scopeDefinitionId);

    void deleteHistoricTaskLogEntriesForTaskId(string taskId);

    void deleteHistoricTaskLogEntriesForNonExistingProcessInstances();

    void deleteHistoricTaskLogEntriesForNonExistingCaseInstances();
}
