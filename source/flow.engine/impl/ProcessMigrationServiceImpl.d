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


import flow.batch.service.api.Batch;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.ProcessMigrationService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.GetProcessInstanceMigrationBatchResultCmd;
import flow.engine.impl.cmd.ProcessInstanceMigrationBatchCmd;
import flow.engine.impl.cmd.ProcessInstanceMigrationCmd;
import flow.engine.impl.cmd.ProcessInstanceMigrationValidationCmd;
import flow.engine.impl.migration.ProcessInstanceMigrationBuilderImpl;
import flow.engine.migration.ProcessInstanceBatchMigrationResult;
import flow.engine.migration.ProcessInstanceMigrationBuilder;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationValidationResult;

class ProcessMigrationServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl implements ProcessMigrationService {

    public ProcessMigrationServiceImpl(ProcessEngineConfigurationImpl configuration) {
        super(configuration);
    }

    override
    public ProcessInstanceMigrationBuilder createProcessInstanceMigrationBuilder() {
        return new ProcessInstanceMigrationBuilderImpl(this);
    }

    override
    public ProcessInstanceMigrationBuilder createProcessInstanceMigrationBuilderFromProcessInstanceMigrationDocument(ProcessInstanceMigrationDocument document) {
        return createProcessInstanceMigrationBuilder().fromProcessInstanceMigrationDocument(document);
    }

    override
    public ProcessInstanceMigrationValidationResult validateMigrationForProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        return commandExecutor.execute(new ProcessInstanceMigrationValidationCmd(processInstanceId, processInstanceMigrationDocument));
    }

    override
    public ProcessInstanceMigrationValidationResult validateMigrationForProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        return commandExecutor.execute(new ProcessInstanceMigrationValidationCmd(processInstanceMigrationDocument, processDefinitionId));
    }

    override
    public ProcessInstanceMigrationValidationResult validateMigrationForProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        return commandExecutor.execute(new ProcessInstanceMigrationValidationCmd(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, processInstanceMigrationDocument));
    }

    override
    public void migrateProcessInstance(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        commandExecutor.execute(new ProcessInstanceMigrationCmd(processInstanceId, processInstanceMigrationDocument));
    }

    override
    public void migrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        commandExecutor.execute(new ProcessInstanceMigrationCmd(processInstanceMigrationDocument, processDefinitionId));
    }

    override
    public void migrateProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        commandExecutor.execute(new ProcessInstanceMigrationCmd(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, processInstanceMigrationDocument));
    }

    override
    public Batch batchMigrateProcessInstancesOfProcessDefinition(string processDefinitionId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        return commandExecutor.execute(new ProcessInstanceMigrationBatchCmd(processDefinitionId, processInstanceMigrationDocument));
    }

    override
    public Batch batchMigrateProcessInstancesOfProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        return commandExecutor.execute(new ProcessInstanceMigrationBatchCmd(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, processInstanceMigrationDocument));
    }

    override
    public ProcessInstanceBatchMigrationResult getResultsOfBatchProcessInstanceMigration(string migrationBatchId) {
        return commandExecutor.execute(new GetProcessInstanceMigrationBatchResultCmd(migrationBatchId));
    }
}

