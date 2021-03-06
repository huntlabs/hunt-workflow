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
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.ACTIVITY_MAPPINGS_JSON_SECTION;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.CALL_ACTIVITY_PROCESS_DEFINITION_VERSION_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.FROM_ACTIVITY_IDS_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.FROM_ACTIVITY_ID_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.IN_PARENT_PROCESS_OF_CALL_ACTIVITY_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.IN_SUB_PROCESS_OF_CALL_ACTIVITY_ID_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.LANGUAGE;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.LOCAL_VARIABLES_JSON_SECTION;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.NEW_ASSIGNEE_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.POST_UPGRADE_JAVA_DELEGATE;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.POST_UPGRADE_JAVA_DELEGATE_EXPRESSION;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.POST_UPGRADE_SCRIPT;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.PRE_UPGRADE_JAVA_DELEGATE_EXPRESSION;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.PRE_UPGRADE_JAVA_DELEGATE;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.PRE_UPGRADE_SCRIPT;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.PROCESS_INSTANCE_VARIABLES_JSON_SECTION;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.SCRIPT;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_ACTIVITY_IDS_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_ACTIVITY_ID_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_PROCESS_DEFINITION_ID_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_PROCESS_DEFINITION_KEY_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_PROCESS_DEFINITION_TENANT_ID_JSON_PROPERTY;
//import static flow.engine.migration.ProcessInstanceMigrationDocumentConstants.TO_PROCESS_DEFINITION_VERSION_JSON_PROPERTY;
//
//import java.io.IOException;
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//import java.util.Optional;
//import java.util.function.Predicate;
//
//import flow.common.api.FlowableException;
//import flow.engine.impl.migration.ProcessInstanceMigrationDocumentBuilderImpl;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.core.type.TypeReference;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.ObjectWriter;
//import com.fasterxml.jackson.databind.node.ArrayNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * @author Dennis
// * @author martin.grofcik
// */
//class ProcessInstanceMigrationDocumentConverter {
//
//    protected static Predicate!JsonNode isNotNullNode = jsonNode -> jsonNode !is null && !jsonNode.isNull();
//    protected static Predicate!JsonNode isSingleTextValue = jsonNode -> isNotNullNode.test(jsonNode) && jsonNode.isTextual();
//    protected static Predicate!JsonNode isMultiValue = jsonNode -> isNotNullNode.test(jsonNode) && jsonNode.isArray();
//
//    protected static ObjectMapper objectMapper = new ObjectMapper();
//
//    protected static Map<Class<? : ActivityMigrationMapping>, BaseActivityMigrationMappingConverter> activityMigrationMappingConverters = new HashMap<>();
//
//    static {
//        activityMigrationMappingConverters.put(ActivityMigrationMapping.OneToOneMapping.class, new OneToOneMappingConverter());
//        activityMigrationMappingConverters.put(ActivityMigrationMapping.OneToManyMapping.class, new OneToManyMappingConverter());
//        activityMigrationMappingConverters.put(ActivityMigrationMapping.ManyToOneMapping.class, new ManyToOneMappingConverter());
//    }
//
//    protected static <T> T convertFromJsonNodeToObject(JsonNode jsonNode, ObjectMapper objectMapper) {
//        return objectMapper.convertValue(jsonNode, new TypeReference!T() {
//
//        });
//    }
//
//    public static JsonNode convertToJson(ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
//
//        ObjectNode documentNode = objectMapper.createObjectNode();
//
//        if (processInstanceMigrationDocument.getMigrateToProcessDefinitionId() !is null) {
//            documentNode.put(TO_PROCESS_DEFINITION_ID_JSON_PROPERTY, processInstanceMigrationDocument.getMigrateToProcessDefinitionId());
//        }
//
//        if (processInstanceMigrationDocument.getMigrateToProcessDefinitionKey() !is null) {
//            documentNode.put(TO_PROCESS_DEFINITION_KEY_JSON_PROPERTY, processInstanceMigrationDocument.getMigrateToProcessDefinitionKey());
//        }
//
//        if (processInstanceMigrationDocument.getMigrateToProcessDefinitionVersion() !is null) {
//            documentNode.put(TO_PROCESS_DEFINITION_VERSION_JSON_PROPERTY, processInstanceMigrationDocument.getMigrateToProcessDefinitionVersion());
//        }
//
//        if (processInstanceMigrationDocument.getMigrateToProcessDefinitionTenantId() !is null) {
//            documentNode.put(TO_PROCESS_DEFINITION_TENANT_ID_JSON_PROPERTY, processInstanceMigrationDocument.getMigrateToProcessDefinitionTenantId());
//        }
//
//        JsonNode preUpgradeScriptNode = convertToJsonUpgradeScript(processInstanceMigrationDocument.getPreUpgradeScript(), objectMapper);
//        if (preUpgradeScriptNode !is null && !preUpgradeScriptNode.isNull()) {
//            documentNode.set(PRE_UPGRADE_SCRIPT, preUpgradeScriptNode);
//        }
//
//        if (processInstanceMigrationDocument.getPreUpgradeJavaDelegate() !is null) {
//            documentNode.put(PRE_UPGRADE_JAVA_DELEGATE, processInstanceMigrationDocument.getPreUpgradeJavaDelegate());
//        }
//
//        if (processInstanceMigrationDocument.getPreUpgradeJavaDelegateExpression() !is null) {
//            documentNode.put(PRE_UPGRADE_JAVA_DELEGATE_EXPRESSION, processInstanceMigrationDocument.getPreUpgradeJavaDelegateExpression());
//        }
//
//        JsonNode postUpgradeScriptNode = convertToJsonUpgradeScript(processInstanceMigrationDocument.getPostUpgradeScript(), objectMapper);
//        if (postUpgradeScriptNode !is null && !postUpgradeScriptNode.isNull()) {
//            documentNode.set(POST_UPGRADE_SCRIPT, postUpgradeScriptNode);
//        }
//
//        if (processInstanceMigrationDocument.getPostUpgradeJavaDelegate() !is null) {
//            documentNode.put(POST_UPGRADE_JAVA_DELEGATE, processInstanceMigrationDocument.getPostUpgradeJavaDelegate());
//        }
//
//        if (processInstanceMigrationDocument.getPostUpgradeJavaDelegateExpression() !is null) {
//            documentNode.put(POST_UPGRADE_JAVA_DELEGATE_EXPRESSION, processInstanceMigrationDocument.getPostUpgradeJavaDelegateExpression());
//        }
//
//        ArrayNode mappingNodes = convertToJsonActivityMigrationMappings(processInstanceMigrationDocument.getActivityMigrationMappings());
//        if (mappingNodes !is null && !mappingNodes.isNull()) {
//            documentNode.set(ACTIVITY_MAPPINGS_JSON_SECTION, mappingNodes);
//        }
//
//        JsonNode processInstanceVariablesNode = convertToJsonProcessInstanceVariables(processInstanceMigrationDocument, objectMapper);
//        if (processInstanceVariablesNode !is null && !processInstanceVariablesNode.isNull()) {
//            documentNode.set(PROCESS_INSTANCE_VARIABLES_JSON_SECTION, processInstanceVariablesNode);
//        }
//
//        return documentNode;
//    }
//
//    public static string convertToJsonString(ProcessInstanceMigrationDocument processInstanceMigrationDocument) {
//        JsonNode jsonNode = convertToJson(processInstanceMigrationDocument);
//        ObjectWriter objectWriter = objectMapper.writerWithDefaultPrettyPrinter();
//        try {
//            return objectWriter.writeValueAsString(jsonNode);
//        } catch (JsonProcessingException e) {
//            return jsonNode.toString();
//        }
//    }
//
//    protected static ArrayNode convertToJsonActivityMigrationMappings(List<? : ActivityMigrationMapping> activityMigrationMappings) {
//        ArrayNode mappingsArray = objectMapper.createArrayNode();
//
//        for (ActivityMigrationMapping mapping : activityMigrationMappings) {
//            BaseActivityMigrationMappingConverter mappingConverter = activityMigrationMappingConverters.get(mapping.getClass());
//            if (mappingConverter is null) {
//                throw new FlowableException("Cannot convert mapping of type '" + mapping.getClass() + "'");
//            }
//            ObjectNode mappingNode = mappingConverter.convertToJson(mapping, objectMapper);
//            mappingsArray.add(mappingNode);
//        }
//
//        return mappingsArray;
//    }
//
//    public static ProcessInstanceMigrationDocument convertFromJson(string jsonProcessInstanceMigrationDocument) {
//
//        try {
//            JsonNode rootNode = objectMapper.readTree(jsonProcessInstanceMigrationDocument);
//            ProcessInstanceMigrationDocumentBuilderImpl documentBuilder = new ProcessInstanceMigrationDocumentBuilderImpl();
//
//            string processDefinitionId = Optional.ofNullable(rootNode.get(TO_PROCESS_DEFINITION_ID_JSON_PROPERTY))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setProcessDefinitionToMigrateTo(processDefinitionId);
//
//            string processDefinitionKey = Optional.ofNullable(rootNode.get(TO_PROCESS_DEFINITION_KEY_JSON_PROPERTY))
//                .map(JsonNode::textValue).orElse(null);
//            Integer processDefinitionVersion = (Integer) Optional.ofNullable(rootNode.get(TO_PROCESS_DEFINITION_VERSION_JSON_PROPERTY))
//                .map(JsonNode::numberValue).orElse(null);
//            documentBuilder.setProcessDefinitionToMigrateTo(processDefinitionKey, processDefinitionVersion);
//
//            string processDefinitionTenantId = Optional.ofNullable(rootNode.get(TO_PROCESS_DEFINITION_TENANT_ID_JSON_PROPERTY))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setTenantId(processDefinitionTenantId);
//
//            JsonNode preUpgradeScriptNode = rootNode.get(PRE_UPGRADE_SCRIPT);
//            if (preUpgradeScriptNode !is null) {
//                string language = Optional.ofNullable(preUpgradeScriptNode.get(LANGUAGE)).map(JsonNode::asText).orElse("javascript");
//                string script = Optional.ofNullable(preUpgradeScriptNode.get(SCRIPT)).map(JsonNode::asText).orElse("javascript");
//                documentBuilder.setPreUpgradeScript(new Script(language, script));
//            }
//
//            string javaDelegateClassName = Optional.ofNullable(rootNode.get(PRE_UPGRADE_JAVA_DELEGATE))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setPreUpgradeJavaDelegate(javaDelegateClassName);
//
//            string expression = Optional.ofNullable(rootNode.get(PRE_UPGRADE_JAVA_DELEGATE_EXPRESSION))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setPreUpgradeJavaDelegateExpression(expression);
//
//            JsonNode postUpgradeScriptNode = rootNode.get(POST_UPGRADE_SCRIPT);
//            if (postUpgradeScriptNode !is null) {
//                string language = Optional.ofNullable(postUpgradeScriptNode.get(LANGUAGE)).map(JsonNode::asText).orElse("javascript");
//                string script = Optional.ofNullable(postUpgradeScriptNode.get(SCRIPT)).map(JsonNode::asText).orElse("javascript");
//                documentBuilder.setPostUpgradeScript(new Script(language, script));
//            }
//
//            string postJavaDelegateClassName = Optional.ofNullable(rootNode.get(POST_UPGRADE_JAVA_DELEGATE))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setPostUpgradeJavaDelegate(postJavaDelegateClassName);
//
//            string postExpression = Optional.ofNullable(rootNode.get(POST_UPGRADE_JAVA_DELEGATE_EXPRESSION))
//                .map(JsonNode::textValue).orElse(null);
//            documentBuilder.setPostUpgradeJavaDelegateExpression(postExpression);
//
//            JsonNode activityMigrationMappings = rootNode.get(ACTIVITY_MAPPINGS_JSON_SECTION);
//            if (activityMigrationMappings !is null) {
//
//                for (JsonNode mappingNode : activityMigrationMappings) {
//                    Class<? : ActivityMigrationMapping> mappingClass = null;
//                    if (isSingleTextValue.test(mappingNode.get(FROM_ACTIVITY_ID_JSON_PROPERTY)) && isSingleTextValue.test(mappingNode.get(TO_ACTIVITY_ID_JSON_PROPERTY))) {
//                        mappingClass = ActivityMigrationMapping.OneToOneMapping.class;
//                    }
//                    if (isSingleTextValue.test(mappingNode.get(FROM_ACTIVITY_ID_JSON_PROPERTY)) && isMultiValue.test(mappingNode.get(TO_ACTIVITY_IDS_JSON_PROPERTY))) {
//                        mappingClass = ActivityMigrationMapping.OneToManyMapping.class;
//                    }
//                    if (isMultiValue.test(mappingNode.get(FROM_ACTIVITY_IDS_JSON_PROPERTY)) && isSingleTextValue.test(mappingNode.get(TO_ACTIVITY_ID_JSON_PROPERTY))) {
//                        mappingClass = ActivityMigrationMapping.ManyToOneMapping.class;
//                    }
//
//                    BaseActivityMigrationMappingConverter mappingConverter = activityMigrationMappingConverters.get(mappingClass);
//                    ActivityMigrationMapping mapping = mappingConverter.convertFromJson(mappingNode, objectMapper);
//                    documentBuilder.addActivityMigrationMapping(mapping);
//                }
//            }
//
//            JsonNode processInstanceVariablesNode = rootNode.get(PROCESS_INSTANCE_VARIABLES_JSON_SECTION);
//            if (processInstanceVariablesNode !is null) {
//                Map!(string, Object) processInstanceVariables = ProcessInstanceMigrationDocumentConverter.convertFromJsonNodeToObject(processInstanceVariablesNode, objectMapper);
//                documentBuilder.addProcessInstanceVariables(processInstanceVariables);
//            }
//            return documentBuilder.build();
//
//        } catch (IOException e) {
//            throw new FlowableException("Error parsing Process Instance Migration Document", e);
//        }
//
//    }
//
//    protected static JsonNode convertToJsonProcessInstanceVariables(ProcessInstanceMigrationDocument processInstanceMigrationDocument, ObjectMapper objectMapper) {
//        Map!(string, Object) processInstanceVariables = processInstanceMigrationDocument.getProcessInstanceVariables();
//        if (processInstanceVariables !is null && !processInstanceVariables.isEmpty()) {
//            return objectMapper.valueToTree(processInstanceVariables);
//        }
//        return null;
//    }
//
//    protected static JsonNode convertToJsonUpgradeScript(Script script, ObjectMapper objectMapper) {
//        if (script !is null) {
//            return objectMapper.valueToTree(script);
//        }
//        return null;
//    }
//
//    abstract static class BaseActivityMigrationMappingConverter<T : ActivityMigrationMapping> {
//
//        public ObjectNode convertToJson(T mapping, ObjectMapper objectMapper) {
//            ObjectNode mappingNode = convertMappingInfoToJson(mapping, objectMapper);
//
//            JsonNode newAssigneeToJsonNode = convertNewAssigneeToJson(mapping, objectMapper);
//            if (newAssigneeToJsonNode !is null && !newAssigneeToJsonNode.isNull()) {
//                mappingNode.set(NEW_ASSIGNEE_JSON_PROPERTY, newAssigneeToJsonNode);
//            }
//
//            JsonNode variablesToJsonNode = convertLocalVariablesToJson(mapping, objectMapper);
//            if (variablesToJsonNode !is null && !variablesToJsonNode.isNull()) {
//                mappingNode.set(LOCAL_VARIABLES_JSON_SECTION, variablesToJsonNode);
//            }
//
//            return mappingNode;
//        }
//
//        protected abstract ObjectNode convertMappingInfoToJson(T mapping, ObjectMapper objectMapper);
//
//        protected ObjectNode convertAdditionalMappingInfoToJson(T mapping, ObjectMapper objectMapper) {
//            ObjectNode mappingNode = objectMapper.createObjectNode();
//            if (mapping.isToParentProcess()) {
//                mappingNode.put(IN_PARENT_PROCESS_OF_CALL_ACTIVITY_JSON_PROPERTY, mapping.getFromCallActivityId());
//            }
//            if (mapping.isToCallActivity()) {
//                mappingNode.put(IN_SUB_PROCESS_OF_CALL_ACTIVITY_ID_JSON_PROPERTY, mapping.getToCallActivityId());
//                mappingNode.put(CALL_ACTIVITY_PROCESS_DEFINITION_VERSION_JSON_PROPERTY, mapping.getCallActivityProcessDefinitionVersion());
//            }
//            return mappingNode;
//        }
//
//        protected abstract JsonNode convertLocalVariablesToJson(T mapping, ObjectMapper objectMapper);
//
//        protected abstract JsonNode convertNewAssigneeToJson(T mapping, ObjectMapper objectMapper);
//
//        abstract T convertFromJson(JsonNode jsonNode, ObjectMapper objectMapper);
//
//        protected <M : ActivityMigrationMappingOptions!T> void convertAdditionalMappingInfoFromJson(M mapping, JsonNode jsonNode) {
//            Optional!JsonNode callActivityOfParentProcess = Optional.ofNullable(jsonNode.get(IN_PARENT_PROCESS_OF_CALL_ACTIVITY_JSON_PROPERTY));
//            if (callActivityOfParentProcess.isPresent()) {
//                callActivityOfParentProcess.map(JsonNode::textValue).ifPresent(mapping::inParentProcessOfCallActivityId);
//                return; //if its a move to parent, it cannot be also a move to subProcess
//            }
//
//            Optional!JsonNode ofCallActivityId = Optional.ofNullable(jsonNode.get(IN_SUB_PROCESS_OF_CALL_ACTIVITY_ID_JSON_PROPERTY));
//            Optional!JsonNode subProcDefVer = Optional.ofNullable(jsonNode.get(CALL_ACTIVITY_PROCESS_DEFINITION_VERSION_JSON_PROPERTY));
//            if (ofCallActivityId.isPresent()) {
//                if (subProcDefVer.isPresent()) {
//                    mapping.inSubProcessOfCallActivityId(ofCallActivityId.get().textValue(), subProcDefVer.get().intValue());
//                } else {
//                    mapping.inSubProcessOfCallActivityId(ofCallActivityId.get().textValue());
//                }
//            }
//
//        }
//
//        protected <V> V getLocalVariablesFromJson(JsonNode jsonNode, ObjectMapper objectMapper) {
//            JsonNode localVariablesNode = jsonNode.get(LOCAL_VARIABLES_JSON_SECTION);
//            if (localVariablesNode !is null) {
//                return ProcessInstanceMigrationDocumentConverter.convertFromJsonNodeToObject(localVariablesNode, objectMapper);
//            }
//            return null;
//        }
//
//        protected string getNewAssigneeFromJson(JsonNode jsonNode) {
//            if (isSingleTextValue.test(jsonNode.get(NEW_ASSIGNEE_JSON_PROPERTY))) {
//                return jsonNode.get(NEW_ASSIGNEE_JSON_PROPERTY).textValue();
//            }
//            return null;
//        }
//
//    }
//
//    public static class OneToOneMappingConverter : BaseActivityMigrationMappingConverter<ActivityMigrationMapping.OneToOneMapping> {
//
//        override
//        protected ObjectNode convertMappingInfoToJson(ActivityMigrationMapping.OneToOneMapping mapping, ObjectMapper objectMapper) {
//            ObjectNode mappingNode = objectMapper.createObjectNode();
//            mappingNode.put(FROM_ACTIVITY_ID_JSON_PROPERTY, mapping.getFromActivityId());
//            mappingNode.put(TO_ACTIVITY_ID_JSON_PROPERTY, mapping.getToActivityId());
//            mappingNode.setAll(convertAdditionalMappingInfoToJson(mapping, objectMapper));
//            return mappingNode;
//        }
//
//        override
//        public JsonNode convertLocalVariablesToJson(ActivityMigrationMapping.OneToOneMapping mapping, ObjectMapper objectMapper) {
//            Map!(string, Object) activityLocalVariables = mapping.getActivityLocalVariables();
//            if (activityLocalVariables !is null && !activityLocalVariables.isEmpty()) {
//                return objectMapper.valueToTree(activityLocalVariables);
//            }
//            return null;
//        }
//
//        override
//        protected JsonNode convertNewAssigneeToJson(ActivityMigrationMapping.OneToOneMapping mapping, ObjectMapper objectMapper) {
//            return objectMapper.valueToTree(mapping.getWithNewAssignee());
//        }
//
//        override
//        public ActivityMigrationMapping.OneToOneMapping convertFromJson(JsonNode jsonNode, ObjectMapper objectMapper) {
//            string fromActivityId = jsonNode.get(FROM_ACTIVITY_ID_JSON_PROPERTY).textValue();
//            string toActivityId = jsonNode.get(TO_ACTIVITY_ID_JSON_PROPERTY).textValue();
//
//            ActivityMigrationMapping.OneToOneMapping oneToOneMapping = ActivityMigrationMapping.createMappingFor(fromActivityId, toActivityId);
//            convertAdditionalMappingInfoFromJson(oneToOneMapping, jsonNode);
//
//            Optional.ofNullable(getNewAssigneeFromJson(jsonNode))
//                .ifPresent(oneToOneMapping::withNewAssignee);
//
//            Map!(string, Object) localVariables = getLocalVariablesFromJson(jsonNode, objectMapper);
//            if (localVariables !is null) {
//                oneToOneMapping.withLocalVariables(localVariables);
//            }
//
//            return oneToOneMapping;
//        }
//
//    }
//
//    public static class ManyToOneMappingConverter : BaseActivityMigrationMappingConverter<ActivityMigrationMapping.ManyToOneMapping> {
//
//        override
//        protected ObjectNode convertMappingInfoToJson(ActivityMigrationMapping.ManyToOneMapping mapping, ObjectMapper objectMapper) {
//            ObjectNode mappingNode = objectMapper.createObjectNode();
//            JsonNode fromActivityIdsNode = objectMapper.valueToTree(mapping.getFromActivityIds());
//            mappingNode.set(FROM_ACTIVITY_IDS_JSON_PROPERTY, fromActivityIdsNode);
//            mappingNode.put(TO_ACTIVITY_ID_JSON_PROPERTY, mapping.getToActivityId());
//            mappingNode.setAll(convertAdditionalMappingInfoToJson(mapping, objectMapper));
//            return mappingNode;
//        }
//
//        override
//        public JsonNode convertLocalVariablesToJson(ActivityMigrationMapping.ManyToOneMapping mapping, ObjectMapper objectMapper) {
//            Map!(string, Object) activityLocalVariables = mapping.getActivityLocalVariables();
//            if (activityLocalVariables !is null && !activityLocalVariables.isEmpty()) {
//                return objectMapper.valueToTree(activityLocalVariables);
//            }
//            return null;
//        }
//
//        override
//        protected JsonNode convertNewAssigneeToJson(ActivityMigrationMapping.ManyToOneMapping mapping, ObjectMapper objectMapper) {
//            return objectMapper.valueToTree(mapping.getWithNewAssignee());
//        }
//
//        override
//        public ActivityMigrationMapping.ManyToOneMapping convertFromJson(JsonNode jsonNode, ObjectMapper objectMapper) {
//            JsonNode fromActivityIdsNode = jsonNode.get(FROM_ACTIVITY_IDS_JSON_PROPERTY);
//            List!string fromActivityIds = objectMapper.convertValue(fromActivityIdsNode, new TypeReference<List!string>() {
//
//            });
//            string toActivityId = jsonNode.get(TO_ACTIVITY_ID_JSON_PROPERTY).textValue();
//
//            ActivityMigrationMapping.ManyToOneMapping manyToOneMapping = ActivityMigrationMapping.createMappingFor(fromActivityIds, toActivityId);
//            convertAdditionalMappingInfoFromJson(manyToOneMapping, jsonNode);
//
//            Optional.ofNullable(getNewAssigneeFromJson(jsonNode))
//                .ifPresent(manyToOneMapping::withNewAssignee);
//
//            Map!(string, Object) localVariables = getLocalVariablesFromJson(jsonNode, objectMapper);
//            if (localVariables !is null) {
//                manyToOneMapping.withLocalVariables(localVariables);
//            }
//
//            return manyToOneMapping;
//        }
//    }
//
//    public static class OneToManyMappingConverter : BaseActivityMigrationMappingConverter<ActivityMigrationMapping.OneToManyMapping> {
//
//        override
//        protected ObjectNode convertMappingInfoToJson(ActivityMigrationMapping.OneToManyMapping mapping, ObjectMapper objectMapper) {
//            ObjectNode mappingNode = objectMapper.createObjectNode();
//            mappingNode.put(FROM_ACTIVITY_ID_JSON_PROPERTY, mapping.getFromActivityId());
//            JsonNode toActivityIdsNode = objectMapper.valueToTree(mapping.getToActivityIds());
//            mappingNode.set(TO_ACTIVITY_IDS_JSON_PROPERTY, toActivityIdsNode);
//            mappingNode.setAll(convertAdditionalMappingInfoToJson(mapping, objectMapper));
//            return mappingNode;
//        }
//
//        override
//        public JsonNode convertLocalVariablesToJson(ActivityMigrationMapping.OneToManyMapping mapping, ObjectMapper objectMapper) {
//            Map<string, Map!(string, Object)> activitiesLocalVariables = mapping.getActivitiesLocalVariables();
//            if (activitiesLocalVariables !is null && !activitiesLocalVariables.isEmpty()) {
//                return objectMapper.valueToTree(activitiesLocalVariables);
//            }
//            return null;
//        }
//
//        override
//        protected JsonNode convertNewAssigneeToJson(ActivityMigrationMapping.OneToManyMapping mapping, ObjectMapper objectMapper) {
//            return null;
//        }
//
//        override
//        public ActivityMigrationMapping.OneToManyMapping convertFromJson(JsonNode jsonNode, ObjectMapper objectMapper) {
//            string fromActivityId = jsonNode.get(FROM_ACTIVITY_ID_JSON_PROPERTY).textValue();
//            JsonNode toActivityIdsNode = jsonNode.get(TO_ACTIVITY_IDS_JSON_PROPERTY);
//            List!string toActivityIds = objectMapper.convertValue(toActivityIdsNode, new TypeReference<List!string>() {
//
//            });
//
//            ActivityMigrationMapping.OneToManyMapping oneToManyMapping = ActivityMigrationMapping.createMappingFor(fromActivityId, toActivityIds);
//            convertAdditionalMappingInfoFromJson(oneToManyMapping, jsonNode);
//
//            Map<string, Map!(string, Object)> localVariables = getLocalVariablesFromJson(jsonNode, objectMapper);
//            if (localVariables !is null) {
//                oneToManyMapping.withLocalVariables(localVariables);
//            }
//
//            return oneToManyMapping;
//        }
//    }
//}
//
