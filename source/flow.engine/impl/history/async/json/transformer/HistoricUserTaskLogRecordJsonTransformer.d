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
import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import hunt.collections;
import hunt.collection.List;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.task.service.impl.BaseHistoricTaskLogEntryBuilderImpl;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author martin.grofcik
 */
class HistoricUserTaskLogRecordJsonTransformer : AbstractHistoryJsonTransformer {

    override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_HISTORIC_TASK_LOG_RECORD);
    }

    override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        BaseHistoricTaskLogEntryBuilderImpl taskLogEntryBuilder = new BaseHistoricTaskLogEntryBuilderImpl();

        taskLogEntryBuilder.data(getStringFromJson(historicalData, HistoryJsonConstants.LOG_ENTRY_DATA));
        taskLogEntryBuilder.processInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID));
        taskLogEntryBuilder.executionId(getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID));
        taskLogEntryBuilder.processDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_ID));
        taskLogEntryBuilder.taskId(getStringFromJson(historicalData, HistoryJsonConstants.TASK_ID));
        taskLogEntryBuilder.tenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));
        taskLogEntryBuilder.timeStamp(getDateFromJson(historicalData, HistoryJsonConstants.CREATE_TIME));
        taskLogEntryBuilder.type(getStringFromJson(historicalData, HistoryJsonConstants.LOG_ENTRY_TYPE));
        taskLogEntryBuilder.userId(getStringFromJson(historicalData, HistoryJsonConstants.USER_ID));
        taskLogEntryBuilder.scopeType(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_TYPE));
        taskLogEntryBuilder.scopeId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_ID));
        taskLogEntryBuilder.subScopeId(getStringFromJson(historicalData, HistoryJsonConstants.SUB_SCOPE_ID));
        taskLogEntryBuilder.scopeDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.SCOPE_DEFINITION_ID));

        CommandContextUtil.getHistoricTaskService().createHistoricTaskLogEntry(taskLogEntryBuilder);
    }
}
