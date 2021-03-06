///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection.List;
//
//import javax.xml.stream.XMLStreamWriter;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.bpmn.converter.constants.BpmnXMLConstants;
//import flow.bpmn.converter.converter.util.BpmnXMLUtil;
//import flow.bpmn.model.FieldExtension;
//
//class FieldExtensionExport implements BpmnXMLConstants {
//
//    public static bool writeFieldExtensions(List<FieldExtension> fieldExtensionList, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
//
//        for (FieldExtension fieldExtension : fieldExtensionList) {
//
//            if (StringUtils.isNotEmpty(fieldExtension.getFieldName())) {
//
//                if (StringUtils.isNotEmpty(fieldExtension.getStringValue()) || StringUtils.isNotEmpty(fieldExtension.getExpression())) {
//
//                    if (!didWriteExtensionStartElement) {
//                        xtw.writeStartElement(ELEMENT_EXTENSIONS);
//                        didWriteExtensionStartElement = true;
//                    }
//
//                    xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_FIELD, FLOWABLE_EXTENSIONS_NAMESPACE);
//                    BpmnXMLUtil.writeDefaultAttribute(ATTRIBUTE_FIELD_NAME, fieldExtension.getFieldName(), xtw);
//
//                    if (StringUtils.isNotEmpty(fieldExtension.getStringValue())) {
//                        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ELEMENT_FIELD_STRING, FLOWABLE_EXTENSIONS_NAMESPACE);
//                        xtw.writeCData(fieldExtension.getStringValue());
//                    } else {
//                        xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, ATTRIBUTE_FIELD_EXPRESSION, FLOWABLE_EXTENSIONS_NAMESPACE);
//                        xtw.writeCData(fieldExtension.getExpression());
//                    }
//                    xtw.writeEndElement();
//                    xtw.writeEndElement();
//                }
//            }
//        }
//        return didWriteExtensionStartElement;
//    }
//}
