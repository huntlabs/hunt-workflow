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
//import hunt.time.LocalDateTime;
//
//import flow.common.api.deleg.event.FlowableEvent;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//
///**
// * @author Joram Barrez
// */
//interface EventLoggerEventHandler {
//
//    EventLogEntryEntity generateEventLogEntry(CommandContext commandContext);
//
//    void setEvent(FlowableEvent event);
//
//    void setTimeStamp(Date timeStamp);
//
//    void setObjectMapper(ObjectMapper objectMapper);
//
//}
