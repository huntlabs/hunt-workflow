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
module flow.engine.impl.bpmn.parser.handler.ConditionalEventDefinitionParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;
/**
 * @author Tijs Rademakers
 */
class ConditionalEventDefinitionParseHandler : AbstractBpmnParseHandler!ConditionalEventDefinition {

    override
    BaseElement getHandledType() {
        return new ConditionalEventDefinition;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, ConditionalEventDefinition eventDefinition) {
        if (cast(IntermediateCatchEvent)bpmnParse.getCurrentFlowElement() !is null) {
            IntermediateCatchEvent intermediateCatchEvent = cast(IntermediateCatchEvent) bpmnParse.getCurrentFlowElement();
            intermediateCatchEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchConditionalEventActivityBehavior(
                            intermediateCatchEvent, eventDefinition, eventDefinition.getConditionExpression()));

        } else if (cast(BoundaryEvent)bpmnParse.getCurrentFlowElement() !is null) {
            BoundaryEvent boundaryEvent = cast(BoundaryEvent) bpmnParse.getCurrentFlowElement();

            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryConditionalEventActivityBehavior(boundaryEvent,
                                eventDefinition, eventDefinition.getConditionExpression(), boundaryEvent.isCancelActivity()));
        }
    }
}
