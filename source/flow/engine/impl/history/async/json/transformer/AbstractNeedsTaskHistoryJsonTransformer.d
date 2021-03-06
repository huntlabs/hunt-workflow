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
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.history.async.HistoryJsonConstants;
//import flow.engine.impl.util.CommandContextUtil;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
//abstract class AbstractNeedsTaskHistoryJsonTransformer : AbstractHistoryJsonTransformer {
//
//    override
//    public bool isApplicable(ObjectNode historicalData, CommandContext commandContext) {
//        string taskId = getStringFromJson(historicalData, HistoryJsonConstants.ID);
//        return CommandContextUtil.getHistoricTaskService().getHistoricTask(taskId) !is null;
//    }
//
//}
