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


import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.ExtensionElement;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import org.flowable.bpmn.model.Process;
import org.flowable.bpmn.model.SequenceFlow;
import flow.common.api.scope.ScopeTypes;
import flow.common.history.HistoryLevel;
import flow.common.identity.Authentication;
import flow.common.persistence.cache.EntityCache;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.AbstractManager;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.task.Event;
import org.flowable.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import org.flowable.task.service.HistoricTaskService;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

abstract class AbstractHistoryManager extends AbstractManager implements HistoryManager {

    private static final Logger LOGGER = LoggerFactory.getLogger(AbstractHistoryManager.class.getName());

    protected HistoryLevel historyLevel;
    protected boolean enableProcessDefinitionHistoryLevel;
    protected boolean usePrefixId;

    public AbstractHistoryManager(ProcessEngineConfigurationImpl processEngineConfiguration, HistoryLevel historyLevel, boolean usePrefixId) {
        super(processEngineConfiguration);
        this.historyLevel = historyLevel;
        this.enableProcessDefinitionHistoryLevel = processEngineConfiguration.isEnableProcessDefinitionHistoryLevel();
        this.usePrefixId = usePrefixId;
    }
    
    @Override
    public boolean isHistoryLevelAtLeast(HistoryLevel level) {
        return isHistoryLevelAtLeast(level, null);
    }

