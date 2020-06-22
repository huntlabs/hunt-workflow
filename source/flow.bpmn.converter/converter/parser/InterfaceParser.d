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
module flow.bpmn.converter.converter.parser.InterfaceParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Operation;
import hunt.xml;
import std.string;
import std.uni;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class InterfaceParser : BpmnXMLConstants {
  import flow.bpmn.model.Interface;
  void loopNexSibling(Element n , Interface interfaceObject  , Operation operation ,bool readyWithFormProperty ,BpmnModel model)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (ELEMENT_OPERATION == node.getName()) {
        operation = new Operation();
        BpmnXMLUtil.addXMLLocation(operation, node);
        operation.setId(model.getTargetNamespace() ~ ":" ~ node.firstAttribute(ATTRIBUTE_ID) is null ? "" :node.firstAttribute(ATTRIBUTE_ID).getValue);
        operation.setName(node.firstAttribute(ATTRIBUTE_NAME) is null ? "" : node.firstAttribute(ATTRIBUTE_NAME).getValue);
        operation.setImplementationRef(parseMessageRef(node.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF) is null ? "" : node.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF), model));

      } else if (ELEMENT_IN_MESSAGE == node.getName()()) {
        string inMessageRef = node.getText();
        if (operation !is null && inMessageRef.length != 0) {
          operation.setInMessageRef(parseMessageRef(strip(inMessageRef), model));
        }

      } else if (ELEMENT_OUT_MESSAGE == node.getName()) {
        string outMessageRef = node.getText();
        if (operation !is null && outMessageRef.length != 0) {
          operation.setOutMessageRef(parseMessageRef(strip(outMessageRef), model));
        }
      }
      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (ELEMENT_OPERATION == child.getName()) {
          operation = new Operation();
          BpmnXMLUtil.addXMLLocation(operation, child);
          operation.setId(model.getTargetNamespace() ~ ":" ~ child.firstAttribute(ATTRIBUTE_ID) is null ? "" :child.firstAttribute(ATTRIBUTE_ID).getValue);
          operation.setName(child.firstAttribute(ATTRIBUTE_NAME) is null ? "" : child.firstAttribute(ATTRIBUTE_NAME).getValue);
          operation.setImplementationRef(parseMessageRef(child.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF) is null ? "" : child.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF), model));

        } else if (ELEMENT_IN_MESSAGE == child.getName()()) {
          string inMessageRef = child.getText();
          if (operation !is null && inMessageRef.length != 0) {
            operation.setInMessageRef(parseMessageRef(strip(inMessageRef), model));
          }

        } else if (ELEMENT_OUT_MESSAGE == child.getName()) {
          string outMessageRef = child.getText();
          if (operation !is null && outMessageRef.length != 0) {
            operation.setOutMessageRef(parseMessageRef(strip(outMessageRef), model));
          }
        }

        if (icmp(ELEMENT_OPERATION,child.getName()) == 0)
        {
          if (operation !is null && (operation.getImplementationRef().length != 0)) {
            interfaceObject.getOperations().add(operation);
            operation = null;
          }
        }

        loopNexSibling(child.nextSibling, interfaceObject, operation, readyWithFormProperty, model);
      }

      if (icmp(ELEMENT_OPERATION,node.getName()) == 0)
      {
        if (operation !is null && (operation.getImplementationRef().length != 0)) {
          interfaceObject.getOperations().add(operation);
          operation = null;
        }
      }
      node = node.nextSibling;
    }
  }


    public void parse(Element xtr, BpmnModel model)  {

        Interface interfaceObject = new Interface();
        BpmnXMLUtil.addXMLLocation(interfaceObject, xtr);
        interfaceObject.setId(model.getTargetNamespace() ~ ":" ~ xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue);
        interfaceObject.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
        interfaceObject.setImplementationRef(parseMessageRef(xtr.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_IMPLEMENTATION_REF).getValue, model));

        bool readyWithInterface = false;
        Operation operation = null;
        try {
            if (xtr !is null)
            {
                loopNexSibling(xtr.firstNode, interfaceObject,operation, readyWithInterface ,model);
            }
            //while (!readyWithInterface && xtr.hasNext()) {
            //    xtr.next();
            //    if (xtr.isStartElement() && ELEMENT_OPERATION.equals(xtr.getLocalName())) {
            //        operation = new Operation();
            //        BpmnXMLUtil.addXMLLocation(operation, xtr);
            //        operation.setId(model.getTargetNamespace() + ":" + xtr.getAttributeValue(null, ATTRIBUTE_ID));
            //        operation.setName(xtr.getAttributeValue(null, ATTRIBUTE_NAME));
            //        operation.setImplementationRef(parseMessageRef(xtr.getAttributeValue(null, ATTRIBUTE_IMPLEMENTATION_REF), model));
            //
            //    } else if (xtr.isStartElement() && ELEMENT_IN_MESSAGE.equals(xtr.getLocalName())) {
            //        String inMessageRef = xtr.getElementText();
            //        if (operation !is null && StringUtils.isNotEmpty(inMessageRef)) {
            //            operation.setInMessageRef(parseMessageRef(inMessageRef.trim(), model));
            //        }
            //
            //    } else if (xtr.isStartElement() && ELEMENT_OUT_MESSAGE.equals(xtr.getLocalName())) {
            //        String outMessageRef = xtr.getElementText();
            //        if (operation !is null && StringUtils.isNotEmpty(outMessageRef)) {
            //            operation.setOutMessageRef(parseMessageRef(outMessageRef.trim(), model));
            //        }
            //
            //    } else if (xtr.isEndElement() && ELEMENT_OPERATION.equalsIgnoreCase(xtr.getLocalName())) {
            //        if (operation !is null && StringUtils.isNotEmpty(operation.getImplementationRef())) {
            //            interfaceObject.getOperations().add(operation);
            //        }
            //
            //    } else if (xtr.isEndElement() && ELEMENT_INTERFACE.equals(xtr.getLocalName())) {
            //        readyWithInterface = true;
            //    }
            //}
        } catch (Exception e) {
            logError("Error parsing interface child elements %s", e.msg);
        }

        model.getInterfaces().add(interfaceObject);
    }

    protected string parseMessageRef(string messageRef, BpmnModel model) {
        string result;
        if (messageRef.length != 0) {
            int indexOfP = messageRef.indexOf(':');
            if (indexOfP != -1) {
                string prefix = messageRef[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                messageRef = messageRef[indexOfP + 1 .. $];

                if (resolvedNamespace is null) {
                    // if it's an invalid prefix will consider this is not a
                    // namespace prefix so will be used as part of the
                    // stringReference
                    messageRef = prefix ~ ":" ~ messageRef;
                } else if (icmp(resolvedNamespace,model.getTargetNamespace()) != 0) {
                    // if it's a valid namespace prefix but it's not the
                    // targetNamespace then we'll use it as a valid namespace
                    // (even out editor does not support defining namespaces it
                    // is still a valid xml file)
                    messageRef = resolvedNamespace ~ ":" ~ messageRef;
                }
            }
            result = messageRef;
        }
        return result;
    }
}
