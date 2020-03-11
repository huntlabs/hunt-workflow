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

module flow.common.api.deleg.event.FlowableEngineEventType;




import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.Exceptions;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEventType;

 import hunt.Enum;
import std.concurrency : initOnce;

/**

 * Enumeration containing all possible types of {@link FlowableEvent}s.
 *
 * @author Frederik Heremans
 *
 */
class FlowableEngineEventType : AbstractEnum!FlowableEngineEventType, FlowableEventType {

    /**
     * New entity is created.
     */
    static FlowableEngineEventType[] vs;

    this(string name, int val)
    {
        super(name,val);
    }

     static FlowableEngineEventType[]  values() {
        if (vs is null)
        {
           vs = new  FlowableEngineEventType[];
        }

        if(FlowableEngineEventType.vs.length == 0)
        {
            vs ~= ENTITY_CREATED;
            vs ~= ENTITY_INITIALIZED;
            vs ~= ENTITY_UPDATED;
            vs ~= ENTITY_DELETED;
            vs ~= ENTITY_SUSPENDED;
            vs ~= ENTITY_ACTIVATED;
            vs ~= TIMER_SCHEDULED;
            vs ~= TIMER_FIRED;
            vs ~= JOB_CANCELED;
            vs ~= JOB_EXECUTION_SUCCESS;
            vs ~= JOB_EXECUTION_FAILURE;
            vs ~= JOB_RETRIES_DECREMENTED;
            vs ~= JOB_RESCHEDULED;
            vs ~= CUSTOM;
            vs ~= ENGINE_CREATED;
            vs ~= ENGINE_CLOSED;
            vs ~= ACTIVITY_STARTED;
            vs ~= ACTIVITY_COMPLETED;
            vs ~= ACTIVITY_CANCELLED;
            vs ~= MULTI_INSTANCE_ACTIVITY_STARTED;
            vs ~= MULTI_INSTANCE_ACTIVITY_COMPLETED;
            vs ~= MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION;
            vs ~= MULTI_INSTANCE_ACTIVITY_CANCELLED;
            vs ~= ACTIVITY_SIGNAL_WAITING;
            vs ~= ACTIVITY_SIGNALED;
            vs ~= ACTIVITY_COMPENSATE;
            vs ~= ACTIVITY_CONDITIONAL_WAITING;
            vs ~= ACTIVITY_CONDITIONAL_RECEIVED;
            vs ~= ACTIVITY_ESCALATION_WAITING;
            vs ~= ACTIVITY_ESCALATION_RECEIVED;
            vs ~= ACTIVITY_MESSAGE_WAITING;
            vs ~= ACTIVITY_MESSAGE_RECEIVED;
            vs ~= ACTIVITY_MESSAGE_CANCELLED;
            vs ~= ACTIVITY_ERROR_RECEIVED;
            vs ~= HISTORIC_ACTIVITY_INSTANCE_CREATED;
            vs ~= HISTORIC_ACTIVITY_INSTANCE_ENDED;
            vs ~= SEQUENCEFLOW_TAKEN;
            vs ~= VARIABLE_CREATED;
            vs ~= VARIABLE_UPDATED;
            vs ~= VARIABLE_DELETED;
            vs ~= TASK_CREATED;
            vs ~= TASK_ASSIGNED;
            vs ~= TASK_COMPLETED;
            vs ~= TASK_OWNER_CHANGED;
            vs ~= TASK_PRIORITY_CHANGED;
            vs ~= TASK_DUEDATE_CHANGED;
            vs ~= TASK_NAME_CHANGED;
            vs ~= PROCESS_CREATED;
            vs ~= PROCESS_STARTED;
            vs ~= PROCESS_COMPLETED;
            vs ~= PROCESS_COMPLETED_WITH_TERMINATE_END_EVENT;
            vs ~= PROCESS_COMPLETED_WITH_ERROR_END_EVENT;
            vs ~= PROCESS_COMPLETED_WITH_ESCALATION_END_EVENT;
            vs ~= PROCESS_CANCELLED;
            vs ~= HISTORIC_PROCESS_INSTANCE_CREATED;
            vs ~= HISTORIC_PROCESS_INSTANCE_ENDED;
        }
        return vs;
     }

