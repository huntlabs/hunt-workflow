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
module flow.engine.impl.cmd.ResolveTaskCmd;

import flow.engine.impl.cmd.NeedsActiveTaskCmd;
import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.TaskHelper;
import flow.task.api.DelegationState;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ResolveTaskCmd : NeedsActiveTaskCmd!Void {


    protected Map!(string, Object) variables;
    protected Map!(string, Object) transientVariables;

    this(string taskId, Map!(string, Object) variables) {
        super(taskId);
        this.variables = variables;
    }

    this(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        this(taskId, variables);
        this.transientVariables = transientVariables;
    }

    override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        implementationMissing(false);
        return null;
        //if (variables !is null) {
        //    task.setVariables(variables);
        //}
        //if (transientVariables !is null) {
        //    task.setTransientVariables(transientVariables);
        //}
        //
        //task.setDelegationState(DelegationState.RESOLVED);
        //TaskHelper.changeTaskAssignee(task, task.getOwner());
        //
        //return null;
    }

    override
    protected string getSuspendedTaskException() {
        return "Cannot resolve a suspended task";
    }

}
