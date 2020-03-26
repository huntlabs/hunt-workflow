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
module flow.bpmn.converter.converter.parser.ProcessParser;

import hunt.collection.List;

import flow.bpmn.converter.converter.exp.ProcessExport;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.Process;
import hunt.xml;
import std.string;
import hunt.Boolean;
/**
 * @author Tijs Rademakers
 */
class ProcessParser : BpmnXMLConstants {

    public Process parse(Element xtr, BpmnModel model)  {
        Process process = null;
        if (xtr.firstAttribute(ATTRIBUTE_ID) !is null && xtr.firstAttribute(ATTRIBUTE_ID).getValue.length != 0) {
            auto processId = xtr.firstAttribute(ATTRIBUTE_ID);
            process = new Process();
            process.setId(processId.getValue);
            BpmnXMLUtil.addXMLLocation(process, xtr);
            process.setName(xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue);
            if (xtr.firstAttribute(ATTRIBUTE_PROCESS_EXECUTABLE) !is null && xtr.firstAttribute(ATTRIBUTE_PROCESS_EXECUTABLE).getValue.length != 0) {
                process.setExecutable(Boolean.parseBoolean(xtr.firstAttribute(ATTRIBUTE_PROCESS_EXECUTABLE) is null ? "" : xtr.firstAttribute(ATTRIBUTE_PROCESS_EXECUTABLE).getValue));
            }

            string candidateUsersstring = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_CANDIDATE_USERS, xtr);
            if (candidateUsersstring !is null && candidateUsersstring.length != 0) {
                List!string candidateUsers = BpmnXMLUtil.parseDelimitedList(candidateUsersstring);
                process.setCandidateStarterUsers(candidateUsers);
            }

            string candidateGroupsstring = BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_CANDIDATE_GROUPS, xtr);
            if (candidateGroupsstring !is null && candidateGroupsstring.length != 0) {
                List!string candidateGroups = BpmnXMLUtil.parseDelimitedList(candidateGroupsstring);
                process.setCandidateStarterGroups(candidateGroups);
            }

            if (BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING, xtr) !is null && BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING, xtr).length != 0) {
                process.setEnableEagerExecutionTreeFetching(
                        Boolean.parseBoolean(BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING, xtr) is null ? "" : BpmnXMLUtil.getAttributeValue(ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING, xtr)));
            }

            BpmnXMLUtil.addCustomAttributes(xtr, process, ProcessExport.defaultProcessAttributes);

            model.getProcesses().add(process);

        }
        return process;
    }
}
