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


import hunt.collection;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.Flowable5Util;

/**
 * @author roman.smirnov
 * @author Joram Barrez
 */
class RemoveExecutionVariablesCmd : NeedsActiveExecutionCmd!Void {

    private static final long serialVersionUID = 1L;

    private Collection!string variableNames;
    private bool isLocal;

    public RemoveExecutionVariablesCmd(string executionId, Collection!string variableNames, bool isLocal) {
        super(executionId);
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    override
    protected Void execute(CommandContext commandContext, ExecutionEntity execution) {
        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.removeExecutionVariables(executionId, variableNames, isLocal);
            return null;
        }

        if (isLocal) {
            execution.removeVariablesLocal(variableNames);
        } else {
            execution.removeVariables(variableNames);
        }

        return null;
    }

    override
    protected string getSuspendedExceptionMessage() {
        return "Cannot remove variables because execution '" + executionId + "' is suspended";
    }

}
