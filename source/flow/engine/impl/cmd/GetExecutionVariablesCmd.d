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
module flow.engine.impl.cmd.GetExecutionVariablesCmd;

import hunt.collection;
import hunt.collection.Map;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.Execution;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetExecutionVariablesCmd : Command!(Map!(string, Object)) {

    protected string executionId;
    protected Collection!string variableNames;
    protected bool isLocal;

    this(string executionId, Collection!string variableNames, bool isLocal) {
        this.executionId = executionId;
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    public Map!(string, Object) execute(CommandContext commandContext) {

        // Verify existence of execution
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " ~ executionId ~ " doesn't exist");
        }

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    return compatibilityHandler.getExecutionVariables(executionId, variableNames, isLocal);
        //}

        if (variableNames is null || variableNames.isEmpty()) {

            // Fetch all

            if (isLocal) {
                return execution.getVariablesLocal();
            } else {
                return execution.getVariables();
            }

        } else {

            // Fetch specific collection of variables
            if (isLocal) {
                return execution.getVariablesLocal(variableNames, false);
            } else {
                return execution.getVariables(variableNames, false);
            }

        }

    }
}
