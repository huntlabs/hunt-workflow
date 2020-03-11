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
import flow.bpmn.model.Process;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;

class AbstractStartProcessInstanceAfterContext {

    protected ExecutionEntity processInstance;
    protected ExecutionEntity childExecution;
    protected Map!(string, Object) variables;
    protected FlowElement initialFlowElement;
    protected Process process;
    protected ProcessDefinition processDefinition;

    public AbstractStartProcessInstanceAfterContext() {

    }

    public AbstractStartProcessInstanceAfterContext(ExecutionEntity processInstance, ExecutionEntity childExecution, Map!(string, Object) variables,
                    FlowElement initialFlowElement, Process process, ProcessDefinition processDefinition) {

        this.processInstance = processInstance;
        this.childExecution = childExecution;
        this.variables = variables;
        this.initialFlowElement = initialFlowElement;
        this.process = process;
        this.processDefinition = processDefinition;
    }

    public ExecutionEntity getProcessInstance() {
        return processInstance;
    }

    public void setProcessInstance(ExecutionEntity processInstance) {
        this.processInstance = processInstance;
    }

    public ExecutionEntity getChildExecution() {
        return childExecution;
    }

    public void setChildExecution(ExecutionEntity childExecution) {
        this.childExecution = childExecution;
    }

    public Map!(string, Object) getVariables() {
        return variables;
    }

    public void setVariables(Map!(string, Object) variables) {
        this.variables = variables;
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
