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
import flow.engine.repository.ProcessDefinition;

class StartProcessInstanceBeforeContext extends AbstractStartProcessInstanceBeforeContext {

    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected Map!(string, Object) transientVariables;
    protected string tenantId;
    protected string initiatorVariableName;
    protected string overrideDefinitionTenantId;
    protected string predefinedProcessInstanceId;

    public StartProcessInstanceBeforeContext() {

    }

    public StartProcessInstanceBeforeContext(string businessKey, string processInstanceName,
                    string callbackId, string callbackType, string referenceId, string referenceType,
                    Map!(string, Object) variables, Map!(string, Object) transientVariables, string tenantId,
                    string initiatorVariableName, string initialActivityId, FlowElement initialFlowElement, Process process,
                    ProcessDefinition processDefinition, string overrideDefinitionTenantId, string predefinedProcessInstanceId) {

        super(businessKey, processInstanceName, variables, initialActivityId, initialFlowElement, process, processDefinition);

        this.callbackId = callbackId;
        this.callbackType = callbackType;
        this.referenceId = referenceId;
        this.referenceType = referenceType;
        this.transientVariables = transientVariables;
        this.tenantId = tenantId;
        this.initiatorVariableName = initiatorVariableName;
        this.overrideDefinitionTenantId = overrideDefinitionTenantId;
        this.predefinedProcessInstanceId = predefinedProcessInstanceId;
    }

    public string getCallbackId() {
        return callbackId;
    }

    public void setCallbackId(string callbackId) {
        this.callbackId = callbackId;
    }

    public string getCallbackType() {
        return callbackType;
    }

    public void setCallbackType(string callbackType) {
        this.callbackType = callbackType;
    }

    public string getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(string referenceId) {
        this.referenceId = referenceId;
    }

    public string getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(string referenceType) {
        this.referenceType = referenceType;
    }

    public Map!(string, Object) getTransientVariables() {
        return transientVariables;
    }

    public void setTransientVariables(Map!(string, Object) transientVariables) {
        this.transientVariables = transientVariables;
    }

    public string getTenantId() {
        return tenantId;
    }

    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    public string getInitiatorVariableName() {
        return initiatorVariableName;
    }

    public void setInitiatorVariableName(string initiatorVariableName) {
        this.initiatorVariableName = initiatorVariableName;
    }

    public string getOverrideDefinitionTenantId() {
        return overrideDefinitionTenantId;
    }

    public void setOverrideDefinitionTenantId(string overrideDefinitionTenantId) {
        this.overrideDefinitionTenantId = overrideDefinitionTenantId;
    }

    public string getPredefinedProcessInstanceId() {
        return predefinedProcessInstanceId;
    }

    public void setPredefinedProcessInstanceId(string predefinedProcessInstanceId) {
        this.predefinedProcessInstanceId = predefinedProcessInstanceId;
    }
}
