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
module flow.engine.impl.ExecutionQueryImpl;

import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Set;
import flow.engine.impl.ExecutionQueryProperty;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.DynamicBpmnConstants;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ExecutionQuery;
import flow.eventsubscription.service.impl.EventSubscriptionQueryValue;
import flow.variable.service.impl.AbstractVariableQueryImpl;
import hunt.Exceptions;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 * @author Frederik Heremans
 * @author Daniel Meyer
 */
class ExecutionQueryImpl : AbstractVariableQueryImpl!(ExecutionQuery, Execution) , ExecutionQuery, QueryCacheValues {

    protected string _processDefinitionId;
    protected string _processDefinitionKey;
    protected string _processDefinitionCategory;
    protected string _processDefinitionName;
    protected int _processDefinitionVersion;
    protected string _processDefinitionEngineVersion;
    protected string _activityId;
    protected string _executionId;
    protected string _parentId;
    protected bool _onlyChildExecutions;
    protected bool _onlySubProcessExecutions;
    protected bool _onlyProcessInstanceExecutions;
    protected string _processInstanceId;
    protected string _rootProcessInstanceId;
    protected List!EventSubscriptionQueryValue eventSubscriptions;

    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string _locale;
    protected bool _withLocalizationFallback;

    protected Date _startedBefore;
    protected Date _startedAfter;
    protected string _startedBy;

    // Not used by end-users, but needed for dynamic ibatis query
    protected string superProcessInstanceId;
    protected string subProcessInstanceId;
    protected bool excludeSubprocesses;
    protected SuspensionState suspensionState;
    protected string businessKey;
    protected string businessKeyLike;
    protected bool includeChildExecutionsWithBusinessKeyQuery;
    protected bool _isActive;
    protected string involvedUser;
    protected Set!string involvedGroups;
    protected Set!string _processDefinitionKeys;
    protected Set!string processDefinitionIds;

    // Not exposed in API, but here for the ProcessInstanceQuery support, since
    // the name lives on the
    // Execution entity/table
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string deploymentId;
    protected List!string deploymentIds;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;

    protected List!ExecutionQueryImpl orQueryObjects ;//= new ArrayList<>();
    protected ExecutionQueryImpl currentOrQueryObject;
    protected bool inOrStatement;

    this() {
        orQueryObjects = new ArrayList!ExecutionQueryImpl;
    }

    this(CommandContext commandContext) {
        super(commandContext);
        orQueryObjects = new ArrayList!ExecutionQueryImpl;
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
        orQueryObjects = new ArrayList!ExecutionQueryImpl;
    }

    public bool isProcessInstancesOnly() {
        return false; // see dynamic query
    }

