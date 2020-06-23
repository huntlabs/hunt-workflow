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

module flow.engine.impl.cmd.DeploymentSettings;
/**
 * @author Joram Barrez
 */
interface DeploymentSettings {

    static string IS_BPMN20_XSD_VALIDATION_ENABLED = "isBpmn20XsdValidationEnabled";

    static string IS_PROCESS_VALIDATION_ENABLED = "isProcessValidationEnabled";

    static string IS_DERIVED_DEPLOYMENT = "isDerivedDeployment";

    static string DERIVED_PROCESS_DEFINITION_ID = "derivedProcessDefinitionId";

    static string DERIVED_PROCESS_DEFINITION_ROOT_ID = "derivedProcessDefinitionRootId";
}
