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



import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.flowable.common.engine.impl.context.Context;
import org.flowable.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.util.CommandContextUtil;
import org.flowable.variable.service.impl.persistence.entity.HistoricVariableInitializingList;
import org.flowable.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricTaskInstanceEntityImpl extends AbstractTaskServiceEntity implements HistoricTaskInstanceEntity {

    private static final long serialVersionUID = 1L;

    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string taskDefinitionId;
    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;
    protected string propagatedStageInstanceId;
    protected Date createTime;
    protected Date endTime;
    protected Long durationInMillis;
    protected string deleteReason;
    protected string name;
    protected string localizedName;
    protected string parentTaskId;
    protected string description;
    protected string localizedDescription;
    protected string owner;
    protected string assignee;
    protected string taskDefinitionKey;
    protected string formKey;
    protected int priority;
    protected Date dueDate;
    protected Date claimTime;
    protected string category;
    protected string tenantId = TaskServiceConfiguration.NO_TENANT_ID;
    protected Date lastUpdateTime;
    protected List<HistoricVariableInstanceEntity> queryVariables;
    protected List<HistoricIdentityLinkEntity> queryIdentityLinks;
    protected List<HistoricIdentityLinkEntity> identityLinks = new ArrayList<>();
    protected boolean isIdentityLinksInitialized;

    public HistoricTaskInstanceEntityImpl() {

    }

    public HistoricTaskInstanceEntityImpl(TaskEntity task) {
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
        this.createTime = task.getCreateTime();
        this.taskDefinitionKey = task.getTaskDefinitionKey();
        this.formKey = task.getFormKey();

        this.setPriority(task.getPriority());
        this.setDueDate(task.getDueDate());
        this.setCategory(task.getCategory());

        // Inherit tenant id (if applicable)
        if (task.getTenantId() != null) {
            tenantId = task.getTenantId();
        }
    }

    // persistence //////////////////////////////////////////////////////////////

    @Override
    public Object getPersistentState() {
        Map<string, Object> persistentState = new HashMap<>();
        persistentState.put("name", name);
        persistentState.put("owner", owner);
        persistentState.put("assignee", assignee);
        persistentState.put("endTime", endTime);
        persistentState.put("durationInMillis", durationInMillis);
        persistentState.put("description", description);
        persistentState.put("deleteReason", deleteReason);
        persistentState.put("taskDefinitionKey", taskDefinitionKey);
        persistentState.put("formKey", formKey);
        persistentState.put("priority", priority);
        persistentState.put("category", category);
        persistentState.put("executionId", executionId);
        persistentState.put("processDefinitionId", processDefinitionId);
        persistentState.put("taskDefinitionId", taskDefinitionId);
        persistentState.put("scopeId", scopeId);
        persistentState.put("subScopeId", subScopeId);
        persistentState.put("scopeType", scopeType);
        persistentState.put("scopeDefinitionId", scopeDefinitionId);
        persistentState.put("propagatedStageInstanceId", propagatedStageInstanceId);
        persistentState.put("parentTaskId", parentTaskId);
        persistentState.put("dueDate", dueDate);
        persistentState.put("claimTime", claimTime);
        persistentState.put("lastUpdateTime", lastUpdateTime);
        return persistentState;
    }
    
    @Override
    public void markEnded(string deleteReason, Date endTime) {
        if (this.endTime == null) {
            this.deleteReason = deleteReason;
            if (endTime != null) {
                this.endTime = endTime;
            } else {
                this.endTime = CommandContextUtil.getTaskServiceConfiguration().getClock().getCurrentTime();
            }
            if (endTime != null && createTime != null) {
                this.durationInMillis = endTime.getTime() - createTime.getTime();
            }
        }
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getExecutionId() {
        return executionId;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }
    
    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }

    @Override
    public string getScopeId() {
        return scopeId;
    }

    @Override
    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }

    @Override
    public string getSubScopeId() {
        return subScopeId;
    }

    @Override
    public void setSubScopeId(string subScopeId) {
        this.subScopeId = subScopeId;
    }

    @Override
    public string getScopeType() {
        return scopeType;
    }

    @Override
    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }

    @Override
    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    @Override
    public void setScopeDefinitionId(string scopeDefinitionId) {
        this.scopeDefinitionId = scopeDefinitionId;
    }

    @Override
    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }

    @Override
    public Date getStartTime() {
        return getCreateTime(); // For backwards compatible reason implemented with createTime and startTime
    }

    @Override
    public Date getEndTime() {
        return endTime;
    }

    @Override
    public Long getDurationInMillis() {
        return durationInMillis;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public void setTaskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
    }

    @Override
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Override
    public void setDurationInMillis(Long durationInMillis) {
        this.durationInMillis = durationInMillis;
    }

    @Override
    public string getDeleteReason() {
        return deleteReason;
    }

    @Override
    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
    }

    @Override
    public string getName() {
        if (localizedName != null && localizedName.length() > 0) {
            return localizedName;
        } else {
            return name;
        }
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    @Override
    public void setLocalizedName(string name) {
        this.localizedName = name;
    }

    @Override
    public string getDescription() {
        if (localizedDescription != null && localizedDescription.length() > 0) {
            return localizedDescription;
        } else {
            return description;
        }
    }

    @Override
    public void setDescription(string description) {
        this.description = description;
    }

    @Override
    public void setLocalizedDescription(string description) {
        this.localizedDescription = description;
    }

    @Override
    public string getAssignee() {
        return assignee;
    }

    @Override
    public void setAssignee(string assignee) {
        this.assignee = assignee;
    }

    @Override
    public string getTaskDefinitionKey() {
        return taskDefinitionKey;
    }

    @Override
    public void setTaskDefinitionKey(string taskDefinitionKey) {
        this.taskDefinitionKey = taskDefinitionKey;
    }

    @Override
    public Date getCreateTime() {
        return createTime;
    }

    @Override
    public string getFormKey() {
        return formKey;
    }

    @Override
    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    @Override
    public int getPriority() {
        return priority;
    }

    @Override
    public void setPriority(int priority) {
        this.priority = priority;
    }

    @Override
    public Date getDueDate() {
        return dueDate;
    }

    @Override
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    @Override
    public string getCategory() {
        return category;
    }

    @Override
    public void setCategory(string category) {
        this.category = category;
    }

    @Override
    public string getOwner() {
        return owner;
    }

    @Override
    public void setOwner(string owner) {
        this.owner = owner;
    }

    @Override
    public string getParentTaskId() {
        return parentTaskId;
    }

    @Override
    public void setParentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
    }

    @Override
    public Date getClaimTime() {
        return claimTime;
    }

    @Override
    public void setClaimTime(Date claimTime) {
        this.claimTime = claimTime;
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
    public Date getTime() {
        return getCreateTime();
    }

    @Override
    public Long getWorkTimeInMillis() {
        if (endTime == null || claimTime == null) {
            return null;
        }
        return endTime.getTime() - claimTime.getTime();
    }

    @Override
    public Date getLastUpdateTime() {
        return lastUpdateTime;
    }

    @Override
    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }

    @Override
    public Map<string, Object> getTaskLocalVariables() {
        Map<string, Object> variables = new HashMap<>();
        if (queryVariables != null) {
            for (HistoricVariableInstanceEntity variableInstance : queryVariables) {
                if (variableInstance.getId() != null && variableInstance.getTaskId() != null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }

    @Override
    public Map<string, Object> getProcessVariables() {
        Map<string, Object> variables = new HashMap<>();
        if (queryVariables != null) {
            for (HistoricVariableInstanceEntity variableInstance : queryVariables) {
                if (variableInstance.getId() != null && variableInstance.getTaskId() == null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }

    @Override
    public List<HistoricVariableInstanceEntity> getQueryVariables() {
        if (queryVariables == null && Context.getCommandContext() != null) {
            queryVariables = new HistoricVariableInitializingList();
        }
        return queryVariables;
    }

    @Override
    public void setQueryVariables(List<HistoricVariableInstanceEntity> queryVariables) {
        this.queryVariables = queryVariables;
    }

    @Override
    public List<HistoricIdentityLinkEntity> getIdentityLinks() {
        if (!isIdentityLinksInitialized) {
            if (queryIdentityLinks == null) {
                identityLinks = CommandContextUtil.getHistoricIdentityLinkEntityManager().findHistoricIdentityLinksByTaskId(id);
            } else {
                identityLinks = queryIdentityLinks;
            }
            isIdentityLinksInitialized = true;
        }

        return identityLinks;
    }

    public List<HistoricIdentityLinkEntity> getQueryIdentityLinks() {
        if(queryIdentityLinks == null) {
            queryIdentityLinks = new LinkedList<>();
        }
        return queryIdentityLinks;
    }

    public void setQueryIdentityLinks(List<HistoricIdentityLinkEntity> identityLinks) {
        queryIdentityLinks = identityLinks;
    }
    
    @Override
    public string toString() {
        return "HistoricTaskInstanceEntity[id=" + id + "]";
    }

}
