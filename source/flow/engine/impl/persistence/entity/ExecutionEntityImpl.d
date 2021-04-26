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

import flow.common.persistence.entity.Entity;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowableListener;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.db.SuspensionState;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.CommandContext;
import flow.common.runtime.Clockm;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.impl.persistence.CountingExecutionEntity;
//import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.variable.service.impl.persistence.entity.VariableInitializingList;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.VariableScopeImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.AbstractBpmnEngineVariableScopeEntity;
import flow.bpmn.model.Process;
//import com.fasterxml.jackson.databind.node.ObjectNode;
import hunt.entity;
import hunt.Exceptions;
import hunt.String;
import hunt.Integer;
import hunt.Long;
import hunt.Boolean;
import flow.engine.deleg.DelegateExecution;
/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */
@Table("ACT_RU_EXECUTION")
class ExecutionEntityImpl : AbstractBpmnEngineVariableScopeEntity , Model, ExecutionEntity, CountingExecutionEntity {

    // current position /////////////////////////////////////////////////////////
    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("REV_")
    int rev;

    /** The tenant identifier (if any) */
    @Column("TENANT_ID_")
    string tenantId  ;//= ProcessEngineConfiguration.NO_TENANT_ID;

    @Column("NAME_")
    string name;


    @Column("LOCK_TIME_")
    long lockTime;

    // state/type of execution //////////////////////////////////////////////////

    @Column("IS_ACTIVE_")
    int _isActive = 0;

    @Column("IS_SCOPE_")
    int _isScope = 0;

    @Column("IS_CONCURRENT_")
    int _isConcurrent;

    @Column("IS_EVENT_SCOPE_")
    int _isEventScope;

    @Column("IS_MI_ROOT_")
    int _isMultiInstanceRoot;

    @Column("IS_COUNT_ENABLED_")
    int _isCountEnabled;

    @Column("SUSPENSION_STATE_")
    int suspensionState ;// = SuspensionState.ACTIVE.getStateCode();

    @Column("START_ACT_ID_")
    string startActivityId;

    @Column("START_USER_ID_")
    string startUserId;

    @Column("START_TIME_")
    long startTime;

    // CountingExecutionEntity
    @Column("EVT_SUBSCR_COUNT_")
    int eventSubscriptionCount;

    @Column("TASK_COUNT_")
    int taskCount;

    @Column("JOB_COUNT_")
    int jobCount;

    @Column("TIMER_JOB_COUNT_")
    int timerJobCount;

    @Column("SUSP_JOB_COUNT_")
    int suspendedJobCount;

    @Column("DEADLETTER_JOB_COUNT_")
    int deadLetterJobCount;

    @Column("VAR_COUNT_")
    int variableCount;

    @Column("ID_LINK_COUNT_")
    int identityLinkCount;

    /**
     * Persisted reference to the processDefinition.
     *
     * @see #processDefinition
     * @see #setProcessDefinition(ProcessDefinitionImpl)
     * @see #getProcessDefinition()
     */
    @Column("PROC_DEF_ID_")
    string processDefinitionId;



    /**
     * Persisted reference to the current position in the diagram within the {@link #processDefinition}.
     *
     * @see #activity
     * @see #setActivity(ActivityImpl)
     * @see #getActivity()
     */
    @Column("ACT_ID_")
    string activityId;

    /**
     * The name of the current activity position
     */


    /**
     * Persisted reference to the process instance.
     *
     * @see #getProcessInstance()
     */

    @Column("PROC_INST_ID_")
    string processInstanceId = null;

    /**
     * Persisted reference to the business key.
     */
    @Column("BUSINESS_KEY_")
    string businessKey;

    /**
     * Persisted reference to the parent of this execution.
     *
     * @see #getParent()
     * @see #setParentId(string)
     */
    @Column("PARENT_ID_")
    string parentId;

    /**
     * Persisted reference to the super execution of this execution
     *
     * @see #getSuperExecution()
     * @see #setSuperExecution(ExecutionEntityImpl)
     */
    @Column("SUPER_EXEC_")
    string superExecutionId;

