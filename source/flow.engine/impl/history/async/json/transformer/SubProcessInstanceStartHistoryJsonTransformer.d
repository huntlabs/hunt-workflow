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

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class SubProcessInstanceStartHistoryJsonTransformer : AbstractHistoryJsonTransformer {

    override
    public List!string getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_SUBPROCESS_INSTANCE_START);
    }

    override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);
        HistoricActivityInstance activityInstance = findHistoricActivityInstance(commandContext,
                getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID), activityId);

        if (activityInstance is null) {
            return false;
        }

        return true;
    }

    override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext);

        string id = getStringFromJson(historicalData, HistoryJsonConstants.ID);
        string processInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID);
        HistoricProcessInstanceEntity historicProcessInstance = historicProcessInstanceEntityManager.findById(id);
        if (historicProcessInstance is null) {
            HistoricProcessInstanceEntity subProcessInstance = historicProcessInstanceEntityManager.create();

            subProcessInstance.setId(id);
            subProcessInstance.setProcessInstanceId(processInstanceId);
            subProcessInstance.setBusinessKey(getStringFromJson(historicalData, HistoryJsonConstants.BUSINESS_KEY));
            subProcessInstance.setProcessDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_ID));
            subProcessInstance.setProcessDefinitionKey(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_KEY));
            subProcessInstance.setProcessDefinitionName(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_NAME));
            string versionString = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_VERSION);
            subProcessInstance.setProcessDefinitionVersion(versionString !is null ? Integer.valueOf(versionString) : 0);
            subProcessInstance.setDeploymentId(getStringFromJson(historicalData, HistoryJsonConstants.DEPLOYMENT_ID));
            subProcessInstance.setStartTime(getDateFromJson(historicalData, HistoryJsonConstants.START_TIME));
            subProcessInstance.setStartUserId(getStringFromJson(historicalData, HistoryJsonConstants.START_USER_ID));
            subProcessInstance.setStartActivityId(getStringFromJson(historicalData, HistoryJsonConstants.START_ACTIVITY_ID));
            subProcessInstance.setSuperProcessInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.SUPER_PROCESS_INSTANCE_ID));
            subProcessInstance.setCallbackId(getStringFromJson(historicalData, HistoryJsonConstants.CALLBACK_ID));
            subProcessInstance.setCallbackType(getStringFromJson(historicalData, HistoryJsonConstants.CALLBACK_TYPE));
            subProcessInstance.setReferenceId(getStringFromJson(historicalData, HistoryJsonConstants.REFERENCE_ID));
            subProcessInstance.setReferenceType(getStringFromJson(historicalData, HistoryJsonConstants.REFERENCE_TYPE));
            subProcessInstance.setTenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));

            historicProcessInstanceEntityManager.insert(subProcessInstance, false);

            // Fire event
            dispatchEvent(commandContext, FlowableEventBuilder.createEntityEvent(
                    FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_CREATED, subProcessInstance));
        }

        string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
        string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);

        HistoricActivityInstanceEntity activityInstance = findHistoricActivityInstance(commandContext, executionId, activityId);
        if (activityInstance !is null) {
            activityInstance.setCalledProcessInstanceId(processInstanceId);
        }
    }

}
