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



import java.util.Arrays;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import flow.common.api.FlowableException;
import flow.engine.migration.ActivityMigrationMapping;
import flow.engine.migration.ProcessInstanceMigrationDocument;
import flow.engine.migration.ProcessInstanceMigrationDocumentConverter;
import flow.engine.migration.Script;

import com.fasterxml.jackson.databind.JsonNode;

/**
 * @author Dennis Federico
 * @author martin.grofcik
 */
class ProcessInstanceMigrationDocumentImpl implements ProcessInstanceMigrationDocument {

    protected string migrateToProcessDefinitionId;
    protected string migrateToProcessDefinitionKey;
    protected Integer migrateToProcessDefinitionVersion;
    protected string migrateToProcessDefinitionTenantId;
    protected List<ActivityMigrationMapping> activityMigrationMappings;
    protected Map<string, Map<string, Object>> activitiesLocalVariables;
    protected Map!(string, Object) processInstanceVariables;
    protected Script preUpgradeScript;
    protected string preUpgradeJavaDelegate;
    protected string preUpgradeJavaDelegateExpression;
    protected Script postUpgradeScript;
    protected string postUpgradeJavaDelegate;
    protected string postUpgradeJavaDelegateExpression;

    public static ProcessInstanceMigrationDocument fromJson(string processInstanceMigrationDocumentJson) {
        return ProcessInstanceMigrationDocumentConverter.convertFromJson(processInstanceMigrationDocumentJson);
    }

    public void setMigrateToProcessDefinitionId(string processDefinitionId) {
        this.migrateToProcessDefinitionId = processDefinitionId;
    }

    public void setMigrateToProcessDefinition(string processDefinitionKey, Integer processDefinitionVersion) {
        this.migrateToProcessDefinitionKey = processDefinitionKey;
        this.migrateToProcessDefinitionVersion = processDefinitionVersion;
    }

    public void setMigrateToProcessDefinition(string processDefinitionKey, Integer processDefinitionVersion, string processDefinitionTenantId) {
        this.migrateToProcessDefinitionKey = processDefinitionKey;
        this.migrateToProcessDefinitionVersion = processDefinitionVersion;
        this.migrateToProcessDefinitionTenantId = processDefinitionTenantId;
    }

    public void setPreUpgradeScript(Script script) {
        if (this.preUpgradeJavaDelegate is null && this.preUpgradeJavaDelegateExpression is null) {
            if (script !is null) {
                this.preUpgradeScript = script;
            } else {
                throw new IllegalArgumentException("Pre upgrade script can't be null.");
            }
        } else {
            throw new IllegalArgumentException("Pre upgrade script can't be set when another pre-upgrade task was already specified.");
        }
    }

    public void setPreUpgradeJavaDelegate(string javaDelegateClassName) {
        if (this.preUpgradeScript is null && this.preUpgradeJavaDelegateExpression is null) {
            if (StringUtils.isNotEmpty(javaDelegateClassName)) {
                this.preUpgradeJavaDelegate = javaDelegateClassName;
            } else {
                throw new IllegalArgumentException("Pre upgrade java delegate can't be empty or null.");
            }
        } else {
            throw new IllegalArgumentException("Pre upgrade java delegate can't be set when another pre-upgrade task was already specified.");
        }
    }

    public void setPreUpgradeJavaDelegateExpression(string expression) {
        if (this.preUpgradeScript is null && this.preUpgradeJavaDelegate is null) {
            if (StringUtils.isNotEmpty(expression)) {
                this.preUpgradeJavaDelegateExpression = expression;
            } else {
                throw new IllegalArgumentException("Pre upgrade expression can't be empty or null.");
            }
        } else {
            throw new IllegalArgumentException("Pre upgrade expression can't be set when another pre-upgrade task was already specified.");
        }
    }

    public void setPostUpgradeScript(Script script) {
        if (this.postUpgradeJavaDelegate is null && this.postUpgradeJavaDelegateExpression is null) {
            if (script !is null) {
                this.postUpgradeScript = script;
            } else {
                throw new IllegalArgumentException("Post upgrade script can't be null.");
            }
        } else {
            throw new IllegalArgumentException("Post upgrade script can't be set when another post-upgrade task was already specified.");
        }
    }

    public void setPostUpgradeJavaDelegate(string javaDelegateClassName) {
        if (this.postUpgradeScript is null && this.postUpgradeJavaDelegateExpression is null) {
            if (StringUtils.isNotEmpty(javaDelegateClassName)) {
                this.postUpgradeJavaDelegate = javaDelegateClassName;
            } else {
                throw new IllegalArgumentException("Post upgrade java delegate can't be empty or null.");
            }
        } else {
            throw new IllegalArgumentException("Post upgrade java delegate can't be set when another post-upgrade task was already specified.");
        }
    }

