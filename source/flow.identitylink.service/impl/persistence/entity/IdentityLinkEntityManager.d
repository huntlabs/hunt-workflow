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
module flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;

import hunt.collection;
import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
/**
 * @author Joram Barrez
 */
interface IdentityLinkEntityManager : EntityManager!IdentityLinkEntity {

    List!IdentityLinkEntity findIdentityLinksByTaskId(string taskId);

    List!IdentityLinkEntity findIdentityLinksByProcessInstanceId(string processInstanceId);

    List!IdentityLinkEntity findIdentityLinksByScopeIdAndType(string scopeId, string scopeType);

    List!IdentityLinkEntity findIdentityLinksBySubScopeIdAndType(string subScopeId, string scopeType);

    List!IdentityLinkEntity findIdentityLinksByProcessDefinitionId(string processDefinitionId);

    List!IdentityLinkEntity findIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

    List!IdentityLinkEntity findIdentityLinkByTaskUserGroupAndType(string taskId, string userId, string groupId, string type);

    List!IdentityLinkEntity findIdentityLinkByProcessInstanceUserGroupAndType(string processInstanceId, string userId, string groupId, string type);

    List!IdentityLinkEntity findIdentityLinkByProcessDefinitionUserAndGroup(string processDefinitionId, string userId, string groupId);

    List!IdentityLinkEntity findIdentityLinkByScopeIdScopeTypeUserGroupAndType(string scopeId, string scopeType, string userId, string groupId, string type);

    List!IdentityLinkEntity findIdentityLinkByScopeDefinitionScopeTypeUserAndGroup(string scopeDefinitionId, string scopeType, string userId, string groupId);

    IdentityLinkEntity addProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type);

    IdentityLinkEntity addScopeIdentityLink(string scopeDefinitionId, string scopeId, string scopeType, string userId, string groupId, string type);

    IdentityLinkEntity addSubScopeIdentityLink(string scopeDefinitionId, string scopeId, string subScopeId, string scopeType,
                    string userId, string groupId, string type);

    IdentityLinkEntity addTaskIdentityLink(string taskId, string userId, string groupId, string type);

    IdentityLinkEntity addProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId);

    IdentityLinkEntity addScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId);

    IdentityLinkEntity addCandidateUser(string taskId, string userId);

    List!IdentityLinkEntity addCandidateUsers(string taskId, Collection!string candidateUsers);

    IdentityLinkEntity addCandidateGroup(string taskId, string groupId);

    List!IdentityLinkEntity addCandidateGroups(string taskId, Collection!string candidateGroups);

    List!IdentityLinkEntity deleteProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteScopeIdentityLink(string scopeId, string scopeType, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteTaskIdentityLink(string taskId, List!IdentityLinkEntity currentIdentityLinks, string userId, string groupId, string type);

    List!IdentityLinkEntity deleteProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId);

    List!IdentityLinkEntity deleteScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId);

    void deleteIdentityLinksByTaskId(string taskId);

    void deleteIdentityLinksByProcDef(string processDefId);

    void deleteIdentityLinksByProcessInstanceId(string processInstanceId);

    void deleteIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType);

    void deleteIdentityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType);

}
