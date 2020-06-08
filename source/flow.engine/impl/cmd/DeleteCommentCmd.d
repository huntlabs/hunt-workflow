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
import hunt.collection.ArrayList;

import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.impl.persistence.entity.CommentEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.task.Comment;
import flow.task.api.Task;

/**
 * @author Joram Barrez
 */
class DeleteCommentCmd implements Command!Void, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;
    protected string processInstanceId;
    protected string commentId;

    public DeleteCommentCmd(string taskId, string processInstanceId, string commentId) {
        this.taskId = taskId;
        this.processInstanceId = processInstanceId;
        this.commentId = commentId;
    }

    override
    public Void execute(CommandContext commandContext) {
        CommentEntityManager commentManager = CommandContextUtil.getCommentEntityManager(commandContext);

        if (commentId !is null) {
            // Delete for an individual comment
            Comment comment = commentManager.findComment(commentId);
            if (comment is null) {
                throw new FlowableObjectNotFoundException("Comment with id '" + commentId + "' doesn't exists.", Comment.class);
            }

            if (comment.getProcessInstanceId() !is null) {
                ExecutionEntity execution = (ExecutionEntity) CommandContextUtil.getExecutionEntityManager(commandContext).findById(comment.getProcessInstanceId());
                if (execution !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteComment(commentId, taskId, processInstanceId);
                    return null;
                }

            } else if (comment.getTaskId() !is null) {
                Task task = CommandContextUtil.getTaskService().getTask(comment.getTaskId());
                if (task !is null && task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteComment(commentId, taskId, processInstanceId);
                    return null;
                }
            }

            commentManager.delete((CommentEntity) comment);

        } else {
            // Delete all comments on a task of process
            ArrayList!Comment comments = new ArrayList<>();
            if (processInstanceId !is null) {

                ExecutionEntity execution = (ExecutionEntity) CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);
                if (execution !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteComment(commentId, taskId, processInstanceId);
                    return null;
                }

                comments.addAll(commentManager.findCommentsByProcessInstanceId(processInstanceId));
            }
            if (taskId !is null) {

                Task task = CommandContextUtil.getTaskService().getTask(taskId);
                if (task !is null && task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteComment(commentId, taskId, processInstanceId);
                    return null;
                }

                comments.addAll(commentManager.findCommentsByTaskId(taskId));
            }

            for (Comment comment : comments) {
                commentManager.delete((CommentEntity) comment);
            }
        }
        return null;
    }
}
