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



import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.Flowable5Util;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class SetTaskVariablesCmd : NeedsActiveTaskCmd!Object {

    private static final long serialVersionUID = 1L;

    protected Map<string, ? : Object> variables;
    protected bool isLocal;

    public SetTaskVariablesCmd(string taskId, Map<string, ? : Object> variables, bool isLocal) {
        super(taskId);
        this.taskId = taskId;
        this.variables = variables;
        this.isLocal = isLocal;
    }

    override
    protected Object execute(CommandContext commandContext, TaskEntity task) {

        if (task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.setTaskVariables(taskId, variables, isLocal);
            return null;
        }

        if (isLocal) {
            if (variables !is null) {
                for (string variableName : variables.keySet()) {
                    task.setVariableLocal(variableName, variables.get(variableName), false);
                }
            }

        } else {
            if (variables !is null) {
                for (string variableName : variables.keySet()) {
                    task.setVariable(variableName, variables.get(variableName), false);
                }
            }
        }

        // ACT-1887: Force an update of the task's revision to prevent
        // simultaneous inserts of the same variable. If not, duplicate variables may occur since optimistic
        // locking doesn't work on inserts
        task.forceUpdate();
        return null;
    }

    override
    protected string getSuspendedTaskException() {
        return "Cannot add variables to a suspended task";
    }

}
