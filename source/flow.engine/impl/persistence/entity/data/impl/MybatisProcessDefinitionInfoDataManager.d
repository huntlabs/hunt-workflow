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


import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ProcessDefinitionInfoDataManager;

/**
 * @author Tijs Rademakers
 */
class MybatisProcessDefinitionInfoDataManager extends AbstractProcessDataManager<ProcessDefinitionInfoEntity> implements ProcessDefinitionInfoDataManager {

    public MybatisProcessDefinitionInfoDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends ProcessDefinitionInfoEntity> getManagedEntityClass() {
        return ProcessDefinitionInfoEntityImpl.class;
    }

    @Override
    public ProcessDefinitionInfoEntity create() {
        return new ProcessDefinitionInfoEntityImpl();
    }

    @Override
    public ProcessDefinitionInfoEntity findProcessDefinitionInfoByProcessDefinitionId(string processDefinitionId) {
        return (ProcessDefinitionInfoEntity) getDbSqlSession().selectOne("selectProcessDefinitionInfoByProcessDefinitionId", processDefinitionId);
    }
}
