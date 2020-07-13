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
module flow.engine.impl.cmd.GetHistoricIdentityLinksForTaskCmd;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.identitylink.api.history.HistoricIdentityLink;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;

/**
 * @author Frederik Heremans
 */
class GetHistoricIdentityLinksForTaskCmd : Command!(List!HistoricIdentityLink) {

    protected string taskId;
    protected string processInstanceId;

    this(string taskId, string processInstanceId) {
        if (taskId is null && processInstanceId is null) {
            throw new FlowableIllegalArgumentException("taskId or processInstanceId is required");
        }
        this.taskId = taskId;
        this.processInstanceId = processInstanceId;
    }

    public List!HistoricIdentityLink execute(CommandContext commandContext) {
        if (taskId !is null) {
            return getLinksForTask(commandContext);
        } else {
            return getLinksForProcessInstance(commandContext);
        }
    }

    protected List!HistoricIdentityLink getLinksForTask(CommandContext commandContext) {
        HistoricTaskInstanceEntity task = CommandContextUtil.getHistoricTaskService().getHistoricTask(taskId);

        if (task is null) {
            throw new FlowableObjectNotFoundException("No historic task exists with the given id: " ~ taskId);
        }

        HistoricIdentityLinkService historicIdentityLinkService = CommandContextUtil.getHistoricIdentityLinkService();
        List!HistoricIdentityLinkEntity identityLinks = historicIdentityLinkService.findHistoricIdentityLinksByTaskId(taskId);

        HistoricIdentityLinkEntity assigneeIdentityLink = null;
        HistoricIdentityLinkEntity ownerIdentityLink = null;
        foreach (HistoricIdentityLinkEntity historicIdentityLink ; identityLinks) {
            if (IdentityLinkType.ASSIGNEE == (historicIdentityLink.getType())) {
                assigneeIdentityLink = historicIdentityLink;

            } else if (IdentityLinkType.OWNER == (historicIdentityLink.getType())) {
                ownerIdentityLink = historicIdentityLink;
            }
        }

        // Similar to GetIdentityLinksForTask, return assignee and owner as identity link
        if (task.getAssignee() !is null && task.getAssignee.length != 0 && assigneeIdentityLink is null) {
            HistoricIdentityLinkEntity identityLink = historicIdentityLinkService.createHistoricIdentityLink();
            identityLink.setUserId(task.getAssignee());
            identityLink.setTaskId(task.getId());
            identityLink.setType(IdentityLinkType.ASSIGNEE);
            identityLinks.add(identityLink);
        }

        if (task.getOwner() !is null && task.getOwner.length != 0 && ownerIdentityLink is null) {
            HistoricIdentityLinkEntity identityLink = historicIdentityLinkService.createHistoricIdentityLink();
            identityLink.setTaskId(task.getId());
            identityLink.setUserId(task.getOwner());
            identityLink.setType(IdentityLinkType.OWNER);
            identityLinks.add(identityLink);
        }

        return cast(List!HistoricIdentityLink) identityLinks;
    }

    protected List!HistoricIdentityLink getLinksForProcessInstance(CommandContext commandContext) {
        return cast(List!HistoricIdentityLink) CommandContextUtil.getHistoricIdentityLinkService().findHistoricIdentityLinksByProcessInstanceId(processInstanceId);
    }

}
