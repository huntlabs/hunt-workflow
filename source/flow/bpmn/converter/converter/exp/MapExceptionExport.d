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
//import org.apache.commons.lang3.StringUtils;
//import flow.bpmn.converter.constants.BpmnXMLConstants;
//import flow.bpmn.converter.converter.util.BpmnXMLUtil;
//import flow.bpmn.model.MapExceptionEntry;
//
//import javax.xml.stream.XMLStreamWriter;
//import hunt.collection.List;
//
//class MapExceptionExport implements BpmnXMLConstants {
//
//    public static bool writeMapExceptionExtensions(List<MapExceptionEntry> mapExceptionList, bool didWriteExtensionStartElement, XMLStreamWriter xtw)  {
//
//        for (MapExceptionEntry mapException : mapExceptionList) {
//
//            if (!didWriteExtensionStartElement) {
//                xtw.writeStartElement(ELEMENT_EXTENSIONS);
//                didWriteExtensionStartElement = true;
//            }
//
//            if (StringUtils.isNotEmpty(mapException.getErrorCode())) {
//                xtw.writeStartElement(FLOWABLE_EXTENSIONS_PREFIX, MAP_EXCEPTION, FLOWABLE_EXTENSIONS_NAMESPACE);
//
//                BpmnXMLUtil.writeDefaultAttribute(MAP_EXCEPTION_ERRORCODE, mapException.getErrorCode(), xtw);
//                BpmnXMLUtil.writeDefaultAttribute(MAP_EXCEPTION_ANDCHILDREN, Boolean.toString(mapException.isAndChildren()), xtw);
//
//                if (StringUtils.isNotEmpty(mapException.getClassName())) {
//                    xtw.writeCData(mapException.getClassName());
//                }
//                xtw.writeEndElement(); //end flowable:mapException
//            }
//        }
//        return didWriteExtensionStartElement;
//    }
//
//}
