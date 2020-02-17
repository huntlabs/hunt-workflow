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
import flow.engine.impl.util.TaskHelper;
import org.flowable.task.api.DelegationState;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ResolveTaskCmd extends NeedsActiveTaskCmd<Void> {

    private static final long serialVersionUID = 1L;

    protected Map<string, Object> variables;
    protected Map<string, Object> transientVariables;

    public ResolveTaskCmd(string taskId, Map<string, Object> variables) {
        super(taskId);
        this.variables = variables;
    }

    public ResolveTaskCmd(string taskId, Map<string, Object> variables, Map<string, Object> transientVariables) {
        this(taskId, variables);
        this.transientVariables = transientVariables;
    }

    @Override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        if (variables != null) {
            task.setVariables(variables);
        }
        if (transientVariables != null) {
            task.setTransientVariables(transientVariables);
        }

        task.setDelegationState(DelegationState.RESOLVED);
        TaskHelper.changeTaskAssignee(task, task.getOwner());

        return null;
    }

    @Override
    protected string getSuspendedTaskException() {
        return "Cannot resolve a suspended task";
    }

}
