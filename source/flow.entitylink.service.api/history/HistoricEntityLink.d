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
module flow.entitylink.service.api.history.HistoricEntityLink;


import hunt.time.LocalDateTime;

import flow.entitylink.service.api.EntityLink;

/**
 * Historic counterpart of {@link EntityLink} that represents the current state if any runtime link.
 *
 * @author Tijs Rademakers
 */
interface HistoricEntityLink {

    /**
     * Returns the type of link. See for the native supported types.
     */
    string getLinkType();

    /**
     * Returns the scope id of the originating entity
     */
    string getScopeId();

    /**
     * The scope type associated with the originating entity
     */
    string getScopeType();

    /**
     * A scope definition id for the originating entity
     */
    string getScopeDefinitionId();

    /**
     * Returns the scope id of the referenced entity
     */
    string getReferenceScopeId();

    /**
     * The scope type associated with the referenced entity
     */
    string getReferenceScopeType();

    /**
     * A scope definition id for the referenced entity
     */
    string getReferenceScopeDefinitionId();

    /**
     * Returns the hierarchy type for the entity link e.g. root, parent or empty
     */
    string getHierarchyType();

    /**
     * The create time for the entity link
     */
    Date getCreateTime();
}
