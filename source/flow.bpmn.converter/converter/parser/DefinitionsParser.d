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
module flow.bpmn.converter.converter.parser.DefinitionsParser;

import hunt.collection.ArrayList;
import hunt.collection.List;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionAttribute;
import hunt.xml;
import std.concurrency : initOnce;
/**
 * @author Tijs Rademakers
 */
class DefinitionsParser : BpmnXMLConstants {

    //protected static final List!ExtensionAttribute defaultAttributes = Arrays.asList(new ExtensionAttribute(TYPE_LANGUAGE_ATTRIBUTE), new ExtensionAttribute(EXPRESSION_LANGUAGE_ATTRIBUTE),
    //        new ExtensionAttribute(TARGET_NAMESPACE_ATTRIBUTE));

    static List!ExtensionAttribute defaultAttributes() {
      __gshared List!ExtensionAttribute inst;
      return initOnce!inst(new ArrayList!ExtensionAttribute([new ExtensionAttribute(TYPE_LANGUAGE_ATTRIBUTE),
      new ExtensionAttribute(EXPRESSION_LANGUAGE_ATTRIBUTE),
      new ExtensionAttribute(TARGET_NAMESPACE_ATTRIBUTE)
      ]));
    }

    public void parse(Element xtr, BpmnModel model)  {
        //model.setTargetNamespace(xtr.firstAttribute(TARGET_NAMESPACE_ATTRIBUTE) is null ? "" : xtr.firstAttribute(TARGET_NAMESPACE_ATTRIBUTE).getValue());
        //for (int i = 0; i < xtr.getNamespaceCount(); i++) {
        //    String prefix = xtr.getNamespacePrefix(i);
        //    if (StringUtils.isNotEmpty(prefix)) {
        //        model.addNamespace(prefix, xtr.getNamespaceURI(i));
        //    }
        //}
        //
        //for (int i = 0; i < xtr.getAttributeCount(); i++) {
        //    ExtensionAttribute extensionAttribute = new ExtensionAttribute();
        //    extensionAttribute.setName(xtr.getAttributeLocalName(i));
        //    extensionAttribute.setValue(xtr.getAttributeValue(i));
        //    if (StringUtils.isNotEmpty(xtr.getAttributeNamespace(i))) {
        //        extensionAttribute.setNamespace(xtr.getAttributeNamespace(i));
        //    }
        //    if (StringUtils.isNotEmpty(xtr.getAttributePrefix(i))) {
        //        extensionAttribute.setNamespacePrefix(xtr.getAttributePrefix(i));
        //    }
        //    if (!BpmnXMLUtil.isBlacklisted(extensionAttribute, defaultAttributes)) {
        //        model.addDefinitionsAttribute(extensionAttribute);
        //    }
        //}
    }
}
