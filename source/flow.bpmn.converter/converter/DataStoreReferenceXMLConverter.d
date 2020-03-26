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
module flow.bpmn.converter.converter.DataStoreReferenceXMLConverter;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataStoreReference;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class DataStoreReferenceXMLConverter : BaseBpmnXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(DataStoreReference);
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_DATA_STORE_REFERENCE;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        DataStoreReference dataStoreRef = new DataStoreReference();
        BpmnXMLUtil.addXMLLocation(dataStoreRef, xtr);
        parseChildElements(getXMLElementName(), dataStoreRef, model, xtr);
        return dataStoreRef;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    DataStoreReference dataStoreRef = (DataStoreReference) element;
    //    if (StringUtils.isNotEmpty(dataStoreRef.getDataStoreRef())) {
    //        xtw.writeAttribute(ATTRIBUTE_DATA_STORE_REF, dataStoreRef.getDataStoreRef());
    //    }
    //
    //    if (StringUtils.isNotEmpty(dataStoreRef.getItemSubjectRef())) {
    //        xtw.writeAttribute(ATTRIBUTE_ITEM_SUBJECT_REF, dataStoreRef.getItemSubjectRef());
    //    }
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    DataStoreReference dataStoreRef = (DataStoreReference) element;
    //    if (StringUtils.isNotEmpty(dataStoreRef.getDataState())) {
    //        xtw.writeStartElement(ELEMENT_DATA_STATE);
    //        xtw.writeAttribute(ATTRIBUTE_NAME, dataStoreRef.getDataState());
    //        xtw.writeEndElement();
    //    }
    //}
}
