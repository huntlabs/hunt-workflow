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



import hunt.collection.List;

import flow.bpmn.model.BpmnModel;
import flow.common.api.FlowableException;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.DynamicBpmnConstants;
import flow.engine.DynamicBpmnService;
import flow.engine.dynamic.DynamicProcessDefinitionSummary;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.GetBpmnModelCmd;
import flow.engine.impl.cmd.GetProcessDefinitionInfoCmd;
import flow.engine.impl.cmd.InjectEmbeddedSubProcessInProcessInstanceCmd;
import flow.engine.impl.cmd.InjectParallelEmbeddedSubProcessCmd;
import flow.engine.impl.cmd.InjectParallelUserTaskCmd;
import flow.engine.impl.cmd.InjectUserTaskInProcessInstanceCmd;
import flow.engine.impl.cmd.SaveProcessDefinitionInfoCmd;
import flow.engine.impl.dynamic.DynamicEmbeddedSubProcessBuilder;
import flow.engine.impl.dynamic.DynamicUserTaskBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tijs Rademakers
 */
class DynamicBpmnServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements DynamicBpmnService, DynamicBpmnConstants {

    public DynamicBpmnServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public void injectUserTaskInProcessInstance(string processInstanceId, DynamicUserTaskBuilder dynamicUserTaskBuilder) {
        commandExecutor.execute(new InjectUserTaskInProcessInstanceCmd(processInstanceId, dynamicUserTaskBuilder));
    }

    @Override
    public void injectParallelUserTask(string taskId, DynamicUserTaskBuilder dynamicUserTaskBuilder) {
        commandExecutor.execute(new InjectParallelUserTaskCmd(taskId, dynamicUserTaskBuilder));
    }

    @Override
    public void injectEmbeddedSubProcessInProcessInstance(string processInstanceId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder) {
        commandExecutor.execute(new InjectEmbeddedSubProcessInProcessInstanceCmd(processInstanceId, dynamicEmbeddedSubProcessBuilder));
    }

    @Override
    public void injectParallelEmbeddedSubProcess(string taskId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder) {
        commandExecutor.execute(new InjectParallelEmbeddedSubProcessCmd(taskId, dynamicEmbeddedSubProcessBuilder));
    }

    @Override
    public ObjectNode getProcessDefinitionInfo(string processDefinitionId) {
        return commandExecutor.execute(new GetProcessDefinitionInfoCmd(processDefinitionId));
    }

    @Override
    public void saveProcessDefinitionInfo(string processDefinitionId, ObjectNode infoNode) {
        commandExecutor.execute(new SaveProcessDefinitionInfoCmd(processDefinitionId, infoNode));
    }

