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
module flow.bpmn.converter.converter.child.CompensateEventDefinitionParser;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import hunt.Boolean;
/**
 * @author Tijs Rademakers
 */
class CompensateEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_COMPENSATEDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Event)parentElement is null)
            return;

        CompensateEventDefinition eventDefinition = new CompensateEventDefinition();
        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        eventDefinition.setActivityRef(xtr.firstAttribute(ATTRIBUTE_COMPENSATE_ACTIVITYREF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_COMPENSATE_ACTIVITYREF).getValue);
        if (xtr.firstAttribute(ATTRIBUTE_COMPENSATE_WAITFORCOMPLETION) !is null && xtr.firstAttribute(ATTRIBUTE_COMPENSATE_WAITFORCOMPLETION).getValue.length != 0) {
            eventDefinition.setWaitForCompletion(Boolean.parseBoolean(xtr.firstAttribute(ATTRIBUTE_COMPENSATE_WAITFORCOMPLETION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_COMPENSATE_WAITFORCOMPLETION).getValue));
        }

        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_COMPENSATEDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }
}
