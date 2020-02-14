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
 
module flow.engine.delegata.event.FlowableEscalationEvent;
 
 
 


import flow.common.api.delegate.event.FlowableEvent;

/**
 * An {@link FlowableEvent} related to an escalation being sent to an activity.
 */
interface FlowableEscalationEvent : FlowableActivityEvent {

    /**
     * @return the code of the escalation. Returns null, if no specific escalation code has been specified.
     */
    public string getEscalationCode();

    /**
     * @return the name of the escalation. Returns null, if no specific escalation name has been specified.
     */
    public string getEscalationName();

}
