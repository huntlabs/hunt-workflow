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
 
module flow.engine.deleg.event.FlowableProcessStartedEvent;
 
 
 


import flow.common.api.deleg.event.FlowableEvent;
import flow.engine.deleg.event.FlowableEntityWithVariablesEvent;
/**
 * An {@link FlowableEvent} related to start event being sent when a process instance is started.
 *
 * @author Christophe DENEUX - Linagora
 */
interface FlowableProcessStartedEvent : FlowableEntityWithVariablesEvent {

    /**
     * @return the id of the process instance of the nested process that starts the current process instance, or null if the current process instance is not started into a nested process.
     */
    string getNestedProcessInstanceId();

    /**
     * @return the id of the process definition of the nested process that starts the current process instance, or null if the current process instance is not started into a nested process.
     */
    string getNestedProcessDefinitionId();
}
