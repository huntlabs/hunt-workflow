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
module flow.engine.impl.bpmn.parser.handler.StartEventParseHandler;

import hunt.collection.List;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.Message;
import flow.bpmn.model.MessageEventDefinition;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.TimerEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class StartEventParseHandler : AbstractActivityBpmnParseHandler!StartEvent {

    override
    BaseElement getHandledType() {
        return new StartEvent;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, StartEvent element) {
        if (element.getSubProcess() !is null && cast(EventSubProcess)element.getSubProcess() !is null) {
            if (element.getEventDefinitions() !is null && element.getEventDefinitions().size != 0) {
                EventDefinition eventDefinition = element.getEventDefinitions().get(0);
                if (cast(MessageEventDefinition)eventDefinition !is null) {
                    MessageEventDefinition messageDefinition = fillMessageRef(bpmnParse, eventDefinition);
                    element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessMessageStartEventActivityBehavior(element, messageDefinition));

                } else if (cast(SignalEventDefinition)eventDefinition !is null) {
                    SignalEventDefinition signalDefinition = cast(SignalEventDefinition) eventDefinition;
                    Signal signal = null;
                    if (bpmnParse.getBpmnModel().containsSignalId(signalDefinition.getSignalRef())) {
                        signal = bpmnParse.getBpmnModel().getSignal(signalDefinition.getSignalRef());
                    }

                    element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessSignalStartEventActivityBehavior(
                            element, signalDefinition, signal));

                } else if (cast(TimerEventDefinition)eventDefinition !is null) {
                    TimerEventDefinition timerEventDefinition = cast(TimerEventDefinition) eventDefinition;
                    element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessTimerStartEventActivityBehavior(
                            element, timerEventDefinition));

                } else if (cast(ErrorEventDefinition)eventDefinition !is null) {
                    element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessErrorStartEventActivityBehavior(element));

                } else if (cast(EscalationEventDefinition)eventDefinition !is null) {
                    element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessEscalationStartEventActivityBehavior(element));
                }

            } else {
                List!ExtensionElement eventTypeElements = element.getExtensionElements().get("eventType");
                if (eventTypeElements !is null && !eventTypeElements.isEmpty()) {
                    string eventType = eventTypeElements.get(0).getElementText();
                    if (eventType !is null && eventType.length != 0) {
                        element.setBehavior(bpmnParse.getActivityBehaviorFactory().createEventSubProcessEventRegistryStartEventActivityBehavior(element, eventType));
                    }
                }
            }

        } else if (element.getEventDefinitions() is null || element.getEventDefinitions().size == 0) {
            element.setBehavior(bpmnParse.getActivityBehaviorFactory().createNoneStartEventActivityBehavior(element));

        } else if (element.getEventDefinitions() !is null && element.getEventDefinitions().size != 0) {
            EventDefinition eventDefinition = element.getEventDefinitions().get(0);
            if (cast(MessageEventDefinition)eventDefinition !is null) {
                fillMessageRef(bpmnParse, eventDefinition);
            }
        }

        if (element.getSubProcess() is null && ((element.getEventDefinitions() is null || element.getEventDefinitions().size == 0) ||
                bpmnParse.getCurrentProcess().getInitialFlowElement() is null)) {

            bpmnParse.getCurrentProcess().setInitialFlowElement(element);
        }
    }

    protected MessageEventDefinition fillMessageRef(BpmnParse bpmnParse, EventDefinition eventDefinition) {
        MessageEventDefinition messageDefinition = cast(MessageEventDefinition) eventDefinition;
        BpmnModel bpmnModel = bpmnParse.getBpmnModel();
        string messageRef = messageDefinition.getMessageRef();
        if (bpmnModel.containsMessageId(messageRef)) {
            Message message = bpmnModel.getMessage(messageRef);
            messageDefinition.setMessageRef(message.getName());
            messageDefinition.setExtensionElements(message.getExtensionElements());
        }

        return messageDefinition;
    }

}
