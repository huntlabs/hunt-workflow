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


import hunt.collection.List;

import flow.common.identity.Authentication;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.history.HistoricTaskLogEntryType;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;
import org.flowable.task.service.impl.persistence.CountingTaskEntity;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class IdentityLinkUtil {

    public static IdentityLinkEntity createProcessInstanceIdentityLink(ExecutionEntity processInstanceExecution, string userId, string groupId, string type) {
        IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createProcessInstanceIdentityLink(
                        processInstanceExecution.getId(), userId, groupId, type);

        CommandContextUtil.getHistoryManager().recordIdentityLinkCreated(identityLinkEntity);
        processInstanceExecution.getIdentityLinks().add(identityLinkEntity);

        return identityLinkEntity;
    }

    public static void deleteTaskIdentityLinks(TaskEntity taskEntity, string userId, string groupId, string type) {
        List<IdentityLinkEntity> removedIdentityLinkEntities = CommandContextUtil.getIdentityLinkService().deleteTaskIdentityLink(
                        taskEntity.getId(), taskEntity.getIdentityLinks(), userId, groupId, type);

        handleTaskIdentityLinkDeletions(taskEntity, removedIdentityLinkEntities, true, true);
    }

    public static void deleteProcessInstanceIdentityLinks(ExecutionEntity processInstanceEntity, string userId, string groupId, string type) {
        List<IdentityLinkEntity> removedIdentityLinkEntities = CommandContextUtil.getIdentityLinkService().deleteProcessInstanceIdentityLink(
                        processInstanceEntity.getId(), userId, groupId, type);
        for (IdentityLinkEntity identityLinkEntity : removedIdentityLinkEntities) {
            CommandContextUtil.getHistoryManager().recordIdentityLinkDeleted(identityLinkEntity);
        }
        processInstanceEntity.getIdentityLinks().removeAll(removedIdentityLinkEntities);
    }

    public static void handleTaskIdentityLinkAdditions(TaskEntity taskEntity, List<IdentityLinkEntity> identityLinkEntities) {
        for (IdentityLinkEntity identityLinkEntity : identityLinkEntities) {
            handleTaskIdentityLinkAddition(taskEntity, identityLinkEntity);
        }
    }

    public static void handleTaskIdentityLinkAddition(TaskEntity taskEntity, IdentityLinkEntity identityLinkEntity) {
        CommandContextUtil.getHistoryManager().recordIdentityLinkCreated(identityLinkEntity);

        if (CountingEntityUtil.isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = (CountingTaskEntity) taskEntity;
            if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setIdentityLinkCount(countingTaskEntity.getIdentityLinkCount() + 1);
            }
        }

        logTaskIdentityLinkEvent(HistoricTaskLogEntryType.USER_TASK_IDENTITY_LINK_ADDED.name(), taskEntity, identityLinkEntity);

        taskEntity.getIdentityLinks().add(identityLinkEntity);

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (processEngineConfiguration.getIdentityLinkInterceptor() !is null) {
            processEngineConfiguration.getIdentityLinkInterceptor().handleAddIdentityLinkToTask(taskEntity, identityLinkEntity);
        }
    }

    public static void handleTaskIdentityLinkDeletions(TaskEntity taskEntity, List<IdentityLinkEntity> identityLinks, bool cascadeHistory, bool updateTaskCounts) {
        for (IdentityLinkEntity identityLinkEntity : identityLinks) {
            if (cascadeHistory) {
                CommandContextUtil.getHistoryManager().recordIdentityLinkDeleted(identityLinkEntity);
            }
            if (updateTaskCounts) {
                handleTaskCountsForIdentityLinkDeletion(taskEntity, identityLinkEntity);
            }
            logTaskIdentityLinkEvent(HistoricTaskLogEntryType.USER_TASK_IDENTITY_LINK_REMOVED.name(), taskEntity, identityLinkEntity);
        }

        taskEntity.getIdentityLinks().removeAll(identityLinks);
    }

    protected static void handleTaskCountsForIdentityLinkDeletion(TaskEntity taskEntity, IdentityLinkEntity identityLink) {
        if (CountingEntityUtil.isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = (CountingTaskEntity) taskEntity;
            if (CountingEntityUtil.isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setIdentityLinkCount(countingTaskEntity.getIdentityLinkCount() - 1);
            }
        }
    }

    protected static void logTaskIdentityLinkEvent(string eventType, TaskEntity taskEntity, IdentityLinkEntity identityLinkEntity) {
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration();
        if (taskServiceConfiguration.isEnableHistoricTaskLogging()) {
            BaseHistoricTaskLogEntryBuilderImpl taskLogEntryBuilder = new BaseHistoricTaskLogEntryBuilderImpl(taskEntity);
            ObjectNode data = CommandContextUtil.getTaskServiceConfiguration().getObjectMapper().createObjectNode();
            if (identityLinkEntity.isUser()) {
                data.put("userId", identityLinkEntity.getUserId());
            } else if (identityLinkEntity.isGroup()) {
                data.put("groupId", identityLinkEntity.getGroupId());
            }
            data.put("type", identityLinkEntity.getType());
            taskLogEntryBuilder.timeStamp(taskServiceConfiguration.getClock().getCurrentTime());
            taskLogEntryBuilder.userId(Authentication.getAuthenticatedUserId());
            taskLogEntryBuilder.data(data.toString());
            taskLogEntryBuilder.type(eventType);
            taskServiceConfiguration.getInternalHistoryTaskManager().recordHistoryUserTaskLog(taskLogEntryBuilder);
        }
    }

}
