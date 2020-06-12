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
module flow.engine.impl.cmd.GetEntityLinkChildrenForTaskCmd;

import hunt.collection.List;

import flow.common.api.scop.ScopeTypes;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.entitylink.service.api.EntityLink;
import flow.entitylink.service.api.EntityLinkType;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tijs Rademakers
 */
class GetEntityLinkChildrenForTaskCmd : Command!(List!EntityLink) {

    protected string taskId;

    this(string taskId) {
        this.taskId = taskId;
    }

    public List!EntityLink execute(CommandContext commandContext) {
        TaskEntity task = CommandContextUtil.getTaskService().getTask(taskId);
        return CommandContextUtil.getEntityLinkService().findEntityLinksByScopeIdAndType(task.getId(), ScopeTypes.TASK, EntityLinkType.CHILD);
    }

}
