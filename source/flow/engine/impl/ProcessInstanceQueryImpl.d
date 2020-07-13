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
module flow.engine.impl.ProcessInstanceQueryImpl;


import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.ProcessInstance;
import flow.engine.runtime.ProcessInstanceQuery;
import flow.eventsubscription.service.impl.EventSubscriptionQueryValue;
import flow.variable.service.impl.AbstractVariableQueryImpl;
import std.uni : toLower;
import std.uni : toUpper;
import flow.engine.impl.ProcessInstanceQueryProperty;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Frederik Heremans
 * @author Falko Menge
 * @author Daniel Meyer
 */
class ProcessInstanceQueryImpl : AbstractVariableQueryImpl!(ProcessInstanceQuery, ProcessInstance) ,
        ProcessInstanceQuery, QueryCacheValues {

    protected string executionId;
    protected string businessKey;
    protected string businessKeyLike;
    protected bool includeChildExecutionsWithBusinessKeyQuery;
    protected string _processDefinitionId;
    protected Set!string _processDefinitionIds;
    protected string _processDefinitionCategory;
    protected string _processDefinitionName;
    protected int _processDefinitionVersion;
    protected Set!string _processInstanceIds;
    protected string _processDefinitionKey;
    protected Set!string _processDefinitionKeys;
    protected string _processDefinitionEngineVersion;
    protected string _deploymentId;
    protected List!string deploymentIds;
    protected string _superProcessInstanceId;
    protected string _subProcessInstanceId;
    protected bool _excludeSubprocesses;
    protected string _involvedUser;
    protected Set!string _involvedGroups;
    protected SuspensionState suspensionState;
    protected bool _includeProcessVariables;
    protected int processInstanceVariablesLimit;
    protected bool _withJobException;
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string _locale;
    protected bool _withLocalizationFallback;

    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;

    protected List!ProcessInstanceQueryImpl orQueryObjects ;//= new ArrayList<>();
    protected ProcessInstanceQueryImpl currentOrQueryObject;
    protected bool inOrStatement;

    protected Date _startedBefore;
    protected Date _startedAfter;
    protected string _startedBy;

    // Unused, see dynamic query
    protected string activityId;
    protected List!EventSubscriptionQueryValue eventSubscriptions;
    protected bool onlyChildExecutions;
    protected bool onlyProcessInstanceExecutions;
    protected bool onlySubProcessExecutions;
    protected string rootProcessInstanceId;

    this() {
        orQueryObjects = new ArrayList!ProcessInstanceQueryImpl;
    }

    this(CommandContext commandContext) {
        super(commandContext);
        orQueryObjects = new ArrayList!ProcessInstanceQueryImpl;
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
        orQueryObjects = new ArrayList!ProcessInstanceQueryImpl;
    }


    public ProcessInstanceQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId is null) {
            throw new FlowableIllegalArgumentException("Process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.executionId = processInstanceId;
        } else {
            this.executionId = processInstanceId;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceIds(Set!string processInstanceIds) {
        if (processInstanceIds is null) {
            throw new FlowableIllegalArgumentException("Set of process instance ids is null");
        }
        if (processInstanceIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process instance ids is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceIds = processInstanceIds;
        } else {
            this._processInstanceIds = processInstanceIds;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceBusinessKey(string businessKey) {
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


    public ProcessInstanceQuery processInstanceBusinessKey(string businessKey, string processDefinitionKey) {
        if (businessKey is null) {
            throw new FlowableIllegalArgumentException("Business key is null");
        }
        if (inOrStatement) {
            throw new FlowableIllegalArgumentException("This method is not supported in an OR statement");
        }

        this.businessKey = businessKey;
        this._processDefinitionKey = processDefinitionKey;
        return this;
    }


    public ProcessInstanceQuery processInstanceBusinessKeyLike(string businessKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.businessKeyLike = businessKeyLike;
        } else {
            this.businessKeyLike = businessKeyLike;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceTenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("process instance tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceTenantIdLike(string tenantIdLike) {
        if (tenantIdLike is null) {
            throw new FlowableIllegalArgumentException("process instance tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        return this;
    }


    public ProcessInstanceQuery processDefinitionCategory(string processDefinitionCategory) {
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


    public ProcessInstanceQuery processDefinitionName(string processDefinitionName) {
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


    public ProcessInstanceQuery processDefinitionVersion(int processDefinitionVersion) {

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionVersion = processDefinitionVersion;
        } else {
            this._processDefinitionVersion = processDefinitionVersion;
        }
        return this;
    }


    public ProcessInstanceQueryImpl processDefinitionId(string processDefinitionId) {
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


    public ProcessInstanceQuery processDefinitionIds(Set!string processDefinitionIds) {
        if (processDefinitionIds is null) {
            throw new FlowableIllegalArgumentException("Set of process definition ids is null");
        }
        if (processDefinitionIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process definition ids is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionIds = processDefinitionIds;
        } else {
            this._processDefinitionIds = processDefinitionIds;
        }
        return this;
    }


    public ProcessInstanceQueryImpl processDefinitionKey(string processDefinitionKey) {
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


    public ProcessInstanceQuery processDefinitionKeys(Set!string processDefinitionKeys) {
        if (processDefinitionKeys is null) {
            throw new FlowableIllegalArgumentException("Set of process definition keys is null");
        }
        if (processDefinitionKeys.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process definition keys is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this._processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }


    public ProcessInstanceQuery processDefinitionEngineVersion(string processDefinitionEngineVersion) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionEngineVersion = processDefinitionEngineVersion;
        } else {
            this._processDefinitionEngineVersion = processDefinitionEngineVersion;
        }
        return this;
    }


    public ProcessInstanceQueryImpl deploymentId(string deploymentId) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentId = deploymentId;
        } else {
            this._deploymentId = deploymentId;
        }
        return this;
    }


    public ProcessInstanceQueryImpl deploymentIdIn(List!string deploymentIds) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentIds = deploymentIds;
        } else {
            this.deploymentIds = deploymentIds;
        }
        return this;
    }


    public ProcessInstanceQuery superProcessInstanceId(string superProcessInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.superProcessInstanceId = superProcessInstanceId;
        } else {
            this._superProcessInstanceId = superProcessInstanceId;
        }
        return this;
    }


    public ProcessInstanceQuery subProcessInstanceId(string subProcessInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.subProcessInstanceId = subProcessInstanceId;
        } else {
            this._subProcessInstanceId = subProcessInstanceId;
        }
        return this;
    }


    public ProcessInstanceQuery excludeSubprocesses(bool excludeSubprocesses) {
        if (inOrStatement) {
            this.currentOrQueryObject.excludeSubprocesses = excludeSubprocesses;
        } else {
            this._excludeSubprocesses = excludeSubprocesses;
        }
        return this;
    }


    public ProcessInstanceQuery involvedUser(string involvedUser) {
        if (involvedUser is null) {
            throw new FlowableIllegalArgumentException("Involved user is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.involvedUser = involvedUser;
        } else {
            this._involvedUser = involvedUser;
        }
        return this;
    }


    public ProcessInstanceQuery involvedGroups(Set!string involvedGroups) {
        if (involvedGroups is null) {
            throw new FlowableIllegalArgumentException("Involved groups are null");
        }
        if (involvedGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("Involved groups are empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.involvedGroups = involvedGroups;
        } else {
            this._involvedGroups = involvedGroups;
        }
        return this;
    }


    public ProcessInstanceQuery active() {
        if (inOrStatement) {
            this.currentOrQueryObject.suspensionState = ACTIVE;
        } else {
            this.suspensionState = ACTIVE;
        }
        return this;
    }


    public ProcessInstanceQuery suspended() {
        if (inOrStatement) {
            this.currentOrQueryObject.suspensionState = SUSPENDED;
        } else {
            this.suspensionState = SUSPENDED;
        }
        return this;
    }


    public ProcessInstanceQuery includeProcessVariables() {
        this._includeProcessVariables = true;
        return this;
    }


    public ProcessInstanceQuery limitProcessInstanceVariables(int processInstanceVariablesLimit) {
        this.processInstanceVariablesLimit = processInstanceVariablesLimit;
        return this;
    }

    public int getProcessInstanceVariablesLimit() {
        return processInstanceVariablesLimit;
    }


    public ProcessInstanceQuery withJobException() {
        this._withJobException = true;
        return this;
    }


    public ProcessInstanceQuery processInstanceName(string name) {
        if (inOrStatement) {
            this.currentOrQueryObject.name = name;
        } else {
            this.name = name;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceNameLike(string nameLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLike = nameLike;
        } else {
            this.nameLike = nameLike;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLikeIgnoreCase = nameLikeIgnoreCase.toLower;
        } else {
            this.nameLikeIgnoreCase = nameLikeIgnoreCase.toLower;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceCallbackId(string callbackId) {
        if (inOrStatement) {
            this.currentOrQueryObject.callbackId = callbackId;
        } else {
            this.callbackId = callbackId;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceCallbackType(string callbackType) {
        if (inOrStatement) {
            this.currentOrQueryObject.callbackType = callbackType;
        } else {
            this.callbackType = callbackType;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceReferenceId(string referenceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceId = referenceId;
        } else {
            this.referenceId = referenceId;
        }
        return this;
    }


    public ProcessInstanceQuery processInstanceReferenceType(string referenceType) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceType = referenceType;
        } else {
            this.referenceType = referenceType;
        }
        return this;
    }


    public ProcessInstanceQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new ProcessInstanceQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }


    public ProcessInstanceQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    override
    public ProcessInstanceQuery variableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }

    override
    ProcessInstanceQuery variableValueEquals(string name, Object value, bool localScope)
    {
          return super.variableValueEquals(name, value, localScope);
    }


    override
    public ProcessInstanceQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }

    override
    ProcessInstanceQuery variableValueNotEquals(string name, Object value, bool localScope)
    {
        return super.variableValueNotEquals(name, value, localScope);
    }


    override
    public ProcessInstanceQuery variableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }

    override
    ProcessInstanceQuery variableValueEquals(Object value, bool localScope)
    {
        return super.variableValueEquals(value, localScope);
    }

    override
    public ProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value, bool localScope)
    {
        return super.variableValueEqualsIgnoreCase(name, value, localScope);
    }

    override
    public ProcessInstanceQuery variableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueNotEqualsIgnoreCase(string name, string value, bool localScope)
    {
          return super.variableValueNotEqualsIgnoreCase(name, value, localScope);
    }

    override
    public ProcessInstanceQuery variableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
            return this;
        } else {
            return variableValueGreaterThan(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueGreaterThan(string name, Object value, bool localScope)
    {
        return super.variableValueGreaterThan(name, value, localScope);
    }


    override
    public ProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value, bool localScope)
    {
          return super.variableValueGreaterThanOrEqual(name, value, localScope);
    }

    override
    public ProcessInstanceQuery variableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
            return this;
        } else {
            return variableValueLessThan(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueLessThan(string name, Object value, bool localScope)
    {
        return super.variableValueLessThan(name, value, localScope);
    }



    override
    public ProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value, bool localScope)
    {
        return super.variableValueLessThanOrEqual(name, value, localScope);
    }


    override
    public ProcessInstanceQuery variableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueLike(string name, string value, bool localScope)
    {
        return super.variableValueLike(name, value, localScope);
    }




    override
    public ProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }

    override
    ProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value, bool localScope)
    {
        return super.variableValueLikeIgnoreCase(name, value ,localScope);
    }

    override
    public ProcessInstanceQuery variableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }

    override
    ProcessInstanceQuery variableExists(string name, bool localScope)
    {
          return super.variableExists(name, localScope);
    }

    override
    public ProcessInstanceQuery variableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }

   override
    ProcessInstanceQuery variableNotExists(string name, bool localScope)
    {
        return super.variableNotExists(name,localScope);
    }


    public ProcessInstanceQuery locale(string locale) {
        this._locale = locale;
        return this;
    }


    public ProcessInstanceQuery withLocalizationFallback() {
        _withLocalizationFallback = true;
        return this;
    }


    public ProcessInstanceQuery startedBefore(Date beforeTime) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBefore = beforeTime;
        } else {
            this._startedBefore = beforeTime;
        }
        return this;
    }


    public ProcessInstanceQuery startedAfter(Date afterTime) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedAfter = afterTime;
        } else {
            this._startedAfter = afterTime;
        }
        return this;
    }


    public ProcessInstanceQuery startedBy(string userId) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBy = userId;
        } else {
            this._startedBy = userId;
        }
        return this;
    }


    public ProcessInstanceQuery orderByProcessInstanceId() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_INSTANCE_ID;
        return this;
    }


    public ProcessInstanceQuery orderByProcessDefinitionId() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_DEFINITION_ID;
        return this;
    }


    public ProcessInstanceQuery orderByProcessDefinitionKey() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_DEFINITION_KEY;
        return this;
    }


    public ProcessInstanceQuery orderByStartTime() {
        return orderBy(ProcessInstanceQueryProperty.PROCESS_START_TIME);
    }


    public ProcessInstanceQuery orderByTenantId() {
        this.orderProperty = ProcessInstanceQueryProperty.TENANT_ID;
        return this;
    }

    public string getMssqlOrDB2OrderBy() {
        implementationMissing(false);
        return "";
        //string specialOrderBy = super.getOrderByColumns();
        //if (specialOrderBy !is null && specialOrderBy.length() > 0) {
        //    specialOrderBy = specialOrderBy.replace("RES.", "TEMPRES_");
        //    specialOrderBy = specialOrderBy.replace("ProcessDefinitionKey", "TEMPP_KEY_");
        //    specialOrderBy = specialOrderBy.replace("ProcessDefinitionId", "TEMPP_ID_");
        //}
        //return specialOrderBy;
    }

    // results /////////////////////////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().beforeProcessInstanceQueryExecute(this);
        }

        return CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceCountByQueryCriteria(this);
    }

    override
    public List!ProcessInstance executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        List!ProcessInstance processInstances = null;

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().beforeProcessInstanceQueryExecute(this);
        }

        if (_includeProcessVariables) {
            processInstances = CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceAndVariablesByQueryCriteria(this);
        } else {
            processInstances = CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceByQueryCriteria(this);
        }

        if (processEngineConfiguration.getPerformanceSettings().isEnableLocalization() && processEngineConfiguration.getInternalProcessLocalizationManager() !is null) {
            foreach (ProcessInstance processInstance ; processInstances) {
                processEngineConfiguration.getInternalProcessLocalizationManager().localize(processInstance, _locale, _withLocalizationFallback);
            }
        }

        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().afterProcessInstanceQueryExecute(this, processInstances);
        }

        return processInstances;
    }

    override
    protected void ensureVariablesInitialized() {
        super.ensureVariablesInitialized();

        foreach (ProcessInstanceQueryImpl orQueryObject ; orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    // getters /////////////////////////////////////////////////////////////////

    public bool getOnlyProcessInstances() {
        return true; // See dynamic query in runtime.mapping.xml
    }

    public string getProcessInstanceId() {
        return executionId;
    }


    public string getId() {
        return executionId;
    }

    public string getRootProcessInstanceId() {
        return rootProcessInstanceId;
    }

    public Set!string getProcessInstanceIds() {
        return _processInstanceIds;
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public string getBusinessKeyLike() {
        return businessKeyLike;
    }

    public bool isIncludeChildExecutionsWithBusinessKeyQuery() {
        return includeChildExecutionsWithBusinessKeyQuery;
    }

    public string getProcessDefinitionId() {
        return _processDefinitionId;
    }

    public Set!string getProcessDefinitionIds() {
        return _processDefinitionIds;
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

    public string getProcessDefinitionKey() {
        return _processDefinitionKey;
    }

    public Set!string getProcessDefinitionKeys() {
        return _processDefinitionKeys;
    }

    public string getProcessDefinitionEngineVersion() {
        return _processDefinitionEngineVersion;
    }

    public string getActivityId() {
        return null; // Unused, see dynamic query
    }

    public string getSuperProcessInstanceId() {
        return _superProcessInstanceId;
    }

    public string getSubProcessInstanceId() {
        return _subProcessInstanceId;
    }

    public bool isExcludeSubprocesses() {
        return _excludeSubprocesses;
    }

    public string getInvolvedUser() {
        return _involvedUser;
    }

    public Set!string getInvolvedGroups() {
        return _involvedGroups;
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

    public void setEventSubscriptions(List!EventSubscriptionQueryValue eventSubscriptions) {
        this.eventSubscriptions = eventSubscriptions;
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

    public string getExecutionId() {
        return executionId;
    }

    public string getDeploymentId() {
        return _deploymentId;
    }

    public List!string getDeploymentIds() {
        return deploymentIds;
    }

    public bool isIncludeProcessVariables() {
        return _includeProcessVariables;
    }

    public bool iswithException() {
        return _withJobException;
    }

    public string getNameLikeIgnoreCase() {
        return nameLikeIgnoreCase;
    }

    public string getCallbackId() {
        return callbackId;
    }

    public string getCallbackType() {
        return callbackType;
    }

    public string getReferenceId() {
        return referenceId;
    }

    public string getReferenceType() {
        return referenceType;
    }

    public List!ProcessInstanceQueryImpl getOrQueryObjects() {
        return orQueryObjects;
    }

    /**
     * Methods needed for ibatis because of re-use of query-xml for executions. ExecutionQuery contains a parentId property.
     */

    public string getParentId() {
        return null;
    }

    public bool isOnlyChildExecutions() {
        return onlyChildExecutions;
    }

    public bool isOnlyProcessInstanceExecutions() {
        return onlyProcessInstanceExecutions;
    }

    public bool isOnlySubProcessExecutions() {
        return onlySubProcessExecutions;
    }

    public Date getStartedBefore() {
        return _startedBefore;
    }

    public void setStartedBefore(Date startedBefore) {
        this._startedBefore = startedBefore;
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
