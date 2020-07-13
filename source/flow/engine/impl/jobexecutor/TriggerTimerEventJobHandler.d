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
module flow.engine.impl.jobexecutor.TriggerTimerEventJobHandler;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.JobHandler;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 * @author Joram Barrez
 */
class TriggerTimerEventJobHandler : JobHandler {

    public static  string TYPE = "trigger-timer";

    public string getType() {
        return TYPE;
    }

    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) variableScope;
        CommandContextUtil.getAgenda(commandContext).planTriggerExecutionOperation(executionEntity);
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.TIMER_FIRED, cast(Object)job));
        }
    }

}
