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


import java.util.Arrays;
import hunt.collection.List;

import javax.xml.stream.XMLStreamReader;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionAttribute;

/**
 * @author Tijs Rademakers
 */
public class DefinitionsParser implements BpmnXMLConstants {

    protected static final List<ExtensionAttribute> defaultAttributes = Arrays.asList(new ExtensionAttribute(TYPE_LANGUAGE_ATTRIBUTE), new ExtensionAttribute(EXPRESSION_LANGUAGE_ATTRIBUTE),
            new ExtensionAttribute(TARGET_NAMESPACE_ATTRIBUTE));

    @SuppressWarnings("unchecked")
    public void parse(XMLStreamReader xtr, BpmnModel model) throws Exception {
        model.setTargetNamespace(xtr.getAttributeValue(null, TARGET_NAMESPACE_ATTRIBUTE));
        for (int i = 0; i < xtr.getNamespaceCount(); i++) {
            String prefix = xtr.getNamespacePrefix(i);
            if (StringUtils.isNotEmpty(prefix)) {
                model.addNamespace(prefix, xtr.getNamespaceURI(i));
            }
        }

        for (int i = 0; i < xtr.getAttributeCount(); i++) {
            ExtensionAttribute extensionAttribute = new ExtensionAttribute();
            extensionAttribute.setName(xtr.getAttributeLocalName(i));
            extensionAttribute.setValue(xtr.getAttributeValue(i));
            if (StringUtils.isNotEmpty(xtr.getAttributeNamespace(i))) {
                extensionAttribute.setNamespace(xtr.getAttributeNamespace(i));
            }
            if (StringUtils.isNotEmpty(xtr.getAttributePrefix(i))) {
                extensionAttribute.setNamespacePrefix(xtr.getAttributePrefix(i));
            }
            if (!BpmnXMLUtil.isBlacklisted(extensionAttribute, defaultAttributes)) {
                model.addDefinitionsAttribute(extensionAttribute);
            }
        }
    }
}
