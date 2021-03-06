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
module flow.engine.impl.cmd.NeedsActiveTaskCmd;


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.task.api.Task;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * An abstract superclass for {@link Command} implementations that want to verify the provided task is always active (ie. not suspended).
 *
 * @author Joram Barrez
 */
class NeedsActiveTaskCmd(T) : Command!T {

    protected string taskId;

    this(string taskId) {
        this.taskId = taskId;
    }

    public T execute(CommandContext commandContext) {

        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task is null) {
            throw new FlowableObjectNotFoundException("Cannot find task with id " ~ taskId, typeid(Task));
        }

        if (task.isSuspended()) {
            throw new FlowableException(getSuspendedTaskException());
        }

        return execute(commandContext, task);
    }

    /**
     * Subclasses must implement in this method their normal command logic. The provided task is ensured to be active.
     */
    protected abstract T execute(CommandContext commandContext, TaskEntity task);

    /**
     * Subclasses can override this method to provide a customized exception message that will be thrown when the task is suspended.
     */
    protected string getSuspendedTaskException() {
        return "Cannot execute operation: task is suspended";
    }

}
