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
module flow.engine.impl.cmd.SaveAttachmentCmd;



import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.AttachmentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.task.Attachment;

/**
 * @author Tom Baeyens
 */
class SaveAttachmentCmd : Command!Object {

    protected Attachment attachment;

    this(Attachment attachment) {
        this.attachment = attachment;
    }

    public Object execute(CommandContext commandContext) {
        AttachmentEntity updateAttachment = CommandContextUtil.getAttachmentEntityManager().findById(attachment.getId());

        string processInstanceId = updateAttachment.getProcessInstanceId();
        string processDefinitionId = null;
        if (updateAttachment.getProcessInstanceId() !is null && updateAttachment.getProcessInstanceId().length != 0) {
            ExecutionEntity process = CommandContextUtil.getExecutionEntityManager(commandContext).findById(processInstanceId);
            if (process !is null) {
                processDefinitionId = process.getProcessDefinitionId();
                //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, process.getProcessDefinitionId())) {
                //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                //    compatibilityHandler.saveAttachment(attachment);
                //    return null;
                //}
            }
        }

        updateAttachment.setName(attachment.getName());
        updateAttachment.setDescription(attachment.getDescription());

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                    .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, cast(Object)attachment, processInstanceId, processInstanceId, processDefinitionId));
        }

        return null;
    }
}
