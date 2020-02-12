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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Dennis
 */
abstract class ActivityMigrationMapping {

    protected string toCallActivityId;
    protected Integer callActivityProcessDefinitionVersion;
    protected string fromCallActivityId;

    abstract List<string> getFromActivityIds();

    abstract List<string> getToActivityIds();

    public boolean isToParentProcess() {
        return this.fromCallActivityId != null;
    }

    public boolean isToCallActivity() {
        return this.toCallActivityId != null;
    }

    public string getToCallActivityId() {
        return toCallActivityId;
    }

    public Integer getCallActivityProcessDefinitionVersion() {
        return callActivityProcessDefinitionVersion;
    }

    public string getFromCallActivityId() {
        return fromCallActivityId;
    }

    public static ActivityMigrationMapping.OneToOneMapping createMappingFor(string fromActivityId, string toActivityId) {
        return new OneToOneMapping(fromActivityId, toActivityId);
    }

    public static ActivityMigrationMapping.OneToManyMapping createMappingFor(string fromActivityId, List<string> toActivityIds) {
        return new OneToManyMapping(fromActivityId, toActivityIds);
    }

    public static ActivityMigrationMapping.ManyToOneMapping createMappingFor(List<string> fromActivityIds, string toActivityId) {
        return new ManyToOneMapping(fromActivityIds, toActivityId);
    }

    public static class OneToOneMapping extends ActivityMigrationMapping implements ActivityMigrationMappingOptions.SingleToActivityOptions<OneToOneMapping> {

        public string fromActivityId;
        public string toActivityId;
        protected string withNewAssignee;
        protected Map<string, Object> withLocalVariables = new LinkedHashMap<>();

        public OneToOneMapping(string fromActivityId, string toActivityId) {
            this.fromActivityId = fromActivityId;
            this.toActivityId = toActivityId;
        }

        @Override
        public List<string> getFromActivityIds() {
            ArrayList<string> list = new ArrayList<>();
            list.add(fromActivityId);
            return list;
        }

        @Override
        public List<string> getToActivityIds() {
            ArrayList<string> list = new ArrayList<>();
            list.add(toActivityId);
            return list;
        }

        public string getFromActivityId() {
            return fromActivityId;
        }

        public string getToActivityId() {
            return toActivityId;
        }

        @Override
        public OneToOneMapping inParentProcessOfCallActivityId(string fromCallActivityId) {
            this.fromCallActivityId = fromCallActivityId;
            this.toCallActivityId = null;
            this.callActivityProcessDefinitionVersion = null;
            return this;
        }

        @Override
        public OneToOneMapping inSubProcessOfCallActivityId(string toCallActivityId) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = null;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public OneToOneMapping inSubProcessOfCallActivityId(string toCallActivityId, int subProcessDefVersion) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = subProcessDefVersion;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public OneToOneMapping withNewAssignee(string newAssigneeId) {
            this.withNewAssignee = newAssigneeId;
            return this;
        }

        @Override
        public string getWithNewAssignee() {
            return withNewAssignee;
        }

        @Override
        public OneToOneMapping withLocalVariable(string variableName, Object variableValue) {
            withLocalVariables.put(variableName, variableValue);
            return this;
        }

        @Override
        public OneToOneMapping withLocalVariables(Map<string, Object> variables) {
            withLocalVariables.putAll(variables);
            return this;
        }

        @Override
        public Map<string, Object> getActivityLocalVariables() {
            return withLocalVariables;
        }

        @Override
        public string toString() {
            return "OneToOneMapping{" + "fromActivityId='" + fromActivityId + '\'' + ", toActivityId='" + toActivityId + '\'' + '}';
        }
    }

    public static class OneToManyMapping extends ActivityMigrationMapping implements ActivityMigrationMappingOptions.MultipleToActivityOptions<OneToManyMapping> {

        public string fromActivityId;
        public List<string> toActivityIds;
        protected Map<string, Map<string, Object>> withLocalVariables = new LinkedHashMap<>();

        public OneToManyMapping(string fromActivityId, List<string> toActivityIds) {
            this.fromActivityId = fromActivityId;
            this.toActivityIds = toActivityIds;
        }

        @Override
        public List<string> getFromActivityIds() {
            ArrayList<string> list = new ArrayList<>();
            list.add(fromActivityId);
            return list;
        }

        @Override
        public List<string> getToActivityIds() {
            return new ArrayList<>(toActivityIds);
        }

        public string getFromActivityId() {
            return fromActivityId;
        }

