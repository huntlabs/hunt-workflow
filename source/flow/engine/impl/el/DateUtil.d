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
//module flow.engine.impl.el.DynamicUserTaskBuilder;
//
//import hunt.time.LocalDateTime;
//
//import flow.engine.impl.util.CommandContextUtil;
//import org.joda.time.DateTime;
//import org.joda.time.DateTimeZone;
//import org.joda.time.format.DateTimeFormatter;
//import org.joda.time.format.ISODateTimeFormat;
//
//class DateUtil {
//
//    public static string format(Object value) {
//        string formattedString = null;
//        if (value instanceof Date) {
//            Date date = (Date) value;
//            DateTimeFormatter fmt = ISODateTimeFormat.dateTime();
//            DateTimeZone dateTimeZone = DateTimeZone.forTimeZone(CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTimeZone());
//            formattedString = fmt.print(new DateTime(date, dateTimeZone));
//        } else {
//            formattedString = value.toString();
//        }
//
//        return formattedString;
//    }
//}
