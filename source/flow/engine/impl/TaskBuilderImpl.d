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
module flow.engine.impl.TaskBuilderImpl;

import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.cmd.CreateTaskCmd;
import flow.task.api.Task;
import flow.task.api.TaskBuilder;
import flow.task.service.impl.BaseTaskBuilderImpl;

/**
 * {@link TaskBuilder} implementation
 */
class TaskBuilderImpl : BaseTaskBuilderImpl {
    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    override
    public Task create() {
        return cast(Task)(commandExecutor.execute(new CreateTaskCmd(this)));
    }

}
