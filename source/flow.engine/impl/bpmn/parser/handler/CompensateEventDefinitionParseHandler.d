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
module flow.engine.impl.bpmn.parser.handler.CompensateEventDefinitionParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.ThrowEvent;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class CompensateEventDefinitionParseHandler : AbstractBpmnParseHandler!CompensateEventDefinition {

    override
    BaseElement getHandledType() {
        return new CompensateEventDefinition;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, CompensateEventDefinition eventDefinition) {

        if (cast(ThrowEvent)bpmnParse.getCurrentFlowElement() !is null) {
            ThrowEvent throwEvent = cast(ThrowEvent) bpmnParse.getCurrentFlowElement();
            throwEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateThrowCompensationEventActivityBehavior(
                    throwEvent, eventDefinition));

        } else if (cast(BoundaryEvent)bpmnParse.getCurrentFlowElement() !is null) {
            BoundaryEvent boundaryEvent = cast(BoundaryEvent) bpmnParse.getCurrentFlowElement();
            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryCompensateEventActivityBehavior(boundaryEvent,
                    eventDefinition, boundaryEvent.isCancelActivity()));

        } else {

            // What to do?

        }

    }

}
