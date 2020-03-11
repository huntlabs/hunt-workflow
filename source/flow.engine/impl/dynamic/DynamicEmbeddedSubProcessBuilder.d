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


import hunt.collection.Map;

import flow.bpmn.model.FlowElement;

class DynamicEmbeddedSubProcessBuilder {

    protected string id;
    protected string processDefinitionId;
    protected string dynamicSubProcessId;
    protected int counter = 1;

    public DynamicEmbeddedSubProcessBuilder() {

    }

    public DynamicEmbeddedSubProcessBuilder(string id) {
        this.id = id;
    }

    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }

    public DynamicEmbeddedSubProcessBuilder id(string id) {
        this.id = id;
        return this;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public DynamicEmbeddedSubProcessBuilder processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    public string getDynamicSubProcessId() {
        return dynamicSubProcessId;
    }

    public void setDynamicSubProcessId(string dynamicSubProcessId) {
        this.dynamicSubProcessId = dynamicSubProcessId;
    }

    public string nextSubProcessId(Map<string, FlowElement> flowElementMap) {
        return nextId("dynamicSubProcess", flowElementMap);
    }

    public string nextTaskId(Map<string, FlowElement> flowElementMap) {
        return nextId("dynamicTask", flowElementMap);
    }

    public string nextFlowId(Map<string, FlowElement> flowElementMap) {
        return nextId("dynamicFlow", flowElementMap);
    }

    public string nextForkGatewayId(Map<string, FlowElement> flowElementMap) {
        return nextId("dynamicForkGateway", flowElementMap);
    }

    public string nextJoinGatewayId(Map<string, FlowElement> flowElementMap) {
        return nextId("dynamicJoinGateway", flowElementMap);
    }

    public string nextStartEventId(Map<string, FlowElement> flowElementMap) {
        return nextId("startEvent", flowElementMap);
    }

    public string nextEndEventId(Map<string, FlowElement> flowElementMap) {
        return nextId("endEvent", flowElementMap);
    }

    protected string nextId(string prefix, Map<string, FlowElement> flowElementMap) {
        string nextId = null;
        bool nextIdNotFound = true;
        while (nextIdNotFound) {
            if (!flowElementMap.containsKey(prefix + counter)) {
                nextId = prefix + counter;
                nextIdNotFound = false;
            }

            counter++;
        }

        return nextId;
    }
}
