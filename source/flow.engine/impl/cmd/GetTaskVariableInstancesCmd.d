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
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.task.api.Task;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.variable.api.persistence.entity.VariableInstance;

class GetTaskVariableInstancesCmd implements Command<Map<string, VariableInstance>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;
    protected Collection<string> variableNames;
    protected boolean isLocal;

    public GetTaskVariableInstancesCmd(string taskId, Collection<string> variableNames, boolean isLocal) {
        this.taskId = taskId;
        this.variableNames = variableNames;
        this.isLocal = isLocal;
    }

    @Override
    public Map<string, VariableInstance> execute(CommandContext commandContext) {
        if (taskId == null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }

        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task == null) {
            throw new FlowableObjectNotFoundException("task " + taskId + " doesn't exist", Task.class);
        }

        Map<string, VariableInstance> variables = null;
        if (variableNames == null) {

            if (isLocal) {
                variables = task.getVariableInstancesLocal();
            } else {
                variables = task.getVariableInstances();
            }

        } else {
            if (isLocal) {
                variables = task.getVariableInstancesLocal(variableNames, false);
            } else {
                variables = task.getVariableInstances(variableNames, false);
            }

        }

        return variables;
    }
}
