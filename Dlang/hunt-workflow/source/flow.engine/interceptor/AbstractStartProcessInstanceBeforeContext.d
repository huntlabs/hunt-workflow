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

import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.Process;
import flow.engine.repository.ProcessDefinition;

class AbstractStartProcessInstanceBeforeContext {

    protected string businessKey;
    protected string processInstanceName;
    protected Map<string, Object> variables;
    protected string initialActivityId;
    protected FlowElement initialFlowElement;
    protected Process process;
    protected ProcessDefinition processDefinition;
    
    public AbstractStartProcessInstanceBeforeContext() {
        
    }

    public AbstractStartProcessInstanceBeforeContext(string businessKey, string processInstanceName, Map<string, Object> variables,
                    string initialActivityId, FlowElement initialFlowElement, Process process, ProcessDefinition processDefinition) {
        
        this.businessKey = businessKey;
        this.processInstanceName = processInstanceName;
        this.variables = variables;
        this.initialActivityId = initialActivityId;
        this.initialFlowElement = initialFlowElement;
        this.process = process;
        this.processDefinition = processDefinition;
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }

    public string getProcessInstanceName() {
        return processInstanceName;
    }

    public void setProcessInstanceName(string processInstanceName) {
        this.processInstanceName = processInstanceName;
    }

    public Map<string, Object> getVariables() {
        return variables;
    }

    public void setVariables(Map<string, Object> variables) {
        this.variables = variables;
    }

    public string getInitialActivityId() {
        return initialActivityId;
    }

    public void setInitialActivityId(string initialActivityId) {
        this.initialActivityId = initialActivityId;
    }

    public FlowElement getInitialFlowElement() {
        return initialFlowElement;
    }

    public void setInitialFlowElement(FlowElement initialFlowElement) {
        this.initialFlowElement = initialFlowElement;
    }

    public Process getProcess() {
        return process;
    }

    public void setProcess(Process process) {
        this.process = process;
    }

    public ProcessDefinition getProcessDefinition() {
        return processDefinition;
    }

    public void setProcessDefinition(ProcessDefinition processDefinition) {
        this.processDefinition = processDefinition;
    }
}
