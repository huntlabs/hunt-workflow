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


import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.ThrowEvent;
import flow.engine.impl.bpmn.parser.BpmnParse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Joram Barrez
 */
class IntermediateThrowEventParseHandler : AbstractActivityBpmnParseHandler!ThrowEvent {

    private static final Logger LOGGER = LoggerFactory.getLogger(IntermediateThrowEventParseHandler.class);

    override
    class<? : BaseElement> getHandledType() {
        return ThrowEvent.class;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, ThrowEvent intermediateEvent) {

        EventDefinition eventDefinition = null;
        if (!intermediateEvent.getEventDefinitions().isEmpty()) {
            eventDefinition = intermediateEvent.getEventDefinitions().get(0);
        }

        if (eventDefinition instanceof SignalEventDefinition) {
            SignalEventDefinition signalEventDefinition = (SignalEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowSignalEventActivityBehavior(intermediateEvent, signalEventDefinition,
                    bpmnParse.getBpmnModel().getSignal(signalEventDefinition.getSignalRef())));

        } else if (eventDefinition instanceof EscalationEventDefinition) {
            EscalationEventDefinition escalationEventDefinition = (EscalationEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowEscalationEventActivityBehavior(intermediateEvent, escalationEventDefinition,
                    bpmnParse.getBpmnModel().getEscalation(escalationEventDefinition.getEscalationCode())));

        } else if (eventDefinition instanceof CompensateEventDefinition) {
            CompensateEventDefinition compensateEventDefinition = (CompensateEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowCompensationEventActivityBehavior(intermediateEvent, compensateEventDefinition));

        } else if (eventDefinition is null) {
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowNoneEventActivityBehavior(intermediateEvent));
        } else {
            LOGGER.warn("Unsupported intermediate throw event type for throw event {}", intermediateEvent.getId());
        }
    }
}
