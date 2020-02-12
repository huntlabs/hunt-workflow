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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

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
import org.flowable.eventsubscription.service.impl.EventSubscriptionQueryValue;
import org.flowable.variable.service.impl.AbstractVariableQueryImpl;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Frederik Heremans
 * @author Falko Menge
 * @author Daniel Meyer
 */
class ProcessInstanceQueryImpl extends AbstractVariableQueryImpl<ProcessInstanceQuery, ProcessInstance> implements
        ProcessInstanceQuery, QueryCacheValues, Serializable {

    private static final long serialVersionUID = 1L;
    protected string executionId;
    protected string businessKey;
    protected string businessKeyLike;
    protected boolean includeChildExecutionsWithBusinessKeyQuery;
    protected string processDefinitionId;
    protected Set<string> processDefinitionIds;
    protected string processDefinitionCategory;
    protected string processDefinitionName;
    protected Integer processDefinitionVersion;
    protected Set<string> processInstanceIds;
    protected string processDefinitionKey;
    protected Set<string> processDefinitionKeys;
    protected string processDefinitionEngineVersion;
    protected string deploymentId;
    protected List<string> deploymentIds;
    protected string superProcessInstanceId;
    protected string subProcessInstanceId;
    protected boolean excludeSubprocesses;
    protected string involvedUser;
    protected Set<string> involvedGroups;
    protected SuspensionState suspensionState;
    protected boolean includeProcessVariables;
    protected Integer processInstanceVariablesLimit;
    protected boolean withJobException;
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string locale;
    protected boolean withLocalizationFallback;

    protected string tenantId;
    protected string tenantIdLike;
    protected boolean withoutTenantId;

    protected List<ProcessInstanceQueryImpl> orQueryObjects = new ArrayList<>();
    protected ProcessInstanceQueryImpl currentOrQueryObject;
    protected boolean inOrStatement;

    protected Date startedBefore;
    protected Date startedAfter;
    protected string startedBy;

    // Unused, see dynamic query
    protected string activityId;
    protected List<EventSubscriptionQueryValue> eventSubscriptions;
    protected boolean onlyChildExecutions;
    protected boolean onlyProcessInstanceExecutions;
    protected boolean onlySubProcessExecutions;
    protected string rootProcessInstanceId;

    public ProcessInstanceQueryImpl() {
    }

    public ProcessInstanceQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public ProcessInstanceQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public ProcessInstanceQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId == null) {
            throw new FlowableIllegalArgumentException("Process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.executionId = processInstanceId;
        } else {
            this.executionId = processInstanceId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceIds(Set<string> processInstanceIds) {
        if (processInstanceIds == null) {
            throw new FlowableIllegalArgumentException("Set of process instance ids is null");
        }
        if (processInstanceIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process instance ids is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceIds = processInstanceIds;
        } else {
            this.processInstanceIds = processInstanceIds;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceBusinessKey(string businessKey) {
        if (businessKey == null) {
            throw new FlowableIllegalArgumentException("Business key is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.businessKey = businessKey;
        } else {
            this.businessKey = businessKey;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceBusinessKey(string businessKey, string processDefinitionKey) {
        if (businessKey == null) {
            throw new FlowableIllegalArgumentException("Business key is null");
        }
        if (inOrStatement) {
            throw new FlowableIllegalArgumentException("This method is not supported in an OR statement");
        }

        this.businessKey = businessKey;
        this.processDefinitionKey = processDefinitionKey;
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceBusinessKeyLike(string businessKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.businessKeyLike = businessKeyLike;
        } else {
            this.businessKeyLike = businessKeyLike;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceTenantId(string tenantId) {
        if (tenantId == null) {
            throw new FlowableIllegalArgumentException("process instance tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceTenantIdLike(string tenantIdLike) {
        if (tenantIdLike == null) {
            throw new FlowableIllegalArgumentException("process instance tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionCategory(string processDefinitionCategory) {
        if (processDefinitionCategory == null) {
            throw new FlowableIllegalArgumentException("Process definition category is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionCategory = processDefinitionCategory;
        } else {
            this.processDefinitionCategory = processDefinitionCategory;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionName(string processDefinitionName) {
        if (processDefinitionName == null) {
            throw new FlowableIllegalArgumentException("Process definition name is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionName = processDefinitionName;
        } else {
            this.processDefinitionName = processDefinitionName;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionVersion(Integer processDefinitionVersion) {
        if (processDefinitionVersion == null) {
            throw new FlowableIllegalArgumentException("Process definition version is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionVersion = processDefinitionVersion;
        } else {
            this.processDefinitionVersion = processDefinitionVersion;
        }
        return this;
    }

    @Override
    public ProcessInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        if (processDefinitionId == null) {
            throw new FlowableIllegalArgumentException("Process definition id is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this.processDefinitionId = processDefinitionId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionIds(Set<string> processDefinitionIds) {
        if (processDefinitionIds == null) {
            throw new FlowableIllegalArgumentException("Set of process definition ids is null");
        }
        if (processDefinitionIds.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process definition ids is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionIds = processDefinitionIds;
        } else {
            this.processDefinitionIds = processDefinitionIds;
        }
        return this;
    }

    @Override
    public ProcessInstanceQueryImpl processDefinitionKey(string processDefinitionKey) {
        if (processDefinitionKey == null) {
            throw new FlowableIllegalArgumentException("Process definition key is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKey = processDefinitionKey;
        } else {
            this.processDefinitionKey = processDefinitionKey;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionKeys(Set<string> processDefinitionKeys) {
        if (processDefinitionKeys == null) {
            throw new FlowableIllegalArgumentException("Set of process definition keys is null");
        }
        if (processDefinitionKeys.isEmpty()) {
            throw new FlowableIllegalArgumentException("Set of process definition keys is empty");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this.processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processDefinitionEngineVersion(string processDefinitionEngineVersion) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionEngineVersion = processDefinitionEngineVersion;
        } else {
            this.processDefinitionEngineVersion = processDefinitionEngineVersion;
        }
        return this;
    }

    @Override
    public ProcessInstanceQueryImpl deploymentId(string deploymentId) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentId = deploymentId;
        } else {
            this.deploymentId = deploymentId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQueryImpl deploymentIdIn(List<string> deploymentIds) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentIds = deploymentIds;
        } else {
            this.deploymentIds = deploymentIds;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery superProcessInstanceId(string superProcessInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.superProcessInstanceId = superProcessInstanceId;
        } else {
            this.superProcessInstanceId = superProcessInstanceId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery subProcessInstanceId(string subProcessInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.subProcessInstanceId = subProcessInstanceId;
        } else {
            this.subProcessInstanceId = subProcessInstanceId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery excludeSubprocesses(boolean excludeSubprocesses) {
        if (inOrStatement) {
            this.currentOrQueryObject.excludeSubprocesses = excludeSubprocesses;
        } else {
            this.excludeSubprocesses = excludeSubprocesses;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery involvedUser(string involvedUser) {
        if (involvedUser == null) {
            throw new FlowableIllegalArgumentException("Involved user is null");
        }

        if (inOrStatement) {
            this.currentOrQueryObject.involvedUser = involvedUser;
        } else {
            this.involvedUser = involvedUser;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery involvedGroups(Set<string> involvedGroups) {
        if (involvedGroups == null) {
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

    @Override
    public ProcessInstanceQuery active() {
        if (inOrStatement) {
            this.currentOrQueryObject.suspensionState = SuspensionState.ACTIVE;
        } else {
            this.suspensionState = SuspensionState.ACTIVE;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery suspended() {
        if (inOrStatement) {
            this.currentOrQueryObject.suspensionState = SuspensionState.SUSPENDED;
        } else {
            this.suspensionState = SuspensionState.SUSPENDED;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery includeProcessVariables() {
        this.includeProcessVariables = true;
        return this;
    }

    @Override
    public ProcessInstanceQuery limitProcessInstanceVariables(Integer processInstanceVariablesLimit) {
        this.processInstanceVariablesLimit = processInstanceVariablesLimit;
        return this;
    }

    public Integer getProcessInstanceVariablesLimit() {
        return processInstanceVariablesLimit;
    }

    @Override
    public ProcessInstanceQuery withJobException() {
        this.withJobException = true;
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceName(string name) {
        if (inOrStatement) {
            this.currentOrQueryObject.name = name;
        } else {
            this.name = name;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceNameLike(string nameLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLike = nameLike;
        } else {
            this.nameLike = nameLike;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        } else {
            this.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        }
        return this;
    }
    
    @Override
    public ProcessInstanceQuery processInstanceCallbackId(string callbackId) {
        if (inOrStatement) {
            this.currentOrQueryObject.callbackId = callbackId;
        } else {
            this.callbackId = callbackId;
        }
        return this;
    }
    
    @Override
    public ProcessInstanceQuery processInstanceCallbackType(string callbackType) {
        if (inOrStatement) {
            this.currentOrQueryObject.callbackType = callbackType;
        } else {
            this.callbackType = callbackType;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceReferenceId(string referenceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceId = referenceId;
        } else {
            this.referenceId = referenceId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery processInstanceReferenceType(string referenceType) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceType = referenceType;
        } else {
            this.referenceType = referenceType;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new ProcessInstanceQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }

    @Override
    public ProcessInstanceQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    @Override
    public ProcessInstanceQuery variableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
            return this;
        } else {
            return variableValueGreaterThan(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
            return this;
        } else {
            return variableValueLessThan(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }

    @Override
    public ProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }
    
    @Override
    public ProcessInstanceQuery variableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }
    
    @Override
    public ProcessInstanceQuery variableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }

    @Override
    public ProcessInstanceQuery locale(string locale) {
        this.locale = locale;
        return this;
    }

    @Override
    public ProcessInstanceQuery withLocalizationFallback() {
        withLocalizationFallback = true;
        return this;
    }

    @Override
    public ProcessInstanceQuery startedBefore(Date beforeTime) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBefore = beforeTime;
        } else {
            this.startedBefore = beforeTime;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery startedAfter(Date afterTime) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedAfter = afterTime;
        } else {
            this.startedAfter = afterTime;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery startedBy(string userId) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBy = userId;
        } else {
            this.startedBy = userId;
        }
        return this;
    }

    @Override
    public ProcessInstanceQuery orderByProcessInstanceId() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_INSTANCE_ID;
        return this;
    }

    @Override
    public ProcessInstanceQuery orderByProcessDefinitionId() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_DEFINITION_ID;
        return this;
    }

    @Override
    public ProcessInstanceQuery orderByProcessDefinitionKey() {
        this.orderProperty = ProcessInstanceQueryProperty.PROCESS_DEFINITION_KEY;
        return this;
    }

    @Override
    public ProcessInstanceQuery orderByStartTime() {
        return orderBy(ProcessInstanceQueryProperty.PROCESS_START_TIME);
    }

    @Override
    public ProcessInstanceQuery orderByTenantId() {
        this.orderProperty = ProcessInstanceQueryProperty.TENANT_ID;
        return this;
    }

    public string getMssqlOrDB2OrderBy() {
        string specialOrderBy = super.getOrderByColumns();
        if (specialOrderBy != null && specialOrderBy.length() > 0) {
            specialOrderBy = specialOrderBy.replace("RES.", "TEMPRES_");
            specialOrderBy = specialOrderBy.replace("ProcessDefinitionKey", "TEMPP_KEY_");
            specialOrderBy = specialOrderBy.replace("ProcessDefinitionId", "TEMPP_ID_");
        }
        return specialOrderBy;
    }

    // results /////////////////////////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();
        
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() != null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().beforeProcessInstanceQueryExecute(this);
        }
        
        return CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceCountByQueryCriteria(this);
    }

    @Override
    public List<ProcessInstance> executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        List<ProcessInstance> processInstances = null;
        
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() != null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().beforeProcessInstanceQueryExecute(this);
        }
        
        if (includeProcessVariables) {
            processInstances = CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceAndVariablesByQueryCriteria(this);
        } else {
            processInstances = CommandContextUtil.getExecutionEntityManager(commandContext).findProcessInstanceByQueryCriteria(this);
        }

        if (processEngineConfiguration.getPerformanceSettings().isEnableLocalization() && processEngineConfiguration.getInternalProcessLocalizationManager() != null) {
            for (ProcessInstance processInstance : processInstances) {
                processEngineConfiguration.getInternalProcessLocalizationManager().localize(processInstance, locale, withLocalizationFallback);
            }
        }
        
        if (processEngineConfiguration.getProcessInstanceQueryInterceptor() != null) {
            processEngineConfiguration.getProcessInstanceQueryInterceptor().afterProcessInstanceQueryExecute(this, processInstances);
        }

        return processInstances;
    }

    @Override
    protected void ensureVariablesInitialized() {
        super.ensureVariablesInitialized();

        for (ProcessInstanceQueryImpl orQueryObject : orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    // getters /////////////////////////////////////////////////////////////////

    public boolean getOnlyProcessInstances() {
        return true; // See dynamic query in runtime.mapping.xml
    }

    public string getProcessInstanceId() {
        return executionId;
    }
    
    @Override
    public string getId() {
        return executionId;
    }

    public string getRootProcessInstanceId() {
        return rootProcessInstanceId;
    }

    public Set<string> getProcessInstanceIds() {
        return processInstanceIds;
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public string getBusinessKeyLike() {
        return businessKeyLike;
    }

    public boolean isIncludeChildExecutionsWithBusinessKeyQuery() {
        return includeChildExecutionsWithBusinessKeyQuery;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public Set<string> getProcessDefinitionIds() {
        return processDefinitionIds;
    }

    public string getProcessDefinitionCategory() {
        return processDefinitionCategory;
    }

    public string getProcessDefinitionName() {
        return processDefinitionName;
    }

    public Integer getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public Set<string> getProcessDefinitionKeys() {
        return processDefinitionKeys;
    }

    public string getProcessDefinitionEngineVersion() {
        return processDefinitionEngineVersion;
    }

    public string getActivityId() {
        return null; // Unused, see dynamic query
    }

    public string getSuperProcessInstanceId() {
        return superProcessInstanceId;
    }

    public string getSubProcessInstanceId() {
        return subProcessInstanceId;
    }

    public boolean isExcludeSubprocesses() {
        return excludeSubprocesses;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public Set<string> getInvolvedGroups() {
        return involvedGroups;
    }

    public SuspensionState getSuspensionState() {
        return suspensionState;
    }

    public void setSuspensionState(SuspensionState suspensionState) {
        this.suspensionState = suspensionState;
    }

    public List<EventSubscriptionQueryValue> getEventSubscriptions() {
        return eventSubscriptions;
    }

    public void setEventSubscriptions(List<EventSubscriptionQueryValue> eventSubscriptions) {
        this.eventSubscriptions = eventSubscriptions;
    }

    public string getTenantId() {
        return tenantId;
    }

    public string getTenantIdLike() {
        return tenantIdLike;
    }

    public boolean isWithoutTenantId() {
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
        return deploymentId;
    }

    public List<string> getDeploymentIds() {
        return deploymentIds;
    }

    public boolean isIncludeProcessVariables() {
        return includeProcessVariables;
    }

    public boolean iswithException() {
        return withJobException;
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

    public List<ProcessInstanceQueryImpl> getOrQueryObjects() {
        return orQueryObjects;
    }

    /**
     * Methods needed for ibatis because of re-use of query-xml for executions. ExecutionQuery contains a parentId property.
     */

    public string getParentId() {
        return null;
    }

    public boolean isOnlyChildExecutions() {
        return onlyChildExecutions;
    }

    public boolean isOnlyProcessInstanceExecutions() {
        return onlyProcessInstanceExecutions;
    }

    public boolean isOnlySubProcessExecutions() {
        return onlySubProcessExecutions;
    }

    public Date getStartedBefore() {
        return startedBefore;
    }

    public void setStartedBefore(Date startedBefore) {
        this.startedBefore = startedBefore;
    }

    public Date getStartedAfter() {
        return startedAfter;
    }

    public void setStartedAfter(Date startedAfter) {
        this.startedAfter = startedAfter;
    }

    public string getStartedBy() {
        return startedBy;
    }

    public void setStartedBy(string startedBy) {
        this.startedBy = startedBy;
    }
}
