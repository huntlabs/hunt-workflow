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
//module flow.variable.service.impl.util.VariableLoggingSessionUtil;
//
//import hunt.time.LocalDateTime;
//import java.util.UUID;
//
//import flow.common.api.scop.ScopeTypes;
////import flow.common.logging.LoggingSessionUtil;
//import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
//import flow.variable.service.impl.types.BooleanType;
//import flow.variable.service.impl.types.DateType;
//import flow.variable.service.impl.types.DoubleType;
//import flow.variable.service.impl.types.IntegerType;
////import flow.variable.service.impl.types.JodaDateTimeType;
////import flow.variable.service.impl.types.JodaDateType;
////import flow.variable.service.impl.types.JsonType;
//import flow.variable.service.impl.types.LongType;
//import flow.variable.service.impl.types.NullType;
//import flow.variable.service.impl.types.ShortType;
//import flow.variable.service.impl.types.StringType;
//import flow.variable.service.impl.types.UUIDType;
////import org.joda.time.DateTime;
////import org.joda.time.LocalDate;
////
////import com.fasterxml.jackson.databind.JsonNode;
////import com.fasterxml.jackson.databind.node.ObjectNode;
//
//class VariableLoggingSessionUtil {
//
//    public static ObjectNode addLoggingData(String message, VariableInstanceEntity variableInstance) {
//        ObjectNode loggingNode = null;
//        if (variableInstance.getScopeId() !is null && ScopeTypes.CMMN.equals(variableInstance.getScopeType())) {
//            String subScopeId = null;
//            if (!variableInstance.getScopeId().equals(variableInstance.getSubScopeId())) {
//                subScopeId = variableInstance.getSubScopeId();
//            }
//
//            loggingNode = LoggingSessionUtil.fillLoggingData(message, variableInstance.getScopeId(), subScopeId, ScopeTypes.CMMN);
//
//        } else if (variableInstance.getProcessInstanceId() !is null) {
//            String subScopeId = null;
//            if (!variableInstance.getProcessInstanceId().equals(variableInstance.getExecutionId())) {
//                subScopeId = variableInstance.getExecutionId();
//            }
//
//            loggingNode = LoggingSessionUtil.fillLoggingData(message, variableInstance.getProcessInstanceId(), subScopeId, ScopeTypes.BPMN);
//        }
//
//        if (loggingNode !is null) {
//            loggingNode.put("variableName", variableInstance.getName());
//            String variableTypeName = variableInstance.getType().getTypeName();
//            loggingNode.put("variableType", variableTypeName);
//
//            if (variableInstance.getValue() is null) {
//                loggingNode.putNull("variableRawValue");
//                loggingNode.putNull("variableValue");
//
//            } else {
//                addVariableValue(variableInstance.getValue(), variableTypeName, "variableRawValue", "variableValue", loggingNode);
//            }
//        }
//
//        return loggingNode;
//    }
//
//    public static void addVariableValue(Object variableValue, String variableTypeName, String variableRawValueName, String variableValueName, ObjectNode loggingNode) {
//        if (LongType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (Long) variableValue);
//        } else if (IntegerType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (Integer) variableValue);
//        } else if (DoubleType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (Double) variableValue);
//        } else if (ShortType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (Short) variableValue);
//        } else if (DateType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, LoggingSessionUtil.formatDate((Date) variableValue));
//        } else if (JodaDateTimeType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, LoggingSessionUtil.formatDate((DateTime) variableValue));
//        } else if (JodaDateType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, LoggingSessionUtil.formatDate((LocalDate) variableValue));
//        } else if (BooleanType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (Boolean) variableValue);
//        } else if (JsonType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.set(variableRawValueName, (JsonNode) variableValue);
//        } else if (UUIDType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put("variableRawValue", ((UUID) variableValue).toString());
//        } else if (NullType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.putNull(variableRawValueName);
//        } else if (StringType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableRawValueName, (String) variableValue);
//        } else {
//            return;
//        }
//
//        if (DateType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableValueName, LoggingSessionUtil.formatDate((Date) variableValue));
//        } else if (JodaDateTimeType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableValueName, LoggingSessionUtil.formatDate((DateTime) variableValue));
//        } else if (JodaDateType.TYPE_NAME.equals(variableTypeName)) {
//            loggingNode.put(variableValueName, LoggingSessionUtil.formatDate((LocalDate) variableValue));
//        } else {
//            loggingNode.put(variableValueName, variableValue.toString());
//        }
//    }
//}
