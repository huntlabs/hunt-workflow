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
module flow.variable.service.event.impl.FlowableVariableEventBuilder;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.event.FlowableEntityEventImpl;
import flow.variable.service.api.event.FlowableVariableEvent;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.event.impl.FlowableVariableEventImpl;
/**
 * Builder class used to create {@link FlowableEvent} implementations.
 *
 * @author Frederik Heremans
 */
class FlowableVariableEventBuilder {

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @return an {@link FlowableEntityEvent}. In case an ExecutionContext is active, the execution related event fields will be populated. If not, execution details will be retrieved from the
     *         {@link Object} if possible.
     */
    public static FlowableEntityEvent createEntityEvent(FlowableEngineEventType type, Object entity) {
        FlowableEntityEventImpl newEvent = new FlowableEntityEventImpl(entity, type);

        return newEvent;
    }

    public static FlowableVariableEvent createVariableEvent(FlowableEngineEventType type, string variableName, Object variableValue, VariableType variableType, string taskId, string executionId,
            string processInstanceId, string processDefinitionId, string scopeId, string scopeType) {

        FlowableVariableEventImpl newEvent = new FlowableVariableEventImpl(type);
        newEvent.setVariableName(variableName);
        newEvent.setVariableValue(variableValue);
        newEvent.setVariableType(variableType);
        newEvent.setTaskId(taskId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setScopeId(scopeId);
        newEvent.setScopeType(scopeType);
        return newEvent;
    }
}
