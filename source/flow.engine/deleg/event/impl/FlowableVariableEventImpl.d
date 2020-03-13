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

module flow.engine.deleg.event.impl.FlowableVariableEventImpl;




import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.variable.service.api.event.FlowableVariableEvent;
import flow.variable.service.api.types.VariableType;

/**
 * Implementation of {@link FlowableVariableEvent}.
 *
 * @author Frederik Heremans
 */
class FlowableVariableEventImpl : FlowableProcessEventImpl , FlowableVariableEvent {

    protected string variableName;
    protected Object variableValue;
    protected VariableType variableType;
    protected string taskId;
    protected string scopeId;
    protected string scopeType;

    this(FlowableEngineEventType type) {
        super(type);
    }

    @Override
    public string getVariableName() {
        return variableName;
    }

    public void setVariableName(string variableName) {
        this.variableName = variableName;
    }

    @Override
    public Object getVariableValue() {
        return variableValue;
    }

    public void setVariableValue(Object variableValue) {
        this.variableValue = variableValue;
    }

    @Override
    public VariableType getVariableType() {
        return variableType;
    }

    public void setVariableType(VariableType variableType) {
        this.variableType = variableType;
    }

    @Override
    public string getTaskId() {
        return taskId;
    }

    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public string getScopeId() {
        return scopeId;
    }

    public void setScopeId(string scopeId) {
        this.scopeId = scopeId;
    }

    @Override
    public string getScopeType() {
        return scopeType;
    }

    public void setScopeType(string scopeType) {
        this.scopeType = scopeType;
    }
}
