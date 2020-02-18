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


import java.io.Serializable;
import java.util.Collection;
import java.util.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.Execution;
import org.flowable.variable.api.persistence.entity.VariableInstance;

class GetExecutionVariableInstancesCmd implements Command<Map<string, VariableInstance>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string executionId;
    protected Collection<string> variableNames;
    protected bool isLocal;

    public GetExecutionVariableInstancesCmd(string executionId, Collection<string> variableNames, bool isLocal) {
        this.executionId = executionId;
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    @Override
    public Map<string, VariableInstance> execute(CommandContext commandContext) {

        // Verify existence of execution
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " + executionId + " doesn't exist", Execution.class);
        }

        Map<string, VariableInstance> variables = null;

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            variables = compatibilityHandler.getExecutionVariableInstances(executionId, variableNames, isLocal);

        } else {

            if (variableNames is null || variableNames.isEmpty()) {
                // Fetch all
                if (isLocal) {
                    variables = execution.getVariableInstancesLocal();
                } else {
                    variables = execution.getVariableInstances();
                }

            } else {
                // Fetch specific collection of variables
                if (isLocal) {
                    variables = execution.getVariableInstancesLocal(variableNames, false);
                } else {
                    variables = execution.getVariableInstances(variableNames, false);
                }
            }
        }

        return variables;
    }
}
