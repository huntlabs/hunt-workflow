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

module flow.engine.impl.cmd.GetRenderedTaskFormCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.form.TaskFormData;
import flow.engine.impl.form.FormEngine;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.form.TaskFormHandler;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.api.Task;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetRenderedTaskFormCmd : Command!Object {

    protected string taskId;
    protected string formEngineName;

    this(string taskId, string formEngineName) {
        this.taskId = taskId;
        this.formEngineName = formEngineName;
    }

    public Object execute(CommandContext commandContext) {

        if (taskId is null) {
            throw new FlowableIllegalArgumentException("Task id should not be null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);
        if (task is null) {
            throw new FlowableObjectNotFoundException("Task '" ~ taskId ~ "' not found");
        }

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        TaskFormHandler taskFormHandler = formHandlerHelper.getTaskFormHandlder(task);
        if (taskFormHandler !is null) {

            FormEngine formEngine = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormEngines().get(formEngineName);

            if (formEngine is null) {
                throw new FlowableException("No formEngine '" ~ formEngineName ~ "' defined process engine configuration");
            }

            TaskFormData taskForm = taskFormHandler.createTaskForm(task);

            return formEngine.renderTaskForm(taskForm);
        }

        return null;
    }
}
