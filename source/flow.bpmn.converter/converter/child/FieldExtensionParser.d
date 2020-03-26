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

module flow.bpmn.converter.converter.child.FieldExtensionParser;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.AbstractFlowableHttpHandler;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FieldExtension;
import flow.bpmn.model.SendTask;
import flow.bpmn.model.ServiceTask;

import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;

/**
 * @author Tijs Rademakers
 */
class FieldExtensionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_FIELD;
    }

    override
    public bool accepts(BaseElement element) {
        return ((cast(FlowableListener)element !is null) || (cast(ServiceTask)element !is null) || (cast(SendTask)element !is null) || (cast(AbstractFlowableHttpHandler)element !is null));
    }


  void loopNexSibling(Element n , FieldExtension extension , bool readyWithFormProperty)
  {
    Element node = n;
    while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
    {
      //DOSOMETHING
      if (icmp(ELEMENT_FIELD_STRING,(node.getName())) == 0) {
        extension.setStringValue(strip(node.getText()));

      } else if (icmp(ATTRIBUTE_FIELD_EXPRESSION,node.getName()) == 0) {
        extension.setExpression(strip(node.getText()));

      } else if (icmp(getElementName(),(node.getName())) == 0) {
        readyWithFormProperty = true;
      }
      Element child  = node.firstNode;
      if(child !is null && child.getType == NodeType.Element)
      {
        //writefln(child.toString);
        //DOSOMETHING
        if (icmp(ELEMENT_FIELD_STRING,(child.getName())) == 0) {
          extension.setStringValue(strip(child.getText()));

        } else if (icmp(ATTRIBUTE_FIELD_EXPRESSION,child.getName()) == 0) {
          extension.setExpression(strip(child.getText()));

        } else if (icmp(getElementName(),(child.getName())) == 0) {
          readyWithFormProperty = true;
        }
        loopNexSibling(child.nextSibling , extension ,readyWithFormProperty);
      }
      node = node.nextSibling;
    }
  }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        if (!accepts(parentElement))
            return;

        FieldExtension extension = new FieldExtension();
        BpmnXMLUtil.addXMLLocation(extension, xtr);
        extension.setFieldName(xtr.firstAttribute(ATTRIBUTE_FIELD_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FIELD_NAME).getValue);

        if (xtr.firstAttribute(ATTRIBUTE_FIELD_STRING) !is null && xtr.firstAttribute(ATTRIBUTE_FIELD_STRING).getValue.length != 0) {
            extension.setStringValue(xtr.firstAttribute(ATTRIBUTE_FIELD_STRING).getValue);

        } else if (xtr.firstAttribute(ATTRIBUTE_FIELD_EXPRESSION) !is null && xtr.firstAttribute(ATTRIBUTE_FIELD_EXPRESSION).getValue.length != 0) {
            extension.setExpression(xtr.firstAttribute(ATTRIBUTE_FIELD_EXPRESSION).getValue);

        } else {
            bool readyWithFieldExtension = false;
            try {
                if (xtr !is null)
                {
                    loopNexSibling(xtr.firstNode, extension, readyWithFieldExtension);
                }
                //while (!readyWithFieldExtension && xtr.hasNext()) {
                //    xtr.next();
                //    if (xtr.isStartElement() && ELEMENT_FIELD_STRING.equalsIgnoreCase(xtr.getLocalName())) {
                //        extension.setStringValue(xtr.getElementText().trim());
                //
                //    } else if (xtr.isStartElement() && ATTRIBUTE_FIELD_EXPRESSION.equalsIgnoreCase(xtr.getLocalName())) {
                //        extension.setExpression(xtr.getElementText().trim());
                //
                //    } else if (xtr.isEndElement() && getElementName().equalsIgnoreCase(xtr.getLocalName())) {
                //        readyWithFieldExtension = true;
                //    }
                //}
            } catch (Exception e) {
                logError("Error parsing field extension child elements %s", e.msg);
            }
        }

        if (cast(FlowableListener)parentElement !is null) {
            (cast(FlowableListener) parentElement).getFieldExtensions().add(extension);
        } else if (cast(ServiceTask)parentElement !is null) {
            (cast(ServiceTask) parentElement).getFieldExtensions().add(extension);
        } else if (cast(SendTask)parentElement !is null) {
            (cast(SendTask) parentElement).getFieldExtensions().add(extension);
        } else {
            (cast(AbstractFlowableHttpHandler) parentElement).getFieldExtensions().add(extension);
        }
    }
}
