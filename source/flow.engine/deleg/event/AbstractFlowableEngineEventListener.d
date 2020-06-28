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
               // switch (engineEventType) {
                    if(engineEventType == FlowableEngineEventType.ENTITY_CREATED)
                        entityCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENTITY_INITIALIZED)
                        entityInitialized(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if( engineEventType == FlowableEngineEventType.ENTITY_UPDATED)
                        entityUpdated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENTITY_DELETED)
                        entityDeleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENTITY_SUSPENDED)
                        entitySuspended(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENTITY_ACTIVATED)
                        entityActivated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.TIMER_SCHEDULED)
                        timerScheduled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.TIMER_FIRED)
                        timerFired(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.JOB_CANCELED)
                        jobCancelled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.JOB_EXECUTION_SUCCESS)
                        jobExecutionSuccess(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.JOB_EXECUTION_FAILURE)
                        jobExecutionFailure(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.JOB_RETRIES_DECREMENTED)
                        jobRetriesDecremented(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.JOB_RESCHEDULED)
                        jobRescheduled(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.CUSTOM)
                        custom(flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENGINE_CREATED)
                        engineCreated(cast(FlowableProcessEngineEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ENGINE_CLOSED)
                        engineClosed(cast(FlowableProcessEngineEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_STARTED)
                        activityStarted(cast(FlowableActivityEvent) flowableEngineEvent);
                    else if(FlowableEngineEventType.ACTIVITY_COMPLETED == engineEventType)
                        activityCompleted(cast(FlowableActivityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_CANCELLED)
                        activityCancelled(cast(FlowableActivityCancelledEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_STARTED)
                        multiInstanceActivityStarted(cast(FlowableMultiInstanceActivityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_COMPLETED)
                        multiInstanceActivityCompleted(cast(FlowableMultiInstanceActivityCompletedEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION)
                        multiInstanceActivityCompletedWithCondition(cast(FlowableMultiInstanceActivityCompletedEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.MULTI_INSTANCE_ACTIVITY_CANCELLED)
                        multiInstanceActivityCancelled(cast(FlowableMultiInstanceActivityCancelledEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_SIGNAL_WAITING)
                        activitySignalWaiting(cast(FlowableSignalEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_SIGNALED)
                        activitySignaled(cast(FlowableSignalEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_COMPENSATE)
                        activityCompensate(cast(FlowableActivityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_MESSAGE_WAITING)
                        activityMessageWaiting(cast(FlowableMessageEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_MESSAGE_RECEIVED)
                        activityMessageReceived(cast(FlowableMessageEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_MESSAGE_CANCELLED)
                        activityMessageCancelled(cast(FlowableMessageEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.ACTIVITY_ERROR_RECEIVED)
                        activityErrorReceived(cast(FlowableErrorEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_CREATED)
                        historicActivityInstanceCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.HISTORIC_ACTIVITY_INSTANCE_ENDED)
                        historicActivityInstanceEnded(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.SEQUENCEFLOW_TAKEN)
                        sequenceFlowTaken(cast(FlowableSequenceFlowTakenEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.VARIABLE_CREATED)
                        variableCreated(cast(FlowableVariableEvent) flowableEngineEvent);
                    else if(FlowableEngineEventType.VARIABLE_UPDATED == engineEventType)
                        variableUpdatedEvent(cast(FlowableVariableEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.VARIABLE_DELETED)
                        variableDeletedEvent(cast(FlowableVariableEvent) flowableEngineEvent);
                    else if(FlowableEngineEventType.TASK_CREATED == engineEventType)
                        taskCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.TASK_ASSIGNED)
                        taskAssigned(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.TASK_COMPLETED)
                        taskCompleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_CREATED)
                        processCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_STARTED)
                        processStarted(cast(FlowableProcessStartedEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_COMPLETED)
                        processCompleted(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_COMPLETED_WITH_TERMINATE_END_EVENT)
                        processCompletedWithTerminateEnd(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_COMPLETED_WITH_ERROR_END_EVENT)
                        processCompletedWithErrorEnd(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.PROCESS_CANCELLED)
                        processCancelled(cast(FlowableCancelledEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_CREATED)
                        historicProcessInstanceCreated(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else if(engineEventType == FlowableEngineEventType.HISTORIC_PROCESS_INSTANCE_ENDED)
                        historicProcessInstanceEnded(cast(FlowableEngineEntityEvent) flowableEngineEvent);
                    else {}
                //}
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
