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

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.Flowable5Util;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class SetExecutionVariablesCmd extends NeedsActiveExecutionCmd<Object> {

    private static final long serialVersionUID = 1L;

    protected Map<string, ? extends Object> variables;
    protected bool isLocal;

    public SetExecutionVariablesCmd(string executionId, Map<string, ? extends Object> variables, bool isLocal) {
        super(executionId);
        this.variables = variables;
        this.isLocal = isLocal;
    }

    @Override
    protected Object execute(CommandContext commandContext, ExecutionEntity execution) {

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.setExecutionVariables(executionId, variables, isLocal);
            return null;
        }

        if (isLocal) {
            if (variables !is null) {
                for (string variableName : variables.keySet()) {
                    execution.setVariableLocal(variableName, variables.get(variableName), false);
                }
            }
        } else {
            if (variables !is null) {
                for (string variableName : variables.keySet()) {
                    execution.setVariable(variableName, variables.get(variableName), false);
                }
            }
        }

        // ACT-1887: Force an update of the execution's revision to prevent
        // simultaneous inserts of the same
        // variable. If not, duplicate variables may occur since optimistic
        // locking doesn't work on inserts
        execution.forceUpdate();
        return null;
    }

    @Override
    protected string getSuspendedExceptionMessage() {
        return "Cannot set variables because execution '" + executionId + "' is suspended";
    }

}