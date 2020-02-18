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
//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.engine.delegate.event.impl.FlowableEventBuilder; 
 
 
 


import java.util.Map;

import org.flowable.bpmn.model.Activity;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableExceptionEvent;
import flow.common.event.FlowableEngineEventImpl;
import flow.engine.delegate.DelegateExecution;
import flow.engine.delegate.event.FlowableActivityCancelledEvent;
import flow.engine.delegate.event.FlowableActivityEvent;
import flow.engine.delegate.event.FlowableCancelledEvent;
import flow.engine.delegate.event.FlowableConditionalEvent;
import flow.engine.delegate.event.FlowableEntityWithVariablesEvent;
import flow.engine.delegate.event.FlowableErrorEvent;
import flow.engine.delegate.event.FlowableEscalationEvent;
import flow.engine.delegate.event.FlowableJobRescheduledEvent;
import flow.engine.delegate.event.FlowableMessageEvent;
import flow.engine.delegate.event.FlowableMultiInstanceActivityCancelledEvent;
import flow.engine.delegate.event.FlowableMultiInstanceActivityCompletedEvent;
import flow.engine.delegate.event.FlowableMultiInstanceActivityEvent;
import flow.engine.delegate.event.FlowableProcessStartedEvent;
import flow.engine.delegate.event.FlowableProcessTerminatedEvent;
import flow.engine.delegate.event.FlowableSequenceFlowTakenEvent;
import flow.engine.delegate.event.FlowableSignalEvent;
import flow.engine.impl.context.ExecutionContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;
import org.flowable.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import org.flowable.job.api.Job;
import org.flowable.task.api.Task;
import org.flowable.variable.api.event.FlowableVariableEvent;
import org.flowable.variable.api.types.VariableType;

/**
 * Builder class used to create {@link FlowableEvent} implementations.
 *
 * @author Frederik Heremans
 */
class FlowableEventBuilder {

    /**
     * @param type
     *            type of event
     * @return an {@link FlowableEvent} that doesn't have it's execution context-fields filled, as the event is a global event, independent of any running execution.
     */
    public static FlowableEvent createGlobalEvent(FlowableEngineEventType type) {
        FlowableEngineEventImpl newEvent = new FlowableProcessEventImpl(type);
        return newEvent;
    }

