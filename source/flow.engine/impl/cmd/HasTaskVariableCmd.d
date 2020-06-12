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

module flow.engine.impl.cmd.HasTaskVariableCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.api.Task;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Frederik Heremans
 */
class HasTaskVariableCmd : Command!bool {

    protected string taskId;
    protected string variableName;
    protected bool isLocal;

    this(string taskId, string variableName, bool isLocal) {
        this.taskId = taskId;
        this.variableName = variableName;
        this.isLocal = isLocal;
    }

    public bool execute(CommandContext commandContext) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task is null) {
            throw new FlowableObjectNotFoundException("task " ~ taskId ~ " doesn't exist");
        }
        bool hasVariable = false;

        if (isLocal) {
            hasVariable = task.hasVariableLocal(variableName);
        } else {
            hasVariable = task.hasVariable(variableName);
        }

        return hasVariable;
    }
}
