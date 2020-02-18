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



import flow.common.api.FlowableException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationManager;
import flow.engine.migration.ProcessInstanceMigrationValidationResult;

class ProcessInstanceMigrationValidationCmd implements Command<ProcessInstanceMigrationValidationResult> {
    
    protected string processInstanceId;
    protected string processDefinitionId;
    protected string processDefinitionKey;
    protected int processDefinitionVersion;
    protected string processDefinitionTenantId;
    protected ProcessInstanceMigrationDocument processInstanceMigrationDocument;

    public ProcessInstanceMigrationValidationCmd(string processInstanceId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        if (processInstanceId is null) {
            throw new FlowableException("Must specify a process instance id to migrate");
        }
        
        if (processInstanceMigrationDocument is null) {
            throw new FlowableException("Must specify a process migration document to migrate");
        }

        this.processInstanceId = processInstanceId;
        this.processInstanceMigrationDocument = processInstanceMigrationDocument;
    }

    public ProcessInstanceMigrationValidationCmd(ProcessInstanceMigrationDocument processInstanceMigrationDocument, string processDefinitionId) {
        if (processDefinitionId is null) {
            throw new FlowableException("Must specify a process definition id to migrate");
        }
        
        if (processInstanceMigrationDocument is null) {
            throw new FlowableException("Must specify a process migration document to migrate");
        }

        this.processDefinitionId = processDefinitionId;
        this.processInstanceMigrationDocument = processInstanceMigrationDocument;
    }

    public ProcessInstanceMigrationValidationCmd(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId, ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
        if (processDefinitionKey is null) {
            throw new FlowableException("Must specify a process definition key to migrate");
        }
        
        if (processInstanceMigrationDocument is null) {
            throw new FlowableException("Must specify a process migration document to migrate");
        }

        this.processDefinitionKey = processDefinitionKey;
        this.processDefinitionVersion = processDefinitionVersion;
        this.processDefinitionTenantId = processDefinitionTenantId;
    }

    @Override
    public ProcessInstanceMigrationValidationResult execute(CommandContext commandContext) {

        ProcessInstanceMigrationManager migrationManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceMigrationManager();

        if (processInstanceId !is null) {
            return migrationManager.validateMigrateProcessInstance(processInstanceId, processInstanceMigrationDocument, commandContext);
        }

        if (processDefinitionId !is null) {
            return migrationManager.validateMigrateProcessInstancesOfProcessDefinition(processDefinitionId, processInstanceMigrationDocument, commandContext);
        }

        if (processDefinitionKey !is null && processDefinitionVersion >= 0) {
            return migrationManager.validateMigrateProcessInstancesOfProcessDefinition(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, processInstanceMigrationDocument, commandContext);
        }

        throw new FlowableException("Cannot validate process migration, not enough information");
    }

}
