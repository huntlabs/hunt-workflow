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
//import java.nio.charset.StandardCharsets;
//import java.util.Base64;
//import hunt.time.LocalDateTime;
//import hunt.collection.Map;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.job.service.impl.history.async.AsyncHistoryDateUtil;
//import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * @author Joram Barrez
// */
//class AsyncHistoryJsonUtil {
//
//    public static void putIfNotNull(Map!(string, string) map, string key, string value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//    public static void putIfNotNull(ObjectNode map, string key, string value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//    public static void putIfNotNull(Map!(string, string) map, string key, int value) {
//        map.put(key, Integer.toString(value));
//    }
//    public static void putIfNotNull(ObjectNode map, string key, int value) {
//        map.put(key, value);
//    }
//
//    public static void putIfNotNull(Map!(string, string) map, string key, Double value) {
//        if (value !is null) {
//            map.put(key, Double.toString(value));
//        }
//    }
//
//    public static void putIfNotNull(ObjectNode map, string key, Double value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//    public static void putIfNotNull(Map!(string, string) map, string key, Long value) {
//        if (value !is null) {
//            map.put(key, Long.toString(value));
//        }
//    }
//
//    public static void putIfNotNull(ObjectNode map, string key, Long value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//    public static void putIfNotNull(Map!(string, string) map, string key, Date value) {
//        if (value !is null) {
//            map.put(key, AsyncHistoryDateUtil.formatDate(value));
//        }
//    }
//
//    public static void putIfNotNull(ObjectNode map, string key, Date value) {
//        if (value !is null) {
//            map.put(key, AsyncHistoryDateUtil.formatDate(value));
//        }
//    }
//
//    public static void putIfNotNull(Map!(string, string) map, string key, bool value) {
//        if (value !is null) {
//            map.put(key, bool.toString(value));
//        }
//    }
//
//    public static void putIfNotNull(ObjectNode map, string key, bool value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//    public static string convertToBase64(VariableInstanceEntity variable) {
//        byte[] bytes = variable.getBytes();
//        if (bytes !is null) {
//            return new string(Base64.getEncoder().encode(variable.getBytes()), StandardCharsets.US_ASCII);
//        } else {
//            return null;
//        }
//    }
//
//    public static string getStringFromJson(ObjectNode objectNode, string fieldName) {
//        if (objectNode.has(fieldName)) {
//            return objectNode.get(fieldName).asText();
//        }
//        return null;
//    }
//
//    public static Date getDateFromJson(ObjectNode objectNode, string fieldName) {
//        string s = getStringFromJson(objectNode, fieldName);
//        return AsyncHistoryDateUtil.parseDate(s);
//    }
//
//    public static Integer getIntegerFromJson(ObjectNode objectNode, string fieldName) {
//        string s = getStringFromJson(objectNode, fieldName);
//        if (StringUtils.isNotEmpty(s)) {
//            return Integer.valueOf(s);
//        }
//        return null;
//    }
//
//    public static Double getDoubleFromJson(ObjectNode objectNode, string fieldName) {
//        string s = getStringFromJson(objectNode, fieldName);
//        if (StringUtils.isNotEmpty(s)) {
//            return Double.valueOf(s);
//        }
//        return null;
//    }
//
//    public static Long getLongFromJson(ObjectNode objectNode, string fieldName) {
//        string s = getStringFromJson(objectNode, fieldName);
//        if (StringUtils.isNotEmpty(s)) {
//            return Long.valueOf(s);
//        }
//        return null;
//    }
//
//    public static bool getBooleanFromJson(ObjectNode objectNode, string fieldName, bool defaultValue) {
//        bool value = getBooleanFromJson(objectNode, fieldName);
//        return value !is null ? value : defaultValue;
//    }
//
//    public static bool getBooleanFromJson(ObjectNode objectNode, string fieldName) {
//        string s = getStringFromJson(objectNode, fieldName);
//        if (StringUtils.isNotEmpty(s)) {
//            return bool.valueOf(s);
//        }
//        return null;
//    }
//
//}
