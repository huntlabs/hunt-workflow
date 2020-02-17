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



import java.util.List;

import flow.common.api.FlowableException;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.AttachmentDataManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Attachment;
import org.flowable.task.api.Task;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class AttachmentEntityManagerImpl
    extends AbstractProcessEngineEntityManager<AttachmentEntity, AttachmentDataManager>
    implements AttachmentEntityManager {

    public AttachmentEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, AttachmentDataManager attachmentDataManager) {
        super(processEngineConfiguration, attachmentDataManager);
    }

    @Override
    public List<AttachmentEntity> findAttachmentsByProcessInstanceId(string processInstanceId) {
        checkHistoryEnabled();
        return dataManager.findAttachmentsByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<AttachmentEntity> findAttachmentsByTaskId(string taskId) {
        checkHistoryEnabled();
        return dataManager.findAttachmentsByTaskId(taskId);
    }

    @Override
    public void deleteAttachmentsByTaskId(string taskId) {
        checkHistoryEnabled();
        List<AttachmentEntity> attachments = findAttachmentsByTaskId(taskId);
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        bool dispatchEvents = eventDispatcher != null && eventDispatcher.isEnabled();

        string processInstanceId = null;
        string processDefinitionId = null;
        string executionId = null;

        if (dispatchEvents && attachments != null && !attachments.isEmpty()) {
            // Forced to fetch the task to get hold of the process definition
            // for event-dispatching, if available
            Task task = CommandContextUtil.getTaskService().getTask(taskId);
            if (task != null) {
                processDefinitionId = task.getProcessDefinitionId();
                processInstanceId = task.getProcessInstanceId();
                executionId = task.getExecutionId();
            }
        }

        for (Attachment attachment : attachments) {
            string contentId = attachment.getContentId();
            if (contentId != null) {
                getByteArrayEntityManager().deleteByteArrayById(contentId);
            }

            dataManager.delete((AttachmentEntity) attachment);

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
