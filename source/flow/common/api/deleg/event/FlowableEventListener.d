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
 
module flow.common.api.deleg.event.FlowableEventListener;
 
 
 import flow.common.api.deleg.event.FlowableEvent;

/**
 * Describes a class that listens for {@link FlowableEvent}s dispatched by the engine.
 * 
 * @author Frederik Heremans
 * @author Joram Barrez
 */
interface FlowableEventListener {

    /**
     * Called when an event has been fired
     * 
     * @param event the event
     */
    void onEvent(FlowableEvent event);

    /**
     * @return whether or not the current operation should fail when this listeners execution throws an exception.
     */
    bool isFailOnException();
    
    /**
     * @return Returns whether this event listener fires immediately when the event occurs or 
     *         on a transaction lifecycle event (before/after commit or rollback).
     */
    bool isFireOnTransactionLifecycleEvent();
    
    /**
     * @return if non-null, indicates the point in the lifecycle of the current transaction when the event should be fired.
     */
    string getOnTransaction();
    
}
