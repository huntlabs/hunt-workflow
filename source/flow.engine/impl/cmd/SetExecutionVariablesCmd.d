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
module flow.engine.impl.cmd.SetExecutionVariablesCmd;

import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
//mport flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.cmd.NeedsActiveExecutionCmd;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class SetExecutionVariablesCmd : NeedsActiveExecutionCmd!Object {

    protected Map!(string, Object) variables;
    protected bool isLocal;

    this(string executionId, Map!(string, Object) variables, bool isLocal) {
        super(executionId);
        this.variables = variables;
        this.isLocal = isLocal;
    }

    override
    protected Object execute(CommandContext commandContext, ExecutionEntity execution) {

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.setExecutionVariables(executionId, variables, isLocal);
        //    return null;
        //}

        if (isLocal) {
            if (variables !is null) {
                foreach (MapEntry!(string, Object) variableName ; variables) {
                    execution.setVariableLocal(variableName.getKey(), variables.get(variableName.getKey()), false);
                }
            }
        } else {
            if (variables !is null) {
                foreach (MapEntry!(string, Object) variableName ; variables) {
                    execution.setVariable(variableName.getKey(), variables.get(variableName.getKey()), false);
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

    override
    protected string getSuspendedExceptionMessage() {
        return "Cannot set variables because execution '" ~ executionId ~ "' is suspended";
    }

}
