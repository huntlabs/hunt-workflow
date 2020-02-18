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
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Objects;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.api.scope.ScopeTypes;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.persistence.cache.EntityCache;
import org.flowable.idm.api.Group;
import org.flowable.idm.api.IdmEngineConfigurationApi;
import org.flowable.idm.api.IdmIdentityService;
import org.flowable.task.api.DelegationState;
import org.flowable.task.api.Task;
import org.flowable.task.api.TaskQuery;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.task.service.impl.util.CommandContextUtil;
import org.flowable.variable.api.types.VariableTypes;
import org.flowable.variable.service.impl.AbstractVariableQueryImpl;
import org.flowable.variable.service.impl.QueryVariableValue;
import org.flowable.variable.service.impl.persistence.entity.VariableInstanceEntity;

/**
 * @author Joram Barrez
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Tijs Rademakers
 */
class TaskQueryImpl extends AbstractVariableQueryImpl<TaskQuery, Task> implements TaskQuery, QueryCacheValues {

    private static final long serialVersionUID = 1L;

    protected string taskId;
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected Collection<string> nameList;
    protected Collection<string> nameListIgnoreCase;
    protected string description;
    protected string descriptionLike;
    protected string descriptionLikeIgnoreCase;
    protected Integer priority;
    protected Integer minPriority;
    protected Integer maxPriority;
    protected string assignee;
    protected string assigneeLike;
    protected string assigneeLikeIgnoreCase;
    protected Collection<string> assigneeIds;
    protected string involvedUser;
    protected Collection<string> involvedGroups;
    protected string owner;
    protected string ownerLike;
    protected string ownerLikeIgnoreCase;
    protected bool unassigned;
    protected bool noDelegationState;
    protected DelegationState delegationState;
    protected string candidateUser;
    protected string candidateGroup;
    protected Collection<string> candidateGroups;
    protected bool ignoreAssigneeValue;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool withoutDeleteReason;
    protected string processInstanceId;
    protected Collection<string> processInstanceIds;
    protected string executionId;
    protected string scopeId;
    protected string subScopeId;
    protected string scopeType;
    protected string scopeDefinitionId;
    protected string propagatedStageInstanceId;
    protected string processInstanceIdWithChildren;
    protected string caseInstanceIdWithChildren;
    protected Date createTime;
    protected Date createTimeBefore;
    protected Date createTimeAfter;
    protected string category;
    protected bool withFormKey;
    protected string formKey;
    protected string taskDefinitionId;
    protected string key;
    protected string keyLike;
    protected Collection<string> keys;
    protected string processDefinitionKey;
    protected string processDefinitionKeyLike;
    protected string processDefinitionKeyLikeIgnoreCase;
    protected Collection<string> processDefinitionKeys;
    protected string processDefinitionId;
    protected string processDefinitionName;
    protected string processDefinitionNameLike;
    protected Collection<string> processCategoryInList;
    protected Collection<string> processCategoryNotInList;
    protected string deploymentId;
    protected Collection<string> deploymentIds;
    protected string cmmnDeploymentId;
    protected Collection<string> cmmnDeploymentIds;
    protected string processInstanceBusinessKey;
    protected string processInstanceBusinessKeyLike;
    protected string processInstanceBusinessKeyLikeIgnoreCase;
    protected Date dueDate;
    protected Date dueBefore;
    protected Date dueAfter;
    protected bool withoutDueDate;
    protected SuspensionState suspensionState;
    protected bool excludeSubtasks;
    protected bool includeTaskLocalVariables;
    protected bool includeProcessVariables;
    protected Integer taskVariablesLimit;
    protected bool includeIdentityLinks;
    protected string userIdForCandidateAndAssignee;
    protected bool bothCandidateAndAssigned;
    protected string locale;
    protected bool withLocalizationFallback;
    protected bool orActive;
    protected List<TaskQueryImpl> orQueryObjects = new ArrayList<>();
    protected TaskQueryImpl currentOrQueryObject;

    private Collection<string> cachedCandidateGroups;

    public TaskQueryImpl() {
    }

    public TaskQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public TaskQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    public TaskQueryImpl(CommandExecutor commandExecutor, string databaseType) {
        super(commandExecutor);
        this.databaseType = databaseType;
    }

    @Override
    public TaskQueryImpl taskId(string taskId) {
        if (taskId is null) {
            throw new FlowableIllegalArgumentException("Task id is null");
        }

        if (orActive) {
            currentOrQueryObject.taskId = taskId;
        } else {
            this.taskId = taskId;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("Task name is null");
        }

        if (orActive) {
            currentOrQueryObject.name = name;
        } else {
            this.name = name;
        }
        return this;
    }

    @Override
    public TaskQuery taskNameIn(Collection<string> nameList) {
        if (nameList is null) {
            throw new FlowableIllegalArgumentException("Task name list is null");
        }
        if (nameList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task name list is empty");
        }
        for (string name : nameList) {
            if (name is null) {
                throw new FlowableIllegalArgumentException("None of the given task names can be null");
            }
        }

        if (name !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and name");
        }
        if (nameLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and nameLike");
        }
        if (nameLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and nameLikeIgnoreCase");
        }

        if (orActive) {
            currentOrQueryObject.nameList = nameList;
        } else {
            this.nameList = nameList;
        }
        return this;
    }

