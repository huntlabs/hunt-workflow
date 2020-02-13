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


import java.io.Serializable;
import java.util.Collection;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.TaskHelper;

/**
 * @author Joram Barrez
 */
class DeleteTaskCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;
    protected Collection<string> taskIds;
    protected bool cascade;
    protected string deleteReason;

    public DeleteTaskCmd(string taskId, string deleteReason, bool cascade) {
        this.taskId = taskId;
        this.cascade = cascade;
        this.deleteReason = deleteReason;
    }

    public DeleteTaskCmd(Collection<string> taskIds, string deleteReason, bool cascade) {
        this.taskIds = taskIds;
        this.cascade = cascade;
        this.deleteReason = deleteReason;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        if (taskId != null) {
            deleteTask(commandContext, taskId);
        } else if (taskIds != null) {
            for (string taskId : taskIds) {
                deleteTask(commandContext, taskId);
            }
        } else {
            throw new FlowableIllegalArgumentException("taskId and taskIds are null");
        }

        return null;
    }

    protected void deleteTask(CommandContext commandContext, string taskId) {
        TaskHelper.deleteTask(taskId, deleteReason, cascade);
    }
}