        @Override
        public OneToManyMapping inParentProcessOfCallActivityId(string fromCallActivityId) {
            this.fromCallActivityId = fromCallActivityId;
            this.toCallActivityId = null;
            this.callActivityProcessDefinitionVersion = null;
            return this;
        }

        @Override
        public OneToManyMapping inSubProcessOfCallActivityId(string toCallActivityId) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = null;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public OneToManyMapping inSubProcessOfCallActivityId(string toCallActivityId, int subProcessDefVersion) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = subProcessDefVersion;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public OneToManyMapping withLocalVariableForActivity(string toActivity, string variableName, Object variableValue) {
            Map<string, Object> activityVariables = withLocalVariables.computeIfAbsent(toActivity, key -> new HashMap<>());
            activityVariables.put(variableName, variableValue);
            return this;
        }

        @Override
        public OneToManyMapping withLocalVariablesForActivity(string toActivity, Map<string, Object> variables) {
            Map<string, Object> activityVariables = withLocalVariables.computeIfAbsent(toActivity, key -> new HashMap<>());
            activityVariables.putAll(variables);
            return this;
        }

        @Override
        public OneToManyMapping withLocalVariableForAllActivities(string variableName, Object variableValue) {
            toActivityIds.forEach(id -> withLocalVariableForActivity(id, variableName, variableValue));
            return this;
        }

        @Override
        public OneToManyMapping withLocalVariablesForAllActivities(Map<string, Object> variables) {
            toActivityIds.forEach(id -> withLocalVariablesForActivity(id, variables));
            return this;
        }

        @Override
        public OneToManyMapping withLocalVariables(Map<string, Map<string, Object>> mappingVariables) {
            withLocalVariables.putAll(mappingVariables);
            return this;
        }

        @Override
        public Map<string, Map<string, Object>> getActivitiesLocalVariables() {
            return withLocalVariables;
        }

        @Override
        public string toString() {
            return "OneToManyMapping{" + "fromActivityId='" + fromActivityId + '\'' + ", toActivityIds=" + toActivityIds + '}';
        }
    }

    public static class ManyToOneMapping extends ActivityMigrationMapping implements ActivityMigrationMappingOptions.SingleToActivityOptions<ManyToOneMapping> {

        public List<string> fromActivityIds;
        public string toActivityId;
        protected string withNewAssignee;
        protected Map<string, Object> withLocalVariables = new LinkedHashMap<>();

        public ManyToOneMapping(List<string> fromActivityIds, string toActivityId) {
            this.fromActivityIds = fromActivityIds;
            this.toActivityId = toActivityId;
        }

        @Override
        public List<string> getFromActivityIds() {
            return new ArrayList<>(fromActivityIds);
        }

        @Override
        public List<string> getToActivityIds() {
            ArrayList<string> list = new ArrayList<>();
            list.add(toActivityId);
            return list;
        }

        public string getToActivityId() {
            return toActivityId;
        }

        @Override
        public ManyToOneMapping inParentProcessOfCallActivityId(string fromCallActivityId) {
            this.fromCallActivityId = fromCallActivityId;
            this.toCallActivityId = null;
            this.callActivityProcessDefinitionVersion = null;
            return this;
        }

        @Override
        public ManyToOneMapping inSubProcessOfCallActivityId(string toCallActivityId) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = null;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public ManyToOneMapping inSubProcessOfCallActivityId(string toCallActivityId, int subProcessDefVersion) {
            this.toCallActivityId = toCallActivityId;
            this.callActivityProcessDefinitionVersion = subProcessDefVersion;
            this.fromCallActivityId = null;
            return this;
        }

        @Override
        public ManyToOneMapping withNewAssignee(string newAssigneeId) {
            this.withNewAssignee = newAssigneeId;
            return this;
        }

        @Override
        public string getWithNewAssignee() {
            return withNewAssignee;
        }

        @Override
        public ManyToOneMapping withLocalVariable(string variableName, Object variableValue) {
            withLocalVariables.put(variableName, variableValue);
            return this;
        }

        @Override
        public ManyToOneMapping withLocalVariables(Map<string, Object> variables) {
            withLocalVariables.putAll(variables);
            return this;
        }

        @Override
        public Map<string, Object> getActivityLocalVariables() {
            return withLocalVariables;
        }

        @Override
        public string toString() {
            return "ManyToOneMapping{" + "fromActivityIds=" + fromActivityIds + ", toActivityId='" + toActivityId + '\'' + '}';
        }
    }

}