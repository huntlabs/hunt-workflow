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
import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.variable.service.api.persistence.entity.VariableInstance;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Daisuke Yoshimoto
 */
class GetExecutionsVariablesCmd implements Command<List<VariableInstance>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected Set!string executionIds;

    public GetExecutionsVariablesCmd(Set!string executionIds) {
        this.executionIds = executionIds;
    }

    @Override
    public List<VariableInstance> execute(CommandContext commandContext) {
        // Verify existence of executions
        if (executionIds is null) {
            throw new FlowableIllegalArgumentException("executionIds is null");
        }
        if (executionIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of executionIds is empty");
        }

        List<VariableInstance> instances = new ArrayList<>();
        List<VariableInstanceEntity> entities = CommandContextUtil.getVariableService().findVariableInstancesByExecutionIds(executionIds);
        for (VariableInstanceEntity entity : entities) {
            entity.getValue();
            instances.add(entity);
        }
        return instances;
    }

}
