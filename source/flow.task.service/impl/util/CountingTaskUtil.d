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
module flow.task.service.impl.util.CountingTaskUtil;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.event.impl.FlowableVariableEventBuilder;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.task.service.impl.util.CommandContextUtil;
/**
 * @author Tijs Rademakers
 */
class CountingTaskUtil {

    public static void handleDeleteVariableInstanceEntityCount(VariableInstanceEntity variableInstance, bool fireDeleteEvent) {
        if (variableInstance.getTaskId() !is null && isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = cast(CountingTaskEntity) CommandContextUtil.getTaskEntityManager().findById(variableInstance.getTaskId());
            if (isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setVariableCount(countingTaskEntity.getVariableCount() - 1);
            }
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getTaskServiceConfiguration().getEventDispatcher();
        if (fireDeleteEvent && eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableVariableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, variableInstance));

            eventDispatcher.dispatchEvent(FlowableVariableEventBuilder.createVariableEvent(FlowableEngineEventType.VARIABLE_DELETED,
                            variableInstance.getName(), null, variableInstance.getType(), variableInstance.getTaskId(),
                            variableInstance.getExecutionId(), variableInstance.getProcessInstanceId(), variableInstance.getProcessDefinitionId(),
                            variableInstance.getScopeId(), variableInstance.getScopeType()));
        }
    }

    public static void handleInsertVariableInstanceEntityCount(VariableInstanceEntity variableInstance) {
        if (variableInstance.getTaskId() !is null && isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = cast(CountingTaskEntity) CommandContextUtil.getTaskEntityManager().findById(variableInstance.getTaskId());
            if (isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setVariableCount(countingTaskEntity.getVariableCount() + 1);
            }
        }
    }

    /**
     * Check if the Task Relationship Count performance improvement is enabled.
     */
    public static bool isTaskRelatedEntityCountEnabledGlobally() {
        if (CommandContextUtil.getTaskServiceConfiguration() is null) {
            return false;
        }

        return CommandContextUtil.getTaskServiceConfiguration().isEnableTaskRelationshipCounts();
    }

    public static bool isTaskRelatedEntityCountEnabled(TaskEntity taskEntity) {
        CountingTaskEntity c =  cast(CountingTaskEntity) taskEntity;
        if (c !is null) {
            return isTaskRelatedEntityCountEnabled(c);
        }
        return false;
    }

    /**
     * Similar functionality with <b>ExecutionRelatedEntityCount</b>, but on the TaskEntity level.
     */
    public static bool isTaskRelatedEntityCountEnabled(CountingTaskEntity taskEntity) {
        return isTaskRelatedEntityCountEnabledGlobally() && taskEntity.isCountEnabled();
    }
}
