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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.Execution;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class FindActiveActivityIdsCmd implements Command<List<string>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string executionId;

    public FindActiveActivityIdsCmd(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public List!string execute(CommandContext commandContext) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity execution = executionEntityManager.findById(executionId);

        if (execution is null) {
            throw new FlowableObjectNotFoundException("execution " + executionId + " doesn't exist", Execution.class);
        }

        return findActiveActivityIds(execution);
    }

    public List!string findActiveActivityIds(ExecutionEntity executionEntity) {
        List!string activeActivityIds = new ArrayList<>();
        collectActiveActivityIds(executionEntity, activeActivityIds);
        return activeActivityIds;
    }

    protected void collectActiveActivityIds(ExecutionEntity executionEntity, List!string activeActivityIds) {
        if (executionEntity.isActive() && executionEntity.getActivityId() !is null) {
            activeActivityIds.add(executionEntity.getActivityId());
        }

        for (ExecutionEntity childExecution : executionEntity.getExecutions()) {
            collectActiveActivityIds(childExecution, activeActivityIds);
        }
    }

}
