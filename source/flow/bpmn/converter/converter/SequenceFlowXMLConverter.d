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
module flow.bpmn.converter.converter.SequenceFlowXMLConverter;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;

/**
 * @author Tijs Rademakers
 */
class SequenceFlowXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(SequenceFlow);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_SEQUENCE_FLOW;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        SequenceFlow sequenceFlow = new SequenceFlow();
        BpmnXMLUtil.addXMLLocation(sequenceFlow, xtr);
        sequenceFlow.setSourceRef(xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF).getValue);
        sequenceFlow.setTargetRef(xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF).getValue);
        sequenceFlow.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
        sequenceFlow.setSkipExpression(xtr.firstAttribute(ATTRIBUTE_FLOW_SKIP_EXPRESSION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_SKIP_EXPRESSION).getValue);

        parseChildElements(getXMLElementName(), sequenceFlow, model, xtr);

        return sequenceFlow;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    SequenceFlow sequenceFlow = (SequenceFlow) element;
    //    writeDefaultAttribute(ATTRIBUTE_FLOW_SOURCE_REF, sequenceFlow.getSourceRef(), xtw);
    //    writeDefaultAttribute(ATTRIBUTE_FLOW_TARGET_REF, sequenceFlow.getTargetRef(), xtw);
    //    if (StringUtils.isNotEmpty(sequenceFlow.getSkipExpression())) {
    //        writeDefaultAttribute(ATTRIBUTE_FLOW_SKIP_EXPRESSION, sequenceFlow.getSkipExpression(), xtw);
    //    }
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    SequenceFlow sequenceFlow = (SequenceFlow) element;
    //
    //    if (StringUtils.isNotEmpty(sequenceFlow.getConditionExpression())) {
    //        xtw.writeStartElement(ELEMENT_FLOW_CONDITION);
    //        xtw.writeAttribute(XSI_PREFIX, XSI_NAMESPACE, "type", "tFormalExpression");
    //        xtw.writeCData(sequenceFlow.getConditionExpression());
    //        xtw.writeEndElement();
    //    }
    //}
}
