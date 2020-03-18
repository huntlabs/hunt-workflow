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
//import java.time.Instant;
//import java.time.LocalDateTime;
//import java.time.ZoneOffset;
//
//import flow.variable.service.api.types.ValueFields;
//import flow.variable.service.api.types.VariableType;
//
///**
// * @author Filip Hrisafov
// */
//class LocalDateTimeType implements VariableType {
//
//    public static final String TYPE_NAME = "localdatetime";
//
//    @Override
//    public String getTypeName() {
//        return TYPE_NAME;
//    }
//
//    @Override
//    public boolean isCachable() {
//        return true;
//    }
//
//    @Override
//    public boolean isAbleToStore(Object value) {
//        if (value is null) {
//            return true;
//        }
//        return LocalDateTime.class.isAssignableFrom(value.getClass());
//    }
//
//    @Override
//    public Object getValue(ValueFields valueFields) {
//        Long longValue = valueFields.getLongValue();
//        if (longValue !is null) {
//            return LocalDateTime.ofInstant(Instant.ofEpochMilli(longValue), ZoneOffset.UTC);
//        }
//        return null;
//    }
//
//    @Override
//    public void setValue(Object value, ValueFields valueFields) {
//        if (value !is null) {
//            valueFields.setLongValue(((LocalDateTime) value).toInstant(ZoneOffset.UTC).toEpochMilli());
//        } else {
//            valueFields.setLongValue(null);
//        }
//    }
//}
