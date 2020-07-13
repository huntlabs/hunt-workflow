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
module flow.bpmn.converter.converter.child.TimerEventDefinitionParser;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Event;
import flow.bpmn.model.TimerEventDefinition;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
import std.string;

/**
 * @author Tijs Rademakers
 */
class TimerEventDefinitionParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_EVENT_TIMERDEFINITION;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(Event)parentElement is null)
            return;

        TimerEventDefinition eventDefinition = new TimerEventDefinition();
        string calendarName = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_CALENDAR_NAME, xtr);
        if (calendarName !is null && calendarName.length != 0) {
            eventDefinition.setCalendarName(calendarName);
        }
        BpmnXMLUtil.addXMLLocation(eventDefinition, xtr);
        BpmnXMLUtil.parseChildElements(ELEMENT_EVENT_TIMERDEFINITION, eventDefinition, xtr, model);

        (cast(Event) parentElement).getEventDefinitions().add(eventDefinition);
    }
}
