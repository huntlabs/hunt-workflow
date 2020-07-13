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
 
module flow.engine.deleg.event.FlowableProcessEngineEvent;
 
 
 


import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.engine.deleg.DelegateExecution;

/**
 * Event interface for {@link FlowableEvent} implementations related to the process engine,
 * exposing process engine specific functions.
 * 
 * @author Joram Barrez
 */
interface FlowableProcessEngineEvent : FlowableEngineEvent {
    
    /**
     * Return the execution this event is associated with. Returns null, if the event was not related to an active execution.
     * 
     * Note that this will only retun a {@link DelegateExecution} instance when a command context is active.
     */
    DelegateExecution getExecution();

}
