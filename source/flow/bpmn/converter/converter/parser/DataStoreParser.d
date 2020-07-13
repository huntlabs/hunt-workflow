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
module flow.bpmn.converter.converter.parser.DataStoreParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.DataStore;
import hunt.xml;

/**
 * @author Tijs Rademakers
 */
class DataStoreParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        string id = xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue;
        if (id.length != 0) {

            DataStore dataStore = new DataStore();
            dataStore.setId(id);

            string name = xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue;
            if (name.length != 0) {
                dataStore.setName(name);
            }

            string itemSubjectRef = xtr.firstAttribute(ATTRIBUTE_ITEM_SUBJECT_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ITEM_SUBJECT_REF).getValue;
            if (itemSubjectRef.length != 0) {
                dataStore.setItemSubjectRef(itemSubjectRef);
            }

            BpmnXMLUtil.addXMLLocation(dataStore, xtr);

            model.addDataStore(dataStore.getId(), dataStore);

            BpmnXMLUtil.parseChildElements(ELEMENT_DATA_STORE, dataStore, xtr, model);
        }
    }
}
