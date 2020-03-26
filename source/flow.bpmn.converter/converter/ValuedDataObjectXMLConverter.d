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
module flow.bpmn.converter.converter.ValuedDataObjectXMLConverter;

//import java.text.SimpleDateFormat;
import hunt.collection.List;
//import java.util.regex.Pattern;

import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BooleanDataObject;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DateDataObject;
import flow.bpmn.model.DoubleDataObject;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.IntegerDataObject;
import flow.bpmn.model.ItemDefinition;
import flow.bpmn.model.LongDataObject;
import flow.bpmn.model.StringDataObject;
import flow.bpmn.model.ValuedDataObject;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
import hunt.text.Pattern;
import hunt.logging;
import hunt.Exceptions;
/**
 * @author Lori Small
 * @author Tijs Rademakers
 */
class ValuedDataObjectXMLConverter : BaseBpmnXMLConverter {

   // private  Pattern xmlChars = Pattern.compile("[<>&]");
    //private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    protected bool didWriteExtensionStartElement;

    override
    public TypeInfo getBpmnElementType() {
        return ValuedDataObject;
    }

    override
    protected string getXMLElementName() {
        return ELEMENT_DATA_OBJECT;
    }

    override
    protected BaseElement convertXMLToElement(Element xtr, BpmnModel model)  {
        ValuedDataObject dataObject = null;
        ItemDefinition itemSubjectRef = new ItemDefinition();

        string structureRef = xtr.firstAttribute(ATTRIBUTE_DATA_ITEM_REF) is null ? "" :  xtr.firstAttribute(ATTRIBUTE_DATA_ITEM_REF).getValue;
        if ((structureRef.length != 0) && structureRef.contains(":")) {
            string dataType = structureRef[structureRef.indexOf(':') + 1 .. $];

            if (dataType == ("string")) {
                dataObject = new StringDataObject();
            } else if (dataType == ("int")) {
                dataObject = new IntegerDataObject();
            } else if (dataType == ("long")) {
                dataObject = new LongDataObject();
            } else if (dataType == ("double")) {
                dataObject = new DoubleDataObject();
            } else if (dataType == ("boolean")) {
                dataObject = new BooleanDataObject();
            } else if (dataType == ("datetime")) {
                dataObject = new DateDataObject();
            } else {
                logError("Error converting {%s}, invalid data type: {%s}", xtr.toString, dataType);
            }

        } else {
            // use String as default type
            dataObject = new StringDataObject();
            structureRef = "xsd:string";
        }

        if (dataObject !is null) {
            dataObject.setId(xtr.firstAttribute(ATTRIBUTE_DATA_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_DATA_ID).getValue);
            dataObject.setName(xtr.firstAttribute(ATTRIBUTE_DATA_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_DATA_NAME).getValue);

            BpmnXMLUtil.addXMLLocation(dataObject, xtr);

            itemSubjectRef.setStructureRef(structureRef);
            dataObject.setItemSubjectRef(itemSubjectRef);

            parseChildElements(getXMLElementName(), dataObject, model, xtr);

            List!ExtensionElement valuesElement = dataObject.getExtensionElements().get("value");
            if (valuesElement !is null && !valuesElement.isEmpty()) {
                ExtensionElement valueElement = valuesElement.get(0);
                if (valueElement.getElementText() !is null && valueElement.getElementText().length != 0) {
                    if (cast(DateDataObject)dataObject !is null ) {
                        try {
                            implementationMissing(false);
                          //  dataObject.setValue(sdf.parse(valueElement.getElementText()));
                        } catch (Exception e) {
                            logError("Error converting {%s}; message={%s}", dataObject.getName(), e.getMessage());
                        }
                    } else {
                        dataObject.setValue(valueElement.getElementText());
                    }
                }

                // remove value element
                dataObject.getExtensionElements().remove("value");
            }
        }

        return dataObject;
    }

    //override
    //protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //    ValuedDataObject dataObject = (ValuedDataObject) element;
    //    if (dataObject.getItemSubjectRef() !is null && StringUtils.isNotEmpty(dataObject.getItemSubjectRef().getStructureRef())) {
    //        writeDefaultAttribute(ATTRIBUTE_DATA_ITEM_REF, dataObject.getItemSubjectRef().getStructureRef(), xtw);
    //    }
    //}
    //
    //override
    //protected bool writeExtensionChildElements(BaseElement element, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
    //    ValuedDataObject dataObject = (ValuedDataObject) element;
    //
    //    if (StringUtils.isNotEmpty(dataObject.getId()) && dataObject.getValue() !is null) {
    //
    //        if (!didWriteExtensionStartElement) {
    //            xtw.writeStartElement(ELEMENT_EXTENSIONS);
    //            didWriteExtensionStartElement = true;
    //        }
    //
    //        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_DATA_VALUE, FLOWABLE_EXTENSIONS_NAMESPACE);
    //        if (dataObject.getValue() !is null) {
    //            String value = null;
    //            if (dataObject instanceof DateDataObject) {
    //                value = sdf.format(dataObject.getValue());
    //            } else {
    //                value = dataObject.getValue().toString();
    //            }
    //
    //            if (dataObject instanceof StringDataObject && xmlChars.matcher(value).find()) {
    //                xtw.writeCData(value);
    //            } else {
    //                xtw.writeCharacters(value);
    //            }
    //        }
    //        xtw.writeEndElement();
    //    }
    //
    //    return didWriteExtensionStartElement;
    //}
    //
    //override
    //protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw)  {
    //}
}
