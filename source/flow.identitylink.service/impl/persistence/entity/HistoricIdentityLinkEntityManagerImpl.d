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

module flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityManagerImpl;

import hunt.collection.List;

import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.data.HistoricIdentityLinkDataManager;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityManager;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
/**
 * @author Frederik Heremans
 * @author Joram Barrez
 */
class HistoricIdentityLinkEntityManagerImpl
    : AbstractServiceEngineEntityManager!(IdentityLinkServiceConfiguration, HistoricIdentityLinkEntity, HistoricIdentityLinkDataManager)
    , HistoricIdentityLinkEntityManager {


    this(IdentityLinkServiceConfiguration identityLinkServiceConfiguration, HistoricIdentityLinkDataManager historicIdentityLinkDataManager) {
        super(identityLinkServiceConfiguration, historicIdentityLinkDataManager);
    }


    public HistoricIdentityLinkEntity create() {
        HistoricIdentityLinkEntity identityLinkEntity = super.create();
        identityLinkEntity.setCreateTime(getClock().getCurrentTime());
        return identityLinkEntity;
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByTaskId(string taskId) {
        return dataManager.findHistoricIdentityLinksByTaskId(taskId);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByProcessInstanceId(string processInstanceId) {
        return dataManager.findHistoricIdentityLinksByProcessInstanceId(processInstanceId);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {
        return dataManager.findHistoricIdentityLinksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return dataManager.findHistoricIdentityLinksBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public void deleteHistoricIdentityLinksByTaskId(string taskId) {
        List!HistoricIdentityLinkEntity identityLinks = findHistoricIdentityLinksByTaskId(taskId);
        foreach (HistoricIdentityLinkEntity identityLink ; identityLinks) {
            dele(identityLink);
        }
    }


    public void deleteHistoricIdentityLinksByProcInstance(string processInstanceId) {
        List!HistoricIdentityLinkEntity identityLinks = dataManager
                .findHistoricIdentityLinksByProcessInstanceId(processInstanceId);

        foreach (HistoricIdentityLinkEntity identityLink ; identityLinks) {
            dele(identityLink);
        }
    }


    public void deleteHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {
        dataManager.deleteHistoricIdentityLinksByScopeIdAndType(scopeId, scopeType);
    }


    public void deleteHistoricIdentityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType) {
        dataManager.deleteHistoricIdentityLinksByScopeDefinitionIdAndType(scopeDefinitionId, scopeType);
    }


    public void deleteHistoricProcessIdentityLinksForNonExistingInstances() {
        dataManager.deleteHistoricProcessIdentityLinksForNonExistingInstances();
    }


    public void deleteHistoricCaseIdentityLinksForNonExistingInstances() {
        dataManager.deleteHistoricCaseIdentityLinksForNonExistingInstances();
    }


    public void deleteHistoricTaskIdentityLinksForNonExistingInstances() {
        dataManager.deleteHistoricTaskIdentityLinksForNonExistingInstances();
    }

}
