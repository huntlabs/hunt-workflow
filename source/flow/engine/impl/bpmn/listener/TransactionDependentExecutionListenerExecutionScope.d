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
module flow.engine.impl.bpmn.listener.TransactionDependentExecutionListenerExecutionScope;

import hunt.collection.Map;

import flow.bpmn.model.FlowElement;

/**
 * @author Yvo Swillens
 */
class TransactionDependentExecutionListenerExecutionScope {

    protected  string processInstanceId;
    protected  string executionId;
    protected  FlowElement flowElement;
    protected  Map!(string, Object) executionVariables;
    protected  Map!(string, Object) customPropertiesMap;

    this(string processInstanceId, string executionId,
            FlowElement flowElement, Map!(string, Object) executionVariables,
            Map!(string, Object) customPropertiesMap) {
        this.processInstanceId = processInstanceId;
        this.executionId = executionId;
        this.flowElement = flowElement;
        this.executionVariables = executionVariables;
        this.customPropertiesMap = customPropertiesMap;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getExecutionId() {
        return executionId;
    }

    public FlowElement getFlowElement() {
        return flowElement;
    }

    public Map!(string, Object) getExecutionVariables() {
        return executionVariables;
    }

    public Map!(string, Object) getCustomPropertiesMap() {
        return customPropertiesMap;
    }
}
