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
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.entitylink.service.api.EntityLink;
import flow.entitylink.service.api.EntityLinkType;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Javier Casal
 */
class GetEntityLinkParentsForTaskCmd implements Command<List!EntityLink>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;

    public GetEntityLinkParentsForTaskCmd(string taskId) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is required");
        }
        this.taskId = taskId;
    }

    override
    public List!EntityLink execute(CommandContext commandContext) {
        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);

        if (task is null) {
            throw new FlowableObjectNotFoundException("Cannot find task with id " + taskId, ExecutionEntity.class);
        }

        return CommandContextUtil.getEntityLinkService().findEntityLinksByReferenceScopeIdAndType(task.getId(), ScopeTypes.TASK, EntityLinkType.CHILD);
    }

}
