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
module flow.engine.impl.runtime.ProcessInstanceBuilderImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.engine.impl.RuntimeServiceImpl;
import flow.engine.runtime.ProcessInstance;
import flow.engine.runtime.ProcessInstanceBuilder;

/**
 * @author Bassam Al-Sarori
 * @author Joram Barrez
 */
class ProcessInstanceBuilderImpl : ProcessInstanceBuilder {

    protected RuntimeServiceImpl runtimeService;

    protected string _processDefinitionId;
    protected string _processDefinitionKey;
    protected string _messageName;
    protected string processInstanceName;
    protected string _businessKey;
    protected string _callbackId;
    protected string _callbackType;
    protected string _referenceId;
    protected string _referenceType;
    protected string _stageInstanceId;
    protected string _tenantId;
    protected string overrideDefinitionTenantId;
    protected string predefinedProcessInstanceId;
    protected Map!(string, Object) _variables;
    protected Map!(string, Object) _transientVariables;
    protected Map!(string, Object) _startFormVariables;
    protected string _outcome;
    protected bool _fallbackToDefaultTenant;

    this(RuntimeServiceImpl runtimeService) {
        this.runtimeService = runtimeService;
    }


    public ProcessInstanceBuilder processDefinitionId(string processDefinitionId) {
        this._processDefinitionId = processDefinitionId;
        return this;
    }


    public ProcessInstanceBuilder processDefinitionKey(string processDefinitionKey) {
        this._processDefinitionKey = processDefinitionKey;
        return this;
    }


    public ProcessInstanceBuilder messageName(string messageName) {
        this._messageName = messageName;
        return this;
    }


    public ProcessInstanceBuilder name(string processInstanceName) {
        this.processInstanceName = processInstanceName;
        return this;
    }


    public ProcessInstanceBuilder businessKey(string businessKey) {
        this._businessKey = businessKey;
        return this;
    }


    public ProcessInstanceBuilder callbackId(string callbackId) {
        this._callbackId = callbackId;
        return this;
    }


    public ProcessInstanceBuilder callbackType(string callbackType) {
        this._callbackType = callbackType;
        return this;
    }


    public ProcessInstanceBuilder referenceId(string referenceId) {
        this._referenceId = referenceId;
        return this;
    }


    public ProcessInstanceBuilder referenceType(string referenceType) {
        this._referenceType = referenceType;
        return this;
    }


    public ProcessInstanceBuilder stageInstanceId(string stageInstanceId) {
        this._stageInstanceId = stageInstanceId;
        return this;
    }


    public ProcessInstanceBuilder tenantId(string tenantId) {
        this._tenantId = tenantId;
        return this;
    }


    public ProcessInstanceBuilder overrideProcessDefinitionTenantId(string tenantId) {
        this.overrideDefinitionTenantId = tenantId;
        return this;
    }


    public ProcessInstanceBuilder predefineProcessInstanceId(string processInstanceId) {
        this.predefinedProcessInstanceId = processInstanceId;
        return this;
    }


    public ProcessInstanceBuilder variables(Map!(string, Object) variables) {
        if (this._variables is null) {
            this._variables = new HashMap!(string, Object)();
        }
        if (variables !is null) {
            this._variables.putAll(variables);
        }
        return this;
    }


    public ProcessInstanceBuilder variable(string variableName, Object value) {
        if (this._variables is null) {
            this._variables = new HashMap!(string, Object)();
        }
        this._variables.put(variableName, value);
        return this;
    }


    public ProcessInstanceBuilder transientVariables(Map!(string, Object) transientVariables) {
        if (this._transientVariables is null) {
            this._transientVariables = new HashMap!(string, Object)();
        }
        if (transientVariables !is null) {
            this._transientVariables.putAll(transientVariables);
        }
        return this;
    }


    public ProcessInstanceBuilder transientVariable(string variableName, Object value) {
        if (this._transientVariables is null) {
            this._transientVariables = new HashMap!(string, Object)();
        }
        this._transientVariables.put(variableName, value);
        return this;
    }


    public ProcessInstanceBuilder startFormVariables(Map!(string, Object) startFormVariables) {
        if (this._startFormVariables is null) {
            this._startFormVariables = new HashMap!(string, Object)();
        }
        if (startFormVariables !is null) {
            this._startFormVariables.putAll(startFormVariables);
        }
        return this;
    }


    public ProcessInstanceBuilder startFormVariable(string variableName, Object value) {
        if (this._startFormVariables is null) {
            this._startFormVariables = new HashMap!(string, Object)();
        }
        this._startFormVariables.put(variableName, value);
        return this;
    }


    public ProcessInstanceBuilder outcome(string outcome) {
        this._outcome = outcome;
        return this;
    }


    public ProcessInstanceBuilder fallbackToDefaultTenant() {
        this._fallbackToDefaultTenant = true;
        return this;
    }


    public ProcessInstance start() {
        return runtimeService.startProcessInstance(this);
    }


    public ProcessInstance startAsync() {
        return runtimeService.startProcessInstanceAsync(this);
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getProcessDefinitionKey() {
        return _processDefinitionKey;
    }

    public string getMessageName() {
        return _messageName;
    }

    public string getProcessInstanceName() {
        return processInstanceName;
    }

    public string getBusinessKey() {
        return _businessKey;
    }

    public string getCallbackId() {
        return _callbackId;
    }

    public string getCallbackType() {
        return _callbackType;
    }

    public string getReferenceId() {
        return _referenceId;
    }

    public string getReferenceType() {
        return _referenceType;
    }

    public string getStageInstanceId() {
        return _stageInstanceId;
    }

    public string getTenantId() {
        return _tenantId;
    }

    public string getOverrideDefinitionTenantId() {
        return overrideDefinitionTenantId;
    }

    public string getPredefinedProcessInstanceId() {
        return predefinedProcessInstanceId;
    }

    public Map!(string, Object) getVariables() {
        return _variables;
    }

    public Map!(string, Object) getTransientVariables() {
        return _transientVariables;
    }

    public Map!(string, Object) getStartFormVariables() {
        return _startFormVariables;
    }
    public string getOutcome() {
        return _outcome;
    }

    public bool isFallbackToDefaultTenant() {
        return _fallbackToDefaultTenant;
    }

}