    @Column("ROOT_PROC_INST_ID_")
    string rootProcessInstanceId;

    // Callback
    @Column("CALLBACK_ID_")
    string callbackId;

    @Column("CALLBACK_TYPE_")
    string callbackType;

    // Reference
    @Column("REFERENCE_ID_")
    string referenceId;

    @Column("REFERENCE_TYPE_")
    string referenceType;

    /**
     * The optional stage instance id, if this execution runs in the context of a CMMN case and has a parent stage it belongs to.
     */
    @Column("PROPAGATED_STAGE_INST_ID_")
    string propagatedStageInstanceId;



    private FlowElement currentFlowElement;
    private FlowableListener currentListener; // Only set when executing an execution listener

    private FlowElement originatingCurrentFlowElement;

    /**
     * the process instance. this is the root of the execution tree. the processInstance of a process instance is a self reference.
     */
    private ExecutionEntityImpl processInstance;

    /** the parent execution */
    private ExecutionEntityImpl parent;

    /** nested executions representing scopes or concurrent paths */
    private List!ExecutionEntityImpl executions;

    /** super execution, not-null if this execution is part of a subprocess */
    private ExecutionEntityImpl superExecution;

    /** reference to a subprocessinstance, not-null if currently subprocess is started from this execution */
    private ExecutionEntityImpl subProcessInstance;

    private ExecutionEntityImpl rootProcessInstance;

    private bool forcedUpdate;

    private List!VariableInstanceEntity queryVariables;

    private string activityName;

        /**
     * Persisted reference to the process definition key.
     */
    private string processDefinitionKey;

    /**
     * Persisted reference to the process definition name.
     */
    private string processDefinitionName;

    /**
     * persisted reference to the process definition version.
     */
    private int processDefinitionVersion;

    /**
     * Persisted reference to the deployment id.
     */
    private string deploymentId;


      // events ///////////////////////////////////////////////////////////////////

    // TODO: still needed in v6?

    private string eventName;

    private string deleteReason;

    private bool _isEnded;


    private string description;
    private string localizedName;
    private string localizedDescription;

    // associated entities /////////////////////////////////////////////////////

    // (we cache associated entities here to minimize db queries)
    //private List!EventSubscriptionEntity eventSubscriptions;
    private List!JobEntity jobs;
    private List!TimerJobEntity timerJobs;
    private List!TaskEntity tasks;
    private List!IdentityLinkEntity identityLinks;

    // cascade deletion ////////////////////////////////////////////////////////

    this() {
      tenantId = ProcessEngineConfiguration.NO_TENANT_ID;
      suspensionState = ACTIVE.getStateCode();
      rev = 1;
    }

    string getId()
    {
        return id;
    }


    void setId(string id)
    {
        this.id = id;
    }

    /**
     * Static factory method: to be used when a new execution is created for the very first time/ Calling this will make sure no extra db fetches are needed later on, as all collections will be
     * populated with empty collections. If they would be null, it would trigger a database fetch for those relationship entities.
     */
    public static ExecutionEntityImpl createWithEmptyRelationshipCollections() {
        ExecutionEntityImpl execution = new ExecutionEntityImpl();
        execution.executions = new ArrayList!ExecutionEntityImpl(1);
        execution.tasks = new ArrayList!TaskEntity(1);
        Map!(string, VariableInstanceEntity) tmp =  execution.variableInstances; // = new HashMap!(string, VariableInstanceEntity)(1);
        tmp = new HashMap!(string, VariableInstanceEntity)(1);
        execution.jobs = new ArrayList!JobEntity(1);
        execution.timerJobs = new ArrayList!TimerJobEntity(1);
        //execution.eventSubscriptions = new ArrayList<>(1);
        execution.identityLinks = new ArrayList!IdentityLinkEntity(1);
        return execution;
    }

    // persistent state /////////////////////////////////////////////////////////

