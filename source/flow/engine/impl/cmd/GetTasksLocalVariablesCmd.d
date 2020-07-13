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
module flow.engine.impl.cmd.GetTasksLocalVariablesCmd;


import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.variable.service.api.persistence.entity.VariableInstance;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Daisuke Yoshimoto
 */
class GetTasksLocalVariablesCmd : Command!(List!VariableInstance) {

    protected Set!string taskIds;

    this(Set!string taskIds) {
        this.taskIds = taskIds;
    }

    public List!VariableInstance execute(CommandContext commandContext) {
        if (taskIds is null) {
            throw new FlowableIllegalArgumentException("taskIds is null");
        }
        if (taskIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of taskIds is empty");
        }

        List!VariableInstance instances = new ArrayList!VariableInstance();
        List!VariableInstanceEntity entities = CommandContextUtil.getVariableService().findVariableInstancesByTaskIds(taskIds);
        foreach (VariableInstanceEntity entity ; entities) {
            entity.getValue();
            instances.add(entity);
        }

        return instances;
    }

}
