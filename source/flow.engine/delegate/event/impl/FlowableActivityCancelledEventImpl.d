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
 
module flow.engine.delegate.event.impl.FlowableActivityCancelledEventImpl;
 
 
 

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.delegate.event.FlowableActivityCancelledEvent;

/**
 * An {@link flow.engine.delegate.event.FlowableActivityCancelledEvent} implementation.
 * 
 * @author martin.grofcik
 */
class FlowableActivityCancelledEventImpl : FlowableActivityEventImpl , FlowableActivityCancelledEvent {

    protected Object cause;

    this() {
        super(FlowableEngineEventType.ACTIVITY_CANCELLED);
    }

    public void setCause(Object cause) {
        this.cause = cause;
    }

    @Override
    public Object getCause() {
        return cause;
    }

}
