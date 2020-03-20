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


import java.text.StringCharacterIterator;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import java.util.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;

import javax.xml.stream.Location;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.converter.child.CancelEventDefinitionParser;
import flow.bpmn.converter.converter.child.CompensateEventDefinitionParser;
import flow.bpmn.converter.converter.child.ConditionExpressionParser;
import flow.bpmn.converter.converter.child.ConditionParser;
import flow.bpmn.converter.converter.child.ConditionalEventDefinitionParser;
import flow.bpmn.converter.converter.child.DataInputAssociationParser;
import flow.bpmn.converter.converter.child.DataOutputAssociationParser;
import flow.bpmn.converter.converter.child.DataStateParser;
import flow.bpmn.converter.converter.child.DocumentationParser;
import flow.bpmn.converter.converter.child.ErrorEventDefinitionParser;
import flow.bpmn.converter.converter.child.EscalationEventDefinitionParser;
import flow.bpmn.converter.converter.child.ExecutionListenerParser;
import flow.bpmn.converter.converter.child.FieldExtensionParser;
import flow.bpmn.converter.converter.child.FlowNodeRefParser;
import flow.bpmn.converter.converter.child.FlowableEventListenerParser;
import flow.bpmn.converter.converter.child.FlowableFailedjobRetryParser;
import flow.bpmn.converter.converter.child.FlowableHttpRequestHandlerParser;
import flow.bpmn.converter.converter.child.FlowableHttpResponseHandlerParser;
import flow.bpmn.converter.converter.child.FlowableMapExceptionParser;
import flow.bpmn.converter.converter.child.FormPropertyParser;
import flow.bpmn.converter.converter.child.IOSpecificationParser;
import flow.bpmn.converter.converter.child.MessageEventDefinitionParser;
import flow.bpmn.converter.converter.child.MultiInstanceParser;
import flow.bpmn.converter.converter.child.SignalEventDefinitionParser;
import flow.bpmn.converter.converter.child.TaskListenerParser;
import flow.bpmn.converter.converter.child.TerminateEventDefinitionParser;
import flow.bpmn.converter.converter.child.TimeCycleParser;
import flow.bpmn.converter.converter.child.TimeDateParser;
import flow.bpmn.converter.converter.child.TimeDurationParser;
import flow.bpmn.converter.converter.child.TimerEventDefinitionParser;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionAttribute;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.GraphicInfo;
import flow.bpmn.model.IOParameter;

public class BpmnXMLUtil implements BpmnXMLConstants {

    private static Map<String, BaseChildElementParser> genericChildParserMap = new HashMap<>();

    static {
        addGenericParser(new CancelEventDefinitionParser());
        addGenericParser(new CompensateEventDefinitionParser());
        addGenericParser(new ConditionalEventDefinitionParser());
        addGenericParser(new ConditionParser());
        addGenericParser(new ConditionExpressionParser());
        addGenericParser(new DataInputAssociationParser());
        addGenericParser(new DataOutputAssociationParser());
        addGenericParser(new DataStateParser());
        addGenericParser(new DocumentationParser());
        addGenericParser(new ErrorEventDefinitionParser());
        addGenericParser(new EscalationEventDefinitionParser());
        addGenericParser(new ExecutionListenerParser());
        addGenericParser(new FieldExtensionParser());
        addGenericParser(new FlowableEventListenerParser());
        addGenericParser(new FlowableHttpRequestHandlerParser());
        addGenericParser(new FlowableHttpResponseHandlerParser());
        addGenericParser(new FormPropertyParser());
        addGenericParser(new IOSpecificationParser());
        addGenericParser(new MessageEventDefinitionParser());
        addGenericParser(new MultiInstanceParser());
        addGenericParser(new SignalEventDefinitionParser());
        addGenericParser(new TaskListenerParser());
        addGenericParser(new TerminateEventDefinitionParser());
        addGenericParser(new TimerEventDefinitionParser());
        addGenericParser(new TimeDateParser());
        addGenericParser(new TimeCycleParser());
        addGenericParser(new TimeDurationParser());
        addGenericParser(new FlowNodeRefParser());
        addGenericParser(new FlowableFailedjobRetryParser());
        addGenericParser(new FlowableMapExceptionParser());
    }

    private static void addGenericParser(BaseChildElementParser parser) {
        genericChildParserMap.put(parser.getElementName(), parser);
    }

    public static void addXMLLocation(BaseElement element, XMLStreamReader xtr) {
        Location location = xtr.getLocation();
        element.setXmlRowNumber(location.getLineNumber());
        element.setXmlColumnNumber(location.getColumnNumber());
    }

