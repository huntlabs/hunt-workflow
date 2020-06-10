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
module flow.engine.impl.bpmn.parser.handler.SubProcessParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.SubProcess;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
/**
 * @author Joram Barrez
 */
class SubProcessParseHandler : AbstractActivityBpmnParseHandler!SubProcess {

    override
    protected TypeInfo getHandledType() {
        return typeid(SubProcess);
    }

    override
    protected void executeParse(BpmnParse bpmnParse, SubProcess subProcess) {

        subProcess.setBehavior(bpmnParse.getActivityBehaviorFactory().createSubprocessActivityBehavior(subProcess));

        bpmnParse.processFlowElements(subProcess.getFlowElements());
        processArtifacts(bpmnParse, subProcess.getArtifacts());

        // no data objects for event subprocesses
        /*
         * if (!(subProcess instanceof EventSubProcess)) { // parse out any data objects from the template in order to set up the necessary process variables Map!(string, Object) variables =
         * processDataObjects(bpmnParse, subProcess.getDataObjects(), activity); activity.setVariables(variables); }
         *
         * bpmnParse.removeCurrentScope(); bpmnParse.removeCurrentSubProcess();
         *
         * if (subProcess.getIoSpecification() !is null) { IOSpecification ioSpecification = createIOSpecification(bpmnParse, subProcess.getIoSpecification());
         * activity.setIoSpecification(ioSpecification); }
         */

    }

}
