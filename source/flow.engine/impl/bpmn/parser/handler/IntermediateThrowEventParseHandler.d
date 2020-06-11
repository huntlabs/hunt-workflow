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
module flow.engine.impl.bpmn.parser.handler.IntermediateThrowEventParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.ThrowEvent;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class IntermediateThrowEventParseHandler : AbstractActivityBpmnParseHandler!ThrowEvent {


    override
    TypeInfo getHandledType() {
        return typeid(ThrowEvent);
    }

    override
    protected void executeParse(BpmnParse bpmnParse, ThrowEvent intermediateEvent) {

        EventDefinition eventDefinition = null;
        if (!intermediateEvent.getEventDefinitions().isEmpty()) {
            eventDefinition = intermediateEvent.getEventDefinitions().get(0);
        }

        if (cast(SignalEventDefinition)eventDefinition !is null) {
            SignalEventDefinition signalEventDefinition = cast(SignalEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowSignalEventActivityBehavior(intermediateEvent, signalEventDefinition,
                    bpmnParse.getBpmnModel().getSignal(signalEventDefinition.getSignalRef())));

        } else if (cast(EscalationEventDefinition)eventDefinition !is null) {
            EscalationEventDefinition escalationEventDefinition = cast(EscalationEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowEscalationEventActivityBehavior(intermediateEvent, escalationEventDefinition,
                    bpmnParse.getBpmnModel().getEscalation(escalationEventDefinition.getEscalationCode())));

        } else if (cast(CompensateEventDefinition)eventDefinition !is null) {
            CompensateEventDefinition compensateEventDefinition = cast(CompensateEventDefinition) eventDefinition;
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowCompensationEventActivityBehavior(intermediateEvent, compensateEventDefinition));

        } else if (eventDefinition is null) {
            intermediateEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowNoneEventActivityBehavior(intermediateEvent));
        } else {
            logWarning("Unsupported intermediate throw event type for throw event {%s}", intermediateEvent.getId());
        }
    }
}
