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

module flow.engine.impl.persistence.entity.ExecutionEntityManagerImpl;

import hunt.collection.ArrayList;
import hunt.collection;
//import hunt.Collections;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.constant.ReferenceTypes;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.scop.ScopeTypes;
//import flow.common.identity.Authentication;
import flow.common.interceptor.CommandContext;
//import flow.common.logging.LoggingSessionConstants;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.history.DeleteReason;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmmn.CaseInstanceService;
import flow.engine.impl.deleg.SubProcessActivityBehavior;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.CountingExecutionEntity;
import flow.engine.impl.persistence.entity.data.ExecutionDataManager;
import flow.engine.impl.runtime.callback.ProcessInstanceState;
//import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.EventUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.impl.util.TaskHelper;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;
import flow.entitylink.service.api.EntityLink;
import flow.entitylink.service.api.EntityLinkService;
import flow.entitylink.service.api.EntityLinkType;
//import org.flowable.entitylink.service.impl.persistence.entity.EntityLinkEntity;
//import flow.eventsubscription.service.EventSubscriptionService;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.identitylink.service.IdentityLinkService;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
//import flow.identitylink.service.impl.persistence.entity.data.impl.cachematcher.IdentityLinksByProcessInstanceMatcher;
import flow.job.service.JobService;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import flow.variable.service.api.persistence.entity.VariableInstance;
import flow.variable.service.impl.persistence.entity.VariableByteArrayRef;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import hunt.Exceptions;
import hunt.logging;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class ExecutionEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ExecutionEntity, ExecutionDataManager)
    , ExecutionEntityManager {


    this(ProcessEngineConfigurationImpl processEngineConfiguration, ExecutionDataManager executionDataManager) {
        super(processEngineConfiguration, executionDataManager);
    }

    // Overriding the default delete methods to set the 'isDeleted' flag

    override
    public void dele(ExecutionEntity entity) {
        dele(entity, true);
    }

    override
    public void dele(ExecutionEntity entity, bool fireDeleteEvent) {
        super.dele(entity, fireDeleteEvent);
        entity.setDeleted(true);
    }

    // FIND METHODS


    public ExecutionEntity findSubProcessInstanceBySuperExecutionId(string superExecutionId) {
        return dataManager.findSubProcessInstanceBySuperExecutionId(superExecutionId);
    }


    public List!ExecutionEntity findChildExecutionsByParentExecutionId(string parentExecutionId) {
        return dataManager.findChildExecutionsByParentExecutionId(parentExecutionId);
    }


    public List!ExecutionEntity findChildExecutionsByProcessInstanceId(string processInstanceId) {
        return dataManager.findChildExecutionsByProcessInstanceId(processInstanceId);
    }


    public List!ExecutionEntity findExecutionsByParentExecutionAndActivityIds( string parentExecutionId,  Collection!string activityIds) {
        return dataManager.findExecutionsByParentExecutionAndActivityIds(parentExecutionId, activityIds);
    }


    public long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery) {
        return dataManager.findExecutionCountByQueryCriteria(executionQuery);
    }


    public List!ExecutionEntity findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery) {
        return dataManager.findExecutionsByQueryCriteria(executionQuery);
    }


    public long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        return dataManager.findProcessInstanceCountByQueryCriteria(executionQuery);
    }


    public List!ProcessInstance findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        return dataManager.findProcessInstanceByQueryCriteria(executionQuery);
    }


    public ExecutionEntity findByRootProcessInstanceId(string rootProcessInstanceId) {
        List!ExecutionEntity executions = dataManager.findExecutionsByRootProcessInstanceId(rootProcessInstanceId);
        return processExecutionTree(rootProcessInstanceId, executions);

    }

    /**
     * Processes a collection of {@link ExecutionEntity} instances, which form on execution tree. All the executions share the same rootProcessInstanceId (which is provided). The return value will be
     * the root {@link ExecutionEntity} instance, with all child {@link ExecutionEntity} instances populated and set using the {@link ExecutionEntity} instances from the provided collections
     */
    protected ExecutionEntity processExecutionTree(string rootProcessInstanceId, List!ExecutionEntity executions) {
        ExecutionEntity rootExecution = null;

        // Collect executions
        Map!(string, ExecutionEntity) executionMap = new HashMap!(string, ExecutionEntity)(executions.size());
        foreach (ExecutionEntity executionEntity ; executions) {
            if (executionEntity.getId() == (rootProcessInstanceId)) {
                rootExecution = executionEntity;
            }
            executionMap.put(executionEntity.getId(), executionEntity);
        }

        // Set relationships
        foreach (ExecutionEntity executionEntity ; executions) {

            // Root process instance relationship
            if (executionEntity.getRootProcessInstanceId().length != 0) {
                executionEntity.setRootProcessInstance(executionMap.get(executionEntity.getRootProcessInstanceId()));
            }

            // Process instance relationship
            if (executionEntity.getProcessInstanceId().length != 0 ) {
                executionEntity.setProcessInstance(executionMap.get(executionEntity.getProcessInstanceId()));
            }

            // Parent - child relationship
            if (executionEntity.getParentId().length != 0) {
                ExecutionEntity parentExecutionEntity = executionMap.get(executionEntity.getParentId());
                executionEntity.setParent(parentExecutionEntity);
                parentExecutionEntity.addChildExecution(executionEntity);
            }

            // Super - sub execution relationship
            if (executionEntity.getSuperExecution() !is null) {
                ExecutionEntity superExecutionEntity = executionMap.get(executionEntity.getSuperExecutionId());
                executionEntity.setSuperExecution(superExecutionEntity);
                superExecutionEntity.setSubProcessInstance(executionEntity);
            }

        }
        return rootExecution;
    }


    public List!ProcessInstance findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        return dataManager.findProcessInstanceAndVariablesByQueryCriteria(executionQuery);
    }


    public Collection!ExecutionEntity findInactiveExecutionsByProcessInstanceId( string processInstanceId) {
        return dataManager.findInactiveExecutionsByProcessInstanceId(processInstanceId);
    }


    public Collection!ExecutionEntity findInactiveExecutionsByActivityIdAndProcessInstanceId( string activityId,  string processInstanceId) {
        return dataManager.findInactiveExecutionsByActivityIdAndProcessInstanceId(activityId, processInstanceId);
    }


    public List!Execution findExecutionsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findExecutionsByNativeQuery(parameterMap);
    }


    public List!ProcessInstance findProcessInstanceByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findProcessInstanceByNativeQuery(parameterMap);
    }


    public long findExecutionCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findExecutionCountByNativeQuery(parameterMap);
    }

    // CREATE METHODS


    public ExecutionEntity createProcessInstanceExecution(ProcessDefinition processDefinition, string predefinedProcessInstanceId,
            string businessKey, string processInstanceName,
            string callbackId, string callbackType, string referenceId, string referenceType,
            string propagatedStageInstanceId, string tenantId, string initiatorVariableName, string startActivityId) {

        ExecutionEntity processInstanceExecution = dataManager.create();

        if (CountingEntityUtil.isExecutionRelatedEntityCountEnabledGlobally()) {
            (cast(CountingExecutionEntity) processInstanceExecution).setCountEnabled(true);
        }

        if (predefinedProcessInstanceId.length != 0) {
            processInstanceExecution.setId(predefinedProcessInstanceId);
        }

        processInstanceExecution.setProcessDefinitionId(processDefinition.getId());
        processInstanceExecution.setProcessDefinitionKey(processDefinition.getKey());
        processInstanceExecution.setProcessDefinitionName(processDefinition.getName());
        processInstanceExecution.setProcessDefinitionVersion(processDefinition.getVersion());
        processInstanceExecution.setDeploymentId(processDefinition.getDeploymentId());
        processInstanceExecution.setBusinessKey(businessKey);
        processInstanceExecution.setName(processInstanceName);

        // Callbacks
        if (callbackId.length != 0) {
            processInstanceExecution.setCallbackId(callbackId);
        }
        if (callbackType.length != 0) {
            processInstanceExecution.setCallbackType(callbackType);
        }
        if (referenceId.length != 0) {
            processInstanceExecution.setReferenceId(referenceId);
        }
        if (referenceType.length != 0) {
            processInstanceExecution.setReferenceType(referenceType);
        }
        if (propagatedStageInstanceId.length != 0) {
            processInstanceExecution.setPropagatedStageInstanceId(propagatedStageInstanceId);
        }

        processInstanceExecution.setScope(true); // process instance is always a scope for all child executions

        // Inherit tenant id (if any)
        if (tenantId.length != 0) {
            processInstanceExecution.setTenantId(tenantId);
        }

       // string authenticatedUserId = Authentication.getAuthenticatedUserId();
        implementationMissing(false);
        processInstanceExecution.setStartActivityId(startActivityId);
        processInstanceExecution.setStartTime(CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime());
        processInstanceExecution.setStartUserId("authenticatedUserId");

        // Store in database
        insert(processInstanceExecution, false);

        if (initiatorVariableName !is null) {
            processInstanceExecution.setVariable(initiatorVariableName, authenticatedUserId);
        }

        // Need to be after insert, cause we need the id
        processInstanceExecution.setProcessInstanceId(processInstanceExecution.getId());
        processInstanceExecution.setRootProcessInstanceId(processInstanceExecution.getId());

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        if (processEngineConfiguration.getIdentityLinkInterceptor() !is null) {
            processEngineConfiguration.getIdentityLinkInterceptor().handleCreateProcessInstance(processInstanceExecution);
        }

        // Fire events
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, processInstanceExecution));
        }

        return processInstanceExecution;
    }

    /**
     * Creates a new execution. properties processDefinition, processInstance and activity will be initialized.
     */

    public ExecutionEntity createChildExecution(ExecutionEntity parentExecutionEntity) {
        ExecutionEntity childExecution = dataManager.create();
        inheritCommonProperties(parentExecutionEntity, childExecution);
        childExecution.setParent(parentExecutionEntity);
        childExecution.setProcessDefinitionId(parentExecutionEntity.getProcessDefinitionId());
        childExecution.setProcessDefinitionKey(parentExecutionEntity.getProcessDefinitionKey());
        childExecution.setProcessInstanceId(parentExecutionEntity.getProcessInstanceId() !is null
                ? parentExecutionEntity.getProcessInstanceId() : parentExecutionEntity.getId());
        childExecution.setScope(false);

        // manage the bidirectional parent-child relation
        parentExecutionEntity.addChildExecution(childExecution);

        // Insert the child execution
        insert(childExecution, false);


        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Child execution {} created with parent {}", childExecution, parentExecutionEntity.getId());
        //}

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, childExecution));
            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, childExecution));
        }

        return childExecution;
    }


    public ExecutionEntity createSubprocessInstance(ProcessDefinition processDefinition, ExecutionEntity superExecutionEntity,
                                                    string businessKey, string activityId) {

        ExecutionEntity subProcessInstance = dataManager.create();
        inheritCommonProperties(superExecutionEntity, subProcessInstance);
        subProcessInstance.setProcessDefinitionId(processDefinition.getId());
        subProcessInstance.setProcessDefinitionKey(processDefinition.getKey());
        subProcessInstance.setProcessDefinitionName(processDefinition.getName());
        subProcessInstance.setSuperExecution(superExecutionEntity);
        subProcessInstance.setRootProcessInstanceId(superExecutionEntity.getRootProcessInstanceId());
        subProcessInstance.setScope(true); // process instance is always a scope for all child executions

        implementationMissing(false);
        //string authenticatedUserId = Authentication.getAuthenticatedUserId();

        subProcessInstance.setStartActivityId(activityId);
        subProcessInstance.setStartUserId("authenticatedUserId");
        subProcessInstance.setBusinessKey(businessKey);

        // Store in database
        insert(subProcessInstance, false);

        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Child execution {} created with super execution {}", subProcessInstance, superExecutionEntity.getId());
        //}

        subProcessInstance.setProcessInstanceId(subProcessInstance.getId());
        superExecutionEntity.setSubProcessInstance(subProcessInstance);

        if (engineConfiguration.getIdentityLinkInterceptor() !is null) {
            engineConfiguration.getIdentityLinkInterceptor().handleCreateSubProcessInstance(subProcessInstance, superExecutionEntity);
        }

        engineConfiguration.getProcessInstanceHelper().processAvailableEventSubProcesses(subProcessInstance,
            ProcessDefinitionUtil.getProcess(processDefinition.getId()),CommandContextUtil.getCommandContext());

        FlowableEventDispatcher flowableEventDispatcher = engineConfiguration.getEventDispatcher();
        if (flowableEventDispatcher !is null && flowableEventDispatcher.isEnabled()) {
            flowableEventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, subProcessInstance));
        }

        return subProcessInstance;
    }

    protected void inheritCommonProperties(ExecutionEntity parentExecutionEntity, ExecutionEntity childExecution) {

        // Inherits the 'count' feature from the parent.
        // If the parent was not 'counting', we can't make the child 'counting' again.
        if (cast(CountingExecutionEntity)parentExecutionEntity !is null) {
            CountingExecutionEntity countingParentExecutionEntity = cast(CountingExecutionEntity) parentExecutionEntity;
            (cast(CountingExecutionEntity) childExecution).setCountEnabled(countingParentExecutionEntity.isCountEnabled());
        }

        // inherit the stage instance id, if present
        childExecution.setPropagatedStageInstanceId(parentExecutionEntity.getPropagatedStageInstanceId());

        childExecution.setRootProcessInstanceId(parentExecutionEntity.getRootProcessInstanceId());
        childExecution.setActive(true);
        childExecution.setStartTime(getClock().getCurrentTime());

        if (parentExecutionEntity.getTenantId() !is null) {
            childExecution.setTenantId(parentExecutionEntity.getTenantId());
        }

    }

    // UPDATE METHODS


    public void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateExecutionTenantIdForDeployment(deploymentId, newTenantId);
    }

    // DELETE METHODS


    public void deleteProcessInstancesByProcessDefinition(string processDefinitionId, string deleteReason, bool cascade) {
        List!string processInstanceIds = dataManager.findProcessInstanceIdsByProcessDefinitionId(processDefinitionId);

        foreach (string processInstanceId ; processInstanceIds) {
            deleteProcessInstanceCascade(findById(processInstanceId), deleteReason, cascade);
        }

        if (cascade) {
            getHistoryManager().recordDeleteHistoricProcessInstancesByProcessDefinitionId(processDefinitionId);
        }
    }


    public void deleteProcessInstance(string processInstanceId, string deleteReason, bool cascade) {
        ExecutionEntity processInstanceExecution = findById(processInstanceId);

        if (processInstanceExecution is null) {
            throw new FlowableObjectNotFoundException("No process instance found for id '" ~ processInstanceId ~ "'", typeid(ProcessInstance));
        }

        deleteProcessInstanceCascade(processInstanceExecution, deleteReason, cascade);

        // Special care needed for a process instance of a call activity: the parent process instance needs to be triggered for completion
        // This can't be added to the deleteProcessInstanceCascade method, as this will also trigger all child and/or multi-instance
        // process instances for child call activities, which shouldn't happen.
        if (processInstanceExecution.getSuperExecutionId() !is null) {
            ExecutionEntity superExecution = processInstanceExecution.getSuperExecution();
            if (superExecution !is null
                    && cast(FlowNode)(superExecution.getCurrentFlowElement()) !is null
                    && cast(SubProcessActivityBehavior)(cast(FlowNode) superExecution.getCurrentFlowElement()).getBehavior() !is null) {
                SubProcessActivityBehavior subProcessActivityBehavior = cast(SubProcessActivityBehavior) (cast(FlowNode) superExecution.getCurrentFlowElement()).getBehavior();
                try {
                    subProcessActivityBehavior.completing(superExecution, processInstanceExecution);
                    superExecution.setSubProcessInstance(null);
                    subProcessActivityBehavior.completed(superExecution);
                } catch (Exception e) {
                    throw new FlowableException("Could not complete parent process instance for call activity with process instance execution "
                                ~ processInstanceExecution.getId(), e);
                }
            }
        }
    }

    protected void deleteProcessInstanceCascade(ExecutionEntity execution, string deleteReason, bool deleteHistory) {

        // fill default reason if none provided
        if (deleteReason.length == 0) {
            deleteReason = DeleteReason.PROCESS_INSTANCE_DELETED;
        }
        getActivityInstanceEntityManager().deleteActivityInstancesByProcessInstanceId(execution.getId());

        List!ExecutionEntity childExecutions = collectChildren(execution.getProcessInstance());
        foreach (ExecutionEntity subExecutionEntity ; childExecutions) {
            if (subExecutionEntity.isMultiInstanceRoot()) {
                foreach (ExecutionEntity miExecutionEntity ; subExecutionEntity.getExecutions()) {
                    if (miExecutionEntity.getSubProcessInstance() !is null) {
                        deleteProcessInstanceCascade(miExecutionEntity.getSubProcessInstance(), deleteReason, deleteHistory);

                        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                            FlowElement callActivityElement = miExecutionEntity.getCurrentFlowElement();
                            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createActivityCancelledEvent(callActivityElement.getId(),
                                    callActivityElement.getName(), miExecutionEntity.getId(), miExecutionEntity.getProcessInstanceId(),
                                    miExecutionEntity.getProcessDefinitionId(), "callActivity", deleteReason));
                        }
                    }
                }

            } else if (subExecutionEntity.getSubProcessInstance() !is null) {
                deleteProcessInstanceCascade(subExecutionEntity.getSubProcessInstance(), deleteReason, deleteHistory);

                if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                    FlowElement callActivityElement = subExecutionEntity.getCurrentFlowElement();
                    getEventDispatcher().dispatchEvent(FlowableEventBuilder.createActivityCancelledEvent(callActivityElement.getId(),
                            callActivityElement.getName(), subExecutionEntity.getId(), subExecutionEntity.getProcessInstanceId(),
                            subExecutionEntity.getProcessDefinitionId(), "callActivity", deleteReason));
                }
            }
        }

        TaskHelper.deleteTasksByProcessInstanceId(execution.getId(), deleteReason, deleteHistory);

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableEventBuilder.createCancelledEvent(execution.getProcessInstanceId(),
                    execution.getProcessInstanceId(), execution.getProcessDefinitionId(), deleteReason));
        }

        // delete the execution BEFORE we delete the history, otherwise we will
        // produce orphan HistoricVariableInstance instances

        ExecutionEntity processInstanceExecutionEntity = execution.getProcessInstance();
        if (processInstanceExecutionEntity is null) {
            return;
        }

        for (int i = childExecutions.size() - 1; i >= 0; i--) {
            ExecutionEntity childExecutionEntity = childExecutions.get(i);
            deleteExecutionAndRelatedData(childExecutionEntity, deleteReason, deleteHistory);
        }

        deleteExecutionAndRelatedData(execution, deleteReason, deleteHistory);

        if (deleteHistory) {
            getHistoryManager().recordProcessInstanceDeleted(execution.getId(), execution.getProcessDefinitionId(), execution.getTenantId());
        }

        getHistoryManager().recordProcessInstanceEnd(processInstanceExecutionEntity, deleteReason, null, Date.now());
        processInstanceExecutionEntity.setDeleted(true);
    }


    public void deleteExecutionAndRelatedData(ExecutionEntity executionEntity, string deleteReason, bool deleteHistory, bool cancel, FlowElement cancelActivity) {
        if (!deleteHistory && executionEntity.isActive()
                && executionEntity.getCurrentFlowElement() !is null
                && !executionEntity.isMultiInstanceRoot()
                && cast(BoundaryEvent)(executionEntity.getCurrentFlowElement() is null)) {  // Boundary events will handle the history themselves (see TriggerExecutionOperation for example)

            CommandContextUtil.getActivityInstanceEntityManager().recordActivityEnd(executionEntity, deleteReason);
        }

        deleteRelatedDataForExecution(executionEntity, deleteReason);
        dele(executionEntity);

        if (cancel) {
            dispatchActivityCancelled(executionEntity, cancelActivity !is null ? cancelActivity : executionEntity.getCurrentFlowElement());
        }

        if (executionEntity.isProcessInstanceType() && executionEntity.getCallbackId() !is null) {
            CommandContext commandContext = CommandContextUtil.getCommandContext();
            ProcessInstanceHelper processInstanceHelper = CommandContextUtil.getProcessInstanceHelper(commandContext);
            if (cancel) {
                processInstanceHelper.callCaseInstanceStateChangeCallbacks(commandContext, executionEntity,
                        ProcessInstanceState.RUNNING, ProcessInstanceState.CANCELLED);
            } else {
                processInstanceHelper.callCaseInstanceStateChangeCallbacks(commandContext, executionEntity,
                        ProcessInstanceState.RUNNING, ProcessInstanceState.COMPLETED);
            }
        }
    }


    public void deleteExecutionAndRelatedData(ExecutionEntity executionEntity, string deleteReason, bool deleteHistory) {
        deleteExecutionAndRelatedData(executionEntity, deleteReason, deleteHistory, false, null);
    }


    public void deleteProcessInstanceExecutionEntity(string processInstanceId,
                                                     string currentFlowElementId,
                                                     string deleteReason,
                                                     bool cascade,
                                                     bool cancel,
                                                     bool fireEvents) {

        ExecutionEntity processInstanceEntity = findById(processInstanceId);

        if (processInstanceEntity is null) {
            throw new FlowableObjectNotFoundException("No process instance found for id '" ~ processInstanceId ~ "'", typeid(ProcessInstance));
        }

        if (processInstanceEntity.isDeleted()) {
            return;
        }

        // Call activities
        foreach (ExecutionEntity subExecutionEntity ; processInstanceEntity.getExecutions()) {
            if (subExecutionEntity.getSubProcessInstance() !is null && !subExecutionEntity.isEnded()) {
                deleteProcessInstanceCascade(subExecutionEntity.getSubProcessInstance(), deleteReason, cascade);

                if (getEventDispatcher() !is null && getEventDispatcher().isEnabled() && fireEvents) {
                    FlowElement callActivityElement = subExecutionEntity.getCurrentFlowElement();
                    getEventDispatcher().dispatchEvent(FlowableEventBuilder.createActivityCancelledEvent(callActivityElement.getId(),
                            callActivityElement.getName(), subExecutionEntity.getId(), processInstanceId, subExecutionEntity.getProcessDefinitionId(),
                            "callActivity", deleteReason));
                }
            }
        }

        // delete event scope executions
        foreach (ExecutionEntity childExecution ; processInstanceEntity.getExecutions()) {
            if (childExecution.isEventScope()) {
                deleteExecutionAndRelatedData(childExecution, null, cascade);
            }
        }

        deleteChildExecutions(processInstanceEntity, deleteReason, cancel);
        deleteExecutionAndRelatedData(processInstanceEntity, deleteReason, cascade);

        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled() && fireEvents) {
            if (!cancel) {
                getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.PROCESS_COMPLETED, processInstanceEntity));
            } else {
                getEventDispatcher().dispatchEvent(FlowableEventBuilder.createCancelledEvent(processInstanceEntity.getId(),
                        processInstanceEntity.getId(), processInstanceEntity.getProcessDefinitionId(), deleteReason));
            }
        }
        implementationMissing(false);
        //if (engineConfiguration.isLoggingSessionEnabled()) {
        //    BpmnLoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_PROCESS_COMPLETED, "Completed process instance with id " + processInstanceEntity.getId(), processInstanceEntity);
        //}

        getHistoryManager().recordProcessInstanceEnd(processInstanceEntity, deleteReason, currentFlowElementId, Date.now());
        processInstanceEntity.setDeleted(true);
    }


    public void deleteChildExecutions(ExecutionEntity executionEntity, string deleteReason, bool cancel) {
        deleteChildExecutions(executionEntity, null, null, deleteReason, cancel, null);
    }


    public void deleteChildExecutions(ExecutionEntity executionEntity, Collection!string executionIdsNotToDelete,
            Collection!string executionIdsNotToSendCancelledEventFor, string deleteReason, bool cancel, FlowElement cancelActivity) {

        // The children of an execution for a tree. For correct deletions (taking care of foreign keys between child-parent)
        // the leafs of this tree must be deleted first before the parents elements.

        List!ExecutionEntity childExecutions = collectChildren(executionEntity, executionIdsNotToDelete);
        for (int i = childExecutions.size() - 1; i >= 0; i--) {
            ExecutionEntity childExecutionEntity = childExecutions.get(i);
            if (!childExecutionEntity.isEnded()) {
                if (executionIdsNotToDelete is null || (executionIdsNotToDelete !is null && !executionIdsNotToDelete.contains(childExecutionEntity.getId()))) {

                    if (childExecutionEntity.isProcessInstanceType()) {
                        deleteProcessInstanceExecutionEntity(childExecutionEntity.getId(),
                                cancelActivity !is null ? cancelActivity.getId() : null, deleteReason, true, cancel, true);

                    } else {
                        if (cancel && (childExecutionEntity.isActive() || childExecutionEntity.isMultiInstanceRoot())
                                && (executionIdsNotToSendCancelledEventFor is null || !executionIdsNotToSendCancelledEventFor.contains(childExecutionEntity.getId())))
                            dispatchExecutionCancelled(childExecutionEntity,
                                    cancelActivity !is null ? cancelActivity : childExecutionEntity.getCurrentFlowElement());
                    }
                    deleteExecutionAndRelatedData(childExecutionEntity, deleteReason, false);
                }

            }
        }
    }


    public List!ExecutionEntity collectChildren(ExecutionEntity executionEntity) {
        return collectChildren(executionEntity, null);
    }

    protected List!ExecutionEntity collectChildren(ExecutionEntity executionEntity, Collection!string executionIdsToExclude) {
        List!ExecutionEntity childExecutions = new ArrayList!ExecutionEntity();
        collectChildren(executionEntity, childExecutions, executionIdsToExclude !is null ? executionIdsToExclude :emptyList!string);
        return childExecutions;
    }

    protected void collectChildren(ExecutionEntity executionEntity, List!ExecutionEntity collectedChildExecution, Collection!string executionIdsToExclude) {
        List!ExecutionEntity childExecutions = cast(List!ExecutionEntity) executionEntity.getExecutions();
        if (childExecutions !is null && childExecutions.size() > 0) {

            // Have a fixed ordering of child executions (important for the order in which events are sent)
            Collections.sort(childExecutions, ExecutionEntity.EXECUTION_ENTITY_START_TIME_ASC_COMPARATOR);

            foreach (ExecutionEntity childExecution ; childExecutions) {
                if (!executionIdsToExclude.contains(childExecution.getId())) {
                    if (!childExecution.isDeleted()) {
                        collectedChildExecution.add(childExecution);
                    }

                    collectChildren(childExecution, collectedChildExecution, executionIdsToExclude);
                }
            }
        }

        ExecutionEntity subProcessInstance = executionEntity.getSubProcessInstance();
        if (subProcessInstance !is null && !executionIdsToExclude.contains(subProcessInstance.getId())) {
            if (!subProcessInstance.isDeleted()) {
                collectedChildExecution.add(subProcessInstance);
            }

            collectChildren(subProcessInstance, collectedChildExecution, executionIdsToExclude);
        }
    }

    protected void dispatchExecutionCancelled(ExecutionEntity execution, FlowElement cancelActivity) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

        // subprocesses
        foreach (ExecutionEntity subExecution ; executionEntityManager.findChildExecutionsByParentExecutionId(execution.getId())) {
            dispatchExecutionCancelled(subExecution, cancelActivity);
        }

        // call activities
        ExecutionEntity subProcessInstance = CommandContextUtil.getExecutionEntityManager().findSubProcessInstanceBySuperExecutionId(execution.getId());
        if (subProcessInstance !is null) {
            dispatchExecutionCancelled(subProcessInstance, cancelActivity);
        }

        // activity with message/signal boundary events
        FlowElement currentFlowElement = execution.getCurrentFlowElement();
        if (cast(FlowNode)currentFlowElement !is null) {

            if (execution.isMultiInstanceRoot()) {
                dispatchMultiInstanceActivityCancelled(execution, cancelActivity);
            }
            else {
                dispatchActivityCancelled(execution, cancelActivity);
            }
        }
    }

    protected void dispatchActivityCancelled(ExecutionEntity execution, FlowElement cancelActivity) {
        CommandContextUtil.getProcessEngineConfiguration()
                .getEventDispatcher()
                .dispatchEvent(
                        FlowableEventBuilder.createActivityCancelledEvent(execution.getCurrentFlowElement().getId(),
                                execution.getCurrentFlowElement().getName(), execution.getId(), execution.getProcessInstanceId(),
                                execution.getProcessDefinitionId(), getActivityType(cast(FlowNode) execution.getCurrentFlowElement()), cancelActivity));
    }

    protected void dispatchMultiInstanceActivityCancelled(ExecutionEntity execution, FlowElement cancelActivity) {
        CommandContextUtil.getProcessEngineConfiguration()
                .getEventDispatcher()
                .dispatchEvent(
                        FlowableEventBuilder.createMultiInstanceActivityCancelledEvent(execution.getCurrentFlowElement().getId(),
                                execution.getCurrentFlowElement().getName(), execution.getId(), execution.getProcessInstanceId(),
                                execution.getProcessDefinitionId(), getActivityType(cast(FlowNode) execution.getCurrentFlowElement()), cancelActivity));
    }

    protected string getActivityType(FlowNode flowNode) {
        implementationMissing(false);
        return "";
        //string elementType = flowNode.getClass().getSimpleName();
        //elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        //return elementType;
    }


    public ExecutionEntity findFirstScope(ExecutionEntity executionEntity) {
        ExecutionEntity currentExecutionEntity = executionEntity;
        while (currentExecutionEntity !is null) {
            if (currentExecutionEntity.isScope()) {
                return currentExecutionEntity;
            }

            ExecutionEntity parentExecutionEntity = currentExecutionEntity.getParent();
            if (parentExecutionEntity is null) {
                parentExecutionEntity = currentExecutionEntity.getSuperExecution();
            }
            currentExecutionEntity = parentExecutionEntity;
        }
        return null;
    }


    public ExecutionEntity findFirstMultiInstanceRoot(ExecutionEntity executionEntity) {
        ExecutionEntity currentExecutionEntity = executionEntity;
        while (currentExecutionEntity !is null) {
            if (currentExecutionEntity.isMultiInstanceRoot()) {
                return currentExecutionEntity;
            }

            ExecutionEntity parentExecutionEntity = currentExecutionEntity.getParent();
            if (parentExecutionEntity is null) {
                parentExecutionEntity = currentExecutionEntity.getSuperExecution();
            }
            currentExecutionEntity = parentExecutionEntity;
        }
        return null;
    }

    //protected CachedEntityMatcher!IdentityLinkEntity identityLinkByProcessInstanceMatcher = new IdentityLinksByProcessInstanceMatcher();


    public void deleteRelatedDataForExecution(ExecutionEntity executionEntity, string deleteReason) {

        // To start, deactivate the current incoming execution
        executionEntity.setEnded(true);
        executionEntity.setActive(false);

        CommandContext commandContext = CommandContextUtil.getCommandContext();
        bool enableExecutionRelationshipCounts = CountingEntityUtil.isExecutionRelatedEntityCountEnabled(executionEntity);

        // If event dispatching is disabled, related entities can be deleted in bulk. Otherwise, they need to be fetched
        // and events need to be sent for each of them separately (the bulk delete still happens).
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration(commandContext).getEventDispatcher();
        bool eventDispatcherEnabled = eventDispatcher !is null && eventDispatcher.isEnabled();

        deleteIdentityLinks(executionEntity, commandContext, eventDispatcherEnabled);
        deleteEntityLinks(executionEntity, commandContext, eventDispatcherEnabled);
        deleteVariables(executionEntity, commandContext, enableExecutionRelationshipCounts, eventDispatcherEnabled);
        deleteUserTasks(executionEntity, deleteReason, commandContext, enableExecutionRelationshipCounts, eventDispatcherEnabled);
        deleteJobs(executionEntity, commandContext, enableExecutionRelationshipCounts, eventDispatcherEnabled);
        deleteEventSubScriptions(executionEntity, enableExecutionRelationshipCounts, eventDispatcherEnabled);
        deleteActivityInstances(executionEntity, commandContext);
        deleteSubCases(executionEntity, commandContext);
    }

    protected void deleteSubCases(ExecutionEntity executionEntity, CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        CaseInstanceService caseInstanceService = processEngineConfiguration.getCaseInstanceService();
        if (caseInstanceService !is null) {
            if (executionEntity.getReferenceId().length != 0 && ReferenceTypes.EXECUTION_CHILD_CASE.equals(executionEntity.getReferenceType())) {
                caseInstanceService.deleteCaseInstance(executionEntity.getReferenceId());
            } else if (cast(CaseServiceTask)executionEntity.getCurrentFlowElement() !is null) {
                // backwards compatibility in case there is no reference
                // (cases created before the double reference in the execution) was added
                caseInstanceService.deleteCaseInstancesForExecutionId(executionEntity.getId());
            }
        }
    }

    protected void deleteActivityInstances(ExecutionEntity executionEntity, CommandContext commandContext) {
        if (executionEntity.isProcessInstanceType()) {
            CommandContextUtil.getActivityInstanceEntityManager(commandContext).deleteActivityInstancesByProcessInstanceId(executionEntity.getId());
        }
    }

    protected void deleteIdentityLinks(ExecutionEntity executionEntity, CommandContext commandContext, bool eventDispatcherEnabled) {
        if (executionEntity.isProcessInstanceType()) {
            IdentityLinkService identityLinkService = CommandContextUtil.getIdentityLinkService(commandContext);
            bool deleteIdentityLinks = true;
            if (eventDispatcherEnabled) {
                Collection!IdentityLinkEntity identityLinks = identityLinkService.findIdentityLinksByProcessInstanceId(executionEntity.getId());
                foreach (IdentityLinkEntity identityLink ; identityLinks) {
                    fireEntityDeletedEvent(identityLink);
                }
                deleteIdentityLinks = !identityLinks.isEmpty();
            }

            if (deleteIdentityLinks) {
                identityLinkService.deleteIdentityLinksByProcessInstanceId(executionEntity.getId());
            }
        }
    }

    protected void deleteEntityLinks(ExecutionEntity executionEntity, CommandContext commandContext, bool eventDispatcherEnabled) {
        implementationMissing(false);
        //if (engineConfiguration.isEnableEntityLinks() && executionEntity.isProcessInstanceType()) {
        //    EntityLinkService entityLinkService = CommandContextUtil.getEntityLinkService(commandContext);
        //    bool deleteEntityLinks = true;
        //    if (eventDispatcherEnabled) {
        //        List!EntityLink entityLinks = entityLinkService.findEntityLinksByScopeIdAndType(
        //                        executionEntity.getId(), ScopeTypes.BPMN, EntityLinkType.CHILD);
        //        foreach (EntityLink entityLink ; entityLinks) {
        //            fireEntityDeletedEvent(cast(EntityLinkEntity) entityLink);
        //        }
        //        deleteEntityLinks = !entityLinks.isEmpty();
        //    }
        //
        //    if (deleteEntityLinks) {
        //        entityLinkService.deleteEntityLinksByScopeIdAndType(executionEntity.getId(), ScopeTypes.BPMN);
        //    }
        //}
    }

    protected void deleteVariables(ExecutionEntity executionEntity, CommandContext commandContext, bool enableExecutionRelationshipCounts, bool eventDispatcherEnabled) {
        if (!enableExecutionRelationshipCounts ||
                (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getVariableCount() > 0)) {

            Collection!VariableInstance executionVariables = executionEntity.getVariableInstancesLocal().values();
            if (!executionVariables.isEmpty()) {

                ArrayList!VariableByteArrayRef variableByteArrayRefs = new ArrayList!VariableByteArrayRef();
                foreach (VariableInstance variableInstance ; executionVariables) {
                    if (cast(VariableInstanceEntity)variableInstance !is null) {
                        VariableInstanceEntity variableInstanceEntity = cast(VariableInstanceEntity) variableInstance;

                        if (variableInstanceEntity.getByteArrayRef() !is null && variableInstanceEntity.getByteArrayRef().getId().length != 0) {
                            variableByteArrayRefs.add(variableInstanceEntity.getByteArrayRef());
                        }

                        if (eventDispatcherEnabled) {
                            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
                            if (eventDispatcher !is null) {
                                eventDispatcher.dispatchEvent(EventUtil.createVariableDeleteEvent(variableInstanceEntity));
                                eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, variableInstance));
                            }
                        }
                    }
                }

                // First byte arrays that reference variable, then variables in bulk
                foreach (VariableByteArrayRef variableByteArrayRef ; variableByteArrayRefs) {
                    getByteArrayEntityManager().deleteByteArrayById(variableByteArrayRef.getId());
                }

                CommandContextUtil.getVariableService(commandContext).deleteVariablesByExecutionId(executionEntity.getId());
            }
        }
    }

    protected void deleteUserTasks(ExecutionEntity executionEntity, string deleteReason, CommandContext commandContext,
            bool enableExecutionRelationshipCounts, bool eventDispatcherEnabled) {
        if (!enableExecutionRelationshipCounts ||
                (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getTaskCount() > 0)) {
            TaskHelper.deleteTasksForExecution(executionEntity,
                    CommandContextUtil.getTaskService(commandContext).findTasksByExecutionId(executionEntity.getId()), deleteReason);
        }
    }

    protected void deleteJobs(ExecutionEntity executionEntity, CommandContext commandContext, bool enableExecutionRelationshipCounts, bool eventDispatcherEnabled) {

        // Jobs have byte array references that don't store the execution id.
        // This means a bulk delete is not done for jobs. Generally there aren't many jobs / execution either.

        if (!enableExecutionRelationshipCounts
                || (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getTimerJobCount() > 0)) {
            CommandContextUtil.getTimerJobService().deleteTimerJobsByExecutionId(executionEntity.getId());
        }

        JobService jobService = CommandContextUtil.getJobService();
        if (!enableExecutionRelationshipCounts
                || (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getJobCount() > 0)) {
            jobService.deleteJobsByExecutionId(executionEntity.getId());
        }

        if (!enableExecutionRelationshipCounts
                || (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getSuspendedJobCount() > 0)) {
            jobService.deleteSuspendedJobsByExecutionId(executionEntity.getId());
        }

        if (!enableExecutionRelationshipCounts
                || (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getDeadLetterJobCount() > 0)) {
            jobService.deleteDeadLetterJobsByExecutionId(executionEntity.getId());
        }
    }

    protected void deleteEventSubScriptions(ExecutionEntity executionEntity, bool enableExecutionRelationshipCounts, bool eventDispatcherEnabled) {
        implementationMissing(false);

      //if (!enableExecutionRelationshipCounts
        //        || (enableExecutionRelationshipCounts && (cast(CountingExecutionEntity) executionEntity).getEventSubscriptionCount() > 0)) {
        //
        //    EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
        //
        //    bool deleteEventSubscriptions = true;
        //    if (eventDispatcherEnabled) {
        //        List!EventSubscriptionEntity eventSubscriptions = eventSubscriptionService.findEventSubscriptionsByExecution(executionEntity.getId());
        //        for (EventSubscriptionEntity eventSubscription : eventSubscriptions) {
        //
        //            fireEntityDeletedEvent(eventSubscription);
        //            if (MessageEventSubscriptionEntity.EVENT_TYPE.equals(eventSubscription.getEventType())) {
        //                getEventDispatcher().dispatchEvent(FlowableEventBuilder.createMessageEvent(FlowableEngineEventType.ACTIVITY_MESSAGE_CANCELLED,
        //                        eventSubscription.getActivityId(), eventSubscription.getEventName(), null, eventSubscription.getExecutionId(),
        //                        eventSubscription.getProcessInstanceId(), eventSubscription.getProcessDefinitionId()));
        //            }
        //        }
        //
        //        deleteEventSubscriptions = !eventSubscriptions.isEmpty();
        //    }
        //
        //    if (deleteEventSubscriptions) {
        //        eventSubscriptionService.deleteEventSubscriptionsByExecutionId(executionEntity.getId());
        //    }
        //}
    }

    // OTHER METHODS


    public void updateProcessInstanceLockTime(string processInstanceId) {
         implementationMissing(false);
        //Date expirationTime = Date.now();
        //int lockMillis = getAsyncExecutor().getAsyncJobLockTimeInMillis();
        //
        //GregorianCalendar lockCal = new GregorianCalendar();
        //lockCal.setTime(expirationTime);
        //lockCal.add(Calendar.MILLISECOND, lockMillis);
        //Date lockDate = lockCal.getTime();
        //
        //dataManager.updateProcessInstanceLockTime(processInstanceId, lockDate, expirationTime);
    }


    public void clearProcessInstanceLockTime(string processInstanceId) {
        dataManager.clearProcessInstanceLockTime(processInstanceId);
    }


    public string updateProcessInstanceBusinessKey(ExecutionEntity executionEntity, string businessKey) {
        if (executionEntity.isProcessInstanceType() && businessKey !is null) {
            executionEntity.setBusinessKey(businessKey);
            getHistoryManager().updateProcessBusinessKeyInHistory(executionEntity);

            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, executionEntity));
            }

            return businessKey;
        }
        return null;
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

    protected AsyncExecutor getAsyncExecutor() {
        return engineConfiguration.getAsyncExecutor();
    }

    protected ByteArrayEntityManager getByteArrayEntityManager() {
        return engineConfiguration.getByteArrayEntityManager();
    }

    protected ActivityInstanceEntityManager getActivityInstanceEntityManager() {
        return engineConfiguration.getActivityInstanceEntityManager();
    }

}
