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
import java.util.List;
import java.util.Set;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.db.SuspensionState;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.DynamicBpmnConstants;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ExecutionQuery;
import org.flowable.eventsubscription.service.impl.EventSubscriptionQueryValue;
import org.flowable.variable.service.impl.AbstractVariableQueryImpl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 * @author Frederik Heremans
 * @author Daniel Meyer
 */
class ExecutionQueryImpl extends AbstractVariableQueryImpl<ExecutionQuery, Execution> implements ExecutionQuery, QueryCacheValues {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionId;
    protected string processDefinitionKey;
    protected string processDefinitionCategory;
    protected string processDefinitionName;
    protected Integer processDefinitionVersion;
    protected string processDefinitionEngineVersion;
    protected string activityId;
    protected string executionId;
    protected string parentId;
    protected boolean onlyChildExecutions;
    protected boolean onlySubProcessExecutions;
    protected boolean onlyProcessInstanceExecutions;
    protected string processInstanceId;
    protected string rootProcessInstanceId;
    protected List<EventSubscriptionQueryValue> eventSubscriptions;

    protected string tenantId;
    protected string tenantIdLike;
    protected boolean withoutTenantId;
    protected string locale;
    protected boolean withLocalizationFallback;

    protected Date startedBefore;
    protected Date startedAfter;
    protected string startedBy;

    // Not used by end-users, but needed for dynamic ibatis query
    protected string superProcessInstanceId;
    protected string subProcessInstanceId;
    protected boolean excludeSubprocesses;
    protected SuspensionState suspensionState;
    protected string businessKey;
    protected string businessKeyLike;
    protected boolean includeChildExecutionsWithBusinessKeyQuery;
    protected boolean isActive;
    protected string involvedUser;
    protected Set<string> involvedGroups;
    protected Set<string> processDefinitionKeys;
    protected Set<string> processDefinitionIds;

    // Not exposed in API, but here for the ProcessInstanceQuery support, since
    // the name lives on the
    // Execution entity/table
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string deploymentId;
    protected List<string> deploymentIds;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    
    protected List<ExecutionQueryImpl> orQueryObjects = new ArrayList<>();
    protected ExecutionQueryImpl currentOrQueryObject;
    protected boolean inOrStatement;

    public ExecutionQueryImpl() {
    }

    public ExecutionQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public ExecutionQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    public boolean isProcessInstancesOnly() {
        return false; // see dynamic query
    }

