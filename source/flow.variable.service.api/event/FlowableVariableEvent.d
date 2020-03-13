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
module flow.variable.service.api.event.FlowableVariableEvent;

import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.variable.service.api.types.VariableType;

/**
 * An {@link FlowableEvent} related to a single variable.
 *
 * @author Frederik Heremans
 * @author Joram Barrez
 */
interface FlowableVariableEvent : FlowableEngineEvent {

    /**
     * @return the name of the variable involved.
     */
    string getVariableName();

    /**
     * @return the current value of the variable.
     */
    Object getVariableValue();

    /**
     * @return The {@link VariableType} of the variable.
     */
    VariableType getVariableType();

    /**
     * @return the id of the task the variable has been set on.
     */
    string getTaskId();

    /**
     * @return the id of the scope the variable has been set on.
     */
    string getScopeId();

    /**
     * @return the type of the scope the variable has been set on.
     */
    string getScopeType();
}
