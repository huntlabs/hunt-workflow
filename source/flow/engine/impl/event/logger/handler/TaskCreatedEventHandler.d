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
//import flow.common.api.deleg.event.FlowableEntityEvent;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//import flow.task.service.impl.persistence.entity.TaskEntity;
//
///**
// * @author Joram Barrez
// */
//class TaskCreatedEventHandler : AbstractTaskEventHandler {
//
//    override
//    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {
//        TaskEntity task = (TaskEntity) ((FlowableEntityEvent) event).getEntity();
//        Map!(string, Object) data = handleCommonTaskFields(task);
//        return createEventLogEntry(task.getProcessDefinitionId(), task.getProcessInstanceId(), task.getExecutionId(), task.getId(), data);
//    }
//
//}
