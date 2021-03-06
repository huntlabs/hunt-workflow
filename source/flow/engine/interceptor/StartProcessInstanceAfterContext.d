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
module flow.engine.interceptor.StartProcessInstanceAfterContext;

import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;
import flow.engine.interceptor.AbstractStartProcessInstanceAfterContext;

class StartProcessInstanceAfterContext : AbstractStartProcessInstanceAfterContext {

    protected Map!(string, Object) transientVariables;

    this() {

    }

    this(ExecutionEntity processInstance, ExecutionEntity childExecution, Map!(string, Object) variables,
                    Map!(string, Object) transientVariables, FlowElement initialFlowElement, Process process, ProcessDefinition processDefinition) {

        super(processInstance, childExecution, variables, initialFlowElement, process, processDefinition);

        this.transientVariables = transientVariables;
    }

    public Map!(string, Object) getTransientVariables() {
        return transientVariables;
    }

    public void setTransientVariables(Map!(string, Object) transientVariables) {
        this.transientVariables = transientVariables;
    }
}
