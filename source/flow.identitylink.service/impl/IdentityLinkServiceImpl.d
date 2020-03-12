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
module flow.identitylink.service.impl.IdentityLinkServiceImpl;

import hunt.collection;
import hunt.collection.List;

import flow.common.service.CommonServiceImpl;
import flow.identitylink.service.IdentityLinkService;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;

/**
 * @author Tijs Rademakers
 */
class IdentityLinkServiceImpl : CommonServiceImpl!IdentityLinkServiceConfiguration , IdentityLinkService {

    this(IdentityLinkServiceConfiguration identityLinkServiceConfiguration) {
        super(identityLinkServiceConfiguration);
    }


    public IdentityLinkEntity getIdentityLink(string id) {
        return getIdentityLinkEntityManager().findById(id);
    }


    public List!IdentityLinkEntity findIdentityLinksByTaskId(string taskId) {
        return getIdentityLinkEntityManager().findIdentityLinksByTaskId(taskId);
    }


    public List!IdentityLinkEntity findIdentityLinksByProcessInstanceId(string processInstanceId) {
        return getIdentityLinkEntityManager().findIdentityLinksByProcessInstanceId(processInstanceId);
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeIdAndType(string scopeId, string scopeType) {
        return getIdentityLinkEntityManager().findIdentityLinksByScopeIdAndType(scopeId, scopeType);
    }


    public List!IdentityLinkEntity findIdentityLinksBySubScopeIdAndType(string subScopeId, string scopeType) {
        return getIdentityLinkEntityManager().findIdentityLinksBySubScopeIdAndType(subScopeId, scopeType);
    }


    public List!IdentityLinkEntity findIdentityLinksByProcessDefinitionId(string processDefinitionId) {
        return getIdentityLinkEntityManager().findIdentityLinksByProcessDefinitionId(processDefinitionId);
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        return getIdentityLinkEntityManager().findIdentityLinksByScopeDefinitionIdAndType(scopeDefinitionId, scopeType);
    }


    public IdentityLinkEntity addCandidateUser(string taskId, string userId) {
        return getIdentityLinkEntityManager().addCandidateUser(taskId, userId);
    }


    public List!IdentityLinkEntity addCandidateUsers(string taskId, Collection!string candidateUsers) {
        return getIdentityLinkEntityManager().addCandidateUsers(taskId, candidateUsers);
    }


    public IdentityLinkEntity addCandidateGroup(string taskId, string groupId) {
        return getIdentityLinkEntityManager().addCandidateGroup(taskId, groupId);
    }


    public List!IdentityLinkEntity addCandidateGroups(string taskId, Collection!string candidateGroups) {
        return getIdentityLinkEntityManager().addCandidateGroups(taskId, candidateGroups);
    }


    public IdentityLinkEntity createProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().addProcessInstanceIdentityLink(processInstanceId, userId, groupId, type);
    }


    public IdentityLinkEntity createScopeIdentityLink(string scopeDefinitionId, string scopeId, string scopeType, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().addScopeIdentityLink(scopeDefinitionId, scopeId, scopeType, userId, groupId, type);
    }


    public IdentityLinkEntity createSubScopeIdentityLink(string scopeDefinitionId, string scopeId, string subScopeId, string scopeType,
                    string userId, string groupId, string type) {

        return getIdentityLinkEntityManager().addSubScopeIdentityLink(scopeDefinitionId, scopeId, subScopeId, scopeType, userId, groupId, type);
    }


    public IdentityLinkEntity createTaskIdentityLink(string taskId, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().addTaskIdentityLink(taskId, userId, groupId, type);
    }


    public IdentityLinkEntity createProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId) {
        return getIdentityLinkEntityManager().addProcessDefinitionIdentityLink(processDefinitionId, userId, groupId);
    }


    public IdentityLinkEntity createScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        return getIdentityLinkEntityManager().addScopeDefinitionIdentityLink(scopeDefinitionId, scopeType, userId, groupId);
    }


    public IdentityLinkEntity createIdentityLink() {
        return getIdentityLinkEntityManager().create();
    }


    public void insertIdentityLink(IdentityLinkEntity identityLink) {
        getIdentityLinkEntityManager().insert(identityLink);
    }


    public void deleteIdentityLink(IdentityLinkEntity identityLink) {
        getIdentityLinkEntityManager().dele(identityLink);
    }


    public List!IdentityLinkEntity deleteProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().deleteProcessInstanceIdentityLink(processInstanceId, userId, groupId, type);
    }


    public List!IdentityLinkEntity deleteScopeIdentityLink(string scopeId, string scopeType, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().deleteScopeIdentityLink(scopeId, scopeType, userId, groupId, type);
    }


    public List!IdentityLinkEntity deleteTaskIdentityLink(string taskId, List!IdentityLinkEntity currentIdentityLinks, string userId, string groupId, string type) {
        return getIdentityLinkEntityManager().deleteTaskIdentityLink(taskId, currentIdentityLinks, userId, groupId, type);
    }


    public List!IdentityLinkEntity deleteProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId) {
        return getIdentityLinkEntityManager().deleteProcessDefinitionIdentityLink(processDefinitionId, userId, groupId);
    }


    public List!IdentityLinkEntity deleteScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        return getIdentityLinkEntityManager().deleteScopeDefinitionIdentityLink(scopeDefinitionId, scopeType, userId, groupId);
    }


    public void deleteIdentityLinksByTaskId(string taskId) {
        getIdentityLinkEntityManager().deleteIdentityLinksByTaskId(taskId);
    }


    public void deleteIdentityLinksByProcessDefinitionId(string processDefinitionId) {
        getIdentityLinkEntityManager().deleteIdentityLinksByProcDef(processDefinitionId);
    }


    public void deleteIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        getIdentityLinkEntityManager().deleteIdentityLinksByScopeDefinitionIdAndScopeType(scopeDefinitionId, scopeType);
    }


    public void deleteIdentityLinksByScopeIdAndType(string scopeId, string scopeType) {
        getIdentityLinkEntityManager().deleteIdentityLinksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public void deleteIdentityLinksByProcessInstanceId(string processInstanceId) {
        getIdentityLinkEntityManager().deleteIdentityLinksByProcessInstanceId(processInstanceId);
    }

    public IdentityLinkEntityManager getIdentityLinkEntityManager() {
        return configuration.getIdentityLinkEntityManager();
    }
}
