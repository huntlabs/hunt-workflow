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
module flow.task.api.history.HistoricTaskLogEntryQuery;

import hunt.time.LocalDateTime;

alias Date = LocalDateTime;

import flow.common.api.query.Query;
import flow.task.api.history.HistoricTaskLogEntry;

/**
 * Allows programmatic querying of {@link HistoricTaskLogEntry}s;
 *
 * @author martin.grofcik
 */
interface HistoricTaskLogEntryQuery : Query!(HistoricTaskLogEntryQuery, HistoricTaskLogEntry) {

    HistoricTaskLogEntryQuery taskId(string taskId);

    HistoricTaskLogEntryQuery type(string type);

    HistoricTaskLogEntryQuery userId(string userId);

    HistoricTaskLogEntryQuery processInstanceId(string processInstanceId);

    HistoricTaskLogEntryQuery processDefinitionId(string processDefinitionId);

    HistoricTaskLogEntryQuery scopeId(string scopeId);

    HistoricTaskLogEntryQuery scopeDefinitionId(string scopeDefinitionId);

    HistoricTaskLogEntryQuery caseInstanceId(string caseInstanceId);

    HistoricTaskLogEntryQuery caseDefinitionId(string caseDefinitionId);

    HistoricTaskLogEntryQuery subScopeId(string subScopeId);

    HistoricTaskLogEntryQuery scopeType(string scopeType);

    HistoricTaskLogEntryQuery from(Date fromDate);

    HistoricTaskLogEntryQuery to(Date toDate);

    HistoricTaskLogEntryQuery tenantId(string tenantId);

    HistoricTaskLogEntryQuery fromLogNumber(long fromLogNumber);

    HistoricTaskLogEntryQuery toLogNumber(long toLogNumber);

    HistoricTaskLogEntryQuery orderByLogNumber();

    HistoricTaskLogEntryQuery orderByTimeStamp();
}
