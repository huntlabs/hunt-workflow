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
module flow.identitylink.service.IdentityLinkService;

import hunt.collection;
import hunt.collection.List;

import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;

/**
 * Service which provides access to variables.
 *
 * @author Tijs Rademakers
 */
interface IdentityLinkService {

    IdentityLinkEntity getIdentityLink(string id);

    List!IdentityLinkEntity findIdentityLinksByTaskId(string taskId);

    List!IdentityLinkEntity findIdentityLinksByProcessInstanceId(string processInstanceId);

    List!IdentityLinkEntity findIdentityLinksByScopeIdAndType(string scopeId, string scopeType);

    List!IdentityLinkEntity findIdentityLinksBySubScopeIdAndType(string subScopeId, string scopeType);

    List!IdentityLinkEntity findIdentityLinksByProcessDefinitionId(string processDefinitionId);

    List!IdentityLinkEntity findIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

    IdentityLinkEntity addCandidateUser(string taskId, string userId);

    List!IdentityLinkEntity addCandidateUsers(string taskId, Collection!string candidateUsers);

    IdentityLinkEntity addCandidateGroup(string taskId, string groupId);

    List!IdentityLinkEntity addCandidateGroups(string taskId, Collection!string candidateGroups);

    IdentityLinkEntity createProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type);

    IdentityLinkEntity createScopeIdentityLink(string scopeDefinitionId, string scopeId, string scopeType, string userId, string groupId, string type);
    IdentityLinkEntity createSubScopeIdentityLink(string scopeDefinitionId, string scopeId, string subScopeId, string scopeType,
                    string userId, string groupId, string type);

    IdentityLinkEntity createTaskIdentityLink(string taskId, string userId, string groupId, string type);

    IdentityLinkEntity createProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId);

    IdentityLinkEntity createScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId);

    IdentityLinkEntity createIdentityLink();

    void insertIdentityLink(IdentityLinkEntity identityLink);

    void deleteIdentityLink(IdentityLinkEntity identityLink);

    List!IdentityLinkEntity deleteProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteScopeIdentityLink(string scopeId, string scopeType, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteTaskIdentityLink(string taskId, List!IdentityLinkEntity currentIdentityLinks, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId);

    List!IdentityLinkEntity deleteScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId);

    void deleteIdentityLinksByTaskId(string taskId);

    void deleteIdentityLinksByProcessDefinitionId(string processDefinitionId);

    void deleteIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

    void deleteIdentityLinksByScopeIdAndType(string scopeId, string scopeType);

    void deleteIdentityLinksByProcessInstanceId(string processInstanceId);

}