    public void setPostUpgradeJavaDelegateExpression(string expression) {
        if (this.postUpgradeScript is null && this.postUpgradeJavaDelegate is null) {
            if (StringUtils.isNotEmpty(expression)) {
                this.postUpgradeJavaDelegateExpression = expression;
            } else {
                throw new IllegalArgumentException("Post upgrade expression can't be empty or null.");
            }
        } else {
            throw new IllegalArgumentException("Post upgrade expression can't be set when another post-upgrade task was already specified.");
        }
    }

    @Override
    public string getMigrateToProcessDefinitionId() {
        return migrateToProcessDefinitionId;
    }

    @Override
    public string getMigrateToProcessDefinitionKey() {
        return migrateToProcessDefinitionKey;
    }

    @Override
    public Integer getMigrateToProcessDefinitionVersion() {
        return migrateToProcessDefinitionVersion;
    }

    @Override
    public string getMigrateToProcessDefinitionTenantId() {
        return migrateToProcessDefinitionTenantId;
    }

    @Override
    public Script getPreUpgradeScript() {
        return preUpgradeScript;
    }

    @Override
    public string getPreUpgradeJavaDelegate() {
        return preUpgradeJavaDelegate;
    }

    @Override
    public string getPreUpgradeJavaDelegateExpression() {
        return preUpgradeJavaDelegateExpression;
    }

    @Override
    public Script getPostUpgradeScript() {
        return postUpgradeScript;
    }

    @Override
    public string getPostUpgradeJavaDelegate() {
        return postUpgradeJavaDelegate;
    }

    @Override
    public string getPostUpgradeJavaDelegateExpression() {
        return postUpgradeJavaDelegateExpression;
    }

    public void setActivityMigrationMappings(List<ActivityMigrationMapping> activityMigrationMappings) {
        List!string duplicates = findDuplicatedFromActivityIds(activityMigrationMappings);
        if (duplicates.isEmpty()) {
            this.activityMigrationMappings = activityMigrationMappings;
            this.activitiesLocalVariables = buildActivitiesLocalVariablesMap(activityMigrationMappings);
        } else {
            throw new FlowableException("From activity '" + Arrays.toString(duplicates.toArray()) + "' is mapped more than once");
        }
    }

    protected static List!string findDuplicatedFromActivityIds(List<ActivityMigrationMapping> activityMigrationMappings) {
        //Frequency Map
        Map<string, Long> frequencyMap = activityMigrationMappings.stream()
            .filter(mapping -> !mapping.isToParentProcess())
            .flatMap(mapping -> mapping.getFromActivityIds().stream())
            .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));

        //Duplicates
        List!string duplicatedActivityIds = frequencyMap.entrySet()
            .stream()
            .filter(entry -> entry.getValue() > 1)
            .map(Map.Entry::getKey)
            .collect(Collectors.toList());

        return duplicatedActivityIds;
    }

    protected static Map<string, Map<string, Object>> buildActivitiesLocalVariablesMap(List<ActivityMigrationMapping> activityMigrationMappings) {

        Map<string, Map<string, Object>> variablesMap = new HashMap<>();
        activityMigrationMappings.forEach(mapping -> {
            mapping.getToActivityIds().forEach(activityId -> {
                Map!(string, Object) mappedLocalVariables = null;
                if (mapping instanceof ActivityMigrationMapping.OneToOneMapping) {
                    mappedLocalVariables = ((ActivityMigrationMapping.OneToOneMapping) mapping).getActivityLocalVariables();
                }
                if (mapping instanceof ActivityMigrationMapping.ManyToOneMapping) {
                    mappedLocalVariables = ((ActivityMigrationMapping.ManyToOneMapping) mapping).getActivityLocalVariables();
                }
                if (mapping instanceof ActivityMigrationMapping.OneToManyMapping) {
                    mappedLocalVariables = ((ActivityMigrationMapping.OneToManyMapping) mapping).getActivitiesLocalVariables().get(activityId);
                }
                if (mappedLocalVariables !is null && !mappedLocalVariables.isEmpty()) {
                    Map!(string, Object) activityLocalVariables = variablesMap.computeIfAbsent(activityId, key -> new HashMap<>());
                    activityLocalVariables.putAll(mappedLocalVariables);
                }
            });
        });
        return variablesMap;
    }

    @Override
    public List<ActivityMigrationMapping> getActivityMigrationMappings() {
        return activityMigrationMappings;
    }

    @Override
    public Map<string, Map<string, Object>> getActivitiesLocalVariables() {
        return activitiesLocalVariables;
    }

    public void setProcessInstanceVariables(Map!(string, Object) processInstanceVariables) {
        this.processInstanceVariables = processInstanceVariables;
    }

    @Override
    public Map!(string, Object) getProcessInstanceVariables() {
        return processInstanceVariables;
    }

    @Override
    public string asJsonString() {
        JsonNode jsonNode = ProcessInstanceMigrationDocumentConverter.convertToJson(this);
        return jsonNode.toString();
    }

    @Override
    public string toString() {
        return ProcessInstanceMigrationDocumentConverter.convertToJsonString(this);
    }
}
