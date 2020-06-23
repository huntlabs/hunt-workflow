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

module flow.engine.impl.cmd.DelegateTaskCmd;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.TaskHelper;
import flow.task.api.DelegationState;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.cmd.NeedsActiveTaskCmd;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DelegateTaskCmd : NeedsActiveTaskCmd!Object {

    protected string userId;

    this(string taskId, string userId) {
        super(taskId);
        this.userId = userId;
    }

    override
    protected Object execute(CommandContext commandContext, TaskEntity task) {
        task.setDelegationState(DelegationState.PENDING);
        if (task.getOwner() is null || task.getOwner().length == 0 ) {
            task.setOwner(task.getAssignee());
        }
        TaskHelper.changeTaskAssignee(task, userId);
        return null;
    }

    override
    protected string getSuspendedTaskException() {
        return "Cannot delegate a suspended task";
    }

}
