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

module flow.engine.impl.persistence.entity.CommentEntityManagerImpl;

import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.CommentDataManager;
import flow.engine.task.Comment;
import flow.engine.task.Event;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.impl.persistence.entity.CommentEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class CommentEntityManagerImpl
    : AbstractProcessEngineEntityManager!(CommentEntity, CommentDataManager)
    , CommentEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, CommentDataManager commentDataManager) {
        super(processEngineConfiguration, commentDataManager);
    }

    override
    public void insert(CommentEntity commentEntity) {
        checkHistoryEnabled();

        insert(commentEntity, false);

        Comment comment = cast(Comment) commentEntity;
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            // Forced to fetch the process-instance to associate the right
            // process definition
            string processDefinitionId = null;
            string processInstanceId = comment.getProcessInstanceId();
            if (comment.getProcessInstanceId() !is null) {
                ExecutionEntity process = getExecutionEntityManager().findById(comment.getProcessInstanceId());
                if (process !is null) {
                    processDefinitionId = process.getProcessDefinitionId();
                }
            }
            getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, commentEntity, processInstanceId, processInstanceId, processDefinitionId));
            getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, commentEntity, processInstanceId, processInstanceId, processDefinitionId));
        }
    }

    override
    public CommentEntity update(CommentEntity commentEntity) {
        checkHistoryEnabled();

        CommentEntity updatedCommentEntity = update(commentEntity, false);

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            // Forced to fetch the process-instance to associate the right
            // process definition
            string processDefinitionId = null;
            string processInstanceId = updatedCommentEntity.getProcessInstanceId();
            if (updatedCommentEntity.getProcessInstanceId() !is null) {
                ExecutionEntity process = getExecutionEntityManager().findById(updatedCommentEntity.getProcessInstanceId());
                if (process !is null) {
                    processDefinitionId = process.getProcessDefinitionId();
                }
            }
            getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, commentEntity, processInstanceId, processInstanceId, processDefinitionId));
        }

        return updatedCommentEntity;
    }

    public List!Comment findCommentsByTaskId(string taskId) {
        checkHistoryEnabled();
        return dataManager.findCommentsByTaskId(taskId);
    }

    public List!Comment findCommentsByTaskIdAndType(string taskId, string type) {
        checkHistoryEnabled();
        return dataManager.findCommentsByTaskIdAndType(taskId, type);
    }

    public List!Comment findCommentsByType(string type) {
        checkHistoryEnabled();
        return dataManager.findCommentsByType(type);
    }

    public List!Event findEventsByTaskId(string taskId) {
        checkHistoryEnabled();
        return dataManager.findEventsByTaskId(taskId);
    }

    public List!Event findEventsByProcessInstanceId(string processInstanceId) {
        checkHistoryEnabled();
        return dataManager.findEventsByProcessInstanceId(processInstanceId);
    }

    public void deleteCommentsByTaskId(string taskId) {
        checkHistoryEnabled();
        dataManager.deleteCommentsByTaskId(taskId);
    }

    public void deleteCommentsByProcessInstanceId(string processInstanceId) {
        checkHistoryEnabled();
        dataManager.deleteCommentsByProcessInstanceId(processInstanceId);
    }

    public List!Comment findCommentsByProcessInstanceId(string processInstanceId) {
        checkHistoryEnabled();
        return dataManager.findCommentsByProcessInstanceId(processInstanceId);
    }

    public List!Comment findCommentsByProcessInstanceId(string processInstanceId, string type) {
        checkHistoryEnabled();
        return dataManager.findCommentsByProcessInstanceId(processInstanceId, type);
    }

    public Comment findComment(string commentId) {
        return dataManager.findComment(commentId);
    }

    public Event findEvent(string commentId) {
        return dataManager.findEvent(commentId);
    }

    override
    public void dele(CommentEntity commentEntity) {
        checkHistoryEnabled();

        dele(commentEntity, false);

        Comment comment = cast(Comment) commentEntity;
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            // Forced to fetch the process-instance to associate the right
            // process definition
            string processDefinitionId = null;
            string processInstanceId = comment.getProcessInstanceId();
            if (comment.getProcessInstanceId() !is null) {
                ExecutionEntity process = getExecutionEntityManager().findById(comment.getProcessInstanceId());
                if (process !is null) {
                    processDefinitionId = process.getProcessDefinitionId();
                }
            }
            getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, commentEntity, processInstanceId, processInstanceId, processDefinitionId));
        }
    }

    protected void checkHistoryEnabled() {
        if (!getHistoryManager().isHistoryEnabled()) {
            throw new FlowableException("In order to use comments, history should be enabled");
        }
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return engineConfiguration.getExecutionEntityManager();
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

}
