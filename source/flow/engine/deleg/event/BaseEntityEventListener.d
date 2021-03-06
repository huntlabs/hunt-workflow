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

module flow.engine.deleg.event.BaseEntityEventListener;





import flow.common.api.deleg.event.AbstractFlowableEventListener;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import hunt.Exceptions;
/**
 * Base event listener that can be used when implementing an {@link FlowableEventListener} to get notified when an entity is created, updated, deleted or if another entity-related event occurs.
 *
 * Override the <code>onXX(..)</code> methods to respond to entity changes accordingly.
 *
 * @author Frederik Heremans
 *
 */
class BaseEntityEventListener : AbstractFlowableEventListener {

    protected bool failOnException;
    //protected Class<?> entityClass;
    protected TypeInfo entityClass;
    /**
     * Create a new BaseEntityEventListener, notified when an event that targets any type of entity is received. Returning true when {@link #isFailOnException()} is called.
     */
    this() {
        this(true, null);
    }

    /**
     * Create a new BaseEntityEventListener.
     *
     * @param failOnException
     *            return value for {@link #isFailOnException()}.
     */
    this(bool failOnException) {
        this(failOnException, null);
    }

    this(bool failOnException, TypeInfo entityClass) {
        this.failOnException = failOnException;
        this.entityClass = entityClass;
    }

    override
    public  void onEvent(FlowableEvent event) {
        if (isValidEvent(event)) {
            // Check if this event
            if (event.getType() == FlowableEngineEventType.ENTITY_CREATED) {
                onCreate(event);
            } else if (event.getType() == FlowableEngineEventType.ENTITY_INITIALIZED) {
                onInitialized(event);
            } else if (event.getType() == FlowableEngineEventType.ENTITY_DELETED) {
                onDelete(event);
            } else if (event.getType() == FlowableEngineEventType.ENTITY_UPDATED) {
                onUpdate(event);
            } else {
                // Entity-specific event
                onEntityEvent(event);
            }
        }
    }

    override
    public bool isFailOnException() {
        return failOnException;
    }

    /**
     * @return true, if the event is an {@link FlowableEntityEvent} and (if needed) the entityClass set in this instance, is assignable from the entity class in the event.
     */
    protected bool isValidEvent(FlowableEvent event) {
        implementationMissing(false);
        return true;
        //bool valid = false;
        //FlowableEntityEvent f = cast (FlowableEntityEvent)event;
        //if (f !is null) {
        //    if (entityClass is null) {
        //        valid = true;
        //    } else {
        //        valid = entityClass.isAssignableFrom(((FlowableEntityEvent) event).getEntity().getClass());
        //    }
        //}
        //return valid;
    }

    /**
     * Called when an entity create event is received.
     */
    protected void onCreate(FlowableEvent event) {
        // Default implementation is a NO-OP
    }

    /**
     * Called when an entity initialized event is received.
     */
    protected void onInitialized(FlowableEvent event) {
        // Default implementation is a NO-OP
    }

    /**
     * Called when an entity delete event is received.
     */
    protected void onDelete(FlowableEvent event) {
        // Default implementation is a NO-OP
    }

    /**
     * Called when an entity update event is received.
     */
    protected void onUpdate(FlowableEvent event) {
        // Default implementation is a NO-OP
    }

    /**
     * Called when an event is received, which is not a create, an update or delete.
     */
    protected void onEntityEvent(FlowableEvent event) {
        // Default implementation is a NO-OP
    }
}
