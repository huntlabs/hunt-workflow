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
module flow.engine.impl.history.AbstractHistoryManager;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.common.api.scop.ScopeTypes;
import flow.common.history.HistoryLevel;
//import flow.common.identity.Authentication;
//import flow.common.persistence.cache.EntityCache;
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
import flow.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.service.HistoricTaskService;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.history.HistoryManager;
import hunt.Exceptions;


abstract class AbstractHistoryManager : AbstractManager , HistoryManager {

    protected HistoryLevel historyLevel;
    protected bool enableProcessDefinitionHistoryLevel;
    protected bool usePrefixId;

    this(ProcessEngineConfigurationImpl processEngineConfiguration, HistoryLevel historyLevel, bool usePrefixId) {
        super(processEngineConfiguration);
        this.historyLevel = historyLevel;
        this.enableProcessDefinitionHistoryLevel = processEngineConfiguration.isEnableProcessDefinitionHistoryLevel();
        this.usePrefixId = usePrefixId;
    }

    public bool isHistoryLevelAtLeast(HistoryLevel level) {
        return isHistoryLevelAtLeast(level, null);
    }

    public bool isHistoryLevelAtLeast(HistoryLevel level, string processDefinitionId) {
        if (enableProcessDefinitionHistoryLevel && processDefinitionId !is null) {
            HistoryLevel processDefinitionLevel = getProcessDefinitionHistoryLevel(processDefinitionId);
            if (processDefinitionLevel !is null) {
                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("Current history level: {}, level required: {}", processDefinitionLevel, level);
                //}
                return processDefinitionLevel.isAtLeast(level);
            } else {
                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("Current history level: {}, level required: {}", historyLevel, level);
                //}
                return historyLevel.isAtLeast(level);
            }

        } else {
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Current history level: {}, level required: {}", historyLevel, level);
            //}

            // Comparing enums actually compares the location of values declared in the enum
            return historyLevel.isAtLeast(level);
        }
    }

    public bool isHistoryEnabled() {
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Current history level: {}", historyLevel);
        //}
        return historyLevel != HistoryLevel.NONE;
    }


    public bool isHistoryEnabled(string processDefinitionId) {
        if (enableProcessDefinitionHistoryLevel && processDefinitionId !is null) {
            HistoryLevel processDefinitionLevel = getProcessDefinitionHistoryLevel(processDefinitionId);
            if (processDefinitionLevel !is null) {
                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("Current history level: {}", processDefinitionLevel);
                //}
                return processDefinitionLevel != (HistoryLevel.NONE);
            } else {
                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("Current history level: {}", historyLevel);
                //}
                return !historyLevel ==(HistoryLevel.NONE);
            }

        } else {
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Current history level: {}", historyLevel);
            //}
            return !historyLevel==(HistoryLevel.NONE);
        }
    }


    public void createIdentityLinkComment(TaskEntity taskEntity, string userId, string groupId, string type, bool create) {
        createIdentityLinkComment(taskEntity, userId, groupId, type, create, false);
    }


    public void createUserIdentityLinkComment(TaskEntity taskEntity, string userId, string type, bool create) {
        createIdentityLinkComment(taskEntity, userId, null, type, create, false);
    }


    public void createGroupIdentityLinkComment(TaskEntity taskEntity, string groupId, string type, bool create) {
        createIdentityLinkComment(taskEntity, null, groupId, type, create, false);
    }


    public void createUserIdentityLinkComment(TaskEntity taskEntity, string userId, string type, bool create, bool forceNullUserId) {
        createIdentityLinkComment(taskEntity, userId, null, type, create, forceNullUserId);
    }

    /*
     * (non-Javadoc)
     *
     * @see flow.engine.impl.history.HistoryManagerInterface# createIdentityLinkComment(java.lang.string, java.lang.string, java.lang.string, java.lang.string, bool, bool)
     */

