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


import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.task.service.impl.util.CountingTaskUtil;

/**
 * Creates new task by {@link flow.task.api.TaskBuilder}
 *
 * @author martin.grofcik
 */
class CreateTaskCmd implements Command<Task> {
    protected TaskBuilder taskBuilder;

    public CreateTaskCmd(TaskBuilder taskBuilder) {
        this.taskBuilder = taskBuilder;
    }

    @Override
    public Task execute(CommandContext commandContext) {
        Task task = CommandContextUtil.getTaskService().createTask(this.taskBuilder);
        if (CountingTaskUtil.isTaskRelatedEntityCountEnabledGlobally()) {
            if (StringUtils.isNotEmpty(task.getParentTaskId())) {
                TaskEntity parentTaskEntity = CommandContextUtil.getTaskService().getTask(task.getParentTaskId());
                if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(parentTaskEntity)) {
                    CountingTaskEntity countingParentTaskEntity = (CountingTaskEntity) parentTaskEntity;
                    countingParentTaskEntity.setSubTaskCount(countingParentTaskEntity.getSubTaskCount() + 1);
                }
            }
        }

        return task;
    }
}
