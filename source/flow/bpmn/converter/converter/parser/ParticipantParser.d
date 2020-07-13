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
module flow.bpmn.converter.converter.parser.ParticipantParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Pool;
import hunt.xml;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class ParticipantParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {

        if (xtr.firstAttribute(ATTRIBUTE_ID) !is null && xtr.firstAttribute(ATTRIBUTE_ID).getValue.length != 0) {
            Pool pool = new Pool();
            pool.setId(xtr.firstAttribute(ATTRIBUTE_ID).getValue);
            pool.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
            pool.setProcessRef(xtr.firstAttribute(ATTRIBUTE_PROCESS_REF) is null ? "" : xtr.firstAttribute(ATTRIBUTE_PROCESS_REF).getValue);
            BpmnXMLUtil.parseChildElements(ELEMENT_PARTICIPANT, pool, xtr, model);
            model.getPools().add(pool);
        }
    }
}
