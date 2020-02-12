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


import java.util.HashMap;
import java.util.Map;

import flow.engine.impl.RuntimeServiceImpl;
import flow.engine.runtime.ProcessInstance;
import flow.engine.runtime.ProcessInstanceBuilder;

/**
 * @author Bassam Al-Sarori
 * @author Joram Barrez
 */
class ProcessInstanceBuilderImpl implements ProcessInstanceBuilder {

    protected RuntimeServiceImpl runtimeService;

    protected string processDefinitionId;
    protected string processDefinitionKey;
    protected string messageName;
    protected string processInstanceName;
    protected string businessKey;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string stageInstanceId;
    protected string tenantId;
    protected string overrideDefinitionTenantId;
    protected string predefinedProcessInstanceId;
    protected Map<string, Object> variables;
    protected Map<string, Object> transientVariables;
    protected Map<string, Object> startFormVariables;
    protected string outcome;
    protected boolean fallbackToDefaultTenant;

    public ProcessInstanceBuilderImpl(RuntimeServiceImpl runtimeService) {
        this.runtimeService = runtimeService;
    }

    @Override
    public ProcessInstanceBuilder processDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public ProcessInstanceBuilder processDefinitionKey(string processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
        return this;
    }

    @Override
    public ProcessInstanceBuilder messageName(string messageName) {
        this.messageName = messageName;
        return this;
    }

    @Override
    public ProcessInstanceBuilder name(string processInstanceName) {
        this.processInstanceName = processInstanceName;
        return this;
    }

    @Override
    public ProcessInstanceBuilder businessKey(string businessKey) {
        this.businessKey = businessKey;
        return this;
    }
    
    @Override
    public ProcessInstanceBuilder callbackId(string callbackId) {
        this.callbackId = callbackId;
        return this;
    }
    
    @Override
    public ProcessInstanceBuilder callbackType(string callbackType) {
        this.callbackType = callbackType;
        return this;
    }

    @Override
    public ProcessInstanceBuilder referenceId(string referenceId) {
        this.referenceId = referenceId;
        return this;
    }

    @Override
    public ProcessInstanceBuilder referenceType(string referenceType) {
        this.referenceType = referenceType;
        return this;
    }

    @Override
    public ProcessInstanceBuilder stageInstanceId(string stageInstanceId) {
        this.stageInstanceId = stageInstanceId;
        return this;
    }

    @Override
    public ProcessInstanceBuilder tenantId(string tenantId) {
        this.tenantId = tenantId;
        return this;
    }
    
    @Override
    public ProcessInstanceBuilder overrideProcessDefinitionTenantId(string tenantId) {
        this.overrideDefinitionTenantId = tenantId;
        return this;
    }

    @Override
    public ProcessInstanceBuilder predefineProcessInstanceId(string processInstanceId) {
        this.predefinedProcessInstanceId = processInstanceId;
        return this;
    }

    @Override
    public ProcessInstanceBuilder variables(Map<string, Object> variables) {
        if (this.variables == null) {
            this.variables = new HashMap<>();
        }
        if (variables != null) {
            this.variables.putAll(variables);
        }
        return this;
    }

    @Override
    public ProcessInstanceBuilder variable(string variableName, Object value) {
        if (this.variables == null) {
            this.variables = new HashMap<>();
        }
        this.variables.put(variableName, value);
        return this;
    }

    @Override
    public ProcessInstanceBuilder transientVariables(Map<string, Object> transientVariables) {
        if (this.transientVariables == null) {
            this.transientVariables = new HashMap<>();
        }
        if (transientVariables != null) {
            this.transientVariables.putAll(transientVariables);
        }
        return this;
    }

    @Override
    public ProcessInstanceBuilder transientVariable(string variableName, Object value) {
        if (this.transientVariables == null) {
            this.transientVariables = new HashMap<>();
        }
        this.transientVariables.put(variableName, value);
        return this;
    }

    @Override
    public ProcessInstanceBuilder startFormVariables(Map<string, Object> startFormVariables) {
        if (this.startFormVariables == null) {
            this.startFormVariables = new HashMap<>();
        }
        if (startFormVariables != null) {
            this.startFormVariables.putAll(startFormVariables);
        }
        return this;
    }

    @Override
    public ProcessInstanceBuilder startFormVariable(string variableName, Object value) {
        if (this.startFormVariables == null) {
            this.startFormVariables = new HashMap<>();
        }
        this.startFormVariables.put(variableName, value);
        return this;
    }

    @Override
    public ProcessInstanceBuilder outcome(string outcome) {
        this.outcome = outcome;
        return this;
    }

    @Override
    public ProcessInstanceBuilder fallbackToDefaultTenant() {
        this.fallbackToDefaultTenant = true;
        return this;
    }

    @Override
    public ProcessInstance start() {
        return runtimeService.startProcessInstance(this);
    }

    @Override
    public ProcessInstance startAsync() {
        return runtimeService.startProcessInstanceAsync(this);
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public string getMessageName() {
        return messageName;
    }

    public string getProcessInstanceName() {
        return processInstanceName;
    }

    public string getBusinessKey() {
        return businessKey;
    }
    
    public string getCallbackId() {
        return callbackId;
    }

    public string getCallbackType() {
        return callbackType;
    }

    public string getReferenceId() {
        return referenceId;
    }

    public string getReferenceType() {
        return referenceType;
    }

    public string getStageInstanceId() {
        return stageInstanceId;
    }

    public string getTenantId() {
        return tenantId;
    }

    public string getOverrideDefinitionTenantId() {
        return overrideDefinitionTenantId;
    }

    public string getPredefinedProcessInstanceId() {
        return predefinedProcessInstanceId;
    }

    public Map<string, Object> getVariables() {
        return variables;
    }

    public Map<string, Object> getTransientVariables() {
        return transientVariables;
    }

    public Map<string, Object> getStartFormVariables() {
        return startFormVariables;
    }
    public string getOutcome() {
        return outcome;
    }

    public boolean isFallbackToDefaultTenant() {
        return fallbackToDefaultTenant;
    }

}
