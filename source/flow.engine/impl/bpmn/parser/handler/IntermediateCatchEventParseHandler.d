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


import org.flowable.bpmn.model.BaseElement;
import org.flowable.bpmn.model.ConditionalEventDefinition;
import org.flowable.bpmn.model.EventDefinition;
import org.flowable.bpmn.model.IntermediateCatchEvent;
import org.flowable.bpmn.model.MessageEventDefinition;
import org.flowable.bpmn.model.SignalEventDefinition;
import org.flowable.bpmn.model.TimerEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class IntermediateCatchEventParseHandler extends AbstractFlowNodeBpmnParseHandler<IntermediateCatchEvent> {

    private static final Logger LOGGER = LoggerFactory.getLogger(IntermediateCatchEventParseHandler.class);

    @Override
    class<? extends BaseElement> getHandledType() {
        return IntermediateCatchEvent.class;
    }

    @Override
    protected void executeParse(BpmnParse bpmnParse, IntermediateCatchEvent event) {
        EventDefinition eventDefinition = null;
        if (!event.getEventDefinitions().isEmpty()) {
            eventDefinition = event.getEventDefinitions().get(0);
        }

        if (eventDefinition is null) {
            event.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchEventActivityBehavior(event));

        } else {
            if (eventDefinition instanceof TimerEventDefinition || eventDefinition instanceof SignalEventDefinition || 
                            eventDefinition instanceof MessageEventDefinition || eventDefinition instanceof ConditionalEventDefinition) {

                bpmnParse.getBpmnParserHandlers().parseElement(bpmnParse, eventDefinition);

            } else {
                LOGGER.warn("Unsupported intermediate catch event type for event {}", event.getId());
            }
        }
    }

}
