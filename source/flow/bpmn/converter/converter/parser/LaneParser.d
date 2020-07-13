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
module flow.bpmn.converter.converter.parser.LaneParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Lane;
import flow.bpmn.model.Process;
import hunt.xml;
/**
 * @author Tijs Rademakers
 */
class LaneParser : BpmnXMLConstants {

    public void parse(Element xtr, Process activeProcess, BpmnModel model)  {
        Lane lane = new Lane();
        BpmnXMLUtil.addXMLLocation(lane, xtr);
        lane.setId(xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue);
        lane.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
        lane.setParentProcess(activeProcess);
        activeProcess.getLanes().add(lane);
        BpmnXMLUtil.parseChildElements(ELEMENT_LANE, lane, xtr, model);
    }
}
