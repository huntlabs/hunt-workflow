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
module flow.engine.impl.bpmn.parser.handler.SignalEventDefinitionParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class SignalEventDefinitionParseHandler : AbstractBpmnParseHandler!SignalEventDefinition {

    override
    BaseElement getHandledType() {
        return new SignalEventDefinition;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, SignalEventDefinition signalDefinition) {

        Signal signal = null;
        if (bpmnParse.getBpmnModel().containsSignalId(signalDefinition.getSignalRef())) {
            signal = bpmnParse.getBpmnModel().getSignal(signalDefinition.getSignalRef());
        }

        if (cast(IntermediateCatchEvent)bpmnParse.getCurrentFlowElement() !is null) {
            IntermediateCatchEvent intermediateCatchEvent = cast(IntermediateCatchEvent) bpmnParse.getCurrentFlowElement();
            intermediateCatchEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchSignalEventActivityBehavior(intermediateCatchEvent, signalDefinition, signal));

        } else if (cast(BoundaryEvent)bpmnParse.getCurrentFlowElement() !is null) {
            BoundaryEvent boundaryEvent = cast(BoundaryEvent) bpmnParse.getCurrentFlowElement();
            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundarySignalEventActivityBehavior(boundaryEvent, signalDefinition, signal, boundaryEvent.isCancelActivity()));
        }
    }
}