    static FlowableEngineEventType  ENTITY_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_CREATED" , 0));
    }

    /**
     * New entity has been created and all properties have been set.
     */
    static FlowableEngineEventType  ENTITY_INITIALIZED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_INITIALIZED" , 1));
    }
    /**
     * Existing entity us updated.
     */
    static FlowableEngineEventType  ENTITY_UPDATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_UPDATED" , 2));
    }
    /**
     * Existing entity is deleted.
     */
   static FlowableEngineEventType  ENTITY_DELETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_DELETED" , 3));
    }
    /**
     * Existing entity has been suspended.
     */
   static FlowableEngineEventType  ENTITY_SUSPENDED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_SUSPENDED" , 4));
    }
    /**
     * Existing entity has been activated.
     */
   static FlowableEngineEventType  ENTITY_ACTIVATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENTITY_ACTIVATED" , 5));
    }
    /**
     * A Timer has been scheduled.
     */
    static FlowableEngineEventType  TIMER_SCHEDULED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TIMER_SCHEDULED" , 6));
    }
    /**
     * Timer has been fired successfully.
     */
    static FlowableEngineEventType  TIMER_FIRED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TIMER_FIRED" , 7));
    }
    /**
     * Timer has been cancelled (e.g. user task on which it was bounded has been completed earlier than expected)
     */
    static FlowableEngineEventType  JOB_CANCELED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("JOB_CANCELED" , 8));
    }
    /**
     * A job has been successfully executed.
     */
    static FlowableEngineEventType  JOB_EXECUTION_SUCCESS() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("JOB_EXECUTION_SUCCESS" , 9));
    }
    /**
     * A job has been executed, but failed. Event should be an instance of a {@link ExceptionEvent}.
     */
    static FlowableEngineEventType  JOB_EXECUTION_FAILURE() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("JOB_EXECUTION_FAILURE" , 10));
    }
    /**
     * The retry-count on a job has been decremented.
     */
    static FlowableEngineEventType  JOB_RETRIES_DECREMENTED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("JOB_RETRIES_DECREMENTED" , 11));
    }
    /**
     * The job has been rescheduled.
     */
    static FlowableEngineEventType  JOB_RESCHEDULED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("JOB_RESCHEDULED" , 12));
    }
    /**
     * An event type to be used by custom events. These types of events are never thrown by the engine itself, only be an external API call to dispatch an event.
     */
    static FlowableEngineEventType  CUSTOM() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("CUSTOM" , 13));
    }
    /**
     * The process-engine that dispatched this event has been created and is ready for use.
     */
    static FlowableEngineEventType  ENGINE_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENGINE_CREATED" , 14));
    }
    /**
     * The process-engine that dispatched this event has been closed and cannot be used anymore.
     */
    static FlowableEngineEventType  ENGINE_CLOSED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ENGINE_CLOSED" , 15));
    }
    /**
     * An activity is starting to execute. This event is dispatched right before an activity is executed.
     */
    static FlowableEngineEventType  ACTIVITY_STARTED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_STARTED" , 16));
    }
    /**
     * An activity has been completed successfully.
     */
    static FlowableEngineEventType  ACTIVITY_COMPLETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_COMPLETED" , 17));
    }
    /**
     * An activity has been cancelled because of boundary event.
     */
    static FlowableEngineEventType  ACTIVITY_CANCELLED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_CANCELLED" , 18));
    }
    /**
     * A multi-instance activity is starting to execute. This event is dispatched right before an activity is executed.
     */
    static FlowableEngineEventType  MULTI_INSTANCE_ACTIVITY_STARTED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("MULTI_INSTANCE_ACTIVITY_STARTED" , 19));
    }
    /**
     * A multi-instance activity has been completed successfully.
     */
    static FlowableEngineEventType  MULTI_INSTANCE_ACTIVITY_COMPLETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("MULTI_INSTANCE_ACTIVITY_COMPLETED" , 20));
    }
    /**
     * A multi-instance activity has met its condition and completed successfully.
     */
    static FlowableEngineEventType  MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("MULTI_INSTANCE_ACTIVITY_COMPLETED_WITH_CONDITION" , 21));
    }
    /**
     * A multi-instance activity has been cancelled.
     */
    static FlowableEngineEventType  MULTI_INSTANCE_ACTIVITY_CANCELLED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("MULTI_INSTANCE_ACTIVITY_CANCELLED" , 22));
    }
    /**
     * A boundary, intermediate, or subprocess start signal catching event has started.
     */
    static FlowableEngineEventType  ACTIVITY_SIGNAL_WAITING() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_SIGNAL_WAITING" , 23));
    }
    /**
     * An activity has received a signal. Dispatched after the activity has responded to the signal.
     */
    static FlowableEngineEventType  ACTIVITY_SIGNALED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_SIGNALED" , 24));
    }
    /**
     * An activity is about to be executed as a compensation for another activity. The event targets the activity that is about to be executed for compensation.
     */
    static FlowableEngineEventType  ACTIVITY_COMPENSATE() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_COMPENSATE" , 25));
    }
    /**
     * A boundary, intermediate, or subprocess start conditional catching event has started.
     */
    static FlowableEngineEventType  ACTIVITY_CONDITIONAL_WAITING() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_CONDITIONAL_WAITING" , 26));
    }
    /**
     * An activity has received a conditional event. Dispatched before the actual conditional event has been received by the activity. This event will be either followed by a {@link #ACTIVITY_SIGNALLED} event or
     * {@link #ACTIVITY_COMPLETED} for the involved activity, if the error was delivered successfully.
     */
    static FlowableEngineEventType  ACTIVITY_CONDITIONAL_RECEIVED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_CONDITIONAL_RECEIVED" , 27));
    }
    /**
     * A boundary, intermediate, or subprocess start escalation catching event has started.
     */
    static FlowableEngineEventType  ACTIVITY_ESCALATION_WAITING() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_ESCALATION_WAITING" , 28));
    }
    /**
     * An activity has received an escalation event. Dispatched before the actual escalation has been received by the activity. This event will be either followed by a {@link #ACTIVITY_SIGNALLED} event or
     * {@link #ACTIVITY_COMPLETED} for the involved activity, if the error was delivered successfully.
     */
    static FlowableEngineEventType  ACTIVITY_ESCALATION_RECEIVED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_ESCALATION_RECEIVED" , 29));
    }
    /**
     * A boundary, intermediate, or subprocess start message catching event has started.
     */
    static FlowableEngineEventType  ACTIVITY_MESSAGE_WAITING() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_MESSAGE_WAITING" , 30));
    }
    /**
     * An activity has received a message event. Dispatched before the actual message has been received by the activity. This event will be either followed by a {@link #ACTIVITY_SIGNALLED} event or
     * {@link #ACTIVITY_COMPLETED} for the involved activity, if the message was delivered successfully.
     */
    static FlowableEngineEventType  ACTIVITY_MESSAGE_RECEIVED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_MESSAGE_RECEIVED" , 31));
    }
    /**
     * A boundary, intermediate, or subprocess start message catching event has been cancelled.
     */
    static FlowableEngineEventType  ACTIVITY_MESSAGE_CANCELLED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_MESSAGE_CANCELLED" , 32));
    }
    /**
     * An activity has received an error event. Dispatched before the actual error has been received by the activity. This event will be either followed by a {@link #ACTIVITY_SIGNALLED} event or
     * {@link #ACTIVITY_COMPLETED} for the involved activity, if the error was delivered successfully.
     */
    static FlowableEngineEventType  ACTIVITY_ERROR_RECEIVED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("ACTIVITY_ERROR_RECEIVED" , 33));
    }
    /**
     * A event dispatched when a {@link HistoricActivityInstance} is created. This is a specialized version of the {@link FlowableEngineEventType#ENTITY_CREATED} and
     * {@link FlowableEngineEventType#ENTITY_INITIALIZED} event, with the same use case as the {@link FlowableEngineEventType#ACTIVITY_STARTED}, but containing slightly different data.
     *
     * Note this will be an {@link FlowableEngineEventType}, where the entity is the {@link HistoricActivityInstance}.
     *
     * Note that history (minimum level ACTIVITY) must be enabled to receive this event.
     */
    static FlowableEngineEventType  HISTORIC_ACTIVITY_INSTANCE_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("HISTORIC_ACTIVITY_INSTANCE_CREATED" , 34));
    }
    /**
     * A event dispatched when a {@link HistoricActivityInstance} is marked as ended. his is a specialized version of the {@link FlowableEngineEventType#ENTITY_UPDATED} event, with the same use case
     * as the {@link FlowableEngineEventType#ACTIVITY_COMPLETED}, but containing slightly different data (e.g. the end time, the duration, etc.).
     *
     * Note that history (minimum level ACTIVITY) must be enabled to receive this event.
     */
    static FlowableEngineEventType  HISTORIC_ACTIVITY_INSTANCE_ENDED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("HISTORIC_ACTIVITY_INSTANCE_ENDED" , 35));
    }
    /**
     * Indicates the engine has taken (ie. followed) a sequenceflow from a source activity to a target activity.
     */
    static FlowableEngineEventType  SEQUENCEFLOW_TAKEN() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("SEQUENCEFLOW_TAKEN" , 36));
    }
    /**
     * A new variable has been created.
     */
    static FlowableEngineEventType  VARIABLE_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("VARIABLE_CREATED" , 37));
    }
    /**
     * An existing variable has been updated.
     */
    static FlowableEngineEventType  VARIABLE_UPDATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("VARIABLE_UPDATED" , 38));
    }
    /**
     * An existing variable has been deleted.
     */
    static FlowableEngineEventType  VARIABLE_DELETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("VARIABLE_DELETED" , 39));
    }
    /**
     * A task has been created. This is thrown when task is fully initialized (before TaskListener.EVENTNAME_CREATE).
     */
    static FlowableEngineEventType  TASK_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_CREATED" , 40));
    }
    /**
     * A task as been assigned. This is thrown alongside with an {@link #ENTITY_UPDATED} event.
     */
    static FlowableEngineEventType  TASK_ASSIGNED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_ASSIGNED" , 41));
    }
    /**
     * A task has been completed. Dispatched before the task entity is deleted ( {@link #ENTITY_DELETED}). If the task is part of a process, this event is dispatched before the process moves on, as a
     * result of the task completion. In that case, a {@link #ACTIVITY_COMPLETED} will be dispatched after an event of this type for the activity corresponding to the task.
     */
    static FlowableEngineEventType  TASK_COMPLETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_COMPLETED" , 42));
    }
    /**
     * A task owner has been changed. This is thrown alongside with an {@link #ENTITY_UPDATED} event.
     */
    static FlowableEngineEventType  TASK_OWNER_CHANGED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_OWNER_CHANGED" , 43));
    }
    /**
     * A task priority has been changed. This is thrown alongside with an {@link #ENTITY_UPDATED} event.
     */
    static FlowableEngineEventType  TASK_PRIORITY_CHANGED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_PRIORITY_CHANGED" , 44));
    }
    /**
     * A task dueDate has been changed. This is thrown alongside with an {@link #ENTITY_UPDATED} event.
     */
    static FlowableEngineEventType  TASK_DUEDATE_CHANGED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_DUEDATE_CHANGED" , 45));
    }
    /**
     * A task name has been changed. This is thrown alongside with an {@link #ENTITY_UPDATED} event.
     */
    static FlowableEngineEventType  TASK_NAME_CHANGED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("TASK_NAME_CHANGED" , 46));
    }
    /**
     * A process instance has been created. All basic properties have been set, but variables not yet.
     */
    static FlowableEngineEventType  PROCESS_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_CREATED" , 47));
    }
    /**
     * A process instance has been started. Dispatched when starting a process instance previously created. The event PROCESS_STARTED is dispatched after the associated event ENTITY_INITIALIZED and
     * after the variables have been set.
     */
    static FlowableEngineEventType  PROCESS_STARTED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_STARTED" , 48));
    }
    /**
     * A process has been completed. Dispatched after the last activity is ACTIVITY_COMPLETED. Process is completed when it reaches state in which process instance does not have any transition to
     * take.
     */
    static FlowableEngineEventType  PROCESS_COMPLETED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_COMPLETED" , 49));
    }
    /**
     * A process has been completed with a terminate end event.
     */
    static FlowableEngineEventType  PROCESS_COMPLETED_WITH_TERMINATE_END_EVENT() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_COMPLETED_WITH_TERMINATE_END_EVENT" , 50));
    }
    /**
     * A process has been completed with an error end event.
     */
    static FlowableEngineEventType  PROCESS_COMPLETED_WITH_ERROR_END_EVENT() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_COMPLETED_WITH_ERROR_END_EVENT" , 51));
    }
    /**
     * A process has been completed with an escalation end event.
     */
    static FlowableEngineEventType  PROCESS_COMPLETED_WITH_ESCALATION_END_EVENT() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_COMPLETED_WITH_ESCALATION_END_EVENT" , 52));
    }
    /**
     * A process has been cancelled. Dispatched when process instance is deleted by
     *
     * @see org.flowable.engine.impl.RuntimeServiceImpl#deleteProcessInstance(java.lang.string, java.lang.string), before DB delete.
     */
    static FlowableEngineEventType  PROCESS_CANCELLED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("PROCESS_CANCELLED" , 53));
    }
    /**
     * A event dispatched when a {@link HistoricProcessInstance} is created. This is a specialized version of the {@link FlowableEngineEventType#ENTITY_CREATED} and
     * {@link FlowableEngineEventType#ENTITY_INITIALIZED} event, with the same use case as the {@link FlowableEngineEventType#PROCESS_STARTED}, but containing slightly different data (e.g. the start
     * time, the start user id, etc.).
     *
     * Note this will be an {@link FlowableEngineEventType}, where the entity is the {@link HistoricProcessInstance}.
     *
     * Note that history (minimum level ACTIVITY) must be enabled to receive this event.
     */
    static FlowableEngineEventType  HISTORIC_PROCESS_INSTANCE_CREATED() {
      __gshared FlowableEngineEventType  inst;
      return initOnce!inst(new FlowableEngineEventType("HISTORIC_PROCESS_INSTANCE_CREATED" , 54));
    }
    /**
     * A event dispatched when a {@link HistoricProcessInstance} is marked as ended. his is a specialized version of the {@link FlowableEngineEventType#ENTITY_UPDATED} event, with the same use case as
     * the {@link FlowableEngineEventType#PROCESS_COMPLETED}, but containing slightly different data (e.g. the end time, the duration, etc.).
     *
     * Note that history (minimum level ACTIVITY) must be enabled to receive this event.
     */
    static FlowableEngineEventType  HISTORIC_PROCESS_INSTANCE_ENDED() {
        __gshared FlowableEngineEventType  inst;
        return initOnce!inst(new FlowableEngineEventType("HISTORIC_PROCESS_INSTANCE_ENDED" , 55));
    }
   // public static final FlowableEngineEventType[] EMPTY_ARRAY = new FlowableEngineEventType[] {};

       static FlowableEngineEventType[]  EMPTY_ARRAY() {
           __gshared  FlowableEngineEventType[]  inst;
           return initOnce!inst(new FlowableEngineEventType[]);
       }
    /**
     * @param string
     *            the string containing a comma-separated list of event-type names
     * @return a list of {@link FlowableEngineEventType} based on the given list.
     * @throws FlowableIllegalArgumentException
     *             when one of the given string is not a valid type name
     */
    public static FlowableEngineEventType[] getTypesFromString(string str) {
        //implementationMissing(false);
        List!FlowableEngineEventType result = new ArrayList!FlowableEngineEventType;
        if (str !is null && !str.isEmpty()) {
            string[] split = str.split( ",");
            foreach (string typeName ; split) {
                bool found = false;
                foreach (FlowableEngineEventType type ; values()) {
                    if (typeName == (type.name())) {
                        result.add(type);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new FlowableIllegalArgumentException("Invalid event-type: " ~ typeName);
                }
            }
        }
        return result.toArray();
        //return result.toArray(EMPTY_ARRAY);
    }
}
