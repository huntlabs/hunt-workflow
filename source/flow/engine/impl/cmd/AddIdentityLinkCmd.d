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
module flow.engine.impl.cmd.AddIdentityLinkCmd;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.IdentityLinkUtil;
import flow.engine.impl.util.TaskHelper;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.cmd.NeedsActiveTaskCmd;
import hunt.Object;

/**
 * @author Joram Barrez
 */
class AddIdentityLinkCmd : NeedsActiveTaskCmd!Void {

    public static  int IDENTITY_USER = 1;
    public static  int IDENTITY_GROUP = 2;

    protected string identityId;

    protected int identityIdType;

    protected string identityType;

    this(string taskId, string identityId, int identityIdType, string identityType) {
        super(taskId);
        validateParams(taskId, identityId, identityIdType, identityType);
        this.taskId = taskId;
        this.identityId = identityId;
        this.identityIdType = identityIdType;
        this.identityType = identityType;
    }

    protected void validateParams(string taskId, string identityId, int identityIdType, string identityType) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("taskId is null");
        }

        if (identityType is null) {
            throw new FlowableIllegalArgumentException("type is required when adding a new task identity link");
        }

        if (identityId is null && (identityIdType == IDENTITY_GROUP ||
                (IdentityLinkType.ASSIGNEE != (identityType) && IdentityLinkType.OWNER != (identityType)))) {

            throw new FlowableIllegalArgumentException("identityId is null");
        }

        if (identityIdType != IDENTITY_USER && identityIdType != IDENTITY_GROUP) {
            throw new FlowableIllegalArgumentException("identityIdType allowed values are 1 and 2");
        }
    }

    override
    protected Void execute(CommandContext commandContext, TaskEntity task) {

        //if (task.getProcessDefinitionId() !is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.addIdentityLink(taskId, identityId, identityIdType, identityType);
        //    return null;
        //}

        string oldAssigneeId = task.getAssignee();
        string oldOwnerId = task.getOwner();

        bool assignedToNoOne = false;
        if (IdentityLinkType.ASSIGNEE == (identityType)) {

            if (oldAssigneeId is null && identityId is null) {
                return null;
            }

            if (oldAssigneeId !is null && oldAssigneeId == (identityId)) {
                return null;
            }

            TaskHelper.changeTaskAssignee(task, identityId);
            assignedToNoOne = identityId is null;

        } else if (IdentityLinkType.OWNER == (identityType)) {

            if (oldOwnerId is null && identityId is null) {
                return null;
            }

            if (oldOwnerId !is null && oldOwnerId == identityId) {
                return null;
            }

            TaskHelper.changeTaskOwner(task, identityId);
            assignedToNoOne = identityId is null;

        } else if (IDENTITY_USER == identityIdType) {
            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(task.getId(), identityId, null, identityType);
            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);

        } else if (IDENTITY_GROUP == identityIdType) {
            IdentityLinkEntity identityLinkEntity = CommandContextUtil.getIdentityLinkService().createTaskIdentityLink(task.getId(), null, identityId, identityType);
            IdentityLinkUtil.handleTaskIdentityLinkAddition(task, identityLinkEntity);

        }

        bool forceNullUserId = false;
        if (assignedToNoOne) {
            // ACT-1317: Special handling when assignee is set to NULL, a
            // CommentEntity notifying of assignee-delete should be created
            forceNullUserId = true;
            if (IdentityLinkType.ASSIGNEE == (identityType)) {
                identityId = oldAssigneeId;
            } else {
                identityId = oldOwnerId;
            }
        }

        if (IDENTITY_USER == identityIdType) {
            CommandContextUtil.getHistoryManager(commandContext).createUserIdentityLinkComment(task, identityId, identityType, true, forceNullUserId);
        } else {
            CommandContextUtil.getHistoryManager(commandContext).createGroupIdentityLinkComment(task, identityId, identityType, true);
        }

        return null;
    }

}
