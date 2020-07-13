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
module flow.bpmn.converter.converter.child.ExecutionListenerParser;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.HasExecutionListeners;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.converter.converter.child.FlowableListenerParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class ExecutionListenerParser : FlowableListenerParser {


    override
    public string getElementName() {
        return ELEMENT_EXECUTION_LISTENER;
    }

    override
    public void addListenerToParent(FlowableListener listener, BaseElement parentElement) {
        if (cast(HasExecutionListeners)parentElement !is null) {
            if ((listener.getEvent().length != 0) &&  cast(SequenceFlow)parentElement !is null) {
                // No event type on a sequenceflow = 'take' implied
                listener.setEvent("take");
            }
            (cast(HasExecutionListeners) parentElement).getExecutionListeners().add(listener);
        }
    }
}
