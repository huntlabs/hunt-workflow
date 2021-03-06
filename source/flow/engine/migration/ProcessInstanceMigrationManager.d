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
//import flow.batch.service.api.Batch;
//import flow.common.interceptor.CommandContext;
//
//interface ProcessInstanceMigrationManager {
//
//    ProcessInstanceMigrationValidationResult validateMigrateProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenant, ProcessInstanceMigrationDocument processInstanceMigrationDocument, CommandContext commandContext);
//
//    ProcessInstanceMigrationValidationResult validateMigrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument, CommandContext commandContext);
//
//    ProcessInstanceMigrationValidationResult validateMigrateProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument, CommandContext commandContext);
//
//    void migrateProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument document, CommandContext commandContext);
//
//    void migrateProcessInstancesOfProcessDefinition(string procDefKey, int procDefVer, string procDefTenantId, ProcessInstanceMigrationDocument document, CommandContext commandContext);
//
//    void migrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument document, CommandContext commandContext);
//
//    Batch batchMigrateProcessInstancesOfProcessDefinition(string procDefKey, int procDefVer, string procDefTenantId, ProcessInstanceMigrationDocument document, CommandContext commandContext);
//
//    Batch batchMigrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument document, CommandContext commandContext);
//}
