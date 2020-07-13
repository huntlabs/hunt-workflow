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

module flow.engine.impl.cmd.TriggerCmd;

import hunt.collection.Map;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import  flow.engine.impl.cmd.NeedsActiveExecutionCmd;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class TriggerCmd : NeedsActiveExecutionCmd!Object {


    protected Map!(string, Object) processVariables;
    protected Map!(string, Object) transientVariables;
    protected bool async;

    this(string executionId, Map!(string, Object) processVariables) {
        super(executionId);
        this.processVariables = processVariables;
    }

    this(string executionId, Map!(string, Object) processVariables, bool async) {
        super(executionId);
        this.processVariables = processVariables;
        this.async = async;
    }

    this(string executionId, Map!(string, Object) processVariables, Map!(string, Object) transientVariables) {
        this(executionId, processVariables);
        this.transientVariables = transientVariables;
    }

    override
    protected Object execute(CommandContext commandContext, ExecutionEntity execution) {
        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.trigger(executionId, processVariables, transientVariables);
        //    return null;
        //}

        if (processVariables !is null) {
            execution.setVariables(processVariables);
        }

        if (!async) {
            if (transientVariables !is null) {
                execution.setTransientVariables(transientVariables);
            }

            CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNALED, execution.getCurrentActivityId(), null,
                            null, execution.getId(), execution.getProcessInstanceId(), execution.getProcessDefinitionId()));

            CommandContextUtil.getAgenda(commandContext).planTriggerExecutionOperation(execution);

        } else {
            CommandContextUtil.getAgenda(commandContext).planAsyncTriggerExecutionOperation(execution);
        }

        return null;
    }

    override
    protected string getSuspendedExceptionMessage() {
        return "Cannot trigger an execution that is suspended";
    }

}
