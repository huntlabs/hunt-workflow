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
module flow.engine.impl.form.DefaultTaskFormHandler;

import flow.common.api.deleg.Expression;
import flow.engine.form.TaskFormData;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.form.DefaultFormHandler;
import flow.engine.impl.form.TaskFormHandler;
import flow.engine.impl.form.TaskFormDataImpl;
import hunt.String;
/**
 * @author Tom Baeyens
 */
class DefaultTaskFormHandler : DefaultFormHandler , TaskFormHandler {

    public TaskFormData createTaskForm(TaskEntity task) {
        TaskFormDataImpl taskFormData = new TaskFormDataImpl();

        ExecutionEntity executionEntity = null;
        if (task.getExecutionId() !is null && task.getExecutionId().length != 0) {
            executionEntity = CommandContextUtil.getExecutionEntityManager().findById(task.getExecutionId());
        }

        if (formKey !is null) {
            Object formValue = formKey.getValue(executionEntity);
            if (formValue !is null) {
                taskFormData.setFormKey((cast(String)formValue).value);
            }
        }
        taskFormData.setDeploymentId(deploymentId);
        taskFormData.setTask(task);
        initializeFormProperties(taskFormData, executionEntity);
        return taskFormData;
    }

     override
     Expression getFormKey()
     {
        return super.getFormKey;
     }
}
