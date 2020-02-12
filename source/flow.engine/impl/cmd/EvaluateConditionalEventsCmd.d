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



import java.util.Map;

import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class EvaluateConditionalEventsCmd extends NeedsActiveExecutionCmd<Object> {

    private static final long serialVersionUID = 1L;

    protected Map<string, Object> processVariables;
    protected Map<string, Object> transientVariables;
    protected boolean async;

    public EvaluateConditionalEventsCmd(string processInstanceId, Map<string, Object> processVariables) {
        super(processInstanceId);
        this.processVariables = processVariables;
    }

    public EvaluateConditionalEventsCmd(string processInstanceId, Map<string, Object> processVariables, Map<string, Object> transientVariables) {
        this(processInstanceId, processVariables);
        this.transientVariables = transientVariables;
    }

    @Override
    protected Object execute(CommandContext commandContext, ExecutionEntity execution) {
        if (!execution.isProcessInstanceType()) {
            throw new FlowableException("Execution is not of type process instance");
        }
        
        if (processVariables != null) {
            execution.setVariables(processVariables);
        }

        if (transientVariables != null) {
            execution.setTransientVariables(transientVariables);
        }

        CommandContextUtil.getAgenda(commandContext).planEvaluateConditionalEventsOperation(execution);

        return null;
    }

    @Override
    protected string getSuspendedExceptionMessage() {
        return "Cannot evaluate conditions for an execution that is suspended";
    }

}
