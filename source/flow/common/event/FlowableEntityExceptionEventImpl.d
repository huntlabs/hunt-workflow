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

module flow.common.event.FlowableEntityExceptionEventImpl;





import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEntityEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableExceptionEvent;
import flow.common.event.FlowableEngineEventImpl;
/**
 * Base class for all {@link FlowableEvent} implementations, represents an exception occurred, related to an entity.
 *
 * @author Frederik Heremans
 */
class FlowableEntityExceptionEventImpl : FlowableEngineEventImpl , FlowableEngineEntityEvent, FlowableExceptionEvent {

    protected Object entity;
    protected Throwable cause;

    this(Object entity, FlowableEngineEventType type, Throwable cause) {
        super(type);
        if (entity is null) {
            throw new FlowableIllegalArgumentException("Entity cannot be null.");
        }
        this.entity = entity;
        this.cause = cause;
    }

    //@Override
    public Object getEntity() {
        return entity;
    }

   // @Override
    public Throwable getCause() {
        return cause;
    }

    override
    string getExecutionId()
    {
        return super.getExecutionId;
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
