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
module flow.bpmn.converter.converter.parser.ResourceParser;


import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.converter.converter.util.BpmnXMLUtil;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Resource;
import flow.bpmn.model.UserTask;
import hunt.xml;
import flow.bpmn.model.Process;
/**
 * @author Tim Stephenson
 */
class ResourceParser : BpmnXMLConstants {

    public void parse(Element xtr, BpmnModel model)  {
        string resourceId = xtr.firstAttribute(ATTRIBUTE_ID) is null ? "" : xtr.firstAttribute(ATTRIBUTE_ID).getValue;
        string resourceName = xtr.firstAttribute(ATTRIBUTE_NAME) is null ? "" : xtr.firstAttribute(ATTRIBUTE_NAME).getValue;

        Resource resource;
        if (model.containsResourceId(resourceId)) {
            resource = model.getResource(resourceId);
            resource.setName(resourceName);
            foreach (flow.bpmn.model.Process.Process process ; model.getProcesses()) {
                foreach (FlowElement fe ; process.getFlowElements()) {
                    if (cast(UserTask)fe !is null
                            && (cast(UserTask) fe).getCandidateGroups().contains(resourceId)) {
                        (cast(UserTask) fe).getCandidateGroups().remove(resourceId);
                        (cast(UserTask) fe).getCandidateGroups().add(resourceName);
                    }
                }
            }
        } else {
            resource = new Resource(resourceId, resourceName);
            model.addResource(resource);
        }

        BpmnXMLUtil.addXMLLocation(resource, xtr);
    }
}
