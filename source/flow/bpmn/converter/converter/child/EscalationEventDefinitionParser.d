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
module flow.bpmn.converter.converter.child.EscalationEventDefinitionParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class EscalationEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_ESCALATIONDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Event)parentElement is null)
            return;

        EscalationEventDefinition eventDefinition = new EscalationEventDefinition();
        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        eventDefinition.setEscalationCode(xtr.firstAttribute(ATTRIBUTE_ESCALATION_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ESCALATION_REF).getValue);

        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_ESCALATIONDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }
}
