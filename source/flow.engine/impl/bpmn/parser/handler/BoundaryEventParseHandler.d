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
module flow.engine.impl.bpmn.parser.handler.BoundaryEventParseHandler;

import hunt.collection.List;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.TimerEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractFlowNodeBpmnParseHandler;
import hunt.logging;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class BoundaryEventParseHandler : AbstractFlowNodeBpmnParseHandler!BoundaryEvent {

    override
    BaseElement getHandledType() {
        return  new BoundaryEvent;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, BoundaryEvent boundaryEvent) {

        if (boundaryEvent.getAttachedToRef() is null) {
            logWarning("Invalid reference in boundary event. Make sure that the referenced activity is defined in the same scope as the boundary event {%s}", boundaryEvent.getId());
            return;
        }

        EventDefinition eventDefinition = null;
        if (boundaryEvent.getEventDefinitions().size() > 0) {
            eventDefinition = boundaryEvent.getEventDefinitions().get(0);
        }

        if (cast(TimerEventDefinition)eventDefinition !is null || cast(ErrorEventDefinition)eventDefinition !is null || cast(SignalEventDefinition)eventDefinition !is null
                || cast(CancelEventDefinition)eventDefinition !is null || cast(ConditionalEventDefinition)eventDefinition !is null || cast(MessageEventDefinition)eventDefinition !is null
                || cast(EscalationEventDefinition)eventDefinition !is null || cast(CompensateEventDefinition)eventDefinition !is null) {

            bpmnParse.getBpmnParserHandlers().parseElement(bpmnParse, eventDefinition);
            return;

        } else if (!boundaryEvent.getExtensionElements().isEmpty()) {
            List!ExtensionElement eventTypeExtensionElements = boundaryEvent.getExtensionElements().get(BpmnXMLConstants.ELEMENT_EVENT_TYPE);
            if (eventTypeExtensionElements !is null && !eventTypeExtensionElements.isEmpty()) {
                string eventTypeValue = eventTypeExtensionElements.get(0).getElementText();
                if (eventTypeValue !is null && eventTypeValue.length != 0) {
                    boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryEventRegistryEventActivityBehavior(
                                    boundaryEvent, eventTypeValue, boundaryEvent.isCancelActivity()));
                    return;
                }
            }

        }

        // Should already be picked up by process validator on deploy, so this is just to be sure
        logWarning("Unsupported boundary event type for boundary event {%s}", boundaryEvent.getId());
    }

}
