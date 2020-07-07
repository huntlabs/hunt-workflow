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
module flow.engine.impl.bpmn.parser.handler.AdhocSubProcessParseHandler;

import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.SubProcess;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.collection.Collection;
import flow.engine.impl.bpmn.parser.handler.AbstractBpmnParseHandler;
/**
 * @author Tijs Rademakers
 */
class AdhocSubProcessParseHandler : AbstractActivityBpmnParseHandler!SubProcess {


    //alias getHandledTypes = AbstractBpmnParseHandler.getHandledTypes;

    override
    protected BaseElement getHandledType() {
        return new AdhocSubProcess;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, SubProcess subProcess) {

        subProcess.setBehavior(bpmnParse.getActivityBehaviorFactory().createAdhocSubprocessActivityBehavior(subProcess));

        bpmnParse.processFlowElements(subProcess.getFlowElements());
        processArtifacts(bpmnParse, subProcess.getArtifacts());
    }

    override
    Collection!BaseElement getHandledTypes()
    {
        return super.getHandledTypes;
    }

}
