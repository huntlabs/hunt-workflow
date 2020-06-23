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
module flow.bpmn.converter.converter.SendTaskXMLConverter;

//import javax.xml.stream.XMLStreamReader;
//import javax.xml.stream.XMLStreamWriter;

//import flow.bpmn.converter.converter.exp.FieldExtensionExport;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ImplementationType;
import flow.bpmn.model.SendTask;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import hunt.xml;
import std.string;
/**
 * @author Tijs Rademakers
 */
class SendTaskXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(SendTask);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_TASK_SEND;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model) {
        SendTask sendTask = new SendTask();
        BpmnXMLUtil.addXMLLocation(sendTask, xtr);
        sendTask.setType(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_TYPE, xtr));
        Attribute arr = xtr.firstAttribute(ATTRIBUTE_TASK_IMPLEMENTATION);

        if (arr !is null && "##WebService" == (arr.getValue)) {
            sendTask.setImplementationType(ImplementationType.IMPLEMENTATION_TYPE_WEBSERVICE);
            Attribute a = xtr.firstAttribute(ATTRIBUTE_TASK_OPERATION_REF);
            sendTask.setOperationRef(parseOperationRef(a is null ? null : a.getValue, model));
        }

        parseChildElements(getXMLElementName(), sendTask, model, xtr);

        return sendTask;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //
    //    SendTask sendTask = (SendTask) element;
    //
    //    if (stringUtils.isNotEmpty(sendTask.getType())) {
    //        writeQualifiedAttribute(ATTRIBUTE_TYPE, sendTask.getType(), xtw);
    //    }
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    SendTask sendTask = (SendTask) element;
    //    didWriteExtensionStartElement = FieldExtensionExport.writeFieldExtensions(sendTask.getFieldExtensions(), didWriteExtensionStartElement, xtw);
    //    return didWriteExtensionStartElement;
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw) {
    //}

    protected string parseOperationRef(string operationRef, BpmnModel model) {
        string result = null;
        if (operationRef !is null && operationRef.length != 0) {
            int indexOfP = cast(int)operationRef.indexOf(':');
            if (indexOfP != -1) {
                string prefix = operationRef[0 .. indexOfP];
                string resolvedNamespace = model.getNamespace(prefix);
                result = resolvedNamespace ~ ":" ~ operationRef[indexOfP + 1 .. $];
            } else {
                result = model.getTargetNamespace() ~ ":" ~ operationRef;
            }
        }
        return result;
    }
}