    public Object getPersistentState() {
        Map!(string, Object) persistentState = new HashMap!(string, Object)();
        persistentState.put("processDefinitionId", new String(processDefinitionId));
        persistentState.put("businessKey", new String(businessKey));
        persistentState.put("activityId", new String(activityId));
        persistentState.put("isActive", new Boolean(isActive));
        persistentState.put("isConcurrent", new Boolean(isConcurrent));
        persistentState.put("isScope", new Boolean(isScope));
        persistentState.put("isEventScope", new Boolean(isEventScope));
        persistentState.put("parentId", new String(parentId));
        persistentState.put("name", new String(name));
        persistentState.put("lockTime", new Long(lockTime));
        persistentState.put("superExecution", new String(superExecutionId));
        persistentState.put("rootProcessInstanceId", new String(rootProcessInstanceId));
        persistentState.put("isMultiInstanceRoot", new Boolean(isMultiInstanceRoot));
        if (forcedUpdate) {
            persistentState.put("forcedUpdate", Boolean.TRUE);
        }
        persistentState.put("suspensionState", new Integer(suspensionState));
        persistentState.put("startActivityId", new String(startActivityId));
        persistentState.put("startTime", new Long(startTime));
        persistentState.put("startUserId", new String(startUserId));
        persistentState.put("isCountEnabled", new Boolean(isCountEnabled));
        persistentState.put("eventSubscriptionCount", new Integer(eventSubscriptionCount));
        persistentState.put("taskCount",new Integer(taskCount));
        persistentState.put("jobCount", new Integer(jobCount));
        persistentState.put("timerJobCount", new Integer(timerJobCount));
        persistentState.put("suspendedJobCount", new Integer(suspendedJobCount));
        persistentState.put("deadLetterJobCount", new Integer(deadLetterJobCount));
        persistentState.put("variableCount", new Integer(variableCount));
        persistentState.put("identityLinkCount", new Integer(identityLinkCount));
        persistentState.put("callbackId", new String(callbackId));
        persistentState.put("callbackType", new String(callbackType));
        persistentState.put("referenceId", new String(referenceId));
        persistentState.put("referenceType", new String(referenceType));
        persistentState.put("propagatedStageInstanceId",new String(propagatedStageInstanceId));
        return cast(Object)persistentState;
    }

    // The current flow element, will be filled during operation execution

    public FlowElement getCurrentFlowElement() {
        if (currentFlowElement is null) {
            string processDefinitionId = getProcessDefinitionId();
            if (processDefinitionId !is null) {
                flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
                currentFlowElement = process.getFlowElement(getCurrentActivityId(), true);
            }
        }
        return currentFlowElement;
    }

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

    public FlowableListener getCurrentFlowableListener() {
        return currentListener;
    }

    public void setCurrentFlowableListener(FlowableListener currentListener) {
        this.currentListener = currentListener;
    }


    public FlowElement getOriginatingCurrentFlowElement() {
        return originatingCurrentFlowElement;
    }


    public void setOriginatingCurrentFlowElement(FlowElement flowElement) {
        this.originatingCurrentFlowElement = flowElement;
    }

    // executions ///////////////////////////////////////////////////////////////

    /** ensures initialization and returns the non-null executions list */

    public List!ExecutionEntity getExecutionEntities() {
        ensureExecutionsInitialized();
        List!ExecutionEntity list = new ArrayList!ExecutionEntity;
        foreach(ExecutionEntityImpl e ; executions)
        {
            list.add(cast(ExecutionEntity)e);
        }
        return list;
    }

    public List!DelegateExecution getExecutions() {
      ensureExecutionsInitialized();
      List!DelegateExecution list = new ArrayList!DelegateExecution;
      foreach(ExecutionEntityImpl e ; executions)
      {
        list.add(cast(DelegateExecution)e);
      }
      return list;
    }

    public void addChildExecution(ExecutionEntity executionEntity) {
        ensureExecutionsInitialized();
        executions.remove(cast(ExecutionEntityImpl)executionEntity);
        executions.add(cast(ExecutionEntityImpl) executionEntity);
    }

