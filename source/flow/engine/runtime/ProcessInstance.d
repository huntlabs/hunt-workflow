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


module flow.engine.runtime.ProcessInstance;

import hunt.time.LocalDateTime;
import hunt.collection.Map;
import hunt.time.LocalDateTime;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;


alias Date = LocalDateTime;
/**
 * Represents one execution of a {@link ProcessDefinition}.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Daniel Meyer
 * @author Tijs Rademakers
 */
interface ProcessInstance : Execution {

    /**
     * The id of the process definition of the process instance.
     */
    string getProcessDefinitionId();

    /**
     * The name of the process definition of the process instance.
     */
    string getProcessDefinitionName();

    /**
     * The key of the process definition of the process instance.
     */
    string getProcessDefinitionKey();

    /**
     * The version of the process definition of the process instance.
     */
    int getProcessDefinitionVersion();

    /**
     * The deployment id of the process definition of the process instance.
     */
    string getDeploymentId();

    /**
     * The business key of this process instance.
     */
    string getBusinessKey();

    /**
     * returns true if the process instance is suspended
     */

    bool isSuspended();

    /**
     * Returns the process variables if requested in the process instance query
     */
    Map!(string, Object) getProcessVariables();

    /**
     * The tenant identifier of this process instance
     */

    string getTenantId();

    /**
     * Returns the name of this process instance.
     */

    string getName();

    /**
     * Returns the description of this process instance.
     */

    string getDescription();

    /**
     * Returns the localized name of this process instance.
     */
    string getLocalizedName();

    /**
     * Returns the localized description of this process instance.
     */
    string getLocalizedDescription();

    /**
     * Returns the start time of this process instance.
     */
    Date getStartTime();

    /**
     * Returns the user id of this process instance.
     */
    string getStartUserId();

    /**
     * Returns the callback id of this process instance.
     */
    string getCallbackId();

    /**
     * Returns the callback type of this process instance.
     */
    string getCallbackType();
}
