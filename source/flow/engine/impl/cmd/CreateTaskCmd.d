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
module flow.engine.impl.cmd.CreateTaskCmd;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.CountingEntityUtil;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.util.CountingTaskUtil;
import hunt.Exceptions;
/**
 * Creates new task by {@link flow.task.api.TaskBuilder}
 *
 * @author martin.grofcik
 */
class CreateTaskCmd : Command!Task {
    protected TaskBuilder taskBuilder;

    this(TaskBuilder taskBuilder) {
        this.taskBuilder = taskBuilder;
    }

    public Task execute(CommandContext commandContext) {
        Task task = CommandContextUtil.getTaskService().createTask(this.taskBuilder);
        implementationMissing(false);
        //if (CountingTaskUtil.isTaskRelatedEntityCountEnabledGlobally()) {
        //    if (task.getParentTaskId().length != 0) {
        //        TaskEntity parentTaskEntity = CommandContextUtil.getTaskService().getTask(task.getParentTaskId());
        //        if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(parentTaskEntity)) {
        //            CountingTaskEntity countingParentTaskEntity = (CountingTaskEntity) parentTaskEntity;
        //            countingParentTaskEntity.setSubTaskCount(countingParentTaskEntity.getSubTaskCount() + 1);
        //        }
        //    }
        //}

        return task;
    }
}
