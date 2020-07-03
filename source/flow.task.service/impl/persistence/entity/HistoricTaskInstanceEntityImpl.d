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

module flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntityImpl;

import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.context.Context;
import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.util.CommandContextUtil;
import flow.variable.service.impl.persistence.entity.HistoricVariableInitializingList;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.task.service.impl.persistence.entity.AbstractTaskServiceEntity;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.entity;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
alias Date = LocalDateTime;
@Table("ACT_HI_TASKINST")
class HistoricTaskInstanceEntityImpl : AbstractTaskServiceEntity , Model, HistoricTaskInstanceEntity {
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("EXECUTION_ID_")
    string executionId;

    @Column("PROC_INST_ID_")
    string processInstanceId;

    @Column("PROC_DEF_ID_")
    string processDefinitionId;

    @Column("TASK_DEF_ID_")
    string taskDefinitionId;

    @Column("SCOPE_ID_")
    string scopeId;

    @Column("SUB_SCOPE_ID_")
    string subScopeId;

    @Column("SCOPE_TYPE_")
    string scopeType;

    @Column("SCOPE_DEFINITION_ID_")
    string scopeDefinitionId;

    @Column("PROPAGATED_STAGE_INST_ID_")
    string propagatedStageInstanceId;

    @Column("START_TIME_")
    long createTime;

    @Column("END_TIME_")
    long endTime;

    @Column("DURATION_")
    long durationInMillis;

    @Column("DELETE_REASON_")
    string deleteReason;

    @Column("NAME_")
    string name;

    @Column("PARENT_TASK_ID_")
    string parentTaskId;

    @Column("DESCRIPTION_")
    string description;

    @Column("OWNER_")
    string owner;

    @Column("ASSIGNEE_")
    string assignee;

    @Column("TASK_DEF_KEY_")
    string taskDefinitionKey;

    @Column("FORM_KEY_")
    string formKey;

    @Column("PRIORITY_")
    int priority;

    @Column("DUE_DATE_")
    long dueDate;

    @Column("CLAIM_TIME_")
    long claimTime;

    @Column("CATEGORY_")
    string category;

    @Column("TENANT_ID_")
    string tenantId  ;//= TaskServiceConfiguration.NO_TENANT_ID;

    @Column("LAST_UPDATED_TIME_")
    long lastUpdateTime;
    private List!HistoricVariableInstanceEntity queryVariables;
    private List!HistoricIdentityLinkEntity queryIdentityLinks;
    private List!HistoricIdentityLinkEntity identityLinks ;//= new ArrayList<>();
    private bool isIdentityLinksInitialized;
    private string localizedName;
    private string localizedDescription;
    this() {
        endTime  = 0;
        createTime = 0;
        tenantId = TaskServiceConfiguration.NO_TENANT_ID;
        identityLinks = new ArrayList!HistoricIdentityLinkEntity;
    }

    this(TaskEntity task) {
        tenantId = TaskServiceConfiguration.NO_TENANT_ID;
        identityLinks = new ArrayList!HistoricIdentityLinkEntity;
         endTime  = 0;
        createTime = 0;
        this.id = task.getId();
        this.taskDefinitionId = task.getTaskDefinitionId();
        this.processDefinitionId = task.getProcessDefinitionId();
        this.processInstanceId = task.getProcessInstanceId();
        this.executionId = task.getExecutionId();
        this.scopeId = task.getScopeId();
        this.subScopeId = task.getSubScopeId();
        this.scopeType = task.getScopeType();
        this.scopeDefinitionId = task.getScopeDefinitionId();
        this.propagatedStageInstanceId = task.getPropagatedStageInstanceId();
        this.name = task.getName();
        this.parentTaskId = task.getParentTaskId();
        this.description = task.getDescription();
        this.owner = task.getOwner();
        this.assignee = task.getAssignee();
        this.createTime = task.getCreateTime().toEpochMilli;
        this.taskDefinitionKey = task.getTaskDefinitionKey();
        this.formKey = task.getFormKey();

        this.setPriority(task.getPriority());
        this.setDueDate(task.getDueDate());
        this.setCategory(task.getCategory());

        // Inherit tenant id (if applicable)
        if (task.getTenantId() !is null) {
            tenantId = task.getTenantId();
        }
    }

    // persistence //////////////////////////////////////////////////////////////

    public Object getPersistentState() {
        return this;
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("name", name);
        //persistentState.put("owner", owner);
        //persistentState.put("assignee", assignee);
        //persistentState.put("endTime", endTime);
        //persistentState.put("durationInMillis", durationInMillis);
        //persistentState.put("description", description);
        //persistentState.put("deleteReason", deleteReason);
        //persistentState.put("taskDefinitionKey", taskDefinitionKey);
        //persistentState.put("formKey", formKey);
        //persistentState.put("priority", priority);
        //persistentState.put("category", category);
        //persistentState.put("executionId", executionId);
        //persistentState.put("processDefinitionId", processDefinitionId);
        //persistentState.put("taskDefinitionId", taskDefinitionId);
        //persistentState.put("scopeId", scopeId);
        //persistentState.put("subScopeId", subScopeId);
        //persistentState.put("scopeType", scopeType);
        //persistentState.put("scopeDefinitionId", scopeDefinitionId);
        //persistentState.put("propagatedStageInstanceId", propagatedStageInstanceId);
        //persistentState.put("parentTaskId", parentTaskId);
        //persistentState.put("dueDate", dueDate);
        //persistentState.put("claimTime", claimTime);
        //persistentState.put("lastUpdateTime", lastUpdateTime);
        //return persistentState;
    }

