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

module flow.form.api.FormService;
import hunt.collection.Map;
import flow.form.api.FormInfo;
import flow.form.api.FormInstance;
import flow.form.api.FormInstanceInfo;
import flow.form.api.FormInstanceQuery;
/**
 * @author Tijs Rademakers
 */
interface FormService {

    /**
     * Apply validation restrictions on the submitted variables
     *
     * @param formInfo
     *     form description
     * @param values
     *     submitted variables
     * @throws flow.common.api.FlowableException in the case when validation failed
     */
    void validateFormFields(FormInfo formInfo, Map!(string, Object) values);

    /**
     * @param formInfo
     *            form definition to use for type-conversion and validation
     * @param values
     *            values submitted by the user
     * @param outcome
     *            outcome selected by the user. If null, no outcome is used and any outcome definitions are ignored.
     *
     * @return raw variables that can be used in the process engine, based on the filled in values and selected outcome.
     */
    Map!(string, Object) getVariablesFromFormSubmission(FormInfo formInfo, Map!(string, Object) values, string outcome);

    /**
     * Store the submitted form values.
     *
     * @param formInfo
     *            form instance of the submitted form
     * @param taskId
     *            task instance id of the completed task
     * @param processInstanceId
     *            process instance id of the completed task
     * @param variables
     *            json node with the values of the
     */
    FormInstance createFormInstance(Map!(string, Object) variables, FormInfo formInfo, string taskId, string processInstanceId, string processDefinitionId,
        string tenantId, string outcome);

    FormInstance saveFormInstance(Map!(string, Object) variables, FormInfo formInfo, string taskId, string processInstanceId, string processDefinitionId,
        string tenantId, string outcome);

    FormInstance saveFormInstanceByFormDefinitionId(Map!(string, Object) variables, string formDefinitionId, string taskId, string processInstanceId,
        string processDefinitionId, string tenantId, string outcome);

    FormInstance createFormInstanceWithScopeId(Map!(string, Object) variables, FormInfo formInfo, string taskId, string scopeId, string scopeType,
        string scopeDefinitionId, string tenantId, string outcome);

    FormInstance saveFormInstanceWithScopeId(Map!(string, Object) variables, FormInfo formInfo, string taskId, string scopeId, string scopeType,
        string scopeDefinitionId, string tenantId, string outcome);

    FormInstance saveFormInstanceWithScopeId(Map!(string, Object) variables, string formDefinitionId, string taskId, string scopeId, string scopeType,
        string scopeDefinitionId, string tenantId, string outcome);

    FormInfo getFormModelWithVariablesById(string formDefinitionId, string taskId, Map!(string, Object) variables);

    FormInfo getFormModelWithVariablesById(string formDefinitionId, string taskId, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInfo getFormModelWithVariablesByKey(string formDefinitionKey, string taskId, Map!(string, Object) variables);

    FormInfo getFormModelWithVariablesByKey(string formDefinitionKey, string taskId, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInfo getFormModelWithVariablesByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId, string taskId, Map!(string, Object) variables);

    FormInfo getFormModelWithVariablesByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId,
                    string taskId, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceInfo getFormInstanceModelById(string formInstanceId, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelById(string formDefinitionId, string taskId, string processInstanceId, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelById(string formDefinitionId, string taskId, string processInstanceId,
                    Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceInfo getFormInstanceModelByKey(string formDefinitionKey, string taskId, string processInstanceId, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelByKey(string formDefinitionKey, string taskId, string processInstanceId,
                    Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceInfo getFormInstanceModelByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId,
                    string taskId, string processInstanceId, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelByKeyAndParentDeploymentId(string formDefinitionKey, string parentDeploymentId,
                    string taskId, string processInstanceId, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceInfo getFormInstanceModelByKeyAndScopeId(string formDefinitionKey,
                    string scopeId, string scopeType, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelByKeyAndScopeId(string formDefinitionKey,
                    string scopeId, string scopeType, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceInfo getFormInstanceModelByKeyAndParentDeploymentIdAndScopeId(string formDefinitionKey, string parentDeploymentId,
                    string scopeId, string scopeType, Map!(string, Object) variables);

    FormInstanceInfo getFormInstanceModelByKeyAndParentDeploymentIdAndScopeId(string formDefinitionKey, string parentDeploymentId,
                    string scopeId, string scopeType, Map!(string, Object) variables, string tenantId, bool fallbackToDefaultTenant);

    FormInstanceQuery createFormInstanceQuery();

    byte[] getFormInstanceValues(string formInstanceId);

    void deleteFormInstance(string formInstanceId);

    void deleteFormInstancesByFormDefinition(string formDefinitionId);

    void deleteFormInstancesByProcessDefinition(string processDefinitionId);

    void deleteFormInstancesByScopeDefinition(string scopeDefinitionId);
}
