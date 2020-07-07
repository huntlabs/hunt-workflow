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
module flow.engine.impl.bpmn.parser.handler.SequenceFlowParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.SequenceFlow;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;
import flow.bpmn.model.Process;
/**
 * @author Joram Barrez
 */
class SequenceFlowParseHandler : AbstractBpmnParseHandler!SequenceFlow {

    public static  string PROPERTYNAME_CONDITION = "condition";
    public static  string PROPERTYNAME_CONDITION_TEXT = "conditionText";

    override
    BaseElement getHandledType() {
        return new SequenceFlow;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, SequenceFlow sequenceFlow) {
        flow.bpmn.model.Process.Process process = bpmnParse.getCurrentProcess();
        sequenceFlow.setSourceFlowElement(process.getFlowElement(sequenceFlow.getSourceRef(), true));
        sequenceFlow.setTargetFlowElement(process.getFlowElement(sequenceFlow.getTargetRef(), true));
    }

}
