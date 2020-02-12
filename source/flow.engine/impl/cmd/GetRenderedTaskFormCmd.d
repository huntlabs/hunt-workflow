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



import java.io.Serializable;

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
import org.flowable.task.api.Task;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetRenderedTaskFormCmd implements Command<Object>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;
    protected string formEngineName;

    public GetRenderedTaskFormCmd(string taskId, string formEngineName) {
        this.taskId = taskId;
        this.formEngineName = formEngineName;
    }

    @Override
    public Object execute(CommandContext commandContext) {

        if (taskId == null) {
            throw new FlowableIllegalArgumentException("Task id should not be null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);
        if (task == null) {
            throw new FlowableObjectNotFoundException("Task '" + taskId + "' not found", Task.class);
        }

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        TaskFormHandler taskFormHandler = formHandlerHelper.getTaskFormHandlder(task);
        if (taskFormHandler != null) {

            FormEngine formEngine = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormEngines().get(formEngineName);

            if (formEngine == null) {
                throw new FlowableException("No formEngine '" + formEngineName + "' defined process engine configuration");
            }

            TaskFormData taskForm = taskFormHandler.createTaskForm(task);

            return formEngine.renderTaskForm(taskForm);
        }

        return null;
    }
}
