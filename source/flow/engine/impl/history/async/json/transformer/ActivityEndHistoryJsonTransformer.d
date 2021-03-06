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
//import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getDateFromJson;
//import static flow.job.service.impl.history.async.util.AsyncHistoryJsonUtil.getStringFromJson;
//
//import hunt.collections;
//import hunt.time.LocalDateTime;
//import hunt.collection.List;
//
//import flow.common.api.deleg.event.FlowableEngineEventType;
//import flow.common.interceptor.CommandContext;
//import flow.engine.deleg.event.impl.FlowableEventBuilder;
//import flow.engine.impl.history.async.HistoryJsonConstants;
//import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntity;
//import flow.job.service.impl.persistence.entity.HistoryJobEntity;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
//class ActivityEndHistoryJsonTransformer : AbstractNeedsUnfinishedHistoricActivityHistoryJsonTransformer {
//
//    override
//    public List!string getTypes() {
//        return Collections.singletonList(HistoryJsonConstants.TYPE_ACTIVITY_END);
//    }
//
//    override
//    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
//        string executionId = getStringFromJson(historicalData, HistoryJsonConstants.EXECUTION_ID);
//        string activityId = getStringFromJson(historicalData, HistoryJsonConstants.ACTIVITY_ID);
//        HistoricActivityInstanceEntity historicActivityInstanceEntity = findUnfinishedHistoricActivityInstance(commandContext, executionId, activityId);
//        if (historicActivityInstanceEntity !is null) {
//            Date endTime = getDateFromJson(historicalData, HistoryJsonConstants.END_TIME);
//            historicActivityInstanceEntity.setEndTime(endTime);
//            historicActivityInstanceEntity.setDeleteReason(getStringFromJson(historicalData, HistoryJsonConstants.DELETE_REASON));
//
//            Date startTime = historicActivityInstanceEntity.getStartTime();
//            if (startTime !is null && endTime !is null) {
//                historicActivityInstanceEntity.setDurationInMillis(endTime.getTime() - startTime.getTime());
//            }
//
//            dispatchEvent(commandContext, FlowableEventBuilder.createEntityEvent(
//                            FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_ENDED, historicActivityInstanceEntity));
//        }
//    }
//
//}
