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



import hunt.time.LocalDateTime;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ActivityInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.api.history.HistoricTaskLogEntryBuilder;
import flow.task.service.history.InternalHistoryTaskManager;
import flow.task.service.impl.persistence.entity.TaskEntity;

class DefaultHistoryTaskManager implements InternalHistoryTaskManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public DefaultHistoryTaskManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }



    @Override
    public void recordTaskInfoChange(TaskEntity taskEntity, Date changeTime) {
        getActivityInstanceEntityManager().recordTaskInfoChange(taskEntity, changeTime);
    }

    @Override
    public void recordTaskCreated(TaskEntity taskEntity) {
        CommandContextUtil.getHistoryManager().recordTaskCreated(taskEntity, null);
    }

    @Override
    public void recordHistoryUserTaskLog(HistoricTaskLogEntryBuilder taskLogEntryBuilder) {
        CommandContextUtil.getHistoryManager().recordHistoricUserTaskLogEntry(taskLogEntryBuilder);
    }

    @Override
    public void deleteHistoryUserTaskLog(long logNumber) {
        CommandContextUtil.getHistoryManager().deleteHistoryUserTaskLog(logNumber);
    }

    protected ActivityInstanceEntityManager getActivityInstanceEntityManager() {
        return processEngineConfiguration.getActivityInstanceEntityManager();
    }
}
