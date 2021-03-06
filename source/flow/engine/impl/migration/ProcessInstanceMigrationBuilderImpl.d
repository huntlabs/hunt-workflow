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
//import hunt.collection.Map;
//
//import flow.batch.service.api.Batch;
//import flow.common.api.FlowableException;
//import flow.engine.ProcessMigrationService;
//import flow.engine.migration.ActivityMigrationMapping;
//import flow.engine.migration.ProcessInstanceMigrationBuilder;
//import flow.engine.migration.ProcessInstanceMigrationDocument;
//import flow.engine.migration.ProcessInstanceMigrationValidationResult;
//import flow.engine.migration.Script;
//
//class ProcessInstanceMigrationBuilderImpl implements ProcessInstanceMigrationBuilder {
//
//    protected ProcessMigrationService processInstanceMigrationService;
//    protected ProcessInstanceMigrationDocumentBuilderImpl migrationDocumentBuilder = new ProcessInstanceMigrationDocumentBuilderImpl();
//
//    public ProcessInstanceMigrationBuilderImpl(ProcessMigrationService processInstanceMigrationService) {
//        this.processInstanceMigrationService = processInstanceMigrationService;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder fromProcessInstanceMigrationDocument(ProcessInstanceMigrationDocument document) {
//        migrationDocumentBuilder.setProcessDefinitionToMigrateTo(document.getMigrateToProcessDefinitionId());
//        migrationDocumentBuilder.setProcessDefinitionToMigrateTo(document.getMigrateToProcessDefinitionKey(), document.getMigrateToProcessDefinitionVersion());
//        migrationDocumentBuilder.setTenantId(document.getMigrateToProcessDefinitionTenantId());
//        migrationDocumentBuilder.addActivityMigrationMappings(document.getActivityMigrationMappings());
//        migrationDocumentBuilder.setPreUpgradeScript(document.getPreUpgradeScript());
//        migrationDocumentBuilder.setPreUpgradeJavaDelegate(document.getPreUpgradeJavaDelegate());
//        migrationDocumentBuilder.setPreUpgradeJavaDelegateExpression(document.getPreUpgradeJavaDelegateExpression());
//        migrationDocumentBuilder.setPostUpgradeScript(document.getPostUpgradeScript());
//        migrationDocumentBuilder.setPostUpgradeJavaDelegate(document.getPostUpgradeJavaDelegate());
//        migrationDocumentBuilder.setPostUpgradeJavaDelegateExpression(document.getPostUpgradeJavaDelegateExpression());
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder migrateToProcessDefinition(string processDefinitionId) {
//        this.migrationDocumentBuilder.setProcessDefinitionToMigrateTo(processDefinitionId);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder migrateToProcessDefinition(string processDefinitionKey, int processDefinitionVersion) {
//        this.migrationDocumentBuilder.setProcessDefinitionToMigrateTo(processDefinitionKey, processDefinitionVersion);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder migrateToProcessDefinition(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId) {
//        this.migrationDocumentBuilder.setProcessDefinitionToMigrateTo(processDefinitionKey, processDefinitionVersion);
//        this.migrationDocumentBuilder.setTenantId(processDefinitionTenantId);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder withMigrateToProcessDefinitionTenantId(string processDefinitionTenantId) {
//        this.migrationDocumentBuilder.setTenantId(processDefinitionTenantId);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder preUpgradeScript(Script script) {
//        this.migrationDocumentBuilder.setPreUpgradeScript(script);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder preUpgradeJavaDelegate(string javaDelegateClassName) {
//        this.migrationDocumentBuilder.setPreUpgradeJavaDelegate(javaDelegateClassName);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder preUpgradeJavaDelegateExpression(string expression) {
//        this.migrationDocumentBuilder.setPreUpgradeJavaDelegateExpression(expression);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder postUpgradeScript(Script script) {
//        this.migrationDocumentBuilder.setPostUpgradeScript(script);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder postUpgradeJavaDelegate(string javaDelegateClassName) {
//        this.migrationDocumentBuilder.setPostUpgradeJavaDelegate(javaDelegateClassName);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder postUpgradeJavaDelegateExpression(string expression) {
//        this.migrationDocumentBuilder.setPostUpgradeJavaDelegateExpression(expression);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder addActivityMigrationMapping(ActivityMigrationMapping mapping) {
//        this.migrationDocumentBuilder.addActivityMigrationMapping(mapping);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder withProcessInstanceVariable(string variableName, Object variableValue) {
//        this.migrationDocumentBuilder.processInstanceVariables.put(variableName, variableValue);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationBuilder withProcessInstanceVariables(Map!(string, Object) variables) {
//        this.migrationDocumentBuilder.processInstanceVariables.putAll(variables);
//        return this;
//    }
//
//    override
//    public ProcessInstanceMigrationDocument getProcessInstanceMigrationDocument() {
//        return this.migrationDocumentBuilder.build();
//    }
//
//    override
//    public void migrate(string processInstanceId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        getProcessMigrationService().migrateProcessInstance(processInstanceId, document);
//    }
//
//    override
//    public ProcessInstanceMigrationValidationResult validateMigration(string processInstanceId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        return getProcessMigrationService().validateMigrationForProcessInstance(processInstanceId, document);
//    }
//
//    override
//    public void migrateProcessInstances(string processDefinitionId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        getProcessMigrationService().migrateProcessInstancesOfProcessDefinition(processDefinitionId, document);
//    }
//
//    override
//    public ProcessInstanceMigrationValidationResult validateMigrationOfProcessInstances(string processDefinitionId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        return getProcessMigrationService().validateMigrationForProcessInstancesOfProcessDefinition(processDefinitionId, document);
//    }
//
//    override
//    public void migrateProcessInstances(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        getProcessMigrationService().migrateProcessInstancesOfProcessDefinition(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, document);
//    }
//
//    override
//    public Batch batchMigrateProcessInstances(string processDefinitionId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        return getProcessMigrationService().batchMigrateProcessInstancesOfProcessDefinition(processDefinitionId, document);
//    }
//
//    override
//    public Batch batchMigrateProcessInstances(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        return getProcessMigrationService().batchMigrateProcessInstancesOfProcessDefinition(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, document);
//    }
//
//    override
//    public ProcessInstanceMigrationValidationResult validateMigrationOfProcessInstances(string processDefinitionKey, int processDefinitionVersion, string processDefinitionTenantId) {
//        ProcessInstanceMigrationDocument document = migrationDocumentBuilder.build();
//        return getProcessMigrationService().validateMigrationForProcessInstancesOfProcessDefinition(processDefinitionKey, processDefinitionVersion, processDefinitionTenantId, document);
//    }
//
//    protected ProcessMigrationService getProcessMigrationService() {
//        if (processInstanceMigrationService is null) {
//            throw new FlowableException("ProcessInstanceMigrationService cannot be null, Obtain your builder instance from the ProcessInstanceMigrationService to access this feature");
//        }
//        return processInstanceMigrationService;
//    }
//}
