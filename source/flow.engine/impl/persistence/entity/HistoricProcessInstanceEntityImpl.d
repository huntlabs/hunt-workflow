/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.context.Context;
import flow.engine.ProcessEngineConfiguration;
import flow.variable.service.impl.persistence.entity.HistoricVariableInitializingList;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

/**
 * @author Tom Baeyens
 * @author Christian Stettler
 * @author Joram Barrez
 */
class HistoricProcessInstanceEntityImpl extends HistoricScopeInstanceEntityImpl implements HistoricProcessInstanceEntity {

    private static final long serialVersionUID = 1L;

    protected string endActivityId;
    protected string businessKey;
    protected string startUserId;
    protected string startActivityId;
    protected string superProcessInstanceId;
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
    protected string name;
    protected string localizedName;
    protected string description;
    protected string localizedDescription;
    protected string processDefinitionKey;
    protected string processDefinitionName;
    protected Integer processDefinitionVersion;
    protected string deploymentId;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected List<HistoricVariableInstanceEntity> queryVariables;

    public HistoricProcessInstanceEntityImpl() {

    }

    public HistoricProcessInstanceEntityImpl(ExecutionEntity processInstance) {
        this.id = processInstance.getId();
        this.processInstanceId = processInstance.getId();
        this.businessKey = processInstance.getBusinessKey();
        this.name = processInstance.getName();
        this.processDefinitionId = processInstance.getProcessDefinitionId();
        this.processDefinitionKey = processInstance.getProcessDefinitionKey();
        this.processDefinitionName = processInstance.getProcessDefinitionName();
        this.processDefinitionVersion = processInstance.getProcessDefinitionVersion();
        this.deploymentId = processInstance.getDeploymentId();
        this.startActivityId = processInstance.getStartActivityId();
        this.startTime = processInstance.getStartTime();
        this.startUserId = processInstance.getStartUserId();
        this.superProcessInstanceId = processInstance.getSuperExecution() !is null ? processInstance.getSuperExecution().getProcessInstanceId() : null;
        this.callbackId = processInstance.getCallbackId();
        this.callbackType = processInstance.getCallbackType();
        this.referenceId = processInstance.getReferenceId();
        this.referenceType = processInstance.getReferenceType();

        // Inherit tenant id (if applicable)
        if (processInstance.getTenantId() !is null) {
            this.tenantId = processInstance.getTenantId();
        }
    }

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("startTime", startTime);
        persistentState.put("endTime", endTime);
        persistentState.put("businessKey", businessKey);
        persistentState.put("name", name);
        persistentState.put("durationInMillis", durationInMillis);
        persistentState.put("deleteReason", deleteReason);
        persistentState.put("endActivityId", endActivityId);
        persistentState.put("superProcessInstanceId", superProcessInstanceId);
        persistentState.put("processDefinitionId", processDefinitionId);
        persistentState.put("processDefinitionKey", processDefinitionKey);
        persistentState.put("processDefinitionName", processDefinitionName);
        persistentState.put("processDefinitionVersion", processDefinitionVersion);
        persistentState.put("deploymentId", deploymentId);
        persistentState.put("callbackId", callbackId);
        persistentState.put("callbackType", callbackType);
        persistentState.put("referenceId", referenceId);
        persistentState.put("referenceType", referenceType);
        return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getEndActivityId() {
        return endActivityId;
    }

    @Override
    public void setEndActivityId(string endActivityId) {
        this.endActivityId = endActivityId;
    }

    @Override
    public string getBusinessKey() {
        return businessKey;
    }

    @Override
    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }

    @Override
    public string getStartUserId() {
        return startUserId;
    }

    @Override
    public void setStartUserId(string startUserId) {
        this.startUserId = startUserId;
    }

    @Override
    public string getStartActivityId() {
        return startActivityId;
    }

    @Override
    public void setStartActivityId(string startUserId) {
        this.startActivityId = startUserId;
    }

    @Override
    public string getSuperProcessInstanceId() {
        return superProcessInstanceId;
    }

    @Override
    public void setSuperProcessInstanceId(string superProcessInstanceId) {
        this.superProcessInstanceId = superProcessInstanceId;
    }

    @Override
    public string getTenantId() {
        return tenantId;
    }

    @Override
    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public string getName() {
        if (localizedName !is null && localizedName.length() > 0) {
            return localizedName;
        } else {
            return name;
        }
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    public string getLocalizedName() {
        return localizedName;
    }

    @Override
    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }

    @Override
    public string getDescription() {
        if (localizedDescription !is null && localizedDescription.length() > 0) {
            return localizedDescription;
        } else {
            return description;
        }
    }

    @Override
    public void setDescription(string description) {
        this.description = description;
    }

    public string getLocalizedDescription() {
        return localizedDescription;
    }

    @Override
    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }

    @Override
    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    @Override
    public void setProcessDefinitionKey(string processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
    }

    @Override
    public string getProcessDefinitionName() {
        return processDefinitionName;
    }

    @Override
    public void setProcessDefinitionName(string processDefinitionName) {
        this.processDefinitionName = processDefinitionName;
    }

    @Override
    public Integer getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }

    @Override
    public void setProcessDefinitionVersion(Integer processDefinitionVersion) {
        this.processDefinitionVersion = processDefinitionVersion;
    }

    @Override
    public string getDeploymentId() {
        return deploymentId;
    }

    @Override
    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    @Override
    public string getCallbackId() {
        return callbackId;
    }

    @Override
    public void setCallbackId(string callbackId) {
        this.callbackId = callbackId;
    }

    @Override
    public string getCallbackType() {
        return callbackType;
    }

    @Override
    public void setCallbackType(string callbackType) {
        this.callbackType = callbackType;
    }

    @Override
    public string getReferenceId() {
        return referenceId;
    }

    @Override
    public void setReferenceId(string referenceId) {
        this.referenceId = referenceId;
    }

    @Override
    public string getReferenceType() {
        return referenceType;
    }

    @Override
    public void setReferenceType(string referenceType) {
        this.referenceType = referenceType;
    }

    @Override
    public Map!(string, Object) getProcessVariables() {
        Map!(string, Object) variables = new HashMap<>();
        if (queryVariables !is null) {
            for (HistoricVariableInstanceEntity variableInstance : queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() is null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }

    @Override
    public List<HistoricVariableInstanceEntity> getQueryVariables() {
        if (queryVariables is null && Context.getCommandContext() !is null) {
            queryVariables = new HistoricVariableInitializingList();
        }
        return queryVariables;
    }

    @Override
    public void setQueryVariables(List<HistoricVariableInstanceEntity> queryVariables) {
        this.queryVariables = queryVariables;
    }

    // common methods //////////////////////////////////////////////////////////

    @Override
    public string toString() {
        return "HistoricProcessInstanceEntity[superProcessInstanceId=" + superProcessInstanceId + "]";
    }
}
