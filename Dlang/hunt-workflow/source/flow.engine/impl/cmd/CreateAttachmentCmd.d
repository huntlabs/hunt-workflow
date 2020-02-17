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



import java.io.InputStream;

import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.common.identity.Authentication;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.util.IoUtil;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.AttachmentEntity;
import flow.engine.impl.persistence.entity.ByteArrayEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.ProcessInstance;
import flow.engine.task.Attachment;
import org.flowable.task.api.Task;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
// Not Serializable
class CreateAttachmentCmd implements Command<Attachment> {

    protected string attachmentType;
    protected string taskId;
    protected string processInstanceId;
    protected string attachmentName;
    protected string attachmentDescription;
    protected InputStream content;
    protected string url;

    public CreateAttachmentCmd(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, InputStream content, string url) {
        this.attachmentType = attachmentType;
        this.taskId = taskId;
        this.processInstanceId = processInstanceId;
        this.attachmentName = attachmentName;
        this.attachmentDescription = attachmentDescription;
        this.content = content;
        this.url = url;
    }

    @Override
    public Attachment execute(CommandContext commandContext) {

        if (taskId != null) {
            TaskEntity task = verifyTaskParameters(commandContext);
            if (task.getProcessDefinitionId() != null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                return compatibilityHandler.createAttachment(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, content, url);
            }
        }

        if (processInstanceId != null) {
            ExecutionEntity execution = verifyExecutionParameters(commandContext);
            if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                return compatibilityHandler.createAttachment(attachmentType, taskId, processInstanceId, attachmentName, attachmentDescription, content, url);
            }
        }

        AttachmentEntity attachment = CommandContextUtil.getAttachmentEntityManager().create();
        attachment.setName(attachmentName);
        attachment.setProcessInstanceId(processInstanceId);
        attachment.setTaskId(taskId);
        attachment.setDescription(attachmentDescription);
        attachment.setType(attachmentType);
        attachment.setUrl(url);
        attachment.setUserId(Authentication.getAuthenticatedUserId());
        attachment.setTime(CommandContextUtil.getProcessEngineConfiguration(commandContext).getClock().getCurrentTime());

        CommandContextUtil.getAttachmentEntityManager().insert(attachment, false);

        if (content != null) {
            byte[] bytes = IoUtil.readInputStream(content, attachmentName);
            ByteArrayEntity byteArray = CommandContextUtil.getByteArrayEntityManager().create();
            byteArray.setBytes(bytes);
            CommandContextUtil.getByteArrayEntityManager().insert(byteArray);
            attachment.setContentId(byteArray.getId());
            attachment.setContent(byteArray);
        }

        ExecutionEntity processInstance = null;
        if (processInstanceId != null) {
            processInstance = CommandContextUtil.getExecutionEntityManager().findById(processInstanceId);
        }
        
        TaskEntity task = null;
        if (taskId != null) {
            task = CommandContextUtil.getTaskService().getTask(taskId);
        }
        
        CommandContextUtil.getHistoryManager(commandContext).createAttachmentComment(task, processInstance, attachmentName, true);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher != null && eventDispatcher.isEnabled()) {
            // Forced to fetch the process-instance to associate the right
            // process definition
            string processDefinitionId = null;
            if (attachment.getProcessInstanceId() != null) {
                ExecutionEntity process = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);
                if (process != null) {
                    processDefinitionId = process.getProcessDefinitionId();
                }
            }

            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, attachment, processInstanceId, processInstanceId, processDefinitionId));
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, attachment, processInstanceId, processInstanceId, processDefinitionId));
        }

        return attachment;
    }

    protected TaskEntity verifyTaskParameters(CommandContext commandContext) {
        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task == null) {
            throw new FlowableObjectNotFoundException("Cannot find task with id " + taskId, Task.class);
        }

        if (task.isSuspended()) {
            throw new FlowableException("It is not allowed to add an attachment to a suspended task");
        }

        return task;
    }

    protected ExecutionEntity verifyExecutionParameters(CommandContext commandContext) {
        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);

        if (execution == null) {
            throw new FlowableObjectNotFoundException("Process instance " + processInstanceId + " doesn't exist", ProcessInstance.class);
        }

        if (execution.isSuspended()) {
            throw new FlowableException("It is not allowed to add an attachment to a suspended process instance");
        }

        return execution;
    }

}
