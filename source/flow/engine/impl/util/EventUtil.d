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
module flow.engine.impl.util.EventUtil;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.variable.service.api.event.FlowableVariableEvent;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
/**
 * @author Joram Barrez
 */
class EventUtil {

    public static FlowableVariableEvent createVariableDeleteEvent(VariableInstanceEntity variableInstance) {

        string processDefinitionId = null;
        if (variableInstance.getProcessInstanceId() !is null) {
            ExecutionEntity executionEntity = CommandContextUtil.getExecutionEntityManager().findById(variableInstance.getProcessInstanceId());
            if (executionEntity !is null) {
                processDefinitionId = executionEntity.getProcessDefinitionId();
            }
        }

        return FlowableEventBuilder.createVariableEvent(FlowableEngineEventType.VARIABLE_DELETED,
                variableInstance.getName(),
                null,
                variableInstance.getType(),
                variableInstance.getTaskId(),
                variableInstance.getExecutionId(),
                variableInstance.getProcessInstanceId(),
                processDefinitionId);
    }

}
