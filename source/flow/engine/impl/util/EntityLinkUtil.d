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
module flow.engine.impl.util.EntityLinkUtil;

import hunt.collection.ArrayList;
import hunt.collection.List;
//import java.util.Optional;

import flow.common.api.scop.ScopeTypes;
import flow.entitylink.service.api.EntityLink;
import flow.entitylink.service.api.EntityLinkService;
import flow.entitylink.service.api.EntityLinkType;
import flow.entitylink.service.api.HierarchyType;
import flow.entitylink.service.impl.persistence.entity.EntityLinkEntity;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class EntityLinkUtil {

    public static void copyExistingEntityLinks(string scopeId, string referenceScopeId, string referenceScopeType) {
        EntityLinkService entityLinkService = CommandContextUtil.getEntityLinkService();
        List!EntityLink entityLinks = entityLinkService.findEntityLinksByReferenceScopeIdAndType(scopeId, ScopeTypes.BPMN, EntityLinkType.CHILD);
        List!string parentIds = new ArrayList!string();
        foreach (EntityLink entityLink ; entityLinks) {
            if (!parentIds.contains(entityLink.getScopeId())) {
                EntityLinkEntity newEntityLink = cast(EntityLinkEntity) entityLinkService.createEntityLink();
                newEntityLink.setLinkType(EntityLinkType.CHILD);
                newEntityLink.setScopeId(entityLink.getScopeId());
                newEntityLink.setScopeType(entityLink.getScopeType());
                newEntityLink.setScopeDefinitionId(entityLink.getScopeDefinitionId());
                newEntityLink.setReferenceScopeId(referenceScopeId);
                newEntityLink.setReferenceScopeType(referenceScopeType);
                if (HierarchyType.ROOT == (entityLink.getHierarchyType())) {
                    newEntityLink.setHierarchyType(entityLink.getHierarchyType());
                }
                entityLinkService.insertEntityLink(newEntityLink);

                CommandContextUtil.getHistoryManager().recordEntityLinkCreated(newEntityLink);

                parentIds.add(entityLink.getScopeId());
            }
        }
    }

    public static void createNewEntityLink(string scopeId, string referenceScopeId, string referenceScopeType) {
        implementationMissing(false);
        //EntityLinkService entityLinkService = CommandContextUtil.getEntityLinkService();
        //
        //// Check if existing links already have root, if not, current is root
        //Optional!EntityLink entityLinkWithRoot = entityLinkService
        //    .findEntityLinksByReferenceScopeIdAndType(scopeId, ScopeTypes.BPMN, EntityLinkType.CHILD)
        //    .stream()
        //    .filter(e -> HierarchyType.ROOT.equals(e.getHierarchyType()))
        //    .findFirst();
        //
        //EntityLinkEntity newEntityLink = (EntityLinkEntity) entityLinkService.createEntityLink();
        //newEntityLink.setLinkType(EntityLinkType.CHILD);
        //newEntityLink.setScopeId(scopeId);
        //newEntityLink.setScopeType(ScopeTypes.BPMN);
        //newEntityLink.setReferenceScopeId(referenceScopeId);
        //newEntityLink.setReferenceScopeType(referenceScopeType);
        //if (!entityLinkWithRoot.isPresent()) {
        //    newEntityLink.setHierarchyType(HierarchyType.ROOT);
        //} else {
        //    newEntityLink.setHierarchyType(HierarchyType.PARENT);
        //}
        //entityLinkService.insertEntityLink(newEntityLink);
        //
        //CommandContextUtil.getHistoryManager().recordEntityLinkCreated(newEntityLink);
    }

}
