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



import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.engine.impl.util.IdentityLinkUtil;
import flow.engine.impl.util.TaskHelper;
import flow.identitylink.api.IdentityLink;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.task.api.Task;
import org.flowable.task.service.InternalTaskAssignmentManager;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Tijs Rademakers
 */
class DefaultTaskAssignmentManager implements InternalTaskAssignmentManager {

    @Override
    public void changeAssignee(Task task, string assignee) {
        TaskHelper.changeTaskAssignee((TaskEntity) task, assignee);
    }

    @Override
    public void changeOwner(Task task, string owner) {
        TaskHelper.changeTaskOwner((TaskEntity) task, owner);
    }

    @Override
    public void addCandidateUser(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition((TaskEntity) task, (IdentityLinkEntity) identityLink);
    }

    @Override
    public void addCandidateUsers(Task task, List!IdentityLink candidateUsers) {
        List<IdentityLinkEntity> identityLinks = new ArrayList<>();
        for (IdentityLink identityLink : candidateUsers) {
            identityLinks.add((IdentityLinkEntity) identityLink);
        }
        IdentityLinkUtil.handleTaskIdentityLinkAdditions((TaskEntity) task, identityLinks);
    }

    @Override
    public void addCandidateGroup(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition((TaskEntity) task, (IdentityLinkEntity) identityLink);
    }

    @Override
    public void addCandidateGroups(Task task, List!IdentityLink candidateGroups) {
        List<IdentityLinkEntity> identityLinks = new ArrayList<>();
        for (IdentityLink identityLink : candidateGroups) {
            identityLinks.add((IdentityLinkEntity) identityLink);
        }
        IdentityLinkUtil.handleTaskIdentityLinkAdditions((TaskEntity) task, identityLinks);
    }

    @Override
    public void addUserIdentityLink(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition((TaskEntity) task, (IdentityLinkEntity) identityLink);
    }

    @Override
    public void addGroupIdentityLink(Task task, IdentityLink identityLink) {
        IdentityLinkUtil.handleTaskIdentityLinkAddition((TaskEntity) task, (IdentityLinkEntity) identityLink);
    }

    @Override
    public void deleteUserIdentityLink(Task task, IdentityLink identityLink) {
        List<IdentityLinkEntity> identityLinks = new ArrayList<>();
        identityLinks.add((IdentityLinkEntity) identityLink);
        IdentityLinkUtil.handleTaskIdentityLinkDeletions((TaskEntity) task, identityLinks, true, true);
    }

    @Override
    public void deleteGroupIdentityLink(Task task, IdentityLink identityLink) {
        List<IdentityLinkEntity> identityLinks = new ArrayList<>();
        identityLinks.add((IdentityLinkEntity) identityLink);
        IdentityLinkUtil.handleTaskIdentityLinkDeletions((TaskEntity) task, identityLinks, true, true);
    }

}
