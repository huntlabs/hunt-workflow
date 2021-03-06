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

module flow.job.service.event.impl.FlowableJobEventBuilder;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableExceptionEvent;
import flow.common.event.FlowableEntityEventImpl;
import flow.common.event.FlowableEntityExceptionEventImpl;
import flow.common.event.FlowableEngineEventImpl;
import flow.job.service.api.Job;

/**
 * Builder class used to create {@link FlowableEvent} implementations.
 *
 * @author Frederik Heremans
 */
class FlowableJobEventBuilder {

    /**
     * @param type
     *            type of event
     * @param entity
     *            the entity this event targets
     * @return an {@link FlowableEntityEvent}.
     */
    public static FlowableEntityEvent createEntityEvent(FlowableEngineEventType type, Object entity) {
        FlowableEntityEventImpl newEvent = new FlowableEntityEventImpl(entity, type);

        // In case an execution-context is active, populate the event fields related to the execution
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
     * @return an {@link FlowableEntityEvent} that is also instance of {@link FlowableExceptionEvent}. In case an ExecutionContext is active, the execution related event fields will be
     *         populated.
     */
    public static FlowableEntityEvent createEntityExceptionEvent(FlowableEngineEventType type, Object entity, Throwable cause) {
        FlowableEntityExceptionEventImpl newEvent = new FlowableEntityExceptionEventImpl(entity, type, cause);

        // In case an execution-context is active, populate the event fields related to the execution
        populateEventWithCurrentContext(newEvent);
        return newEvent;
    }

    protected static void populateEventWithCurrentContext(FlowableEngineEventImpl event) {
        FlowableEntityEvent f = cast(FlowableEntityEvent) event;
        if (f !is null) {
            Object persistedObject = f.getEntity();
             Job j = cast(Job)persistedObject;
            if (j !is null) {
                event.setExecutionId(j.getExecutionId());
                event.setProcessInstanceId(j.getProcessInstanceId());
                event.setProcessDefinitionId(j.getProcessDefinitionId());
            }
        }
    }
}
