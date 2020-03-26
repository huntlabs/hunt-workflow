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
module flow.bpmn.converter.converter.parser.ItemDefinitionParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ItemDefinition;
import hunt.xml;
import std.string;
/**
 * @author Tijs Rademakers
 */
class ItemDefinitionParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        if (xtr.firstAttribute(ATTRIBUTE_ID) !is null && xtr.firstAttribute(ATTRIBUTE_ID).getValue.length != 0) {
            string itemDefinitionId = model.getTargetNamespace() ~ ":" ~ xtr.firstAttribute(ATTRIBUTE_ID).getValue;
            string structureRef = xtr.firstAttribute(ATTRIBUTE_STRUCTURE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_STRUCTURE_REF).getValue;
            if (structureRef.length != 0) {
                ItemDefinition item = new ItemDefinition();
                item.setId(itemDefinitionId);
                BpmnXMLUtil.addXMLLocation(item, xtr);

                int indexOfP = structureRef.indexOf(':');
                if (indexOfP != -1) {
                    string prefix = structureRef[0 .. indexOfP];
                    string resolvedNamespace = model.getNamespace(prefix);
                    structureRef = resolvedNamespace ~ ":" ~ structureRef[indexOfP + 1 .. $];
                } else {
                    structureRef = model.getTargetNamespace() ~ ":" ~ structureRef;
                }

                item.setStructureRef(structureRef);
                item.setItemKind(xtr.firstAttribute(ATTRIBUTE_ITEM_KIND) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ITEM_KIND).getValue);
                BpmnXMLUtil.parseChildElements(ELEMENT_ITEM_DEFINITION, item, xtr, model);
                model.addItemDefinition(itemDefinitionId, item);
            }
        }
    }
}