    override
    public ExecutionQueryImpl processDefinitionId(string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Process definition id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this._processDefinitionId = processDefinitionId;
        }
        return this;
    }

    override
    public ExecutionQueryImpl processDefinitionKey(string processDefinitionKey) {
        if (processDefinitionKey is null) {
            throw new FlowableIllegalArgumentException("Process definition key is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKey = processDefinitionKey;
        } else {
            this._processDefinitionKey = processDefinitionKey;
        }
        return this;
    }

    override
    public ExecutionQuery processDefinitionCategory(string processDefinitionCategory) {
        if (processDefinitionCategory is null) {
            throw new FlowableIllegalArgumentException("Process definition category is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionCategory = processDefinitionCategory;
        } else {
            this._processDefinitionCategory = processDefinitionCategory;
        }
        return this;
    }

    override
    public ExecutionQuery processDefinitionName(string processDefinitionName) {
        if (processDefinitionName is null) {
            throw new FlowableIllegalArgumentException("Process definition name is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionName = processDefinitionName;
        } else {
            this._processDefinitionName = processDefinitionName;
        }
        return this;
    }


    public ExecutionQuery processDefinitionVersion(int processDefinitionVersion) {
        if (inOrStatement) {
            this.currentOrQueryObject._processDefinitionVersion = processDefinitionVersion;
        } else {
            this._processDefinitionVersion = processDefinitionVersion;
        }
        return this;
    }

    override
    public ExecutionQuery processDefinitionEngineVersion(string processDefinitionEngineVersion) {
        if (processDefinitionEngineVersion is null) {
            throw new FlowableIllegalArgumentException("Process definition engine version is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionEngineVersion = processDefinitionEngineVersion;
        } else {
            this._processDefinitionEngineVersion = processDefinitionEngineVersion;
        }
        return this;
    }

    override
    public ExecutionQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("Process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this._processInstanceId = processInstanceId;
        }
        return this;
    }

    override
    public ExecutionQueryImpl rootProcessInstanceId(string rootProcessInstanceId) {
        if (rootProcessInstanceId is null) {
            throw new FlowableIllegalArgumentException("Root process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.rootProcessInstanceId = rootProcessInstanceId;
        } else {
            this._rootProcessInstanceId = rootProcessInstanceId;
        }
        return this;
    }

    override
    public ExecutionQuery processInstanceBusinessKey(string businessKey) {
        if (businessKey is null) {
            throw new FlowableIllegalArgumentException("Business key is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.businessKey = businessKey;
        } else {
            this.businessKey = businessKey;
        }
        return this;
    }

    override
    public ExecutionQuery processInstanceBusinessKey(string processInstanceBusinessKey, bool includeChildExecutions) {
        if (!includeChildExecutions) {
            return this.processInstanceBusinessKey(processInstanceBusinessKey);
        } else {
            if (processInstanceBusinessKey is null) {
                throw new FlowableIllegalArgumentException("Business key is null");
            }

            if (inOrStatement) {
                this.currentOrQueryObject.businessKey = processInstanceBusinessKey;
                this.currentOrQueryObject.includeChildExecutionsWithBusinessKeyQuery = includeChildExecutions;
            } else {
                this.businessKey = processInstanceBusinessKey;
                this.includeChildExecutionsWithBusinessKeyQuery = includeChildExecutions;
            }

            return this;
        }
    }

    override
    public ExecutionQuery processDefinitionKeys(Set!string processDefinitionKeys) {
        if (processDefinitionKeys is null) {
            throw new FlowableIllegalArgumentException("Process definition keys is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this._processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }

    override
    public ExecutionQueryImpl executionId(string executionId) {
        if (executionId is null) {
            throw new FlowableIllegalArgumentException("Execution id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.executionId = executionId;
        } else {
            this._executionId = executionId;
        }
        return this;
    }

    override
    public ExecutionQueryImpl activityId(string activityId) {
        if (inOrStatement) {
            this.currentOrQueryObject.activityId = activityId;
            if (activityId !is null) {
                this.currentOrQueryObject._isActive = true;
            }

        } else {
            this._activityId = activityId;

            if (activityId !is null && activityId.length != 0) {
                this._isActive = true;
            }
        }

        return this;
    }

    override
    public ExecutionQueryImpl parentId(string parentId) {
        if (parentId is null) {
            throw new FlowableIllegalArgumentException("Parent id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.parentId = parentId;
        } else {
            this._parentId = parentId;
        }
        return this;
    }

    override
    public ExecutionQuery onlyChildExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject._onlyChildExecutions = true;
        } else {
            this._onlyChildExecutions = true;
        }
        return this;
    }

    override
    public ExecutionQuery onlySubProcessExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject._onlySubProcessExecutions = true;
        } else {
            this._onlySubProcessExecutions = true;
        }
        return this;
    }

    override
    public ExecutionQuery onlyProcessInstanceExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject._onlyProcessInstanceExecutions = true;
        } else {
            this._onlyProcessInstanceExecutions = true;
        }
        return this;
    }

    override
    public ExecutionQueryImpl executionTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("execution tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }

    override
    public ExecutionQueryImpl executionTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("execution tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }

    override
    public ExecutionQueryImpl executionWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }

        return this;
    }

    override
    public ExecutionQuery executionReferenceId(string referenceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceId = referenceId;
        } else {
            this.referenceId = referenceId;
        }
        return this;
    }

    override
    public ExecutionQuery executionReferenceType(string referenceType) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceType = referenceType;
        } else {
            this.referenceType = referenceType;
        }
        return this;
    }

    public ExecutionQuery signalEventSubscription(string signalName) {
        return eventSubscription("signal", signalName);
    }

    override
    public ExecutionQuery signalEventSubscriptionName(string signalName) {
        return eventSubscription("signal", signalName);
    }

    override
    public ExecutionQuery messageEventSubscriptionName(string messageName) {
        return eventSubscription("message", messageName);
    }

    public ExecutionQuery eventSubscription(string eventType, string eventName) {
        if (eventName is null) {
            throw new FlowableIllegalArgumentException("event name is null");
        }
        if (eventType is null) {
            throw new FlowableIllegalArgumentException("event type is null");
        }

        if (inOrStatement) {
            if (this.currentOrQueryObject.eventSubscriptions is null) {
                this.currentOrQueryObject.eventSubscriptions = new ArrayList!EventSubscriptionQueryValue();
            }
            this.currentOrQueryObject.eventSubscriptions.add(new EventSubscriptionQueryValue(eventName, eventType));

        } else {
            if (eventSubscriptions is null) {
                eventSubscriptions = new ArrayList!EventSubscriptionQueryValue();
            }
            eventSubscriptions.add(new EventSubscriptionQueryValue(eventName, eventType));
        }

        return this;
    }

    override
    public ExecutionQuery processVariableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }

    override
    ExecutionQuery variableValueEquals(string name, Object value, bool localScope)
    {
        return super.variableValueEquals(name,value,localScope);
    }

    override
    ExecutionQuery variableValueEquals(Object value, bool localScope)
    {
        return super.variableValueEquals(value,localScope);
    }



    override
    public ExecutionQuery processVariableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }

    override
    public ExecutionQuery processVariableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }

    override
    ExecutionQuery variableValueNotEquals(string name, Object value, bool localScope)
    {
        return super.variableValueNotEquals(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }

    override
    ExecutionQuery variableValueEqualsIgnoreCase(string name, string value, bool localScope)
    {
        return super.variableValueEqualsIgnoreCase(name, value, localScope);
    }


    override
    public ExecutionQuery processVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        }
    }

    override
    ExecutionQuery variableValueNotEqualsIgnoreCase(string name, string value, bool localScope)
    {
        return super.variableValueNotEqualsIgnoreCase(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }

    override
    ExecutionQuery variableValueLike(string name, string value, bool localScope)
    {
          return super.variableValueLike(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }

    override
    ExecutionQuery variableValueLikeIgnoreCase(string name, string value, bool localScope)
    {
        return super.variableValueLikeIgnoreCase(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
        } else {
            this.variableValueGreaterThan(name, value, false);
        }
        return this;
    }

    override
    ExecutionQuery variableValueGreaterThan(string name, Object value, bool localScope)
    {
        return super.variableValueGreaterThan(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
        } else {
            this.variableValueGreaterThanOrEqual(name, value, false);
        }
        return this;
    }

    override
    ExecutionQuery variableValueGreaterThanOrEqual(string name, Object value, bool localScope)
    {
        return super.variableValueGreaterThanOrEqual(name, value, localScope);
    }

    override
    public ExecutionQuery processVariableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
        } else {
            this.variableValueLessThan(name, value, false);
        }
        return this;
    }

    override
     ExecutionQuery variableValueLessThan(string name, Object value, bool localScope)
     {
          return super.variableValueLessThan(name, value, localScope);
     }

    override
    public ExecutionQuery processVariableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
        } else {
            this.variableValueLessThanOrEqual(name, value, false);
        }
        return this;
    }

    override
    ExecutionQuery variableValueLessThanOrEqual(string name, Object value, bool localScope)
    {
        return super.variableValueLessThanOrEqual(name, value, localScope);
    }


    override
    public ExecutionQuery processVariableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }

    override
    ExecutionQuery variableExists(string name, bool localScope)
    {
        return super.variableExists(name, localScope);
    }

    override
    public ExecutionQuery processVariableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }

    override
    ExecutionQuery variableNotExists(string name, bool localScope)
    {
        return super.variableNotExists(name, localScope);
    }

    override
    public ExecutionQuery variableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, true);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, true);
        }
    }

    override
    public ExecutionQuery variableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, true);
            return this;
        } else {
            return variableValueEquals(variableValue, true);
        }
    }

    override
    public ExecutionQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, true);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, true);
        }
    }

    override
    public ExecutionQuery variableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, true);
            return this;
        } else {
            return variableValueLike(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, true);
            return this;
        } else {
            return variableValueGreaterThan(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, true);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, true);
            return this;
        } else {
            return variableValueLessThan(name, value, true);
        }
    }

    override
    public ExecutionQuery variableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, true);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, true);
        }
    }

    override
    public ExecutionQuery variableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, true);
            return this;
        } else {
            return variableExists(name, true);
        }
    }

    override
    public ExecutionQuery variableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, true);
            return this;
        } else {
            return variableNotExists(name, true);
        }
    }

    override
    public ExecutionQuery locale(string locale) {
        if (inOrStatement) {
            currentOrQueryObject.locale = locale;
        } else {
            this._locale = locale;
        }

        return this;
    }

    override
    public ExecutionQuery withLocalizationFallback() {
        if (inOrStatement) {
            currentOrQueryObject._withLocalizationFallback = true;
        } else {
            this._withLocalizationFallback = true;
        }

        return this;
    }

    override
    public ExecutionQuery startedBefore(Date beforeTime) {
        if (beforeTime is null) {
            throw new FlowableIllegalArgumentException("before time is null");
        }

        if (inOrStatement) {
            currentOrQueryObject.startedBefore = beforeTime;
        } else {
            this._startedBefore = beforeTime;
        }

        return this;
    }

    override
    public ExecutionQuery startedAfter(Date afterTime) {
        if (afterTime is null) {
            throw new FlowableIllegalArgumentException("after time is null");
        }

        if (inOrStatement) {
            currentOrQueryObject.startedAfter = afterTime;
        } else {
            this._startedAfter = afterTime;
        }

        return this;
    }

    override
    public ExecutionQuery startedBy(string userId) {
        if (userId is null) {
            throw new FlowableIllegalArgumentException("user id is null");
        }

        if (inOrStatement) {
            currentOrQueryObject.startedBy = userId;
        } else {
            this._startedBy = userId;
        }

        return this;
    }

    override
    public ExecutionQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new ExecutionQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }

    override
    public ExecutionQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    // ordering ////////////////////////////////////////////////////

    override
    public ExecutionQueryImpl orderByProcessInstanceId() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_INSTANCE_ID;
        return this;
    }

    override
    public ExecutionQueryImpl orderByProcessDefinitionId() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_DEFINITION_ID;
        return this;
    }

    override
    public ExecutionQueryImpl orderByProcessDefinitionKey() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_DEFINITION_KEY;
        return this;
    }

    override
    public ExecutionQueryImpl orderByTenantId() {
        this.orderProperty = ExecutionQueryProperty.TENANT_ID;
        return this;
    }

    // results ////////////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getExecutionQueryInterceptor() !is null) {
            processEngineConfiguration.getExecutionQueryInterceptor().beforeExecutionQueryExecute(this);
        }

        return CommandContextUtil.getExecutionEntityManager(commandContext).findExecutionCountByQueryCriteria(this);
    }

    override
    public List!Execution executeList(CommandContext commandContext) {
        ensureVariablesInitialized();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getExecutionQueryInterceptor() !is null) {
            processEngineConfiguration.getExecutionQueryInterceptor().beforeExecutionQueryExecute(this);
        }

        auto executions = CommandContextUtil.getExecutionEntityManager(commandContext).findExecutionsByQueryCriteria(this);

        if (processEngineConfiguration.getPerformanceSettings().isEnableLocalization()) {
            foreach (ExecutionEntity execution ; cast(List!ExecutionEntity) executions) {
                string activityId = null;
                if (execution.getId() == (execution.getProcessInstanceId())) {
                    if (execution.getProcessDefinitionId() !is null && execution.getProcessDefinitionId().length != 0) {
                        ProcessDefinition processDefinition = processEngineConfiguration
                                .getDeploymentManager()
                                .findDeployedProcessDefinitionById(execution.getProcessDefinitionId());
                        activityId = processDefinition.getKey();
                    }

                } else {
                    activityId = execution.getActivityId();
                }

                if (activityId !is null) {
                    localize(execution, activityId);
                }
            }
        }

        if (processEngineConfiguration.getExecutionQueryInterceptor() !is null) {
            processEngineConfiguration.getExecutionQueryInterceptor().afterExecutionQueryExecute(this, cast(List!Execution) executions);
        }

        return cast(List!Execution) executions;
    }

    protected void localize(Execution execution, string activityId) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        executionEntity.setLocalizedName(null);
        executionEntity.setLocalizedDescription(null);

        string processDefinitionId = executionEntity.getProcessDefinitionId();
        if (_locale !is null && processDefinitionId !is null) {
            implementationMissing(false);
            //ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, activityId, processDefinitionId, withLocalizationFallback);
            //if (languageNode !is null) {
            //    JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
            //    if (languageNameNode !is null && !languageNameNode.isNull()) {
            //        executionEntity.setLocalizedName(languageNameNode.asText());
            //    }
            //
            //    JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
            //    if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
            //        executionEntity.setLocalizedDescription(languageDescriptionNode.asText());
            //    }
            //}
        }
    }

    override
    protected void ensureVariablesInitialized() {
        super.ensureVariablesInitialized();

        foreach (ExecutionQueryImpl orQueryObject ; orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    // getters ////////////////////////////////////////////////////

    public bool getOnlyProcessInstances() {
        return false;
    }

    public string getProcessDefinitionKey() {
        return _processDefinitionKey;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public string getProcessDefinitionCategory() {
        return _processDefinitionCategory;
    }

    public string getProcessDefinitionName() {
        return _processDefinitionName;
    }

    public int getProcessDefinitionVersion() {
        return _processDefinitionVersion;
    }

    public string getProcessDefinitionEngineVersion() {
        return _processDefinitionEngineVersion;
    }

    public string getActivityId() {
        return _activityId;
    }

    public string getProcessInstanceId() {
        return _processInstanceId;
    }

    public string getRootProcessInstanceId() {
        return _rootProcessInstanceId;
    }

    public string getProcessInstanceIds() {
        return null;
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public string getBusinessKeyLike() {
        return businessKeyLike;
    }

    public string getExecutionId() {
        return _executionId;
    }

    override
    public string getId() {
        return _executionId;
    }

    public string getSuperProcessInstanceId() {
        return superProcessInstanceId;
    }

    public string getSubProcessInstanceId() {
        return subProcessInstanceId;
    }

    public bool isExcludeSubprocesses() {
        return excludeSubprocesses;
    }

    public SuspensionState getSuspensionState() {
        return suspensionState;
    }

    public void setSuspensionState(SuspensionState suspensionState) {
        this.suspensionState = suspensionState;
    }

    public List!EventSubscriptionQueryValue getEventSubscriptions() {
        return eventSubscriptions;
    }

    public bool isIncludeChildExecutionsWithBusinessKeyQuery() {
        return includeChildExecutionsWithBusinessKeyQuery;
    }

    public void setEventSubscriptions(List!EventSubscriptionQueryValue eventSubscriptions) {
        this.eventSubscriptions = eventSubscriptions;
    }

    public bool isActive() {
        return _isActive;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public void setInvolvedUser(string involvedUser) {
        this.involvedUser = involvedUser;
    }

    public Set!string getInvolvedGroups() {
        return involvedGroups;
    }

    public void setInvolvedGroups(Set!string involvedGroups) {
        this.involvedGroups = involvedGroups;
    }

    public Set!string getProcessDefinitionIds() {
        return processDefinitionIds;
    }

    public Set!string getProcessDefinitionKeys() {
        return _processDefinitionKeys;
    }

    public string getParentId() {
        return _parentId;
    }

    public bool isOnlyChildExecutions() {
        return _onlyChildExecutions;
    }

    public bool isOnlySubProcessExecutions() {
        return _onlySubProcessExecutions;
    }

    public bool isOnlyProcessInstanceExecutions() {
        return _onlyProcessInstanceExecutions;
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

    public string getReferenceId() {
        return referenceId;
    }

    public string getReferenceType() {
        return referenceType;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public void setName(string name) {
        this.name = name;
    }

    public void setNameLike(string nameLike) {
        this.nameLike = nameLike;
    }

    public string getNameLikeIgnoreCase() {
        return nameLikeIgnoreCase;
    }

    public void setNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        this.nameLikeIgnoreCase = nameLikeIgnoreCase;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    public List!string getDeploymentIds() {
        return deploymentIds;
    }

    public void setDeploymentIds(List!string deploymentIds) {
        this.deploymentIds = deploymentIds;
    }

    public Date getStartedBefore() {
        return _startedBefore;
    }

    public void setStartedBefore(Date startedBefore) {
        this.startedBefore = startedBefore;
    }

    public Date getStartedAfter() {
        return _startedAfter;
    }

    public void setStartedAfter(Date startedAfter) {
        this._startedAfter = startedAfter;
    }

    public string getStartedBy() {
        return _startedBy;
    }

    public void setStartedBy(string startedBy) {
        this._startedBy = startedBy;
    }


}
