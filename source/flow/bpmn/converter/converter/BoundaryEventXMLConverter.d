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
module flow.bpmn.converter.converter.BoundaryEventXMLConverter;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ErrorEventDefinition;
import flow.bpmn.model.EventDefinition;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import std.uni;
/**
 * @author Tijs Rademakers
 */
class BoundaryEventXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(BoundaryEvent);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_EVENT_BOUNDARY;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        BoundaryEvent boundaryEvent = new BoundaryEvent();
        BpmnXMLUtil.addXMLLocation(boundaryEvent, xtr);
        if (xtr.firstAttribute(ATTRIBUTE_BOUNDARY_CANCELACTIVITY) !is null && xtr.firstAttribute(ATTRIBUTE_BOUNDARY_CANCELACTIVITY).getValue.length != 0) {
            string cancelActivity = xtr.firstAttribute(ATTRIBUTE_BOUNDARY_CANCELACTIVITY).getValue;
            if (icmp(ATTRIBUTE_VALUE_FALSE,cancelActivity) == 0) {
                boundaryEvent.setCancelActivity(false);
            }
        }
        boundaryEvent.setAttachedToRefId(xtr.firstAttribute(ATTRIBUTE_BOUNDARY_ATTACHEDTOREF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_BOUNDARY_ATTACHEDTOREF).getValue);
        parseChildElements(getXMLElementName(), boundaryEvent, model, xtr);

        // Explicitly set cancel activity to false for error boundary events
        if (boundaryEvent.getEventDefinitions().size() == 1) {
            EventDefinition eventDef = boundaryEvent.getEventDefinitions().get(0);

            if (cast(ErrorEventDefinition)eventDef !is null) {
                boundaryEvent.setCancelActivity(false);
            }
        }

        return boundaryEvent;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    BoundaryEvent boundaryEvent = (BoundaryEvent) element;
    //    if (boundaryEvent.getAttachedToRef() !is null) {
    //        writeDefaultAttribute(ATTRIBUTE_BOUNDARY_ATTACHEDTOREF, boundaryEvent.getAttachedToRef().getId(), xtw);
    //    }
    //
    //    if (boundaryEvent.getEventDefinitions().size() == 1) {
    //        EventDefinition eventDef = boundaryEvent.getEventDefinitions().get(0);
    //
    //        if (!(eventDef instanceof ErrorEventDefinition)) {
    //            writeDefaultAttribute(ATTRIBUTE_BOUNDARY_CANCELACTIVITY, String.valueOf(boundaryEvent.isCancelActivity()).toLowerCase(), xtw);
    //        }
    //    }
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    BoundaryEvent boundaryEvent = (BoundaryEvent) element;
    //    writeEventDefinitions(boundaryEvent, boundaryEvent.getEventDefinitions(), model, xtw);
    //}
}
