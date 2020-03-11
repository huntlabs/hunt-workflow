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


import java.io.Serializable;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import java.util.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;
import flow.task.api.DelegationState;
import org.flowable.task.service.InternalTaskAssignmentManager;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.persistence.CountingTaskEntity;
import org.flowable.task.service.impl.util.CommandContextUtil;
import org.flowable.task.service.impl.util.CountingTaskUtil;
import org.flowable.variable.service.impl.persistence.entity.VariableInitializingList;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;
import org.flowable.variable.service.impl.persistence.entity.VariableScopeImpl;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Falko Menge
 * @author Tijs Rademakers
 */
class TaskEntityImpl extends AbstractTaskServiceVariableScopeEntity implements TaskEntity, CountingTaskEntity, Serializable {

    public static final string DELETE_REASON_COMPLETED = "completed";
    public static final string DELETE_REASON_DELETED = "deleted";

    private static final long serialVersionUID = 1L;

    protected string owner;
    protected int assigneeUpdatedCount; // needed for v5 compatibility
    protected string originalAssignee; // needed for v5 compatibility
    protected string assignee;
    protected DelegationState delegationState;

    protected string parentTaskId;

    protected string name;
    protected string localizedName;
    protected string description;
    protected string localizedDescription;
    protected int priority = DEFAULT_PRIORITY;
    protected Date createTime; // The time when the task has been created
    protected Date dueDate;
    protected int suspensionState = SuspensionState.ACTIVE.getStateCode();
    protected string category;

    protected bool isIdentityLinksInitialized;
    protected List<IdentityLinkEntity> taskIdentityLinkEntities = new ArrayList<>();

    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string taskDefinitionId;

    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;
    protected string propagatedStageInstanceId;

    protected string taskDefinitionKey;
    protected string formKey;

    protected bool isCanceled;

    private bool isCountEnabled;
    protected int variableCount;
    protected int identityLinkCount;
    protected int subTaskCount;

    protected Date claimTime;

    protected string tenantId = TaskServiceConfiguration.NO_TENANT_ID;

    // Non-persisted
    protected string eventName;
    protected string eventHandlerId;
    protected List<VariableInstanceEntity> queryVariables;
    protected List<IdentityLinkEntity> queryIdentityLinks;
    protected bool forcedUpdate;


    public TaskEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("assignee", this.assignee);
        persistentState.put("owner", this.owner);
        persistentState.put("name", this.name);
        persistentState.put("priority", this.priority);
        persistentState.put("category", this.category);
        persistentState.put("formKey", this.formKey);
        if (executionId !is null) {
            persistentState.put("executionId", this.executionId);
        }
        if (processInstanceId !is null) {
            persistentState.put("processInstanceId", this.processInstanceId);
        }
        if (processDefinitionId !is null) {
            persistentState.put("processDefinitionId", this.processDefinitionId);
        }
        if (taskDefinitionId !is null) {
            persistentState.put("taskDefinitionId", this.taskDefinitionId);
        }
        if (taskDefinitionKey !is null) {
            persistentState.put("taskDefinitionKey", this.taskDefinitionKey);
        }
        if (scopeId !is null) {
            persistentState.put("scopeId", this.scopeId);
        }
        if (subScopeId !is null) {
            persistentState.put("subScopeId", this.subScopeId);
        }
        if (scopeType !is null) {
            persistentState.put("scopeType", this.scopeType);
        }
        if (scopeDefinitionId !is null) {
            persistentState.put("scopeDefinitionId", this.scopeDefinitionId);
        }
        if (propagatedStageInstanceId !is null) {
            persistentState.put("propagatedStageInstanceId", propagatedStageInstanceId);
        }
        if (createTime !is null) {
            persistentState.put("createTime", this.createTime);
        }
        if (description !is null) {
            persistentState.put("description", this.description);
        }
        if (dueDate !is null) {
            persistentState.put("dueDate", this.dueDate);
        }
        if (parentTaskId !is null) {
            persistentState.put("parentTaskId", this.parentTaskId);
        }
        if (delegationState !is null) {
            persistentState.put("delegationState", this.delegationState);
            persistentState.put("delegationStateString", getDelegationStateString());
        }

