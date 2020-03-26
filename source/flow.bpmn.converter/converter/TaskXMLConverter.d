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
module flow.bpmn.converter.converter.TaskXMLConverter;


import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ManualTask;
import flow.bpmn.model.Task;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;

/**
 * @author Tijs Rademakers
 */
class TaskXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(Task);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        ManualTask manualTask = new ManualTask();
        BpmnXMLUtil.addXMLLocation(manualTask, xtr);
        parseChildElements(getXMLElementName(), manualTask, model, xtr);
        return manualTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //
    //}
}
