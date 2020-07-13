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
module flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.task.api.history.HistoricTaskLogEntry;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.HistoricTaskLogEntryQueryImpl;
import flow.task.service.impl.persistence.entity.data.HistoricTaskLogEntryDataManager;
import flow.task.service.impl.persistence.entity.AbstractTaskServiceEntityManager;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntityManager;
/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryEntityManagerImpl
    : AbstractTaskServiceEntityManager!(HistoricTaskLogEntryEntity, HistoricTaskLogEntryDataManager)
    , HistoricTaskLogEntryEntityManager {

    this(TaskServiceConfiguration taskServiceConfiguration, HistoricTaskLogEntryDataManager taskLogDataManager) {
        super(taskServiceConfiguration, taskLogDataManager);
    }


    public List!HistoricTaskLogEntry findHistoricTaskLogEntriesByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery) {
        return getDataManager().findHistoricTaskLogEntriesByQueryCriteria(taskLogEntryQuery);
    }


    public long findHistoricTaskLogEntriesCountByQueryCriteria(HistoricTaskLogEntryQueryImpl taskLogEntryQuery) {
        return getDataManager().findHistoricTaskLogEntriesCountByQueryCriteria(taskLogEntryQuery);
    }


    public List!HistoricTaskLogEntry findHistoricTaskLogEntriesByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery) {
        return getDataManager().findHistoricTaskLogEntriesByNativeQueryCriteria(nativeHistoricTaskLogEntryQuery);
    }

    public long findHistoricTaskLogEntriesCountByNativeQueryCriteria(Map!(string, Object) nativeHistoricTaskLogEntryQuery) {
        return getDataManager().findHistoricTaskLogEntriesCountByNativeQueryCriteria(nativeHistoricTaskLogEntryQuery);
    }


    public void deleteHistoricTaskLogEntry(long logNr) {
        getDataManager().deleteHistoricTaskLogEntry(logNr);
    }


    public void deleteHistoricTaskLogEntriesForProcessDefinition(string processDefinitionId) {
        getDataManager().deleteHistoricTaskLogEntriesByProcessDefinitionId(processDefinitionId);
    }


    public void deleteHistoricTaskLogEntriesForScopeDefinition(string scopeType, string scopeDefinitionId) {
        getDataManager().deleteHistoricTaskLogEntriesByScopeDefinitionId(scopeType, scopeDefinitionId);
    }


    public void deleteHistoricTaskLogEntriesForTaskId(string taskId) {
        getDataManager().deleteHistoricTaskLogEntriesByTaskId(taskId);
    }


    public void deleteHistoricTaskLogEntriesForNonExistingProcessInstances() {
        getDataManager().deleteHistoricTaskLogEntriesForNonExistingProcessInstances();
    }


    public void deleteHistoricTaskLogEntriesForNonExistingCaseInstances() {
        getDataManager().deleteHistoricTaskLogEntriesForNonExistingCaseInstances();
    }


    public void createHistoricTaskLogEntry(HistoricTaskLogEntryBuilder historicTaskLogEntryBuilder) {
        HistoricTaskLogEntryEntity historicTaskLogEntryEntity = getDataManager().create();
        historicTaskLogEntryEntity.setUserId(historicTaskLogEntryBuilder.getUserId());
        historicTaskLogEntryEntity.setTimeStamp(historicTaskLogEntryBuilder.getTimeStamp());
        historicTaskLogEntryEntity.setTaskId(historicTaskLogEntryBuilder.getTaskId());
        historicTaskLogEntryEntity.setTenantId(historicTaskLogEntryBuilder.getTenantId());
        historicTaskLogEntryEntity.setProcessInstanceId(historicTaskLogEntryBuilder.getProcessInstanceId());
        historicTaskLogEntryEntity.setProcessDefinitionId(historicTaskLogEntryBuilder.getProcessDefinitionId());
        historicTaskLogEntryEntity.setExecutionId(historicTaskLogEntryBuilder.getExecutionId());
        historicTaskLogEntryEntity.setScopeId(historicTaskLogEntryBuilder.getScopeId());
        historicTaskLogEntryEntity.setScopeDefinitionId(historicTaskLogEntryBuilder.getScopeDefinitionId());
        historicTaskLogEntryEntity.setSubScopeId(historicTaskLogEntryBuilder.getSubScopeId());
        historicTaskLogEntryEntity.setScopeType(historicTaskLogEntryBuilder.getScopeType());

        historicTaskLogEntryEntity.setType(historicTaskLogEntryBuilder.getType());
        historicTaskLogEntryEntity.setData(historicTaskLogEntryBuilder.getData());
        getDataManager().insert(historicTaskLogEntryEntity);
    }

}