        persistentState.put("suspensionState", this.suspensionState);

        if (forcedUpdate) {
            persistentState.put("forcedUpdate", bool.TRUE);
        }

        if (claimTime !is null) {
            persistentState.put("claimTime", this.claimTime);
        }

        persistentState.put("isCountEnabled", this.isCountEnabled);
        persistentState.put("variableCount", this.variableCount);
        persistentState.put("identityLinkCount", this.identityLinkCount);
        persistentState.put("subTaskCount", this.subTaskCount);

        return persistentState;
    }

    @Override
    public void forceUpdate() {
        this.forcedUpdate = true;
    }

    // variables //////////////////////////////////////////////////////////////////

    @Override
    protected VariableScopeImpl getParentVariableScope() {
        return CommandContextUtil.getTaskServiceConfiguration().getInternalTaskVariableScopeResolver().resolveParentVariableScope(this);
    }

    @Override
    protected void initializeVariableInstanceBackPointer(VariableInstanceEntity variableInstance) {
        variableInstance.setTaskId(id);
        if (ScopeTypes.CMMN.equals(this.scopeType)) {
            variableInstance.setScopeId(this.scopeId);
            variableInstance.setScopeType(this.scopeType);
            variableInstance.setSubScopeId(this.subScopeId);
        } else {
            variableInstance.setExecutionId(this.executionId);
            variableInstance.setProcessInstanceId(this.processInstanceId);
            variableInstance.setProcessDefinitionId(this.processDefinitionId);
        }
    }

    @Override
    protected void addLoggingSessionInfo(ObjectNode loggingNode) {
        // TODO
    }

    @Override
    protected List<VariableInstanceEntity> loadVariableInstances() {
        return CommandContextUtil.getVariableInstanceEntityManager().findVariableInstancesByTaskId(id);
    }

    @Override
    protected VariableInstanceEntity createVariableInstance(string variableName, Object value) {
        VariableInstanceEntity variableInstance = super.createVariableInstance(variableName, value);

        CountingTaskUtil.handleInsertVariableInstanceEntityCount(variableInstance);

        return variableInstance;

    }

    @Override
    protected void deleteVariableInstanceForExplicitUserCall(VariableInstanceEntity variableInstance) {
        super.deleteVariableInstanceForExplicitUserCall(variableInstance);

        CountingTaskUtil.handleDeleteVariableInstanceEntityCount(variableInstance, true);
    }

    // task assignment ////////////////////////////////////////////////////////////

    @Override
    public Set!IdentityLink getCandidates() {
        Set!IdentityLink potentialOwners = new HashSet<>();
        for (IdentityLinkEntity identityLinkEntity : getIdentityLinks()) {
            if (IdentityLinkType.CANDIDATE.equals(identityLinkEntity.getType())) {
                potentialOwners.add(identityLinkEntity);
            }
        }
        return potentialOwners;
    }

    @Override
    public List<IdentityLinkEntity> getIdentityLinks() {
        if (!isIdentityLinksInitialized) {
            if (queryIdentityLinks is null) {
                taskIdentityLinkEntities = CommandContextUtil.getIdentityLinkEntityManager().findIdentityLinksByTaskId(id);
            } else {
                taskIdentityLinkEntities = queryIdentityLinks;
            }
            isIdentityLinksInitialized = true;
        }

        return taskIdentityLinkEntities;
    }

    @Override
    public void setName(string taskName) {
        this.name = taskName;
    }

    @Override
    public void setDescription(string description) {
        this.description = description;
    }

    @Override
    public void setAssignee(string assignee) {
        this.originalAssignee = this.assignee;
        this.assignee = assignee;
        assigneeUpdatedCount++;
    }

    @Override
    public void setAssigneeValue(string assignee) {
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.changeAssignee(this, assignee);
        } else {
            this.originalAssignee = this.assignee;
            this.assignee = assignee;
            assigneeUpdatedCount++;
        }
    }

    @Override
    public void setOwner(string owner) {
        this.owner = owner;
    }

    @Override
    public void setOwnerValue(string owner) {
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.changeOwner(this, owner);
        } else {
            this.owner = owner;
        }
    }

    @Override
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    @Override
    public void setPriority(int priority) {
        this.priority = priority;
    }

    @Override
    public void setCategory(string category) {
        this.category = category;
    }

    @Override
    public void addUserIdentityLink(string userId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addTaskIdentityLink(this.id, userId, null, identityLinkType);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addUserIdentityLink(this, identityLink);
        }
    }

    @Override
    public void addGroupIdentityLink(string groupId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addTaskIdentityLink(this.id, null, groupId, identityLinkType);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addGroupIdentityLink(this, identityLink);
        }
    }

    @Override
    public void deleteCandidateUser(string userId) {
        deleteUserIdentityLink(userId, IdentityLinkType.CANDIDATE);
    }

    @Override
    public void deleteCandidateGroup(string groupId) {
        deleteGroupIdentityLink(groupId, IdentityLinkType.CANDIDATE);
    }

    @Override
    public void deleteUserIdentityLink(string userId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        identityLinkEntityManager.deleteTaskIdentityLink(this.id, getIdentityLinks(), userId, null, identityLinkType);
    }

    @Override
    public void deleteGroupIdentityLink(string groupId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        identityLinkEntityManager.deleteTaskIdentityLink(this.id, getIdentityLinks(), null, groupId,identityLinkType);
    }

    @Override
    public void setParentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
    }

    @Override
    public string getFormKey() {
        return formKey;
    }

    @Override
    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    // Override from VariableScopeImpl

    @Override
    protected bool isPropagateToHistoricVariable() {
        return true;
    }

    // Overridden to avoid fetching *all* variables (as is the case in the super // call)
    @Override
    protected VariableInstanceEntity getSpecificVariable(string variableName) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        VariableInstanceEntity variableInstance = CommandContextUtil.getVariableInstanceEntityManager().findVariableInstanceByTaskAndName(id, variableName);

        return variableInstance;
    }

    @Override
    protected List<VariableInstanceEntity> getSpecificVariables(Collection!string variableNames) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        return CommandContextUtil.getVariableInstanceEntityManager().findVariableInstancesByTaskAndNames(id, variableNames);
    }

    // regular getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getName() {
        if (localizedName !is null && localizedName.length() > 0) {
            return localizedName;
        } else {
            return name;
        }
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

    public string getLocalizedDescription() {
        return localizedDescription;
    }

    @Override
    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }

    @Override
    public Date getDueDate() {
        return dueDate;
    }

    @Override
    public int getPriority() {
        return priority;
    }

    @Override
    public Date getCreateTime() {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public string getExecutionId() {
        return executionId;
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
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }

    @Override
    public void setTaskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
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
    public void setPropagatedStageInstanceId(string propagatedStageInstanceId) {
        this.propagatedStageInstanceId = propagatedStageInstanceId;
    }

    @Override
    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }

    @Override
    public string getAssignee() {
        return assignee;
    }

    public string getOriginalAssignee() {
        // Don't ask. A stupid hack for v5 compatibility
        if (assigneeUpdatedCount > 1) {
            return originalAssignee;
        } else {
            return assignee;
        }
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
    public string getEventName() {
        return eventName;
    }

    @Override
    public void setEventName(string eventName) {
        this.eventName = eventName;
    }

    @Override
    public string getEventHandlerId() {
        return eventHandlerId;
    }

    @Override
    public void setEventHandlerId(string eventHandlerId) {
        this.eventHandlerId = eventHandlerId;
    }

    @Override
    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getOwner() {
        return owner;
    }

    @Override
    public DelegationState getDelegationState() {
        return delegationState;
    }

    @Override
    public void addCandidateUser(string userId) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addCandidateUser(this.id, userId);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateUser(this, identityLink);
        }
    }

    @Override
    public void addCandidateUsers(Collection!string candidateUsers) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        List<IdentityLinkEntity> identityLinks = identityLinkEntityManager.addCandidateUsers(this.id, candidateUsers);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateUsers(this, convertToIdentityLinks(identityLinks));
        }
    }

    @Override
    public void addCandidateGroup(string groupId) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addCandidateGroup(this.id, groupId);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateGroup(this, identityLink);
        }
    }

    @Override
    public void addCandidateGroups(Collection!string candidateGroups) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        List<IdentityLinkEntity> identityLinks = identityLinkEntityManager.addCandidateGroups(this.id, candidateGroups);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateGroups(this, convertToIdentityLinks(identityLinks));
        }
    }

    protected List!IdentityLink convertToIdentityLinks(List<IdentityLinkEntity> identityLinks) {
        List!IdentityLink identityLinkObjects = new ArrayList<>(identityLinks);
        return identityLinkObjects;
    }

    protected InternalTaskAssignmentManager getTaskAssignmentManager() {
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration();
        if (taskServiceConfiguration !is null) {
            return taskServiceConfiguration.getInternalTaskAssignmentManager();
        }

        return null;
    }

    @Override
    public void setDelegationState(DelegationState delegationState) {
        this.delegationState = delegationState;
    }

    public string getDelegationStateString() { // Needed for Activiti 5 compatibility, not exposed in interface
        return (delegationState !is null ? delegationState.toString() : null);
    }

    public void setDelegationStateString(string delegationStateString) {
        this.delegationState = (delegationStateString !is null ? DelegationState.valueOf(DelegationState.class, delegationStateString) : null);
    }

    @Override
    public bool isDeleted() {
        return isDeleted;
    }

    @Override
    public void setDeleted(bool isDeleted) {
        this.isDeleted = isDeleted;
    }

    @Override
    public bool isCanceled() {
        return isCanceled;
    }

    @Override
    public void setCanceled(bool isCanceled) {
        this.isCanceled = isCanceled;
    }

    @Override
    public string getParentTaskId() {
        return parentTaskId;
    }

    @Override
    public Map<string, VariableInstanceEntity> getVariableInstanceEntities() {
        ensureVariableInstancesInitialized();
        return variableInstances;
    }

    @Override
    public int getSuspensionState() {
        return suspensionState;
    }

    @Override
    public void setSuspensionState(int suspensionState) {
        this.suspensionState = suspensionState;
    }

    @Override
    public string getCategory() {
        return category;
    }

    @Override
    public bool isSuspended() {
        return suspensionState == SuspensionState.SUSPENDED.getStateCode();
    }

    @Override
    public Map!(string, Object) getTaskLocalVariables() {
        Map!(string, Object) variables = new HashMap<>();
        if (queryVariables !is null) {
            for (VariableInstanceEntity variableInstance : queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() !is null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }

    @Override
    public Map!(string, Object) getProcessVariables() {
        Map!(string, Object) variables = new HashMap<>();
        if (queryVariables !is null) {
            for (VariableInstanceEntity variableInstance : queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() is null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
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
    public List<VariableInstanceEntity> getQueryVariables() {
        if (queryVariables is null && Context.getCommandContext() !is null) {
            queryVariables = new VariableInitializingList();
        }
        return queryVariables;
    }

    public void setQueryVariables(List<VariableInstanceEntity> queryVariables) {
        this.queryVariables = queryVariables;
    }

    public List<IdentityLinkEntity> getQueryIdentityLinks() {
        if (queryIdentityLinks is null) {
            queryIdentityLinks = new LinkedList<>();
        }
        return queryIdentityLinks;
    }

    public void setQueryIdentityLinks(List<IdentityLinkEntity> identityLinks) {
        queryIdentityLinks = identityLinks;
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
    public string toString() {
        return "Task[id=" + id + ", name=" + name + "]";
    }

    @Override
    public bool isCountEnabled() {
        return isCountEnabled;
    }

    @Override
    public void setCountEnabled(bool isCountEnabled) {
        this.isCountEnabled = isCountEnabled;
    }

    @Override
    public void setVariableCount(int variableCount) {
        this.variableCount = variableCount;
    }

    @Override
    public int getVariableCount() {
        return variableCount;
    }

    @Override
    public void setIdentityLinkCount(int identityLinkCount) {
        this.identityLinkCount = identityLinkCount;
    }

    @Override
    public int getIdentityLinkCount() {
        return identityLinkCount;
    }

    @Override
    public int getSubTaskCount() {
        return subTaskCount;
    }

    @Override
    public void setSubTaskCount(int subTaskCount) {
        this.subTaskCount = subTaskCount;
    }

}
