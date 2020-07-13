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
module flow.engine.impl.bpmn.parser.handler.ScriptTaskParseHandler;

import flow.bpmn.model.BaseElement;
import flow.bpmn.model.ScriptTask;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class ScriptTaskParseHandler : AbstractActivityBpmnParseHandler!ScriptTask {

    override
    BaseElement getHandledType() {
        return new ScriptTask;
    }

    override
    protected void executeParse(BpmnParse bpmnParse, ScriptTask scriptTask) {

        if (scriptTask.getScript() is null || scriptTask.getScript().length == 0) {
            logWarning("No script provided for scriptTask {%s}", scriptTask.getId());
        }

        scriptTask.setBehavior(bpmnParse.getActivityBehaviorFactory().createScriptTaskActivityBehavior(scriptTask));

    }

}
