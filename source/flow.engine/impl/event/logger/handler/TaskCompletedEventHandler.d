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

import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.FlowableEntityWithVariablesEvent;
import flow.engine.impl.persistence.entity.EventLogEntryEntity;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class TaskCompletedEventHandler extends AbstractTaskEventHandler {

    @Override
    public EventLogEntryEntity generateEventLogEntry(CommandContext commandContext) {

        FlowableEntityEvent entityEvent = (FlowableEntityEvent) event;

        TaskEntity task = (TaskEntity) entityEvent.getEntity();
        Map!(string, Object) data = handleCommonTaskFields(task);

        long duration = timeStamp.getTime() - task.getCreateTime().getTime();
        putInMapIfNotNull(data, Fields.DURATION, duration);

        if (event instanceof FlowableEntityWithVariablesEvent) {
            FlowableEntityWithVariablesEvent activitiEntityWithVariablesEvent = (FlowableEntityWithVariablesEvent) event;
            if (activitiEntityWithVariablesEvent.getVariables() !is null && !activitiEntityWithVariablesEvent.getVariables().isEmpty()) {
                Map!(string, Object) variableMap = new HashMap<>();
                for (Object variableName : activitiEntityWithVariablesEvent.getVariables().keySet()) {
                    putInMapIfNotNull(variableMap, (string) variableName, activitiEntityWithVariablesEvent.getVariables().get(variableName));
                }
                if (activitiEntityWithVariablesEvent.isLocalScope()) {
                    putInMapIfNotNull(data, Fields.LOCAL_VARIABLES, variableMap);
                } else {
                    putInMapIfNotNull(data, Fields.VARIABLES, variableMap);
                }
            }

        }

        return createEventLogEntry(task.getProcessDefinitionId(), task.getProcessInstanceId(), task.getExecutionId(), task.getId(), data);
    }

}