    @Override
    public ObjectNode changeServiceTaskClassName(string id, string className) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeServiceTaskClassName(id, className, infoNode);
        return infoNode;
    }

    @Override
    public void changeServiceTaskClassName(string id, string className, ObjectNode infoNode) {
        setElementProperty(id, SERVICE_TASK_CLASS_NAME, className, infoNode);
    }

    @Override
    public ObjectNode changeServiceTaskExpression(string id, string expression) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeServiceTaskExpression(id, expression, infoNode);
        return infoNode;
    }

    @Override
    public void changeServiceTaskExpression(string id, string expression, ObjectNode infoNode) {
        setElementProperty(id, SERVICE_TASK_EXPRESSION, expression, infoNode);
    }

    @Override
    public ObjectNode changeServiceTaskDelegateExpression(string id, string expression) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeServiceTaskDelegateExpression(id, expression, infoNode);
        return infoNode;
    }

    @Override
    public void changeServiceTaskDelegateExpression(string id, string expression, ObjectNode infoNode) {
        setElementProperty(id, SERVICE_TASK_DELEGATE_EXPRESSION, expression, infoNode);
    }

    @Override
    public ObjectNode changeScriptTaskScript(string id, string script) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeScriptTaskScript(id, script, infoNode);
        return infoNode;
    }

    @Override
    public void changeScriptTaskScript(string id, string script, ObjectNode infoNode) {
        setElementProperty(id, SCRIPT_TASK_SCRIPT, script, infoNode);
    }

    @Override
    public ObjectNode changeSkipExpression(string id, string skipExpression) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeSkipExpression(id, skipExpression, infoNode);
        return infoNode;
    }

    @Override
    public void changeSkipExpression(string id, string skipExpression, ObjectNode infoNode) {
        setElementProperty(id, TASK_SKIP_EXPRESSION, skipExpression, infoNode);
    }

    @Override
    public void removeSkipExpression(string id, ObjectNode infoNode) {
        removeElementProperty(id, TASK_SKIP_EXPRESSION, infoNode);
    }

    @Override
    public ObjectNode enableSkipExpression() {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        enableSkipExpression(infoNode);
        return infoNode;
    }

    @Override
    public void enableSkipExpression(ObjectNode infoNode) {
        setElementProperty(GLOBAL_PROCESS_DEFINITION_PROPERTIES, ENABLE_SKIP_EXPRESSION, "true", infoNode);
    }

    @Override
    public void removeEnableSkipExpression(ObjectNode infoNode) {
        removeElementProperty(GLOBAL_PROCESS_DEFINITION_PROPERTIES, ENABLE_SKIP_EXPRESSION, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskName(string id, string name) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskName(id, name, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskName(string id, string name, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_NAME, name, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskDescription(string id, string description) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskDescription(id, description, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskDescription(string id, string description, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_DESCRIPTION, description, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskDueDate(string id, string dueDate) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskDueDate(id, dueDate, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskDueDate(string id, string dueDate, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_DUEDATE, dueDate, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskPriority(string id, string priority) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskPriority(id, priority, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskPriority(string id, string priority, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_PRIORITY, priority, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskCategory(string id, string category) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskCategory(id, category, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskCategory(string id, string category, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_CATEGORY, category, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskFormKey(string id, string formKey) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskFormKey(id, formKey, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskFormKey(string id, string formKey, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_FORM_KEY, formKey, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskAssignee(string id, string assignee) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskAssignee(id, assignee, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskAssignee(string id, string assignee, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_ASSIGNEE, assignee, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskOwner(string id, string owner) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskOwner(id, owner, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskOwner(string id, string owner, ObjectNode infoNode) {
        setElementProperty(id, USER_TASK_OWNER, owner, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskCandidateUser(string id, string candidateUser, bool overwriteOtherChangedEntries) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskCandidateUser(id, candidateUser, overwriteOtherChangedEntries, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskCandidateUser(string id, string candidateUser, bool overwriteOtherChangedEntries, ObjectNode infoNode) {
        ArrayNode valuesNode = null;
        if (overwriteOtherChangedEntries) {
            valuesNode = configuration.getObjectMapper().createArrayNode();
        } else {
            if (doesElementPropertyExist(id, USER_TASK_CANDIDATE_USERS, infoNode)) {
                valuesNode = (ArrayNode) infoNode.get(BPMN_NODE).get(id).get(USER_TASK_CANDIDATE_USERS);
            }

            if (valuesNode is null || valuesNode.isNull()) {
                valuesNode = configuration.getObjectMapper().createArrayNode();
            }
        }

        valuesNode.add(candidateUser);
        setElementProperty(id, USER_TASK_CANDIDATE_USERS, valuesNode, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskCandidateGroup(string id, string candidateGroup, bool overwriteOtherChangedEntries) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskCandidateGroup(id, candidateGroup, overwriteOtherChangedEntries, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskCandidateGroup(string id, string candidateGroup, bool overwriteOtherChangedEntries, ObjectNode infoNode) {
        ArrayNode valuesNode = null;
        if (overwriteOtherChangedEntries) {
            valuesNode = configuration.getObjectMapper().createArrayNode();
        } else {
            if (doesElementPropertyExist(id, USER_TASK_CANDIDATE_GROUPS, infoNode)) {
                valuesNode = (ArrayNode) infoNode.get(BPMN_NODE).get(id).get(USER_TASK_CANDIDATE_GROUPS);
            }

            if (valuesNode is null || valuesNode.isNull()) {
                valuesNode = configuration.getObjectMapper().createArrayNode();
            }
        }

        valuesNode.add(candidateGroup);
        setElementProperty(id, USER_TASK_CANDIDATE_GROUPS, valuesNode, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskCandidateUsers(string id, List!string candidateUsers) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskCandidateUsers(id, candidateUsers, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskCandidateUsers(string id, List!string candidateUsers, ObjectNode infoNode) {
        ArrayNode candidateUsersNode = configuration.getObjectMapper().createArrayNode();
        for (string candidateUser : candidateUsers) {
            candidateUsersNode.add(candidateUser);
        }
        setElementProperty(id, USER_TASK_CANDIDATE_USERS, candidateUsersNode, infoNode);
    }

    @Override
    public ObjectNode changeUserTaskCandidateGroups(string id, List!string candidateGroups) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeUserTaskCandidateGroups(id, candidateGroups, infoNode);
        return infoNode;
    }

    @Override
    public void changeUserTaskCandidateGroups(string id, List!string candidateGroups, ObjectNode infoNode) {
        ArrayNode candidateGroupsNode = configuration.getObjectMapper().createArrayNode();
        for (string candidateGroup : candidateGroups) {
            candidateGroupsNode.add(candidateGroup);
        }
        setElementProperty(id, USER_TASK_CANDIDATE_GROUPS, candidateGroupsNode, infoNode);
    }

    @Override
    public ObjectNode changeMultiInstanceCompletionCondition(string id, string completionCondition) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeMultiInstanceCompletionCondition(id, completionCondition, infoNode);
        return infoNode;
    }

    @Override
    public void changeMultiInstanceCompletionCondition(string id, string completionCondition, ObjectNode infoNode) {
        setElementProperty(id, MULTI_INSTANCE_COMPLETION_CONDITION, completionCondition, infoNode);
    }

    @Override
    public ObjectNode changeDmnTaskDecisionTableKey(string id, string decisionTableKey) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeDmnTaskDecisionTableKey(id, decisionTableKey, infoNode);
        return infoNode;
    }

    @Override
    public void changeDmnTaskDecisionTableKey(string id, string decisionTableKey, ObjectNode infoNode) {
        setElementProperty(id, DMN_TASK_DECISION_TABLE_KEY, decisionTableKey, infoNode);
    }

    @Override
    public ObjectNode changeSequenceFlowCondition(string id, string condition) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeSequenceFlowCondition(id, condition, infoNode);
        return infoNode;
    }

    @Override
    public void changeSequenceFlowCondition(string id, string condition, ObjectNode infoNode) {
        setElementProperty(id, SEQUENCE_FLOW_CONDITION, condition, infoNode);
    }

    @Override
    public ObjectNode changeCallActivityCalledElement(string id, string calledElement){
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeCallActivityCalledElement(id, calledElement, infoNode);
        return infoNode;
    }

    @Override
    public void changeCallActivityCalledElement(string id, string calledElement, ObjectNode infoNode){
        setElementProperty(id, CALL_ACTIVITY_CALLED_ELEMENT, calledElement, infoNode);
    }

    @Override
    public ObjectNode getBpmnElementProperties(string id, ObjectNode infoNode) {
        ObjectNode propertiesNode = null;
        ObjectNode bpmnNode = getBpmnNode(infoNode);
        if (bpmnNode !is null) {
            propertiesNode = (ObjectNode) bpmnNode.get(id);
        }
        return propertiesNode;
    }

    @Override
    public ObjectNode changeLocalizationName(string language, string id, string value) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeLocalizationName(language, id, value, infoNode);
        return infoNode;
    }

    @Override
    public void changeLocalizationName(string language, string id, string value, ObjectNode infoNode) {
        setLocalizationProperty(language, id, LOCALIZATION_NAME, value, infoNode);
    }

    @Override
    public ObjectNode changeLocalizationDescription(string language, string id, string value) {
        ObjectNode infoNode = configuration.getObjectMapper().createObjectNode();
        changeLocalizationDescription(language, id, value, infoNode);
        return infoNode;
    }

    @Override
    public void changeLocalizationDescription(string language, string id, string value, ObjectNode infoNode) {
        setLocalizationProperty(language, id, LOCALIZATION_DESCRIPTION, value, infoNode);
    }

    @Override
    public ObjectNode getLocalizationElementProperties(string language, string id, ObjectNode infoNode) {
        ObjectNode propertiesNode = null;
        ObjectNode localizationNode = getLocalizationNode(infoNode);
        if (localizationNode !is null) {
            JsonNode languageNode = localizationNode.get(language);
            if (languageNode !is null) {
                propertiesNode = (ObjectNode) languageNode.get(id);
            }
        }
        return propertiesNode;
    }

    protected bool doesElementPropertyExist(string id, string propertyName, ObjectNode infoNode) {
        bool exists = false;
        if (infoNode.get(BPMN_NODE) !is null && infoNode.get(BPMN_NODE).get(id) !is null && infoNode.get(BPMN_NODE).get(id).get(propertyName) !is null) {
            JsonNode propNode = infoNode.get(BPMN_NODE).get(id).get(propertyName);
            if (!propNode.isNull()) {
                exists = true;
            }
        }
        return exists;
    }

    @Override
    public void resetProperty(string elementId, string property, ObjectNode infoNode) {
        ObjectNode path = (ObjectNode) infoNode.path(BPMN_NODE).path(elementId);
        if (!path.isMissingNode()) {
            path.remove(property);
        }
    }

    @Override
    public DynamicProcessDefinitionSummary getDynamicProcessDefinitionSummary(string processDefinitionId) {
        ObjectNode infoNode = getProcessDefinitionInfo(processDefinitionId);
        ObjectMapper objectMapper = configuration.getObjectMapper();
        BpmnModel bpmnModel = commandExecutor.execute(new GetBpmnModelCmd(processDefinitionId));

        // aggressive exception. this method should not be called if the process definition does not exists.
        if (bpmnModel is null) {
            throw new FlowableException("ProcessDefinition " + processDefinitionId + " does not exists");
        }

        // to avoid redundant null checks we create an new node
        if (infoNode is null) {
            infoNode = configuration.getObjectMapper().createObjectNode();
            createOrGetBpmnNode(infoNode);
        }

        return new DynamicProcessDefinitionSummary(bpmnModel, infoNode, objectMapper);
    }

    protected void setElementProperty(string id, string propertyName, string propertyValue, ObjectNode infoNode) {
        ObjectNode bpmnNode = createOrGetBpmnNode(infoNode);
        if (!bpmnNode.has(id)) {
            bpmnNode.putObject(id);
        }

        ((ObjectNode) bpmnNode.get(id)).put(propertyName, propertyValue);
    }

    protected void setElementProperty(string id, string propertyName, JsonNode propertyValue, ObjectNode infoNode) {
        ObjectNode bpmnNode = createOrGetBpmnNode(infoNode);
        if (!bpmnNode.has(id)) {
            bpmnNode.putObject(id);
        }

        ((ObjectNode) bpmnNode.get(id)).set(propertyName, propertyValue);
    }

    protected void removeElementProperty(string id, string propertyName, ObjectNode infoNode) {
        ObjectNode bpmnNode = createOrGetBpmnNode(infoNode);
        if (bpmnNode.has(id)) {
            ObjectNode activityNode = (ObjectNode) bpmnNode.get(id);
            if (activityNode.has(propertyName)) {
                activityNode.remove(propertyName);
            }
        }
    }

    protected ObjectNode createOrGetBpmnNode(ObjectNode infoNode) {
        if (!infoNode.has(BPMN_NODE)) {
            infoNode.putObject(BPMN_NODE);
        }
        return (ObjectNode) infoNode.get(BPMN_NODE);
    }

    protected ObjectNode getBpmnNode(ObjectNode infoNode) {
        return (ObjectNode) infoNode.get(BPMN_NODE);
    }

    protected void setLocalizationProperty(string language, string id, string propertyName, string propertyValue, ObjectNode infoNode) {
        ObjectNode localizationNode = createOrGetLocalizationNode(infoNode);
        if (!localizationNode.has(language)) {
            localizationNode.putObject(language);
        }

        ObjectNode languageNode = (ObjectNode) localizationNode.get(language);
        if (!languageNode.has(id)) {
            languageNode.putObject(id);
        }

        ((ObjectNode) languageNode.get(id)).put(propertyName, propertyValue);
    }

    protected ObjectNode createOrGetLocalizationNode(ObjectNode infoNode) {
        if (!infoNode.has(LOCALIZATION_NODE)) {
            infoNode.putObject(LOCALIZATION_NODE);
        }
        return (ObjectNode) infoNode.get(LOCALIZATION_NODE);
    }

    protected ObjectNode getLocalizationNode(ObjectNode infoNode) {
        return (ObjectNode) infoNode.get(LOCALIZATION_NODE);
    }

}
