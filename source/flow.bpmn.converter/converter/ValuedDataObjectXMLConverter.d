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


import java.text.SimpleDateFormat;
import hunt.collection.List;
import java.util.regex.Pattern;

import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.XMLStreamWriter;

import org.apache.commons.lang3.StringUtils;
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

/**
 * @author Lori Small
 * @author Tijs Rademakers
 */
public class ValuedDataObjectXMLConverter extends BaseBpmnXMLConverter {

    private final Pattern xmlChars = Pattern.compile("[<>&]");
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    protected boolean didWriteExtensionStartElement;

    @Override
    public Class<? extends BaseElement> getBpmnElementType() {
        return ValuedDataObject.class;
    }

    @Override
    protected String getXMLElementName() {
        return ELEMENT_DATA_OBJECT;
    }

    @Override
    protected BaseElement convertXMLToElement(XMLStreamReader xtr, BpmnModel model) throws Exception {
        ValuedDataObject dataObject = null;
        ItemDefinition itemSubjectRef = new ItemDefinition();

        String structureRef = xtr.getAttributeValue(null, ATTRIBUTE_DATA_ITEM_REF);
        if (StringUtils.isNotEmpty(structureRef) && structureRef.contains(":")) {
            String dataType = structureRef.substring(structureRef.indexOf(':') + 1);

            if (dataType.equals("string")) {
                dataObject = new StringDataObject();
            } else if (dataType.equals("int")) {
                dataObject = new IntegerDataObject();
            } else if (dataType.equals("long")) {
                dataObject = new LongDataObject();
            } else if (dataType.equals("double")) {
                dataObject = new DoubleDataObject();
            } else if (dataType.equals("boolean")) {
                dataObject = new BooleanDataObject();
            } else if (dataType.equals("datetime")) {
                dataObject = new DateDataObject();
            } else {
                LOGGER.error("Error converting {}, invalid data type: {}", xtr.getAttributeValue(null, ATTRIBUTE_DATA_NAME), dataType);
            }

        } else {
            // use String as default type
            dataObject = new StringDataObject();
            structureRef = "xsd:string";
        }

        if (dataObject != null) {
            dataObject.setId(xtr.getAttributeValue(null, ATTRIBUTE_DATA_ID));
            dataObject.setName(xtr.getAttributeValue(null, ATTRIBUTE_DATA_NAME));

            BpmnXMLUtil.addXMLLocation(dataObject, xtr);

            itemSubjectRef.setStructureRef(structureRef);
            dataObject.setItemSubjectRef(itemSubjectRef);

            parseChildElements(getXMLElementName(), dataObject, model, xtr);

            List<ExtensionElement> valuesElement = dataObject.getExtensionElements().get("value");
            if (valuesElement != null && !valuesElement.isEmpty()) {
                ExtensionElement valueElement = valuesElement.get(0);
                if (StringUtils.isNotEmpty(valueElement.getElementText())) {
                    if (dataObject instanceof DateDataObject) {
                        try {
                            dataObject.setValue(sdf.parse(valueElement.getElementText()));
                        } catch (Exception e) {
                            LOGGER.error("Error converting {}; message={}", dataObject.getName(), e.getMessage());
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

    @Override
    protected void writeAdditionalAttributes(BaseElement element, BpmnModel model, XMLStreamWriter xtw) throws Exception {
        ValuedDataObject dataObject = (ValuedDataObject) element;
        if (dataObject.getItemSubjectRef() != null && StringUtils.isNotEmpty(dataObject.getItemSubjectRef().getStructureRef())) {
            writeDefaultAttribute(ATTRIBUTE_DATA_ITEM_REF, dataObject.getItemSubjectRef().getStructureRef(), xtw);
        }
    }

    @Override
    protected boolean writeExtensionChildElements(BaseElement element, boolean didWriteExtensionStartElement, XMLStreamWriter xtw) throws Exception {
        ValuedDataObject dataObject = (ValuedDataObject) element;

        if (StringUtils.isNotEmpty(dataObject.getId()) && dataObject.getValue() != null) {

            if (!didWriteExtensionStartElement) {
                xtw.writeStartElement(ELEMENT_EXTENSIONS);
                didWriteExtensionStartElement = true;
            }

            xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_DATA_VALUE, FLOWABLE_EXTENSIONS_NAMESPACE);
            if (dataObject.getValue() != null) {
                String value = null;
                if (dataObject instanceof DateDataObject) {
                    value = sdf.format(dataObject.getValue());
                } else {
                    value = dataObject.getValue().toString();
                }

                if (dataObject instanceof StringDataObject && xmlChars.matcher(value).find()) {
                    xtw.writeCData(value);
                } else {
                    xtw.writeCharacters(value);
                }
            }
            xtw.writeEndElement();
        }

        return didWriteExtensionStartElement;
    }

    @Override
    protected void writeAdditionalChildElements(BaseElement element, BpmnModel model, XMLStreamWriter xtw) throws Exception {
    }
}
