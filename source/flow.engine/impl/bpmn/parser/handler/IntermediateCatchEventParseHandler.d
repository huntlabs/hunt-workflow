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
module flow.engine.impl.bpmn.parser.handler.IntermediateCatchEventParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.IntermediateCatchEvent;
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
class IntermediateCatchEventParseHandler : AbstractFlowNodeBpmnParseHandler!IntermediateCatchEvent {


    override
    TypeInfo getHandledType() {
        return typeid(IntermediateCatchEvent);
    }

    override
    protected void executeParse(BpmnParse bpmnParse, IntermediateCatchEvent event) {
        EventDefinition eventDefinition = null;
        if (!event.getEventDefinitions().isEmpty()) {
            eventDefinition = event.getEventDefinitions().get(0);
        }

        if (eventDefinition is null) {
            event.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchEventActivityBehavior(event));

        } else {
            if (cast(TimerEventDefinition)eventDefinition !is null || cast(SignalEventDefinition)eventDefinition !is null ||
                            cast(MessageEventDefinition)eventDefinition !is null || cast(ConditionalEventDefinition)eventDefinition !is null) {

                bpmnParse.getBpmnParserHandlers().parseElement(bpmnParse, eventDefinition);

            } else {
                logWarning("Unsupported intermediate catch event type for event {%s}", event.getId());
            }
        }
    }

}
