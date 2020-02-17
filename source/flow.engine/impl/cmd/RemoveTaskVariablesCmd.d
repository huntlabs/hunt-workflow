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


import java.util.Collection;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.Flowable5Util;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author roman.smirnov
 * @author Joram Barrez
 */
class RemoveTaskVariablesCmd extends NeedsActiveTaskCmd<Void> {

    private static final long serialVersionUID = 1L;

    private final Collection<string> variableNames;
    private final bool isLocal;

    public RemoveTaskVariablesCmd(string taskId, Collection<string> variableNames, bool isLocal) {
        super(taskId);
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    @Override
    protected Void execute(CommandContext commandContext, TaskEntity task) {

        if (task.getProcessDefinitionId() != null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.removeTaskVariables(taskId, variableNames, isLocal);
            return null;
        }

        if (isLocal) {
            task.removeVariablesLocal(variableNames);
        } else {
            task.removeVariables(variableNames);
        }

        return null;
    }

    @Override
    protected string getSuspendedTaskException() {
        return "Cannot remove variables from a suspended task.";
    }

}
