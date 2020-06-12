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

module flow.engine.impl.cmd.EvaluateConditionalEventsCmd;

import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.cmd.NeedsActiveExecutionCmd;


/**
 * @author Tijs Rademakers
 */
class EvaluateConditionalEventsCmd : NeedsActiveExecutionCmd!Object {

    protected Map!(string, Object) processVariables;
    protected Map!(string, Object) transientVariables;
    protected bool async;

    this(string processInstanceId, Map!(string, Object) processVariables) {
        super(processInstanceId);
        this.processVariables = processVariables;
    }

    this(string processInstanceId, Map!(string, Object) processVariables, Map!(string, Object) transientVariables) {
        this(processInstanceId, processVariables);
        this.transientVariables = transientVariables;
    }

    override
    protected Object execute(CommandContext commandContext, ExecutionEntity execution) {
        if (!execution.isProcessInstanceType()) {
            throw new FlowableException("Execution is not of type process instance");
        }

        if (processVariables !is null) {
            execution.setVariables(processVariables);
        }

        if (transientVariables !is null) {
            execution.setTransientVariables(transientVariables);
        }

        CommandContextUtil.getAgenda(commandContext).planEvaluateConditionalEventsOperation(execution);

        return null;
    }

    override
    protected string getSuspendedExceptionMessage() {
        return "Cannot evaluate conditions for an execution that is suspended";
    }

}
