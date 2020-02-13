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
import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.TaskHelper;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class CompleteTaskCmd extends NeedsActiveTaskCmd<Void> {

    private static final long serialVersionUID = 1L;
    protected Map<string, Object> variables;
    protected Map<string, Object> transientVariables;
    protected bool localScope;

    public CompleteTaskCmd(string taskId, Map<string, Object> variables) {
        super(taskId);
        this.variables = variables;
    }

    public CompleteTaskCmd(string taskId, Map<string, Object> variables, bool localScope) {
        this(taskId, variables);
        this.localScope = localScope;
    }

    public CompleteTaskCmd(string taskId, Map<string, Object> variables, Map<string, Object> transientVariables) {
        this(taskId, variables);
        this.transientVariables = transientVariables;
    }

    @Override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        // Backwards compatibility
        if (task.getProcessDefinitionId() != null) {
            if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();

                if (transientVariables == null) {
                    compatibilityHandler.completeTask(task, variables, localScope);
                } else {
                    compatibilityHandler.completeTask(task, variables, transientVariables);
                }
                return null;
            }
        }

        TaskHelper.completeTask(task, variables, transientVariables, localScope, commandContext);
        return null;
    }

    @Override
    protected string getSuspendedTaskException() {
        return "Cannot complete a suspended task";
    }

}
