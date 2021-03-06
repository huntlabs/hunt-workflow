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
module flow.engine.impl.util.CountingEntityUtil;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.eventsubscription.service.api.EventSubscription;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventUtil;

/**
 * @author Tijs Rademakers
 */
class CountingEntityUtil {

    public static void handleDeleteVariableInstanceEntityCount(VariableInstanceEntity variableInstance, bool fireDeleteEvent) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        if (variableInstance.getTaskId() !is null && variableInstance.getTaskId().length != 0 && isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = cast(CountingTaskEntity) CommandContextUtil.getTaskService().getTask(variableInstance.getTaskId());
            if (isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setVariableCount(countingTaskEntity.getVariableCount() - 1);
            }
        } else if (variableInstance.getExecutionId() !is null && variableInstance.getExecutionId().length != 0 && isExecutionRelatedEntityCountEnabledGlobally()) {
            CountingExecutionEntity executionEntity = cast(CountingExecutionEntity) CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableInstance.getExecutionId());
            if (isExecutionRelatedEntityCountEnabled(executionEntity)) {
                executionEntity.setVariableCount(executionEntity.getVariableCount() - 1);
            }
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
        if (fireDeleteEvent && eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)variableInstance));

            eventDispatcher.dispatchEvent(EventUtil.createVariableDeleteEvent(variableInstance));
        }
    }

    public static void handleInsertVariableInstanceEntityCount(VariableInstanceEntity variableInstance) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        if (variableInstance.getTaskId() !is null && variableInstance.getTaskId().length != 0 && isTaskRelatedEntityCountEnabledGlobally()) {
            CountingTaskEntity countingTaskEntity = cast(CountingTaskEntity) CommandContextUtil.getTaskService().getTask(variableInstance.getTaskId());
            if (isTaskRelatedEntityCountEnabled(countingTaskEntity)) {
                countingTaskEntity.setVariableCount(countingTaskEntity.getVariableCount() + 1);
            }
        } else if (variableInstance.getExecutionId() !is null && variableInstance.getExecutionId().length != 0 && isExecutionRelatedEntityCountEnabledGlobally()) {
            CountingExecutionEntity executionEntity = cast(CountingExecutionEntity) CommandContextUtil.getExecutionEntityManager(commandContext).findById(variableInstance.getExecutionId());
            if (isExecutionRelatedEntityCountEnabled(executionEntity)) {
                executionEntity.setVariableCount(executionEntity.getVariableCount() + 1);
            }
        }
    }

    public static void handleInsertEventSubscriptionEntityCount(EventSubscription eventSubscription) {
        if (eventSubscription.getExecutionId() !is null && eventSubscription.getExecutionId().length != 0 && CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            CountingExecutionEntity executionEntity = cast(CountingExecutionEntity) CommandContextUtil.getExecutionEntityManager().findById(
                            eventSubscription.getExecutionId());

            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(executionEntity)) {
                executionEntity.setEventSubscriptionCount(executionEntity.getEventSubscriptionCount() + 1);
            }
        }
    }

    public static void handleDeleteEventSubscriptionEntityCount(EventSubscription eventSubscription) {
        if (eventSubscription.getExecutionId() !is null && eventSubscription.getExecutionId().length != 0 && CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            CountingExecutionEntity executionEntity = cast(CountingExecutionEntity) CommandContextUtil.getExecutionEntityManager().findById(
                            eventSubscription.getExecutionId());

            if (CountingEntityUtil.isExecutionRelatedEntityCountEnabled(executionEntity)) {
                executionEntity.setEventSubscriptionCount(executionEntity.getEventSubscriptionCount() - 1);
            }
        }
    }

    /* Execution related entity count methods */

    public static bool isExecutionRelatedEntityCountEnabledGlobally() {
        return CommandContextUtil.getProcessEngineConfiguration().getPerformanceSettings().isEnableExecutionRelationshipCounts();
    }

    /**
     * Check if the Task Relationship Count performance improvement is enabled.
     */
    public static bool isTaskRelatedEntityCountEnabledGlobally() {
        return CommandContextUtil.getProcessEngineConfiguration().getPerformanceSettings().isEnableTaskRelationshipCounts();
    }

    public static bool isExecutionRelatedEntityCountEnabled(ExecutionEntity executionEntity) {
        if (executionEntity.isProcessInstanceType() || cast(CountingExecutionEntity)executionEntity !is null) {
            return isExecutionRelatedEntityCountEnabled(cast(CountingExecutionEntity) executionEntity);
        }
        return false;
    }

    public static bool isTaskRelatedEntityCountEnabled(TaskEntity taskEntity) {
        if (cast(CountingTaskEntity)taskEntity !is null) {
            return isTaskRelatedEntityCountEnabled(cast(CountingTaskEntity) taskEntity);
        }
        return false;
    }

    /**
     * There are two flags here: a global flag and a flag on the execution entity.
     * The global flag can be switched on and off between different reboots, however the flag on the executionEntity refers
     * to the state at that particular moment of the last insert/update.
     *
     * Global flag / ExecutionEntity flag : result
     *
     * T / T : T (all true, regular mode with flags enabled)
     * T / F : F (global is true, but execution was of a time when it was disabled, thus treating it as disabled as the counts can't be guessed)
     * F / T : F (execution was of time when counting was done. But this is overruled by the global flag and thus the queries will o
     * be done)
     * F / F : F (all disabled)
     *
     * From this table it is clear that only when both are true, the result should be true, which is the regular AND rule for booleans.
     */
    public static bool isExecutionRelatedEntityCountEnabled(CountingExecutionEntity executionEntity) {
        return !executionEntity.isProcessInstanceType() && isExecutionRelatedEntityCountEnabledGlobally() && executionEntity.isCountEnabled();
    }

    /**
     * Similar functionality with <b>ExecutionRelatedEntityCount</b>, but on the TaskEntity level.
     */
    public static bool isTaskRelatedEntityCountEnabled(CountingTaskEntity taskEntity) {
        return isTaskRelatedEntityCountEnabledGlobally() && taskEntity.isCountEnabled();
    }

}
