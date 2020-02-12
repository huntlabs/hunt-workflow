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



import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.identity.Authentication;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.Execution;
import flow.engine.task.Comment;
import flow.engine.task.Event;
import org.flowable.task.api.Task;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 */
class AddCommentCmd implements Command<Comment> {

    protected string taskId;
    protected string processInstanceId;
    protected string type;
    protected string message;

    public AddCommentCmd(string taskId, string processInstanceId, string message) {
        this.taskId = taskId;
        this.processInstanceId = processInstanceId;
        this.message = message;
    }

    public AddCommentCmd(string taskId, string processInstanceId, string type, string message) {
        this.taskId = taskId;
        this.processInstanceId = processInstanceId;
        this.type = type;
        this.message = message;
    }

    @Override
    public Comment execute(CommandContext commandContext) {

        TaskEntity task = null;
        // Validate task
        if (taskId != null) {
            task = CommandContextUtil.getTaskService().getTask(taskId);

            if (task == null) {
                throw new FlowableObjectNotFoundException("Cannot find task with id " + taskId, Task.class);
            }

            if (task.isSuspended()) {
                throw new FlowableException(getSuspendedTaskException());
            }
        }

        ExecutionEntity execution = null;
        if (processInstanceId != null) {
            execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);

            if (execution == null) {
                throw new FlowableObjectNotFoundException("execution " + processInstanceId + " doesn't exist", Execution.class);
            }

            if (execution.isSuspended()) {
                throw new FlowableException(getSuspendedExceptionMessage());
            }
        }

        string processDefinitionId = null;
        if (execution != null) {
            processDefinitionId = execution.getProcessDefinitionId();
        } else if (task != null) {
            processDefinitionId = task.getProcessDefinitionId();
        }

        if (processDefinitionId != null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processDefinitionId)) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            return compatibilityHandler.addComment(taskId, processInstanceId, type, message);
        }

        string userId = Authentication.getAuthenticatedUserId();
        CommentEntity comment = CommandContextUtil.getCommentEntityManager(commandContext).create();
        comment.setUserId(userId);
        comment.setType((type == null) ? CommentEntity.TYPE_COMMENT : type);
        comment.setTime(CommandContextUtil.getProcessEngineConfiguration(commandContext).getClock().getCurrentTime());
        comment.setTaskId(taskId);
        comment.setProcessInstanceId(processInstanceId);
        comment.setAction(Event.ACTION_ADD_COMMENT);

        string eventMessage = message.replaceAll("\\s+", " ");
        if (eventMessage.length() > 163) {
            eventMessage = eventMessage.substring(0, 160) + "...";
        }
        comment.setMessage(eventMessage);

        comment.setFullMessage(message);

        CommandContextUtil.getCommentEntityManager(commandContext).insert(comment);

        return comment;
    }

    protected string getSuspendedTaskException() {
        return "Cannot add a comment to a suspended task";
    }

    protected string getSuspendedExceptionMessage() {
        return "Cannot add a comment to a suspended execution";
    }
}
