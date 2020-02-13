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

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class GetExecutionVariablesCmd implements Command<Map<string, Object>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string executionId;
    protected Collection<string> variableNames;
    protected bool isLocal;

    public GetExecutionVariablesCmd(string executionId, Collection<string> variableNames, bool isLocal) {
        this.executionId = executionId;
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    @Override
    public Map<string, Object> execute(CommandContext commandContext) {

        // Verify existence of execution
        if (executionId == null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

        if (execution == null) {
            throw new FlowableObjectNotFoundException("execution " + executionId + " doesn't exist", Execution.class);
        }

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            return compatibilityHandler.getExecutionVariables(executionId, variableNames, isLocal);
        }

        if (variableNames == null || variableNames.isEmpty()) {

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
