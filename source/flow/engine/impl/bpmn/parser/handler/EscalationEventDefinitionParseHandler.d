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
module flow.engine.impl.bpmn.parser.handler.EscalationEventDefinitionParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;
/**
 * @author Tijs Rademakers
 */
class EscalationEventDefinitionParseHandler : AbstractBpmnParseHandler!EscalationEventDefinition {

    override
    BaseElement getHandledType() {
        return new EscalationEventDefinition;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, EscalationEventDefinition eventDefinition) {
        if (cast(BoundaryEvent)bpmnParse.getCurrentFlowElement() !is null) {
            BoundaryEvent boundaryEvent = cast(BoundaryEvent) bpmnParse.getCurrentFlowElement();

            Escalation escalation = null;
            if (bpmnParse.getBpmnModel().containsEscalationRef(eventDefinition.getEscalationCode())) {
                escalation = bpmnParse.getBpmnModel().getEscalation(eventDefinition.getEscalationCode());
            }

            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryEscalationEventActivityBehavior(boundaryEvent,
                                eventDefinition, escalation, boundaryEvent.isCancelActivity()));
        }
    }
}
