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
module flow.engine.interceptor.StartSubProcessInstanceAfterContext;

import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.IOParameter;
import flow.bpmn.model.Process;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;
import flow.engine.interceptor.AbstractStartProcessInstanceAfterContext;

class StartSubProcessInstanceAfterContext : AbstractStartProcessInstanceAfterContext {

    protected ExecutionEntity callActivityExecution;
    protected List!IOParameter inParameters;

    this() {

    }

    this(ExecutionEntity processInstance, ExecutionEntity childExecution, Map!(string, Object) variables,
                    ExecutionEntity callActivityExecution, List!IOParameter inParameters, FlowElement initialFlowElement,
                    Process process, ProcessDefinition processDefinition) {

        super(processInstance, childExecution, variables, initialFlowElement, process, processDefinition);

        this.callActivityExecution = callActivityExecution;
        this.inParameters = inParameters;
    }

    public ExecutionEntity getCallActivityExecution() {
        return callActivityExecution;
    }

    public void setCallActivityExecution(ExecutionEntity callActivityExecution) {
        this.callActivityExecution = callActivityExecution;
    }

    public List!IOParameter getInParameters() {
        return inParameters;
    }

    public void setInParameters(List!IOParameter inParameters) {
        this.inParameters = inParameters;
    }
}
