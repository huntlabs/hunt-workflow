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
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.history.async.HistoryJsonConstants;
//import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.job.service.impl.persistence.entity.HistoryJobEntity;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
//class ProcessInstanceDeleteHistoryJsonTransformer : AbstractProcessInstanceDeleteHistoryTransformer {
//
//    override
//    public List!string getTypes() {
//        return Collections.singletonList(HistoryJsonConstants.TYPE_PROCESS_INSTANCE_DELETED);
//    }
//
//    override
//    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
//        string id = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID);
//        HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext);
//        return historicProcessInstanceEntityManager.findById(id) !is null;
//    }
//
//    override
//    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
//        string processInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID);
//        deleteProcessInstance(processInstanceId, commandContext);
//    }
//}
