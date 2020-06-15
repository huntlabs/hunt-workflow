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
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.event.logger.handler.EventLoggerEventHandler;
//
///**
// * @author Joram Barrez
// */
//abstract class AbstractEventFlusher implements EventFlusher {
//
//    protected List!EventLoggerEventHandler eventHandlers = new ArrayList<>();
//
//    override
//    public void closed(CommandContext commandContext) {
//        // Not interested in closed
//    }
//
//    override
//    public List!EventLoggerEventHandler getEventHandlers() {
//        return eventHandlers;
//    }
//
//    override
//    public void setEventHandlers(List!EventLoggerEventHandler eventHandlers) {
//        this.eventHandlers = eventHandlers;
//    }
//
//    override
//    public void addEventHandler(EventLoggerEventHandler databaseEventLoggerEventHandler) {
//        eventHandlers.add(databaseEventLoggerEventHandler);
//    }
//
//}
