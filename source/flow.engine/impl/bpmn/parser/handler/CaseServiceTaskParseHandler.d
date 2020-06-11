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
module flow.engine.impl.bpmn.parser.handler.CaseServiceTaskParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CaseServiceTask;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
/**
 * @author Tijs Rademakers
 */
class CaseServiceTaskParseHandler : AbstractActivityBpmnParseHandler!CaseServiceTask {

    override
     TypeInfo getHandledType() {
        return typeid(CaseServiceTask);
    }

    override
    protected void executeParse(BpmnParse bpmnParse, CaseServiceTask caseServiceTask) {
        caseServiceTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createCaseTaskBehavior(caseServiceTask));
    }

}