    protected void ensureExecutionsInitialized() {
        if (executions is null) {
            this.executions = cast(List!ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findChildExecutionsByParentExecutionId(id);
        }
    }

    // business key ////////////////////////////////////////////////////////////


    public string getBusinessKey() {
        return businessKey;
    }


    public void setBusinessKey(string businessKey) {
        this.businessKey = businessKey;
    }


    public string getProcessInstanceBusinessKey() {
        return getProcessInstance().getBusinessKey();
    }

    // process definition ///////////////////////////////////////////////////////


    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }


    public string getProcessDefinitionId() {
        return processDefinitionId;
    }


    public string getProcessDefinitionKey() {
        return processDefinitionKey;
    }


    public void setProcessDefinitionKey(string processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
    }


    public string getProcessDefinitionName() {
        return processDefinitionName;
    }


    public void setProcessDefinitionName(string processDefinitionName) {
        this.processDefinitionName = processDefinitionName;
    }


    public int getProcessDefinitionVersion() {
        return processDefinitionVersion;
    }


    public void setProcessDefinitionVersion(int processDefinitionVersion) {
        this.processDefinitionVersion = processDefinitionVersion;
    }


    public string getDeploymentId() {
        return deploymentId;
    }


    public void setDeploymentId(string deploymentId) {
        this.deploymentId = deploymentId;
    }

    // process instance /////////////////////////////////////////////////////////

    /** ensures initialization and returns the process instance. */

    public ExecutionEntityImpl getProcessInstance() {
        ensureProcessInstanceInitialized();
        return processInstance;
    }

