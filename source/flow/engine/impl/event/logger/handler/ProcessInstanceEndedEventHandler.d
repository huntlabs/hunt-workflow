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
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//
///**
// * @author Joram Barrez
// */
//class ProcessInstanceEndedEventHandler : AbstractDatabaseEventLoggerEventHandler {
//
//    private static final string TYPE = "PROCESSINSTANCE_END";
//
//    override
//    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {
//        ExecutionEntity processInstanceEntity = getEntityFromEvent();
//
//        Map!(string, Object) data = new HashMap<>();
//        putInMapIfNotNull(data, Fields.ID, processInstanceEntity.getId());
//        putInMapIfNotNull(data, Fields.BUSINESS_KEY, processInstanceEntity.getBusinessKey());
//        putInMapIfNotNull(data, Fields.PROCESS_DEFINITION_ID, processInstanceEntity.getProcessDefinitionId());
//        putInMapIfNotNull(data, Fields.NAME, processInstanceEntity.getName());
//        putInMapIfNotNull(data, Fields.END_TIME, timeStamp);
//
//        return createEventLogEntry(TYPE, processInstanceEntity.getProcessDefinitionId(), processInstanceEntity.getId(), null, null, data);
//    }
//
//}
