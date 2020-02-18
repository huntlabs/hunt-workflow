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


import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clock;
import flow.engine.FlowableTaskAlreadyClaimedException;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.TaskHelper;
import org.flowable.identitylink.api.IdentityLinkType;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class ClaimTaskCmd extends NeedsActiveTaskCmd<Void> {

    private static final long serialVersionUID = 1L;

    protected string userId;

    public ClaimTaskCmd(string taskId, string userId) {
        super(taskId);
        this.userId = userId;
    }

    @Override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.claimTask(taskId, userId);
            return null;
        }

        if (userId !is null) {
            Clock clock = CommandContextUtil.getProcessEngineConfiguration(commandContext).getClock();
            task.setClaimTime(clock.getCurrentTime());

            if (task.getAssignee() !is null) {
                if (!task.getAssignee().equals(userId)) {
                    // When the task is already claimed by another user, throw
                    // exception. Otherwise, ignore this, post-conditions of method already met.
                    throw new FlowableTaskAlreadyClaimedException(task.getId(), task.getAssignee());
                }
                CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordTaskInfoChange(task, clock.getCurrentTime());
                
            } else {
                TaskHelper.changeTaskAssignee(task, userId);
            }
            
            CommandContextUtil.getHistoryManager().createUserIdentityLinkComment(task, userId, IdentityLinkType.ASSIGNEE, true);
            
        } else {
            if (task.getAssignee() !is null) {
                // Task claim time should be null
                task.setClaimTime(null);
                
                string oldAssigneeId = task.getAssignee();
    
                // Task should be assigned to no one
                TaskHelper.changeTaskAssignee(task, null);
                
                CommandContextUtil.getHistoryManager().createUserIdentityLinkComment(task, oldAssigneeId, IdentityLinkType.ASSIGNEE, true, true);
            }
        }

        return null;
    }

    @Override
    protected string getSuspendedTaskException() {
        return "Cannot claim a suspended task";
    }

}
