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
 
module flow.common.event.FlowableEngineEventImpl;
 
 
 

import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.event.FlowableEventImpl;

/**
 * Base class for all {@link FlowableEngineEvent} implementations.
 *
 * @author Frederik Heremans
 */
class FlowableEngineEventImpl : FlowableEventImpl , FlowableEngineEvent {

    protected string executionId;
    protected string processInstanceId;
    protected string processDefinitionId;

    /**
     * Creates a new event implementation, not part of an execution context.
     */
    this(FlowableEngineEventType type) {
        this(type, null, null, null);
    }

    /**
     * Creates a new event implementation, part of an execution context.
     */
    this(FlowableEngineEventType type, string executionId, string processInstanceId, string processDefinitionId) {
        super(type);
        this.executionId = executionId;
        this.processInstanceId = processInstanceId;
        this.processDefinitionId = processDefinitionId;
    }

    override
    public FlowableEngineEventType getType() {
        return cast(FlowableEngineEventType) super.getType();
    }

    public void setType(FlowableEngineEventType type) {
        this.type = type;
    }

    public string getExecutionId() {
        return executionId;
    }

    public void setExecutionId(string executionId) {
        this.executionId = executionId;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public string getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }
}
