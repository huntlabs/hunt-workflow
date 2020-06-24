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
module flow.bpmn.converter.converter.child.FormPropertyParser;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FormProperty;
import flow.bpmn.model.FormValue;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.UserTask;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import hunt.Boolean;
import std.uni;

/**
 * @author Tijs Rademakers
 */
class FormPropertyParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_FORMPROPERTY;
    }

    override
    public bool accepts(BaseElement element) {
        return ((cast(UserTask)element !is null) || (cast(StartEvent)element !is null));
    }


    void loopNexSibling(Element n , FormProperty property , bool readyWithFormProperty)
    {
        Element node = n;
        while(!readyWithFormProperty && node !is null && node.getType == NodeType.Element)
        {
          //DOSOMETHING
          if (icmp(ELEMENT_VALUE ,node.getName()) == 0) {
              FormValue value = new FormValue();
              BpmnXMLUtil.addXMLLocation(value, node);
              value.setId(node.firstAttribute(ATTRIBUTE_ID) is null? "" : node.firstAttribute(ATTRIBUTE_ID).getValue);
              value.setName(node.firstAttribute(ATTRIBUTE_NAME) is null ? "" : node.firstAttribute(ATTRIBUTE_NAME).getValue);
              property.getFormValues().add(value);

          } else if (icmp(getElementName(),node.getName()) == 0) {
              readyWithFormProperty = true;
          }
          Element child  = node.firstNode;
          if(child !is null && child.getType == NodeType.Element)
          {
            //writefln(child.toString);
            //DOSOMETHING
            if (icmp(ELEMENT_VALUE ,child.getName()) == 0) {
              FormValue value = new FormValue();
              BpmnXMLUtil.addXMLLocation(value, child);
              value.setId(child.firstAttribute(ATTRIBUTE_ID) is null ? "" : child.firstAttribute(ATTRIBUTE_ID).getValue);
              value.setName(child.firstAttribute(ATTRIBUTE_NAME) is null ? "" : child.firstAttribute(ATTRIBUTE_NAME).getValue);
              property.getFormValues().add(value);

            } else if (icmp(getElementName(),child.getName()) == 0) {
              readyWithFormProperty = true;
            }
            loopNexSibling(child.nextSibling , property ,readyWithFormProperty);
          }
          node = node.nextSibling;
        }
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {

        if (!accepts(parentElement))
            return;

        FormProperty property = new FormProperty();
        BpmnXMLUtil.addXMLLocation(property, xtr);
        property.setId(xtr.firstAttribute(ATTRIBUTE_FORM_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_ID).getValue);
        property.setName(xtr.firstAttribute(ATTRIBUTE_FORM_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_NAME).getValue);
        property.setType(xtr.firstAttribute(ATTRIBUTE_FORM_TYPE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_TYPE).getValue);
        property.setVariable(xtr.firstAttribute(ATTRIBUTE_FORM_VARIABLE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_VARIABLE).getValue);
        property.setExpression(xtr.firstAttribute(ATTRIBUTE_FORM_EXPRESSION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_EXPRESSION).getValue);
        property.setDefaultExpression(xtr.firstAttribute(ATTRIBUTE_FORM_DEFAULT) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_DEFAULT).getValue);
        property.setDatePattern(xtr.firstAttribute(ATTRIBUTE_FORM_DATEPATTERN) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FORM_DATEPATTERN).getValue);
        if (xtr.firstAttribute(ATTRIBUTE_FORM_REQUIRED) !is null && xtr.firstAttribute(ATTRIBUTE_FORM_REQUIRED).getValue.length != 0) {
            property.setRequired(Boolean.valueOf(xtr.firstAttribute(ATTRIBUTE_FORM_REQUIRED).getValue).booleanValue);
        }
        if (xtr.firstAttribute(ATTRIBUTE_FORM_READABLE) !is null && xtr.firstAttribute(ATTRIBUTE_FORM_READABLE).getValue.length != 0) {
            property.setReadable(Boolean.valueOf(xtr.firstAttribute(ATTRIBUTE_FORM_READABLE).getValue).booleanValue);
        }
        if (xtr.firstAttribute(ATTRIBUTE_FORM_WRITABLE) !is null && xtr.firstAttribute(ATTRIBUTE_FORM_WRITABLE).getValue.length != 0) {
            property.setWriteable(Boolean.valueOf(xtr.firstAttribute(ATTRIBUTE_FORM_WRITABLE).getValue).booleanValue);
        }

        bool readyWithFormProperty = false;
        if (xtr !is null)
        {
          loopNexSibling(xtr.firstNode , property , readyWithFormProperty);
        }

        //try {
        //    Element element = xtr.firstNode;
        //    while (!readyWithFormProperty && element !is null && element.getType == NodeType.Element) {
        //        if (icmp(ELEMENT_VALUE ,element.getName()) == 0) {
        //            FormValue value = new FormValue();
        //            BpmnXMLUtil.addXMLLocation(value, element);
        //            value.setId(element.getAttributeValue(null, ATTRIBUTE_ID));
        //            value.setName(element.getAttributeValue(null, ATTRIBUTE_NAME));
        //            property.getFormValues().add(value);
        //
        //        } else if (icmp(getElementName(),element.getName()) == 0) {
        //            readyWithFormProperty = true;
        //        }
        //        element = element.firstNode;
        //    }
        //} catch (Exception e) {
        //    LOGGER.warn("Error parsing form properties child elements", e);
        //}

        if ( cast(UserTask)parentElement !is null ) {
            (cast(UserTask) parentElement).getFormProperties().add(property);
        } else {
            (cast(StartEvent) parentElement).getFormProperties().add(property);
        }
    }
}