    public static FlowableEvent createEvent(FlowableEngineEventType type, string executionId, string processInstanceId, string processDefinitionId) {
        FlowableEngineEventImpl newEvent = new FlowableProcessEventImpl(type);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @return an {@link FlowableEntityEvent}. In case an {@link ExecutionContext} is active, the execution related event fields will be populated. If not, execution details will be retrieved from the
     *         {@link Object} if possible.
     */
    public static FlowableEntityEvent createEntityEvent(FlowableEngineEventType type, Object entity) {
        FlowableEntityEventImpl newEvent = new FlowableEntityEventImpl(entity, type);

        // In case an execution-context is active, populate the event fields
        // related to the execution
        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    /**
     * @param entity
     *            the entity this event targets
     * @param variables
     *            the variables associated with this entity
     * @return an {@link FlowableEntityEvent}. In case an {@link ExecutionContext} is active, the execution related event fields will be populated. If not, execution details will be retrieved from the
     *         {@link Object} if possible.
     */
    @SuppressWarnings("rawtypes")
    public static FlowableProcessStartedEvent createProcessStartedEvent(final Object entity,
            final Map variables, final bool localScope) {
        final FlowableProcessStartedEventImpl newEvent = new FlowableProcessStartedEventImpl(entity, variables, localScope);

        // In case an execution-context is active, populate the event fields related to the execution
        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @param variables
     *            the variables associated with this entity
     * @return an {@link FlowableEntityEvent}. In case an {@link ExecutionContext} is active, the execution related event fields will be populated. If not, execution details will be retrieved from the
     *         {@link Object} if possible.
     */
    @SuppressWarnings("rawtypes")
    public static FlowableEntityWithVariablesEvent createEntityWithVariablesEvent(FlowableEngineEventType type, Object entity, Map variables, bool localScope) {
        FlowableEntityWithVariablesEventImpl newEvent = new FlowableEntityWithVariablesEventImpl(entity, variables, localScope, type);

        // In case an execution-context is active, populate the event fields
        // related to the execution
        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param newJob
     *            the new job that was created due to the reschedule
     * @param originalJobId
     *            the job id of the original job that was rescheduled
     * @return an {@link FlowableEntityEvent}. In case an {@link ExecutionContext} is active, the execution related event fields will be populated. If not, execution details will be retrieved from the
     *         {@link Object} if possible.
     */
    public static FlowableJobRescheduledEvent createJobRescheduledEvent(FlowableEngineEventType type, Job newJob, string originalJobId) {
        FlowableJobRescheduledEventImpl newEvent = new FlowableJobRescheduledEventImpl(newJob, originalJobId, type);

        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    public static FlowableSequenceFlowTakenEvent createSequenceFlowTakenEvent(ExecutionEntity executionEntity, FlowableEngineEventType type,
            string sequenceFlowId, string sourceActivityId, string sourceActivityName, string sourceActivityType, Object sourceActivityBehavior,
            string targetActivityId, string targetActivityName, string targetActivityType, Object targetActivityBehavior) {

        FlowableSequenceFlowTakenEventImpl newEvent = new FlowableSequenceFlowTakenEventImpl(type);

        if (executionEntity !is null) {
            newEvent.setExecutionId(executionEntity.getId());
            newEvent.setProcessInstanceId(executionEntity.getProcessInstanceId());
            newEvent.setProcessDefinitionId(executionEntity.getProcessDefinitionId());
        }

        newEvent.setId(sequenceFlowId);
        newEvent.setSourceActivityId(sourceActivityId);
        newEvent.setSourceActivityName(sourceActivityName);
        newEvent.setSourceActivityType(sourceActivityType);
        newEvent.setSourceActivityBehaviorClass(sourceActivityBehavior !is null ? sourceActivityBehavior.getClass().getCanonicalName() : null);
        newEvent.setTargetActivityId(targetActivityId);
        newEvent.setTargetActivityName(targetActivityName);
        newEvent.setTargetActivityType(targetActivityType);
        newEvent.setTargetActivityBehaviorClass(targetActivityBehavior !is null ? targetActivityBehavior.getClass().getCanonicalName() : null);

        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @return an {@link FlowableEntityEvent}
     */
    public static FlowableEntityEvent createEntityEvent(FlowableEngineEventType type, Object entity, string executionId, string processInstanceId, string processDefinitionId) {
        FlowableEntityEventImpl newEvent = new FlowableEntityEventImpl(entity, type);

        newEvent.setExecutionId(executionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @param cause
     *            the cause of the event
     * @return an {@link FlowableEntityEvent} that is also instance of {@link FlowableExceptionEvent}. In case an {@link ExecutionContext} is active, the execution related event fields will be
     *         populated.
     */
    public static FlowableEntityEvent createEntityExceptionEvent(FlowableEngineEventType type, Object entity, Throwable cause) {
        FlowableEntityExceptionEventImpl newEvent = new FlowableEntityExceptionEventImpl(entity, type, cause);

        // In case an execution-context is active, populate the event fields
        // related to the execution
        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @param cause
     *            the cause of the event
     * @return an {@link FlowableEntityEvent} that is also instance of {@link FlowableExceptionEvent}.
     */
    public static FlowableEntityEvent createEntityExceptionEvent(FlowableEngineEventType type, Object entity, Throwable cause, string executionId, string processInstanceId, string processDefinitionId) {
        FlowableEntityExceptionEventImpl newEvent = new FlowableEntityExceptionEventImpl(entity, type, cause);

        newEvent.setExecutionId(executionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        return newEvent;
    }

    public static FlowableActivityEvent createActivityEvent(FlowableEngineEventType type, string activityId, string activityName, string executionId,
            string processInstanceId, string processDefinitionId, FlowElement flowElement) {

        FlowableActivityEventImpl newEvent = new FlowableActivityEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setActivityName(activityName);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);

        if (flowElement instanceof FlowNode) {
            FlowNode flowNode = (FlowNode) flowElement;
            newEvent.setActivityType(parseActivityType(flowNode));
            Object behaviour = flowNode.getBehavior();
            if (behaviour !is null) {
                newEvent.setBehaviorClass(behaviour.getClass().getCanonicalName());
            }
        }

        return newEvent;
    }

    public static FlowableMultiInstanceActivityEvent createMultiInstanceActivityEvent(FlowableEngineEventType type, string activityId, string activityName,
            string executionId, string processInstanceId, string processDefinitionId, FlowElement flowElement) {

        FlowableMultiInstanceActivityEventImpl newEvent = new FlowableMultiInstanceActivityEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setActivityName(activityName);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);

        if (flowElement instanceof FlowNode) {
            FlowNode flowNode = (FlowNode) flowElement;
            newEvent.setActivityType(parseActivityType(flowNode));
            Object behaviour = flowNode.getBehavior();
            if (behaviour !is null) {
                newEvent.setBehaviorClass(behaviour.getClass().getCanonicalName());
            }

            newEvent.setSequential(((Activity) flowNode).getLoopCharacteristics().isSequential());
        }

        return newEvent;
    }

    public static FlowableMultiInstanceActivityCompletedEvent createMultiInstanceActivityCompletedEvent(FlowableEngineEventType type, int numberOfInstances,
            int numberOfActiveInstances, int numberOfCompletedInstances, string activityId, string activityName, string executionId, string processInstanceId,
            string processDefinitionId, FlowElement flowElement) {

        FlowableMultiInstanceActivityCompletedEventImpl newEvent = new FlowableMultiInstanceActivityCompletedEventImpl(type);
        newEvent.setNumberOfInstances(numberOfInstances);
        newEvent.setNumberOfActiveInstances(numberOfActiveInstances);
        newEvent.setNumberOfCompletedInstances(numberOfCompletedInstances);
        newEvent.setActivityId(activityId);
        newEvent.setActivityName(activityName);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);

        if (flowElement instanceof FlowNode) {
            FlowNode flowNode = (FlowNode) flowElement;
            newEvent.setActivityType(parseActivityType(flowNode));
            Object behaviour = flowNode.getBehavior();
            if (behaviour !is null) {
                newEvent.setBehaviorClass(behaviour.getClass().getCanonicalName());
            }

            newEvent.setSequential(((Activity) flowNode).getLoopCharacteristics().isSequential());
        }

        return newEvent;
    }

    protected static string parseActivityType(FlowNode flowNode) {
        string elementType = flowNode.getClass().getSimpleName();
        elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        return elementType;
    }

    public static FlowableActivityCancelledEvent createActivityCancelledEvent(string activityId, string activityName, string executionId,
            string processInstanceId, string processDefinitionId, string activityType, Object cause) {

        FlowableActivityCancelledEventImpl newEvent = new FlowableActivityCancelledEventImpl();
        newEvent.setActivityId(activityId);
        newEvent.setActivityName(activityName);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setActivityType(activityType);
        newEvent.setCause(cause);
        return newEvent;
    }

    public static FlowableMultiInstanceActivityCancelledEvent createMultiInstanceActivityCancelledEvent(string activityId, string activityName,
            string executionId,string processInstanceId, string processDefinitionId, string activityType, Object cause) {

        FlowableMultiInstanceActivityCancelledEventImpl newEvent = new FlowableMultiInstanceActivityCancelledEventImpl();
        newEvent.setActivityId(activityId);
        newEvent.setActivityName(activityName);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setActivityType(activityType);
        newEvent.setCause(cause);
        return newEvent;
    }

    public static FlowableCancelledEvent createCancelledEvent(string executionId, string processInstanceId, string processDefinitionId, Object cause) {
        FlowableProcessCancelledEventImpl newEvent = new FlowableProcessCancelledEventImpl();
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setCause(cause);
        return newEvent;
    }

    public static FlowableProcessTerminatedEvent createTerminateEvent(ExecutionEntity execution, Object cause) {
        return new FlowableProcessTerminatedEventImpl(execution, cause);
    }

    public static FlowableSignalEvent createSignalEvent(FlowableEngineEventType type, string activityId, string signalName, Object signalData, string executionId, string processInstanceId,
            string processDefinitionId) {
        FlowableSignalEventImpl newEvent = new FlowableSignalEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setSignalName(signalName);
        newEvent.setSignalData(signalData);
        return newEvent;
    }

    public static FlowableMessageEvent createMessageEvent(FlowableEngineEventType type, string activityId, string messageName, Object payload,
                    string executionId, string processInstanceId, string processDefinitionId) {
        FlowableMessageEventImpl newEvent = new FlowableMessageEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setMessageName(messageName);
        newEvent.setMessageData(payload);
        return newEvent;
    }
    
    public static FlowableConditionalEvent createConditionalEvent(FlowableEngineEventType type, string activityId, string conditionExpression,
                    string executionId, string processInstanceId, string processDefinitionId) {
        
        FlowableConditionalEventImpl newEvent = new FlowableConditionalEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setConditionExpression(conditionExpression);
        return newEvent;
    }
    
    public static FlowableEscalationEvent createEscalationEvent(FlowableEngineEventType type, string activityId, string escalationCode, string escalationName,
                    string executionId, string processInstanceId, string processDefinitionId) {
        FlowableEscalationEventImpl newEvent = new FlowableEscalationEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setEscalationCode(escalationCode);
        newEvent.setEscalationName(escalationName);
        return newEvent;
    }

    public static FlowableErrorEvent createErrorEvent(FlowableEngineEventType type, string activityId, string errorId, string errorCode,
            string executionId, string processInstanceId, string processDefinitionId) {
        FlowableErrorEventImpl newEvent = new FlowableErrorEventImpl(type);
        newEvent.setActivityId(activityId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        newEvent.setErrorId(errorId);
        newEvent.setErrorCode(errorCode);
        return newEvent;
    }

    public static FlowableVariableEvent createVariableEvent(FlowableEngineEventType type, string variableName, Object variableValue, VariableType variableType, string taskId, string executionId,
            string processInstanceId, string processDefinitionId) {
        FlowableVariableEventImpl newEvent = new FlowableVariableEventImpl(type);
        newEvent.setVariableName(variableName);
        newEvent.setVariableValue(variableValue);
        newEvent.setVariableType(variableType);
        newEvent.setTaskId(taskId);
        newEvent.setExecutionId(executionId);
        newEvent.setProcessDefinitionId(processDefinitionId);
        newEvent.setProcessInstanceId(processInstanceId);
        return newEvent;
    }

    protected static void populateEventWithCurrentContext(FlowableEngineEventImpl event) {
        if (event instanceof FlowableEntityEvent) {
            Object persistedObject = ((FlowableEntityEvent) event).getEntity();
            if (persistedObject instanceof Job) {
                event.setExecutionId(((Job) persistedObject).getExecutionId());
                event.setProcessInstanceId(((Job) persistedObject).getProcessInstanceId());
                event.setProcessDefinitionId(((Job) persistedObject).getProcessDefinitionId());
                
            } else if (persistedObject instanceof DelegateExecution) {
                event.setExecutionId(((DelegateExecution) persistedObject).getId());
                event.setProcessInstanceId(((DelegateExecution) persistedObject).getProcessInstanceId());
                event.setProcessDefinitionId(((DelegateExecution) persistedObject).getProcessDefinitionId());
                
            } else if (persistedObject instanceof IdentityLinkEntity) {
                IdentityLinkEntity idLink = (IdentityLinkEntity) persistedObject;
                if (idLink.getProcessDefinitionId() !is null) {
                    event.setProcessDefinitionId(idLink.getProcessDefId());
                    
                } else if (idLink.getProcessInstanceId() !is null) {
                    event.setProcessDefinitionId(idLink.getProcessDefId());
                    event.setProcessInstanceId(idLink.getProcessInstanceId());
                    
                } else if (idLink.getTaskId() !is null) {
                    event.setProcessDefinitionId(idLink.getProcessDefId());
                }
                
            } else if (persistedObject instanceof Task) {
                event.setProcessInstanceId(((Task) persistedObject).getProcessInstanceId());
                event.setExecutionId(((Task) persistedObject).getExecutionId());
                event.setProcessDefinitionId(((Task) persistedObject).getProcessDefinitionId());
                
            } else if (persistedObject instanceof ProcessDefinition) {
                event.setProcessDefinitionId(((ProcessDefinition) persistedObject).getId());
            }
        }
    }
}
