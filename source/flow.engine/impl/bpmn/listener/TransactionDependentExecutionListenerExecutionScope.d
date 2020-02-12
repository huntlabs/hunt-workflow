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

/**
 * @author Yvo Swillens
 */
class TransactionDependentExecutionListenerExecutionScope {

    protected final string processInstanceId;
    protected final string executionId;
    protected final FlowElement flowElement;
    protected final Map<string, Object> executionVariables;
    protected final Map<string, Object> customPropertiesMap;

    public TransactionDependentExecutionListenerExecutionScope(string processInstanceId, string executionId,
            FlowElement flowElement, Map<string, Object> executionVariables,
            Map<string, Object> customPropertiesMap) {
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

    public Map<string, Object> getExecutionVariables() {
        return executionVariables;
    }

    public Map<string, Object> getCustomPropertiesMap() {
        return customPropertiesMap;
    }
}