    protected void ensureProcessInstanceInitialized() {
        if ((processInstance is null) && (processInstanceId !is null)) {
            processInstance = cast(ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(processInstanceId);
        }
    }


    public void setProcessInstance(ExecutionEntity processInstance) {
        this.processInstance = cast(ExecutionEntityImpl) processInstance;
        if (processInstance !is null) {
            this.processInstanceId = this.processInstance.getId().length == 0 ? null : this.processInstance.getId();
        }
    }


    public bool isProcessInstanceType() {
        return parentId is null || parentId.length == 0;
    }

    // parent ///////////////////////////////////////////////////////////////////

    /** ensures initialization and returns the parent */

    public ExecutionEntityImpl getParent() {
        ensureParentInitialized();
        return parent;
    }

    protected void ensureParentInitialized() {
        if (parent is null && parentId !is null) {
            parent = cast(ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(parentId);
        }
    }


    public void setParent(ExecutionEntity parent) {
        this.parent = cast(ExecutionEntityImpl) parent;

        if (parent !is null) {
            this.parentId = parent.getId();
        } else {
            this.parentId = null;
        }
    }

    // super- and subprocess executions /////////////////////////////////////////


    public string getSuperExecutionId() {
        return superExecutionId;
    }

    public void setSuperExecutionId(string superExecutionId) {
        this.superExecutionId = superExecutionId;
    }


    public ExecutionEntityImpl getSuperExecution() {
        ensureSuperExecutionInitialized();
        return superExecution;
    }


    public void setSuperExecution(ExecutionEntity superExecution) {
        this.superExecution = cast(ExecutionEntityImpl) superExecution;
        if (superExecution !is null) {
            superExecution.setSubProcessInstance(null);
        }

        if (superExecution !is null) {
            this.superExecutionId = (cast(ExecutionEntityImpl) superExecution).getId();
        } else {
            this.superExecutionId = null;
        }
    }

    protected void ensureSuperExecutionInitialized() {
        if (superExecution is null && superExecutionId.length != 0) {
            superExecution = cast(ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(superExecutionId);
        }
    }


    public ExecutionEntityImpl getSubProcessInstance() {
        ensureSubProcessInstanceInitialized();
        return subProcessInstance;
    }


    public void setSubProcessInstance(ExecutionEntity subProcessInstance) {
        this.subProcessInstance = cast(ExecutionEntityImpl) subProcessInstance;
    }

    protected void ensureSubProcessInstanceInitialized() {
        if (subProcessInstance is null) {
            subProcessInstance = cast (ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findSubProcessInstanceBySuperExecutionId(id);
        }
    }


    public ExecutionEntity getRootProcessInstance() {
        ensureRootProcessInstanceInitialized();
        return rootProcessInstance;
    }

    protected void ensureRootProcessInstanceInitialized() {
        if (rootProcessInstance is null && rootProcessInstanceId.length != 0) {
            rootProcessInstance = cast(ExecutionEntityImpl) CommandContextUtil.getExecutionEntityManager().findById(rootProcessInstanceId);
        }
    }


    public void setRootProcessInstance(ExecutionEntity rootProcessInstance) {
        this.rootProcessInstance = cast(ExecutionEntityImpl) rootProcessInstance;

        if (rootProcessInstance !is null) {
            this.rootProcessInstanceId = rootProcessInstance.getId();
        } else {
            this.rootProcessInstanceId = null;
        }
    }


    public string getRootProcessInstanceId() {
        return rootProcessInstanceId;
    }


    public void setRootProcessInstanceId(string rootProcessInstanceId) {
        this.rootProcessInstanceId = rootProcessInstanceId;
    }

    // scopes ///////////////////////////////////////////////////////////////////


    public bool isScope() {
        return _isScope == 0? false : true;
    }


    public void setScope(bool isScope) {
        this._isScope = isScope ? 1 : 0;
    }


    public void forceUpdate() {
        this.forcedUpdate = true;
    }

    // VariableScopeImpl methods //////////////////////////////////////////////////////////////////

    // TODO: this should ideally move to another place
    override
    protected void initializeVariableInstanceBackPointer(VariableInstanceEntity variableInstance) {
        if (processInstanceId !is null) {
            variableInstance.setProcessInstanceId(processInstanceId);
        } else {
            variableInstance.setProcessInstanceId(id);
        }
        variableInstance.setExecutionId(id);
        variableInstance.setProcessDefinitionId(processDefinitionId);
    }


    //protected void addLoggingSessionInfo(ObjectNode loggingNode) {
    //    BpmnLoggingSessionUtil.fillLoggingData(loggingNode, this);
    //}

    override
    protected Collection!VariableInstanceEntity loadVariableInstances() {
        return CommandContextUtil.getVariableService().findVariableInstancesByExecutionId(id);
    }

    override
    public VariableScopeImpl getParentVariableScope() {
        return getParent();
    }

    override
    public void setVariable(string variableName, Object value, bool fetchAllVariables) {
        setVariable(variableName, value, this, fetchAllVariables);
    }


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
                    (cast(ExecutionEntity) parentVariableScope).setOriginatingCurrentFlowElement(localFlowElement);
                }

                if (sourceExecution is null) {
                    parentVariableScope.setVariable(variableName, value);
                } else {
                    (cast(ExecutionEntity) parentVariableScope).setVariable(variableName, value, sourceExecution, true);
                }
                return;
            }

            // We're as high as possible and the variable doesn't exist yet, so we're creating it
            if (sourceExecution !is null) {
                createVariableLocal(variableName, value, sourceExecution);
            } else {
                super.createVariableLocal(variableName, value);
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
                            (cast(ExecutionEntity) parent).setVariable(variableName, value, sourceExecution, fetchAllVariables);
                        }
                        return;
                    }

                    variable = createVariableInstance(variableName, value, sourceExecution);
                    usedVariablesCache.put(variableName, variable);
                }

            }

        }

    }

    override
    public Object setVariableLocal(string variableName, Object value, bool fetchAllVariables) {
        return setVariableLocal(variableName, value, this, fetchAllVariables);
    }


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

    override
    protected VariableInstanceEntity createVariableInstance(string variableName, Object value) {
        return createVariableInstance(variableName, value, this);
    }

    protected VariableInstanceEntity createVariableInstance(string variableName, Object value, ExecutionEntity sourceExecution) {
        VariableInstanceEntity variableInstance = super.createVariableInstance(variableName, value);

        CountingEntityUtil.handleInsertVariableInstanceEntityCount(variableInstance);

        Clockm clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
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
            throw new FlowableException("variable '" ~ variableName ~ "' already exists. Use setVariableLocal if you want to overwrite the value");
        }

        createVariableInstance(variableName, value, sourceActivityExecution);
    }

    override
    protected void updateVariableInstance(VariableInstanceEntity variableInstance, Object value) {
        updateVariableInstance(variableInstance, value, this);
    }

    protected void updateVariableInstance(VariableInstanceEntity variableInstance, Object value, ExecutionEntity sourceExecution) {
        super.updateVariableInstance(variableInstance, value);

        Clockm clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        CommandContextUtil.getHistoryManager().recordHistoricDetailVariableCreate(variableInstance, sourceExecution, true,
            getRelatedActivityInstanceId(sourceExecution), clock.getCurrentTime());

        CommandContextUtil.getHistoryManager().recordVariableUpdate(variableInstance, clock.getCurrentTime());
    }

    override
    protected void deleteVariableInstanceForExplicitUserCall(VariableInstanceEntity variableInstance) {
        super.deleteVariableInstanceForExplicitUserCall(variableInstance);

        CountingEntityUtil.handleDeleteVariableInstanceEntityCount(variableInstance, true);

        Clockm clock = CommandContextUtil.getProcessEngineConfiguration().getClock();
        // Record historic variable deletion
        CommandContextUtil.getHistoryManager().recordVariableRemoved(variableInstance);

        // Record historic detail
        CommandContextUtil.getHistoryManager().recordHistoricDetailVariableCreate(variableInstance, this, true,
            getRelatedActivityInstanceId(this), clock.getCurrentTime());
    }

    override
    protected bool isPropagateToHistoricVariable() {
        return false;
    }

    override
    protected VariableInstanceEntity getSpecificVariable(string variableName) {

        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        VariableInstanceEntity variableInstance = CommandContextUtil.getVariableService().findVariableInstanceByExecutionAndName(id, variableName);

        return variableInstance;
    }

    override
    protected List!VariableInstanceEntity getSpecificVariables(Collection!string variableNames) {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext is null) {
            throw new FlowableException("lazy loading outside command context");
        }
        return CommandContextUtil.getVariableService().findVariableInstancesByExecutionAndNames(id, variableNames);
    }

    // event subscription support //////////////////////////////////////////////


    //public List!EventSubscriptionEntity getEventSubscriptions() {
    //    ensureEventSubscriptionsInitialized();
    //    return eventSubscriptions;
    //}

    //protected void ensureEventSubscriptionsInitialized() {
    //    if (eventSubscriptions is null) {
    //        eventSubscriptions = CommandContextUtil.getEventSubscriptionService().findEventSubscriptionsByExecution(id);
    //    }
    //}

    // referenced job entities //////////////////////////////////////////////////


    public List!JobEntity getJobs() {
        ensureJobsInitialized();
        return jobs;
    }

    protected void ensureJobsInitialized() {
        if (jobs is null) {
            jobs = CommandContextUtil.getJobService().findJobsByExecutionId(id);
        }
    }


    public List!TimerJobEntity getTimerJobs() {
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


    public List!TaskEntity getTasks() {
        ensureTasksInitialized();
        return tasks;
    }

    // identity links ///////////////////////////////////////////////////////////


    public List!IdentityLinkEntity getIdentityLinks() {
        ensureIdentityLinksInitialized();
        return identityLinks;
    }

    protected void ensureIdentityLinksInitialized() {
        if (identityLinks is null) {
            identityLinks = CommandContextUtil.getIdentityLinkService().findIdentityLinksByProcessInstanceId(id);
        }
    }

    // getters and setters //////////////////////////////////////////////////////


    public string getProcessInstanceId() {
        return processInstanceId;
    }


    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId.length == 0? null : processInstanceId;
    }


    public string getParentId() {
        return parentId;
    }


    public void setParentId(string parentId) {
        this.parentId = parentId;
    }


    public string getActivityId() {
        return activityId;
    }

    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }


    public bool isConcurrent() {
        return _isConcurrent == 0 ? false : true;
    }


    public void setConcurrent(bool isConcurrent) {
        this._isConcurrent = isConcurrent? 1 : 0;
    }


    public bool isActive() {
        return _isActive == 0 ? false : true;
    }


    public void setActive(bool isActive) {
        this._isActive = isActive ? 1 : 0;
    }


    public void inactivate() {
        this._isActive = 0;
    }


    public bool isEnded() {
        return _isEnded;
    }


    public void setEnded(bool isEnded) {
        this._isEnded = isEnded;
    }


    public string getEventName() {
        return eventName;
    }


    public void setEventName(string eventName) {
        this.eventName = eventName;
    }


    public string getDeleteReason() {
        return deleteReason;
    }


    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
    }


    public int getSuspensionState() {
        return suspensionState;
    }


    public void setSuspensionState(int suspensionState) {
        this.suspensionState = suspensionState;
    }


    public bool isSuspended() {
        return suspensionState == SUSPENDED.getStateCode();
    }


    public bool isEventScope() {
        return _isEventScope == 0 ? false : true;
    }


    public void setEventScope(bool isEventScope) {
        this._isEventScope = isEventScope ? 1 : 0;
    }


    public bool isMultiInstanceRoot() {
        return _isMultiInstanceRoot == 0 ? false : true;
    }


    public void setMultiInstanceRoot(bool isMultiInstanceRoot) {
        this._isMultiInstanceRoot = isMultiInstanceRoot? 1:0;
    }


    public bool isCountEnabled() {
        return _isCountEnabled == 0 ? false : true;
    }


    public void setCountEnabled(bool isCountEnabled) {
        this._isCountEnabled = isCountEnabled ? 1:0;
    }


    public string getCurrentActivityId() {
        return activityId;
    }


    public string getName() {
        if (localizedName !is null && localizedName.length > 0) {
            return localizedName;
        } else {
            return name;
        }
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getDescription() {
        if (localizedDescription !is null && localizedDescription.length > 0) {
            return localizedDescription;
        } else {
            return description;
        }
    }


    public void setDescription(string description) {
        this.description = description;
    }


    public string getLocalizedName() {
        return localizedName;
    }


    public void setLocalizedName(string localizedName) {
        this.localizedName = localizedName;
    }


    public string getLocalizedDescription() {
        return localizedDescription;
    }


    public void setLocalizedDescription(string localizedDescription) {
        this.localizedDescription = localizedDescription;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }


    public Date getLockTime() {
        return Date.ofEpochMilli(lockTime*1000);
    }


    public void setLockTime(Date lockTime) {
        this.lockTime = lockTime.toEpochMilli / 1000;
    }


    public Map!(string, Object) getProcessVariables() {
        Map!(string, Object) variables = new HashMap!(string, Object)();

        if (queryVariables !is null) {
            foreach (VariableInstanceEntity variableInstance ; queryVariables) {
                if (variableInstance.getId().length != 0 && variableInstance.getTaskId().length == 0) {
                    variables.put(variableInstance.getName(), variableInstance.getValue());
                }
            }
        }

        // The variables from the cache have precedence
        if (variableInstances !is null) {
            foreach (MapEntry!(string, VariableInstanceEntity) variableName ; variableInstances) {
                variables.put(variableName.getKey(), variableInstances.get(variableName.getKey()).getValue());
            }
        }


        return variables;
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

    public string getActivityName() {
        return activityName;
    }

    public string getCurrentActivityName() {
        return activityName;
    }


    public string getStartActivityId() {
        return startActivityId;
    }


    public void setStartActivityId(string startActivityId) {
        this.startActivityId = startActivityId;
    }


    public string getStartUserId() {
        return startUserId;
    }


    public void setStartUserId(string startUserId) {
        this.startUserId = startUserId;
    }


    public Date getStartTime() {
        return Date.ofEpochMilli(startTime*1000);
    }


    public void setStartTime(Date startTime) {
        this.startTime = startTime.toEpochMilli / 1000;
    }


    public int getEventSubscriptionCount() {
        return eventSubscriptionCount;
    }


    public void setEventSubscriptionCount(int eventSubscriptionCount) {
        this.eventSubscriptionCount = eventSubscriptionCount;
    }


    public int getTaskCount() {
        return taskCount;
    }


    public void setTaskCount(int taskCount) {
        this.taskCount = taskCount;
    }


    public int getJobCount() {
        return jobCount;
    }


    public void setJobCount(int jobCount) {
        this.jobCount = jobCount;
    }


    public int getTimerJobCount() {
        return timerJobCount;
    }


    public void setTimerJobCount(int timerJobCount) {
        this.timerJobCount = timerJobCount;
    }


    public int getSuspendedJobCount() {
        return suspendedJobCount;
    }


    public void setSuspendedJobCount(int suspendedJobCount) {
        this.suspendedJobCount = suspendedJobCount;
    }


    public int getDeadLetterJobCount() {
        return deadLetterJobCount;
    }


    public void setDeadLetterJobCount(int deadLetterJobCount) {
        this.deadLetterJobCount = deadLetterJobCount;
    }


    public int getVariableCount() {
        return variableCount;
    }


    public void setVariableCount(int variableCount) {
        this.variableCount = variableCount;
    }


    public int getIdentityLinkCount() {
        return identityLinkCount;
    }


    public void setIdentityLinkCount(int identityLinkCount) {
        this.identityLinkCount = identityLinkCount;
    }


    public string getCallbackId() {
        return callbackId;
    }


    public void setCallbackId(string callbackId) {
        this.callbackId = callbackId;
    }


    public string getCallbackType() {
        return callbackType;
    }


    public void setCallbackType(string callbackType) {
        this.callbackType = callbackType;
    }


    public string getReferenceId() {
        return referenceId;
    }


    public void setReferenceId(string referenceId) {
        this.referenceId = referenceId;
    }


    public string getReferenceType() {
        return referenceType;
    }


    public void setReferenceType(string referenceType) {
        this.referenceType = referenceType;
    }


    public void setPropagatedStageInstanceId(string propagatedStageInstanceId) {
        this.propagatedStageInstanceId = propagatedStageInstanceId;
    }


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


    override
    public string toString() {
        return "";
        //if (isProcessInstanceType()) {
        //    return "ProcessInstance[" + getId() + "]";
        //} else {
        //    StringBuilder strb = new StringBuilder();
        //    if (isScope) {
        //        strb.append("Scoped execution[ id '").append(getId());
        //    } else if (isMultiInstanceRoot) {
        //        strb.append("Multi instance root execution[ id '").append(getId());
        //    } else {
        //        strb.append("Execution[ id '").append(getId());
        //    }
        //    strb.append("' ]");
        //
        //    if (activityId !is null) {
        //        strb.append(" - activity '").append(activityId).append("'");
        //    }
        //    if (parentId !is null) {
        //        strb.append(" - parent '").append(parentId).append("'");
        //    }
        //    return strb.toString();
        //}
    }

  override
  string getIdPrefix()
  {
    return super.getIdPrefix;
  }

  override
  bool isInserted()
  {
    return super.isInserted();
  }

  override
  void setInserted(bool inserted)
  {
    return super.setInserted(inserted);
  }

  override
  bool isUpdated()
  {
    return super.isUpdated;
  }

  override
  void setUpdated(bool updated)
  {
    super.setUpdated(updated);
  }

  override
  bool isDeleted()
  {
    return super.isDeleted;
  }

  override
  void setDeleted(bool deleted)
  {
    super.setDeleted(deleted);
  }

  override
  Object getOriginalPersistentState()
  {
    return super.getOriginalPersistentState;
  }

  override
  void setOriginalPersistentState(Object persistentState)
  {
    super.setOriginalPersistentState(persistentState);
  }

  override
  void setRevision(int revision)
  {
      super.setRevision(revision);
  }

  override
  int getRevision()
  {
      return super.getRevision;
  }


  override
  int getRevisionNext()
  {
      return super.getRevisionNext;
  }

  override size_t toHash() { return 0 - hashOf(this.id); }

  override bool opEquals(Object o)
  {
    ExecutionEntityImpl foo = cast(ExecutionEntityImpl) o;
    return foo && this.id == foo.getId;
  }

  //int opCmp(Object o)
  //{
  //  return cast(int)(hashOf(this.id) - hashOf((cast(ExecutionEntityImpl)o).getId));
  //}
}
