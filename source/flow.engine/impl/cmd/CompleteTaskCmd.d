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

module flow.engine.impl.cmd.CompleteTaskCmd;
import hunt.collection.Map;
import flow.engine.impl.cmd.NeedsActiveTaskCmd;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
//import flow.engine.impl.util.Flowable5Util;
//import flow.engine.impl.util.TaskHelper;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class CompleteTaskCmd : NeedsActiveTaskCmd!Void {

    protected Map!(string, Object) variables;
    protected Map!(string, Object) transientVariables;
    protected bool localScope;

    this(string taskId, Map!(string, Object) variables) {
        super(taskId);
        this.variables = variables;
    }

    this(string taskId, Map!(string, Object) variables, bool localScope) {
        this(taskId, variables);
        this.localScope = localScope;
    }

    this(string taskId, Map!(string, Object) variables, Map!(string, Object) transientVariables) {
        this(taskId, variables);
        this.transientVariables = transientVariables;
    }

    override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        implementationMissing(false);
        // Backwards compatibility
        //if (task.getProcessDefinitionId() !is null) {
        //    if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //        Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //
        //        if (transientVariables is null) {
        //            compatibilityHandler.completeTask(task, variables, localScope);
        //        } else {
        //            compatibilityHandler.completeTask(task, variables, transientVariables);
        //        }
        //        return null;
        //    }
        //}
        //
        //TaskHelper.completeTask(task, variables, transientVariables, localScope, commandContext);
        return null;
    }

    override
    protected string getSuspendedTaskException() {
        return "Cannot complete a suspended task";
    }

}
