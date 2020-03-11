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

module flow.engine.runtime.ChangeActivityStateBuilder;

import hunt.collection.List;
import hunt.collection.Map;
import hunt.Integer;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;

/**
 * Helper for changing the state of a process instance.
 *
 * An instance can be obtained through {@link flow.engine.RuntimeService#createChangeActivityStateBuilder()}.
 *
 * @author Tijs Rademakers
 */
interface ChangeActivityStateBuilder {

    /**
     * Set the id of the process instance
     **/
    ChangeActivityStateBuilder processInstanceId(string processInstanceId);

    /**
     * Set the id of the execution for which the activity should be changed
     **/
    ChangeActivityStateBuilder moveExecutionToActivityId(string executionId, string activityId);

    /**
     * Set the ids of the executions which should be changed to a single execution with the provided activity id.
     * This can be used for parallel execution like parallel/inclusive gateways, multiinstance, event sub processes etc.
     **/
    ChangeActivityStateBuilder moveExecutionsToSingleActivityId(List!string executionIds, string activityId);

    /**
     * Set the id of an execution which should be changed to multiple executions with the provided activity ids.
     * This can be used for parallel execution like parallel/inclusive gateways, multiinstance, event sub processes etc.
     **/
    ChangeActivityStateBuilder moveSingleExecutionToActivityIds(string executionId, List!string activityId);

    /**
     * Moves the execution with the current activity id to the provided new activity id
     */
    ChangeActivityStateBuilder moveActivityIdTo(string currentActivityId, string newActivityId);

    /**
     * Set the activity ids that should be changed to a single activity id.
     * This can be used for parallel execution like parallel/inclusive gateways, multiinstance, event sub processes etc.
     */
    ChangeActivityStateBuilder moveActivityIdsToSingleActivityId(List!string currentActivityIds, string newActivityId);

    /**
     * Set the activity id that should be changed to multiple activity ids.
     * This can be used for parallel execution like parallel/inclusive gateways, multiinstance, event sub processes etc.
     */
    ChangeActivityStateBuilder moveSingleActivityIdToActivityIds(string currentActivityId, List!string newActivityIds);

    /**
     * Moves the execution with the current activity id to an activity id in the parent process instance.
     * The sub process instance will be terminated, so all sub process instance executions need to be moved.
     */
    ChangeActivityStateBuilder moveActivityIdToParentActivityId(string currentActivityId, string newActivityId);

    /**
     * Moves the execution with the current activity id to an activity id in a new sub process instance for the provided call activity id.
     */
    ChangeActivityStateBuilder moveActivityIdToSubProcessInstanceActivityId(string currentActivityId, string newActivityId, string callActivityId);

    /**
     * Moves the execution with the current activity id to an activity id in a new sub process instance of the specific definition version for the provided call activity id.
     */
    ChangeActivityStateBuilder moveActivityIdToSubProcessInstanceActivityId(string currentActivityId, string newActivityId, string callActivityId, Integer subProcessDefinitionVersion);

    /**
     * Sets a process scope variable
     */
    ChangeActivityStateBuilder processVariable(string processVariableName, Object processVariableValue);

    /**
     * Sets multiple process scope variables
     */
    ChangeActivityStateBuilder processVariables(Map!(string, Object) processVariables);

    /**
     * Sets a local scope variable for a start activity id
     */
    ChangeActivityStateBuilder localVariable(string startActivityId, string localVariableName, Object localVariableValue);

    /**
     * Sets multiple local scope variables for a start activity id
     */
    ChangeActivityStateBuilder localVariables(string startActivityId, Map!(string, Object) localVariables);

    /**
     * Start the process instance
     *
     * @throws FlowableObjectNotFoundException
     *             when no process instance is found
     * @throws FlowableException
     *             activity could not be canceled or started
     **/
    void changeState();

}
