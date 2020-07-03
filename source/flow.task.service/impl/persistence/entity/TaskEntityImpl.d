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
module flow.task.service.impl.persistence.entity.TaskEntityImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
import hunt.Enum;
import flow.common.api.FlowableException;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntityManager;
import flow.task.api.DelegationState;
import flow.task.service.InternalTaskAssignmentManager;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.persistence.CountingTaskEntity;
import flow.task.service.impl.util.CommandContextUtil;
import flow.task.service.impl.util.CountingTaskUtil;
import flow.variable.service.impl.persistence.entity.VariableInitializingList;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;
import flow.task.service.impl.persistence.entity.AbstractTaskServiceVariableScopeEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import hunt.entity;
alias Date = LocalDateTime;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Falko Menge
 * @author Tijs Rademakers
 */
@Table("ACT_RU_TASK")
class TaskEntityImpl : AbstractTaskServiceVariableScopeEntity , Model,TaskEntity, CountingTaskEntity {
    mixin MakeModel;

    private static  string DELETE_REASON_COMPLETED = "completed";
    private static  string DELETE_REASON_DELETED = "deleted";

     @PrimaryKey
     @Column("ID_")
     string id;

     @Column("OWNER_")
     string owner;

     @Column("ASSIGNEE_")
     string assignee;

     @Column("PARENT_TASK_ID_")
     string parentTaskId;

     @Column("NAME_")
     string name;

     @Column("DESCRIPTION_")
     string description;

     @Column("PRIORITY_")
     int priority  ;//= DEFAULT_PRIORITY;

     @Column("CREATE_TIME_")
     long createTime; // The time when the task has been created

     @Column("DUE_DATE_")
     long dueDate;

     @Column("SUSPENSION_STATE_")
     int suspensionState ;//= SuspensionState.ACTIVE.getStateCode();

     @Column("CATEGORY_")
     string category;

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

     @Column("TASK_DEF_KEY_")
     string taskDefinitionKey;

     @Column("FORM_KEY_")
     string formKey;


     @Column("IS_COUNT_ENABLED_")
     bool _isCountEnabled;

     @Column("VAR_COUNT_")
     int variableCount;

     @Column("ID_LINK_COUNT_")
     int identityLinkCount;

     @Column("SUB_TASK_COUNT_")
     int subTaskCount;

     @Column("CLAIM_TIME_")
     long claimTime;

     @Column("TENANT_ID_")
     string tenantId;//= TaskServiceConfiguration.NO_TENANT_ID;

    // Non-persisted
     private string eventName;
     private string eventHandlerId;
     private List!VariableInstanceEntity queryVariables;
     private List!IdentityLinkEntity queryIdentityLinks;
     private  List!IdentityLinkEntity taskIdentityLinkEntities  ;//= new ArrayList<>();
     private int assigneeUpdatedCount; // needed for v5 compatibility
     private string originalAssignee; // needed for v5 compatibility
     private DelegationState delegationState;
     private string localizedName;
     private string localizedDescription;
     private bool isIdentityLinksInitialized;
     private bool _isCanceled;
     private bool forcedUpdate;


    this() {
        suspensionState = ACTIVE.getStateCode();
        tenantId = TaskServiceConfiguration.NO_TENANT_ID;
        taskIdentityLinkEntities = new ArrayList!IdentityLinkEntity;
        priority = DEFAULT_PRIORITY;
    }

