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
module flow.task.service.impl.HistoricTaskLogEntryBuilderImpl;

import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.identity.Authentication;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.task.api.TaskInfo;
import flow.task.service.impl.util.CommandContextUtil;
import flow.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryBuilderImpl : BaseHistoricTaskLogEntryBuilderImpl , Command!Void {

    protected CommandExecutor commandExecutor;

    this(CommandExecutor commandExecutor, TaskInfo task) {
        super(task);
        this.commandExecutor = commandExecutor;
    }

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    override
    public void create() {
        this.commandExecutor.execute(this);
    }

    override
    public Void execute(CommandContext commandContext) {
        if (getTaskId() is null || getTaskId().length == 0) {
            throw new FlowableIllegalArgumentException("Empty taskId is not allowed for HistoricTaskLogEntry");
        }
        if (getUserId() is null || getUserId().length == 0) {
          implementationMissing(false);
            //userId(Authentication.getAuthenticatedUserId());
        }
        if (timeStamp is null) {
            timeStamp(CommandContextUtil.getTaskServiceConfiguration().getClock().getCurrentTime());
        }

        CommandContextUtil.getTaskServiceConfiguration(commandContext).getInternalHistoryTaskManager().recordHistoryUserTaskLog(this);
        return null;
    }

}
