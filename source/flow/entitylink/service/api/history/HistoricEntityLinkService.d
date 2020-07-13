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
module flow.entitylink.service.api.history.HistoricEntityLinkService;

import flow.entitylink.service.api.history.HistoricEntityLink;
import hunt.collection.List;

/**
 * Service which provides access to historic entity links.
 *
 * @author Tijs Rademakers
 */
interface HistoricEntityLinkService {

    HistoricEntityLink getHistoricEntityLink(string id);

    List!HistoricEntityLink findHistoricEntityLinksByScopeIdAndScopeType(string scopeId, string scopeType, string linkType);

    List!HistoricEntityLink findHistoricEntityLinksByReferenceScopeIdAndType(string referenceScopeId, string scopeType, string linkType);

    List!HistoricEntityLink findHistoricEntityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType, string linkType);

    HistoricEntityLink createHistoricEntityLink();

    void insertHistoricEntityLink(HistoricEntityLink entityLink, bool fireCreateEvent);

    void deleteHistoricEntityLink(string id);

    void deleteHistoricEntityLink(HistoricEntityLink entityLink);

    void deleteHistoricEntityLinksByScopeIdAndScopeType(string scopeId, string scopeType);

    void deleteHistoricEntityLinksByScopeDefinitionIdAndScopeType(string scopeDefinitionId, string scopeType);

    void deleteHistoricEntityLinksForNonExistingProcessInstances();

    void deleteHistoricEntityLinksForNonExistingCaseInstances();
}
