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
module flow.engine.impl.bpmn.parser.handler.MessageEventDefinitionParseHandler;

import hunt.collection.List;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.IntermediateCatchEvent;
import flow.bpmn.model.Message;
import flow.bpmn.model.MessageEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class MessageEventDefinitionParseHandler : AbstractBpmnParseHandler!MessageEventDefinition {

    override
    BaseElement getHandledType() {
        return new MessageEventDefinition;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, MessageEventDefinition messageDefinition) {
        BpmnModel bpmnModel = bpmnParse.getBpmnModel();
        string messageRef = messageDefinition.getMessageRef();
        if (bpmnModel.containsMessageId(messageRef)) {
            Message message = bpmnModel.getMessage(messageRef);
            messageDefinition.setMessageRef(message.getName());

            foreach(List!ExtensionElement extensionElementList ; message.getExtensionElements().values()) {
                foreach(ExtensionElement extensionElement ; extensionElementList) {
                    messageDefinition.addExtensionElement(extensionElement);
                }
            }
        }

        if (cast(IntermediateCatchEvent)bpmnParse.getCurrentFlowElement() !is null) {
            IntermediateCatchEvent intermediateCatchEvent = cast(IntermediateCatchEvent) bpmnParse.getCurrentFlowElement();
            intermediateCatchEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createIntermediateCatchMessageEventActivityBehavior(intermediateCatchEvent, messageDefinition));

        } else if (cast(BoundaryEvent)bpmnParse.getCurrentFlowElement() !is null) {
            BoundaryEvent boundaryEvent = cast(BoundaryEvent) bpmnParse.getCurrentFlowElement();
            boundaryEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createBoundaryMessageEventActivityBehavior(boundaryEvent, messageDefinition, boundaryEvent.isCancelActivity()));
        }

        else {
            // What to do here?
        }

    }

}
