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
module flow.engine.impl.agenda.DebugFlowableEngineAgenda;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.runtime.ProcessDebugger;
import flow.engine.impl.agenda.DefaultFlowableEngineAgenda;
import flow.engine.impl.agenda.DebugContinueProcessOperation;

/**
 * This {@link flow.engine.FlowableEngineAgenda} schedules operations which allow debugging
 */
class DebugFlowableEngineAgenda : DefaultFlowableEngineAgenda {

    protected ProcessDebugger processDebugger;

    this(CommandContext commandContext, ProcessDebugger processDebugger) {
        super(commandContext);
        this.processDebugger = processDebugger;
    }

    override
    public void planContinueProcessOperation(ExecutionEntity execution) {
        planOperation(new DebugContinueProcessOperation(processDebugger, commandContext, execution), execution);
    }

    override
    public void planContinueProcessSynchronousOperation(ExecutionEntity execution) {
        planOperation(new DebugContinueProcessOperation(processDebugger, commandContext, execution, true, false), execution);
    }

    override
    public void planContinueProcessInCompensation(ExecutionEntity execution) {
        planOperation(new DebugContinueProcessOperation(processDebugger, commandContext, execution, false, true), execution);
    }

}
