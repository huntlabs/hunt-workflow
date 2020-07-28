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
module flow.bpmn.converter.converter.util.BpmnXMLUtil;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.xml;

//import javax.xml.stream.Location;
//import javax.xml.stream.XMLStreamException;
//import javax.xml.stream.XMLStreamReader;
//import javax.xml.stream.XMLStreamWriter;

import flow.bpmn.converter.constants.BpmnXMLConstants;
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
import hunt.util.StringBuilder;
import std.string;
import std.algorithm;
import std.concurrency : initOnce;
import hunt.Exceptions;
import std.algorithm;







class BpmnXMLUtil : BpmnXMLConstants {

   // private static Map!(string, BaseChildElementParser) genericChildParserMap = new HashMap<>();

    static Map!(string, BaseChildElementParser) genericChildParserMap() {
      __gshared Map!(string, BaseChildElementParser) inst;
      return initOnce!inst(new HashMap!(string, BaseChildElementParser));
    }

   shared static this () {
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

    public static void addXMLLocation(BaseElement element, Element xtr) {
        //Location location = xtr.getLocation();
        //element.setXmlRowNumber(location.getLineNumber());
        //element.setXmlColumnNumber(location.getColumnNumber());
    }

    //public static void addXMLLocation(GraphicInfo graphicInfo, Element xtr) {
    //    Location location = xtr.getLocation();
    //    graphicInfo.setXmlRowNumber(location.getLineNumber());
    //    graphicInfo.setXmlColumnNumber(location.getColumnNumber());
    //}

    public static void parseChildElements(string elementName, BaseElement parentElement, Element xtr, BpmnModel model) {
        parseChildElements(elementName, parentElement, xtr, null, model);
    }


    static void loopNexSibling(Element n , BaseElement parentElement , Map!(string, BaseChildElementParser) localParserMap, BpmnModel model, bool inExtensionElements,  bool readyWithFormProperty)
    {
      Element node = n;
      while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
      {
        //DOSOMETHING
        if (ELEMENT_EXTENSIONS == node.getName()) {
          inExtensionElements = true;
        } else if (localParserMap.containsKey(node.getName())) {
          BaseChildElementParser childParser = localParserMap.get(node.getName());
          // if we're into an extension element but the current element is not accepted by this parentElement then is read as a custom extension element
          if (inExtensionElements && !childParser.accepts(parentElement)) {
            ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(node);
            parentElement.addExtensionElement(extensionElement);

            //if (ELEMENT_EXTENSIONS == node.getName()) {
            //  inExtensionElements = false;
            //}
            //node = node.nextSibling;
             // continue;
          } else
          {
            localParserMap.get(node.getName()).parseChildElement(node, parentElement, model);
          }
        } else if (inExtensionElements) {
          ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(node);
          parentElement.addExtensionElement(extensionElement);
        }
        Element child  = node.firstNode;
        if(child !is null && child.getType == NodeType.Element)
        {
          //writefln(child.toString);
          //DOSOMETHING
          if (ELEMENT_EXTENSIONS == child.getName()) {
            inExtensionElements = true;
          } else if (localParserMap.containsKey(child.getName())) {
            BaseChildElementParser childParser = localParserMap.get(child.getName());
            // if we're into an extension element but the current element is not accepted by this parentElement then is read as a custom extension element
            if (inExtensionElements && !childParser.accepts(parentElement)) {
              ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(child);
              parentElement.addExtensionElement(extensionElement);

              //if (ELEMENT_EXTENSIONS == child.getName()) {
              //  inExtensionElements = false;
              //}
             // child = child.nextSibling;
             // continue;
            }else
            {
              localParserMap.get(child.getName()).parseChildElement(child, parentElement, model);
            }
          } else if (inExtensionElements) {
            ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(child);
            parentElement.addExtensionElement(extensionElement);
          }

          if (ELEMENT_EXTENSIONS == (child.getName())) {
            inExtensionElements = false;
          }

          loopNexSibling(child.nextSibling , parentElement ,localParserMap ,model, inExtensionElements,readyWithFormProperty);
        }


        if (ELEMENT_EXTENSIONS == (node.getName())) {
          inExtensionElements = false;
        }
        node = node.nextSibling;
      }
    }


    public static void parseChildElements(string elementName, BaseElement parentElement, Element xtr,
            Map!(string, BaseChildElementParser) childParsers, BpmnModel model) {

        Map!(string, BaseChildElementParser) localParserMap = new HashMap!(string, BaseChildElementParser)(genericChildParserMap);
        if (childParsers !is null) {
            localParserMap.putAll(childParsers);
        }

        bool inExtensionElements = false;
        bool readyWithChildElements = false;
        if (xtr !is null)
        {
            loopNexSibling(xtr.firstNode ,parentElement, localParserMap , model, inExtensionElements, readyWithChildElements);
        }
        //while (!readyWithChildElements && xtr.hasNext()) {
        //    xtr.next();
        //    if (xtr.isStartElement()) {
        //        if (ELEMENT_EXTENSIONS.equals(xtr.getLocalName())) {
        //            inExtensionElements = true;
        //        } else if (localParserMap.containsKey(xtr.getLocalName())) {
        //            BaseChildElementParser childParser = localParserMap.get(xtr.getLocalName());
        //            // if we're into an extension element but the current element is not accepted by this parentElement then is read as a custom extension element
        //            if (inExtensionElements && !childParser.accepts(parentElement)) {
        //                ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(xtr);
        //                parentElement.addExtensionElement(extensionElement);
        //                continue;
        //            }
        //            localParserMap.get(xtr.getLocalName()).parseChildElement(xtr, parentElement, model);
        //        } else if (inExtensionElements) {
        //            ExtensionElement extensionElement = BpmnXMLUtil.parseExtensionElement(xtr);
        //            parentElement.addExtensionElement(extensionElement);
        //        }
        //
        //    } else if (xtr.isEndElement()) {
        //        if (ELEMENT_EXTENSIONS.equals(xtr.getLocalName())) {
        //            inExtensionElements = false;
        //        }
        //
        //        if (elementName.equalsIgnoreCase(xtr.getLocalName())) {
        //            readyWithChildElements = true;
        //        }
        //    }
        //}
    }

   static void loopNexSibling(Element n , ExtensionElement extensionElement , bool readyWithFormProperty)
    {
      Element node = n;
      while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
      {
        //DOSOMETHING
        ExtensionElement childExtensionElement = parseExtensionElement(node);
        extensionElement.addChildElement(childExtensionElement);

        if (node.firstNode !is null && node.firstNode.getType == NodeType.CDATA) {
          if (strip( node.firstNode.getText()).length != 0) {
            extensionElement.setElementText( strip( node.firstNode.getText()));
          }
        }

        Element child  = node.firstNode;
        if(child !is null && child.getType == NodeType.Element)
        {
          //writefln(child.toString);
          //DOSOMETHING
          ExtensionElement childExtensionElement2 = parseExtensionElement(child);
          extensionElement.addChildElement(childExtensionElement2);

          if (child.firstNode !is null && child.firstNode.getType == NodeType.CDATA) {
            if (strip( child.firstNode.getText()).length != 0) {
              extensionElement.setElementText( strip( child.firstNode.getText()));
            }
          }

          loopNexSibling(child.nextSibling , extensionElement ,readyWithFormProperty);
        }
        node = node.nextSibling;
      }
    }

    public static ExtensionElement parseExtensionElement(Element xtr)  {
        ExtensionElement extensionElement = new ExtensionElement();
        extensionElement.setName(xtr.getName());
        if (xtr.firstAttribute("xmlns") !is null && xtr.firstAttribute("xmlns").getValue().length != 0) {
            extensionElement.setNamespace(xtr.firstAttribute("xmlns").getValue());
        }
        //if (stringUtils.isNotEmpty(xtr.getPrefix())) {
        //    extensionElement.setNamespacePrefix(xtr.getPrefix());
        //}

        Attribute arr = xtr.firstAttribute();
        while(arr !is null) {
            ExtensionAttribute extensionAttribute = new ExtensionAttribute();
            extensionAttribute.setName(arr.getName);
            extensionAttribute.setValue(arr.getValue);
            if (startsWith(arr.getName , "xmlns")) {
                extensionAttribute.setNamespace(arr.getValue);
            }
            if (startsWith(arr.getName, "xmlns:")) {
                long index = arr.getName.indexOf(":");
                extensionAttribute.setNamespacePrefix(arr.getName[index + 1 .. $]);
            }
            extensionElement.addAttribute(extensionAttribute);
            arr = arr.nextAttribute;
        }

        bool readyWithExtensionElement = false;
        if (xtr !is null)
        {
          loopNexSibling(xtr.firstNode , extensionElement ,readyWithExtensionElement);
        }
        //while (!readyWithExtensionElement && xtr.hasNext()) {
        //    xtr.next();
        //    if (xtr.isCharacters() || XMLStreamReader.CDATA == xtr.getEventType()) {
        //        if (stringUtils.isNotEmpty(xtr.getText().trim())) {
        //            extensionElement.setElementText(xtr.getText().trim());
        //        }
        //    } else if (xtr.isStartElement()) {
        //        ExtensionElement childExtensionElement = parseExtensionElement(xtr);
        //        extensionElement.addChildElement(childExtensionElement);
        //    } else if (xtr.isEndElement() && extensionElement.getName().equalsIgnoreCase(xtr.getLocalName())) {
        //        readyWithExtensionElement = true;
        //    }
        //}
        return extensionElement;
    }

    public static string getAttributeValue(string attributeName, Element xtr) {
        Attribute arr = xtr.firstAttribute();
        while(arr !is null)
        {
          if (arr.getName == attributeName || endsWith(arr.getName, ":" ~ attributeName))
          {
              return arr.getValue;
          }
          arr =  arr.nextAttribute;
        }
        return "";
        //Attribute  att = xtr.firstAttribute(attributeName);
        //if (att is null)
        //{
        //    return "";
        //}
        //if (attributeValue is null) {
        //    attributeValue = xtr.getAttributeValue(ACTIVITI_EXTENSIONS_NAMESPACE, attributeName);
        //}

        //return att.getValue;
    }

    //public static void writeDefaultAttribute(string attributeName, string value, XMLStreamWriter xtw)  {
    //    if (stringUtils.isNotEmpty(value) && !"null".equalsIgnoreCase(value)) {
    //        xtw.writeAttribute(attributeName, value);
    //    }
    //}
    //
    //public static void writeQualifiedAttribute(string attributeName, string value, XMLStreamWriter xtw)  {
    //    if (stringUtils.isNotEmpty(value)) {
    //        xtw.writeAttribute(FLOWABLE_EXTENSIONS_PREFIX, FLOWABLE_EXTENSIONS_NAMESPACE, attributeName, value);
    //    }
    //}
    //
    //public static bool writeExtensionElements(BaseElement baseElement, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    return writeExtensionElements(baseElement, didWriteExtensionStartElement, null, xtw);
    //}
    //
    //public static bool writeExtensionElements(BaseElement baseElement, bool didWriteExtensionStartElement, Map<string, string> namespaceMap, XMLStreamWriter xtw)  {
    //    if (!baseElement.getExtensionElements().isEmpty()) {
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //
    //        if (namespaceMap is null) {
    //            namespaceMap = new HashMap<>();
    //        }
    //
    //        for (List<ExtensionElement> extensionElements : baseElement.getExtensionElements().values()) {
    //            for (ExtensionElement extensionElement : extensionElements) {
    //                writeExtensionElement(extensionElement, namespaceMap, xtw);
    //            }
    //        }
    //    }
    //    return didWriteExtensionStartElement;
    //}
    //
    //protected static void writeExtensionElement(ExtensionElement extensionElement, Map<string, string> namespaceMap, XMLStreamWriter xtw)  {
    //    if (stringUtils.isNotEmpty(extensionElement.getName())) {
    //        Map<string, string> localNamespaceMap = new HashMap<>();
    //        if (stringUtils.isNotEmpty(extensionElement.getNamespace())) {
    //            if (stringUtils.isNotEmpty(extensionElement.getNamespacePrefix())) {
    //                xtw.writeStartElement(extensionElement.getNamespacePrefix(), extensionElement.getName(), extensionElement.getNamespace());
    //
    //                if (!namespaceMap.containsKey(extensionElement.getNamespacePrefix()) || !namespaceMap.get(extensionElement.getNamespacePrefix()).equals(extensionElement.getNamespace())) {
    //
    //                    xtw.writeNamespace(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
    //                    namespaceMap.put(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
    //                    localNamespaceMap.put(extensionElement.getNamespacePrefix(), extensionElement.getNamespace());
    //                }
    //            } else {
    //                xtw.writeStartElement(extensionElement.getNamespace(), extensionElement.getName());
    //            }
    //        } else {
    //            xtw.writeStartElement(extensionElement.getName());
    //        }
    //
    //        for (List<ExtensionAttribute> attributes : extensionElement.getAttributes().values()) {
    //            for (ExtensionAttribute attribute : attributes) {
    //                if (stringUtils.isNotEmpty(attribute.getName()) && attribute.getValue() !is null) {
    //                    if (stringUtils.isNotEmpty(attribute.getNamespace())) {
    //                        if (stringUtils.isNotEmpty(attribute.getNamespacePrefix())) {
    //
    //                            if (!namespaceMap.containsKey(attribute.getNamespacePrefix()) || !namespaceMap.get(attribute.getNamespacePrefix()).equals(attribute.getNamespace())) {
    //
    //                                xtw.writeNamespace(attribute.getNamespacePrefix(), attribute.getNamespace());
    //                                namespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
    //                                localNamespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
    //                            }
    //
    //                            xtw.writeAttribute(attribute.getNamespacePrefix(), attribute.getNamespace(), attribute.getName(), attribute.getValue());
    //                        } else {
    //                            xtw.writeAttribute(attribute.getNamespace(), attribute.getName(), attribute.getValue());
    //                        }
    //                    } else {
    //                        xtw.writeAttribute(attribute.getName(), attribute.getValue());
    //                    }
    //                }
    //            }
    //        }
    //
    //        if (extensionElement.getElementText() !is null) {
    //            xtw.writeCData(extensionElement.getElementText());
    //        } else {
    //            for (List<ExtensionElement> childElements : extensionElement.getChildElements().values()) {
    //                for (ExtensionElement childElement : childElements) {
    //                    writeExtensionElement(childElement, namespaceMap, xtw);
    //                }
    //            }
    //        }
    //
    //        for (string prefix : localNamespaceMap.keySet()) {
    //            namespaceMap.remove(prefix);
    //        }
    //
    //        xtw.writeEndElement();
    //    }
    //}
    //
    //public static bool writeIOParameters(string elementName, List<IOParameter> parameterList, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //
    //    if (parameterList.isEmpty()) {
    //        return didWriteExtensionStartElement;
    //    }
    //
    //    for (IOParameter ioParameter : parameterList) {
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, elementName, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        if (stringUtils.isNotEmpty(ioParameter.getSourceExpression())) {
    //            writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION, ioParameter.getSourceExpression(), xtw);
    //
    //        } else if (stringUtils.isNotEmpty(ioParameter.getSource())) {
    //            writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_SOURCE, ioParameter.getSource(), xtw);
    //        }
    //
    //        if (stringUtils.isNotEmpty(ioParameter.getAttributeValue(null, "sourceType"))) {
    //            writeDefaultAttribute("sourceType", ioParameter.getAttributeValue(null, "sourceType"), xtw);
    //        }
    //
    //        if (stringUtils.isNotEmpty(ioParameter.getTargetExpression())) {
    //            writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TARGET_EXPRESSION, ioParameter.getTargetExpression(), xtw);
    //
    //        } else if (stringUtils.isNotEmpty(ioParameter.getTarget())) {
    //            writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TARGET, ioParameter.getTarget(), xtw);
    //        }
    //
    //        if (stringUtils.isNotEmpty(ioParameter.getAttributeValue(null, "targetType"))) {
    //            writeDefaultAttribute("targetType", ioParameter.getAttributeValue(null, "targetType"), xtw);
    //        }
    //
    //        if (ioParameter.isTransient()) {
    //            writeDefaultAttribute(ATTRIBUTE_IOPARAMETER_TRANSIENT, "true", xtw);
    //        }
    //
    //        xtw.writeEndElement();
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}

    public static List!string parseDelimitedList(string s) {
        List!string result = new ArrayList!string();
        if (s !is null && s.length != 0) {

            //stringCharacterIterator iterator = new stringCharacterIterator(s);
            //char c = iterator.first();

            StringBuilder strb = new StringBuilder();
            bool insideExpression = false;


            foreach(char c ; s) {
                if (c == '{' || c == '$') {
                    insideExpression = true;
                } else if (c == '}') {
                    insideExpression = false;
                } else if (c == ',' && !insideExpression) {
                    result.add(strip(strb.toString()));
                    strb.reset();
                    //strb.delete(0, strb.length());
                }

                if (c != ',' || insideExpression) {
                    strb.append(c);
                }

              //  c = iterator.next();
            }

            if (strb.length() > 0) {
                result.add(strip(strb.toString()));
            }

        }
        return result;
    }

    public static string convertToDelimitedstring(List!string stringList) {
        StringBuilder resultstring = new StringBuilder();

        if (stringList !is null) {
            foreach (string result ; stringList) {
                if (resultstring.length() > 0) {
                    resultstring.append(",");
                }
                resultstring.append(result);
            }
        }
        return resultstring.toString();
    }

    /**
     * add all attributes from XML to element extensionAttributes (except blackListed).
     *
     * @param xtr
     * @param element
     * @param blackLists
     */
    public static void addCustomAttributes(Element xtr, BaseElement element, List!ExtensionAttribute blackLists) {
        Attribute arr = xtr.firstAttribute();
        while (arr !is null) {
            ExtensionAttribute extensionAttribute = new ExtensionAttribute();
            extensionAttribute.setName(arr.getName);
            extensionAttribute.setValue(arr.getValue());
            if (startsWith(arr.getName,"xmlns")) {
                extensionAttribute.setNamespace(arr.getValue());
            }
            if (startsWith(arr.getName,"xmlns:")) {
                long index = arr.getName.indexOf(":");
                extensionAttribute.setNamespacePrefix(arr.getName()[index + 1 .. $]);
            }
            if (!isBlacklisted(extensionAttribute, blackLists)) {
               // element.addAttribute(extensionAttribute);
            }
            arr = arr.nextAttribute;
        }
    }

    //public static void writeCustomAttributes(Collection<List<ExtensionAttribute>> attributes, XMLStreamWriter xtw, List<ExtensionAttribute>... blackLists) throws XMLStreamException {
    //    writeCustomAttributes(attributes, xtw, new LinkedHashMap<>(), blackLists);
    //}

    /**
     * write attributes to xtw (except blacklisted)
     *
     * @param attributes
     * @param xtw
     * @param namespaceMap
     * @param blackLists
     */
    //public static void writeCustomAttributes(Collection<List<ExtensionAttribute>> attributes, XMLStreamWriter xtw, Map<string, string> namespaceMap, List<ExtensionAttribute>... blackLists)
    //        throws XMLStreamException {
    //
    //    for (List<ExtensionAttribute> attributeList : attributes) {
    //        if (attributeList !is null && !attributeList.isEmpty()) {
    //            for (ExtensionAttribute attribute : attributeList) {
    //                if (!isBlacklisted(attribute, blackLists)) {
    //                    if (attribute.getNamespacePrefix() is null) {
    //                        if (attribute.getNamespace() is null)
    //                            xtw.writeAttribute(attribute.getName(), attribute.getValue());
    //                        else {
    //                            xtw.writeAttribute(attribute.getNamespace(), attribute.getName(), attribute.getValue());
    //                        }
    //                    } else {
    //                        if (!namespaceMap.containsKey(attribute.getNamespacePrefix())) {
    //                            namespaceMap.put(attribute.getNamespacePrefix(), attribute.getNamespace());
    //                            xtw.writeNamespace(attribute.getNamespacePrefix(), attribute.getNamespace());
    //                        }
    //                        xtw.writeAttribute(attribute.getNamespacePrefix(), attribute.getNamespace(), attribute.getName(), attribute.getValue());
    //                    }
    //                }
    //            }
    //        }
    //    }
    //}

    public static bool isBlacklisted(ExtensionAttribute attribute, List!ExtensionAttribute blackLists) {
          //implementationMissing(false);
          return false;
        //if (blackLists !is null) {
        //    for (List<ExtensionAttribute> blackList : blackLists) {
        //        for (ExtensionAttribute blackAttribute : blackList) {
        //            if (blackAttribute.getName().equals(attribute.getName())) {
        //                if (attribute.getNamespace() !is null && (FLOWABLE_EXTENSIONS_NAMESPACE.equals(attribute.getNamespace()) ||
        //                        ACTIVITI_EXTENSIONS_NAMESPACE.equals(attribute.getNamespace()))) {
        //
        //                    return true;
        //                }
        //
        //                if (blackAttribute.getNamespace() is null && attribute.getNamespace() is null) {
        //                    return true;
        //                }
        //            }
        //        }
        //    }
        }
        //return false;
   // }
}
