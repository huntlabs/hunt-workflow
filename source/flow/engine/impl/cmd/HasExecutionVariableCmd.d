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
module flow.engine.impl.cmd.HasExecutionVariableCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.Execution;

/**
 * @author Frederik Heremans
 */
class HasExecutionVariableCmd : Command!bool {

    protected string executionId;
    protected string variableName;
    protected bool isLocal;

    this(string executionId, string variableName, bool isLocal) {
        this.executionId = executionId;
        this.variableName = variableName;
        this.isLocal = isLocal;
    }

    public bool execute(CommandContext commandContext) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " ~ executionId ~ " doesn't exist");
        }

        bool hasVariable = false;

        if (isLocal) {
            hasVariable = execution.hasVariableLocal(variableName);
        } else {
            hasVariable = execution.hasVariable(variableName);
        }

        return hasVariable;
    }
}
