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
//import hunt.collection.Map;
//
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//import flow.variable.service.api.event.FlowableVariableEvent;
//
///**
// * @author Joram Barrez
// */
//class VariableDeletedEventHandler : VariableEventHandler {
//
//    override
//    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {
//        FlowableVariableEvent variableEvent = (FlowableVariableEvent) event;
//        Map!(string, Object) data = createData(variableEvent);
//
//        data.put(Fields.END_TIME, timeStamp);
//
//        return createEventLogEntry(variableEvent.getProcessDefinitionId(), variableEvent.getProcessInstanceId(), variableEvent.getExecutionId(), variableEvent.getTaskId(), data);
//    }
//
//}