    public static void addXMLLocation(GraphicInfo graphicInfo, XMLStreamReader xtr) {
        Location location = xtr.getLocation();
        graphicInfo.setXmlRowNumber(location.getLineNumber());
        graphicInfo.setXmlColumnNumber(location.getColumnNumber());
    }

    public static void parseChildElements(String elementName, BaseElement parentElement, XMLStreamReader xtr, BpmnModel model) throws Exception {
        parseChildElements(elementName, parentElement, xtr, null, model);
    }

    public static void parseChildElements(String elementName, BaseElement parentElement, XMLStreamReader xtr,
            Map<String, BaseChildElementParser> childParsers, BpmnModel model) throws Exception {

        Map<String, BaseChildElementParser> localParserMap = new HashMap<>(genericChildParserMap);
        if (childParsers != null) {
            localParserMap.putAll(childParsers);
        }

        boolean inExtensionElements = false;
        boolean readyWithChildElements = false;
        while (!readyWithChildElements && xtr.hasNext()) {
            xtr.next();
            if (xtr.isStartElement()) {
                if (ELEMENT_EXTENSIONS.equals(xtr.getLocalName())) {
                    inExtensionElements = true;
                } else if (localParserMap.containsKey(xtr.getLocalName())) {
                    BaseChildElementParser childParser = localParserMap.get(xtr.getLocalName());
                    // if we're into an extension element but the current element is not accepted by this parentElement then is read as a custom extension element
                    if (inExtensionElements && !childParser.accepts(parentElement)) {
                        ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(xtr);
                        parentElement.addExtensionElement(extensionElement);
                        continue;
                    }
                    localParserMap.get(xtr.getLocalName()).parseChildElement(xtr, parentElement, model);
                } else if (inExtensionElements) {
                    ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(xtr);
                    parentElement.addExtensionElement(extensionElement);
                }

            } else if (xtr.isEndElement()) {
                if (ELEMENT_EXTENSIONS.equals(xtr.getLocalName())) {
                    inExtensionElements = false;
                }

                if (elementName.equalsIgnoreCase(xtr.getLocalName())) {
                    readyWithChildElements = true;
                }
            }
        }
    }

    public static ExtensionElement parseExtensionElement(XMLStreamReader xtr) throws Exception {
        ExtensionElement extensionElement = new ExtensionElement();
        extensionElement.setName(xtr.getLocalName());
        if (StringUtils.isNotEmpty(xtr.getNamespaceURI())) {
            extensionElement.setNamespace(xtr.getNamespaceURI());
        }
        if (StringUtils.isNotEmpty(xtr.getPrefix())) {
            extensionElement.setNamespacePrefix(xtr.getPrefix());
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
            extensionElement.addAttribute(extensionAttribute);
        }

        boolean readyWithExtensionElement = false;
        while (!readyWithExtensionElement && xtr.hasNext()) {
            xtr.next();
            if (xtr.isCharacters() || XMLStreamReader.CDATA == xtr.getEventType()) {
                if (StringUtils.isNotEmpty(xtr.getText().trim())) {
                    extensionElement.setElementText(xtr.getText().trim());
                }
            } else if (xtr.isStartElement()) {
                ExtensionElement childExtensionElement = parseExtensionElement(xtr);
                extensionElement.addChildElement(childExtensionElement);
            } else if (xtr.isEndElement() && extensionElement.getName().equalsIgnoreCase(xtr.getLocalName())) {
                readyWithExtensionElement = true;
            }
        }
        return extensionElement;
    }

    public static String getAttributeValue(String attributeName, XMLStreamReader xtr) {
        String attributeValue = xtr.getAttributeValue(FLOWABLE_EXTENSIONS_NAMESPACE, attributeName);
        if (attributeValue == null) {
            attributeValue = xtr.getAttributeValue(ACTIVITI_EXTENSIONS_NAMESPACE, attributeName);
        }

        return attributeValue;
    }

    public static void writeDefaultAttribute(String attributeName, String value, XMLStreamWriter xtw) throws Exception {
        if (StringUtils.isNotEmpty(value) && !"null".equalsIgnoreCase(value)) {
            xtw.writeAttribute(attributeName, value);
        }
    }

