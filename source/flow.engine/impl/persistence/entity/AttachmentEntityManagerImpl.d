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

module flow.engine.impl.persistence.entity.AttachmentEntityManagerImpl;

import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.AttachmentDataManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Attachment;
import flow.task.api.Task;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.AttachmentEntityManager;
import flow.engine.impl.persistence.entity.AttachmentEntity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class AttachmentEntityManagerImpl
    : AbstractProcessEngineEntityManager!(AttachmentEntity, AttachmentDataManager)
    , AttachmentEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, AttachmentDataManager attachmentDataManager) {
        super(processEngineConfiguration, attachmentDataManager);
    }

    public List!AttachmentEntity findAttachmentsByProcessInstanceId(string processInstanceId) {
        checkHistoryEnabled();
        return dataManager.findAttachmentsByProcessInstanceId(processInstanceId);
    }

    public List!AttachmentEntity findAttachmentsByTaskId(string taskId) {
        checkHistoryEnabled();
        return dataManager.findAttachmentsByTaskId(taskId);
    }

    public void deleteAttachmentsByTaskId(string taskId) {
        checkHistoryEnabled();
        List!AttachmentEntity attachments = findAttachmentsByTaskId(taskId);
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        bool dispatchEvents = eventDispatcher !is null && eventDispatcher.isEnabled();

        string processInstanceId = null;
        string processDefinitionId = null;
        string executionId = null;

        if (dispatchEvents && attachments !is null && !attachments.isEmpty()) {
            // Forced to fetch the task to get hold of the process definition
            // for event-dispatching, if available
            Task task = CommandContextUtil.getTaskService().getTask(taskId);
            if (task !is null) {
                processDefinitionId = task.getProcessDefinitionId();
                processInstanceId = task.getProcessInstanceId();
                executionId = task.getExecutionId();
            }
        }

        foreach (Attachment attachment ; attachments) {
            string contentId = attachment.getContentId();
            if (contentId !is null) {
                getByteArrayEntityManager().deleteByteArrayById(contentId);
            }

            dataManager.dele(cast(AttachmentEntity) attachment);

            if (dispatchEvents) {
                eventDispatcher.dispatchEvent(
                        FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, attachment, executionId, processInstanceId, processDefinitionId));
            }
        }
    }

    protected void checkHistoryEnabled() {
        if (!getHistoryManager().isHistoryEnabled()) {
            throw new FlowableException("In order to use attachments, history should be enabled");
        }
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

    protected ByteArrayEntityManager getByteArrayEntityManager() {
        return engineConfiguration.getByteArrayEntityManager();
    }

}
