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
module flow.bpmn.converter.converter.StartEventXMLConverter;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.alfresco.AlfrescoStartEvent;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class StartEventXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(StartEvent);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_EVENT_START;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        string formKey = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_FORM_FORMKEY, xtr);
        StartEvent startEvent = null;
        if (formKey !is null && formKey.length != 0) {
            if (model.getStartEventFormTypes() !is null && model.getStartEventFormTypes().contains(formKey)) {
                startEvent = new AlfrescoStartEvent();
            }
        }
        if (startEvent is null) {
            startEvent = new StartEvent();
        }

        BpmnXMLUtil.addXMLLocation(startEvent, xtr);
        startEvent.setInitiator(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_EVENT_START_INITIATOR, xtr));
        bool interrupting = true;
        string interruptingAttribute = xtr.firstAttribute(ATTRIBUTE_EVENT_START_INTERRUPTING) is null ? "" : xtr.firstAttribute(ATTRIBUTE_EVENT_START_INTERRUPTING).getValue;
        if (ATTRIBUTE_VALUE_FALSE == interruptingAttribute) {
            interrupting = false;
        }

        startEvent.setInterrupting(interrupting);
        startEvent.setFormKey(formKey);
        string formValidation = BpmnXMLUtil.getAttributeValue(BpmnXMLConstants.ATTRIBUTE_FORM_FIELD_VALIDATION, xtr);
        startEvent.setValidateFormFields(formValidation);

        parseChildElements(getXMLElementName(), startEvent, model, xtr);

        return startEvent;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    StartEvent startEvent = (StartEvent) element;
    //    writeQualifiedAttribute(ATTRIBUTE_EVENT_START_INITIATOR, startEvent.getInitiator(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_FORM_FORMKEY, startEvent.getFormKey(), xtw);
    //    writeQualifiedAttribute(ATTRIBUTE_FORM_FIELD_VALIDATION, startEvent.getValidateFormFields(), xtw);
    //
    //    if (startEvent.getEventDefinitions() !is null && startEvent.getEventDefinitions().size() > 0) {
    //        writeDefaultAttribute(ATTRIBUTE_EVENT_START_INTERRUPTING, String.valueOf(startEvent.isInterrupting()), xtw);
    //    }
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    StartEvent startEvent = (StartEvent) element;
    //    didWriteExtensionStartElement = writeFormProperties(startEvent, didWriteExtensionStartElement, xtw);
    //    return didWriteExtensionStartElement;
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    StartEvent startEvent = (StartEvent) element;
    //    writeEventDefinitions(startEvent, startEvent.getEventDefinitions(), model, xtw);
    //}
}
