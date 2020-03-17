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


import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getDateFromJson;
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getIntegerFromJson;
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.task.service.HistoricTaskService;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class TaskEndedHistoryJsonTransformer extends AbstractNeedsTaskHistoryJsonTransformer {

    @Override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_TASK_ENDED);
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        string taskId = getStringFromJson(historicalData, HistoryJsonConstants.ID);
        HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
        HistoricTaskInstanceEntity historicTaskInstance = historicTaskService.getHistoricTask(taskId);

        if (historicTaskInstance !is null) {
            Date lastUpdateTime = getDateFromJson(historicalData, HistoryJsonConstants.TIMESTAMP);
            if (historicTaskInstance.getLastUpdateTime() is null || !historicTaskInstance.getLastUpdateTime().after(lastUpdateTime)) {
                historicTaskInstance.setLastUpdateTime(lastUpdateTime);

                historicTaskInstance.setName(getStringFromJson(historicalData, HistoryJsonConstants.NAME));
                historicTaskInstance.setParentTaskId(getStringFromJson(historicalData, HistoryJsonConstants.PARENT_TASK_ID));
                historicTaskInstance.setDescription(getStringFromJson(historicalData, HistoryJsonConstants.DESCRIPTION));
                historicTaskInstance.setOwner(getStringFromJson(historicalData, HistoryJsonConstants.OWNER));
                historicTaskInstance.setAssignee(getStringFromJson(historicalData, HistoryJsonConstants.ASSIGNEE));
                if (historicalData.has(HistoryJsonConstants.CREATE_TIME)) {
                    historicTaskInstance.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.CREATE_TIME));
                } else {
                    // For backwards compatibility. New async data uses the CREATE_TIME. This should be removed eventually
                    historicTaskInstance.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.START_TIME));
                }
                historicTaskInstance.setTaskDefinitionKey(getStringFromJson(historicalData, HistoryJsonConstants.TASK_DEFINITION_KEY));
                historicTaskInstance.setTaskDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.TASK_DEFINITION_ID));
                historicTaskInstance.setPriority(getIntegerFromJson(historicalData, HistoryJsonConstants.PRIORITY));
                historicTaskInstance.setDueDate(getDateFromJson(historicalData, HistoryJsonConstants.DUE_DATE));
                historicTaskInstance.setCategory(getStringFromJson(historicalData, HistoryJsonConstants.CATEGORY));
                historicTaskInstance.setFormKey(getStringFromJson(historicalData, HistoryJsonConstants.FORM_KEY));
                historicTaskInstance.setClaimTime(getDateFromJson(historicalData, HistoryJsonConstants.CLAIM_TIME));
                historicTaskInstance.setTenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));

            }

            Date endTime = getDateFromJson(historicalData, HistoryJsonConstants.END_TIME);
            historicTaskInstance.setEndTime(endTime);
            historicTaskInstance.setDeleteReason(getStringFromJson(historicalData, HistoryJsonConstants.DELETE_REASON));

            Date startTime = historicTaskInstance.getStartTime();
            if (startTime !is null && endTime !is null) {
                historicTaskInstance.setDurationInMillis(endTime.getTime() - startTime.getTime());
            }

        } else {
            string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);

            historicTaskInstance = historicTaskService.createHistoricTask();
            historicTaskInstance.setId(taskId);
            historicTaskInstance.setProcessDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_ID));
            historicTaskInstance.setProcessInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID));
            historicTaskInstance.setExecutionId(executionId);
            historicTaskInstance.setName(getStringFromJson(historicalData, HistoryJsonConstants.NAME));
            historicTaskInstance.setParentTaskId(getStringFromJson(historicalData, HistoryJsonConstants.PARENT_TASK_ID));
            historicTaskInstance.setDescription(getStringFromJson(historicalData, HistoryJsonConstants.DESCRIPTION));
            historicTaskInstance.setOwner(getStringFromJson(historicalData, HistoryJsonConstants.OWNER));
            historicTaskInstance.setAssignee(getStringFromJson(historicalData, HistoryJsonConstants.ASSIGNEE));
            if (historicalData.has(HistoryJsonConstants.CREATE_TIME)) {
                historicTaskInstance.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.CREATE_TIME));
            } else {
                // For backwards compatibility. New async data uses the CREATE_TIME. This should be removed eventually
                historicTaskInstance.setCreateTime(getDateFromJson(historicalData, HistoryJsonConstants.START_TIME));
            }
            historicTaskInstance.setTaskDefinitionKey(getStringFromJson(historicalData, HistoryJsonConstants.TASK_DEFINITION_KEY));
            historicTaskInstance.setTaskDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.TASK_DEFINITION_ID));
            historicTaskInstance.setPriority(getIntegerFromJson(historicalData, HistoryJsonConstants.PRIORITY));
            historicTaskInstance.setDueDate(getDateFromJson(historicalData, HistoryJsonConstants.DUE_DATE));
            historicTaskInstance.setCategory(getStringFromJson(historicalData, HistoryJsonConstants.CATEGORY));
            historicTaskInstance.setFormKey(getStringFromJson(historicalData, HistoryJsonConstants.FORM_KEY));
            historicTaskInstance.setClaimTime(getDateFromJson(historicalData, HistoryJsonConstants.CLAIM_TIME));
            historicTaskInstance.setTenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));
            historicTaskInstance.setLastUpdateTime(getDateFromJson(historicalData, HistoryJsonConstants.TIMESTAMP));

            Date endTime = getDateFromJson(historicalData, HistoryJsonConstants.END_TIME);
            historicTaskInstance.setEndTime(endTime);
            historicTaskInstance.setDeleteReason(getStringFromJson(historicalData, HistoryJsonConstants.DELETE_REASON));

            Date startTime = historicTaskInstance.getStartTime();
            if (startTime !is null && endTime !is null) {
                historicTaskInstance.setDurationInMillis(endTime.getTime() - startTime.getTime());
            }

            historicTaskService.insertHistoricTask(historicTaskInstance, true);

            if (StringUtils.isNotEmpty(executionId)) {
                string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);
                if (StringUtils.isNotEmpty(activityId)) {
                    HistoricActivityInstanceEntity historicActivityInstanceEntity = findHistoricActivityInstance(commandContext, executionId, activityId);
                    if (historicActivityInstanceEntity !is null) {
                        historicActivityInstanceEntity.setTaskId(taskId);
                    }
                }
            }
        }
    }

}
