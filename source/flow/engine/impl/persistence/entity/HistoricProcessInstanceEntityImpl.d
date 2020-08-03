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
module flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.context.Context;
import flow.engine.ProcessEngineConfiguration;
import flow.variable.service.impl.persistence.entity.HistoricVariableInitializingList;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import hunt.entity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Christian Stettler
 * @author Joram Barrez
 */
//class HistoricProcessInstanceEntityImpl : HistoricScopeInstanceEntityImpl implements HistoricProcessInstanceEntity {
@Table("ACT_HI_PROCINST")
class HistoricProcessInstanceEntityImpl : AbstractBpmnEngineEntity, Model , HistoricProcessInstanceEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("REV_")
    int rev;

    @Column("END_ACT_ID_")
    string endActivityId;

    @Column("BUSINESS_KEY_")
    string businessKey;

    @Column("START_USER_ID_")
    string startUserId;

    @Column("START_ACT_ID_")
    string startActivityId;

    @Column("SUPER_PROCESS_INSTANCE_ID_")
    string superProcessInstanceId;

    @Column("TENANT_ID_")
    string tenantId ;//= ProcessEngineConfiguration.NO_TENANT_ID;

    @Column("NAME_")
    string name;

    @Column("CALLBACK_ID_")
    string callbackId;

    @Column("CALLBACK_TYPE_")
    string callbackType;

    @Column("REFERENCE_ID_")
    string referenceId;

    @Column("REFERENCE_TYPE_")
    string referenceType;

    @Column("PROC_INST_ID_")
    string processInstanceId;

    @Column("PROC_DEF_ID_")
    string processDefinitionId;

    @Column("START_TIME_")
    long startTime;

    @Column("END_TIME_")
    long endTime;

    @Column("DURATION_")
    long durationInMillis;

    @Column("DELETE_REASON_")
    string deleteReason;

    private List!HistoricVariableInstanceEntity queryVariables;
    private string localizedName;
    private string description;
    private string localizedDescription;
    private string processDefinitionKey;
    private string processDefinitionName;
    private int processDefinitionVersion;
    private string deploymentId;

    this() {
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
      rev = 1;
    }

    this(ExecutionEntity processInstance) {
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
        this.startTime = processInstance.getStartTime().toEpochMilli / 1000;
        this.startUserId = processInstance.getStartUserId();
        this.superProcessInstanceId = processInstance.getSuperExecution() !is null ? processInstance.getSuperExecution().getProcessInstanceId() : "";
        this.callbackId = processInstance.getCallbackId();
        this.callbackType = processInstance.getCallbackType();
        this.referenceId = processInstance.getReferenceId();
        this.referenceType = processInstance.getReferenceType();

        // Inherit tenant id (if applicable)
        if (processInstance.getTenantId().length != 0) {
            this.tenantId = processInstance.getTenantId();
        }
    }

    string getId()
    {
        return id;
    }

    void setId(string id)
    {
        this.id = id;
    }

    public Object getPersistentState() {
      implementationMissing(false);
        return null;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("startTime", startTime);
        //persistentState.put("endTime", endTime);
        //persistentState.put("businessKey", businessKey);
        //persistentState.put("name", name);
        //persistentState.put("durationInMillis", durationInMillis);
        //persistentState.put("deleteReason", deleteReason);
        //persistentState.put("endActivityId", endActivityId);
        //persistentState.put("superProcessInstanceId", superProcessInstanceId);
        //persistentState.put("processDefinitionId", processDefinitionId);
        //persistentState.put("processDefinitionKey", processDefinitionKey);
        //persistentState.put("processDefinitionName", processDefinitionName);
        //persistentState.put("processDefinitionVersion", processDefinitionVersion);
        //persistentState.put("deploymentId", deploymentId);
        //persistentState.put("callbackId", callbackId);
        //persistentState.put("callbackType", callbackType);
        //persistentState.put("referenceId", referenceId);
        //persistentState.put("referenceType", referenceType);
        //return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getEndActivityId() {
        return endActivityId;
    }


    public void setEndActivityId(string endActivityId) {
        this.endActivityId = endActivityId;
    }


    public string getBusinessKey() {
        return businessKey;
    }


    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }


    public string getStartUserId() {
        return startUserId;
    }


    public void setStartUserId(string startUserId) {
        this.startUserId = startUserId;
    }


    public string getStartActivityId() {
        return startActivityId;
    }


    public void setStartActivityId(string startUserId) {
        this.startActivityId = startUserId;
    }


    public string getSuperProcessInstanceId() {
        return superProcessInstanceId;
    }


    public void setSuperProcessInstanceId(string superProcessInstanceId) {
        this.superProcessInstanceId = superProcessInstanceId;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public string getName() {
        if (localizedName !is null && localizedName.length > 0) {
            return localizedName;
        } else {
            return name;
        }
    }


    public void setName(string name) {
        this.name = name;
    }

    public string getLocalizedName() {
        return localizedName;
    }


    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }


    public string getDescription() {
        if (localizedDescription !is null && localizedDescription.length > 0) {
            return localizedDescription;
        } else {
            return description;
        }
    }


    public void setDescription(string description) {
        this.description = description;
    }

    public string getLocalizedDescription() {
        return localizedDescription;
    }


    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }


    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }


    public void setProcessDefinitionKey(string processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
    }


    public string getProcessDefinitionName() {
        return processDefinitionName;
    }


    public void setProcessDefinitionName(string processDefinitionName) {
        this.processDefinitionName = processDefinitionName;
    }


    public int getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }


    public void setProcessDefinitionVersion(int processDefinitionVersion) {
        this.processDefinitionVersion = processDefinitionVersion;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
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


    public Map!(string, Object) getProcessVariables() {
        Map!(string, Object) variables = new HashMap!(string, Object)();
        if (queryVariables !is null) {
            foreach (HistoricVariableInstanceEntity variableInstance ; queryVariables) {
                if (variableInstance.getId().length != 0 && variableInstance.getTaskId().length == 0) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }


    public List!HistoricVariableInstanceEntity getQueryVariables() {
        if (queryVariables is null && Context.getCommandContext() !is null) {
            queryVariables = new HistoricVariableInitializingList();
        }
        return queryVariables;
    }


    public void setQueryVariables(List!HistoricVariableInstanceEntity queryVariables) {
        this.queryVariables = queryVariables;
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        return "HistoricProcessInstanceEntity[superProcessInstanceId=" ~ superProcessInstanceId ~ "]";
    }

    void markEnded(string deleteReason, LocalDateTime endTime)
    {
        this.deleteReason = deleteReason;
        this.endTime = endTime.toEpochMilli / 1000;
    }

    string getProcessInstanceId()
    {
        return processInstanceId;
    }

     string getProcessDefinitionId()
     {
         return processDefinitionId;
     }

     LocalDateTime getStartTime()
     {
        return LocalDateTime.ofEpochMilli(startTime*1000);
     }

     LocalDateTime getEndTime()
     {
        return LocalDateTime.ofEpochMilli(endTime*1000);
     }

     long getDurationInMillis()
     {
        return durationInMillis;
     }

      void setProcessInstanceId(string processInstanceId)
      {
          this.processInstanceId = processInstanceId;
      }

      void setProcessDefinitionId(string processDefinitionId)
      {
          this.processDefinitionId = processDefinitionId;
      }

      void setStartTime(LocalDateTime startTime)
      {
          this.startTime = startTime.toEpochMilli / 1000;
      }

       void setEndTime(LocalDateTime endTime)
       {
          this.endTime = endTime.toEpochMilli / 1000;
       }

       void setDurationInMillis(long durationInMillis)
       {
          this.durationInMillis = durationInMillis;
       }

       string getDeleteReason()
       {
          return deleteReason;
       }

       void setDeleteReason(string deleteReason)
       {
          this.deleteReason = deleteReason;
       }

      override
      void setRevision(int revision)
      {
        super.setRevision(revision);
      }

      override
      int getRevision()
      {
        return super.getRevision;
      }


      override
      int getRevisionNext()
      {
        return super.getRevisionNext;
      }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.id) - hashOf((cast(HistoricProcessInstanceEntityImpl)o).getId));
    }
}
