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
module flow.engine.impl.bpmn.parser.handler.EndEventParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.EndEvent;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.Escalation;
import flow.bpmn.model.EscalationEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.model.TerminateEventDefinition;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.logging;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class EndEventParseHandler : AbstractActivityBpmnParseHandler!EndEvent {

    override
    BaseElement getHandledType() {
        return new EndEvent;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, EndEvent endEvent) {

        EventDefinition eventDefinition = null;
        if (endEvent.getEventDefinitions().size() > 0) {
            eventDefinition = endEvent.getEventDefinitions().get(0);

            if (cast(ErrorEventDefinition)eventDefinition !is null) {
                ErrorEventDefinition errorDefinition = cast(ErrorEventDefinition) eventDefinition;
                if (bpmnParse.getBpmnModel().containsErrorRef(errorDefinition.getErrorCode())) {
                    string errorCode = bpmnParse.getBpmnModel().getErrors().get(errorDefinition.getErrorCode());
                    if (errorCode !is null && errorCode.length != 0) {
                        logWarning("errorCode is required for an error event {%s}", endEvent.getId());
                    }
                }
                endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createErrorEndEventActivityBehavior(endEvent, errorDefinition));

            } else if (cast(EscalationEventDefinition)eventDefinition !is null) {
                EscalationEventDefinition escalationDefinition = cast(EscalationEventDefinition) eventDefinition;
                Escalation escalation = null;
                if (bpmnParse.getBpmnModel().containsEscalationRef(escalationDefinition.getEscalationCode())) {
                    escalation = bpmnParse.getBpmnModel().getEscalation(escalationDefinition.getEscalationCode());
                    string escalationCode = escalation.getEscalationCode();
                    if (escalationCode is null || escalationCode.length == 0) {
                        logWarning("escalationCode is required for an escalation event {%s}", endEvent.getId());
                    }
                }
                endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createEscalationEndEventActivityBehavior(endEvent, escalationDefinition, escalation));

            } else if (cast(TerminateEventDefinition)eventDefinition !is null) {
                endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createTerminateEndEventActivityBehavior(endEvent));
            } else if (cast(CancelEventDefinition)eventDefinition !is null) {
                endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createCancelEndEventActivityBehavior(endEvent));
            } else {
                endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createNoneEndEventActivityBehavior(endEvent));
            }

        } else {
            endEvent.setBehavior(bpmnParse.getActivityBehaviorFactory().createNoneEndEventActivityBehavior(endEvent));
        }
    }

}
