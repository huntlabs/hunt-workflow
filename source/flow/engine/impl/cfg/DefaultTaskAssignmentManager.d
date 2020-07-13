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

module flow.engine.impl.cfg.DefaultTaskAssignmentManager;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.engine.impl.util.IdentityLinkUtil;
import flow.engine.impl.util.TaskHelper;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.Task;
import flow.task.service.InternalTaskAssignmentManager;
import flow.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tijs Rademakers
 */
class DefaultTaskAssignmentManager : InternalTaskAssignmentManager {


    public void changeAssignee(Task task, string assignee) {
        TaskHelper.changeTaskAssignee(cast(TaskEntity) task, assignee);
    }


    public void changeOwner(Task task, string owner) {
        TaskHelper.changeTaskOwner(cast(TaskEntity) task, owner);
    }


    public void addCandidateUser(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition(cast(TaskEntity) task, cast(IdentityLinkEntity) identityLink);
    }


    public void addCandidateUsers(Task task, List!IdentityLink candidateUsers) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        foreach (IdentityLink identityLink ; candidateUsers) {
            identityLinks.add(cast(IdentityLinkEntity) identityLink);
        }
        IdentityLinkUtil.handleTaskIdentityLinkAdditions(cast(TaskEntity) task, identityLinks);
    }


    public void addCandidateGroup(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition(cast(TaskEntity) task, cast(IdentityLinkEntity) identityLink);
    }


    public void addCandidateGroups(Task task, List!IdentityLink candidateGroups) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        foreach (IdentityLink identityLink ; candidateGroups) {
            identityLinks.add(cast(IdentityLinkEntity) identityLink);
        }
        IdentityLinkUtil.handleTaskIdentityLinkAdditions(cast(TaskEntity) task, identityLinks);
    }


    public void addUserIdentityLink(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition(cast(TaskEntity) task, cast(IdentityLinkEntity) identityLink);
    }


    public void addGroupIdentityLink(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition(cast(TaskEntity) task,cast(IdentityLinkEntity) identityLink);
    }


    public void deleteUserIdentityLink(Task task, IdentityLink identityLink) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        identityLinks.add(cast(IdentityLinkEntity) identityLink);
        IdentityLinkUtil.handleTaskIdentityLinkDeletions(cast(TaskEntity) task, identityLinks, true, true);
    }


    public void deleteGroupIdentityLink(Task task, IdentityLink identityLink) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        identityLinks.add(cast(IdentityLinkEntity) identityLink);
        IdentityLinkUtil.handleTaskIdentityLinkDeletions(cast(TaskEntity) task, identityLinks, true, true);
    }

}