      public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public void markEnded(string deleteReason, Date endTime) {
      if (this.endTime  == 0) {
        this.deleteReason = deleteReason;
        if (endTime !is null) {
          this.endTime = endTime.toEpochMilli;
        } else {
          this.endTime = CommandContextUtil.getTaskServiceConfiguration().getClock().getCurrentTime().toEpochMilli;
        }
        if (endTime !is null && createTime != 0) {
          this.durationInMillis = endTime.toEpochMilli() - createTime;
        }
      }
        //if (this.endTime is null) {
        //    this.deleteReason = deleteReason;
        //    if (endTime !is null) {
        //        this.endTime = endTime;
        //    } else {
        //        this.endTime = CommandContextUtil.getTaskServiceConfiguration().getClock().getCurrentTime();
        //    }
        //    if (endTime !is null && createTime !is null) {
        //        this.durationInMillis = endTime.getTime() - createTime.getTime();
        //    }
        //}
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getExecutionId() {
        return executionId;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }


    public string getScopeId() {
        return scopeId;
    }


    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }


    public string getSubScopeId() {
        return subScopeId;
    }


    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }


    public string getScopeType() {
        return scopeType;
    }


    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }


    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }


    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }


    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }


    public Date getStartTime() {
        return getCreateTime(); // For backwards compatible reason implemented with createTime and startTime
    }


    public Date getEndTime() {
        return Date.ofEpochMilli(endTime);
    }


    public long getDurationInMillis() {
        return durationInMillis;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public void setTaskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime.toEpochMilli;
    }


    public void setEndTime(Date endTime) {
        this.endTime = endTime.toEpochMilli;
    }


    public void setDurationInMillis(long durationInMillis) {
        this.durationInMillis = durationInMillis;
    }


    public string getDeleteReason() {
        return deleteReason;
    }


    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
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


    public void setLocalizedName(string name) {
        this.localizedName = name;
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


    public void setLocalizedDescription(string description) {
        this.localizedDescription = description;
    }


    public string getAssignee() {
        return assignee;
    }


    public void setAssignee(string assignee) {
        this.assignee = assignee;
    }


    public string getTaskDefinitionKey() {
        return taskDefinitionKey;
    }


    public void setTaskDefinitionKey(string taskDefinitionKey) {
        this.taskDefinitionKey = taskDefinitionKey;
    }


    public Date getCreateTime() {
        return Date.ofEpochMilli(createTime);
    }


    public string getFormKey() {
        return formKey;
    }


    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }


    public int getPriority() {
        return priority;
    }


    public void setPriority(int priority) {
        this.priority = priority;
    }


    public Date getDueDate() {
        return Date.ofEpochMilli(dueDate);
    }


    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate.toEpochMilli();
    }


    public string getCategory() {
        return category;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public string getOwner() {
        return owner;
    }


    public void setOwner(string owner) {
        this.owner = owner;
    }


    public string getParentTaskId() {
        return parentTaskId;
    }


    public void setParentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
    }


    public Date getClaimTime() {
        return Date.ofEpochMilli(claimTime);
    }


    public void setClaimTime(Date claimTime) {
        this.claimTime = claimTime.toEpochMilli;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public Date getTime() {
        return (getCreateTime());
    }


    public long getWorkTimeInMillis() {
        if (endTime == 0 || claimTime  == 0) {
            return 0;
        }
        return endTime - claimTime;
    }


    public Date getLastUpdateTime() {
        return Date.ofEpochMilli(lastUpdateTime);
    }


    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime.toEpochMilli();
    }


    public Map!(string, Object) getTaskLocalVariables() {
        Map!(string, Object) variables = new HashMap!(string, Object)();
        if (queryVariables !is null) {
            foreach (HistoricVariableInstanceEntity variableInstance ; queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() !is null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }


    public Map!(string, Object) getProcessVariables() {
        Map!(string, Object) variables = new HashMap!(string, Object)();
        if (queryVariables !is null) {
            foreach (HistoricVariableInstanceEntity variableInstance ; queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() is null) {
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


    public List!HistoricIdentityLinkEntity getIdentityLinks() {
        if (!isIdentityLinksInitialized) {
            if (queryIdentityLinks is null) {
                identityLinks = CommandContextUtil.getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksByTaskId(id);
            } else {
                identityLinks = queryIdentityLinks;
            }
            isIdentityLinksInitialized = true;
        }

        return identityLinks;
    }

    public List!HistoricIdentityLinkEntity getQueryIdentityLinks() {
        if(queryIdentityLinks is null) {
            queryIdentityLinks = new LinkedList!HistoricIdentityLinkEntity();
        }
        return queryIdentityLinks;
    }

    public void setQueryIdentityLinks(List!HistoricIdentityLinkEntity identityLinks) {
        queryIdentityLinks = identityLinks;
    }


    override
    public string toString() {
        return "HistoricTaskInstanceEntity[id=" ~ id ~ "]";
    }

}
