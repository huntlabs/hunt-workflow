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

module flow.engine.impl.persistence.entity.ExecutionEntityImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowableListener;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.db.SuspensionState;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clock;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInitializingList;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineVariableScopeEntity;
//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */

class ExecutionEntityImpl : AbstractBpmnEngineVariableScopeEntity , ExecutionEntity, CountingExecutionEntity {

    // current position /////////////////////////////////////////////////////////

    protected FlowElement currentFlowElement;
    protected FlowableListener currentListener; // Only set when executing an execution listener

    protected FlowElement originatingCurrentFlowElement;

    /**
     * the process instance. this is the root of the execution tree. the processInstance of a process instance is a self reference.
     */
    protected ExecutionEntityImpl processInstance;

    /** the parent execution */
    protected ExecutionEntityImpl parent;

    /** nested executions representing scopes or concurrent paths */
    protected List!ExecutionEntityImpl executions;

    /** super execution, not-null if this execution is part of a subprocess */
    protected ExecutionEntityImpl superExecution;

    /** reference to a subprocessinstance, not-null if currently subprocess is started from this execution */
    protected ExecutionEntityImpl subProcessInstance;

    /** The tenant identifier (if any) */
    protected string tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
    protected string name;
    protected string description;
    protected string localizedName;
    protected string localizedDescription;

    protected Date lockTime;

    // state/type of execution //////////////////////////////////////////////////

    protected bool isActive = true;
    protected bool isScope = true;
    protected bool isConcurrent;
    protected bool isEnded;
    protected bool isEventScope;
    protected bool isMultiInstanceRoot;
    protected bool isCountEnabled;

    // events ///////////////////////////////////////////////////////////////////

    // TODO: still needed in v6?

    protected string eventName;

    // associated entities /////////////////////////////////////////////////////

    // (we cache associated entities here to minimize db queries)
    protected List<EventSubscriptionEntity> eventSubscriptions;
    protected List<JobEntity> jobs;
    protected List<TimerJobEntity> timerJobs;
    protected List<TaskEntity> tasks;
    protected List<IdentityLinkEntity> identityLinks;

    // cascade deletion ////////////////////////////////////////////////////////

    protected string deleteReason;

    protected int suspensionState = SuspensionState.ACTIVE.getStateCode();

    protected string startActivityId;
    protected string startUserId;
    protected Date startTime;

    // CountingExecutionEntity
    protected int eventSubscriptionCount;
    protected int taskCount;
    protected int jobCount;
    protected int timerJobCount;
    protected int suspendedJobCount;
    protected int deadLetterJobCount;
    protected int variableCount;
    protected int identityLinkCount;

    /**
     * Persisted reference to the processDefinition.
     *
     * @see #processDefinition
     * @see #setProcessDefinition(ProcessDefinitionImpl)
     * @see #getProcessDefinition()
     */
    protected string processDefinitionId;

    /**
     * Persisted reference to the process definition key.
     */
    protected string processDefinitionKey;

    /**
     * Persisted reference to the process definition name.
     */
    protected string processDefinitionName;

    /**
     * persisted reference to the process definition version.
     */
    protected Integer processDefinitionVersion;

    /**
     * Persisted reference to the deployment id.
     */
    protected string deploymentId;

    /**
     * Persisted reference to the current position in the diagram within the {@link #processDefinition}.
     *
     * @see #activity
     * @see #setActivity(ActivityImpl)
     * @see #getActivity()
     */
    protected string activityId;

    /**
     * The name of the current activity position
     */
    protected string activityName;

    /**
     * Persisted reference to the process instance.
     *
     * @see #getProcessInstance()
     */
    protected string processInstanceId;

    /**
     * Persisted reference to the business key.
     */
    protected string businessKey;

    /**
     * Persisted reference to the parent of this execution.
     *
     * @see #getParent()
     * @see #setParentId(string)
     */
    protected string parentId;

