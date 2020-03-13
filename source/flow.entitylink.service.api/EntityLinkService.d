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
module flow.entitylink.service.api.EntityLinkService;

import hunt.collection.List;
import flow.entitylink.service.api.EntityLink;

/**
 * Service which provides access to entity links.
 *
 * @author Tijs Rademakers
 */
interface EntityLinkService {

    EntityLink getEntityLink(string id);

    List!EntityLink findEntityLinksByScopeIdAndType(string scopeId, string scopeType, string linkType);

    List!EntityLink findEntityLinksByReferenceScopeIdAndType(string referenceScopeId, string scopeType, string linkType);

    List!EntityLink findEntityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType, string linkType);

    EntityLink createEntityLink();

    void insertEntityLink(EntityLink entityLink);

    void deleteEntityLink(EntityLink entityLink);

    List!EntityLink deleteScopeEntityLink(string scopeId, string scopeType, string linkType);

    List!EntityLink deleteScopeDefinitionEntityLink(string scopeDefinitionId, string scopeType, string linkType);

    void deleteEntityLinksByScopeIdAndType(string scopeId, string scopeType);

    void deleteEntityLinksByScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType);

}
