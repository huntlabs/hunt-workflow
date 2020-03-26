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
module flow.bpmn.converter.converter.parser.ImportParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Import;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class ImportParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        Import importObject = new Import();
        BpmnXMLUtil.addXMLLocation(importObject, xtr);
        importObject.setImportType(xtr.firstAttribute(ATTRIBUTE_IMPORT_TYPE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_IMPORT_TYPE).getValue);
        importObject.setNamespace(xtr.firstAttribute(ATTRIBUTE_NAMESPACE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAMESPACE).getValue);
        importObject.setLocation(xtr.firstAttribute(ATTRIBUTE_LOCATION) is null ? "" : xtr.firstAttribute(ATTRIBUTE_LOCATION).getValue);
        model.getImports().add(importObject);
    }
}
