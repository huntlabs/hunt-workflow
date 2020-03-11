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


module flow.idm.engine.deleg.event.impl.FlowableIdmEventImpl;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEvent;
import flow.idm.api.event.FlowableIdmEventType;

/**
 * Base class for all {@link FlowableIdmEvent} implementations.
 *
 * @author Tijs Rademakers
 */
class FlowableIdmEventImpl : FlowableEvent {

    protected FlowableIdmEventType type;

    /**
     * Creates a new event implementation, not part of an execution context.
     */
    this(FlowableIdmEventType type) {
        if (type is null) {
            throw new FlowableIllegalArgumentException("type is null");
        }
        this.type = type;
    }

    public FlowableIdmEventType getType() {
        return type;
    }

    public void setType(FlowableIdmEventType type) {
        this.type = type;
    }

    override
    public string toString() {
        return getClass() ~ " - " ~ type;
    }

}
