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
module flow.bpmn.converter.converter.child.TerminateEventDefinitionParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EndEvent;
import flow.bpmn.model.Event;
import flow.bpmn.model.TerminateEventDefinition;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class TerminateEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_TERMINATEDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(EndEvent)parentElement is null) {
            return;
        }

        TerminateEventDefinition eventDefinition = new TerminateEventDefinition();

        parseTerminateAllAttribute(xtr, eventDefinition);
        parseTerminateMultiInstanceAttribute(xtr, eventDefinition);

        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_TERMINATEDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }

    protected void parseTerminateAllAttribute(Element xtr, TerminateEventDefinition eventDefinition) {
        string terminateAllValue = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TERMINATE_ALL, xtr);
        if ("true" == terminateAllValue) {
            eventDefinition.setTerminateAll(true);
        } else {
            eventDefinition.setTerminateAll(false);
        }
    }

    protected void parseTerminateMultiInstanceAttribute(Element xtr, TerminateEventDefinition eventDefinition) {
        string terminateMiValue = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TERMINATE_MULTI_INSTANCE, xtr);
        if ("true" == terminateMiValue) {
            eventDefinition.setTerminateMultiInstance(true);
        } else {
            eventDefinition.setTerminateMultiInstance(false);
        }
    }
}