    public static void writeQualifiedAttribute(String attributeName, String value, XMLStreamWriter xtw) throws Exception {
        if (StringUtils.isNotEmpty(value)) {
            xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, attributeName, value);
        }
    }

    public static boolean writeExtensionElements(BaseElement baseElement, boolean didWriteExtensionStartElement, XMLStreamWriter xtw) throws Exception {
        return writeExtensionElements(baseElement, didWriteExtensionStartElement, null, xtw);
    }

    public static boolean writeExtensionElements(BaseElement baseElement, boolean didWriteExtensionStartElement, Map<String, String> namespaceMap, XMLStreamWriter xtw) throws Exception {
        if (!baseElement.getExtensionElements().isEmpty()) {
            if (!didWriteExtensionStartElement) {
                xtw.writeStartElement(ELEMENT_EXTENSIONS);
                didWriteExtensionStartElement = true;
            }

            if (namespaceMap == null) {
                namespaceMap = new HashMap<>();
            }

            for (List<ExtensionElement> extensionElements : baseElement.getExtensionElements().values()) {
                for (ExtensionElement extensionElement : extensionElements) {
                    writeExtensionElement(extensionElement, namespaceMap, xtw);
                }
            }
        }
        return didWriteExtensionStartElement;
    }

    protected static void writeExtensionElement(ExtensionElement extensionElement, Map<String, String> namespaceMap, XMLStreamWriter xtw) throws Exception {
        if (StringUtils.isNotEmpty(extensionElement.getName())) {
            Map<String, String> localNamespaceMap = new HashMap<>();
            if (StringUtils.isNotEmpty(extensionElement.getNamespace())) {
                if (StringUtils.isNotEmpty(extensionElement.getNamespacePrefix())) {
                    xtw.writeStartElement(extensionElement.getNamespacePrefix(), extensionElement.getName(), extensionElement.getNamespace());

                    if (!namespaceMap.containsKey(extensionElement.getNamespacePrefix()) || !namespaceMap.get(extensionElement.getNamespacePrefix()).equals(extensionElement.getNamespace())) {

                        xtw.writeNamespace(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
                        namespaceMap.put(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
                        localNamespaceMap.put(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
                    }
                } else {
                    xtw.writeStartElement(extensionElement.getNamespace(), extensionElement.getName());
                }
            } else {
                xtw.writeStartElement(extensionElement.getName());
            }

            for (List<ExtensionAttribute> attributes : extensionElement.getAttributes().values()) {
                for (ExtensionAttribute attribute : attributes) {
                    if (StringUtils.isNotEmpty(attribute.getName()) && attribute.getValue() != null) {
                        if (StringUtils.isNotEmpty(attribute.getNamespace())) {
                            if (StringUtils.isNotEmpty(attribute.getNamespacePrefix())) {

                                if (!namespaceMap.containsKey(attribute.getNamespacePrefix()) || !namespaceMap.get(attribute.getNamespacePrefix()).equals(attribute.getNamespace())) {

                                    xtw.writeNamespace(attribute.getNamespacePrefix(), attribute.getNamespace());
                                    namespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
                                    localNamespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
                                }

                                xtw.writeAttribute(attribute.getNamespacePrefix(), attribute.getNamespace(), attribute.getName(), attribute.getValue());
                            } else {
                                xtw.writeAttribute(attribute.getNamespace(), attribute.getName(), attribute.getValue());
                            }
                        } else {
                            xtw.writeAttribute(attribute.getName(), attribute.getValue());
                        }
                    }
                }
            }

            if (extensionElement.getElementText() != null) {
                xtw.writeCData(extensionElement.getElementText());
            } else {
                for (List<ExtensionElement> childElements : extensionElement.getChildElements().values()) {
                    for (ExtensionElement childElement : childElements) {
                        writeExtensionElement(childElement, namespaceMap, xtw);
                    }
                }
            }

            for (String prefix : localNamespaceMap.keySet()) {
                namespaceMap.remove(prefix);
            }

            xtw.writeEndElement();
        }
    }

    public static boolean writeIOParameters(String elementName, List<IOParameter> parameterList, boolean didWriteExtensionStartElement, XMLStreamWriter xtw) throws Exception {

        if (parameterList.isEmpty()) {
            return didWriteExtensionStartElement;
        }

        for (IOParameter ioParameter : parameterList) {
            if (!didWriteExtensionStartElement) {
                xtw.writeStartElement(ELEMENT_EXTENSIONS);
                didWriteExtensionStartElement = true;
            }

            xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, elementName, FLOWABLE_EXTENSIONS_NAMESPACE);
            if (StringUtils.isNotEmpty(ioParameter.getSourceExpression())) {
                writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION, ioParameter.getSourceExpression(), xtw);

            } else if (StringUtils.isNotEmpty(ioParameter.getSource())) {
                writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_SOURCE, ioParameter.getSource(), xtw);
            }

            if (StringUtils.isNotEmpty(ioParameter.getAttributeValue(null, "sourceType"))) {
                writeDefaultAttribute("sourceType", ioParameter.getAttributeValue(null, "sourceType"), xtw);
            }

            if (StringUtils.isNotEmpty(ioParameter.getTargetExpression())) {
                writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TARGET_EXPRESSION, ioParameter.getTargetExpression(), xtw);

            } else if (StringUtils.isNotEmpty(ioParameter.getTarget())) {
                writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TARGET, ioParameter.getTarget(), xtw);
            }

            if (StringUtils.isNotEmpty(ioParameter.getAttributeValue(null, "targetType"))) {
                writeDefaultAttribute("targetType", ioParameter.getAttributeValue(null, "targetType"), xtw);
            }

            if (ioParameter.isTransient()) {
                writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TRANSIENT, "true", xtw);
            }

            xtw.writeEndElement();
        }

        return didWriteExtensionStartElement;
    }

    public static List<String> parseDelimitedList(String s) {
        List<String> result = new ArrayList<>();
        if (StringUtils.isNotEmpty(s)) {

            StringCharacterIterator iterator = new StringCharacterIterator(s);
            char c = iterator.first();

            StringBuilder strb = new StringBuilder();
            boolean insideExpression = false;

            while (c != StringCharacterIterator.DONE) {
                if (c == '{' || c == '$') {
                    insideExpression = true;
                } else if (c == '}') {
                    insideExpression = false;
                } else if (c == ',' && !insideExpression) {
                    result.add(strb.toString().trim());
                    strb.delete(0, strb.length());
                }

                if (c != ',' || insideExpression) {
                    strb.append(c);
                }

                c = iterator.next();
            }

            if (strb.length() > 0) {
                result.add(strb.toString().trim());
            }

        }
        return result;
    }

    public static String convertToDelimitedString(List<String> stringList) {
        StringBuilder resultString = new StringBuilder();

        if (stringList != null) {
            for (String result : stringList) {
                if (resultString.length() > 0) {
                    resultString.append(",");
                }
                resultString.append(result);
            }
        }
        return resultString.toString();
    }

    /**
     * add all attributes from XML to element extensionAttributes (except blackListed).
     *
     * @param xtr
     * @param element
     * @param blackLists
     */
    public static void addCustomAttributes(XMLStreamReader xtr, BaseElement element, List<ExtensionAttribute>... blackLists) {
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
            if (!isBlacklisted(extensionAttribute, blackLists)) {
                element.addAttribute(extensionAttribute);
            }
        }
    }

    public static void writeCustomAttributes(Collection<List<ExtensionAttribute>> attributes, XMLStreamWriter xtw, List<ExtensionAttribute>... blackLists) throws XMLStreamException {
        writeCustomAttributes(attributes, xtw, new LinkedHashMap<>(), blackLists);
    }

    /**
     * write attributes to xtw (except blacklisted)
     *
     * @param attributes
     * @param xtw
     * @param namespaceMap
     * @param blackLists
     */
    public static void writeCustomAttributes(Collection<List<ExtensionAttribute>> attributes, XMLStreamWriter xtw, Map<String, String> namespaceMap, List<ExtensionAttribute>... blackLists)
            throws XMLStreamException {

        for (List<ExtensionAttribute> attributeList : attributes) {
            if (attributeList != null && !attributeList.isEmpty()) {
                for (ExtensionAttribute attribute : attributeList) {
                    if (!isBlacklisted(attribute, blackLists)) {
                        if (attribute.getNamespacePrefix() == null) {
                            if (attribute.getNamespace() == null)
                                xtw.writeAttribute(attribute.getName(), attribute.getValue());
                            else {
                                xtw.writeAttribute(attribute.getNamespace(), attribute.getName(), attribute.getValue());
                            }
                        } else {
                            if (!namespaceMap.containsKey(attribute.getNamespacePrefix())) {
                                namespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
                                xtw.writeNamespace(attribute.getNamespacePrefix(), attribute.getNamespace());
                            }
                            xtw.writeAttribute(attribute.getNamespacePrefix(), attribute.getNamespace(), attribute.getName(), attribute.getValue());
                        }
                    }
                }
            }
        }
    }

    public static boolean isBlacklisted(ExtensionAttribute attribute, List<ExtensionAttribute>... blackLists) {
        if (blackLists != null) {
            for (List<ExtensionAttribute> blackList : blackLists) {
                for (ExtensionAttribute blackAttribute : blackList) {
                    if (blackAttribute.getName().equals(attribute.getName())) {
                        if (attribute.getNamespace() != null && (FLOWABLE_EXTENSIONS_NAMESPACE.equals(attribute.getNamespace()) ||
                                ACTIVITI_EXTENSIONS_NAMESPACE.equals(attribute.getNamespace()))) {

                            return true;
                        }

                        if (blackAttribute.getNamespace() == null && attribute.getNamespace() == null) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }
}