    /**
     * Persisted reference to the super execution of this execution
     *
     * @see #getSuperExecution()
     * @see #setSuperExecution(ExecutionEntityImpl)
     */
    protected string superExecutionId;

    protected string rootProcessInstanceId;
    protected ExecutionEntityImpl rootProcessInstance;

    protected bool forcedUpdate;

    protected List<VariableInstanceEntity> queryVariables;

    // Callback
    protected string callbackId;
    protected string callbackType;

    // Reference
    protected string referenceId;
    protected string referenceType;

    /**
     * The optional stage instance id, if this execution runs in the context of a CMMN case and has a parent stage it belongs to.
     */
    protected string propagatedStageInstanceId;

    public ExecutionEntityImpl() {

    }


    /**
     * Static factory method: to be used when a new execution is created for the very first time/ Calling this will make sure no extra db fetches are needed later on, as all collections will be
     * populated with empty collections. If they would be null, it would trigger a database fetch for those relationship entities.
     */
    public static ExecutionEntityImpl createWithEmptyRelationshipCollections() {
        ExecutionEntityImpl execution = new ExecutionEntityImpl();
        execution.executions = new ArrayList<>(1);
        execution.tasks = new ArrayList<>(1);
        execution.variableInstances = new HashMap<>(1);
        execution.jobs = new ArrayList<>(1);
        execution.timerJobs = new ArrayList<>(1);
        execution.eventSubscriptions = new ArrayList<>(1);
        execution.identityLinks = new ArrayList<>(1);
        return execution;
    }

    // persistent state /////////////////////////////////////////////////////////