    public void createIdentityLinkComment(TaskEntity taskEntity, string userId, string groupId, string type, bool create, bool forceNullUserId) {
        implementationMissing(false);
      //if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, taskEntity.getProcessDefinitionId())) {
        //    string authenticatedUserId = Authentication.getAuthenticatedUserId();
        //    CommentEntity comment = getCommentEntityManager().create();
        //    comment.setUserId(authenticatedUserId);
        //    comment.setType(CommentEntity.TYPE_EVENT);
        //    comment.setTime(getClock().getCurrentTime());
        //    comment.setTaskId(taskEntity.getId());
        //    if (userId !is null || forceNullUserId) {
        //        if (create && !forceNullUserId) {
        //            comment.setAction(Event.ACTION_ADD_USER_LINK);
        //        } else {
        //            comment.setAction(Event.ACTION_DELETE_USER_LINK);
        //        }
        //        comment.setMessage(new string[] { userId, type });
        //    } else {
        //        if (create) {
        //            comment.setAction(Event.ACTION_ADD_GROUP_LINK);
        //        } else {
        //            comment.setAction(Event.ACTION_DELETE_GROUP_LINK);
        //        }
        //        comment.setMessage(new string[] { groupId, type });
        //    }
        //
        //    getCommentEntityManager().insert(comment);
        //}
    }


    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create) {
        createProcessInstanceIdentityLinkComment(processInstance, userId, groupId, type, create, false);
    }


    public void createProcessInstanceIdentityLinkComment(ExecutionEntity processInstance, string userId, string groupId, string type, bool create, bool forceNullUserId) {
        implementationMissing(false);
        //if (isHistoryLevelAtLeast(HistoryLevel.AUDIT, processInstance.getProcessDefinitionId())) {
        //    string authenticatedUserId = Authentication.getAuthenticatedUserId();
        //    CommentEntity comment = getCommentEntityManager().create();
        //    comment.setUserId(authenticatedUserId);
        //    comment.setType(CommentEntity.TYPE_EVENT);
        //    comment.setTime(getClock().getCurrentTime());
        //    comment.setProcessInstanceId(processInstance.getId());
        //    if (userId !is null || forceNullUserId) {
        //        if (create && !forceNullUserId) {
        //            comment.setAction(Event.ACTION_ADD_USER_LINK);
        //        } else {
        //            comment.setAction(Event.ACTION_DELETE_USER_LINK);
        //        }
        //        comment.setMessage(new string[] { userId, type });
        //    } else {
        //        if (create) {
        //            comment.setAction(Event.ACTION_ADD_GROUP_LINK);
        //        } else {
        //            comment.setAction(Event.ACTION_DELETE_GROUP_LINK);
        //        }
        //        comment.setMessage(new string[] { groupId, type });
        //    }
        //    getCommentEntityManager().insert(comment);
        //}
    }

    /*
     * (non-Javadoc)
     *
     * @see flow.engine.impl.history.HistoryManagerInterface# createAttachmentComment(java.lang.string, java.lang.string, java.lang.string, bool)
     */

    public void createAttachmentComment(TaskEntity task, ExecutionEntity processInstance, string attachmentName, bool create) {
        implementationMissing(false);
        //string processDefinitionId = null;
        //if (processInstance !is null) {
        //    processDefinitionId = processInstance.getProcessDefinitionId();
        //} else if (task !is null) {
        //    processDefinitionId = task.getProcessDefinitionId();
        //}
        //if (isHistoryEnabled(processDefinitionId)) {
        //    string userId = Authentication.getAuthenticatedUserId();
        //    CommentEntity comment = getCommentEntityManager().create();
        //    comment.setUserId(userId);
        //    comment.setType(CommentEntity.TYPE_EVENT);
        //    comment.setTime(getClock().getCurrentTime());
        //    if (task !is null) {
        //        comment.setTaskId(task.getId());
        //    }
        //    if (processInstance !is null) {
        //        comment.setProcessInstanceId(processInstance.getId());
        //    }
        //    if (create) {
        //        comment.setAction(Event.ACTION_ADD_ATTACHMENT);
        //    } else {
        //        comment.setAction(Event.ACTION_DELETE_ATTACHMENT);
        //    }
        //    comment.setMessage(attachmentName);
        //    getCommentEntityManager().insert(comment);
        //}
    }


    public void updateActivity(ExecutionEntity childExecution, string oldActivityId, FlowElement newFlowElement, TaskEntity task, Date updateTime) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY)) {
            HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager = CommandContextUtil.getHistoricActivityInstanceEntityManager();
            List!HistoricActivityInstanceEntity historicActivityInstances = historicActivityInstanceEntityManager.findHistoricActivityInstancesByExecutionAndActivityId(childExecution.getId(), oldActivityId);
            foreach (HistoricActivityInstanceEntity historicActivityInstance ; historicActivityInstances) {
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

    protected HistoricActivityInstanceEntity getHistoricActivityInstanceFromCache(string executionId, string activityId, bool endTimeMustBeNull) {
        implementationMissing(false);

        //List!HistoricActivityInstanceEntity cachedHistoricActivityInstances = getEntityCache().findInCache(HistoricActivityInstanceEntity.class);
        //for (HistoricActivityInstanceEntity cachedHistoricActivityInstance : cachedHistoricActivityInstances) {
        //    if (activityId !is null
        //                    && activityId.equals(cachedHistoricActivityInstance.getActivityId())
        //                    && (!endTimeMustBeNull || cachedHistoricActivityInstance.getEndTime() is null)) {
        //        if (executionId.equals(cachedHistoricActivityInstance.getExecutionId())) {
        //            return cachedHistoricActivityInstance;
        //        }
        //    }
        //}

        return null;
    }


    public HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, bool endTimeMustBeNull) {
        if (isHistoryLevelAtLeast(HistoryLevel.ACTIVITY, execution.getProcessDefinitionId())) {
            string activityId = getActivityIdForExecution(execution);
            return activityId !is null ? findHistoricActivityInstance(execution, activityId, endTimeMustBeNull) : null;
        }

        return null;
    }

    protected string getActivityIdForExecution(ExecutionEntity execution) {
        string activityId = null;
        if (cast(FlowNode)execution.getCurrentFlowElement() !is null) {
            activityId = execution.getCurrentFlowElement().getId();
        } else if (cast(SequenceFlow)execution.getCurrentFlowElement() !is null
                        && execution.getCurrentFlowableListener() is null) { // while executing sequence flow listeners, we don't want historic activities
            activityId = (cast(SequenceFlow) execution.getCurrentFlowElement()).getSourceFlowElement().getId();
        }
        return activityId;
    }

    protected HistoricActivityInstanceEntity findHistoricActivityInstance(ExecutionEntity execution, string activityId, bool endTimeMustBeNull) {
          implementationMissing(false);
        // No use looking for the HistoricActivityInstance when no activityId is provided.
        //if (activityId is null) {
        //    return null;
        //}
        //
        //string executionId = execution.getId();
        //
        //// Check the cache
        //HistoricActivityInstanceEntity historicActivityInstanceEntityFromCache = getHistoricActivityInstanceFromCache(executionId, activityId, endTimeMustBeNull);
        //if (historicActivityInstanceEntityFromCache !is null) {
        //    return historicActivityInstanceEntityFromCache;
        //}
        //
        //// If the execution was freshly created, there is no need to check the database,
        //// there can never be an entry for a historic activity instance with this execution id.
        //if (!execution.isInserted() && !execution.isProcessInstanceType()) {
        //
        //    // Check the database
        //    List!HistoricActivityInstanceEntity historicActivityInstances = getHistoricActivityInstanceEntityManager()
        //                    .findUnfinishedHistoricActivityInstancesByExecutionAndActivityId(executionId, activityId);
        //
        //    if (historicActivityInstances.size() > 0 && (!endTimeMustBeNull || historicActivityInstances.get(0).getEndTime() is null)) {
        //        return historicActivityInstances.get(0);
        //    }
        //
        //}

        return null;
    }

    protected HistoryLevel getProcessDefinitionHistoryLevel(string processDefinitionId) {
        implementationMissing(false);
        return null;
        //HistoryLevel processDefinitionHistoryLevel = null;
        //
        //try {
        //    ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
        //
        //    BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);
        //
        //    Process process = bpmnModel.getProcessById(processDefinition.getKey());
        //    if (process.getExtensionElements().containsKey("historyLevel")) {
        //        ExtensionElement historyLevelElement = process.getExtensionElements().get("historyLevel").iterator().next();
        //        string historyLevelValue = historyLevelElement.getElementText();
        //        if (StringUtils.isNotEmpty(historyLevelValue)) {
        //            try {
        //                processDefinitionHistoryLevel = HistoryLevel.getHistoryLevelForKey(historyLevelValue);
        //
        //            } catch (Exception e) {}
        //        }
        //    }
        //
        //    if (processDefinitionHistoryLevel is null) {
        //        processDefinitionHistoryLevel = this.historyLevel;
        //    }
        //} catch (Exception e) {}
        //
        //return processDefinitionHistoryLevel;
    }

    protected string parseActivityType(FlowElement element) {
        implementationMissing(false);
        return "";
        //string elementType = element.getClass().getSimpleName();
        //elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        //return elementType;
    }

    //protected EntityCache getEntityCache() {
    //    return getSession(EntityCache.class);
    //}

    public HistoryLevel getHistoryLevel() {
        return historyLevel;
    }

    public void setHistoryLevel(HistoryLevel historyLevel) {
        this.historyLevel = historyLevel;
    }

    protected string getProcessDefinitionId(VariableInstanceEntity variable, ExecutionEntity sourceActivityExecution) {
        string processDefinitionId = null;
        if (sourceActivityExecution !is null) {
            processDefinitionId = sourceActivityExecution.getProcessDefinitionId();
        } else if (variable.getProcessInstanceId() !is null && variable.getProcessInstanceId().length != 0) {
            ExecutionEntity processInstanceExecution = CommandContextUtil.getExecutionEntityManager().findById(variable.getProcessInstanceId());
            if (processInstanceExecution !is null) {
                processDefinitionId = processInstanceExecution.getProcessDefinitionId();
            }
        } else if (variable.getTaskId() !is null && variable.getTaskId().length !=0 ) {
            TaskEntity taskEntity = CommandContextUtil.getTaskService().getTask(variable.getTaskId());
            if (taskEntity !is null) {
                processDefinitionId = taskEntity.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }

    protected string getProcessDefinitionId(IdentityLinkEntity identityLink) {
        string processDefinitionId = null;
        if (identityLink.getProcessInstanceId() !is null && identityLink.getProcessInstanceId().length != 0) {
            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(identityLink.getProcessInstanceId());
            if (execution !is null) {
                processDefinitionId = execution.getProcessDefinitionId();
            }
        } else if (identityLink.getTaskId() !is null && identityLink.getTaskId().length != 0) {
            TaskEntity task = CommandContextUtil.getTaskService().getTask(identityLink.getTaskId());
            if (task !is null) {
                processDefinitionId = task.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }

    protected string getProcessDefinitionId(EntityLinkEntity entityLink) {
        string processDefinitionId = null;
        if (ScopeTypes.BPMN == (entityLink.getScopeType()) && entityLink.getScopeId() !is null && entityLink.getScopeId().length != 0) {
            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager().findById(entityLink.getScopeId());
            if (execution !is null) {
                processDefinitionId = execution.getProcessDefinitionId();
            }

        } else if (ScopeTypes.TASK == (entityLink.getScopeType()) && entityLink.getScopeId() !is null && entityLink.getScopeId().length != 0) {
            TaskEntity task = CommandContextUtil.getTaskService().getTask(entityLink.getScopeId());
            if (task !is null) {
                processDefinitionId = task.getProcessDefinitionId();
            }
        }
        return processDefinitionId;
    }
}
