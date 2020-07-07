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

module flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManagerImpl;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionInfoDataManager;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.impl.persistence.entity.ByteArrayRef;
/**
 * @author Tijs Rademakers
 */
class ProcessDefinitionInfoEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ProcessDefinitionInfoEntity, ProcessDefinitionInfoDataManager)
    , ProcessDefinitionInfoEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration,
            ProcessDefinitionInfoDataManager processDefinitionInfoDataManager) {

        super(processEngineConfiguration, processDefinitionInfoDataManager);
    }

    public void insertProcessDefinitionInfo(ProcessDefinitionInfoEntity processDefinitionInfo) {
        insert(processDefinitionInfo);
    }

    override
    ProcessDefinitionInfoEntity findById(string id)
    {
        return super.findById(id);
    }


    public void updateProcessDefinitionInfo(ProcessDefinitionInfoEntity updatedProcessDefinitionInfo) {
        update(updatedProcessDefinitionInfo, true);
    }


    public void deleteProcessDefinitionInfo(string processDefinitionId) {
        ProcessDefinitionInfoEntity processDefinitionInfo = findProcessDefinitionInfoByProcessDefinitionId(processDefinitionId);
        if (processDefinitionInfo !is null) {
            dele(processDefinitionInfo);
            deleteInfoJson(processDefinitionInfo);
        }
    }


    public void updateInfoJson(string id, byte[] json) {
        ProcessDefinitionInfoEntity processDefinitionInfo = findById(id);
        if (processDefinitionInfo !is null) {
            ByteArrayRef rf = new ByteArrayRef(processDefinitionInfo.getInfoJsonId());
            rf.setValue("json", json);

            if (processDefinitionInfo.getInfoJsonId().length == 0) {
                processDefinitionInfo.setInfoJsonId(rf.getId());
            }

            updateProcessDefinitionInfo(processDefinitionInfo);
        }
    }


    public void deleteInfoJson(ProcessDefinitionInfoEntity processDefinitionInfo) {
        if (processDefinitionInfo.getInfoJsonId().length != 0) {
            ByteArrayRef rf = new ByteArrayRef(processDefinitionInfo.getInfoJsonId());
            rf.dele();
        }
    }


    public ProcessDefinitionInfoEntity findProcessDefinitionInfoByProcessDefinitionId(string processDefinitionId) {
        return dataManager.findProcessDefinitionInfoByProcessDefinitionId(processDefinitionId);
    }


    public byte[] findInfoJsonById(string infoJsonId) {
        ByteArrayRef rf = new ByteArrayRef(infoJsonId);
        return rf.getBytes();
    }
}
