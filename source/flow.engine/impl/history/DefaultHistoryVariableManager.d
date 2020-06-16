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
module flow.engine.impl.histroy.DefaultHistoryVariableManager;


import hunt.time.LocalDateTime;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.variable.service.history.InternalHistoryVariableManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.histroy.HistoryManager;


class DefaultHistoryVariableManager : InternalHistoryVariableManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }


    public void recordVariableCreate(VariableInstanceEntity variable, Date createTime) {
        getHistoryManager().recordVariableCreate(variable, createTime);
        if ((variable.getProcessInstanceId() !is null && variable.getProcessInstanceId().length != 0)|| (variable.getExecutionId() !is null && variable.getExecutionId().length != 0) || (variable.getTaskId() !is null && variable.getTaskId().length != 0)) {
            getHistoryManager().recordHistoricDetailVariableCreate(variable, null, false, null, createTime);
        }
    }


    public void recordVariableUpdate(VariableInstanceEntity variable, Date updateTime) {
        getHistoryManager().recordVariableUpdate(variable, updateTime);
        if ((variable.getProcessInstanceId() !is null && variable.getProcessInstanceId().length != 0)|| (variable.getExecutionId() !is null && variable.getExecutionId().length != 0)|| (variable.getTaskId() !is null && variable.getTaskId().length != 0)) {
            getHistoryManager().recordHistoricDetailVariableCreate(variable, null, false, null, updateTime);
        }
    }


    public void recordVariableRemoved(VariableInstanceEntity variable, Date removeTime) {
        getHistoryManager().recordVariableRemoved(variable);
        if ((variable.getProcessInstanceId() !is null && variable.getProcessInstanceId().length != 0)|| (variable.getExecutionId() !is null && variable.getExecutionId().length != 0)|| (variable.getTaskId() !is null && variable.getTaskId().length != 0)) {
            getHistoryManager().recordHistoricDetailVariableCreate(variable, null, false, null, removeTime);
        }
    }

    protected HistoryManager getHistoryManager() {
        return processEngineConfiguration.getHistoryManager();
    }
}
