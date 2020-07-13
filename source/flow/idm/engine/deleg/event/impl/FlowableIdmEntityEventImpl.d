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

module flow.idm.engine.deleg.event.impl.FlowableIdmEntityEventImpl;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.engine.deleg.event.impl.FlowableIdmEventImpl;

/**
 * Base class for all {@link FlowableIdmEntityEvent} implementations, related to entities.
 *
 * @author Tijs Rademakers
 */
class FlowableIdmEntityEventImpl : FlowableIdmEventImpl , FlowableEntityEvent {

    protected Object entity;

    this(Object entity, FlowableIdmEventType type) {
        super(type);
        if (entity is null) {
            throw new FlowableIllegalArgumentException("Entity cannot be null.");
        }
        this.entity = entity;
    }

    public Object getEntity() {
        return entity;
    }
}
