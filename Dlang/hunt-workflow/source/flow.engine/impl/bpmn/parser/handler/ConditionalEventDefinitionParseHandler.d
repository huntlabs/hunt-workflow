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
import org.flowable.bpmn.model.BoundaryEvent;
import org.flowable.bpmn.model.ConditionalEventDefinition;
import org.flowable.bpmn.model.IntermediateCatchEvent;
import flow.engine.impl.bpmn.parser.BpmnParse;

/**
 * @author Tijs Rademakers
 */
class ConditionalEventDefinitionParseHandler extends AbstractBpmnParseHandler<ConditionalEventDefinition> {

    @Override
    class<? extends BaseElement> getHandledType() {
        return ConditionalEventDefinition.class;
    }

    @Override
    protected void executeParse(BpmnParse bpmnParse, ConditionalEventDefinition eventDefinition) {
        if (bpmnParse.getCurrentFlowElement() instanceof IntermediateCatchEvent) {
            IntermediateCatchEvent intermediateCatchEvent = (IntermediateCatchEvent) bpmnParse.getCurrentFlowElement();
            intermediateCatchEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchConditionalEventActivityBehavior(
                            intermediateCatchEvent, eventDefinition, eventDefinition.getConditionExpression()));
            
        } else if (bpmnParse.getCurrentFlowElement() instanceof BoundaryEvent) {
            BoundaryEvent boundaryEvent = (BoundaryEvent) bpmnParse.getCurrentFlowElement();
            
            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryConditionalEventActivityBehavior(boundaryEvent, 
                                eventDefinition, eventDefinition.getConditionExpression(), boundaryEvent.isCancelActivity()));
        }
    }
}
