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
module flow.identitylink.service.impl.persistence.entity.data.HistoricIdentityLinkDataManager;

import hunt.collection.List;

import flow.common.persistence.entity.data.DataManager;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;

/**
 * @author Joram Barrez
 */
interface HistoricIdentityLinkDataManager : DataManager!HistoricIdentityLinkEntity {

    List!HistoricIdentityLinkEntity findHistoricIdentityLinksByTaskId(string taskId);

    List!HistoricIdentityLinkEntity findHistoricIdentityLinksByProcessInstanceId(string processInstanceId);

    List!HistoricIdentityLinkEntity findHistoricIdentityLinksByScopeIdAndScopeType(string scopeId, string scopeType);

    List!HistoricIdentityLinkEntity findHistoricIdentityLinksBySubScopeIdAndScopeType(string subScopeId, string scopeType);

    void deleteHistoricIdentityLinksByScopeIdAndType(string scopeId, string scopeType);

    void deleteHistoricIdentityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

    void deleteHistoricProcessIdentityLinksForNonExistingInstances();

    void deleteHistoricCaseIdentityLinksForNonExistingInstances();

    void deleteHistoricTaskIdentityLinksForNonExistingInstances();
}
