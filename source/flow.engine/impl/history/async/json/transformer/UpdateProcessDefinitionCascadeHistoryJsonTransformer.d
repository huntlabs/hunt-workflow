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


import static org.flowable.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;

import java.util.Collections;
import java.util.List;

import flow.common.interceptor.CommandContext;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import flow.engine.impl.history.async.HistoryJsonConstants;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;
import org.flowable.task.api.history.HistoricTaskInstance;
import org.flowable.task.service.HistoricTaskService;
import org.flowable.task.service.impl.HistoricTaskInstanceQueryImpl;
import org.flowable.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;

import com.fasterxml.jackson.databind.node.ObjectNode;

class UpdateProcessDefinitionCascadeHistoryJsonTransformer extends AbstractNeedsProcessInstanceHistoryJsonTransformer {

    @Override
    public List<string> getTypes() {
        return Collections.singletonList(HistoryJsonConstants.TYPE_UPDATE_PROCESS_DEFINITION_CASCADE);
    }
    
    @Override
    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
        string processDefinitionId = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_DEFINITION_ID);
        string processInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID);
        
        HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext);
        HistoricProcessInstanceEntity historicProcessInstance = (HistoricProcessInstanceEntity) historicProcessInstanceEntityManager.findById(processInstanceId);
        historicProcessInstance.setProcessDefinitionId(processDefinitionId);
        historicProcessInstanceEntityManager.update(historicProcessInstance);

        HistoricTaskService historicTaskService = CommandContextUtil.getHistoricTaskService();
        HistoricTaskInstanceQueryImpl taskQuery = new HistoricTaskInstanceQueryImpl();
        taskQuery.processInstanceId(processInstanceId);
        List<HistoricTaskInstance> historicTasks = historicTaskService.findHistoricTaskInstancesByQueryCriteria(taskQuery);
        if (historicTasks != null) {
            for (HistoricTaskInstance historicTaskInstance : historicTasks) {
                HistoricTaskInstanceEntity taskEntity = (HistoricTaskInstanceEntity) historicTaskInstance;
                taskEntity.setProcessDefinitionId(processDefinitionId);
                historicTaskService.updateHistoricTask(taskEntity, true);
            }
        }
        
        HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext);
        HistoricActivityInstanceQueryImpl activityQuery = new HistoricActivityInstanceQueryImpl();
        activityQuery.processInstanceId(processInstanceId);
        List<HistoricActivityInstance> historicActivities = historicActivityInstanceEntityManager.findHistoricActivityInstancesByQueryCriteria(activityQuery);
        if (historicActivities != null) {
            for (HistoricActivityInstance historicActivityInstance : historicActivities) {
                HistoricActivityInstanceEntity activityEntity = (HistoricActivityInstanceEntity) historicActivityInstance;
                activityEntity.setProcessDefinitionId(processDefinitionId);
                historicActivityInstanceEntityManager.update(activityEntity);
            }
        }
    }

}
