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
module flow.bpmn.converter.converter.child.TaskListenerParser;

import flow.bpmn.converter.converter.child.FlowableListenerParser;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.UserTask;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.uni;
/**
 * @author Tijs Rademakers
 */
class TaskListenerParser : FlowableListenerParser {

    override
    public string getElementName() {
        return ELEMENT_TASK_LISTENER;
    }

    override
    public void addListenerToParent(FlowableListener listener, BaseElement parentElement) {
        if ( cast(UserTask)parentElement !is null ) {
            (cast(UserTask) parentElement).getTaskListeners().add(listener);
        }
    }
}