    @Override
    public boolean isHistoryLevelAtLeast(HistoryLevel level, string processDefinitionId) {
        if (enableProcessDefinitionHistoryLevel && processDefinitionId != null) {
            HistoryLevel processDefinitionLevel = getProcessDefinitionHistoryLevel(processDefinitionId);
            if (processDefinitionLevel != null) {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("Current history level: {}, level required: {}", processDefinitionLevel, level);
                }
                return processDefinitionLevel.isAtLeast(level);
            } else {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("Current history level: {}, level required: {}", historyLevel, level);
                }
                return historyLevel.isAtLeast(level);
            }
            
        } else {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("Current history level: {}, level required: {}", historyLevel, level);
            }
            
            // Comparing enums actually compares the location of values declared in the enum
            return historyLevel.isAtLeast(level);
        }
    }

    @Override
    public boolean isHistoryEnabled() {
        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("Current history level: {}", historyLevel);
        }
        return historyLevel != HistoryLevel.NONE;
    }
    
    @Override
    public boolean isHistoryEnabled(string processDefinitionId) {
        if (enableProcessDefinitionHistoryLevel && processDefinitionId != null) {
            HistoryLevel processDefinitionLevel = getProcessDefinitionHistoryLevel(processDefinitionId);
            if (processDefinitionLevel != null) {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("Current history level: {}", processDefinitionLevel);
                }
                return !processDefinitionLevel.equals(HistoryLevel.NONE);
            } else {
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("Current history level: {}", historyLevel);
                }
                return !historyLevel.equals(HistoryLevel.NONE);
            }
           
        } else {
            if (LOGGER.isDebugEnabled()) {
                LOGGER.debug("Current history level: {}", historyLevel);
            }
            return !historyLevel.equals(HistoryLevel.NONE);
        }
    }

    @Override
    public void createIdentityLinkComment(TaskEntity taskEntity, string userId, string groupId, string type, boolean create) {
        createIdentityLinkComment(taskEntity, userId, groupId, type, create, false);
    }

    @Override
    public void createUserIdentityLinkComment(TaskEntity taskEntity, string userId, string type, boolean create) {
        createIdentityLinkComment(taskEntity, userId, null, type, create, false);
    }

    @Override
    public void createGroupIdentityLinkComment(TaskEntity taskEntity, string groupId, string type, boolean create) {
        createIdentityLinkComment(taskEntity, null, groupId, type, create, false);
    }

    @Override
    public void createUserIdentityLinkComment(TaskEntity taskEntity, string userId, string type, boolean create, boolean forceNullUserId) {
        createIdentityLinkComment(taskEntity, userId, null, type, create, forceNullUserId);
    }

    /*
     * (non-Javadoc)
     * 
     * @see flow.engine.impl.history.HistoryManagerInterface# createIdentityLinkComment(java.lang.string, java.lang.string, java.lang.string, java.lang.string, boolean, boolean)
     */
    @Override
    public void createIdentityLinkComment(TaskEntity taskEntity, string userId, string groupId, string type, boolean create, boolean forceNullUserId) {
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, taskEntity.getProcessDefinitionId())) {
            string authenticatedUserId = Authentication.getAuthenticatedUserId();
            CommentEntity comment = getCommentEntityManager().create();
            comment.setUserId(authenticatedUserId);
            comment.setType(CommentEntity.TYPE_EVENT);
            comment.setTime(getClock().getCurrentTime());
            comment.setTaskId(taskEntity.getId());
            if (userId != null || forceNullUserId) {
                if (create && !forceNullUserId) {
                    comment.setAction(Event.ACTION_ADD_USER_LINK);
                } else {
                    comment.setAction(Event.ACTION_DELETE_USER_LINK);
                }
                comment.setMessage(new string[] { userId, type });
            } else {
                if (create) {
                    comment.setAction(Event.ACTION_ADD_GROUP_LINK);
                } else {
                    comment.setAction(Event.ACTION_DELETE_GROUP_LINK);
                }
                comment.setMessage(new string[] { groupId, type });
            }

            getCommentEntityManager().insert(comment);
        }
    }

    @Override
    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, boolean create) {
        createProcessInstanceIdentityLinkComment(processInstance, userId, groupId, type, create, false);
    }

    @Override
    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, boolean create, boolean forceNullUserId) {
        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processInstance.getProcessDefinitionId())) {
            string authenticatedUserId = Authentication.getAuthenticatedUserId();
            CommentEntity comment = getCommentEntityManager().create();
            comment.setUserId(authenticatedUserId);
            comment.setType(CommentEntity.TYPE_EVENT);
            comment.setTime(getClock().getCurrentTime());
            comment.setProcessInstanceId(processInstance.getId());
            if (userId != null || forceNullUserId) {
                if (create && !forceNullUserId) {
                    comment.setAction(Event.ACTION_ADD_USER_LINK);
                } else {
                    comment.setAction(Event.ACTION_DELETE_USER_LINK);
                }
                comment.setMessage(new string[] { userId, type });
            } else {
                if (create) {
                    comment.setAction(Event.ACTION_ADD_GROUP_LINK);
                } else {
                    comment.setAction(Event.ACTION_DELETE_GROUP_LINK);
                }
                comment.setMessage(new string[] { groupId, type });
            }
            getCommentEntityManager().insert(comment);
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see flow.engine.impl.history.HistoryManagerInterface# createAttachmentComment(java.lang.string, java.lang.string, java.lang.string, boolean)
     */
    @Override
    public void createAttachmentComment(TaskEntity task, ExecutionEntity processInstance, string attachmentName, boolean create) {
        string processDefinitionId = null;
        if (processInstance != null) {
            processDefinitionId = processInstance.getProcessDefinitionId();
        } else if (task != null) {
            processDefinitionId = task.getProcessDefinitionId();
        }
        if (isHistoryEnabled(processDefinitionId)) {
            string userId = Authentication.getAuthenticatedUserId();
            CommentEntity comment = getCommentEntityManager().create();
            comment.setUserId(userId);
            comment.setType(CommentEntity.TYPE_EVENT);
            comment.setTime(getClock().getCurrentTime());
            if (task != null) {
                comment.setTaskId(task.getId());
            }
            if (processInstance != null) {
                comment.setProcessInstanceId(processInstance.getId());
            }
            if (create) {
                comment.setAction(Event.ACTION_ADD_ATTACHMENT);
            } else {
                comment.setAction(Event.ACTION_DELETE_ATTACHMENT);
            }
            comment.setMessage(attachmentName);
            getCommentEntityManager().insert(comment);
        }
    }

    @Override
    public void updateActivity(ExecutionEntity childExecution, string oldActivityId, FlowElement newFlowElement, TaskEntity task, Date updateTime) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager = CommandContextUtil.getHistoricActivityInstanceEntityManager();
            List<HistoricActivityInstanceEntity> historicActivityInstances = historicActivityInstanceEntityManager.findHistoricActivityInstancesByExecutionAndActivityId(childExecution.getId(), oldActivityId);
            for (HistoricActivityInstanceEntity historicActivityInstance : historicActivityInstances) {
                historicActivityInstance.setProcessDefinitionId(childExecution.getProcessDefinitionId());
                historicActivityInstance.setActivityId(childExecution.getActivityId());
                historicActivityInstance.setActivityName(newFlowElement.getName());
            }
        }

        if (isHistoryLevelAtLeast(HistoryLevel.AUDIT)) {
            HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
            historicTaskService.recordTaskInfoChange(task, updateTime);
        }

    }

    protected HistoricActivityInstanceEntity getHistoricActivityInstanceFromCache(string executionId, string activityId, boolean endTimeMustBeNull) {
        List<HistoricActivityInstanceEntity> cachedHistoricActivityInstances = getEntityCache().findInCache(HistoricActivityInstanceEntity.class);
        for (HistoricActivityInstanceEntity cachedHistoricActivityInstance : cachedHistoricActivityInstances) {
            if (activityId != null
                            && activityId.equals(cachedHistoricActivityInstance.getActivityId())
                            && (!endTimeMustBeNull || cachedHistoricActivityInstance.getEndTime() == null)) {
                if (executionId.equals(cachedHistoricActivityInstance.getExecutionId())) {
                    return cachedHistoricActivityInstance;
                }
            }
        }

        return null;
    }

    @Override
    public HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, boolean endTimeMustBeNull) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, execution.getProcessDefinitionId())) {
            string activityId = getActivityIdForExecution(execution);
            return activityId != null ? findHistoricActivityInstance(execution, activityId, endTimeMustBeNull) : null;
        }
        
        return null;
    }

    protected string getActivityIdForExecution(ExecutionEntity execution) {
        string activityId = null;
        if (execution.getCurrentFlowElement() instanceof FlowNode) {
            activityId = execution.getCurrentFlowElement().getId();
        } else if (execution.getCurrentFlowElement() instanceof SequenceFlow
                        && execution.getCurrentFlowableListener() == null) { // while executing sequence flow listeners, we don't want historic activities
            activityId = ((SequenceFlow) execution.getCurrentFlowElement()).getSourceFlowElement().getId();
        }
        return activityId;
    }

    protected HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, string activityId, boolean endTimeMustBeNull) {

        // No use looking for the HistoricActivityInstance when no activityId is provided.
        if (activityId == null) {
            return null;
        }

        string executionId = execution.getId();

        // Check the cache
        HistoricActivityInstanceEntity historicActivityInstanceEntityFromCache = getHistoricActivityInstanceFromCache(executionId, activityId, endTimeMustBeNull);
        if (historicActivityInstanceEntityFromCache != null) {
            return historicActivityInstanceEntityFromCache;
        }

        // If the execution was freshly created, there is no need to check the database,
        // there can never be an entry for a historic activity instance with this execution id.
        if (!execution.isInserted() && !execution.isProcessInstanceType()) {

            // Check the database
            List<HistoricActivityInstanceEntity> historicActivityInstances = getHistoricActivityInstanceEntityManager()
                            .findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(executionId, activityId);

            if (historicActivityInstances.size() > 0 && (!endTimeMustBeNull || historicActivityInstances.get(0).getEndTime() == null)) {
                return historicActivityInstances.get(0);
            }

        }

        return null;
    }

    protected HistoryLevel getProcessDefinitionHistoryLevel(string processDefinitionId) {
        HistoryLevel processDefinitionHistoryLevel = null;

        try {
            ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
            
            BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);
    
            Process process = bpmnModel.getProcessById(processDefinition.getKey());
            if (process.getExtensionElements().containsKey("historyLevel")) {
                ExtensionElement historyLevelElement = process.getExtensionElements().get("historyLevel").iterator().next();
                string historyLevelValue = historyLevelElement.getElementText();
                if (StringUtils.isNotEmpty(historyLevelValue)) {
                    try {
                        processDefinitionHistoryLevel = HistoryLevel.getHistoryLevelForKey(historyLevelValue);
    
                    } catch (Exception e) {}
                }
            }
    
            if (processDefinitionHistoryLevel == null) {
                processDefinitionHistoryLevel = this.historyLevel;
            }
        } catch (Exception e) {}

        return processDefinitionHistoryLevel;
    }

    protected string parseActivityType(FlowElement element) {
        string elementType = element.getClass().getSimpleName();
        elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        return elementType;
    }

    protected EntityCache getEntityCache() {
        return getSession(EntityCache.class);
    }

    public HistoryLevel getHistoryLevel() {
        return historyLevel;
    }

    public void setHistoryLevel(HistoryLevel historyLevel) {
        this.historyLevel = historyLevel;
    }

    protected string getProcessDefinitionId(VariableInstanceEntity variable, ExecutionEntity sourceActivityExecution) {
        string processDefinitionId = null;
        if (sourceActivityExecution != null) {
            processDefinitionId = sourceActivityExecution.getProcessDefinitionId();
        } else if (variable.getProcessInstanceId() != null) {
            ExecutionEntity processInstanceExecution = CommandContextUtil.getExecutionEntityManager().findById(variable.getProcessInstanceId());
            if (processInstanceExecution != null) {
                processDefinitionId = processInstanceExecution.getProcessDefinitionId();
            }
        } else if (variable.getTaskId() != null) {
            TaskEntity taskEntity = CommandContextUtil.getTaskService().getTask(variable.getTaskId());
            if (taskEntity != null) {
                processDefinitionId = taskEntity.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }

    protected string getProcessDefinitionId(IdentityLinkEntity identityLink) {
        string processDefinitionId = null;
        if (identityLink.getProcessInstanceId() != null) {
            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(identityLink.getProcessInstanceId());
            if (execution != null) {
                processDefinitionId = execution.getProcessDefinitionId();
            }
        } else if (identityLink.getTaskId() != null) {
            TaskEntity task = CommandContextUtil.getTaskService().getTask(identityLink.getTaskId());
            if (task != null) {
                processDefinitionId = task.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }

    protected string getProcessDefinitionId(EntityLinkEntity entityLink) {
        string processDefinitionId = null;
        if (ScopeTypes.BPMN.equals(entityLink.getScopeType()) && entityLink.getScopeId() != null) {
            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(entityLink.getScopeId());
            if (execution != null) {
                processDefinitionId = execution.getProcessDefinitionId();
            }

        } else if (ScopeTypes.TASK.equals(entityLink.getScopeType()) && entityLink.getScopeId() != null) {
            TaskEntity task = CommandContextUtil.getTaskService().getTask(entityLink.getScopeId());
            if (task != null) {
                processDefinitionId = task.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }
}
