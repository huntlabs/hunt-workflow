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

module flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManagerImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.IdentityLinkEventHandler;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.data.IdentityLinkDataManager;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;

/**
 * @author Tom Baeyens
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */
class IdentityLinkEntityManagerImpl
        : AbstractServiceEngineEntityManager!(IdentityLinkServiceConfiguration, IdentityLinkEntity, IdentityLinkDataManager)
        , IdentityLinkEntityManager {

    this(IdentityLinkServiceConfiguration identityLinkServiceConfiguration, IdentityLinkDataManager identityLinkDataManager) {
        super(identityLinkServiceConfiguration, identityLinkDataManager);
    }

    override
    public void insert(IdentityLinkEntity entity, bool fireCreateEvent) {
        super.insert(entity, fireCreateEvent);

        IdentityLinkEventHandler identityLinkEventHandler = getIdentityLinkEventHandler();
        if (identityLinkEventHandler !is null) {
            identityLinkEventHandler.handleIdentityLinkAddition(entity);
        }
    }

    override
    public void dele(IdentityLinkEntity entity, bool fireDeleteEvent) {
        super.dele(entity, fireDeleteEvent);

        IdentityLinkEventHandler identityLinkEventHandler = getIdentityLinkEventHandler();
        if (identityLinkEventHandler !is null) {
            getIdentityLinkEventHandler().handleIdentityLinkDeletion(entity);
        }
    }

    public List!IdentityLinkEntity findIdentityLinksByTaskId(string taskId) {
        return dataManager.findIdentityLinksByTaskId(taskId);
    }


    public List!IdentityLinkEntity findIdentityLinksByProcessInstanceId(string processInstanceId) {
        return dataManager.findIdentityLinksByProcessInstanceId(processInstanceId);
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeIdAndType(string scopeId, string scopeType) {
        return dataManager.findIdentityLinksByScopeIdAndType(scopeId, scopeType);
    }


    public List!IdentityLinkEntity findIdentityLinksBySubScopeIdAndType(string subScopeId, string scopeType) {
        return dataManager.findIdentityLinksBySubScopeIdAndType(subScopeId, scopeType);
    }


    public List!IdentityLinkEntity findIdentityLinksByProcessDefinitionId(string processDefinitionId) {
        return dataManager.findIdentityLinksByProcessDefinitionId(processDefinitionId);
    }


    public List!IdentityLinkEntity findIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        return dataManager.findIdentityLinksByScopeDefinitionIdAndType(scopeDefinitionId, scopeType);
    }


    public List!IdentityLinkEntity findIdentityLinkByTaskUserGroupAndType(string taskId, string userId, string groupId, string type) {
        return dataManager.findIdentityLinkByTaskUserGroupAndType(taskId, userId, groupId, type);
    }


    public List!IdentityLinkEntity findIdentityLinkByProcessInstanceUserGroupAndType(string processInstanceId, string userId, string groupId, string type) {
        return dataManager.findIdentityLinkByProcessInstanceUserGroupAndType(processInstanceId, userId, groupId, type);
    }


    public List!IdentityLinkEntity findIdentityLinkByProcessDefinitionUserAndGroup(string processDefinitionId, string userId, string groupId) {
        return dataManager.findIdentityLinkByProcessDefinitionUserAndGroup(processDefinitionId, userId, groupId);
    }


    public List!IdentityLinkEntity findIdentityLinkByScopeIdScopeTypeUserGroupAndType(string scopeId, string scopeType, string userId, string groupId, string type) {
        return dataManager.findIdentityLinkByScopeIdScopeTypeUserGroupAndType(scopeId, scopeType, userId, groupId, type);
    }


    public List!IdentityLinkEntity findIdentityLinkByScopeDefinitionScopeTypeUserAndGroup(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        return dataManager.findIdentityLinkByScopeDefinitionScopeTypeUserAndGroup(scopeDefinitionId, scopeType, userId, groupId);
    }


    public IdentityLinkEntity addProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type) {
        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setProcessInstanceId(processInstanceId);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(type);
        super.insert(identityLinkEntity);
        return identityLinkEntity;
    }


    public IdentityLinkEntity addScopeIdentityLink(string scopeDefinitionId, string scopeId, string scopeType, string userId, string groupId, string type) {
        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setScopeDefinitionId(scopeDefinitionId);
        identityLinkEntity.setScopeId(scopeId);
        identityLinkEntity.setScopeType(scopeType);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(type);
        super.insert(identityLinkEntity);
        return identityLinkEntity;
    }


    public IdentityLinkEntity addSubScopeIdentityLink(string scopeDefinitionId, string scopeId, string subScopeId, string scopeType,
                    string userId, string groupId, string type) {

        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setScopeDefinitionId(scopeDefinitionId);
        identityLinkEntity.setScopeId(scopeId);
        identityLinkEntity.setSubScopeId(subScopeId);
        identityLinkEntity.setScopeType(scopeType);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(type);
        super.insert(identityLinkEntity);
        return identityLinkEntity;
    }


    public IdentityLinkEntity addTaskIdentityLink(string taskId, string userId, string groupId, string type) {
        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setTaskId(taskId);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(type);
        super.insert(identityLinkEntity);

        return identityLinkEntity;
    }


    public IdentityLinkEntity addProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId) {
        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setProcessDefId(processDefinitionId);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(IdentityLinkType.CANDIDATE);
        super.insert(identityLinkEntity);
        return identityLinkEntity;
    }


    public IdentityLinkEntity addScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        IdentityLinkEntity identityLinkEntity = dataManager.create();
        identityLinkEntity.setScopeDefinitionId(scopeDefinitionId);
        identityLinkEntity.setScopeType(scopeType);
        identityLinkEntity.setUserId(userId);
        identityLinkEntity.setGroupId(groupId);
        identityLinkEntity.setType(IdentityLinkType.CANDIDATE);
        super.insert(identityLinkEntity);
        return identityLinkEntity;
    }


    public IdentityLinkEntity addCandidateUser(string taskId, string userId) {
        return addTaskIdentityLink(taskId, userId, null, IdentityLinkType.CANDIDATE);
    }


    public List!IdentityLinkEntity addCandidateUsers(string taskId, Collection!string candidateUsers) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        foreach (string candidateUser ; candidateUsers) {
            identityLinks.add(addCandidateUser(taskId, candidateUser));
        }

        return identityLinks;
    }


    public IdentityLinkEntity addCandidateGroup(string taskId, string groupId) {
        return addTaskIdentityLink(taskId, null, groupId, IdentityLinkType.CANDIDATE);
    }


    public List!IdentityLinkEntity addCandidateGroups(string taskId, Collection!string candidateGroups) {
        List!IdentityLinkEntity identityLinks = new ArrayList!IdentityLinkEntity();
        foreach (string candidateGroup ; candidateGroups) {
            identityLinks.add(addCandidateGroup(taskId, candidateGroup));
        }
        return identityLinks;
    }


    public List!IdentityLinkEntity deleteProcessInstanceIdentityLink(string processInstanceId, string userId, string groupId, string type) {
        List!IdentityLinkEntity identityLinks = findIdentityLinkByProcessInstanceUserGroupAndType(processInstanceId, userId, groupId, type);

        foreach (IdentityLinkEntity identityLink ; identityLinks) {
            super.dele(identityLink);
        }

        return identityLinks;
    }


    public List!IdentityLinkEntity deleteScopeIdentityLink(string scopeId, string scopeType, string userId, string groupId, string type) {
        List!IdentityLinkEntity identityLinks = findIdentityLinkByScopeIdScopeTypeUserGroupAndType(scopeId, scopeType, userId, groupId, type);

        foreach (IdentityLinkEntity identityLink ; identityLinks) {
            deleteIdentityLink(identityLink);
        }

        return identityLinks;
    }


    public List!IdentityLinkEntity deleteTaskIdentityLink(string taskId, List!IdentityLinkEntity currentIdentityLinks, string userId, string groupId, string type) {
        List!IdentityLinkEntity identityLinks = findIdentityLinkByTaskUserGroupAndType(taskId, userId, groupId, type);

        List!IdentityLinkEntity removedIdentityLinkEntities = new ArrayList!IdentityLinkEntity();
        foreach (IdentityLinkEntity identityLink ; identityLinks) {
            super.dele(identityLink);
            removedIdentityLinkEntities.add(identityLink);
        }

        if (currentIdentityLinks !is null) { // The currentIdentityLinks might contain identity links that are in the cache, but not yet in the db
            foreach (IdentityLinkEntity identityLinkEntity ; currentIdentityLinks) {
                if (type == (identityLinkEntity.getType()) && !contains(removedIdentityLinkEntities, identityLinkEntity.getId())) {

                    if ((userId !is null && userId == (identityLinkEntity.getUserId()))
                            || (groupId !is null && groupId ==(identityLinkEntity.getGroupId()))) {

                        super.dele(identityLinkEntity);
                        removedIdentityLinkEntities.add(identityLinkEntity);

                    }
                }
            }
        }

        return removedIdentityLinkEntities;
    }

    protected bool contains(List!IdentityLinkEntity identityLinkEntities, string identityLinkId) {
        foreach(IdentityLinkEntity identityLinkEntity ; identityLinkEntities)
        {
          if (identityLinkEntity.getId() == identityLinkId)
          {
              return true;
          }
        }
        return false;
        //return identityLinkEntities.stream().anyMatch(identityLinkEntity -> Objects.equals(identityLinkId, identityLinkEntity.getId()));
    }


    public List!IdentityLinkEntity deleteProcessDefinitionIdentityLink(string processDefinitionId, string userId, string groupId) {
        List!IdentityLinkEntity identityLinks = findIdentityLinkByProcessDefinitionUserAndGroup(processDefinitionId, userId, groupId);
        foreach (IdentityLinkEntity identityLink ; identityLinks) {
            super.dele(identityLink);
        }

        return identityLinks;
    }


    public List!IdentityLinkEntity deleteScopeDefinitionIdentityLink(string scopeDefinitionId, string scopeType, string userId, string groupId) {
        List!IdentityLinkEntity identityLinks = findIdentityLinkByScopeDefinitionScopeTypeUserAndGroup(scopeDefinitionId, scopeType, userId, groupId);
        foreach (IdentityLinkEntity identityLink ; identityLinks) {
            deleteIdentityLink(identityLink);
        }

        return identityLinks;
    }

    public void deleteIdentityLink(IdentityLinkEntity identityLink) {
        super.dele(identityLink);
    }


    public void deleteIdentityLinksByTaskId(string taskId) {
        dataManager.deleteIdentityLinksByTaskId(taskId);
    }


    public void deleteIdentityLinksByProcDef(string processDefId) {
        dataManager.deleteIdentityLinksByProcDef(processDefId);
    }


    public void deleteIdentityLinksByProcessInstanceId(string processInstanceId) {
        dataManager.deleteIdentityLinksByProcessInstanceId(processInstanceId);
    }


    public void deleteIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {
        dataManager.deleteIdentityLinksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public void deleteIdentityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType) {
        dataManager.deleteIdentityLinksByScopeDefinitionIdAndScopeType(scopeDefinitionId, scopeType);
    }

    protected IdentityLinkEventHandler getIdentityLinkEventHandler() {
        return serviceConfiguration.getIdentityLinkEventHandler();
    }

}