    @Override
    public TaskQuery taskNameInIgnoreCase(Collection<string> nameList) {
        if (nameList is null) {
            throw new FlowableIllegalArgumentException("Task name list is null");
        }
        if (nameList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task name list is empty");
        }
        for (string name : nameList) {
            if (name is null) {
                throw new FlowableIllegalArgumentException("None of the given task names can be null");
            }
        }

        if (name !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and name");
        }
        if (nameLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and nameLike");
        }
        if (nameLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and nameLikeIgnoreCase");
        }

        final int nameListSize = nameList.size();
        final Collection<string> caseIgnoredNameList = new ArrayList<>(nameListSize);
        for (string name : nameList) {
            caseIgnoredNameList.add(name.toLowerCase());
        }

        if (orActive) {
            this.currentOrQueryObject.nameListIgnoreCase = caseIgnoredNameList;
        } else {
            this.nameListIgnoreCase = caseIgnoredNameList;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("Task namelike is null");
        }

        if (orActive) {
            currentOrQueryObject.nameLike = nameLike;
        } else {
            this.nameLike = nameLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        if (nameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Task nameLikeIgnoreCase is null");
        }

        if (orActive) {
            currentOrQueryObject.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        } else {
            this.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskDescription(string description) {
        if (description is null) {
            throw new FlowableIllegalArgumentException("Description is null");
        }

        if (orActive) {
            currentOrQueryObject.description = description;
        } else {
            this.description = description;
        }
        return this;
    }

    @Override
    public TaskQuery taskDescriptionLike(string descriptionLike) {
        if (descriptionLike is null) {
            throw new FlowableIllegalArgumentException("Task descriptionlike is null");
        }
        if (orActive) {
            currentOrQueryObject.descriptionLike = descriptionLike;
        } else {
            this.descriptionLike = descriptionLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskDescriptionLikeIgnoreCase(string descriptionLikeIgnoreCase) {
        if (descriptionLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Task descriptionLikeIgnoreCase is null");
        }
        if (orActive) {
            currentOrQueryObject.descriptionLikeIgnoreCase = descriptionLikeIgnoreCase.toLowerCase();
        } else {
            this.descriptionLikeIgnoreCase = descriptionLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQuery taskPriority(Integer priority) {
        if (priority is null) {
            throw new FlowableIllegalArgumentException("Priority is null");
        }
        if (orActive) {
            currentOrQueryObject.priority = priority;
        } else {
            this.priority = priority;
        }
        return this;
    }

    @Override
    public TaskQuery taskMinPriority(Integer minPriority) {
        if (minPriority is null) {
            throw new FlowableIllegalArgumentException("Min Priority is null");
        }
        if (orActive) {
            currentOrQueryObject.minPriority = minPriority;
        } else {
            this.minPriority = minPriority;
        }
        return this;
    }

    @Override
    public TaskQuery taskMaxPriority(Integer maxPriority) {
        if (maxPriority is null) {
            throw new FlowableIllegalArgumentException("Max Priority is null");
        }
        if (orActive) {
            currentOrQueryObject.maxPriority = maxPriority;
        } else {
            this.maxPriority = maxPriority;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskAssignee(string assignee) {
        if (assignee is null) {
            throw new FlowableIllegalArgumentException("Assignee is null");
        }
        if (orActive) {
            currentOrQueryObject.assignee = assignee;
        } else {
            this.assignee = assignee;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskAssigneeLike(string assigneeLike) {
        if (assigneeLike is null) {
            throw new FlowableIllegalArgumentException("AssigneeLike is null");
        }
        if (orActive) {
            currentOrQueryObject.assigneeLike = assigneeLike;
        } else {
            this.assigneeLike = assigneeLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskAssigneeLikeIgnoreCase(string assigneeLikeIgnoreCase) {
        if (assigneeLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("assigneeLikeIgnoreCase is null");
        }
        if (orActive) {
            currentOrQueryObject.assigneeLikeIgnoreCase = assigneeLikeIgnoreCase.toLowerCase();
        } else {
            this.assigneeLikeIgnoreCase = assigneeLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQuery taskAssigneeIds(Collection<string> assigneeIds) {
        if (assigneeIds is null) {
            throw new FlowableIllegalArgumentException("Task assignee list is null");
        }
        if (assigneeIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task assignee list is empty");
        }
        for (string assignee : assigneeIds) {
            if (assignee is null) {
                throw new FlowableIllegalArgumentException("None of the given task assignees can be null");
            }
        }

        if (assignee !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssignee");
        }
        if (assigneeLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssigneeLike");
        }
        if (assigneeLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssigneeLikeIgnoreCase");
        }

        if (orActive) {
            currentOrQueryObject.assigneeIds = assigneeIds;
        } else {
            this.assigneeIds = assigneeIds;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskOwner(string owner) {
        if (owner is null) {
            throw new FlowableIllegalArgumentException("Owner is null");
        }
        if (orActive) {
            currentOrQueryObject.owner = owner;
        } else {
            this.owner = owner;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskOwnerLike(string ownerLike) {
        if (ownerLike is null) {
            throw new FlowableIllegalArgumentException("Owner is null");
        }
        if (orActive) {
            currentOrQueryObject.ownerLike = ownerLike;
        } else {
            this.ownerLike = ownerLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskOwnerLikeIgnoreCase(string ownerLikeIgnoreCase) {
        if (ownerLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("OwnerLikeIgnoreCase");
        }
        if (orActive) {
            currentOrQueryObject.ownerLikeIgnoreCase = ownerLikeIgnoreCase.toLowerCase();
        } else {
            this.ownerLikeIgnoreCase = ownerLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQuery taskUnassigned() {
        if (orActive) {
            currentOrQueryObject.unassigned = true;
        } else {
            this.unassigned = true;
        }
        return this;
    }

    @Override
    public TaskQuery taskDelegationState(DelegationState delegationState) {
        if (orActive) {
            if (delegationState is null) {
                currentOrQueryObject.noDelegationState = true;
            } else {
                currentOrQueryObject.delegationState = delegationState;
            }
        } else {
            if (delegationState is null) {
                this.noDelegationState = true;
            } else {
                this.delegationState = delegationState;
            }
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskCandidateUser(string candidateUser) {
        if (candidateUser is null) {
            throw new FlowableIllegalArgumentException("Candidate user is null");
        }

        if (orActive) {
            currentOrQueryObject.candidateUser = candidateUser;
        } else {
            this.candidateUser = candidateUser;
        }

        return this;
    }

    @Override
    public TaskQueryImpl taskInvolvedUser(string involvedUser) {
        if (involvedUser is null) {
            throw new FlowableIllegalArgumentException("Involved user is null");
        }
        if (orActive) {
            currentOrQueryObject.involvedUser = involvedUser;
        } else {
            this.involvedUser = involvedUser;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskInvolvedGroups(Collection<string> involvedGroups) {
        if (involvedGroups is null) {
            throw new FlowableIllegalArgumentException("Involved groups are null");
        }
        if (involvedGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("Involved groups are empty");
        }
        if (orActive) {
            currentOrQueryObject.involvedGroups = involvedGroups;
        } else {
            this.involvedGroups = involvedGroups;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskCandidateGroup(string candidateGroup) {
        if (candidateGroup is null) {
            throw new FlowableIllegalArgumentException("Candidate group is null");
        }

        if (candidateGroups !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both candidateGroup and candidateGroupIn");
        }

        if (orActive) {
            currentOrQueryObject.candidateGroup = candidateGroup;
        } else {
            this.candidateGroup = candidateGroup;
        }
        return this;
    }

    @Override
    public TaskQuery taskCandidateOrAssigned(string userIdForCandidateAndAssignee) {
        if (candidateGroup !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set candidateGroup");
        }
        if (candidateUser !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both candidateGroup and candidateUser");
        }

        if (orActive) {
            currentOrQueryObject.bothCandidateAndAssigned = true;
            currentOrQueryObject.userIdForCandidateAndAssignee = userIdForCandidateAndAssignee;
        } else {
            this.bothCandidateAndAssigned = true;
            this.userIdForCandidateAndAssignee = userIdForCandidateAndAssignee;
        }

        return this;
    }

    @Override
    public TaskQuery taskCandidateGroupIn(Collection<string> candidateGroups) {
        if (candidateGroups is null) {
            throw new FlowableIllegalArgumentException("Candidate group list is null");
        }

        if (candidateGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("Candidate group list is empty");
        }

        if (candidateGroup !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both candidateGroupIn and candidateGroup");
        }

        if (orActive) {
            currentOrQueryObject.candidateGroups = candidateGroups;
        } else {
            this.candidateGroups = candidateGroups;
        }
        return this;
    }

    @Override
    public TaskQuery ignoreAssigneeValue() {
        if (orActive) {
            currentOrQueryObject.ignoreAssigneeValue = true;
        } else {
            this.ignoreAssigneeValue = true;
        }
        return this;
    }

    @Override
    public TaskQuery taskTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("task tenant id is null");
        }
        if (orActive) {
            currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }

    @Override
    public TaskQuery taskTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("task tenant id is null");
        }
        if (orActive) {
            currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskWithoutTenantId() {
        if (orActive) {
            currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        return this;
    }

    @Override
    public TaskQuery taskWithoutDeleteReason() {
        if (orActive) {
            currentOrQueryObject.withoutDeleteReason = true;
        } else {
            this.withoutDeleteReason = true;
        }
        return this;
    }

    @Override
    public TaskQueryImpl processInstanceId(string processInstanceId) {
        if (orActive) {
            currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this.processInstanceId = processInstanceId;
        }
        return this;
    }

    @Override
    public TaskQuery processInstanceIdIn(Collection<string> processInstanceIds) {
        if (processInstanceIds is null) {
            throw new FlowableIllegalArgumentException("Process instance id list is null");
        }
        if (processInstanceIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process instance id list is empty");
        }
        for (string processInstanceId : processInstanceIds) {
            if (processInstanceId is null) {
                throw new FlowableIllegalArgumentException("None of the given process instance ids can be null");
            }
        }

        if (orActive) {
            currentOrQueryObject.processInstanceIds = processInstanceIds;
        } else {
            this.processInstanceIds = processInstanceIds;
        }
        return this;
    }

    @Override
    public TaskQueryImpl processInstanceBusinessKey(string processInstanceBusinessKey) {
        if (orActive) {
            currentOrQueryObject.processInstanceBusinessKey = processInstanceBusinessKey;
        } else {
            this.processInstanceBusinessKey = processInstanceBusinessKey;
        }
        return this;
    }

    @Override
    public TaskQueryImpl processInstanceBusinessKeyLike(string processInstanceBusinessKeyLike) {
        if (orActive) {
            currentOrQueryObject.processInstanceBusinessKeyLike = processInstanceBusinessKeyLike;
        } else {
            this.processInstanceBusinessKeyLike = processInstanceBusinessKeyLike;
        }
        return this;
    }

    @Override
    public TaskQuery processInstanceBusinessKeyLikeIgnoreCase(string processInstanceBusinessKeyLikeIgnoreCase) {
        if (orActive) {
            currentOrQueryObject.processInstanceBusinessKeyLikeIgnoreCase = processInstanceBusinessKeyLikeIgnoreCase.toLowerCase();
        } else {
            this.processInstanceBusinessKeyLikeIgnoreCase = processInstanceBusinessKeyLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQueryImpl executionId(string executionId) {
        if (orActive) {
            currentOrQueryObject.executionId = executionId;
        } else {
            this.executionId = executionId;
        }
        return this;
    }

    @Override
    public TaskQuery caseInstanceId(string caseInstanceId) {
        if (orActive) {
            currentOrQueryObject.scopeId(caseInstanceId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.scopeId(caseInstanceId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }

    @Override
    public TaskQuery caseDefinitionId(string caseDefinitionId) {
        if (orActive) {
            currentOrQueryObject.scopeDefinitionId(caseDefinitionId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.scopeDefinitionId(caseDefinitionId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }

    @Override
    public TaskQuery processInstanceIdWithChildren(string processInstanceId) {
        if (orActive) {
            currentOrQueryObject.processInstanceIdWithChildren(processInstanceId);
        } else {
            this.processInstanceIdWithChildren = processInstanceId;
        }
        return this;
    }

    @Override
    public TaskQuery caseInstanceIdWithChildren(string caseInstanceId) {
        if (orActive) {
            currentOrQueryObject.caseInstanceIdWithChildren(caseInstanceId);
        } else {
            this.caseInstanceIdWithChildren = caseInstanceId;
        }
        return this;
    }

    @Override
    public TaskQuery planItemInstanceId(string planItemInstanceId) {
        if (orActive) {
            currentOrQueryObject.subScopeId(planItemInstanceId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.subScopeId(planItemInstanceId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }

    @Override
    public TaskQueryImpl scopeId(string scopeId) {
        if (orActive) {
            currentOrQueryObject.scopeId = scopeId;
        } else {
            this.scopeId = scopeId;
        }
        return this;
    }

    @Override
    public TaskQueryImpl subScopeId(string subScopeId) {
        if (orActive) {
            currentOrQueryObject.subScopeId = subScopeId;
        } else {
            this.subScopeId = subScopeId;
        }
        return this;
    }

    @Override
    public TaskQueryImpl scopeType(string scopeType) {
        if (orActive) {
            currentOrQueryObject.scopeType = scopeType;
        } else {
            this.scopeType = scopeType;
        }
        return this;
    }

    @Override
    public TaskQueryImpl scopeDefinitionId(string scopeDefinitionId) {
        if (orActive) {
            currentOrQueryObject.scopeDefinitionId = scopeDefinitionId;
        } else {
            this.scopeDefinitionId = scopeDefinitionId;
        }
        return this;
    }

    @Override
    public TaskQuery propagatedStageInstanceId(string propagatedStageInstanceId) {
        if (orActive) {
            currentOrQueryObject.propagatedStageInstanceId = propagatedStageInstanceId;
        } else {
            this.propagatedStageInstanceId = propagatedStageInstanceId;
        }
        return this;
    }

    @Override
    public TaskQueryImpl taskCreatedOn(Date createTime) {
        if (orActive) {
            currentOrQueryObject.createTime = createTime;
        } else {
            this.createTime = createTime;
        }
        return this;
    }

    @Override
    public TaskQuery taskCreatedBefore(Date before) {
        if (orActive) {
            currentOrQueryObject.createTimeBefore = before;
        } else {
            this.createTimeBefore = before;
        }
        return this;
    }

    @Override
    public TaskQuery taskCreatedAfter(Date after) {
        if (orActive) {
            currentOrQueryObject.createTimeAfter = after;
        } else {
            this.createTimeAfter = after;
        }
        return this;
    }

    @Override
    public TaskQuery taskCategory(string category) {
        if (orActive) {
            currentOrQueryObject.category = category;
        } else {
            this.category = category;
        }
        return this;
    }

    @Override
    public TaskQuery taskWithFormKey() {
        if (orActive) {
            currentOrQueryObject.withFormKey = true;
        } else {
            this.withFormKey = true;
        }
        return this;
    }

    @Override
    public TaskQuery taskFormKey(string formKey) {
        if (formKey is null) {
            throw new FlowableIllegalArgumentException("Task formKey is null");
        }
        if (orActive) {
            currentOrQueryObject.formKey = formKey;
        } else {
            this.formKey = formKey;
        }
        return this;
    }

    @Override
    public TaskQuery taskDefinitionId(string taskDefinitionId) {
        if (orActive) {
            currentOrQueryObject.taskDefinitionId = taskDefinitionId;
        } else {
            this.taskDefinitionId = taskDefinitionId;
        }
        return this;
    }

    @Override
    public TaskQuery taskDefinitionKey(string key) {
        if (orActive) {
            currentOrQueryObject.key = key;
        } else {
            this.key = key;
        }
        return this;
    }

    @Override
    public TaskQuery taskDefinitionKeyLike(string keyLike) {
        if (orActive) {
            currentOrQueryObject.keyLike = keyLike;
        } else {
            this.keyLike = keyLike;
        }
        return this;
    }

    @Override
    public TaskQuery taskDefinitionKeys(Collection<string> keys) {
        if (orActive) {
            currentOrQueryObject.keys = keys;
        } else {
            this.keys = keys;
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueEquals(string variableName, Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue);
        } else {
            this.variableValueEquals(variableName, variableValue);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueEquals(Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueEquals(variableValue);
        } else {
            this.variableValueEquals(variableValue);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueEqualsIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value);
        } else {
            this.variableValueEqualsIgnoreCase(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value);
        } else {
            this.variableValueNotEqualsIgnoreCase(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueNotEquals(string variableName, Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue);
        } else {
            this.variableValueNotEquals(variableName, variableValue);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueGreaterThan(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueGreaterThan(name, value);
        } else {
            this.variableValueGreaterThan(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueGreaterThanOrEqual(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value);
        } else {
            this.variableValueGreaterThanOrEqual(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueLessThan(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueLessThan(name, value);
        } else {
            this.variableValueLessThan(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueLessThanOrEqual(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value);
        } else {
            this.variableValueLessThanOrEqual(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueLike(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueLike(name, value);
        } else {
            this.variableValueLike(name, value);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableValueLikeIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value);
        } else {
            this.variableValueLikeIgnoreCase(name, value);
        }
        return this;
    }


    @Override
    public TaskQuery taskVariableExists(string name) {
        if (orActive) {
            currentOrQueryObject.variableExists(name);
        } else {
            this.variableExists(name);
        }
        return this;
    }

    @Override
    public TaskQuery taskVariableNotExists(string name) {
        if (orActive) {
            currentOrQueryObject.variableNotExists(name);
        } else {
            this.variableNotExists(name);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueEquals(string variableName, Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
        } else {
            this.variableValueEquals(variableName, variableValue, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueNotEquals(string variableName, Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
        } else {
            this.variableValueNotEquals(variableName, variableValue, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueEquals(Object variableValue) {
        if (orActive) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
        } else {
            this.variableValueEquals(variableValue, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueEqualsIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
        } else {
            this.variableValueEqualsIgnoreCase(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
        } else {
            this.variableValueNotEqualsIgnoreCase(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueGreaterThan(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
        } else {
            this.variableValueGreaterThan(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueGreaterThanOrEqual(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
        } else {
            this.variableValueGreaterThanOrEqual(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueLessThan(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
        } else {
            this.variableValueLessThan(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueLessThanOrEqual(string name, Object value) {
        if (orActive) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
        } else {
            this.variableValueLessThanOrEqual(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueLike(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueLike(name, value, false);
        } else {
            this.variableValueLike(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableValueLikeIgnoreCase(string name, string value) {
        if (orActive) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
        } else {
            this.variableValueLikeIgnoreCase(name, value, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableExists(string name) {
        if (orActive) {
            currentOrQueryObject.variableExists(name, false);
        } else {
            this.variableExists(name, false);
        }
        return this;
    }

    @Override
    public TaskQuery processVariableNotExists(string name) {
        if (orActive) {
            currentOrQueryObject.variableNotExists(name, false);
        } else {
            this.variableNotExists(name, false);
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionKey(string processDefinitionKey) {
        if (orActive) {
            currentOrQueryObject.processDefinitionKey = processDefinitionKey;
        } else {
            this.processDefinitionKey = processDefinitionKey;
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionKeyLike(string processDefinitionKeyLike) {
        if (orActive) {
            currentOrQueryObject.processDefinitionKeyLike = processDefinitionKeyLike;
        } else {
            this.processDefinitionKeyLike = processDefinitionKeyLike;
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionKeyLikeIgnoreCase(string processDefinitionKeyLikeIgnoreCase) {
        if (orActive) {
            currentOrQueryObject.processDefinitionKeyLikeIgnoreCase = processDefinitionKeyLikeIgnoreCase.toLowerCase();
        } else {
            this.processDefinitionKeyLikeIgnoreCase = processDefinitionKeyLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionKeyIn(Collection<string> processDefinitionKeys) {
        if (orActive) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this.processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionId(string processDefinitionId) {
        if (orActive) {
            currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this.processDefinitionId = processDefinitionId;
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionName(string processDefinitionName) {
        if (orActive) {
            currentOrQueryObject.processDefinitionName = processDefinitionName;
        } else {
            this.processDefinitionName = processDefinitionName;
        }
        return this;
    }

    @Override
    public TaskQuery processDefinitionNameLike(string processDefinitionNameLike) {
        if (orActive) {
            currentOrQueryObject.processDefinitionNameLike = processDefinitionNameLike;
        } else {
            this.processDefinitionNameLike = processDefinitionNameLike;
        }
        return this;
    }

    @Override
    public TaskQuery processCategoryIn(Collection<string> processCategoryInList) {
        if (processCategoryInList is null) {
            throw new FlowableIllegalArgumentException("Process category list is null");
        }
        if (processCategoryInList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process category list is empty");
        }
        for (string processCategory : processCategoryInList) {
            if (processCategory is null) {
                throw new FlowableIllegalArgumentException("None of the given process categories can be null");
            }
        }

        if (orActive) {
            currentOrQueryObject.processCategoryInList = processCategoryInList;
        } else {
            this.processCategoryInList = processCategoryInList;
        }
        return this;
    }

    @Override
    public TaskQuery processCategoryNotIn(Collection<string> processCategoryNotInList) {
        if (processCategoryNotInList is null) {
            throw new FlowableIllegalArgumentException("Process category list is null");
        }
        if (processCategoryNotInList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process category list is empty");
        }
        for (string processCategory : processCategoryNotInList) {
            if (processCategory is null) {
                throw new FlowableIllegalArgumentException("None of the given process categories can be null");
            }
        }

        if (orActive) {
            currentOrQueryObject.processCategoryNotInList = processCategoryNotInList;
        } else {
            this.processCategoryNotInList = processCategoryNotInList;
        }
        return this;
    }

    @Override
    public TaskQuery deploymentId(string deploymentId) {
        if (orActive) {
            currentOrQueryObject.deploymentId = deploymentId;
        } else {
            this.deploymentId = deploymentId;
        }
        return this;
    }

    @Override
    public TaskQuery deploymentIdIn(Collection<string> deploymentIds) {
        if (orActive) {
            currentOrQueryObject.deploymentIds = deploymentIds;
        } else {
            this.deploymentIds = deploymentIds;
        }
        return this;
    }

    @Override
    public TaskQuery cmmnDeploymentId(string cmmnDeploymentId) {
        if (orActive) {
            currentOrQueryObject.cmmnDeploymentId = cmmnDeploymentId;
        } else {
            this.cmmnDeploymentId = cmmnDeploymentId;
        }
        return this;
    }

    @Override
    public TaskQuery cmmnDeploymentIdIn(Collection<string> cmmnDeploymentIds) {
        if (orActive) {
            currentOrQueryObject.cmmnDeploymentIds = cmmnDeploymentIds;
        } else {
            this.cmmnDeploymentIds = cmmnDeploymentIds;
        }
        return this;
    }

    public TaskQuery dueDate(Date dueDate) {
        if (orActive) {
            currentOrQueryObject.dueDate = dueDate;
            currentOrQueryObject.withoutDueDate = false;
        } else {
            this.dueDate = dueDate;
            this.withoutDueDate = false;
        }
        return this;
    }

    @Override
    public TaskQuery taskDueDate(Date dueDate) {
        return dueDate(dueDate);
    }

    public TaskQuery dueBefore(Date dueBefore) {
        if (orActive) {
            currentOrQueryObject.dueBefore = dueBefore;
            currentOrQueryObject.withoutDueDate = false;
        } else {
            this.dueBefore = dueBefore;
            this.withoutDueDate = false;
        }
        return this;
    }

    @Override
    public TaskQuery taskDueBefore(Date dueDate) {
        return dueBefore(dueDate);
    }

    public TaskQuery dueAfter(Date dueAfter) {
        if (orActive) {
            currentOrQueryObject.dueAfter = dueAfter;
            currentOrQueryObject.withoutDueDate = false;
        } else {
            this.dueAfter = dueAfter;
            this.withoutDueDate = false;
        }
        return this;
    }

    @Override
    public TaskQuery taskDueAfter(Date dueDate) {
        return dueAfter(dueDate);
    }

    public TaskQuery withoutDueDate() {
        if (orActive) {
            currentOrQueryObject.withoutDueDate = true;
        } else {
            this.withoutDueDate = true;
        }
        return this;
    }

    @Override
    public TaskQuery withoutTaskDueDate() {
        return withoutDueDate();
    }

    @Override
    public TaskQuery excludeSubtasks() {
        if (orActive) {
            currentOrQueryObject.excludeSubtasks = true;
        } else {
            this.excludeSubtasks = true;
        }
        return this;
    }

    @Override
    public TaskQuery suspended() {
        if (orActive) {
            currentOrQueryObject.suspensionState = SuspensionState.SUSPENDED;
        } else {
            this.suspensionState = SuspensionState.SUSPENDED;
        }
        return this;
    }

    @Override
    public TaskQuery active() {
        if (orActive) {
            currentOrQueryObject.suspensionState = SuspensionState.ACTIVE;
        } else {
            this.suspensionState = SuspensionState.ACTIVE;
        }
        return this;
    }

    @Override
    public TaskQuery locale(string locale) {
        this.locale = locale;
        return this;
    }

    @Override
    public TaskQuery withLocalizationFallback() {
        withLocalizationFallback = true;
        return this;
    }

    @Override
    public TaskQuery includeTaskLocalVariables() {
        this.includeTaskLocalVariables = true;
        return this;
    }

    @Override
    public TaskQuery includeProcessVariables() {
        this.includeProcessVariables = true;
        return this;
    }

    @Override
    public TaskQuery limitTaskVariables(Integer taskVariablesLimit) {
        this.taskVariablesLimit = taskVariablesLimit;
        return this;
    }

    @Override
    public TaskQuery includeIdentityLinks() {
        this.includeIdentityLinks = true;
        return this;
    }
    public Integer getTaskVariablesLimit() {
        return taskVariablesLimit;
    }

    public Collection<string> getCandidateGroups() {
        if (candidateGroup !is null) {
            Collection<string> candidateGroupList = new ArrayList<>(1);
            candidateGroupList.add(candidateGroup);
            return candidateGroupList;

        } else if (candidateGroups !is null) {
            return candidateGroups;

        } else if (candidateUser !is null) {
            if (cachedCandidateGroups is null) {
                cachedCandidateGroups = getGroupsForCandidateUser(candidateUser);
            }
            return cachedCandidateGroups;

        } else if (userIdForCandidateAndAssignee !is null) {
            if (cachedCandidateGroups is null) {
                return getGroupsForCandidateUser(userIdForCandidateAndAssignee);
            }
            return cachedCandidateGroups;
        }
        return null;
    }

    protected Collection<string> getGroupsForCandidateUser(string candidateUser) {
        Collection<string> groupIds = new ArrayList<>();
        IdmEngineConfigurationApi idmEngineConfiguration = CommandContextUtil.getIdmEngineConfiguration();
        if (idmEngineConfiguration !is null) {
            IdmIdentityService idmIdentityService = idmEngineConfiguration.getIdmIdentityService();
            if (idmIdentityService !is null) {
                List<Group> groups = idmIdentityService.createGroupQuery().groupMember(candidateUser).list();
                for (Group group : groups) {
                    groupIds.add(group.getId());
                }
            }
        }
        return groupIds;
    }

    @Override
    protected void ensureVariablesInitialized() {
        VariableTypes types = CommandContextUtil.getVariableServiceConfiguration().getVariableTypes();
        for (QueryVariableValue var : queryVariableValues) {
            var.initialize(types);
        }

        for (TaskQueryImpl orQueryObject : orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    // or query ////////////////////////////////////////////////////////////////

    @Override
    public TaskQuery or() {
        if (orActive) {
            throw new FlowableException("the query is already in an or statement");
        }

        // Create instance of the orQuery
        orActive = true;
        currentOrQueryObject = new TaskQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }

    @Override
    public TaskQuery endOr() {
        if (!orActive) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        orActive = false;
        currentOrQueryObject = null;
        return this;
    }

    // ordering ////////////////////////////////////////////////////////////////

    @Override
    public TaskQuery orderByTaskId() {
        return orderBy(TaskQueryProperty.TASK_ID);
    }

    @Override
    public TaskQuery orderByTaskName() {
        return orderBy(TaskQueryProperty.NAME);
    }

    @Override
    public TaskQuery orderByTaskDescription() {
        return orderBy(TaskQueryProperty.DESCRIPTION);
    }

    @Override
    public TaskQuery orderByTaskPriority() {
        return orderBy(TaskQueryProperty.PRIORITY);
    }

    @Override
    public TaskQuery orderByProcessInstanceId() {
        return orderBy(TaskQueryProperty.PROCESS_INSTANCE_ID);
    }

    @Override
    public TaskQuery orderByExecutionId() {
        return orderBy(TaskQueryProperty.EXECUTION_ID);
    }

    @Override
    public TaskQuery orderByProcessDefinitionId() {
        return orderBy(TaskQueryProperty.PROCESS_DEFINITION_ID);
    }

    @Override
    public TaskQuery orderByTaskAssignee() {
        return orderBy(TaskQueryProperty.ASSIGNEE);
    }

    @Override
    public TaskQuery orderByTaskOwner() {
        return orderBy(TaskQueryProperty.OWNER);
    }

    @Override
    public TaskQuery orderByTaskCreateTime() {
        return orderBy(TaskQueryProperty.CREATE_TIME);
    }

    public TaskQuery orderByDueDate() {
        return orderBy(TaskQueryProperty.DUE_DATE);
    }

    @Override
    public TaskQuery orderByTaskDueDate() {
        return orderByDueDate();
    }

    @Override
    public TaskQuery orderByTaskDefinitionKey() {
        return orderBy(TaskQueryProperty.TASK_DEFINITION_KEY);
    }

    @Override
    public TaskQuery orderByDueDateNullsFirst() {
        return orderBy(TaskQueryProperty.DUE_DATE, NullHandlingOnOrder.NULLS_FIRST);
    }

    @Override
    public TaskQuery orderByDueDateNullsLast() {
        return orderBy(TaskQueryProperty.DUE_DATE, NullHandlingOnOrder.NULLS_LAST);
    }

    @Override
    public TaskQuery orderByTenantId() {
        return orderBy(TaskQueryProperty.TENANT_ID);
    }

    public string getMssqlOrDB2OrderBy() {
        string specialOrderBy = super.getOrderByColumns();
        if (specialOrderBy !is null && specialOrderBy.length() > 0) {
            specialOrderBy = specialOrderBy.replace("RES.", "TEMPRES_");
        }
        return specialOrderBy;
    }

    // results ////////////////////////////////////////////////////////////////

    @Override
    public List<Task> executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        List<Task> tasks = null;
        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration.getTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getTaskQueryInterceptor().beforeTaskQueryExecute(this);
        }

        if (includeTaskLocalVariables || includeProcessVariables || includeIdentityLinks) {
            tasks = CommandContextUtil.getTaskEntityManager(commandContext).findTasksWithRelatedEntitiesByQueryCriteria(this);

            if (taskId !is null) {
                if (includeProcessVariables) {
                    addCachedVariableForQueryById(commandContext, tasks, false);
                } else if (includeTaskLocalVariables) {
                    addCachedVariableForQueryById(commandContext, tasks, true);
                }
            }

        } else {
            tasks = CommandContextUtil.getTaskEntityManager(commandContext).findTasksByQueryCriteria(this);
        }

        if (tasks !is null && taskServiceConfiguration.getInternalTaskLocalizationManager() !is null && taskServiceConfiguration.isEnableLocalization()) {
            for (Task task : tasks) {
                taskServiceConfiguration.getInternalTaskLocalizationManager().localize(task, locale, withLocalizationFallback);
            }
        }

        if (taskServiceConfiguration.getTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getTaskQueryInterceptor().afterTaskQueryExecute(this, tasks);
        }

        return tasks;
    }

    protected void addCachedVariableForQueryById(CommandContext commandContext, List<Task> results, bool local) {
        for (Task task : results) {
            if (Objects.equals(taskId, task.getId())) {

                EntityCache entityCache = commandContext.getSession(EntityCache.class);
                List<VariableInstanceEntity> cachedVariableEntities = entityCache.findInCache(VariableInstanceEntity.class);
                for (VariableInstanceEntity cachedVariableEntity : cachedVariableEntities) {

                    if (local) {
                        if (task.getId().equals(cachedVariableEntity.getTaskId())) {
                            ((TaskEntity) task).getQueryVariables().add(cachedVariableEntity);
                        }
                    } else {
                        if (task.getProcessInstanceId().equals(cachedVariableEntity.getProcessInstanceId())) {
                            ((TaskEntity) task).getQueryVariables().add(cachedVariableEntity);
                        }
                    }
                }

            }
        }
    }

    @Override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();

        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration.getTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getTaskQueryInterceptor().beforeTaskQueryExecute(this);
        }

        return CommandContextUtil.getTaskEntityManager(commandContext).findTaskCountByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////////////////////////

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public Collection<string> getNameList() {
        return nameList;
    }

    public Collection<string> getNameListIgnoreCase() {
        return nameListIgnoreCase;
    }

    public string getAssignee() {
        return assignee;
    }

    public bool getUnassigned() {
        return unassigned;
    }

    public DelegationState getDelegationState() {
        return delegationState;
    }

    public bool getNoDelegationState() {
        return noDelegationState;
    }

    public string getDelegationStateString() {
        return (delegationState !is null ? delegationState.toString() : null);
    }

    public string getCandidateUser() {
        return candidateUser;
    }

    public string getCandidateGroup() {
        return candidateGroup;
    }

    public bool isIgnoreAssigneeValue() {
        return ignoreAssigneeValue;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public Collection<string> getProcessInstanceIds() {
        return processInstanceIds;
    }

    public string getExecutionId() {
        return executionId;
    }

    public string getScopeId() {
        return scopeId;
    }

    public string getSubScopeId() {
        return subScopeId;
    }

    public string getScopeType() {
        return scopeType;
    }

    public string getScopeDefinitionId() {
        return scopeDefinitionId;
    }

    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }

    public string getTaskId() {
        return taskId;
    }
    
    @Override
    public string getId() {
        return taskId;
    }

    public string getDescription() {
        return description;
    }

    public string getDescriptionLike() {
        return descriptionLike;
    }

    public Integer getPriority() {
        return priority;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public Date getCreateTimeBefore() {
        return createTimeBefore;
    }

    public Date getCreateTimeAfter() {
        return createTimeAfter;
    }

    public string getTaskDefinitionId() {
        return taskDefinitionId;
    }

    public string getKey() {
        return key;
    }

    public string getKeyLike() {
        return keyLike;
    }

    public Collection<string> getKeys() {
        return keys;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getProcessDefinitionName() {
        return processDefinitionName;
    }

    public string getProcessInstanceBusinessKey() {
        return processInstanceBusinessKey;
    }

    public string getProcessInstanceIdWithChildren() {
        return processInstanceIdWithChildren;
    }

    public string getCaseInstanceIdWithChildren() {
        return caseInstanceIdWithChildren;
    }

    public bool getExcludeSubtasks() {
        return excludeSubtasks;
    }

    public string getTenantId() {
        return tenantId;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    public string getUserIdForCandidateAndAssignee() {
        return userIdForCandidateAndAssignee;
    }

    public List<TaskQueryImpl> getOrQueryObjects() {
        return orQueryObjects;
    }

    public void setOrQueryObjects(List<TaskQueryImpl> orQueryObjects) {
        this.orQueryObjects = orQueryObjects;
    }

    public Integer getMinPriority() {
        return minPriority;
    }

    public Integer getMaxPriority() {
        return maxPriority;
    }

    public string getAssigneeLike() {
        return assigneeLike;
    }

    public Collection<string> getAssigneeIds() {
        return assigneeIds;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public Collection<string> getInvolvedGroups() {
        return involvedGroups;
    }

    public string getOwner() {
        return owner;
    }

    public string getOwnerLike() {
        return ownerLike;
    }

    public string getCategory() {
        return category;
    }

    public bool isWithFormKey() {
        return withFormKey;
    }

    public string getFormKey() {
        return formKey;
    }

    public string getProcessDefinitionKeyLike() {
        return processDefinitionKeyLike;
    }

    public Collection<string> getProcessDefinitionKeys() {
        return processDefinitionKeys;
    }

    public string getProcessDefinitionNameLike() {
        return processDefinitionNameLike;
    }

    public Collection<string> getProcessCategoryInList() {
        return processCategoryInList;
    }

    public Collection<string> getProcessCategoryNotInList() {
        return processCategoryNotInList;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public Collection<string> getDeploymentIds() {
        return deploymentIds;
    }

    public string getCmmnDeploymentId() {
        return cmmnDeploymentId;
    }

    public Collection<string> getCmmnDeploymentIds() {
        return cmmnDeploymentIds;
    }

    public string getProcessInstanceBusinessKeyLike() {
        return processInstanceBusinessKeyLike;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public Date getDueBefore() {
        return dueBefore;
    }

    public Date getDueAfter() {
        return dueAfter;
    }

    public bool isWithoutDueDate() {
        return withoutDueDate;
    }

    public SuspensionState getSuspensionState() {
        return suspensionState;
    }

    public bool isIncludeTaskLocalVariables() {
        return includeTaskLocalVariables;
    }

    public bool isIncludeProcessVariables() {
        return includeProcessVariables;
    }

    public bool isIncludeIdentityLinks() {
        return includeIdentityLinks;
    }

    public bool isBothCandidateAndAssigned() {
        return bothCandidateAndAssigned;
    }

    public string getNameLikeIgnoreCase() {
        return nameLikeIgnoreCase;
    }

    public string getDescriptionLikeIgnoreCase() {
        return descriptionLikeIgnoreCase;
    }

    public string getAssigneeLikeIgnoreCase() {
        return assigneeLikeIgnoreCase;
    }

    public string getOwnerLikeIgnoreCase() {
        return ownerLikeIgnoreCase;
    }

    public string getProcessInstanceBusinessKeyLikeIgnoreCase() {
        return processInstanceBusinessKeyLikeIgnoreCase;
    }

    public string getProcessDefinitionKeyLikeIgnoreCase() {
        return processDefinitionKeyLikeIgnoreCase;
    }

    public bool isWithoutDeleteReason() {
        return withoutDeleteReason;
    }

    public string getLocale() {
        return locale;
    }

    public bool isOrActive() {
        return orActive;
    }

    @Override
    public List<Task> list() {
        cachedCandidateGroups = null;
        return super.list();
    }

    @Override
    public List<Task> listPage(int firstResult, int maxResults) {
        cachedCandidateGroups = null;
        return super.listPage(firstResult, maxResults);
    }

    @Override
    public long count() {
        cachedCandidateGroups = null;
        return super.count();
    }

}
