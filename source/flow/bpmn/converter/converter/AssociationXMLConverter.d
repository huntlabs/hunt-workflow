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
module flow.bpmn.converter.converter.AssociationXMLConverter;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.Association;
import flow.bpmn.model.AssociationDirection;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import hunt.Enum;
import std.uni, std.stdio;
/**
 * @author Tijs Rademakers
 */
class AssociationXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(Association);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_ASSOCIATION;
    }

    override
    BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        Association association = new Association();
        BpmnXMLUtil.addXMLLocation(association, xtr);
        association.setSourceRef(xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_SOURCE_REF).getValue());
        association.setTargetRef(xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_FLOW_TARGET_REF).getValue);
        association.setId(xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue);

        string associationDirectionString = xtr.firstAttribute(ATTRIBUTE_ASSOCIATION_DIRECTION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ASSOCIATION_DIRECTION).getValue;
        if (associationDirectionString.length != 0) {
            AssociationDirection associationDirection = valueOf!AssociationDirection(associationDirectionString.toUpper());

            association.setAssociationDirection(associationDirection);
        }

        parseChildElements(getXMLElementName(), association, model, xtr);

        return association;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    Association association = (Association) element;
    //    writeDefaultAttribute(ATTRIBUTE_FLOW_SOURCE_REF, association.getSourceRef(), xtw);
    //    writeDefaultAttribute(ATTRIBUTE_FLOW_TARGET_REF, association.getTargetRef(), xtw);
    //    AssociationDirection associationDirection = association.getAssociationDirection();
    //    if (associationDirection !is null) {
    //        writeDefaultAttribute(ATTRIBUTE_ASSOCIATION_DIRECTION, associationDirection.getValue(), xtw);
    //    }
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
}
