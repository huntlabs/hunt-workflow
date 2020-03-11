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

module flow.variable.service.api.history.HistoricVariableInstanceQuery;

import hunt.collection.Set;

import flow.common.api.query.Query;
import flow.variable.service.api.history.HistoricVariableInstance;

/**
 * Programmatic querying for {@link HistoricVariableInstance}s.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface HistoricVariableInstanceQuery : Query!(HistoricVariableInstanceQuery, HistoricVariableInstance) {

    /** Only select a historic variable with the given id. */
    HistoricVariableInstanceQuery id(string id);

    /** Only select historic process variables with the given process instance. */
    HistoricVariableInstanceQuery processInstanceId(string processInstanceId);

    /** Only select historic process variables with the given id. **/
    HistoricVariableInstanceQuery executionId(string executionId);

    /** Only select historic process variables whose id is in the given set of ids. */
    HistoricVariableInstanceQuery executionIds(Set!string executionIds);

    /** Only select historic process variables with the given task. */
    HistoricVariableInstanceQuery taskId(string taskId);

    /** Only select historic process variables whose id is in the given set of ids. */
    HistoricVariableInstanceQuery taskIds(Set!string taskIds);

    /** Only select historic process variables with the given variable name. */
    HistoricVariableInstanceQuery variableName(string variableName);

    /** Only select historic process variables where the given variable name is like. */
    HistoricVariableInstanceQuery variableNameLike(string variableNameLike);

    /** Only select historic process variables which were not set task-local. */
    HistoricVariableInstanceQuery excludeTaskVariables();

    /** Don't initialize variable values. This is foremost a way to deal with variable delete queries */
    HistoricVariableInstanceQuery excludeVariableInitialization();

    /** only select historic process variables with the given name and value */
    HistoricVariableInstanceQuery variableValueEquals(string variableName, Object variableValue);

    /**
     * only select historic process variables that don't have the given name and value
     */
    HistoricVariableInstanceQuery variableValueNotEquals(string variableName, Object variableValue);

    /**
     * only select historic process variables like the given name and value
     */
    HistoricVariableInstanceQuery variableValueLike(string variableName, string variableValue);

    /**
     * only select historic process variables like the given name and value (case insensitive)
     */
    HistoricVariableInstanceQuery variableValueLikeIgnoreCase(string variableName, string variableValue);

    /**
     * Only select historic variables with the given scope id.
     */
    HistoricVariableInstanceQuery scopeId(string scopeId);

    /**
     * Only select historic variables with the given sub scope id.
     */
    HistoricVariableInstanceQuery subScopeId(string subScopeId);

    /**
     * Only select historic variables with the give scope type.
     */
    HistoricVariableInstanceQuery scopeType(string scopeType);

    HistoricVariableInstanceQuery orderByProcessInstanceId();

    HistoricVariableInstanceQuery orderByVariableName();

}
