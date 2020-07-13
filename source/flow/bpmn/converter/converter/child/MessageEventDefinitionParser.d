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
module flow.bpmn.converter.converter.child.MessageEventDefinitionParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Event;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
/**
 * @author Tijs Rademakers
 */
class MessageEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_MESSAGEDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Event)parentElement is null)
            return;

        MessageEventDefinition eventDefinition = new MessageEventDefinition();
        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        eventDefinition.setMessageRef(xtr.firstAttribute(ATTRIBUTE_MESSAGE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_MESSAGE_REF).getValue);
        eventDefinition.setMessageExpression(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_MESSAGE_EXPRESSION, xtr));

        if (eventDefinition.getMessageRef !is null && eventDefinition.getMessageRef.length != 0) {

            int indexOfP = cast(int)eventDefinition.getMessageRef().indexOf(':');
            if (indexOfP != -1) {
                string prefix = eventDefinition.getMessageRef()[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                string messageRef = eventDefinition.getMessageRef()[indexOfP + 1 .. $];

                if (resolvedNamespace is null) {
                    // if it's an invalid prefix will consider this is not a namespace prefix so will be used as part of the stringReference
                    messageRef = prefix ~ ":" ~ messageRef;
                } else if (icmp(resolvedNamespace,(model.getTargetNamespace())) != 0) {
                    // if it's a valid namespace prefix but it's not the targetNamespace then we'll use it as a valid namespace
                    // (even out editor does not support defining namespaces it is still a valid xml file)
                    messageRef = resolvedNamespace ~ ":" ~ messageRef;
                }
                eventDefinition.setMessageRef(messageRef);
            } else {
                eventDefinition.setMessageRef(eventDefinition.getMessageRef());
            }
        }

        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_MESSAGEDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }
}