    @Override
    public ExecutionQueryImpl processDefinitionId(string processDefinitionId) {
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
    public ExecutionQueryImpl processDefinitionKey(string processDefinitionKey) {
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
    public ExecutionQuery processDefinitionCategory(string processDefinitionCategory) {
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
    public ExecutionQuery processDefinitionName(string processDefinitionName) {
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
    public ExecutionQuery processDefinitionVersion(Integer processDefinitionVersion) {
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
    public ExecutionQuery processDefinitionEngineVersion(string processDefinitionEngineVersion) {
        if (processDefinitionEngineVersion == null) {
            throw new FlowableIllegalArgumentException("Process definition engine version is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionEngineVersion = processDefinitionEngineVersion;
        } else {
            this.processDefinitionEngineVersion = processDefinitionEngineVersion;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl processInstanceId(string processInstanceId) {
        if (processInstanceId == null) {
            throw new FlowableIllegalArgumentException("Process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this.processInstanceId = processInstanceId;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl rootProcessInstanceId(string rootProcessInstanceId) {
        if (rootProcessInstanceId == null) {
            throw new FlowableIllegalArgumentException("Root process instance id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.rootProcessInstanceId = rootProcessInstanceId;
        } else {
            this.rootProcessInstanceId = rootProcessInstanceId;
        }
        return this;
    }

    @Override
    public ExecutionQuery processInstanceBusinessKey(string businessKey) {
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
    public ExecutionQuery processInstanceBusinessKey(string processInstanceBusinessKey, boolean includeChildExecutions) {
        if (!includeChildExecutions) {
            return processInstanceBusinessKey(processInstanceBusinessKey);
        } else {
            if (processInstanceBusinessKey == null) {
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

    @Override
    public ExecutionQuery processDefinitionKeys(Set<string> processDefinitionKeys) {
        if (processDefinitionKeys == null) {
            throw new FlowableIllegalArgumentException("Process definition keys is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKeys = processDefinitionKeys;
        } else {
            this.processDefinitionKeys = processDefinitionKeys;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl executionId(string executionId) {
        if (executionId == null) {
            throw new FlowableIllegalArgumentException("Execution id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.executionId = executionId;
        } else {
            this.executionId = executionId;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl activityId(string activityId) {
        if (inOrStatement) {
            this.currentOrQueryObject.activityId = activityId;
            if (activityId != null) {
                this.currentOrQueryObject.isActive = true;
            }
            
        } else {
            this.activityId = activityId;

            if (activityId != null) {
                this.isActive = true;
            }
        }
        
        return this;
    }

    @Override
    public ExecutionQueryImpl parentId(string parentId) {
        if (parentId == null) {
            throw new FlowableIllegalArgumentException("Parent id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.parentId = parentId;
        } else {
            this.parentId = parentId;
        }
        return this;
    }

    @Override
    public ExecutionQuery onlyChildExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject.onlyChildExecutions = true;
        } else {
            this.onlyChildExecutions = true;
        }
        return this;
    }

    @Override
    public ExecutionQuery onlySubProcessExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject.onlySubProcessExecutions = true;
        } else {
            this.onlySubProcessExecutions = true;
        }
        return this;
    }

    @Override
    public ExecutionQuery onlyProcessInstanceExecutions() {
        if (inOrStatement) {
            this.currentOrQueryObject.onlyProcessInstanceExecutions = true;
        } else {
            this.onlyProcessInstanceExecutions = true;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl executionTenantId(string tenantId) {
        if (tenantId == null) {
            throw new FlowableIllegalArgumentException("execution tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantId = tenantId;
        } else {
            this.tenantId = tenantId;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl executionTenantIdLike(string tenantIdLike) {
        if (tenantIdLike == null) {
            throw new FlowableIllegalArgumentException("execution tenant id is null");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.tenantIdLike = tenantIdLike;
        } else {
            this.tenantIdLike = tenantIdLike;
        }
        return this;
    }

    @Override
    public ExecutionQueryImpl executionWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        
        return this;
    }

    @Override
    public ExecutionQuery executionReferenceId(string referenceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.referenceId = referenceId;
        } else {
            this.referenceId = referenceId;
        }
        return this;
    }

    @Override
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

    @Override
    public ExecutionQuery signalEventSubscriptionName(string signalName) {
        return eventSubscription("signal", signalName);
    }

    @Override
    public ExecutionQuery messageEventSubscriptionName(string messageName) {
        return eventSubscription("message", messageName);
    }

    public ExecutionQuery eventSubscription(string eventType, string eventName) {
        if (eventName == null) {
            throw new FlowableIllegalArgumentException("event name is null");
        }
        if (eventType == null) {
            throw new FlowableIllegalArgumentException("event type is null");
        }
        
        if (inOrStatement) {
            if (this.currentOrQueryObject.eventSubscriptions == null) {
                this.currentOrQueryObject.eventSubscriptions = new ArrayList<>();
            }
            this.currentOrQueryObject.eventSubscriptions.add(new EventSubscriptionQueryValue(eventName, eventType));
           
        } else {
            if (eventSubscriptions == null) {
                eventSubscriptions = new ArrayList<>();
            }
            eventSubscriptions.add(new EventSubscriptionQueryValue(eventName, eventType));
        }
        
        return this;
    }

    @Override
    public ExecutionQuery processVariableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }

    @Override
    public ExecutionQuery processVariableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }

    @Override
    public ExecutionQuery processVariableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }

    @Override
    public ExecutionQuery processVariableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }

    @Override
    public ExecutionQuery processVariableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        } 
    }

    @Override
    public ExecutionQuery processVariableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }

    @Override
    public ExecutionQuery processVariableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }
    
    @Override
    public ExecutionQuery processVariableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
        } else {
            this.variableValueGreaterThan(name, value, false);
        }
        return this;
    }

    @Override
    public ExecutionQuery processVariableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
        } else {
            this.variableValueGreaterThanOrEqual(name, value, false);
        }
        return this;
    }

    @Override
    public ExecutionQuery processVariableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
        } else {
            this.variableValueLessThan(name, value, false);
        }
        return this;
    }

    @Override
    public ExecutionQuery processVariableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
        } else {
            this.variableValueLessThanOrEqual(name, value, false);
        }
        return this;
    }

    @Override
    public ExecutionQuery processVariableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }

    @Override
    public ExecutionQuery processVariableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }
    
    @Override
    public ExecutionQuery variableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, true);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, true);
        }
    }

    @Override
    public ExecutionQuery variableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, true);
            return this;
        } else {
            return variableValueEquals(variableValue, true);
        }
    }

    @Override
    public ExecutionQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, true);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, true);
        }
    }

    @Override
    public ExecutionQuery variableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, true);
        } 
    }

    @Override
    public ExecutionQuery variableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, true);
            return this;
        } else {
            return variableValueLike(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, true);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, true);
        }
    }
    
    @Override
    public ExecutionQuery variableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, true);
            return this;
        } else {
            return variableValueGreaterThan(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, true);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, true);
            return this;
        } else {
            return variableValueLessThan(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, true);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, true);
        }
    }

    @Override
    public ExecutionQuery variableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, true);
            return this;
        } else {
            return variableExists(name, true);
        }
    }

    @Override
    public ExecutionQuery variableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, true);
            return this;
        } else {
            return variableNotExists(name, true);
        }
    }

    @Override
    public ExecutionQuery locale(string locale) {
        if (inOrStatement) {
            currentOrQueryObject.locale = locale;
        } else {
            this.locale = locale;
        }
        
        return this;
    }

    @Override
    public ExecutionQuery withLocalizationFallback() {
        if (inOrStatement) {
            currentOrQueryObject.withLocalizationFallback = true;
        } else {
            this.withLocalizationFallback = true;
        }
        
        return this;
    }

    @Override
    public ExecutionQuery startedBefore(Date beforeTime) {
        if (beforeTime == null) {
            throw new FlowableIllegalArgumentException("before time is null");
        }
        
        if (inOrStatement) {
            currentOrQueryObject.startedBefore = beforeTime;
        } else {
            this.startedBefore = beforeTime;
        }
        
        return this;
    }

    @Override
    public ExecutionQuery startedAfter(Date afterTime) {
        if (afterTime == null) {
            throw new FlowableIllegalArgumentException("after time is null");
        }
        
        if (inOrStatement) {
            currentOrQueryObject.startedAfter = afterTime;
        } else {
            this.startedAfter = afterTime;
        }

        return this;
    }

    @Override
    public ExecutionQuery startedBy(string userId) {
        if (userId == null) {
            throw new FlowableIllegalArgumentException("user id is null");
        }
        
        if (inOrStatement) {
            currentOrQueryObject.startedBy = userId;
        } else {
            this.startedBy = userId;
        }

        return this;
    }
    
    @Override
    public ExecutionQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new ExecutionQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }

    @Override
    public ExecutionQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    // ordering ////////////////////////////////////////////////////

    @Override
    public ExecutionQueryImpl orderByProcessInstanceId() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_INSTANCE_ID;
        return this;
    }

    @Override
    public ExecutionQueryImpl orderByProcessDefinitionId() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_DEFINITION_ID;
        return this;
    }

    @Override
    public ExecutionQueryImpl orderByProcessDefinitionKey() {
        this.orderProperty = ExecutionQueryProperty.PROCESS_DEFINITION_KEY;
        return this;
    }

    @Override
    public ExecutionQueryImpl orderByTenantId() {
        this.orderProperty = ExecutionQueryProperty.TENANT_ID;
        return this;
    }

    // results ////////////////////////////////////////////////////

    @Override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();
        
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getExecutionQueryInterceptor() != null) {
            processEngineConfiguration.getExecutionQueryInterceptor().beforeExecutionQueryExecute(this);
        }
        
        return CommandContextUtil.getExecutionEntityManager(commandContext).findExecutionCountByQueryCriteria(this);
    }

    @SuppressWarnings({ "unchecked" })
    @Override
    public List<Execution> executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getExecutionQueryInterceptor() != null) {
            processEngineConfiguration.getExecutionQueryInterceptor().beforeExecutionQueryExecute(this);
        }
        
        List<?> executions = CommandContextUtil.getExecutionEntityManager(commandContext).findExecutionsByQueryCriteria(this);

        if (processEngineConfiguration.getPerformanceSettings().isEnableLocalization()) {
            for (ExecutionEntity execution : (List<ExecutionEntity>) executions) {
                string activityId = null;
                if (execution.getId().equals(execution.getProcessInstanceId())) {
                    if (execution.getProcessDefinitionId() != null) {
                        ProcessDefinition processDefinition = processEngineConfiguration
                                .getDeploymentManager()
                                .findDeployedProcessDefinitionById(execution.getProcessDefinitionId());
                        activityId = processDefinition.getKey();
                    }

                } else {
                    activityId = execution.getActivityId();
                }

                if (activityId != null) {
                    localize(execution, activityId);
                }
            }
        }
        
        if (processEngineConfiguration.getExecutionQueryInterceptor() != null) {
            processEngineConfiguration.getExecutionQueryInterceptor().afterExecutionQueryExecute(this, (List<Execution>) executions);
        }

        return (List<Execution>) executions;
    }

    protected void localize(Execution execution, string activityId) {
        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        executionEntity.setLocalizedName(null);
        executionEntity.setLocalizedDescription(null);

        string processDefinitionId = executionEntity.getProcessDefinitionId();
        if (locale != null && processDefinitionId != null) {
            ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, activityId, processDefinitionId, withLocalizationFallback);
            if (languageNode != null) {
                JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                if (languageNameNode != null && !languageNameNode.isNull()) {
                    executionEntity.setLocalizedName(languageNameNode.asText());
                }

                JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                if (languageDescriptionNode != null && !languageDescriptionNode.isNull()) {
                    executionEntity.setLocalizedDescription(languageDescriptionNode.asText());
                }
            }
        }
    }
    
    @Override
    protected void ensureVariablesInitialized() {
        super.ensureVariablesInitialized();

        for (ExecutionQueryImpl orQueryObject : orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    // getters ////////////////////////////////////////////////////

    public boolean getOnlyProcessInstances() {
        return false;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
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

    public string getProcessDefinitionEngineVersion() {
        return processDefinitionEngineVersion;
    }

    public string getActivityId() {
        return activityId;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public string getRootProcessInstanceId() {
        return rootProcessInstanceId;
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
        return executionId;
    }
    
    @Override
    public string getId() {
        return executionId;
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

    public SuspensionState getSuspensionState() {
        return suspensionState;
    }

    public void setSuspensionState(SuspensionState suspensionState) {
        this.suspensionState = suspensionState;
    }

    public List<EventSubscriptionQueryValue> getEventSubscriptions() {
        return eventSubscriptions;
    }

    public boolean isIncludeChildExecutionsWithBusinessKeyQuery() {
        return includeChildExecutionsWithBusinessKeyQuery;
    }

    public void setEventSubscriptions(List<EventSubscriptionQueryValue> eventSubscriptions) {
        this.eventSubscriptions = eventSubscriptions;
    }

    public boolean isActive() {
        return isActive;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public void setInvolvedUser(string involvedUser) {
        this.involvedUser = involvedUser;
    }

    public Set<string> getInvolvedGroups() {
        return involvedGroups;
    }

    public void setInvolvedGroups(Set<string> involvedGroups) {
        this.involvedGroups = involvedGroups;
    }

    public Set<string> getProcessDefinitionIds() {
        return processDefinitionIds;
    }

    public Set<string> getProcessDefinitionKeys() {
        return processDefinitionKeys;
    }

    public string getParentId() {
        return parentId;
    }

    public boolean isOnlyChildExecutions() {
        return onlyChildExecutions;
    }

    public boolean isOnlySubProcessExecutions() {
        return onlySubProcessExecutions;
    }

    public boolean isOnlyProcessInstanceExecutions() {
        return onlyProcessInstanceExecutions;
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

    public List<string> getDeploymentIds() {
        return deploymentIds;
    }

    public void setDeploymentIds(List<string> deploymentIds) {
        this.deploymentIds = deploymentIds;
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
