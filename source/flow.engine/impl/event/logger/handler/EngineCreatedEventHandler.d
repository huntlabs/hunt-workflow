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
//import java.net.InetAddress;
//import java.net.UnknownHostException;
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//
///**
// * @author Joram Barrez
// */
//class EngineCreatedEventHandler : AbstractDatabaseEventLoggerEventHandler {
//
//    override
//    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {
//        Map!(string, Object) data = new HashMap<>();
//        try {
//            data.put("ip", InetAddress.getLocalHost().getHostAddress()); // Note
//                                                                         // that
//                                                                         // this
//                                                                         // might
//                                                                         // give
//                                                                         // the
//                                                                         // wrong
//                                                                         // ip
//                                                                         // address
//                                                                         // in
//                                                                         // case
//                                                                         // of
//                                                                         // multiple
//                                                                         // network
//                                                                         // interfaces
//                                                                         // -
//                                                                         // but
//                                                                         // it's
//                                                                         // better
//                                                                         // than
//                                                                         // nothing.
//        } catch (UnknownHostException e) {
//            // Best effort
//        }
//        return createEventLogEntry(data);
//    }
//
//}