    @Override
    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap<>();
        persistentState.put("processDefinitionId", this.processDefinitionId);
        persistentState.put("businessKey", this.businessKey);
        persistentState.put("activityId", this.activityId);
        persistentState.put("isActive", this.isActive);
        persistentState.put("isConcurrent", this.isConcurrent);
        persistentState.put("isScope", this.isScope);
        persistentState.put("isEventScope", this.isEventScope);
        persistentState.put("parentId", parentId);
        persistentState.put("name", name);
        persistentState.put("lockTime", lockTime);
        persistentState.put("superExecution", this.superExecutionId);
        persistentState.put("rootProcessInstanceId", this.rootProcessInstanceId);
        persistentState.put("isMultiInstanceRoot", this.isMultiInstanceRoot);
        if (forcedUpdate) {
            persistentState.put("forcedUpdate", bool.TRUE);
        }
        persistentState.put("suspensionState", this.suspensionState);
        persistentState.put("startActivityId", this.startActivityId);
        persistentState.put("startTime", this.startTime);
        persistentState.put("startUserId", this.startUserId);
        persistentState.put("isCountEnabled", this.isCountEnabled);
        persistentState.put("eventSubscriptionCount", eventSubscriptionCount);
        persistentState.put("taskCount", taskCount);
        persistentState.put("jobCount", jobCount);
        persistentState.put("timerJobCount", timerJobCount);
        persistentState.put("suspendedJobCount", suspendedJobCount);
        persistentState.put("deadLetterJobCount", deadLetterJobCount);
        persistentState.put("variableCount", variableCount);
        persistentState.put("identityLinkCount", identityLinkCount);
        persistentState.put("callbackId", callbackId);
        persistentState.put("callbackType", callbackType);
        persistentState.put("referenceId", referenceId);
        persistentState.put("referenceType", referenceType);
        persistentState.put("propagatedStageInstanceId", propagatedStageInstanceId);
        return persistentState;
    }

    // The current flow element, will be filled during operation execution

    @Override
    public FlowElement getCurrentFlowElement() {
        if (currentFlowElement is null) {
            string processDefinitionId = getProcessDefinitionId();
            if (processDefinitionId !is null) {
                flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
                currentFlowElement = process.getFlowElement(getCurrentActivityId(), true);
            }
        }
        return currentFlowElement;
    }

    @Override
    public void setCurrentFlowElement(FlowElement currentFlowElement) {
        this.currentFlowElement = currentFlowElement;
        if (currentFlowElement !is null) {
            this.activityId = currentFlowElement.getId();
            this.activityName = currentFlowElement.getName();
        } else {
            this.activityId = null;
            this.activityName = null;
        }
    }

    @Override
    public FlowableListener getCurrentFlowableListener() {
        return currentListener;
    }

    @Override
    public void setCurrentFlowableListener(FlowableListener currentListener) {
        this.currentListener = currentListener;
    }

    @Override
    public FlowElement getOriginatingCurrentFlowElement() {
        return originatingCurrentFlowElement;
    }

    @Override
    public void setOriginatingCurrentFlowElement(FlowElement flowElement) {
        this.originatingCurrentFlowElement = flowElement;
    }

    // executions ///////////////////////////////////////////////////////////////

    /** ensures initialization and returns the non-null executions list */
    @Override
    public List<ExecutionEntityImpl> getExecutions() {
        ensureExecutionsInitialized();
        return executions;
    }

    @Override
    public void addChildExecution(ExecutionEntity executionEntity) {
        ensureExecutionsInitialized();
        executions.remove(executionEntity);
        executions.add((ExecutionEntityImpl) executionEntity);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
    protected void ensureExecutionsInitialized() {
        if (executions is null) {
            this.executions = (List) CommandContextUtil.getExecutionEntityManager().findChildExecutionsByParentExecutionId(id);
        }
    }

    // business key ////////////////////////////////////////////////////////////

    @Override
    public string getBusinessKey() {
        return businessKey;
    }

    @Override
    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }

    @Override
    public string getProcessInstanceBusinessKey() {
        return getProcessInstance().getBusinessKey();
    }

    // process definition ///////////////////////////////////////////////////////

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    @Override
    public void setProcessDefinitionKey(string processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
    }

    @Override
    public string getProcessDefinitionName() {
        return processDefinitionName;
    }

    @Override
    public void setProcessDefinitionName(string processDefinitionName) {
        this.processDefinitionName = processDefinitionName;
    }

    @Override
    public Integer getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }

    @Override
    public void setProcessDefinitionVersion(Integer processDefinitionVersion) {
        this.processDefinitionVersion = processDefinitionVersion;
    }

    @Override
    public string getDeploymentId() {
        return deploymentId;
    }

    @Override
    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    // process instance /////////////////////////////////////////////////////////

    /** ensures initialization and returns the process instance. */
    @Override
    public ExecutionEntityImpl getProcessInstance() {
        ensureProcessInstanceInitialized();
        return processInstance;
    }

    protected void ensureProcessInstanceInitialized() {
        if ((processInstance is null) && (processInstanceId !is null)) {
            processInstance = (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(processInstanceId);
        }
    }

    @Override
    public void setProcessInstance(ExecutionEntity processInstance) {
        this.processInstance = (ExecutionEntityImpl) processInstance;
        if (processInstance !is null) {
            this.processInstanceId = this.processInstance.getId();
        }
    }

    @Override
    public bool isProcessInstanceType() {
        return parentId is null;
    }

    // parent ///////////////////////////////////////////////////////////////////

    /** ensures initialization and returns the parent */
    @Override
    public ExecutionEntityImpl getParent() {
        ensureParentInitialized();
        return parent;
    }

    protected void ensureParentInitialized() {
        if (parent is null && parentId !is null) {
            parent = (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(parentId);
        }
    }

    @Override
    public void setParent(ExecutionEntity parent) {
        this.parent = (ExecutionEntityImpl) parent;

        if (parent !is null) {
            this.parentId = parent.getId();
        } else {
            this.parentId = null;
        }
    }

    // super- and subprocess executions /////////////////////////////////////////

    @Override
    public string getSuperExecutionId() {
        return superExecutionId;
    }

    public void setSuperExecutionId(string superExecutionId) {
        this.superExecutionId = superExecutionId;
    }

    @Override
    public ExecutionEntityImpl getSuperExecution() {
        ensureSuperExecutionInitialized();
        return superExecution;
    }

    @Override
    public void setSuperExecution(ExecutionEntity superExecution) {
        this.superExecution = (ExecutionEntityImpl) superExecution;
        if (superExecution !is null) {
            superExecution.setSubProcessInstance(null);
        }

        if (superExecution !is null) {
            this.superExecutionId = ((ExecutionEntityImpl) superExecution).getId();
        } else {
            this.superExecutionId = null;
        }
    }

    protected void ensureSuperExecutionInitialized() {
        if (superExecution is null && superExecutionId !is null) {
            superExecution = (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(superExecutionId);
        }
    }

    @Override
    public ExecutionEntityImpl getSubProcessInstance() {
        ensureSubProcessInstanceInitialized();
        return subProcessInstance;
    }

    @Override
    public void setSubProcessInstance(ExecutionEntity subProcessInstance) {
        this.subProcessInstance = (ExecutionEntityImpl) subProcessInstance;
    }

    protected void ensureSubProcessInstanceInitialized() {
        if (subProcessInstance is null) {
            subProcessInstance = (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findSubProcessInstanceBySuperExecutionId(id);
        }
    }

    @Override
    public ExecutionEntity getRootProcessInstance() {
        ensureRootProcessInstanceInitialized();
        return rootProcessInstance;
    }

    protected void ensureRootProcessInstanceInitialized() {
        if (rootProcessInstance is null && rootProcessInstanceId !is null) {
            rootProcessInstance = (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(rootProcessInstanceId);
        }
    }

    @Override
    public void setRootProcessInstance(ExecutionEntity rootProcessInstance) {
        this.rootProcessInstance = (ExecutionEntityImpl) rootProcessInstance;

        if (rootProcessInstance !is null) {
            this.rootProcessInstanceId = rootProcessInstance.getId();
        } else {
            this.rootProcessInstanceId = null;
        }
    }

    @Override
    public string getRootProcessInstanceId() {
        return rootProcessInstanceId;
    }

    @Override
    public void setRootProcessInstanceId(string rootProcessInstanceId) {
        this.rootProcessInstanceId = rootProcessInstanceId;
    }

    // scopes ///////////////////////////////////////////////////////////////////

    @Override
    public bool isScope() {
        return isScope;
    }

    @Override
    public void setScope(bool isScope) {
        this.isScope = isScope;
    }

    @Override
    public void forceUpdate() {
        this.forcedUpdate = true;
    }

    // VariableScopeImpl methods //////////////////////////////////////////////////////////////////

    // TODO: this should ideally move to another place
    @Override
    protected void initializeVariableInstanceBackPointer(VariableInstanceEntity variableInstance) {
        if (processInstanceId !is null) {
            variableInstance.setProcessInstanceId(processInstanceId);
        } else {
            variableInstance.setProcessInstanceId(id);
        }
        variableInstance.setExecutionId(id);
        variableInstance.setProcessDefinitionId(processDefinitionId);
    }

    @Override
    protected void addLoggingSessionInfo(ObjectNode loggingNode) {
        BpmnLoggingSessionUtil.fillLoggingData(loggingNode, this);
    }

    @Override
    protected Collection<VariableInstanceEntity> loadVariableInstances() {
        return CommandContextUtil.getVariableService().findVariableInstancesByExecutionId(id);
    }

    @Override
    protected VariableScopeImpl getParentVariableScope() {
        return getParent();
    }

    @Override
    public void setVariable(string variableName, Object value, bool fetchAllVariables) {
        setVariable(variableName, value, this, fetchAllVariables);
    }

    @Override
    public void setVariable(string variableName, Object value, ExecutionEntity sourceExecution, bool fetchAllVariables) {

        if (fetchAllVariables) {

            // If it's in the cache, it's more recent
            if (usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(usedVariablesCache.get(variableName), value, sourceExecution);
            }

            // If the variable exists on this scope, replace it
            if (hasVariableLocal(variableName)) {
                setVariableLocal(variableName, value, sourceExecution, true);
                return;
            }

            // Otherwise, go up the hierarchy (we're trying to put it as high as possible)
            VariableScopeImpl parentVariableScope = getParentVariableScope();
            if (parentVariableScope !is null) {
                FlowElement localFlowElement = getCurrentFlowElement();
                if (localFlowElement !is null) {
                    ((ExecutionEntity) parentVariableScope).setOriginatingCurrentFlowElement(localFlowElement);
                }

                if (sourceExecution is null) {
                    parentVariableScope.setVariable(variableName, value);
                } else {
                    ((ExecutionEntity) parentVariableScope).setVariable(variableName, value, sourceExecution, true);
                }
                return;
            }

            // We're as high as possible and the variable doesn't exist yet, so we're creating it
            if (sourceExecution !is null) {
                createVariableLocal(variableName, value, sourceExecution);
            } else {
                createVariableLocal(variableName, value);
            }

        } else {

            // Check local cache first
            if (usedVariablesCache.containsKey(variableName)) {

                updateVariableInstance(usedVariablesCache.get(variableName), value, sourceExecution);

            } else if (variableInstances !is null && variableInstances.containsKey(variableName)) {

                updateVariableInstance(variableInstances.get(variableName), value, sourceExecution);

            } else {

                // Not in local cache, check if defined on this scope
                // Create it if it doesn't exist yet
                VariableInstanceEntity variable = getSpecificVariable(variableName);
                if (variable !is null) {
                    updateVariableInstance(variable, value, sourceExecution);
                    usedVariablesCache.put(variableName, variable);
                } else {

                    VariableScopeImpl parent = getParentVariableScope();
                    if (parent !is null) {
                        if (sourceExecution is null) {
                            parent.setVariable(variableName, value, fetchAllVariables);
                        } else {
                            ((ExecutionEntity) parent).setVariable(variableName, value, sourceExecution, fetchAllVariables);
                        }
                        return;
                    }

                    variable = createVariableInstance(variableName, value, sourceExecution);
                    usedVariablesCache.put(variableName, variable);
                }

            }

        }

    }

    @Override
    public Object setVariableLocal(string variableName, Object value, bool fetchAllVariables) {
        return setVariableLocal(variableName, value, this, fetchAllVariables);
    }

    @Override
    public Object setVariableLocal(string variableName, Object value, ExecutionEntity sourceExecution, bool fetchAllVariables) {
        if (fetchAllVariables) {

            // If it's in the cache, it's more recent
            if (usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(usedVariablesCache.get(variableName), value, sourceExecution);
            }

            ensureVariableInstancesInitialized();

            VariableInstanceEntity variableInstance = variableInstances.get(variableName);
            if (variableInstance is null) {
                variableInstance = usedVariablesCache.get(variableName);
            }

            if (variableInstance is null) {
                createVariableLocal(variableName, value, sourceExecution);
            } else {
                updateVariableInstance(variableInstance, value, sourceExecution);
            }

            return null;

        } else {

            if (usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(usedVariablesCache.get(variableName), value, sourceExecution);
            } else if (variableInstances !is null && variableInstances.containsKey(variableName)) {
                updateVariableInstance(variableInstances.get(variableName), value, sourceExecution);
            } else {

                VariableInstanceEntity variable = getSpecificVariable(variableName);
                if (variable !is null) {
                    updateVariableInstance(variable, value, sourceExecution);
                } else {
                    variable = createVariableInstance(variableName, value, sourceExecution);
                }
                usedVariablesCache.put(variableName, variable);

            }

            return null;

        }
    }

    @Override
    protected VariableInstanceEntity createVariableInstance(string variableName, Object value) {
        return createVariableInstance(variableName, value, this);
    }

    protected VariableInstanceEntity createVariableInstance(string variableName, Object value, ExecutionEntity sourceExecution) {
        VariableInstanceEntity variableInstance = super.createVariableInstance(variableName, value);

        CountingEntityUtil.handleInsertVariableInstanceEntityCount(variableInstance);

        Clock clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        // Record historic variable
        CommandContextUtil.getHistoryManager().recordVariableCreate(variableInstance, clock.getCurrentTime());

        // Record historic detail
        CommandContextUtil.getHistoryManager().recordHistoricDetailVariableCreate(variableInstance, sourceExecution, true,
            getRelatedActivityInstanceId(sourceExecution), clock.getCurrentTime());

        return variableInstance;
    }

    protected void createVariableLocal(string variableName, Object value, ExecutionEntity sourceActivityExecution) {
        ensureVariableInstancesInitialized();

        if (variableInstances.containsKey(variableName)) {
            throw new FlowableException("variable '" + variableName + "' already exists. Use setVariableLocal if you want to overwrite the value");
        }

        createVariableInstance(variableName, value, sourceActivityExecution);
    }

    @Override
    protected void updateVariableInstance(VariableInstanceEntity variableInstance, Object value) {
        updateVariableInstance(variableInstance, value, this);
    }

    protected void updateVariableInstance(VariableInstanceEntity variableInstance, Object value, ExecutionEntity sourceExecution) {
        super.updateVariableInstance(variableInstance, value);

        Clock clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        CommandContextUtil.getHistoryManager().recordHistoricDetailVariableCreate(variableInstance, sourceExecution, true,
            getRelatedActivityInstanceId(sourceExecution), clock.getCurrentTime());

        CommandContextUtil.getHistoryManager().recordVariableUpdate(variableInstance, clock.getCurrentTime());
    }

    @Override
    protected void deleteVariableInstanceForExplicitUserCall(VariableInstanceEntity variableInstance) {
        super.deleteVariableInstanceForExplicitUserCall(variableInstance);

        CountingEntityUtil.handleDeleteVariableInstanceEntityCount(variableInstance, true);

        Clock clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        // Record historic variable deletion
        CommandContextUtil.getHistoryManager().recordVariableRemoved(variableInstance);

        // Record historic detail
        CommandContextUtil.getHistoryManager().recordHistoricDetailVariableCreate(variableInstance, this, true,
            getRelatedActivityInstanceId(this), clock.getCurrentTime());
    }

    @Override
    protected bool isPropagateToHistoricVariable() {
        return false;
    }

    @Override
    protected VariableInstanceEntity getSpecificVariable(string variableName) {

        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        VariableInstanceEntity variableInstance = CommandContextUtil.getVariableService().findVariableInstanceByExecutionAndName(id, variableName);

        return variableInstance;
    }

    @Override
    protected List<VariableInstanceEntity> getSpecificVariables(Collection!string variableNames) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        return CommandContextUtil.getVariableService().findVariableInstancesByExecutionAndNames(id, variableNames);
    }

    // event subscription support //////////////////////////////////////////////

    @Override
    public List<EventSubscriptionEntity> getEventSubscriptions() {
        ensureEventSubscriptionsInitialized();
        return eventSubscriptions;
    }

    protected void ensureEventSubscriptionsInitialized() {
        if (eventSubscriptions is null) {
            eventSubscriptions = CommandContextUtil.getEventSubscriptionService().findEventSubscriptionsByExecution(id);
        }
    }

    // referenced job entities //////////////////////////////////////////////////

    @Override
    public List<JobEntity> getJobs() {
        ensureJobsInitialized();
        return jobs;
    }

    protected void ensureJobsInitialized() {
        if (jobs is null) {
            jobs = CommandContextUtil.getJobService().findJobsByExecutionId(id);
        }
    }

    @Override
    public List<TimerJobEntity> getTimerJobs() {
        ensureTimerJobsInitialized();
        return timerJobs;
    }

    protected void ensureTimerJobsInitialized() {
        if (timerJobs is null) {
            timerJobs = CommandContextUtil.getTimerJobService().findTimerJobsByExecutionId(id);
        }
    }

    // referenced task entities ///////////////////////////////////////////////////

    protected void ensureTasksInitialized() {
        if (tasks is null) {
            tasks = CommandContextUtil.getTaskService().findTasksByExecutionId(id);
        }
    }

    @Override
    public List<TaskEntity> getTasks() {
        ensureTasksInitialized();
        return tasks;
    }

    // identity links ///////////////////////////////////////////////////////////

    @Override
    public List<IdentityLinkEntity> getIdentityLinks() {
        ensureIdentityLinksInitialized();
        return identityLinks;
    }

    protected void ensureIdentityLinksInitialized() {
        if (identityLinks is null) {
            identityLinks = CommandContextUtil.getIdentityLinkService().findIdentityLinksByProcessInstanceId(id);
        }
    }

    // getters and setters //////////////////////////////////////////////////////

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getParentId() {
        return parentId;
    }

    @Override
    public void setParentId(string parentId) {
        this.parentId = parentId;
    }

    @Override
    public string getActivityId() {
        return activityId;
    }

    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }

    @Override
    public bool isConcurrent() {
        return isConcurrent;
    }

    @Override
    public void setConcurrent(bool isConcurrent) {
        this.isConcurrent = isConcurrent;
    }

    @Override
    public bool isActive() {
        return isActive;
    }

    @Override
    public void setActive(bool isActive) {
        this.isActive = isActive;
    }

    @Override
    public void inactivate() {
        this.isActive = false;
    }

    @Override
    public bool isEnded() {
        return isEnded;
    }

    @Override
    public void setEnded(bool isEnded) {
        this.isEnded = isEnded;
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
    public string getDeleteReason() {
        return deleteReason;
    }

    @Override
    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
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
    public bool isSuspended() {
        return suspensionState == SuspensionState.SUSPENDED.getStateCode();
    }

    @Override
    public bool isEventScope() {
        return isEventScope;
    }

    @Override
    public void setEventScope(bool isEventScope) {
        this.isEventScope = isEventScope;
    }

    @Override
    public bool isMultiInstanceRoot() {
        return isMultiInstanceRoot;
    }

    @Override
    public void setMultiInstanceRoot(bool isMultiInstanceRoot) {
        this.isMultiInstanceRoot = isMultiInstanceRoot;
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
    public string getCurrentActivityId() {
        return activityId;
    }

    @Override
    public string getName() {
        if (localizedName !is null && localizedName.length() > 0) {
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
    public string getDescription() {
        if (localizedDescription !is null && localizedDescription.length() > 0) {
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
    public string getLocalizedName() {
        return localizedName;
    }

    @Override
    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }

    @Override
    public string getLocalizedDescription() {
        return localizedDescription;
    }

    @Override
    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
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
    public Date getLockTime() {
        return lockTime;
    }

    @Override
    public void setLockTime(Date lockTime) {
        this.lockTime = lockTime;
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

        // The variables from the cache have precedence
        if (variableInstances !is null) {
            for (string variableName : variableInstances.keySet()) {
                variables.put(variableName, variableInstances.get(variableName).getValue());
            }
        }


        return variables;
    }

    public List<VariableInstanceEntity> getQueryVariables() {
        if (queryVariables is null && Context.getCommandContext() !is null) {
            queryVariables = new VariableInitializingList();
        }
        return queryVariables;
    }

    public void setQueryVariables(List<VariableInstanceEntity> queryVariables) {
        this.queryVariables = queryVariables;
    }

    public string getActivityName() {
        return activityName;
    }

    public string getCurrentActivityName() {
        return activityName;
    }

    @Override
    public string getStartActivityId() {
        return startActivityId;
    }

    @Override
    public void setStartActivityId(string startActivityId) {
        this.startActivityId = startActivityId;
    }

    @Override
    public string getStartUserId() {
        return startUserId;
    }

    @Override
    public void setStartUserId(string startUserId) {
        this.startUserId = startUserId;
    }

    @Override
    public Date getStartTime() {
        return startTime;
    }

    @Override
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    @Override
    public int getEventSubscriptionCount() {
        return eventSubscriptionCount;
    }

    @Override
    public void setEventSubscriptionCount(int eventSubscriptionCount) {
        this.eventSubscriptionCount = eventSubscriptionCount;
    }

    @Override
    public int getTaskCount() {
        return taskCount;
    }

    @Override
    public void setTaskCount(int taskCount) {
        this.taskCount = taskCount;
    }

    @Override
    public int getJobCount() {
        return jobCount;
    }

    @Override
    public void setJobCount(int jobCount) {
        this.jobCount = jobCount;
    }

    @Override
    public int getTimerJobCount() {
        return timerJobCount;
    }

    @Override
    public void setTimerJobCount(int timerJobCount) {
        this.timerJobCount = timerJobCount;
    }

    @Override
    public int getSuspendedJobCount() {
        return suspendedJobCount;
    }

    @Override
    public void setSuspendedJobCount(int suspendedJobCount) {
        this.suspendedJobCount = suspendedJobCount;
    }

    @Override
    public int getDeadLetterJobCount() {
        return deadLetterJobCount;
    }

    @Override
    public void setDeadLetterJobCount(int deadLetterJobCount) {
        this.deadLetterJobCount = deadLetterJobCount;
    }

    @Override
    public int getVariableCount() {
        return variableCount;
    }

    @Override
    public void setVariableCount(int variableCount) {
        this.variableCount = variableCount;
    }

    @Override
    public int getIdentityLinkCount() {
        return identityLinkCount;
    }

    @Override
    public void setIdentityLinkCount(int identityLinkCount) {
        this.identityLinkCount = identityLinkCount;
    }

    @Override
    public string getCallbackId() {
        return callbackId;
    }

    @Override
    public void setCallbackId(string callbackId) {
        this.callbackId = callbackId;
    }

    @Override
    public string getCallbackType() {
        return callbackType;
    }

    @Override
    public void setCallbackType(string callbackType) {
        this.callbackType = callbackType;
    }

    @Override
    public string getReferenceId() {
        return referenceId;
    }

    @Override
    public void setReferenceId(string referenceId) {
        this.referenceId = referenceId;
    }

    @Override
    public string getReferenceType() {
        return referenceType;
    }

    @Override
    public void setReferenceType(string referenceType) {
        this.referenceType = referenceType;
    }

    @Override
    public void setPropagatedStageInstanceId(string propagatedStageInstanceId) {
        this.propagatedStageInstanceId = propagatedStageInstanceId;
    }

    @Override
    public string getPropagatedStageInstanceId() {
        return propagatedStageInstanceId;
    }

    protected string getRelatedActivityInstanceId(ExecutionEntity sourceExecution) {
        string activityInstanceId = null;
        if (CommandContextUtil.getHistoryManager().isHistoryLevelAtLeast(HistoryLevel.FULL)) {
            ActivityInstanceEntity unfinishedActivityInstance = CommandContextUtil.getActivityInstanceEntityManager()
                .findUnfinishedActivityInstance(sourceExecution);
            if (unfinishedActivityInstance !is null) {
                activityInstanceId = unfinishedActivityInstance.getId();
            }
        }
        return activityInstanceId;
    }

    // toString /////////////////////////////////////////////////////////////////

    @Override
    public string toString() {
        if (isProcessInstanceType()) {
            return "ProcessInstance[" + getId() + "]";
        } else {
            StringBuilder strb = new StringBuilder();
            if (isScope) {
                strb.append("Scoped execution[ id '").append(getId());
            } else if (isMultiInstanceRoot) {
                strb.append("Multi instance root execution[ id '").append(getId());
            } else {
                strb.append("Execution[ id '").append(getId());
            }
            strb.append("' ]");

            if (activityId !is null) {
                strb.append(" - activity '").append(activityId).append("'");
            }
            if (parentId !is null) {
                strb.append(" - parent '").append(parentId).append("'");
            }
            return strb.toString();
        }
    }

}
