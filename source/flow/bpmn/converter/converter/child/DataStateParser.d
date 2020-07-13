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
module flow.bpmn.converter.converter.child.DataStateParser;


import flow.bpmn.model.BaseElement;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataStore;
import flow.bpmn.model.DataStoreReference;
import hunt.xml;
import flow.bpmn.converter.converter.child.BaseChildElementParser;
import flow.bpmn.converter.constants.BpmnXMLConstants;

/**
 * @author Tijs Rademakers
 */
class DataStateParser : BaseChildElementParser {

    override
    public string getElementName() {
        return ELEMENT_DATA_STATE;
    }

    override
    public void parseChildElement(Element xtr, BaseElement parentElement, BpmnModel model)  {
        if (cast(DataStore)parentElement !is null ) {
            (cast(DataStore) parentElement).setDataState(xtr.firstAttribute(ATTRIBUTE_NAME).getValue);

        } else if ( cast(DataStoreReference)parentElement !is null) {
            (cast(DataStoreReference) parentElement).setDataState(xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
        }
    }
}
