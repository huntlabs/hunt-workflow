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


import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.repository.EngineResource;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;

/**
 * Static methods for working with BPMN and image resource names.
 */
class ResourceNameUtil {

    public static final string[] BPMN_RESOURCE_SUFFIXES = new string[] { "bpmn20.xml", "bpmn" };
    public static final string[] DIAGRAM_SUFFIXES = new string[] { "png", "jpg", "gif", "svg" };

    public static string stripBpmnFileSuffix(string bpmnFileResource) {
        for (string suffix : BPMN_RESOURCE_SUFFIXES) {
            if (bpmnFileResource.endsWith(suffix)) {
                return bpmnFileResource.substring(0, bpmnFileResource.length() - suffix.length());
            }
        }
        return bpmnFileResource;
    }

    public static string getProcessDiagramResourceName(string bpmnFileResource, string processKey, string diagramSuffix) {
        string bpmnFileResourceBase = ResourceNameUtil.stripBpmnFileSuffix(bpmnFileResource);
        return bpmnFileResourceBase + processKey + "." + diagramSuffix;
    }

    /**
     * Finds the name of a resource for the diagram for a process definition. Assumes that the process definition's key and (BPMN) resource name are already set.
     *
     * <p>
     * It will first look for an image resource which matches the process specifically, before resorting to an image resource which matches the BPMN 2.0 xml file resource.
     *
     * <p>
     * Example: if the deployment contains a BPMN 2.0 xml resource called 'abc.bpmn20.xml' containing only one process with key 'myProcess', then this method will look for an image resources
     * called'abc.myProcess.png' (or .jpg, or .gif, etc.) or 'abc.png' if the previous one wasn't found.
     *
     * <p>
     * Example 2: if the deployment contains a BPMN 2.0 xml resource called 'abc.bpmn20.xml' containing three processes (with keys a, b and c), then this method will first look for an image resource
     * called 'abc.a.png' before looking for 'abc.png' (likewise for b and c). Note that if abc.a.png, abc.b.png and abc.c.png don't exist, all processes will have the same image: abc.png.
     *
     * @return name of an existing resource, or null if no matching image resource is found in the resources.
     */
    public static string getProcessDiagramResourceNameFromDeployment(
            ProcessDefinitionEntity processDefinition, Map<string, EngineResource> resources) {

        if (StringUtils.isEmpty(processDefinition.getResourceName())) {
            throw new IllegalStateException("Provided process definition must have its resource name set.");
        }

        string bpmnResourceBase = stripBpmnFileSuffix(processDefinition.getResourceName());
        string key = processDefinition.getKey();

        for (string diagramSuffix : DIAGRAM_SUFFIXES) {
            string possibleName = bpmnResourceBase + key + "." + diagramSuffix;
            if (resources.containsKey(possibleName)) {
                return possibleName;
            }

            possibleName = bpmnResourceBase + diagramSuffix;
            if (resources.containsKey(possibleName)) {
                return possibleName;
            }
        }

        return null;
    }

}
