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

module flow.task.api.history.HistoricTaskLogEntryBuilder;
import hunt.time.LocalDateTime;

alias Date = LocalDateTime;

/**
 * Interface to create and add task log entry
 *
 * @author martin.grofcik
 */
interface HistoricTaskLogEntryBuilder {

    HistoricTaskLogEntryBuilder taskId(string taskId);

    HistoricTaskLogEntryBuilder type(string type);

    HistoricTaskLogEntryBuilder timeStamp(Date timeStamp);

    HistoricTaskLogEntryBuilder userId(string userId);

    HistoricTaskLogEntryBuilder processInstanceId(string processInstanceId);

    HistoricTaskLogEntryBuilder processDefinitionId(string processDefinitionId);

    HistoricTaskLogEntryBuilder executionId(string executionId);

    HistoricTaskLogEntryBuilder scopeId(string scopeId);

    HistoricTaskLogEntryBuilder scopeDefinitionId(string scopeDefinitionId);

    HistoricTaskLogEntryBuilder subScopeId(string subScopeId);

    HistoricTaskLogEntryBuilder scopeType(string scopeType);

    HistoricTaskLogEntryBuilder tenantId(string tenantId);

    HistoricTaskLogEntryBuilder data(string data);

    string getType();

    string getTaskId();

    Date getTimeStamp();

    string getUserId();

    string getData();

    string getExecutionId();

    string getProcessInstanceId();

    string getProcessDefinitionId();

    string getScopeId();

    string getScopeDefinitionId();

    string getSubScopeId();

    string getScopeType();

    string getTenantId();

    void create();

}
