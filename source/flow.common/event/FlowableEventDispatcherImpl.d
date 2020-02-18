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
 
module flow.common.event.FlowableEventDispatcherImpl;
 
 
 


import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.api.deleg.event.FlowableEventType;
import flow.common.AbstractEngineConfiguration;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.event.FlowableEventSupport;
import hunt.Exceptions;
/**
 * Class capable of dispatching events.
 * 
 * @author Frederik Heremans
 */
class FlowableEventDispatcherImpl : FlowableEventDispatcher {

    protected FlowableEventSupport eventSupport;
    protected bool enabled = true;

    this() {
        eventSupport = new FlowableEventSupport();
    }

    public void setEnabled(bool enabled) {
        this.enabled = enabled;
    }

    public bool isEnabled() {
        return enabled;
    }

    public void addEventListener(FlowableEventListener listenerToAdd) {
        eventSupport.addEventListener(listenerToAdd);
    }

    //public void addEventListener(FlowableEventListener listenerToAdd, FlowableEventType... types) {
    //    eventSupport.addEventListener(listenerToAdd, types);
    //}

    public void removeEventListener(FlowableEventListener listenerToRemove) {
        eventSupport.removeEventListener(listenerToRemove);
    }

    public void dispatchEvent(FlowableEvent event) {
        //if (enabled) {
        //    eventSupport.dispatchEvent(event);
        //}
        //
        //CommandContext commandContext = Context.getCommandContext();
        //if (commandContext !is null) {
        //    AbstractEngineConfiguration engineConfiguration = commandContext.getCurrentEngineConfiguration();
        //    if (engineConfiguration !is null && engineConfiguration.getAdditionalEventDispatchActions() !is null) {
        //        for (EventDispatchAction eventDispatchAction : engineConfiguration.getAdditionalEventDispatchActions()) {
        //            eventDispatchAction.dispatchEvent(commandContext, eventSupport, event);
        //        }
        //    }
        //}
        implementationMissing(false);
    }

    public FlowableEventSupport getEventSupport() {
        return eventSupport;
    }

    public void setEventSupport(FlowableEventSupport eventSupport) {
        this.eventSupport = eventSupport;
    }

}
