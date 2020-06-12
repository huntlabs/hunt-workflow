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

module flow.engine.impl.cmd.SubmitTaskFormCmd;

import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.form.FormHandlerHelper;
import flow.engine.impl.form.TaskFormHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.TaskHelper;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.cmd.NeedsActiveTaskCmd;
import hunt.Object;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class SubmitTaskFormCmd : NeedsActiveTaskCmd!Void {

    protected string taskId;
    protected Map!(string, string) properties;
    protected bool completeTask;

    this(string taskId, Map!(string, string) properties, bool completeTask) {
        super(taskId);
        this.taskId = taskId;
        this.properties = properties;
        this.completeTask = completeTask;
    }

    override
    protected Void execute(CommandContext commandContext, TaskEntity task) {

        // Backwards compatibility
        //if (task.getProcessDefinitionId() !is null) {
        //    if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //        Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //        compatibilityHandler.submitTaskFormData(taskId, properties, completeTask);
        //        return null;
        //    }
        //}

        ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager().findById(task.getExecutionId());
        CommandContextUtil.getHistoryManager(commandContext)
            .recordFormPropertiesSubmitted(executionEntity, properties, taskId, commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());

        FormHandlerHelper formHandlerHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getFormHandlerHelper();
        TaskFormHandler taskFormHandler = formHandlerHelper.getTaskFormHandlder(task);

        if (taskFormHandler !is null) {
            taskFormHandler.submitFormProperties(properties, executionEntity);

            if (completeTask) {
                TaskHelper.completeTask(task, null, null, false, commandContext);
            }
        }

        return null;
    }

    override
    protected string getSuspendedTaskException() {
        return "Cannot submit a form to a suspended task";
    }

}
