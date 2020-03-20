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

module flow.engine.ProcessMigrationService;
import flow.batch.service.api.Batch;
import flow.engine.migration.ProcessInstanceBatchMigrationResult;
import flow.engine.migration.ProcessInstanceMigrationBuilder;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationValidationResult;

/**
 * Service to manager process instance migrations.
 */
interface ProcessMigrationService {

    ProcessInstanceMigrationBuilder createProcessInstanceMigrationBuilder();

    ProcessInstanceMigrationBuilder createProcessInstanceMigrationBuilderFromProcessInstanceMigrationDocument(ProcessInstanceMigrationDocument document);

    ProcessInstanceMigrationValidationResult validateMigrationForProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    ProcessInstanceMigrationValidationResult validateMigrationForProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    ProcessInstanceMigrationValidationResult validateMigrationForProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    void migrateProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    void migrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    void migrateProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    Batch batchMigrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    Batch batchMigrateProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument);

    ProcessInstanceBatchMigrationResult getResultsOfBatchProcessInstanceMigration(string migrationBatchId);
}

