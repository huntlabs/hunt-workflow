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
module flow.form.api.FormInstance;

import hunt.time.LocalDateTime;


alias Date = LocalDateTime;

/**
 * An object structure representing a submitted form.
 *
 * @author Tijs Rademakers
 * @author Joram Barez
 */
interface FormInstance {

    /** unique identifier */
    string getId();

    /**
     * Reference to the form definition of this form instance
     */
    string getFormDefinitionId();

    /**
     * Reference to the task for which the form instance was created
     */
    string getTaskId();

    /**
     * Reference to the process instance for which the form instance was created
     */
    string getProcessInstanceId();

    /**
     * Reference to the process definition for which the form instance was created
     */
    string getProcessDefinitionId();

    /**
     * Reference to the scope instance for which the form instance was created
     */
    string getScopeId();

    /**
     * Type of the scope instance for which the form instance was created
     */
    string getScopeType();

    /**
     * Reference to the scope instance definition for which the form instance was created
     */
    string getScopeDefinitionId();

    /**
     * Submitted date for the form instance
     */
    Date getSubmittedDate();

    /**
     * Reference to the user that submitted the form instance
     */
    string getSubmittedBy();

    /**
     * Reference to the JSON document id that contains the submitted form values
     */
    string getFormValuesId();

    /**
     * The tenant identifier of this form instance
     */
    string getTenantId();

    /**
     * The JSON document that contains the submitted form values
     */
    byte[] getFormValueBytes();

}
