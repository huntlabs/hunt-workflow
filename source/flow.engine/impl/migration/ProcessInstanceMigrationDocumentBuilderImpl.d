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



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.api.FlowableException;
import flow.engine.migration.ActivityMigrationMapping;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationDocumentBuilder;
import flow.engine.migration.Script;

/**
 * @author Dennis Federico
 * @author martin.grofcik
 */
class ProcessInstanceMigrationDocumentBuilderImpl implements ProcessInstanceMigrationDocumentBuilder {

    protected string migrateToProcessDefinitionId;
    protected string migrateToProcessDefinitionKey;
    protected Integer migrateToProcessDefinitionVersion;
    protected string migrateToProcessDefinitionTenantId;
    protected List<ActivityMigrationMapping> activityMigrationMappings = new ArrayList<>();
    protected Map<string, Object> processInstanceVariables = new HashMap<>();
    protected Script preUpgradeScript;
    protected string preUpgradeJavaDelegate;
    protected string preUpgradeJavaDelegateExpression;
    protected Script postUpgradeScript;
    protected string postUpgradeJavaDelegate;
    protected string postUpgradeJavaDelegateExpression;

    @Override
    public ProcessInstanceMigrationDocumentBuilder setProcessDefinitionToMigrateTo(string processDefinitionId) {
        this.migrateToProcessDefinitionId = processDefinitionId;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setProcessDefinitionToMigrateTo(string processDefinitionKey, Integer processDefinitionVersion) {
        this.migrateToProcessDefinitionKey = processDefinitionKey;
        this.migrateToProcessDefinitionVersion = processDefinitionVersion;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setTenantId(string processDefinitionTenantId) {
        this.migrateToProcessDefinitionTenantId = processDefinitionTenantId;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPreUpgradeScript(Script script) {
        this.preUpgradeScript = script;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPreUpgradeJavaDelegate(string preUpgradeJavaDelegate) {
        this.preUpgradeJavaDelegate = preUpgradeJavaDelegate;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPreUpgradeJavaDelegateExpression(string expression) {
        this.preUpgradeJavaDelegateExpression = expression;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPostUpgradeScript(Script script) {
        this.postUpgradeScript = script;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPostUpgradeJavaDelegate(string preUpgradeJavaDelegate) {
        this.postUpgradeJavaDelegate = preUpgradeJavaDelegate;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder setPostUpgradeJavaDelegateExpression(string expression) {
        this.postUpgradeJavaDelegateExpression = expression;
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder addActivityMigrationMappings(List<ActivityMigrationMapping> activityMigrationMappings) {
        this.activityMigrationMappings.addAll(activityMigrationMappings);
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder addActivityMigrationMapping(ActivityMigrationMapping activityMigrationMapping) {
        this.activityMigrationMappings.add(activityMigrationMapping);
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder addProcessInstanceVariable(string variableName, Object variableValue) {
        this.processInstanceVariables.put(variableName, variableValue);
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocumentBuilder addProcessInstanceVariables(Map<string, Object> processInstanceVariables) {
        this.processInstanceVariables.putAll(processInstanceVariables);
        return this;
    }

    @Override
    public ProcessInstanceMigrationDocument build() {

        if (migrateToProcessDefinitionId is null) {
            if (migrateToProcessDefinitionKey is null) {
                throw new FlowableException("Process definition key cannot be null");
            }
            if (migrateToProcessDefinitionVersion is null || migrateToProcessDefinitionVersion < 0) {
                throw new FlowableException("Process definition version must be a positive number");
            }
        }

        ProcessInstanceMigrationDocumentImpl document = new ProcessInstanceMigrationDocumentImpl();
        document.setMigrateToProcessDefinitionId(migrateToProcessDefinitionId);
        document.setMigrateToProcessDefinition(migrateToProcessDefinitionKey, migrateToProcessDefinitionVersion, migrateToProcessDefinitionTenantId);
        if (preUpgradeScript !is null) {
            document.setPreUpgradeScript(preUpgradeScript);
        }
        if (preUpgradeJavaDelegate !is null) {
            document.setPreUpgradeJavaDelegate(preUpgradeJavaDelegate);
        }
        if (preUpgradeJavaDelegateExpression !is null) {
            document.setPreUpgradeJavaDelegateExpression(preUpgradeJavaDelegateExpression);
        }
        if (postUpgradeScript !is null) {
            document.setPostUpgradeScript(postUpgradeScript);
        }
        if (postUpgradeJavaDelegate !is null) {
            document.setPostUpgradeJavaDelegate(postUpgradeJavaDelegate);
        }
        if (postUpgradeJavaDelegateExpression !is null) {
            document.setPostUpgradeJavaDelegateExpression(postUpgradeJavaDelegateExpression);
        }
        document.setActivityMigrationMappings(activityMigrationMappings);
        document.setProcessInstanceVariables(processInstanceVariables);

        return document;
    }

}
