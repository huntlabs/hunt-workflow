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
module flow.engine.impl.form.JuelFormEngine;

//import flow.common.scripting.ScriptingEngines;
import flow.common.api.FlowableObjectNotFoundException;
import flow.engine.form.FormData;
import flow.engine.form.StartFormData;
import flow.engine.form.TaskFormData;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.form.FormEngine;
import hunt.Exceptions;
import hunt.logging;
/**
 * @author Tom Baeyens
 */
class JuelFormEngine : FormEngine {

    public string getName() {
        return "juel";
    }


    public Object renderStartForm(StartFormData startForm) {
        implementationMissing(false);
        return null;
        //if (startForm.getFormKey() is null) {
        //    return null;
        //}
        //string formTemplateString = getFormTemplateString(startForm, startForm.getFormKey());
        //ScriptingEngines scriptingEngines = CommandContextUtil.getProcessEngineConfiguration().getScriptingEngines();
        //return scriptingEngines.evaluate(formTemplateString, ScriptingEngines.DEFAULT_SCRIPTING_LANGUAGE, null);
    }


    public Object renderTaskForm(TaskFormData taskForm) {
        implementationMissing(false);
        return null;
        //if (taskForm.getFormKey() is null) {
        //    return null;
        //}
        //string formTemplateString = getFormTemplateString(taskForm, taskForm.getFormKey());
        //ScriptingEngines scriptingEngines = CommandContextUtil.getProcessEngineConfiguration().getScriptingEngines();
        //TaskEntity task = (TaskEntity) taskForm.getTask();
        //
        //ExecutionEntity executionEntity = null;
        //if (task.getExecutionId() !is null) {
        //    executionEntity = CommandContextUtil.getExecutionEntityManager().findById(task.getExecutionId());
        //}
        //
        //return scriptingEngines.evaluate(formTemplateString, ScriptingEngines.DEFAULT_SCRIPTING_LANGUAGE, executionEntity);
    }

    protected string getFormTemplateString(FormData formInstance, string formKey) {
        string deploymentId = formInstance.getDeploymentId();

        ResourceEntity resourceStream = CommandContextUtil.getResourceEntityManager().findResourceByDeploymentIdAndResourceName(deploymentId, formKey);

        if (resourceStream is null) {
            logError("getFormTemplateString error");
          //  throw new FlowableObjectNotFoundException("Form with formKey '" + formKey + "' does not exist", string.class);
        }

        return cast(string)(resourceStream.getBytes());
    }
}