    public Object getPersistentState() {
        //Map!(string, Object) persistentState = new HashMap<>();
        //persistentState.put("assignee", this.assignee);
        //persistentState.put("owner", this.owner);
        //persistentState.put("name", this.name);
        //persistentState.put("priority", this.priority);
        //persistentState.put("category", this.category);
        //persistentState.put("formKey", this.formKey);
        //if (executionId !is null) {
        //    persistentState.put("executionId", this.executionId);
        //}
        //if (processInstanceId !is null) {
        //    persistentState.put("processInstanceId", this.processInstanceId);
        //}
        //if (processDefinitionId !is null) {
        //    persistentState.put("processDefinitionId", this.processDefinitionId);
        //}
        //if (taskDefinitionId !is null) {
        //    persistentState.put("taskDefinitionId", this.taskDefinitionId);
        //}
        //if (taskDefinitionKey !is null) {
        //    persistentState.put("taskDefinitionKey", this.taskDefinitionKey);
        //}
        //if (scopeId !is null) {
        //    persistentState.put("scopeId", this.scopeId);
        //}
        //if (subScopeId !is null) {
        //    persistentState.put("subScopeId", this.subScopeId);
        //}
        //if (scopeType !is null) {
        //    persistentState.put("scopeType", this.scopeType);
        //}
        //if (scopeDefinitionId !is null) {
        //    persistentState.put("scopeDefinitionId", this.scopeDefinitionId);
        //}
        //if (propagatedStageInstanceId !is null) {
        //    persistentState.put("propagatedStageInstanceId", propagatedStageInstanceId);
        //}
        //if (createTime !is null) {
        //    persistentState.put("createTime", this.createTime);
        //}
        //if (description !is null) {
        //    persistentState.put("description", this.description);
        //}
        //if (dueDate !is null) {
        //    persistentState.put("dueDate", this.dueDate);
        //}
        //if (parentTaskId !is null) {
        //    persistentState.put("parentTaskId", this.parentTaskId);
        //}
        //if (delegationState !is null) {
        //    persistentState.put("delegationState", this.delegationState);
        //    persistentState.put("delegationStateString", getDelegationStateString());
        //}
        //
        //persistentState.put("suspensionState", this.suspensionState);
        //
        //if (forcedUpdate) {
        //    persistentState.put("forcedUpdate", bool.TRUE);
        //}
        //
        //if (claimTime !is null) {
        //    persistentState.put("claimTime", this.claimTime);
        //}
        //
        //persistentState.put("isCountEnabled", this.isCountEnabled);
        //persistentState.put("variableCount", this.variableCount);
        //persistentState.put("identityLinkCount", this.identityLinkCount);
        //persistentState.put("subTaskCount", this.subTaskCount);
        //
        //return persistentState;
        return this;
    }


    public string getId() {
        return id;
    }


    public void setId(string id) {
        this.id = id;
    }

    public void forceUpdate() {
        this.forcedUpdate = true;
    }

    // variables //////////////////////////////////////////////////////////////////

    override
    protected VariableScopeImpl getParentVariableScope() {
        return CommandContextUtil.getTaskServiceConfiguration().getInternalTaskVariableScopeResolver().resolveParentVariableScope(this);
    }

    override
    protected void initializeVariableInstanceBackPointer(VariableInstanceEntity variableInstance) {
        variableInstance.setTaskId(id);
        if (ScopeTypes.CMMN == (this.scopeType)) {
            variableInstance.setScopeId(this.scopeId);
            variableInstance.setScopeType(this.scopeType);
            variableInstance.setSubScopeId(this.subScopeId);
        } else {
            variableInstance.setExecutionId(this.executionId);
            variableInstance.setProcessInstanceId(this.processInstanceId);
            variableInstance.setProcessDefinitionId(this.processDefinitionId);
        }
    }


    //protected void addLoggingSessionInfo(ObjectNode loggingNode) {
    //    // TODO
    //}

    override
    protected List!VariableInstanceEntity loadVariableInstances() {
        return CommandContextUtil.getVariableInstanceEntityManager().findVariableInstancesByTaskId(id);
    }

    override
    protected VariableInstanceEntity createVariableInstance(string variableName, Object value) {
        VariableInstanceEntity variableInstance = super.createVariableInstance(variableName, value);

        CountingTaskUtil.handleInsertVariableInstanceEntityCount(variableInstance);

        return variableInstance;

    }

    override
    protected void deleteVariableInstanceForExplicitUserCall(VariableInstanceEntity variableInstance) {
        super.deleteVariableInstanceForExplicitUserCall(variableInstance);

        CountingTaskUtil.handleDeleteVariableInstanceEntityCount(variableInstance, true);
    }

    // task assignment ////////////////////////////////////////////////////////////


    public Set!IdentityLink getCandidates() {
        Set!IdentityLink potentialOwners = new HashSet!IdentityLink();
        foreach (IdentityLinkEntity identityLinkEntity ; getIdentityLinks()) {
            if (IdentityLinkType.CANDIDATE == (identityLinkEntity.getType())) {
                potentialOwners.add(identityLinkEntity);
            }
        }
        return potentialOwners;
    }


