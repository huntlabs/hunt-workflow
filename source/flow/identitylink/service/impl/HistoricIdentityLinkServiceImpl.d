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
module flow.identitylink.service.impl.HistoricIdentityLinkServiceImpl;

import hunt.collection.List;

import flow.common.service.CommonServiceImpl;
import flow.identitylink.service.HistoricIdentityLinkService;
import flow.identitylink.service.IdentityLinkServiceConfiguration;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntityManager;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricIdentityLinkServiceImpl : CommonServiceImpl!IdentityLinkServiceConfiguration , HistoricIdentityLinkService {

    this(IdentityLinkServiceConfiguration identityLinkServiceConfiguration) {
        super(identityLinkServiceConfiguration);
    }


    public HistoricIdentityLinkEntity getHistoricIdentityLink(string id) {
        return getHistoricIdentityLinkEntityManager().findById(id);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByTaskId(string taskId) {
        return getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksByTaskId(taskId);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByProcessInstanceId(string processInstanceId) {
        return getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksByProcessInstanceId(processInstanceId);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {
        return getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public List!HistoricIdentityLinkEntity findHistoricIdentityLinksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        return getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksBySubScopeIdAndScopeType(subScopeId, scopeType);
    }


    public HistoricIdentityLinkEntity createHistoricIdentityLink() {
        return getHistoricIdentityLinkEntityManager().create();
    }


    public void insertHistoricIdentityLink(HistoricIdentityLinkEntity identityLink, bool fireCreateEvent) {
        getHistoricIdentityLinkEntityManager().insert(identityLink, fireCreateEvent);
    }


    public void deleteHistoricIdentityLink(string id) {
        getHistoricIdentityLinkEntityManager().dele(id);
    }


    public void deleteHistoricIdentityLink(HistoricIdentityLinkEntity identityLink) {
        getHistoricIdentityLinkEntityManager().dele(identityLink);
    }


    public void deleteHistoricIdentityLinksByProcessInstanceId(string processInstanceId) {
        getHistoricIdentityLinkEntityManager().deleteHistoricIdentityLinksByProcInstance(processInstanceId);
    }


    public void deleteHistoricIdentityLinksByTaskId(string taskId) {
        getHistoricIdentityLinkEntityManager().deleteHistoricIdentityLinksByTaskId(taskId);
    }


    public void deleteHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType) {
        getHistoricIdentityLinkEntityManager().deleteHistoricIdentityLinksByScopeIdAndScopeType(scopeId, scopeType);
    }


    public void deleteHistoricProcessIdentityLinksForNonExistingInstances() {
        getHistoricIdentityLinkEntityManager().deleteHistoricProcessIdentityLinksForNonExistingInstances();
    }


    public void deleteHistoricCaseIdentityLinksForNonExistingInstances() {
        getHistoricIdentityLinkEntityManager().deleteHistoricCaseIdentityLinksForNonExistingInstances();
    }


    public void deleteHistoricTaskIdentityLinksForNonExistingInstances() {
        getHistoricIdentityLinkEntityManager().deleteHistoricTaskIdentityLinksForNonExistingInstances();
    }

    public HistoricIdentityLinkEntityManager getHistoricIdentityLinkEntityManager() {
        return configuration.getHistoricIdentityLinkEntityManager();
    }
}
