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
module flow.bpmn.converter.converter.CaseServiceTaskXMLConverter;

import flow.bpmn.converter.converter.ServiceTaskXMLConverter;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.BaseBpmnXMLConverter;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class CaseServiceTaskXMLConverter : ServiceTaskXMLConverter {

    override
    public TypeInfo getBpmnElementType() {
        return typeid(CaseServiceTask);
    }

}
