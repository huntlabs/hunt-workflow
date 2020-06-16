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
module flow.entitylink.service.impl.persistence.entity.EntityLinkEntity;


import flow.common.persistence.entity.Entity;
import flow.entitylink.service.api.EntityLink;

/**
 * @author Tijs Rademakers
 */
interface EntityLinkEntity : EntityLink, Entity {

    void setLinkType(string linkType);

    void setScopeId(string scopeId);

    void setScopeType(string scopeType);

    void setScopeDefinitionId(string scopeDefinitionId);

    void setReferenceScopeId(string referenceScopeId);

    void setReferenceScopeType(string referenceScopeType);

    void setReferenceScopeDefinitionId(string referenceScopeDefinitionId);

    void setHierarchyType(string hierarchyType);

    void setCreateTime(Date createTime);
}
