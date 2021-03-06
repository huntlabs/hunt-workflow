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
 
module flow.engine.deleg.event.FlowableSignalEvent;
 
 
 

import flow.engine.deleg.event.FlowableActivityEvent;


/**
 * An {@link FlowableEvent} related to a signal being sent to an activity.
 * 
 * @author Frederik Heremans
 */
interface FlowableSignalEvent : FlowableActivityEvent {

    /**
     * @return the name of the signal. Returns null, if no specific signal name has been specified when signaling.
     */
    public string getSignalName();

    /**
     * @return the payload that was passed when signaling. Returns null, if no payload was passed.
     */
    public Object getSignalData();

}
