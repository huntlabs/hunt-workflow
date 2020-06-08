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

module flow.engine.impl.FormServiceImpl;

import hunt.collection.Map;

import flow.common.service.CommonEngineServiceImpl;
import flow.engine.FormService;
import flow.engine.form.StartFormData;
import flow.engine.form.TaskFormData;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.GetFormKeyCmd;
import flow.engine.impl.cmd.GetRenderedStartFormCmd;
import flow.engine.impl.cmd.GetRenderedTaskFormCmd;
import flow.engine.impl.cmd.GetStartFormCmd;
import flow.engine.impl.cmd.GetTaskFormCmd;
import flow.engine.impl.cmd.SubmitStartFormCmd;
import flow.engine.impl.cmd.SubmitTaskFormCmd;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Tom Baeyens
 * @author Falko Menge (camunda)
 */
class FormServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl implements FormService {

    override
    public Object getRenderedStartForm(string processDefinitionId) {
        return commandExecutor.execute(new GetRenderedStartFormCmd(processDefinitionId, null));
    }

    override
    public Object getRenderedStartForm(string processDefinitionId, string engineName) {
        return commandExecutor.execute(new GetRenderedStartFormCmd(processDefinitionId, engineName));
    }

    override
    public Object getRenderedTaskForm(string taskId) {
        return commandExecutor.execute(new GetRenderedTaskFormCmd(taskId, null));
    }

    override
    public Object getRenderedTaskForm(string taskId, string engineName) {
        return commandExecutor.execute(new GetRenderedTaskFormCmd(taskId, engineName));
    }

    override
    public StartFormData getStartFormData(string processDefinitionId) {
        return commandExecutor.execute(new GetStartFormCmd(processDefinitionId));
    }

    override
    public TaskFormData getTaskFormData(string taskId) {
        return commandExecutor.execute(new GetTaskFormCmd(taskId));
    }

    override
    public ProcessInstance submitStartFormData(string processDefinitionId, Map!(string, string) properties) {
        return commandExecutor.execute(new SubmitStartFormCmd(processDefinitionId, null, properties));
    }

    override
    public ProcessInstance submitStartFormData(string processDefinitionId, string businessKey, Map!(string, string) properties) {
        return commandExecutor.execute(new SubmitStartFormCmd(processDefinitionId, businessKey, properties));
    }

    override
    public void submitTaskFormData(string taskId, Map!(string, string) properties) {
        commandExecutor.execute(new SubmitTaskFormCmd(taskId, properties, true));
    }

    override
    public string getStartFormKey(string processDefinitionId) {
        return commandExecutor.execute(new GetFormKeyCmd(processDefinitionId));
    }

    override
    public string getTaskFormKey(string processDefinitionId, string taskDefinitionKey) {
        return commandExecutor.execute(new GetFormKeyCmd(processDefinitionId, taskDefinitionKey));
    }

    override
    public void saveFormData(string taskId, Map!(string, string) properties) {
        commandExecutor.execute(new SubmitTaskFormCmd(taskId, properties, false));
    }
}
