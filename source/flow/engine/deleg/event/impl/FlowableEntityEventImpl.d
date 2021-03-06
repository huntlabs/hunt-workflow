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

module flow.engine.deleg.event.impl.FlowableEntityEventImpl;





import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEntityEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEvent;
import flow.engine.deleg.event.impl.FlowableProcessEventImpl;
/**
 * Base class for all {@link FlowableEvent} implementations, related to entities.
 *
 * @author Frederik Heremans
 */
class FlowableEntityEventImpl : FlowableProcessEventImpl , FlowableEngineEntityEvent {

    protected Object entity;

    this(Object entity, FlowableEngineEventType type) {
        super(type);
        if (entity is null) {
            throw new FlowableIllegalArgumentException("Entity cannot be null.");
        }
        this.entity = entity;
    }

    public Object getEntity() {
        return entity;
    }

    override
     string getExecutionId()
     {
        return super.getExecutionId();
     }

    override
    string getProcessInstanceId()
    {
        return super.getProcessInstanceId;
    }

    override
    string getProcessDefinitionId()
    {
        return super.getProcessDefinitionId;
    }
}
