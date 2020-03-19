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

module flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManagerImpl;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.task.api.history.HistoricTaskInstance;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.HistoricTaskInstanceQueryImpl;
import flow.task.service.impl.persistence.entity.data.HistoricTaskInstanceDataManager;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityManager;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricTaskInstanceEntityManagerImpl
    : AbstractTaskServiceEntityManager!(HistoricTaskInstanceEntity, HistoricTaskInstanceDataManager)
    , HistoricTaskInstanceEntityManager {

    this(TaskServiceConfiguration taskServiceConfiguration, HistoricTaskInstanceDataManager historicTaskInstanceDataManager) {
        super(taskServiceConfiguration, historicTaskInstanceDataManager);
    }


    public HistoricTaskInstanceEntity create(TaskEntity task) {
        return dataManager.create(task);
    }


    public List!HistoricTaskInstanceEntity findHistoricTasksByParentTaskId(string parentTaskId) {
        return dataManager.findHistoricTasksByParentTaskId(parentTaskId);
    }


    public List!HistoricTaskInstanceEntity findHistoricTasksByProcessInstanceId(string processInstanceId) {
        return dataManager.findHistoricTasksByProcessInstanceId(processInstanceId);
    }


    public long findHistoricTaskInstanceCountByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        if (serviceConfiguration.isHistoryEnabled()) {
            return dataManager.findHistoricTaskInstanceCountByQueryCriteria(historicTaskInstanceQuery);
        }
        return 0;
    }



    public List!HistoricTaskInstance findHistoricTaskInstancesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        if (serviceConfiguration.isHistoryEnabled()) {
            return dataManager.findHistoricTaskInstancesByQueryCriteria(historicTaskInstanceQuery);
        }
        return Collections.emptyList!HistoricTaskInstance;
    }



    public List!HistoricTaskInstance findHistoricTaskInstancesAndRelatedEntitiesByQueryCriteria(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        if (serviceConfiguration.isHistoryEnabled()) {
            return dataManager.findHistoricTaskInstancesAndRelatedEntitiesByQueryCriteria(historicTaskInstanceQuery);
        }
        return Collections.emptyList!HistoricTaskInstance;
    }


    public List!HistoricTaskInstance findHistoricTaskInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricTaskInstancesByNativeQuery(parameterMap);
    }


    public long findHistoricTaskInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findHistoricTaskInstanceCountByNativeQuery(parameterMap);
    }


    public void deleteHistoricTaskInstances(HistoricTaskInstanceQueryImpl historicTaskInstanceQuery) {
        dataManager.deleteHistoricTaskInstances(historicTaskInstanceQuery);
    }


    public void deleteHistoricTaskInstancesForNonExistingProcessInstances() {
        dataManager.deleteHistoricTaskInstancesForNonExistingProcessInstances();
    }


    public void deleteHistoricTaskInstancesForNonExistingCaseInstances() {
        dataManager.deleteHistoricTaskInstancesForNonExistingCaseInstances();
    }

    public HistoricTaskInstanceDataManager getHistoricTaskInstanceDataManager() {
        return dataManager;
    }

    public void setHistoricTaskInstanceDataManager(HistoricTaskInstanceDataManager historicTaskInstanceDataManager) {
        this.dataManager = historicTaskInstanceDataManager;
    }

}
