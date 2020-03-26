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
module flow.bpmn.converter.converter.child.SignalEventDefinitionParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Event;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;
import hunt.Boolean;
/**
 * @author Tijs Rademakers
 */
class SignalEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_SIGNALDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Event)parentElement is null)
            return;

        SignalEventDefinition eventDefinition = new SignalEventDefinition();
        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        eventDefinition.setSignalRef(xtr.firstAttribute(ATTRIBUTE_SIGNAL_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_SIGNAL_REF).getValue);
        eventDefinition.setSignalExpression(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_SIGNAL_EXPRESSION, xtr));
        if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, xtr) !is null && BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, xtr).length != 0) {
            eventDefinition.setAsync(Boolean.parseBoolean(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_ACTIVITY_ASYNCHRONOUS, xtr)).booleanValue());
        }

        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_SIGNALDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }
}
