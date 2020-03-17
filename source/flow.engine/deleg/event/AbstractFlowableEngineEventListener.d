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
 *
 */
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.deleg.event.AbstractFlowableEngineEventListener;





import hunt.collection.Set;

import flow.common.api.deleg.event.AbstractFlowableEventListener;
import flow.common.api.deleg.event.FlowableEngineEntityEvent;
import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.util.CommandContextUtil;
import flow.variable.service.api.event.FlowableVariableEvent;
import flow.engine.deleg.event.FlowableProcessEngineEvent;
import flow.engine.deleg.event.FlowableActivityEvent;
import flow.engine.deleg.event.FlowableActivityCancelledEvent;
import flow.engine.deleg.event.FlowableMultiInstanceActivityEvent;
import flow.engine.deleg.event.FlowableMultiInstanceActivityCompletedEvent;
import flow.engine.deleg.event.FlowableMultiInstanceActivityCancelledEvent;
import flow.engine.deleg.event.FlowableSignalEvent;
import flow.engine.deleg.event.FlowableMessageEvent;
import flow.engine.deleg.event.FlowableErrorEvent;
import flow.engine.deleg.event.FlowableSequenceFlowTakenEvent;
import flow.engine.deleg.event.FlowableProcessStartedEvent;
import flow.engine.deleg.event.FlowableCancelledEvent;
/**
 *  @author Robert Hafner
 */
abstract class AbstractFlowableEngineEventListener : AbstractFlowableEventListener {

    protected Set!FlowableEngineEventType types;

    this() {}

    this(Set!FlowableEngineEventType types) {
        this.types = types;
    }


