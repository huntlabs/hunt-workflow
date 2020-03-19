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
module flow.task.service.HistoricTaskService;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.interceptor.CommandExecutor;
import flow.task.api.TaskInfo;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.api.history.HistoricTaskLogEntryQuery;
import flow.task.api.history.NativeHistoricTaskLogEntryQuery;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * Service which provides access to {@link HistoricTaskInstanceEntity}.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface HistoricTaskService {

    HistoricTaskInstanceEntity getHistoricTask(string id);

    List!HistoricTaskInstanceEntity findHistoricTasksByParentTaskId(string parentTaskId);

    List!HistoricTaskInstanceEntity findHistoricTasksByProcessInstanceId(string processInstanceId);

    List!HistoricTaskInstance findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    HistoricTaskInstanceEntity createHistoricTask();

    HistoricTaskInstanceEntity createHistoricTask(TaskEntity taskEntity);

    void updateHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireUpdateEvent);

    void insertHistoricTask(HistoricTaskInstanceEntity historicTaskInstanceEntity, bool fireCreateEvent);

    void deleteHistoricTask(HistoricTaskInstanceEntity HistoricTaskInstance);

    HistoricTaskInstanceEntity recordTaskCreated(TaskEntity task);

    HistoricTaskInstanceEntity recordTaskEnd(TaskEntity task, string deleteReason, Date endTime);

    HistoricTaskInstanceEntity recordTaskInfoChange(TaskEntity taskEntity, Date changeTime);

    void deleteHistoricTaskLogEntry(long taskLogNumber);

    void createHistoricTaskLogEntry(HistoricTaskLogEntryBuilder historicTaskLogEntryBuilder);

    /**
     * Log new entry to the task log.
     *
     * @param taskInfo task to which add log entry
     * @param logEntryType log entry type
     * @param data log entry data
     */
    void addHistoricTaskLogEntry(TaskInfo taskInfo, string logEntryType, string data);

    HistoricTaskLogEntryQuery createHistoricTaskLogEntryQuery(CommandExecutor commandExecutor);

    NativeHistoricTaskLogEntryQuery createNativeHistoricTaskLogEntryQuery(CommandExecutor commandExecutor);

    void deleteHistoricTaskLogEntriesForProcessDefinition(string processDefinitionId);

    void deleteHistoricTaskLogEntriesForScopeDefinition(string scopeType, string scopeDefinitionId);

    void deleteHistoricTaskLogEntriesForTaskId(string taskId);

    void deleteHistoricTaskLogEntriesForNonExistingProcessInstances();

    void deleteHistoricTaskLogEntriesForNonExistingCaseInstances();

    void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery);

    void deleteHistoricTaskInstancesForNonExistingProcessInstances();

    void deleteHistoricTaskInstancesForNonExistingCaseInstances();
}
