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

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.AttachmentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeleteAttachmentCmd implements Command<Object>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string attachmentId;

    public DeleteAttachmentCmd(string attachmentId) {
        this.attachmentId = attachmentId;
    }

    @Override
    public Object execute(CommandContext commandContext) {
        AttachmentEntity attachment = CommandContextUtil.getAttachmentEntityManager().findById(attachmentId);

        string processInstanceId = attachment.getProcessInstanceId();
        string processDefinitionId = null;
        ExecutionEntity processInstance = null;
        if (attachment.getProcessInstanceId() !is null) {
            processInstance = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);
            if (processInstance !is null) {
                processDefinitionId = processInstance.getProcessDefinitionId();
                if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, processInstance.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.deleteAttachment(attachmentId);
                    return null;
                }
            }
        }

        CommandContextUtil.getAttachmentEntityManager().delete(attachment, false);

        if (attachment.getContentId() !is null) {
            CommandContextUtil.getByteArrayEntityManager().deleteByteArrayById(attachment.getContentId());
        }

        TaskEntity task = null;
        if (attachment.getTaskId() !is null) {
            task = CommandContextUtil.getTaskService().getTask(attachment.getTaskId());
        }

        if (attachment.getTaskId() !is null) {
            CommandContextUtil.getHistoryManager(commandContext).createAttachmentComment(task, processInstance, attachment.getName(), false);
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, attachment, processInstanceId, processInstanceId, processDefinitionId));
        }
        return null;
    }

}
