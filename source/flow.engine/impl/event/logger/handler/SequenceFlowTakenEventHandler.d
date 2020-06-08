/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.FlowableSequenceFlowTakenEvent;
import flow.engine.impl.persistence.entity.EventLogEntryEntity;

/**
 * @author Joram Barrez
 */
class SequenceFlowTakenEventHandler : AbstractDatabaseEventLoggerEventHandler {

    override
    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {
        FlowableSequenceFlowTakenEvent sequenceFlowTakenEvent = (FlowableSequenceFlowTakenEvent) event;

        Map!(string, Object) data = new HashMap<>();
        putInMapIfNotNull(data, Fields.ID, sequenceFlowTakenEvent.getId());

        putInMapIfNotNull(data, Fields.SOURCE_ACTIVITY_ID, sequenceFlowTakenEvent.getSourceActivityId());
        putInMapIfNotNull(data, Fields.SOURCE_ACTIVITY_NAME, sequenceFlowTakenEvent.getSourceActivityName());
        putInMapIfNotNull(data, Fields.SOURCE_ACTIVITY_TYPE, sequenceFlowTakenEvent.getSourceActivityType());
        putInMapIfNotNull(data, Fields.SOURCE_ACTIVITY_BEHAVIOR_CLASS, sequenceFlowTakenEvent.getSourceActivityBehaviorClass());

        putInMapIfNotNull(data, Fields.TARGET_ACTIVITY_ID, sequenceFlowTakenEvent.getTargetActivityId());
        putInMapIfNotNull(data, Fields.TARGET_ACTIVITY_NAME, sequenceFlowTakenEvent.getTargetActivityName());
        putInMapIfNotNull(data, Fields.TARGET_ACTIVITY_TYPE, sequenceFlowTakenEvent.getTargetActivityType());
        putInMapIfNotNull(data, Fields.TARGET_ACTIVITY_BEHAVIOR_CLASS, sequenceFlowTakenEvent.getTargetActivityBehaviorClass());

        return createEventLogEntry(sequenceFlowTakenEvent.getProcessDefinitionId(), sequenceFlowTakenEvent.getProcessInstanceId(),
                sequenceFlowTakenEvent.getExecutionId(), null, data);
    }

}
