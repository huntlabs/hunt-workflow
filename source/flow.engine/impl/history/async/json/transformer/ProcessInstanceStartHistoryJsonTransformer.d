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
import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import java.util.Collections;
import java.util.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class ProcessInstanceStartHistoryJsonTransformer extends AbstractHistoryJsonTransformer {

    @Override
    public List<string> getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_PROCESS_INSTANCE_START);
    }

    @Override
    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
        return true;
    }

    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext);

        string id = getStringFromJson(historicalData, "id");
        HistoricProcessInstanceEntity historicProcessInstance = historicProcessInstanceEntityManager.findById(id);
        if (historicProcessInstance is null) {
            historicProcessInstance = historicProcessInstanceEntityManager.create();
            historicProcessInstance.setId(getStringFromJson(historicalData, HistoryJsonConstants.ID));
            historicProcessInstance.setProcessInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID));
            historicProcessInstance.setName(getStringFromJson(historicalData, HistoryJsonConstants.NAME));
            historicProcessInstance.setBusinessKey(getStringFromJson(historicalData, HistoryJsonConstants.BUSINESS_KEY));
            historicProcessInstance.setProcessDefinitionId(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_ID));
            historicProcessInstance.setProcessDefinitionKey(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_KEY));
            historicProcessInstance.setProcessDefinitionName(getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_NAME));
            string versionString = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_VERSION);
            historicProcessInstance.setProcessDefinitionVersion(versionString !is null ? Integer.valueOf(versionString) : 0);
            historicProcessInstance.setDeploymentId(getStringFromJson(historicalData, HistoryJsonConstants.DEPLOYMENT_ID));
            historicProcessInstance.setStartTime(getDateFromJson(historicalData, HistoryJsonConstants.START_TIME));
            historicProcessInstance.setStartUserId(getStringFromJson(historicalData, HistoryJsonConstants.START_USER_ID));
            historicProcessInstance.setStartActivityId(getStringFromJson(historicalData, HistoryJsonConstants.START_ACTIVITY_ID));
            historicProcessInstance.setSuperProcessInstanceId(getStringFromJson(historicalData, HistoryJsonConstants.SUPER_PROCESS_INSTANCE_ID));
            historicProcessInstance.setCallbackId(getStringFromJson(historicalData, HistoryJsonConstants.CALLBACK_ID));
            historicProcessInstance.setCallbackType(getStringFromJson(historicalData, HistoryJsonConstants.CALLBACK_TYPE));
            historicProcessInstance.setReferenceId(getStringFromJson(historicalData, HistoryJsonConstants.REFERENCE_ID));
            historicProcessInstance.setReferenceType(getStringFromJson(historicalData, HistoryJsonConstants.REFERENCE_TYPE));
            historicProcessInstance.setTenantId(getStringFromJson(historicalData, HistoryJsonConstants.TENANT_ID));
    
            historicProcessInstanceEntityManager.insert(historicProcessInstance, false);
    
            dispatchEvent(commandContext, FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_CREATED, historicProcessInstance));
            
        } else {
            historicProcessInstance.setStartActivityId(getStringFromJson(historicalData, HistoryJsonConstants.START_ACTIVITY_ID));
            historicProcessInstanceEntityManager.update(historicProcessInstance, false);
        }
    }

}
