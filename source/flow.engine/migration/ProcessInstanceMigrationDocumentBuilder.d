///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import hunt.collection.List;
//import hunt.collection.Map;
//
///**
// * @author Dennis Federico
// * @author martin.grofcik
// */
//interface ProcessInstanceMigrationDocumentBuilder {
//
//    ProcessInstanceMigrationDocumentBuilder setProcessDefinitionToMigrateTo(string processDefinitionId);
//
//    ProcessInstanceMigrationDocumentBuilder setProcessDefinitionToMigrateTo(string processDefinitionKey, Integer processDefinitionVersion);
//
//    ProcessInstanceMigrationDocumentBuilder setTenantId(string processDefinitionTenantId);
//
//    ProcessInstanceMigrationDocumentBuilder setPreUpgradeScript(Script script);
//
//    ProcessInstanceMigrationDocumentBuilder setPreUpgradeJavaDelegate(string javaDelegateClassName);
//
//    ProcessInstanceMigrationDocumentBuilder setPreUpgradeJavaDelegateExpression(string expression);
//
//    ProcessInstanceMigrationDocumentBuilder setPostUpgradeScript(Script script);
//
//    ProcessInstanceMigrationDocumentBuilder setPostUpgradeJavaDelegate(string javaDelegateClassName);
//
//    ProcessInstanceMigrationDocumentBuilder setPostUpgradeJavaDelegateExpression(string expression);
//
//    ProcessInstanceMigrationDocumentBuilder addActivityMigrationMappings(List<ActivityMigrationMapping> activityMigrationMappings);
//
//    ProcessInstanceMigrationDocumentBuilder addActivityMigrationMapping(ActivityMigrationMapping activityMigrationMapping);
//
//    ProcessInstanceMigrationDocumentBuilder addProcessInstanceVariable(string variableName, Object variableValue);
//
//    ProcessInstanceMigrationDocumentBuilder addProcessInstanceVariables(Map!(string, Object) processInstanceVariables);
//
//    ProcessInstanceMigrationDocument build();
//
//}
