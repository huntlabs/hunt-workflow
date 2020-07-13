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

module flow.task.service.impl.HistoricTaskInstanceQueryImpl;

import flow.common.api.query.Query;
import std.uni;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
//import flow.common.persistence.cache.EntityCache;
import flow.idm.api.Group;
import flow.idm.api.IdmIdentityService;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.api.history.HistoricTaskInstanceQuery;
import flow.task.service.TaskServiceConfiguration;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.task.service.impl.util.CommandContextUtil;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.impl.AbstractVariableQueryImpl;
import flow.variable.service.impl.QueryVariableValue;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.task.service.impl.HistoricTaskInstanceQueryProperty;
import hunt.Exceptions;
import std.string;



/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricTaskInstanceQueryImpl : AbstractVariableQueryImpl!(HistoricTaskInstanceQuery, HistoricTaskInstance)
        , HistoricTaskInstanceQuery, QueryCacheValues {

    protected string _taskDefinitionId;
    protected string _processDefinitionId;
    protected string _processDefinitionKey;
    protected string _processDefinitionKeyLike;
    protected string _processDefinitionKeyLikeIgnoreCase;
    protected Collection!string processDefinitionKeys;
    protected string _processDefinitionName;
    protected string _processDefinitionNameLike;
    protected Collection!string processCategoryInList;
    protected Collection!string processCategoryNotInList;
    protected string _deploymentId;
    protected Collection!string deploymentIds;
    protected string _cmmnDeploymentId;
    protected Collection!string cmmnDeploymentIds;
    protected string _processInstanceId;
    protected Collection!string processInstanceIds;
    protected string _processInstanceBusinessKey;
    protected string _processInstanceBusinessKeyLike;
    protected string _processInstanceBusinessKeyLikeIgnoreCase;
    protected string _executionId;
    protected string _scopeId;
    protected string _subScopeId;
    protected string _scopeType;
    protected string _scopeDefinitionId;
    protected string _propagatedStageInstanceId;
    protected string _processInstanceIdWithChildren;
    protected string _caseInstanceIdWithChildren;
    protected string _taskId;
    protected string _taskName;
    protected string _taskNameLike;
    protected string _taskNameLikeIgnoreCase;
    protected Collection!string taskNameList;
    protected Collection!string taskNameListIgnoreCase;
    protected string _taskParentTaskId;
    protected string _taskDescription;
    protected string _taskDescriptionLike;
    protected string _taskDescriptionLikeIgnoreCase;
    protected string _taskDeleteReason;
    protected string _taskDeleteReasonLike;
    protected string _taskOwner;
    protected string _taskOwnerLike;
    protected string _taskOwnerLikeIgnoreCase;
    protected string _taskAssignee;
    protected string _taskAssigneeLike;
    protected string _taskAssigneeLikeIgnoreCase;
    protected Collection!string _taskAssigneeIds;
    protected string _taskDefinitionKey;
    protected string _taskDefinitionKeyLike;
    protected Collection!string _taskDefinitionKeys;
    protected string candidateUser;
    protected string candidateGroup;
    private Collection!string candidateGroups;
    protected string involvedUser;
    protected Collection!string involvedGroups;
    protected bool _ignoreAssigneeValue;
    protected int _taskPriority;
    protected int _taskMinPriority;
    protected int _taskMaxPriority;
    protected bool _finished;
    protected bool _unfinished;
    protected bool _processFinished;
    protected bool _processUnfinished;
    protected Date dueDate;
    protected Date dueAfter;
    protected Date dueBefore;
    protected bool withoutDueDate;
    protected Date creationDate;
    protected Date creationAfterDate;
    protected Date creationBeforeDate;
    protected Date completedDate;
    protected Date completedAfterDate;
    protected Date completedBeforeDate;
    protected string category;
    protected bool withFormKey;
    protected string formKey;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected bool withoutDeleteReason;
    protected string _locale;
    protected bool _withLocalizationFallback;
    protected bool _includeTaskLocalVariables;
    protected bool _includeProcessVariables;
    protected int taskVariablesLimit;
    protected bool _includeIdentityLinks;
    protected List!HistoricTaskInstanceQueryImpl orQueryObjects  ;//= new ArrayList<>();
    protected HistoricTaskInstanceQueryImpl currentOrQueryObject;

    protected bool inOrStatement;

    this() {
        orQueryObjects = new ArrayList!HistoricTaskInstanceQueryImpl;
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
        orQueryObjects = new ArrayList!HistoricTaskInstanceQueryImpl;
    }

    this(CommandExecutor commandExecutor, string databaseType) {
        super(commandExecutor);
        this.databaseType = databaseType;
        orQueryObjects = new ArrayList!HistoricTaskInstanceQueryImpl;
    }

    override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();

        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration.getHistoricTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getHistoricTaskQueryInterceptor().beforeHistoricTaskQueryExecute(this);
        }

        return CommandContextUtil.getHistoricTaskInstanceEntityManager(commandContext).findHistoricTaskInstanceCountByQueryCriteria(this);
    }

    override
    public List!HistoricTaskInstance executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        List!HistoricTaskInstance tasks = null;

        TaskServiceConfiguration taskServiceConfiguration = CommandContextUtil.getTaskServiceConfiguration(commandContext);
        if (taskServiceConfiguration.getHistoricTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getHistoricTaskQueryInterceptor().beforeHistoricTaskQueryExecute(this);
        }

        if (_includeTaskLocalVariables || _includeProcessVariables || _includeIdentityLinks) {
            tasks = CommandContextUtil.getHistoricTaskInstanceEntityManager(commandContext).findHistoricTaskInstancesAndRelatedEntitiesByQueryCriteria(this);

            if (_taskId !is null) {
                if (_includeProcessVariables) {
                    addCachedVariableForQueryById(commandContext, tasks, false);
                } else if (_includeTaskLocalVariables) {
                    addCachedVariableForQueryById(commandContext, tasks, true);
                }
            }

        } else {
            tasks = CommandContextUtil.getHistoricTaskInstanceEntityManager(commandContext).findHistoricTaskInstancesByQueryCriteria(this);
        }

        if (tasks !is null && taskServiceConfiguration.getInternalTaskLocalizationManager() !is null && taskServiceConfiguration.isEnableLocalization()) {
            foreach (HistoricTaskInstance task ; tasks) {
                taskServiceConfiguration.getInternalTaskLocalizationManager().localize(task, _locale, _withLocalizationFallback);
            }
        }

        if (taskServiceConfiguration.getHistoricTaskQueryInterceptor() !is null) {
            taskServiceConfiguration.getHistoricTaskQueryInterceptor().afterHistoricTaskQueryExecute(this, tasks);
        }

        return tasks;
    }

    protected void addCachedVariableForQueryById(CommandContext commandContext, List!HistoricTaskInstance results, bool local) {
        implementationMissing(false);
        //foreach (HistoricTaskInstance task ; results) {
        //    if (Objects.equals(taskId, task.getId())) {
        //
        //        EntityCache entityCache = commandContext.getSession(EntityCache.class);
        //        List<HistoricVariableInstanceEntity> cachedVariableEntities = entityCache.findInCache(HistoricVariableInstanceEntity.class);
        //        for (HistoricVariableInstanceEntity cachedVariableEntity : cachedVariableEntities) {
        //
        //            if (local) {
        //                if (task.getId().equals(cachedVariableEntity.getTaskId())) {
        //                    ((HistoricTaskInstanceEntity) task).getQueryVariables().add(cachedVariableEntity);
        //                }
        //            } else {
        //                if (task.getProcessInstanceId().equals(cachedVariableEntity.getProcessInstanceId())) {
        //                    ((HistoricTaskInstanceEntity) task).getQueryVariables().add(cachedVariableEntity);
        //                }
        //            }
        //        }
        //
        //    }
        //}
    }


    public HistoricTaskInstanceQueryImpl processInstanceId(string processInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this._processInstanceId = processInstanceId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl processInstanceIdIn(Collection!string processInstanceIds) {
        if (processInstanceIds is null) {
            throw new FlowableIllegalArgumentException("Process instance id list is null");
        }
        if (processInstanceIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process instance id list is empty");
        }
        foreach (string processInstanceId ; processInstanceIds) {
            if (processInstanceId is null) {
                throw new FlowableIllegalArgumentException("None of the given process instance ids can be null");
            }
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceIds = processInstanceIds;
        } else {
            this.processInstanceIds = processInstanceIds;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl processInstanceBusinessKey(string processInstanceBusinessKey) {
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceBusinessKey = processInstanceBusinessKey;
        } else {
            this._processInstanceBusinessKey = processInstanceBusinessKey;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl processInstanceBusinessKeyLike(string processInstanceBusinessKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceBusinessKeyLike = processInstanceBusinessKeyLike;
        } else {
            this._processInstanceBusinessKeyLike = processInstanceBusinessKeyLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processInstanceBusinessKeyLikeIgnoreCase(string processInstanceBusinessKeyLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceBusinessKeyLikeIgnoreCase = processInstanceBusinessKeyLikeIgnoreCase.toLower();
        } else {
            this._processInstanceBusinessKeyLikeIgnoreCase = toLower!string(processInstanceBusinessKeyLikeIgnoreCase);
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl executionId(string executionId) {
        if (inOrStatement) {
            this.currentOrQueryObject.executionId = executionId;
        } else {
            this._executionId = executionId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl caseInstanceId(string caseInstanceId) {
        if (inOrStatement) {
            currentOrQueryObject.scopeId(caseInstanceId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.scopeId(caseInstanceId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl caseDefinitionId(string caseDefinitionId) {
        if (inOrStatement) {
            currentOrQueryObject.scopeDefinitionId(caseDefinitionId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.scopeDefinitionId(caseDefinitionId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl processInstanceIdWithChildren(string processInstanceId) {
        if (inOrStatement) {
            currentOrQueryObject.processInstanceIdWithChildren(processInstanceId);
        } else {
            this._processInstanceIdWithChildren = processInstanceId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl caseInstanceIdWithChildren(string caseInstanceId) {
        if (inOrStatement) {
            currentOrQueryObject.caseInstanceIdWithChildren(caseInstanceId);
        } else {
            this._caseInstanceIdWithChildren = caseInstanceId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl planItemInstanceId(string planItemInstanceId) {
        if (inOrStatement) {
            currentOrQueryObject.subScopeId(planItemInstanceId);
            currentOrQueryObject.scopeType(ScopeTypes.CMMN);
        } else {
            this.subScopeId(planItemInstanceId);
            this.scopeType(ScopeTypes.CMMN);
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl scopeId(string scopeId) {
        if (inOrStatement) {
            currentOrQueryObject.scopeId = scopeId;
        } else {
            this._scopeId = scopeId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl subScopeId(string subScopeId) {
        if (inOrStatement) {
            currentOrQueryObject.subScopeId = subScopeId;
        } else {
            this._subScopeId = subScopeId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl scopeType(string scopeType) {
        if (inOrStatement) {
            currentOrQueryObject.scopeType = scopeType;
        } else {
            this._scopeType = scopeType;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl scopeDefinitionId(string scopeDefinitionId) {
        if (inOrStatement) {
            currentOrQueryObject.scopeDefinitionId = scopeDefinitionId;
        } else {
            this._scopeDefinitionId = scopeDefinitionId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery propagatedStageInstanceId(string propagatedStageInstanceId) {
        if (inOrStatement) {
            currentOrQueryObject.propagatedStageInstanceId = propagatedStageInstanceId;
        } else {
            this._propagatedStageInstanceId = propagatedStageInstanceId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl taskDefinitionId(string taskDefinitionId) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDefinitionId = taskDefinitionId;
        } else {
            this._taskDefinitionId = taskDefinitionId;
        }
        return this;
    }


    public HistoricTaskInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this._processDefinitionId = processDefinitionId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionKey(string processDefinitionKey) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKey = processDefinitionKey;
        } else {
            this._processDefinitionKey = processDefinitionKey;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionKeyLike(string processDefinitionKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeyLike = processDefinitionKeyLike;
        } else {
            this._processDefinitionKeyLike = processDefinitionKeyLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionKeyLikeIgnoreCase(string processDefinitionKeyLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeyLikeIgnoreCase = toLower!string(processDefinitionKeyLikeIgnoreCase);
        } else {
            this._processDefinitionKeyLikeIgnoreCase = processDefinitionKeyLikeIgnoreCase.toLower();
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionKeyIn(Collection!string processDefinitionKeys) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this.processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionName(string processDefinitionName) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionName = processDefinitionName;
        } else {
            this._processDefinitionName = processDefinitionName;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processDefinitionNameLike(string processDefinitionNameLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionNameLike = processDefinitionNameLike;
        } else {
            this._processDefinitionNameLike = processDefinitionNameLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processCategoryIn(Collection!string processCategoryInList) {
        if (processCategoryInList is null) {
            throw new FlowableIllegalArgumentException("Process category list is null");
        }
        if (processCategoryInList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process category list is empty");
        }
        foreach (string processCategory ; processCategoryInList) {
            if (processCategory is null) {
                throw new FlowableIllegalArgumentException("None of the given process categories can be null");
            }
        }

        if (inOrStatement) {
            currentOrQueryObject.processCategoryInList = processCategoryInList;
        } else {
            this.processCategoryInList = processCategoryInList;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processCategoryNotIn(Collection!string processCategoryNotInList) {
        if (processCategoryNotInList is null) {
            throw new FlowableIllegalArgumentException("Process category list is null");
        }
        if (processCategoryNotInList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Process category list is empty");
        }
        foreach (string processCategory ;processCategoryNotInList) {
            if (processCategory is null) {
                throw new FlowableIllegalArgumentException("None of the given process categories can be null");
            }
        }

        if (inOrStatement) {
            currentOrQueryObject.processCategoryNotInList = processCategoryNotInList;
        } else {
            this.processCategoryNotInList = processCategoryNotInList;
        }
        return this;
    }


    public HistoricTaskInstanceQuery deploymentId(string deploymentId) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentId = deploymentId;
        } else {
            this._deploymentId = deploymentId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery deploymentIdIn(Collection!string deploymentIds) {
        if (inOrStatement) {
            currentOrQueryObject.deploymentIds = deploymentIds;
        } else {
            this.deploymentIds = deploymentIds;
        }
        return this;
    }


    public HistoricTaskInstanceQuery cmmnDeploymentId(string cmmnDeploymentId) {
        if (inOrStatement) {
            currentOrQueryObject.cmmnDeploymentId = cmmnDeploymentId;
        } else {
            this._cmmnDeploymentId = cmmnDeploymentId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery cmmnDeploymentIdIn(Collection!string cmmnDeploymentIds) {
        if (inOrStatement) {
            currentOrQueryObject.cmmnDeploymentIds = cmmnDeploymentIds;
        } else {
            this.cmmnDeploymentIds = cmmnDeploymentIds;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskId(string taskId) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskId = taskId;
        } else {
            this._taskId = taskId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskName(string taskName) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskName = taskName;
        } else {
            this._taskName = taskName;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskNameIn(Collection!string taskNameList) {
        if (taskNameList is null) {
            throw new FlowableIllegalArgumentException("Task name list is null");
        }
        if (taskNameList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task name list is empty");
        }

        if (_taskName !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and taskName");
        }
        if (_taskNameLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and taskNameLike");
        }
        if (_taskNameLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameIn and taskNameLikeIgnoreCase");
        }

        if (inOrStatement) {
            currentOrQueryObject.taskNameList = taskNameList;
        } else {
            this.taskNameList = taskNameList;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskNameInIgnoreCase(Collection!string taskNameList) {
        if (taskNameList is null) {
            throw new FlowableIllegalArgumentException("Task name list is null");
        }
        if (taskNameList.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task name list is empty");
        }
        foreach (string taskName ; taskNameList) {
            if (taskName is null) {
                throw new FlowableIllegalArgumentException("None of the given task names can be null");
            }
        }

        if (_taskName !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and name");
        }
        if (_taskNameLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and nameLike");
        }
        if (_taskNameLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskNameInIgnoreCase and nameLikeIgnoreCase");
        }

         int nameListSize = taskNameList.size();
         Collection!string caseIgnoredTaskNameList = new ArrayList!string(nameListSize);
        foreach (string taskName ;taskNameList) {
            caseIgnoredTaskNameList.add(toLower!string(taskName));
        }

        if (inOrStatement) {
            this.currentOrQueryObject.taskNameListIgnoreCase = caseIgnoredTaskNameList;
        } else {
            this.taskNameListIgnoreCase = caseIgnoredTaskNameList;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskNameLike(string taskNameLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskNameLike = taskNameLike;
        } else {
            this._taskNameLike = taskNameLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskNameLikeIgnoreCase(string taskNameLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskNameLikeIgnoreCase = taskNameLikeIgnoreCase.toLower();
        } else {
            this._taskNameLikeIgnoreCase = taskNameLikeIgnoreCase.toLower();
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskParentTaskId(string parentTaskId) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskParentTaskId = parentTaskId;
        } else {
            this._taskParentTaskId = parentTaskId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDescription(string taskDescription) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDescription = taskDescription;
        } else {
            this._taskDescription = taskDescription;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDescriptionLike(string taskDescriptionLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDescriptionLike = taskDescriptionLike;
        } else {
            this._taskDescriptionLike = taskDescriptionLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDescriptionLikeIgnoreCase(string taskDescriptionLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDescriptionLikeIgnoreCase = toLower!string(taskDescriptionLikeIgnoreCase);
        } else {
            this._taskDescriptionLikeIgnoreCase = toLower!string(taskDescriptionLikeIgnoreCase);
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDeleteReason(string taskDeleteReason) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDeleteReason = taskDeleteReason;
        } else {
            this._taskDeleteReason = taskDeleteReason;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDeleteReasonLike(string taskDeleteReasonLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDeleteReasonLike = taskDeleteReasonLike;
        } else {
            this._taskDeleteReasonLike = taskDeleteReasonLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskAssignee(string taskAssignee) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskAssignee = taskAssignee;
        } else {
            this._taskAssignee = taskAssignee;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskAssigneeLike(string taskAssigneeLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskAssigneeLike = taskAssigneeLike;
        } else {
            this._taskAssigneeLike = taskAssigneeLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskAssigneeLikeIgnoreCase(string taskAssigneeLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskAssigneeLikeIgnoreCase = toLower!string(taskAssigneeLikeIgnoreCase);
        } else {
            this._taskAssigneeLikeIgnoreCase = toLower!string(taskAssigneeLikeIgnoreCase);
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskAssigneeIds(Collection!string assigneeIds) {
        if (assigneeIds is null) {
            throw new FlowableIllegalArgumentException("Task assignee list is null");
        }
        if (assigneeIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Task assignee list is empty");
        }
        foreach (string assignee ; assigneeIds) {
            if (assignee is null) {
                throw new FlowableIllegalArgumentException("None of the given task assignees can be null");
            }
        }

        if (_taskAssignee !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssignee");
        }
        if (_taskAssigneeLike !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssigneeLike");
        }
        if (_taskAssigneeLikeIgnoreCase !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both taskAssigneeIds and taskAssigneeLikeIgnoreCase");
        }

        if (inOrStatement) {
            currentOrQueryObject.taskAssigneeIds = assigneeIds;
        } else {
            this._taskAssigneeIds = assigneeIds;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskOwner(string taskOwner) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskOwner = taskOwner;
        } else {
            this._taskOwner = taskOwner;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskOwnerLike(string taskOwnerLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskOwnerLike = taskOwnerLike;
        } else {
            this._taskOwnerLike = taskOwnerLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskOwnerLikeIgnoreCase(string taskOwnerLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskOwnerLikeIgnoreCase = toLower!string(taskOwnerLikeIgnoreCase);
        } else {
            this._taskOwnerLikeIgnoreCase = toLower!string(taskOwnerLikeIgnoreCase);
        }
        return this;
    }


    public HistoricTaskInstanceQuery finished() {
        if (inOrStatement) {
            this.currentOrQueryObject._finished = true;
        } else {
            this._finished = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery unfinished() {
        if (inOrStatement) {
            this.currentOrQueryObject._unfinished = true;
        } else {
            this._unfinished = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskVariableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue);
            return this;
        } else {
            return variableValueEquals(variableValue);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value);
            return this;
        } else {
            return variableValueGreaterThan(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value);
            return this;
        } else {
            return variableValueLessThan(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value);
            return this;
        } else {
            return variableValueLike(name, value);
        }
    }


    public HistoricTaskInstanceQuery taskVariableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, true);
        }
    }


    public HistoricTaskInstanceQuery taskVariableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, true);
            return this;
        } else {
            return variableExists(name, true);
        }
    }


    public HistoricTaskInstanceQuery taskVariableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, true);
            return this;
        } else {
            return variableNotExists(name, true);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
            return this;
        } else {
            return variableValueGreaterThan(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
            return this;
        } else {
            return variableValueLessThan(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }


    public HistoricTaskInstanceQuery processVariableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }


    public HistoricTaskInstanceQuery taskDefinitionKey(string taskDefinitionKey) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDefinitionKey = taskDefinitionKey;
        } else {
            this._taskDefinitionKey = taskDefinitionKey;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDefinitionKeyLike(string taskDefinitionKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDefinitionKeyLike = taskDefinitionKeyLike;
        } else {
            this._taskDefinitionKeyLike = taskDefinitionKeyLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDefinitionKeys(Collection!string taskDefinitionKeys) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskDefinitionKeys = taskDefinitionKeys;
        } else {
            this._taskDefinitionKeys = taskDefinitionKeys;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskPriority(int taskPriority) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskPriority = taskPriority;
        } else {
            this._taskPriority = taskPriority;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskMinPriority(int taskMinPriority) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskMinPriority = taskMinPriority;
        } else {
            this._taskMinPriority = taskMinPriority;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskMaxPriority(int taskMaxPriority) {
        if (inOrStatement) {
            this.currentOrQueryObject.taskMaxPriority = taskMaxPriority;
        } else {
            this._taskMaxPriority = taskMaxPriority;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processFinished() {
        if (inOrStatement) {
            this.currentOrQueryObject._processFinished = true;
        } else {
            this._processFinished = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery processUnfinished() {
        if (inOrStatement) {
            this.currentOrQueryObject._processUnfinished = true;
        } else {
            this._processUnfinished = true;
        }
        return this;
    }

    override
    protected void ensureVariablesInitialized() {
        VariableTypes types = CommandContextUtil.getVariableServiceConfiguration().getVariableTypes();
        foreach (QueryVariableValue var ; queryVariableValues) {
            var.initialize(types);
        }

        foreach (HistoricTaskInstanceQueryImpl orQueryObject ; orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }


    public HistoricTaskInstanceQuery taskDueDate(Date dueDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.dueDate = dueDate;
        } else {
            this.dueDate = dueDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDueAfter(Date dueAfter) {
        if (inOrStatement) {
            this.currentOrQueryObject.dueAfter = dueAfter;
        } else {
            this.dueAfter = dueAfter;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskDueBefore(Date dueBefore) {
        if (inOrStatement) {
            this.currentOrQueryObject.dueBefore = dueBefore;
        } else {
            this.dueBefore = dueBefore;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCreatedOn(Date creationDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.creationDate = creationDate;
        } else {
            this.creationDate = creationDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCreatedBefore(Date creationBeforeDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.creationBeforeDate = creationBeforeDate;
        } else {
            this.creationBeforeDate = creationBeforeDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCreatedAfter(Date creationAfterDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.creationAfterDate = creationAfterDate;
        } else {
            this.creationAfterDate = creationAfterDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCompletedOn(Date completedDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.completedDate = completedDate;
        } else {
            this.completedDate = completedDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCompletedBefore(Date completedBeforeDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.completedBeforeDate = completedBeforeDate;
        } else {
            this.completedBeforeDate = completedBeforeDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCompletedAfter(Date completedAfterDate) {
        if (inOrStatement) {
            this.currentOrQueryObject.completedAfterDate = completedAfterDate;
        } else {
            this.completedAfterDate = completedAfterDate;
        }
        return this;
    }


    public HistoricTaskInstanceQuery withoutTaskDueDate() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutDueDate = true;
        } else {
            this.withoutDueDate = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCategory(string category) {
        if (inOrStatement) {
            this.currentOrQueryObject.category = category;
        } else {
            this.category = category;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskWithFormKey() {
        if (inOrStatement) {
            currentOrQueryObject.withFormKey = true;
        } else {
            this.withFormKey = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskFormKey(string formKey) {
        if (formKey is null) {
            throw new FlowableIllegalArgumentException("Task formKey is null");
        }

        if (inOrStatement) {
            currentOrQueryObject.formKey = formKey;
        } else {
            this.formKey = formKey;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCandidateUser(string candidateUser) {
        if (candidateUser is null) {
            throw new FlowableIllegalArgumentException("Candidate user is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.candidateUser = candidateUser;
        } else {
            this.candidateUser = candidateUser;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCandidateGroup(string candidateGroup) {
        if (candidateGroup is null) {
            throw new FlowableIllegalArgumentException("Candidate group is null");
        }

        if (candidateGroups !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both candidateGroup and candidateGroupIn");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.candidateGroup = candidateGroup;
        } else {
            this.candidateGroup = candidateGroup;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskCandidateGroupIn(Collection!string candidateGroups) {
        if (candidateGroups is null) {
            throw new FlowableIllegalArgumentException("Candidate group list is null");
        }

        if (candidateGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("Candidate group list is empty");
        }

        if (candidateGroup !is null) {
            throw new FlowableIllegalArgumentException("Invalid query usage: cannot set both candidateGroupIn and candidateGroup");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.candidateGroups = candidateGroups;
        } else {
            this.candidateGroups = candidateGroups;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskInvolvedUser(string involvedUser) {
        if (involvedUser is null) {
            throw new FlowableIllegalArgumentException("involved user is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.involvedUser = involvedUser;
        } else {
            this.involvedUser = involvedUser;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskInvolvedGroups(Collection!string involvedGroups) {
        if (involvedGroups is null) {
            throw new FlowableIllegalArgumentException("Involved groups are null");
        }
        if (involvedGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("Involved groups are empty");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.involvedGroups = involvedGroups;
        } else {
            this.involvedGroups = involvedGroups;
        }
        return this;
    }


    public HistoricTaskInstanceQuery ignoreAssigneeValue() {
        if (inOrStatement) {
            this.currentOrQueryObject._ignoreAssigneeValue = true;
        } else {
            this._ignoreAssigneeValue = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("task tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("task tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery taskWithoutDeleteReason() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutDeleteReason = true;
        } else {
            this.withoutDeleteReason = true;
        }
        return this;
    }


    public HistoricTaskInstanceQuery locale(string locale) {
        this._locale = locale;
        return this;
    }


    public HistoricTaskInstanceQuery withLocalizationFallback() {
        _withLocalizationFallback = true;
        return this;
    }


    public HistoricTaskInstanceQuery includeTaskLocalVariables() {
        this._includeTaskLocalVariables = true;
        return this;
    }


    public HistoricTaskInstanceQuery includeProcessVariables() {
        this._includeProcessVariables = true;
        return this;
    }


    public HistoricTaskInstanceQuery limitTaskVariables(int taskVariablesLimit) {
        this.taskVariablesLimit = taskVariablesLimit;
        return this;
    }


    public HistoricTaskInstanceQuery includeIdentityLinks() {
        this._includeIdentityLinks = true;
        return this;
    }

    public int getTaskVariablesLimit() {
        return taskVariablesLimit;
    }


    public HistoricTaskInstanceQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new HistoricTaskInstanceQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }


    public HistoricTaskInstanceQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    // ordering
    // /////////////////////////////////////////////////////////////////


    public HistoricTaskInstanceQueryImpl orderByTaskId() {
        orderBy(HistoricTaskInstanceQueryProperty.HISTORIC_TASK_INSTANCE_ID);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByHistoricActivityInstanceId() {
        orderBy(HistoricTaskInstanceQueryProperty.PROCESS_DEFINITION_ID);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByProcessDefinitionId() {
        orderBy(HistoricTaskInstanceQueryProperty.PROCESS_DEFINITION_ID);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByProcessInstanceId() {
        orderBy(HistoricTaskInstanceQueryProperty.PROCESS_INSTANCE_ID);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByExecutionId() {
        orderBy(HistoricTaskInstanceQueryProperty.EXECUTION_ID);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByHistoricTaskInstanceDuration() {
        orderBy(HistoricTaskInstanceQueryProperty.DURATION);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByHistoricTaskInstanceEndTime() {
        orderBy(HistoricTaskInstanceQueryProperty.END);
        return this;
    }

    public HistoricTaskInstanceQueryImpl orderByHistoricActivityInstanceStartTime() {
        orderBy(HistoricTaskInstanceQueryProperty.START);
        return this;
    }


    public HistoricTaskInstanceQuery orderByHistoricTaskInstanceStartTime() {
        orderBy(HistoricTaskInstanceQueryProperty.START);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskCreateTime() {
        return orderByHistoricTaskInstanceStartTime();
    }


    public HistoricTaskInstanceQueryImpl orderByTaskName() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_NAME);
        return this;
    }


    public HistoricTaskInstanceQueryImpl orderByTaskDescription() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_DESCRIPTION);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskAssignee() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_ASSIGNEE);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskOwner() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_OWNER);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskDueDate() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_DUE_DATE);
        return this;
    }


    public HistoricTaskInstanceQuery orderByDueDateNullsFirst() {
        return orderBy(HistoricTaskInstanceQueryProperty.TASK_DUE_DATE, NullHandlingOnOrder.NULLS_FIRST);
    }


    public HistoricTaskInstanceQuery orderByDueDateNullsLast() {
        return orderBy(HistoricTaskInstanceQueryProperty.TASK_DUE_DATE, NullHandlingOnOrder.NULLS_LAST);
    }


    public HistoricTaskInstanceQueryImpl orderByDeleteReason() {
        orderBy(HistoricTaskInstanceQueryProperty.DELETE_REASON);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskDefinitionKey() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_DEFINITION_KEY);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTaskPriority() {
        orderBy(HistoricTaskInstanceQueryProperty.TASK_PRIORITY);
        return this;
    }


    public HistoricTaskInstanceQuery orderByTenantId() {
        orderBy(HistoricTaskInstanceQueryProperty.TENANT_ID_);
        return this;
    }

    override
    protected void checkQueryOk() {
        super.checkQueryOk();
        // In case historic query variables are included, an additional order-by
        // clause should be added
        // to ensure the last value of a variable is used
        if (_includeProcessVariables || _includeTaskLocalVariables) {
            this.orderBy(HistoricTaskInstanceQueryProperty.INCLUDED_VARIABLE_TIME).asc();
        }
    }

    public string getMssqlOrDB2OrderBy() {
        string specialOrderBy = super.getOrderByColumns();
        if (specialOrderBy !is null && specialOrderBy.length > 0) {
            specialOrderBy = specialOrderBy.replace("RES.", "TEMPRES_");
            specialOrderBy = specialOrderBy.replace("VAR.", "TEMPVAR_");
        }
        return specialOrderBy;
    }

    public Collection!string getCandidateGroups() {
        if (candidateGroup !is null) {
            Collection!string candidateGroupList = new ArrayList!string(1);
            candidateGroupList.add(candidateGroup);
            return candidateGroupList;

        } else if (candidateGroups !is null) {
            return candidateGroups;

        } else if (candidateUser !is null) {
            return getGroupsForCandidateUser(candidateUser);
        }
        return null;
    }

    protected Collection!string getGroupsForCandidateUser(string candidateUser) {
        Collection!string groupIds = new ArrayList!string();
        IdmIdentityService idmIdentityService = CommandContextUtil.getTaskServiceConfiguration().getIdmIdentityService();
        if (idmIdentityService !is null) {
            List!Group groups = idmIdentityService.createGroupQuery().groupMember(candidateUser).list();
            foreach (Group group ; groups) {
                groupIds.add(group.getId());
            }
        }
        return groupIds;
    }


    public void dele() {
        implementationMissing(false);
        //if (commandExecutor !is null) {
        //    commandExecutor.execute(context -> {
        //        CommandContextUtil.getHistoricTaskInstanceEntityManager(context).deleteHistoricTaskInstances(this);
        //        return null;
        //    });
        //} else {
        //    CommandContextUtil.getHistoricTaskInstanceEntityManager(Context.getCommandContext()).deleteHistoricTaskInstances(this);
        //}
    }


    public void deleteWithRelatedData() {
        dele();
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public Collection!string getProcessInstanceIds() {
        return processInstanceIds;
    }

    public string getProcessInstanceBusinessKey() {
        return _processInstanceBusinessKey;
    }

    public string getExecutionId() {
        return _executionId;
    }

    public string getScopeId() {
        return _scopeId;
    }

    public string getSubScopeId() {
        return _subScopeId;
    }

    public string getScopeType() {
        return _scopeType;
    }

    public string getScopeDefinitionId() {
        return _scopeDefinitionId;
    }

    public string getPropagatedStageInstanceId() {
        return _propagatedStageInstanceId;
    }

    public string getTaskDefinitionId() {
        return _taskDefinitionId;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getProcessDefinitionKey() {
        return _processDefinitionKey;
    }

    public string getProcessDefinitionKeyLike() {
        return _processDefinitionKeyLike;
    }

    public Collection!string getProcessDefinitionKeys() {
        return processDefinitionKeys;
    }

    public string getProcessDefinitionName() {
        return _processDefinitionName;
    }

    public string getProcessDefinitionNameLike() {
        return _processDefinitionNameLike;
    }

    public Collection!string getProcessCategoryInList() {
        return processCategoryInList;
    }

    public Collection!string getProcessCategoryNotInList() {
        return processCategoryNotInList;
    }

    public string getDeploymentId() {
        return _deploymentId;
    }

    public Collection!string getDeploymentIds() {
        return deploymentIds;
    }

    public string getCmmnDeploymentId() {
        return _cmmnDeploymentId;
    }

    public Collection!string getCmmnDeploymentIds() {
        return cmmnDeploymentIds;
    }

    public string getProcessInstanceBusinessKeyLike() {
        return _processInstanceBusinessKeyLike;
    }

    public string getTaskDefinitionKeyLike() {
        return _taskDefinitionKeyLike;
    }

    public string getProcessInstanceIdWithChildren() {
        return _processInstanceIdWithChildren;
    }

    public string getCaseInstanceIdWithChildren() {
        return _caseInstanceIdWithChildren;
    }

    public int getTaskPriority() {
        return _taskPriority;
    }

    public int getTaskMinPriority() {
        return _taskMinPriority;
    }

    public int getTaskMaxPriority() {
        return _taskMaxPriority;
    }

    public bool isProcessFinished() {
        return _processFinished;
    }

    public bool isProcessUnfinished() {
        return _processUnfinished;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public Date getDueAfter() {
        return dueAfter;
    }

    public Date getDueBefore() {
        return dueBefore;
    }

    public bool isWithoutDueDate() {
        return withoutDueDate;
    }

    public Date getCreationAfterDate() {
        return creationAfterDate;
    }

    public Date getCreationBeforeDate() {
        return creationBeforeDate;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public Date getCompletedAfterDate() {
        return completedAfterDate;
    }

    public Date getCompletedBeforeDate() {
        return completedBeforeDate;
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

    public string getTenantId() {
        return tenantId;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public bool isWithoutTenantId() {
        return withoutTenantId;
    }

    public bool isIncludeTaskLocalVariables() {
        return _includeTaskLocalVariables;
    }

    public bool isIncludeProcessVariables() {
        return _includeProcessVariables;
    }

    public bool isIncludeIdentityLinks() {
        return _includeIdentityLinks;
    }

    public bool isInOrStatement() {
        return inOrStatement;
    }

    public bool isFinished() {
        return _finished;
    }

    public bool isUnfinished() {
        return _unfinished;
    }

    public string getTaskName() {
        return _taskName;
    }

    public string getTaskNameLike() {
        return _taskNameLike;
    }

    public Collection!string getTaskNameList() {
        return taskNameList;
    }

    public Collection!string getTaskNameListIgnoreCase() {
        return taskNameListIgnoreCase;
    }

    public string getTaskDescription() {
        return _taskDescription;
    }

    public string getTaskDescriptionLike() {
        return _taskDescriptionLike;
    }

    public string getTaskDeleteReason() {
        return _taskDeleteReason;
    }

    public string getTaskDeleteReasonLike() {
        return _taskDeleteReasonLike;
    }

    public string getTaskAssignee() {
        return _taskAssignee;
    }

    public string getTaskAssigneeLike() {
        return _taskAssigneeLike;
    }

    public Collection!string getTaskAssigneeIds() {
        return _taskAssigneeIds;
    }

    public string getTaskId() {
        return _taskId;
    }


    public string getId() {
        return _taskId;
    }

    public string getTaskDefinitionKey() {
        return _taskDefinitionKey;
    }

    public string getTaskOwnerLike() {
        return _taskOwnerLike;
    }

    public string getTaskOwner() {
        return _taskOwner;
    }

    public Collection!string getTaskDefinitionKeys() {
        return _taskDefinitionKeys;
    }

    public string getTaskParentTaskId() {
        return _taskParentTaskId;
    }

    public Date getCreationDate() {
        return creationDate;
    }

    public string getCandidateUser() {
        return candidateUser;
    }

    public string getCandidateGroup() {
        return candidateGroup;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public Collection!string getInvolvedGroups() {
        return involvedGroups;
    }

    public bool isIgnoreAssigneeValue() {
        return _ignoreAssigneeValue;
    }

    public string getProcessDefinitionKeyLikeIgnoreCase() {
        return _processDefinitionKeyLikeIgnoreCase;
    }

    public string getProcessInstanceBusinessKeyLikeIgnoreCase() {
        return _processInstanceBusinessKeyLikeIgnoreCase;
    }

    public string getTaskNameLikeIgnoreCase() {
        return _taskNameLikeIgnoreCase;
    }

    public string getTaskDescriptionLikeIgnoreCase() {
        return _taskDescriptionLikeIgnoreCase;
    }

    public string getTaskOwnerLikeIgnoreCase() {
        return _taskOwnerLikeIgnoreCase;
    }

    public string getTaskAssigneeLikeIgnoreCase() {
        return _taskAssigneeLikeIgnoreCase;
    }

    public bool isWithoutDeleteReason() {
        return withoutDeleteReason;
    }

    public string getLocale() {
        return _locale;
    }

    public List!HistoricTaskInstanceQueryImpl getOrQueryObjects() {
        return orQueryObjects;
    }
}