    public void onEvent(FlowableEvent flowableEvent) {
        FlowableEngineEvent flowableEngineEvent = cast (FlowableEngineEvent)flowableEvent;
        if(flowableEngineEvent !is null) {
            //FlowableEngineEvent flowableEngineEvent = cast(FlowableEngineEvent) flowableEvent;
            FlowableEngineEventType engineEventType = cast(FlowableEngineEventType) flowableEvent.getType();

            if(types is null || types.contains(engineEventType)) {
                switch (engineEventType) {
                    case ENTITY_CREATED:
                        entityCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case ENTITY_INITIALIZED:
                        entityInitialized(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case ENTITY_UPDATED:
                        entityUpdated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case ENTITY_DELETED:
                        entityDeleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case ENTITY_SUSPENDED:
                        entitySuspended(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case ENTITY_ACTIVATED:
                        entityActivated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case TIMER_SCHEDULED:
                        timerScheduled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case TIMER_FIRED:
                        timerFired(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case JOB_CANCELED:
                        jobCancelled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case JOB_EXECUTION_SUCCESS:
                        jobExecutionSuccess(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case JOB_EXECUTION_FAILURE:
                        jobExecutionFailure(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case JOB_RETRIES_DECREMENTED:
                        jobRetriesDecremented(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case JOB_RESCHEDULED:
                        jobRescheduled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case CUSTOM:
                        custom(flowableEngineEvent);
                        break;
                    case ENGINE_CREATED:
                        engineCreated(cast(FlowableProcessEngineEvent) flowableEngineEvent);
                        break;
                    case ENGINE_CLOSED:
                        engineClosed(cast(FlowableProcessEngineEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_STARTED:
                        activityStarted(cast(FlowableActivityEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_COMPLETED:
                        activityCompleted(cast(FlowableActivityEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_CANCELLED:
                        activityCancelled(cast(FlowableActivityCancelledEvent) flowableEngineEvent);
                        break;
                    case MULTI_INSTANCE_ACTIVITY_STARTED:
                        multiInstanceActivityStarted(cast(FlowableMultiInstanceActivityEvent) flowableEngineEvent);
                        break;
                    case MULTI_INSTANCE_ACTIVITY_COMPLETED:
                        multiInstanceActivityCompleted(cast(FlowableMultiInstanceActivityCompletedEvent) flowableEngineEvent);
                        break;
                    case MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION:
                        multiInstanceActivityCompletedWithCondition(cast(FlowableMultiInstanceActivityCompletedEvent) flowableEngineEvent);
                        break;
                    case MULTI_INSTANCE_ACTIVITY_CANCELLED:
                        multiInstanceActivityCancelled(cast(FlowableMultiInstanceActivityCancelledEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_SIGNAL_WAITING:
                        activitySignalWaiting(cast(FlowableSignalEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_SIGNALED:
                        activitySignaled(cast(FlowableSignalEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_COMPENSATE:
                        activityCompensate(cast(FlowableActivityEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_MESSAGE_WAITING:
                        activityMessageWaiting(cast(FlowableMessageEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_MESSAGE_RECEIVED:
                        activityMessageReceived(cast(FlowableMessageEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_MESSAGE_CANCELLED:
                        activityMessageCancelled(cast(FlowableMessageEvent) flowableEngineEvent);
                        break;
                    case ACTIVITY_ERROR_RECEIVED:
                        activityErrorReceived(cast(FlowableErrorEvent) flowableEngineEvent);
                        break;
                    case HISTORIC_ACTIVITY_INSTANCE_CREATED:
                        historicActivityInstanceCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case HISTORIC_ACTIVITY_INSTANCE_ENDED:
                        historicActivityInstanceEnded(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case SEQUENCEFLOW_TAKEN:
                        sequenceFlowTaken(cast(FlowableSequenceFlowTakenEvent) flowableEngineEvent);
                        break;
                    case VARIABLE_CREATED:
                        variableCreated(cast(FlowableVariableEvent) flowableEngineEvent);
                        break;
                    case VARIABLE_UPDATED:
                        variableUpdatedEvent(cast(FlowableVariableEvent) flowableEngineEvent);
                        break;
                    case VARIABLE_DELETED:
                        variableDeletedEvent(cast(FlowableVariableEvent) flowableEngineEvent);
                        break;
                    case TASK_CREATED:
                        taskCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case TASK_ASSIGNED:
                        taskAssigned(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case TASK_COMPLETED:
                        taskCompleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case PROCESS_CREATED:
                        processCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case PROCESS_STARTED:
                        processStarted(cast(FlowableProcessStartedEvent) flowableEngineEvent);
                        break;
                    case PROCESS_COMPLETED:
                        processCompleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case PROCESS_COMPLETED_WITH_TERMINATE_END_EVENT:
                        processCompletedWithTerminateEnd(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case PROCESS_COMPLETED_WITH_ERROR_END_EVENT:
                        processCompletedWithErrorEnd(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case PROCESS_CANCELLED:
                        processCancelled(cast(FlowableCancelledEvent) flowableEngineEvent);
                        break;
                    case HISTORIC_PROCESS_INSTANCE_CREATED:
                        historicProcessInstanceCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                    case HISTORIC_PROCESS_INSTANCE_ENDED:
                        historicProcessInstanceEnded(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                        break;
                }
            }
        }
    }


    public bool isFailOnException() {
        return true;
    }

    protected void entityCreated(FlowableEngineEntityEvent event) {}

    protected void entityInitialized(FlowableEngineEntityEvent event) {}

    protected void entityUpdated(FlowableEngineEntityEvent event) {}

    protected void entityDeleted(FlowableEngineEntityEvent event) {}

    protected void entitySuspended(FlowableEngineEntityEvent event) {}

    protected void entityActivated(FlowableEngineEntityEvent event) {}

    protected void timerScheduled(FlowableEngineEntityEvent event) {}

    protected void timerFired(FlowableEngineEntityEvent event) {}

    protected void jobCancelled(FlowableEngineEntityEvent event) {}

    protected void jobExecutionSuccess(FlowableEngineEntityEvent event) {}

    protected void jobExecutionFailure(FlowableEngineEntityEvent event) {}

    protected void jobRetriesDecremented(FlowableEngineEntityEvent event) {}

    protected void jobRescheduled(FlowableEngineEntityEvent event) {}

    protected void custom(FlowableEngineEvent event) {}

    protected void engineCreated(FlowableProcessEngineEvent event) {}

    protected void engineClosed(FlowableProcessEngineEvent flowableEngineEvent) {}

    protected void activityStarted(FlowableActivityEvent event) {}

    protected void activityCompleted(FlowableActivityEvent event) {}

    protected void activityCancelled(FlowableActivityCancelledEvent event) {}

    protected void multiInstanceActivityStarted(FlowableMultiInstanceActivityEvent event) {}

    protected void multiInstanceActivityCompleted(FlowableMultiInstanceActivityCompletedEvent event) {}

    protected void multiInstanceActivityCompletedWithCondition(FlowableMultiInstanceActivityCompletedEvent event) {}

    protected void multiInstanceActivityCancelled(FlowableMultiInstanceActivityCancelledEvent event) {}

    protected void activitySignalWaiting(FlowableSignalEvent event) {}

    protected void activitySignaled(FlowableSignalEvent event) {}

    protected void activityCompensate(FlowableActivityEvent event) {}

    protected void activityMessageWaiting(FlowableMessageEvent event) {}

    protected void activityMessageReceived(FlowableMessageEvent event) {}

    protected void activityMessageCancelled(FlowableMessageEvent event) {}

    protected void activityErrorReceived(FlowableErrorEvent event) {}

    protected void historicActivityInstanceCreated(FlowableEngineEntityEvent event) {}

    protected void historicActivityInstanceEnded(FlowableEngineEntityEvent event) {}

    protected void sequenceFlowTaken(FlowableSequenceFlowTakenEvent event) {}

    protected void variableCreated(FlowableVariableEvent event) {}

    protected void variableUpdatedEvent(FlowableVariableEvent event) {}

    protected void variableDeletedEvent(FlowableVariableEvent event) {}

    protected void taskCreated(FlowableEngineEntityEvent event) {}

    protected void taskAssigned(FlowableEngineEntityEvent event) {}

    protected void taskCompleted(FlowableEngineEntityEvent event) {}

    protected void processCreated(FlowableEngineEntityEvent event) {}

    protected void processStarted(FlowableProcessStartedEvent event) {}

    protected void processCompleted(FlowableEngineEntityEvent event) {}

    protected void processCompletedWithTerminateEnd(FlowableEngineEntityEvent event) {}

    protected void processCompletedWithErrorEnd(FlowableEngineEntityEvent event) {}

    protected void processCancelled(FlowableCancelledEvent event) {}

    protected void historicProcessInstanceCreated(FlowableEngineEntityEvent event) {}

    protected void historicProcessInstanceEnded(FlowableEngineEntityEvent event) {}

    protected DelegateExecution getExecution(FlowableEngineEvent event) {
        string executionId = event.getExecutionId();

        if (executionId !is null) {
            CommandContext commandContext = CommandContextUtil.getCommandContext();
            if (commandContext !is null) {
                return CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
                }
            }
        return null;
    }
}
