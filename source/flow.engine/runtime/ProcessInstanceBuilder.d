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

module flow.engine.runtime.ProcessInstanceBuilder;

import hunt.collection.Map;
import flow.engine.runtime.ProcessInstance;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;

/**
 * Helper for starting new ProcessInstance.
 *
 * An instance can be obtained through {@link flow.engine.RuntimeService#createProcessInstanceBuilder()}.
 *
 * processDefinitionId or processDefinitionKey should be set before calling {@link #start()} to start a process instance.
 *
 *
 * @author Bassam Al-Sarori
 * @author Joram Barrez
 */
interface ProcessInstanceBuilder {

    /**
     * Set the id of the process definition
     **/
    ProcessInstanceBuilder processDefinitionId(string processDefinitionId);

    /**
     * Set the key of the process definition, latest version of the process definition with the given key. If processDefinitionId was set this will be ignored
     **/
    ProcessInstanceBuilder processDefinitionKey(string processDefinitionKey);

    /**
     * Set the message name that needs to be used to look up the process definition that needs to be used to start the process instance.
     */
    ProcessInstanceBuilder messageName(string messageName);

    /**
     * Set the name of process instance
     **/
    ProcessInstanceBuilder name(string processInstanceName);

    /**
     * Set the businessKey of process instance
     **/
    ProcessInstanceBuilder businessKey(string businessKey);

    /**
     * Sets the callback identifier of the process instance.
     */
    ProcessInstanceBuilder callbackId(string callbackId);

    /**
     * Sets the callback type of the process instance.
     */
    ProcessInstanceBuilder callbackType(string callbackType);

    /**
     * Sets the reference identifier of the process instance.
     */
    ProcessInstanceBuilder referenceId(string referenceId);

    /**
     * Sets the reference type of the process instance.
     */
    ProcessInstanceBuilder referenceType(string referenceType);

    /**
     * Set the optional instance id of the stage this process instance belongs to, if it runns in the context of a CMMN case.
     */
    ProcessInstanceBuilder stageInstanceId(string stageInstanceId);

    /**
     * Set the tenantId of to lookup the process definition
     **/
    ProcessInstanceBuilder tenantId(string tenantId);

    /**
     * Indicator to override the tenant id of the process definition with the provided value.
     * The tenantId to lookup the process definition should still be provided if needed.
     */
    ProcessInstanceBuilder overrideProcessDefinitionTenantId(string tenantId);

    /**
     * When starting a process instance from the CMMN engine process task, the process instance id needs to be known beforehand
     * to store entity links and callback references before the process instance is started.
     */
    ProcessInstanceBuilder predefineProcessInstanceId(string processInstanceId);

    /**
     * Sets the process variables
     */
    ProcessInstanceBuilder variables(Map!(string, Object) variables);

    /**
     * Adds a variable to the process instance
     **/
    ProcessInstanceBuilder variable(string variableName, Object value);

    /**
     * Sets the transient variables
     */
    ProcessInstanceBuilder transientVariables(Map!(string, Object) transientVariables);

    /**
     * Adds a transient variable to the process instance
     */
    ProcessInstanceBuilder transientVariable(string variableName, Object value);

    /**
     * Adds variables from a start form to the process instance.
     */
    ProcessInstanceBuilder startFormVariables(Map!(string, Object) startFormVariables);

    /**
     * Adds one variable from a start form to the process instance.
     */
    ProcessInstanceBuilder startFormVariable(string variableName, Object value);

    /**
     * Allows to set an outcome for a start form.
     */
    ProcessInstanceBuilder outcome(string outcome);

    /**
     * Use default tenant as a fallback in the case when process definition was not found by key and tenant id
     */
    ProcessInstanceBuilder fallbackToDefaultTenant();

    /**
     * Start the process instance
     *
     * @throws FlowableIllegalArgumentException
     *             if processDefinitionKey and processDefinitionId are null
     * @throws FlowableObjectNotFoundException
     *             when no process definition is deployed with the given processDefinitionKey or processDefinitionId
     **/
    ProcessInstance start();

    /**
     * Start the process instance asynchronously
     *
     * @throws FlowableIllegalArgumentException
     *             if processDefinitionKey and processDefinitionId are null
     * @throws FlowableObjectNotFoundException
     *             when no process definition is deployed with the given processDefinitionKey or processDefinitionId
     **/
    ProcessInstance startAsync();

}
