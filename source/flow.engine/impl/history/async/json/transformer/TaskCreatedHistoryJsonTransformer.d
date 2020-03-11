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


import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getDateFromJson;
import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getIntegerFromJson;
import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;
import org.flowable.task.service.HistoricTaskService;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class TaskCreatedHistoryJsonTransformer extends AbstractHistoryJsonTransformer {

    @Override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_TASK_CREATED);
    }

    @Override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();

        string taskId = getStringFromJson(historicalData, HistoryJsonConstants.ID);
        string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);

        HistoricTaskInstanceEntity historicTaskInstance = historicTaskService.getHistoricTask(taskId);

        if (historicTaskInstance is null) {
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
            historicTaskInstance.setTenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));
            historicTaskInstance.setLastUpdateTime(getDateFromJson(historicalData, HistoryJsonConstants.TIMESTAMP));

            historicTaskService.insertHistoricTask(historicTaskInstance, true);
        }

        // there can be still job in the queue which can have activityId in and we should be able to handle it
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
