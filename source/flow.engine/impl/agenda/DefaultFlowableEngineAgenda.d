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
module flow.engine.impl.agenda.DefaultFlowableEngineAgenda;

import flow.engine.impl.agenda.ContinueProcessOperation;
import flow.common.agenda.AbstractAgenda;
import flow.common.context.Context;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.FlowableEngineAgenda;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import hunt.util.Common;
import hunt.util.Runnable;
import hunt.logging;
import flow.engine.impl.agenda.ContinueMultiInstanceOperation;
import flow.engine.impl.agenda.TakeOutgoingSequenceFlowsOperation;
import flow.engine.impl.agenda.EndExecutionOperation;
import flow.engine.impl.agenda.TriggerExecutionOperation;
import flow.engine.impl.agenda.EvaluateConditionalEventsOperation;
import flow.engine.impl.agenda.DestroyScopeOperation;
import flow.engine.impl.agenda.ExecuteInactiveBehaviorsOperation;
/**
 * For each API call (and thus {@link Command}) being executed, a new agenda instance is created. On this agenda, operations are put, which the {@link CommandExecutor} will keep executing until all
 * are executed.
 *
 * The agenda also gives easy access to methods to plan new operations when writing {@link ActivityBehavior} implementations.
 *
 * During a {@link Command} execution, the agenda can always be fetched using {@link Context#getAgenda()}.
 *
 * @author Joram Barrez
 */
class DefaultFlowableEngineAgenda : AbstractAgenda , FlowableEngineAgenda {

    this(CommandContext commandContext) {
        super(commandContext);
    }

    /**
     * Generic method to plan a {@link Runnable}.
     */

    public void planOperation(Runnable operation, ExecutionEntity executionEntity) {
        operations.add(operation);
        logInfo("Operation {} added to agenda");

        if (executionEntity !is null) {
            CommandContextUtil.addInvolvedExecution(commandContext, executionEntity);
        }
    }

    /* SPECIFIC operations */


    public void planContinueProcessOperation(ExecutionEntity execution) {
        planOperation(new ContinueProcessOperation(commandContext, execution), execution);
    }


    public void planContinueProcessSynchronousOperation(ExecutionEntity execution) {
        planOperation(new ContinueProcessOperation(commandContext, execution, true, false), execution);
    }


    public void planContinueProcessInCompensation(ExecutionEntity execution) {
        planOperation(new ContinueProcessOperation(commandContext, execution, false, true), execution);
    }


    public void planContinueMultiInstanceOperation(ExecutionEntity execution, ExecutionEntity multiInstanceRootExecution, int loopCounter) {
        planOperation(new ContinueMultiInstanceOperation(commandContext, execution, multiInstanceRootExecution, loopCounter), execution);
    }


    public void planTakeOutgoingSequenceFlowsOperation(ExecutionEntity execution, bool evaluateConditions) {
        planOperation(new TakeOutgoingSequenceFlowsOperation(commandContext, execution, evaluateConditions), execution);
    }


    public void planEndExecutionOperation(ExecutionEntity execution) {
        planOperation(new EndExecutionOperation(commandContext, execution), execution);
    }


    public void planEndExecutionOperationSynchronous(ExecutionEntity execution) {
        planOperation(new EndExecutionOperation(commandContext, execution, true), execution);
    }


    public void planTriggerExecutionOperation(ExecutionEntity execution) {
        planOperation(new TriggerExecutionOperation(commandContext, execution), execution);
    }


    public void planAsyncTriggerExecutionOperation(ExecutionEntity execution) {
        planOperation(new TriggerExecutionOperation(commandContext, execution, true), execution);
    }


    public void planEvaluateConditionalEventsOperation(ExecutionEntity execution) {
        planOperation(new EvaluateConditionalEventsOperation(commandContext, execution), execution);
    }


    public void planDestroyScopeOperation(ExecutionEntity execution) {
        planOperation(new DestroyScopeOperation(commandContext, execution), execution);
    }


    public void planExecuteInactiveBehaviorsOperation() {
        planOperation(new ExecuteInactiveBehaviorsOperation(commandContext));
    }

}
