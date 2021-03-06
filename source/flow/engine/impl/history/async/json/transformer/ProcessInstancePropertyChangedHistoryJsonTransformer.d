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
//import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.job.service.impl.persistence.entity.HistoryJobEntity;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
//class ProcessInstancePropertyChangedHistoryJsonTransformer : AbstractNeedsProcessInstanceHistoryJsonTransformer {
//
//    public static final string PROPERTY_NAME = "name";
//    public static final string PROPERTY_BUSINESS_KEY = "businessKey";
//
//    override
//    public List!string getTypes() {
//        return Collections.singletonList(HistoryJsonConstants.TYPE_PROCESS_INSTANCE_PROPERTY_CHANGED);
//    }
//
//    override
//    public void transformJson(HistoryJobEntity job, ObjectNode historicalData, CommandContext commandContext) {
//        string processInstanceId = getStringFromJson(historicalData, HistoryJsonConstants.PROCESS_INSTANCE_ID);
//        string property = getStringFromJson(historicalData, HistoryJsonConstants.PROPERTY);
//        if (StringUtils.isNotEmpty(processInstanceId) && StringUtils.isNotEmpty(property)) {
//            HistoricProcessInstanceEntity historicProcessInstance = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findById(processInstanceId);
//
//            if (PROPERTY_NAME.equals(property)) {
//                historicProcessInstance.setName(getStringFromJson(historicalData, HistoryJsonConstants.NAME));
//
//            } else if (PROPERTY_BUSINESS_KEY.equals(property)) {
//                historicProcessInstance.setBusinessKey(getStringFromJson(historicalData, HistoryJsonConstants.BUSINESS_KEY));
//            }
//        }
//    }
//
//}
