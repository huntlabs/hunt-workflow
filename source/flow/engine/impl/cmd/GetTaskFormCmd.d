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

module flow.engine.impl.cmd.GetTaskFormCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.form.TaskFormData;
//import flow.engine.impl.form.FormHandlerHelper;
//import flow.engine.impl.form.TaskFormHandler;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.task.api.Task;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetTaskFormCmd : Command!TaskFormData {

    protected string taskId;

    this(string taskId) {
        this.taskId = taskId;
    }

    public TaskFormData execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);
        //if (task is null) {
        //    throw new FlowableObjectNotFoundException("No task found for taskId '" + taskId + "'", Task.class);
        //}
        //
        //if (task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    return compatibilityHandler.getTaskFormData(taskId);
        //}
        //
        //FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        //TaskFormHandler taskFormHandler = formHandlerHelper.getTaskFormHandlder(task);
        //if (taskFormHandler is null) {
        //    throw new FlowableException("No taskFormHandler specified for task '" + taskId + "'");
        //}
        //
        //return taskFormHandler.createTaskForm(task);
    }

}
