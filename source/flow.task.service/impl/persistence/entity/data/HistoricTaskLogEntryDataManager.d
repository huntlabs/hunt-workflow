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
import flow.task.api.history.HistoricTaskLogEntry;
import org.flowable.task.service.impl.HistoricTaskLogEntryQueryImpl;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;

/**
 * author martin.grofcik
 */
interface HistoricTaskLogEntryDataManager extends DataManager<HistoricTaskLogEntryEntity> {

    void deleteHistoricTaskLogEntry(long logEntryNumber);

    long findHistoricTaskLogEntriesCountByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery);

    List<HistoricTaskLogEntry> findHistoricTaskLogEntriesByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery);

    long findHistoricTaskLogEntriesCountByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery);

    List<HistoricTaskLogEntry> findHistoricTaskLogEntriesByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery);

    void deleteHistoricTaskLogEntriesByProcessDefinitionId(string processDefinitionId);

    void deleteHistoricTaskLogEntriesByScopeDefinitionId(string scopeType, string scopeDefinitionId);

    void deleteHistoricTaskLogEntriesByTaskId(string taskId);

    void deleteHistoricTaskLogEntriesForNonExistingProcessInstances();

    void deleteHistoricTaskLogEntriesForNonExistingCaseInstances();
}
