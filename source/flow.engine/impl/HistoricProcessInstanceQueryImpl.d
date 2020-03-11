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



import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import java.util.Objects;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.persistence.cache.EntityCache;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.history.HistoricProcessInstanceQuery;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.DeleteHistoricProcessInstancesCmd;
import flow.engine.impl.cmd.DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd;
import flow.engine.impl.cmd.DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd;
import flow.engine.impl.context.Context;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.variable.service.impl.AbstractVariableQueryImpl;
import org.flowable.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;

/**
 * @author Tom Baeyens
 * @author Tijs Rademakers
 * @author Falko Menge
 * @author Bernd Ruecker
 * @author Joram Barrez
 */
class HistoricProcessInstanceQueryImpl extends AbstractVariableQueryImpl<HistoricProcessInstanceQuery, HistoricProcessInstance>
        implements HistoricProcessInstanceQuery, QueryCacheValues {

    private static final long serialVersionUID = 1L;

    protected string processInstanceId;
    protected string processDefinitionId;
    protected string businessKey;
    protected string businessKeyLike;
    protected string deploymentId;
    protected List!string deploymentIds;
    protected bool finished;
    protected bool unfinished;
    protected bool deleted;
    protected bool notDeleted;
    protected string startedBy;
    protected string superProcessInstanceId;
    protected bool excludeSubprocesses;
    protected List!string processDefinitionKeyIn;
    protected List!string processKeyNotIn;
    protected Date startedBefore;
    protected Date startedAfter;
    protected Date finishedBefore;
    protected Date finishedAfter;
    protected string processDefinitionKey;
    protected string processDefinitionCategory;
    protected string processDefinitionName;
    protected Integer processDefinitionVersion;
    protected Set!string processInstanceIds;
    protected string involvedUser;
    protected Set!string involvedGroups;
    protected bool includeProcessVariables;
    protected Integer processInstanceVariablesLimit;
    protected bool withJobException;
    protected string tenantId;
    protected string tenantIdLike;
    protected bool withoutTenantId;
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string locale;
    protected bool withLocalizationFallback;
    protected List<HistoricProcessInstanceQueryImpl> orQueryObjects = new ArrayList<>();
    protected HistoricProcessInstanceQueryImpl currentOrQueryObject;
    protected bool inOrStatement;

    public HistoricProcessInstanceQueryImpl() {
    }

    public HistoricProcessInstanceQueryImpl(CommandContext commandContext) {
        super(commandContext);
    }

    public HistoricProcessInstanceQueryImpl(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }

    @Override
    public HistoricProcessInstanceQueryImpl processInstanceId(string processInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.processInstanceId = processInstanceId;
        } else {
            this.processInstanceId = processInstanceId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceIds(Set!string processInstanceIds) {
        if (processInstanceIds is null) {
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
    public HistoricProcessInstanceQueryImpl processDefinitionId(string processDefinitionId) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionId = processDefinitionId;
        } else {
            this.processDefinitionId = processDefinitionId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionKey(string processDefinitionKey) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionKey = processDefinitionKey;
        } else {
            this.processDefinitionKey = processDefinitionKey;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionKeyIn(List!string processDefinitionKeys) {
        if (inOrStatement) {
            currentOrQueryObject.processDefinitionKeyIn = processDefinitionKeys;
        } else {
            this.processDefinitionKeyIn = processDefinitionKeys;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionCategory(string processDefinitionCategory) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionCategory = processDefinitionCategory;
        } else {
            this.processDefinitionCategory = processDefinitionCategory;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionName(string processDefinitionName) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionName = processDefinitionName;
        } else {
            this.processDefinitionName = processDefinitionName;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionVersion(Integer processDefinitionVersion) {
        if (inOrStatement) {
            this.currentOrQueryObject.processDefinitionVersion = processDefinitionVersion;
        } else {
            this.processDefinitionVersion = processDefinitionVersion;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceBusinessKey(string businessKey) {
        if (inOrStatement) {
            this.currentOrQueryObject.businessKey = businessKey;
        } else {
            this.businessKey = businessKey;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceBusinessKeyLike(string businessKeyLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.businessKeyLike = businessKeyLike;
        } else {
            this.businessKeyLike = businessKeyLike;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery deploymentId(string deploymentId) {
        if (inOrStatement) {
            this.currentOrQueryObject.deploymentId = deploymentId;
        } else {
            this.deploymentId = deploymentId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery deploymentIdIn(List!string deploymentIds) {
        if (inOrStatement) {
            currentOrQueryObject.deploymentIds = deploymentIds;
        } else {
            this.deploymentIds = deploymentIds;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery finished() {
        if (inOrStatement) {
            this.currentOrQueryObject.finished = true;
        } else {
            this.finished = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery unfinished() {
        if (inOrStatement) {
            this.currentOrQueryObject.unfinished = true;
        } else {
            this.unfinished = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery deleted() {
        if (inOrStatement) {
            this.currentOrQueryObject.deleted = true;
        } else {
            this.deleted = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery notDeleted() {
        if (inOrStatement) {
            this.currentOrQueryObject.notDeleted = true;
        } else {
            this.notDeleted = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery startedBy(string startedBy) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBy = startedBy;
        } else {
            this.startedBy = startedBy;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processDefinitionKeyNotIn(List!string processDefinitionKeys) {
        if (inOrStatement) {
            this.currentOrQueryObject.processKeyNotIn = processDefinitionKeys;
        } else {
            this.processKeyNotIn = processDefinitionKeys;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery startedAfter(Date startedAfter) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedAfter = startedAfter;
        } else {
            this.startedAfter = startedAfter;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery startedBefore(Date startedBefore) {
        if (inOrStatement) {
            this.currentOrQueryObject.startedBefore = startedBefore;
        } else {
            this.startedBefore = startedBefore;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery finishedAfter(Date finishedAfter) {
        if (inOrStatement) {
            this.currentOrQueryObject.finishedAfter = finishedAfter;
        } else {
            this.finishedAfter = finishedAfter;
            this.finished = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery finishedBefore(Date finishedBefore) {
        if (inOrStatement) {
            this.currentOrQueryObject.finishedBefore = finishedBefore;
        } else {
            this.finishedBefore = finishedBefore;
            this.finished = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery superProcessInstanceId(string superProcessInstanceId) {
        if (inOrStatement) {
            this.currentOrQueryObject.superProcessInstanceId = superProcessInstanceId;
        } else {
            this.superProcessInstanceId = superProcessInstanceId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery excludeSubprocesses(bool excludeSubprocesses) {
        if (inOrStatement) {
            this.currentOrQueryObject.excludeSubprocesses = excludeSubprocesses;
        } else {
            this.excludeSubprocesses = excludeSubprocesses;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery involvedUser(string involvedUser) {
        if (inOrStatement) {
            this.currentOrQueryObject.involvedUser = involvedUser;
        } else {
            this.involvedUser = involvedUser;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery involvedGroups(Set!string involvedGroups) {
        if (involvedGroups is null) {
            throw new FlowableIllegalArgumentException("involvedGroups are null");
        }
        if (involvedGroups.isEmpty()) {
            throw new FlowableIllegalArgumentException("involvedGroups are empty");
        }
        if (inOrStatement) {
            this.currentOrQueryObject.involvedGroups = involvedGroups;
        } else {
            this.involvedGroups = involvedGroups;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery includeProcessVariables() {
        this.includeProcessVariables = true;
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery limitProcessInstanceVariables(Integer processInstanceVariablesLimit) {
        this.processInstanceVariablesLimit = processInstanceVariablesLimit;
        return this;
    }

    public Integer getProcessInstanceVariablesLimit() {
        return processInstanceVariablesLimit;
    }

    @Override
    public HistoricProcessInstanceQuery withJobException() {
        this.withJobException = true;
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceTenantId(string tenantId) {
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

    @Override
    public HistoricProcessInstanceQuery processInstanceTenantIdLike(string tenantIdLike) {
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

    @Override
    public HistoricProcessInstanceQuery processInstanceWithoutTenantId() {
        if (inOrStatement) {
            this.currentOrQueryObject.withoutTenantId = true;
        } else {
            this.withoutTenantId = true;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceName(string name) {
        if (inOrStatement) {
            this.currentOrQueryObject.name = name;
        } else {
            this.name = name;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceNameLike(string nameLike) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLike = nameLike;
        } else {
            this.nameLike = nameLike;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        if (inOrStatement) {
            this.currentOrQueryObject.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        } else {
            this.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceCallbackId(string callbackId) {
        if (inOrStatement) {
            currentOrQueryObject.callbackId = callbackId;
        } else {
            this.callbackId = callbackId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceCallbackType(string callbackType) {
        if (inOrStatement) {
            currentOrQueryObject.callbackType = callbackType;
        } else {
            this.callbackType = callbackType;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceReferenceId(string referenceId) {
        if (inOrStatement) {
            currentOrQueryObject.referenceId = referenceId;
        } else {
            this.referenceId = referenceId;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery processInstanceReferenceType(string referenceType) {
        if (inOrStatement) {
            currentOrQueryObject.referenceType = referenceType;
        } else {
            this.referenceType = referenceType;
        }
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery variableValueEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableName, variableValue, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueNotEquals(string variableName, Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEquals(variableName, variableValue, false);
            return this;
        } else {
            return variableValueNotEquals(variableName, variableValue, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueEquals(Object variableValue) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEquals(variableValue, false);
            return this;
        } else {
            return variableValueEquals(variableValue, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueEqualsIgnoreCase(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueNotEqualsIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueNotEqualsIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueNotEqualsIgnoreCase(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueLikeIgnoreCase(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLikeIgnoreCase(name, value, false);
            return this;
        } else {
            return variableValueLikeIgnoreCase(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueGreaterThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThan(name, value, false);
            return this;
        } else {
            return variableValueGreaterThan(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueGreaterThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueGreaterThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueGreaterThanOrEqual(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueLessThan(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThan(name, value, false);
            return this;
        } else {
            return variableValueLessThan(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueLessThanOrEqual(string name, Object value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLessThanOrEqual(name, value, false);
            return this;
        } else {
            return variableValueLessThanOrEqual(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableValueLike(string name, string value) {
        if (inOrStatement) {
            currentOrQueryObject.variableValueLike(name, value, false);
            return this;
        } else {
            return variableValueLike(name, value, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableExists(name, false);
            return this;
        } else {
            return variableExists(name, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery variableNotExists(string name) {
        if (inOrStatement) {
            currentOrQueryObject.variableNotExists(name, false);
            return this;
        } else {
            return variableNotExists(name, false);
        }
    }

    @Override
    public HistoricProcessInstanceQuery locale(string locale) {
        this.locale = locale;
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery withLocalizationFallback() {
        withLocalizationFallback = true;
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery or() {
        if (inOrStatement) {
            throw new FlowableException("the query is already in an or statement");
        }

        inOrStatement = true;
        currentOrQueryObject = new HistoricProcessInstanceQueryImpl();
        orQueryObjects.add(currentOrQueryObject);
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery endOr() {
        if (!inOrStatement) {
            throw new FlowableException("endOr() can only be called after calling or()");
        }

        inOrStatement = false;
        currentOrQueryObject = null;
        return this;
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessInstanceBusinessKey() {
        return orderBy(HistoricProcessInstanceQueryProperty.BUSINESS_KEY);
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessInstanceDuration() {
        return orderBy(HistoricProcessInstanceQueryProperty.DURATION);
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessInstanceStartTime() {
        return orderBy(HistoricProcessInstanceQueryProperty.START_TIME);
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessInstanceEndTime() {
        return orderBy(HistoricProcessInstanceQueryProperty.END_TIME);
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessDefinitionId() {
        return orderBy(HistoricProcessInstanceQueryProperty.PROCESS_DEFINITION_ID);
    }

    @Override
    public HistoricProcessInstanceQuery orderByProcessInstanceId() {
        return orderBy(HistoricProcessInstanceQueryProperty.PROCESS_INSTANCE_ID_);
    }

    @Override
    public HistoricProcessInstanceQuery orderByTenantId() {
        return orderBy(HistoricProcessInstanceQueryProperty.TENANT_ID);
    }

    public string getMssqlOrDB2OrderBy() {
        string specialOrderBy = super.getOrderByColumns();
        if (specialOrderBy !is null && specialOrderBy.length() > 0) {
            specialOrderBy = specialOrderBy.replace("RES.", "TEMPRES_");
            specialOrderBy = specialOrderBy.replace("VAR.", "TEMPVAR_");
        }
        return specialOrderBy;
    }

    @Override
    public long executeCount(CommandContext commandContext) {
        ensureVariablesInitialized();

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor().beforeHistoricProcessInstanceQueryExecute(this);
        }

        return CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findHistoricProcessInstanceCountByQueryCriteria(this);
    }

    @Override
    public List<HistoricProcessInstance> executeList(CommandContext commandContext) {
        ensureVariablesInitialized();
        List<HistoricProcessInstance> results = null;

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        if (processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor().beforeHistoricProcessInstanceQueryExecute(this);
        }

        if (includeProcessVariables) {
            results = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findHistoricProcessInstancesAndVariablesByQueryCriteria(this);

            if (processInstanceId !is null) {
                addCachedVariableForQueryById(commandContext, results);
            }

        } else {
            results = CommandContextUtil.getHistoricProcessInstanceEntityManager(commandContext).findHistoricProcessInstancesByQueryCriteria(this);
        }

        if (processEngineConfiguration.getPerformanceSettings().isEnableLocalization() && processEngineConfiguration.getInternalProcessLocalizationManager() !is null) {
            for (HistoricProcessInstance processInstance : results) {
                processEngineConfiguration.getInternalProcessLocalizationManager().localize(processInstance, locale, withLocalizationFallback);
            }
        }

        if (processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor() !is null) {
            processEngineConfiguration.getHistoricProcessInstanceQueryInterceptor().afterHistoricProcessInstanceQueryExecute(this, results);
        }

        return results;
    }

    protected void addCachedVariableForQueryById(CommandContext commandContext, List<HistoricProcessInstance> results) {

        // Unlike the ExecutionEntityImpl, variables are not stored on the HistoricExecutionEntityImpl.
        // The solution for the non-historical entity is to use the variable cache on the entity, inspect the variables
        // of the current transaction and add them if necessary.
        // For the historical entity, we need to detect this use case specifically (i.e. byId is used) and check the entityCache.

        for (HistoricProcessInstance historicProcessInstance : results) {
            if (Objects.equals(processInstanceId, historicProcessInstance.getId())) {

                EntityCache entityCache = commandContext.getSession(EntityCache.class);
                List<HistoricVariableInstanceEntity> cachedVariableEntities = entityCache.findInCache(HistoricVariableInstanceEntity.class);
                for (HistoricVariableInstanceEntity cachedVariableEntity : cachedVariableEntities) {

                    if (historicProcessInstance.getId().equals(cachedVariableEntity.getProcessInstanceId())) {

                        // Variables from the cache have precedence
                        ((HistoricProcessInstanceEntity) historicProcessInstance).getQueryVariables().add(cachedVariableEntity);

                    }

                }

            }
        }
    }

    @Override
    protected void ensureVariablesInitialized() {
        super.ensureVariablesInitialized();

        for (HistoricProcessInstanceQueryImpl orQueryObject : orQueryObjects) {
            orQueryObject.ensureVariablesInitialized();
        }
    }

    @Override
    protected void checkQueryOk() {
        super.checkQueryOk();

        if (includeProcessVariables) {
            this.orderBy(HistoricProcessInstanceQueryProperty.INCLUDED_VARIABLE_TIME).asc();
        }
    }

    @Override
    public void delete() {
        if (commandExecutor !is null) {
            commandExecutor.execute(new DeleteHistoricProcessInstancesCmd(this));
        } else {
            new DeleteHistoricProcessInstancesCmd(this).execute(Context.getCommandContext());
        }
    }

    @Override
    public void deleteWithRelatedData() {
        if (commandExecutor !is null) {
            CommandConfig config = new CommandConfig().transactionRequiresNew();
            commandExecutor.execute(config, new DeleteHistoricProcessInstancesCmd(this));
            commandExecutor.execute(config, new DeleteTaskAndActivityDataOfRemovedHistoricProcessInstancesCmd());
            commandExecutor.execute(config, new DeleteRelatedDataOfRemovedHistoricProcessInstancesCmd());
        } else {
            throw new FlowableException("deleting historic process instances with related data requires CommandExecutor");
        }
    }

    public string getBusinessKey() {
        return businessKey;
    }

    public string getBusinessKeyLike() {
        return businessKeyLike;
    }

    public bool isOpen() {
        return unfinished;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public List!string getProcessDefinitionKeyIn() {
        return processDefinitionKeyIn;
    }

    public string getProcessDefinitionIdLike() {
        return processDefinitionKey + ":%:%";
    }

    public string getProcessDefinitionName() {
        return processDefinitionName;
    }

    public string getProcessDefinitionCategory() {
        return processDefinitionCategory;
    }

    public Integer getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public string getId() {
        return processInstanceId;
    }

    public Set!string getProcessInstanceIds() {
        return processInstanceIds;
    }

    public string getStartedBy() {
        return startedBy;
    }

    public string getSuperProcessInstanceId() {
        return superProcessInstanceId;
    }

    public bool isExcludeSubprocesses() {
        return excludeSubprocesses;
    }

    public List!string getProcessKeyNotIn() {
        return processKeyNotIn;
    }

    public Date getStartedAfter() {
        return startedAfter;
    }

    public Date getStartedBefore() {
        return startedBefore;
    }

    public Date getFinishedAfter() {
        return finishedAfter;
    }

    public Date getFinishedBefore() {
        return finishedBefore;
    }

    public string getInvolvedUser() {
        return involvedUser;
    }

    public Set!string getInvolvedGroups() {
        return involvedGroups;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public string getDeploymentId() {
        return deploymentId;
    }

    public List!string getDeploymentIds() {
        return deploymentIds;
    }

    public bool isFinished() {
        return finished;
    }

    public bool isUnfinished() {
        return unfinished;
    }

    public bool isDeleted() {
        return deleted;
    }

    public bool isNotDeleted() {
        return notDeleted;
    }

    public bool isIncludeProcessVariables() {
        return includeProcessVariables;
    }

    public bool isWithException() {
        return withJobException;
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

    public List<HistoricProcessInstanceQueryImpl> getOrQueryObjects() {
        return orQueryObjects;
    }
}
