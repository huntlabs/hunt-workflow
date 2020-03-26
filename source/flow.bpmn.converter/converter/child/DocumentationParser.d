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
module flow.bpmn.converter.converter.child.DocumentationParser;


import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class DocumentationParser : BaseChildElementParser {

    override
    public string getElementName() {
        return "documentation";
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        string docText = xtr.getText();
        if (docText.length != 0) {
            if (cast(FlowElement)parentElement !is null) {
                (cast(FlowElement) parentElement).setDocumentation(docText);
            } else if (cast(Process)parentElement !is null) {
                (cast(Process) parentElement).setDocumentation(docText);
            }
        }
    }
}