    public List!IdentityLinkEntity getIdentityLinks() {
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


    public void setName(string taskName) {
        this.name = taskName;
    }


    public void setDescription(string description) {
        this.description = description;
    }


    public void setAssignee(string assignee) {
        this.originalAssignee = this.assignee;
        this.assignee = assignee;
        assigneeUpdatedCount++;
    }


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


    public void setOwner(string owner) {
        this.owner = owner;
    }


    public void setOwnerValue(string owner) {
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.changeOwner(this, owner);
        } else {
            this.owner = owner;
        }
    }


    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate.toEpochMilli;
    }


    public void setPriority(int priority) {
        this.priority = priority;
    }


    public void setCategory(string category) {
        this.category = category;
    }


    public void addUserIdentityLink(string userId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addTaskIdentityLink(this.id, userId, null, identityLinkType);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addUserIdentityLink(this, identityLink);
        }
    }


    public void addGroupIdentityLink(string groupId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addTaskIdentityLink(this.id, null, groupId, identityLinkType);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addGroupIdentityLink(this, identityLink);
        }
    }


    public void deleteCandidateUser(string userId) {
        deleteUserIdentityLink(userId, IdentityLinkType.CANDIDATE);
    }


    public void deleteCandidateGroup(string groupId) {
        deleteGroupIdentityLink(groupId, IdentityLinkType.CANDIDATE);
    }


    public void deleteUserIdentityLink(string userId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        identityLinkEntityManager.deleteTaskIdentityLink(this.id, getIdentityLinks(), userId, null, identityLinkType);
    }


    public void deleteGroupIdentityLink(string groupId, string identityLinkType) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        identityLinkEntityManager.deleteTaskIdentityLink(this.id, getIdentityLinks(), null, groupId,identityLinkType);
    }


    public void setParentTaskId(string parentTaskId) {
        this.parentTaskId = parentTaskId;
    }


    public string getFormKey() {
        return formKey;
    }


    public void setFormKey(string formKey) {
        this.formKey = formKey;
    }

    // Override from VariableScopeImpl

    override
    protected bool isPropagateToHistoricVariable() {
        return true;
    }

    // Overridden to avoid fetching *all* variables (as is the case in the super // call)

    override
    protected VariableInstanceEntity getSpecificVariable(string variableName) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        VariableInstanceEntity variableInstance = CommandContextUtil.getVariableInstanceEntityManager().findVariableInstanceByTaskAndName(id, variableName);

        return variableInstance;
    }

    override
    protected List!VariableInstanceEntity getSpecificVariables(Collection!string variableNames) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        return CommandContextUtil.getVariableInstanceEntityManager().findVariableInstancesByTaskAndNames(id, variableNames);
    }

    // regular getters and setters ////////////////////////////////////////////////////////


    public string getName() {
        if (localizedName !is null && localizedName.length > 0) {
            return localizedName;
        } else {
            return name;
        }
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

    public string getLocalizedDescription() {
        return localizedDescription;
    }


    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }


    public Date getDueDate() {
        return LocalDateTime.ofEpochMilli(dueDate);
    }


    public int getPriority() {
        return priority;
    }


    public Date getCreateTime() {
        return LocalDateTime.ofEpochMilli(createTime);
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime.toEpochMilli;
    }


    public string getExecutionId() {
        return executionId;
    }


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }


    public void setTaskDefinitionId(string taskDefinitionId) {
        this.taskDefinitionId = taskDefinitionId;
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


    public void setPropagatedStageInstanceId(string propagatedStageInstanceId) {
        this.propagatedStageInstanceId = propagatedStageInstanceId;
    }


    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }


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


    public string getTaskDefinitionKey() {
        return taskDefinitionKey;
    }


    public void setTaskDefinitionKey(string taskDefinitionKey) {
        this.taskDefinitionKey = taskDefinitionKey;
    }


    public string getEventName() {
        return eventName;
    }


    public void setEventName(string eventName) {
        this.eventName = eventName;
    }


    public string getEventHandlerId() {
        return eventHandlerId;
    }


    public void setEventHandlerId(string eventHandlerId) {
        this.eventHandlerId = eventHandlerId;
    }


    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }


    public string getOwner() {
        return owner;
    }


    public DelegationState getDelegationState() {
        return delegationState;
    }


    public void addCandidateUser(string userId) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addCandidateUser(this.id, userId);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateUser(this, identityLink);
        }
    }


    public void addCandidateUsers(Collection!string candidateUsers) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        List!IdentityLinkEntity identityLinks = identityLinkEntityManager.addCandidateUsers(this.id, candidateUsers);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateUsers(this, convertToIdentityLinks(identityLinks));
        }
    }


    public void addCandidateGroup(string groupId) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        IdentityLinkEntity identityLink = identityLinkEntityManager.addCandidateGroup(this.id, groupId);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateGroup(this, identityLink);
        }
    }


    public void addCandidateGroups(Collection!string candidateGroups) {
        IdentityLinkEntityManager identityLinkEntityManager = CommandContextUtil.getIdentityLinkEntityManager();
        List!IdentityLinkEntity identityLinks = identityLinkEntityManager.addCandidateGroups(this.id, candidateGroups);
        InternalTaskAssignmentManager taskAssignmentManager = getTaskAssignmentManager();
        if (taskAssignmentManager !is null) {
            taskAssignmentManager.addCandidateGroups(this, convertToIdentityLinks(identityLinks));
        }
    }

    protected List!IdentityLink convertToIdentityLinks(List!IdentityLinkEntity identityLinks) {
        List!IdentityLink identityLinkObjects = new ArrayList!IdentityLink();
        foreach(IdentityLinkEntity i ; identityLinks)
        {
            identityLinkObjects.add(cast(IdentityLink) i);
        }

        return identityLinkObjects;
    }

    protected InternalTaskAssignmentManager getTaskAssignmentManager() {
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration();
        if (taskServiceConfiguration !is null) {
            return taskServiceConfiguration.getInternalTaskAssignmentManager();
        }

        return null;
    }


    public void setDelegationState(DelegationState delegationState) {
        this.delegationState = delegationState;
    }

    public string getDelegationStateString() { // Needed for Activiti 5 compatibility, not exposed in interface
        return (delegationState !is null ? delegationState.toString() : null);
    }

    public void setDelegationStateString(string delegationStateString) {
        this.delegationState = ((delegationStateString !is null && delegationStateString.length != 0) ? valueOf!DelegationState(delegationStateString) : null);
    }

    override
    public bool isDeleted() {
        return super.isDeleted;
    }

    override
    public void setDeleted(bool isDeleted) {
          super.setDeleted(isDeleted);
    }


    public bool isCanceled() {
        return _isCanceled;
    }


    public void setCanceled(bool isCanceled) {
        this._isCanceled = isCanceled;
    }


    public string getParentTaskId() {
        return parentTaskId;
    }

    override
    public Map!(string, VariableInstanceEntity) getVariableInstanceEntities() {
        ensureVariableInstancesInitialized();
        return variableInstances;
    }


    public int getSuspensionState() {
        return suspensionState;
    }


    public void setSuspensionState(int suspensionState) {
        this.suspensionState = suspensionState;
    }


    public string getCategory() {
        return category;
    }


    public bool isSuspended() {
        return suspensionState == SUSPENDED.getStateCode();
    }


    public Map!(string, Object) getTaskLocalVariables() {
        Map!(string, Object) variables = new HashMap!(string, Object)();
        if (queryVariables !is null) {
            foreach (VariableInstanceEntity variableInstance ; queryVariables) {
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
            foreach (VariableInstanceEntity variableInstance ; queryVariables) {
                if (variableInstance.getId() !is null && variableInstance.getTaskId() is null) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }
        return variables;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public List!VariableInstanceEntity getQueryVariables() {
        if (queryVariables is null && Context.getCommandContext() !is null) {
            queryVariables = new VariableInitializingList();
        }
        return queryVariables;
    }

    public void setQueryVariables(List!VariableInstanceEntity queryVariables) {
        this.queryVariables = queryVariables;
    }

    public List!IdentityLinkEntity getQueryIdentityLinks() {
        if (queryIdentityLinks is null) {
            queryIdentityLinks = new LinkedList!IdentityLinkEntity();
        }
        return queryIdentityLinks;
    }

    public void setQueryIdentityLinks(List!IdentityLinkEntity identityLinks) {
        queryIdentityLinks = identityLinks;
    }


    public Date getClaimTime() {
        return LocalDateTime.ofEpochMilli(claimTime);
    }


    public void setClaimTime(Date claimTime) {
        this.claimTime = claimTime.toEpochMilli();
    }


    override
    public string toString() {
        return "Task[id=" ~ id ~ ", name=" ~ name ~ "]";
    }


    public bool isCountEnabled() {
        return _isCountEnabled;
    }


    public void setCountEnabled(bool isCountEnabled) {
        this._isCountEnabled = isCountEnabled;
    }


    public void setVariableCount(int variableCount) {
        this.variableCount = variableCount;
    }


    public int getVariableCount() {
        return variableCount;
    }


    public void setIdentityLinkCount(int identityLinkCount) {
        this.identityLinkCount = identityLinkCount;
    }


    public int getIdentityLinkCount() {
        return identityLinkCount;
    }


    public int getSubTaskCount() {
        return subTaskCount;
    }


    public void setSubTaskCount(int subTaskCount) {
        this.subTaskCount = subTaskCount;
    }

}
