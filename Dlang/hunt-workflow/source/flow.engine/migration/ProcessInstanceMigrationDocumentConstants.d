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


/**
 * @author Dennis
 * @author martin.grofcik
 */
interface ProcessInstanceMigrationDocumentConstants {

    string TO_PROCESS_DEFINITION_ID_JSON_PROPERTY = "toProcessDefinitionId";
    string TO_PROCESS_DEFINITION_KEY_JSON_PROPERTY = "toProcessDefinitionKey";
    string TO_PROCESS_DEFINITION_VERSION_JSON_PROPERTY = "toProcessDefinitionVersion";
    string TO_PROCESS_DEFINITION_TENANT_ID_JSON_PROPERTY = "toProcessDefinitionTenantId";

    string FROM_ACTIVITY_ID_JSON_PROPERTY = "fromActivityId";
    string FROM_ACTIVITY_IDS_JSON_PROPERTY = "fromActivityIds";
    string TO_ACTIVITY_ID_JSON_PROPERTY = "toActivityId";
    string TO_ACTIVITY_IDS_JSON_PROPERTY = "toActivityIds";
    string NEW_ASSIGNEE_JSON_PROPERTY = "newAssignee";

    string IN_SUB_PROCESS_OF_CALL_ACTIVITY_ID_JSON_PROPERTY = "inSubProcessOfCallActivityId";
    string CALL_ACTIVITY_PROCESS_DEFINITION_VERSION_JSON_PROPERTY = "callActivityProcessDefinitionVersion";
    string IN_PARENT_PROCESS_OF_CALL_ACTIVITY_JSON_PROPERTY = "inParentProcessOfCallActivityId";

    string PRE_UPGRADE_JAVA_DELEGATE = "preUpgradeJavaDelegate";
    string PRE_UPGRADE_JAVA_DELEGATE_EXPRESSION = "preUpgradeJavaDelegateExpression";
    string PRE_UPGRADE_SCRIPT = "preUpgradeScript";
    string POST_UPGRADE_JAVA_DELEGATE = "postUpgradeJavaDelegate";
    string POST_UPGRADE_JAVA_DELEGATE_EXPRESSION = "postUpgradeJavaDelegateExpression";
    string POST_UPGRADE_SCRIPT = "postUpgradeScript";
    string LANGUAGE = "language";
    string SCRIPT = "script";

    string ACTIVITY_MAPPINGS_JSON_SECTION = "activityMappings";
    string LOCAL_VARIABLES_JSON_SECTION = "localVariables";
    string PROCESS_INSTANCE_VARIABLES_JSON_SECTION = "processInstanceVariables";

}

