///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;
//
//import hunt.collections;
//import hunt.collection.List;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.history.async.HistoryJsonConstants;
//import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
//import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.job.service.impl.persistence.entity.HistoryJobEntity;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * @author martin.grofcik
// */
//class ActivityUpdateHistoryJsonTransformer : AbstractHistoryJsonTransformer {
//
//    override
//    public List!string getTypes() {
//        return Collections.singletonList(HistoryJsonConstants.TYPE_UPDATE_HISTORIC_ACTIVITY_INSTANCE);
//    }
//
//    override
//    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
//        string activityInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
//        if (StringUtils.isNotEmpty(activityInstanceId)) {
//            HistoricActivityInstanceEntity historicActivityInstance = CommandContextUtil.getHistoricActivityInstanceEntityManager(commandContext).findById(activityInstanceId);
//            if (historicActivityInstance is null) {
//                return false;
//            }
//        }
//        return true;
//
//    }
//
//    override
//    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
//        string activityInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.RUNTIME_ACTIVITY_INSTANCE_ID);
//        if (StringUtils.isNotEmpty(activityInstanceId)) {
//            HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager = CommandContextUtil.getProcessEngineConfiguration(commandContext)
//                .getHistoricActivityInstanceEntityManager();
//            HistoricActivityInstanceEntity historicActivityInstance = historicActivityInstanceEntityManager.findById(activityInstanceId);
//            if (historicActivityInstance !is null) {
//                string taskId = getStringFromJson(historicalData, HistoryJsonConstants.TASK_ID);
//                string assigneeId = getStringFromJson(historicalData, HistoryJsonConstants.ASSIGNEE);
//                string calledProcessInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.CALLED_PROCESS_INSTANCE_ID);
//                historicActivityInstance.setTaskId(taskId);
//                historicActivityInstance.setAssignee(assigneeId);
//                historicActivityInstance.setCalledProcessInstanceId(calledProcessInstanceId);
//            }
//
//        }
//
//    }
//
//}
