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

module flow.engine.DynamicBpmnService;

import hunt.collection.List;

import flow.engine.dynamic.DynamicProcessDefinitionSummary;
import flow.engine.impl.dynamic.DynamicEmbeddedSubProcessBuilder;
import flow.engine.impl.dynamic.DynamicUserTaskBuilder;

//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Service providing access to the repository of process definitions and deployments.
 *
 * @author Tijs Rademakers
 */
interface DynamicBpmnService {

    void injectUserTaskInProcessInstance(string processInstanceId, DynamicUserTaskBuilder dynamicUserTaskBuilder);

    void injectParallelUserTask(string taskId, DynamicUserTaskBuilder dynamicUserTaskBuilder);

    void injectEmbeddedSubProcessInProcessInstance(string processInstanceId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder);

    void injectParallelEmbeddedSubProcess(string taskId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder);

    ObjectNode getProcessDefinitionInfo(string processDefinitionId);

    void saveProcessDefinitionInfo(string processDefinitionId, ObjectNode infoNode);

    ObjectNode changeServiceTaskClassName(string id, string className);

    void changeServiceTaskClassName(string id, string className, ObjectNode infoNode);

    ObjectNode changeServiceTaskExpression(string id, string expression);

    void changeServiceTaskExpression(string id, string expression, ObjectNode infoNode);

    ObjectNode changeServiceTaskDelegateExpression(string id, string expression);

    void changeServiceTaskDelegateExpression(string id, string expression, ObjectNode infoNode);

    ObjectNode changeScriptTaskScript(string id, string script);

    void changeScriptTaskScript(string id, string script, ObjectNode infoNode);

    ObjectNode changeSkipExpression(string id, string skipExpression);

    void changeSkipExpression(string id, string skipExpression, ObjectNode infoNode);

    void removeSkipExpression(string id, ObjectNode infoNode);

    ObjectNode enableSkipExpression();

    void enableSkipExpression(ObjectNode infoNode);

    void removeEnableSkipExpression(ObjectNode infoNode);

    ObjectNode changeUserTaskName(string id, string name);

    void changeUserTaskName(string id, string name, ObjectNode infoNode);

    ObjectNode changeUserTaskDescription(string id, string description);

    void changeUserTaskDescription(string id, string description, ObjectNode infoNode);

    ObjectNode changeUserTaskDueDate(string id, string dueDate);

    void changeUserTaskDueDate(string id, string dueDate, ObjectNode infoNode);

    ObjectNode changeUserTaskPriority(string id, string priority);

    void changeUserTaskPriority(string id, string priority, ObjectNode infoNode);

    ObjectNode changeUserTaskCategory(string id, string category);

    void changeUserTaskCategory(string id, string category, ObjectNode infoNode);

    ObjectNode changeUserTaskFormKey(string id, string formKey);

    void changeUserTaskFormKey(string id, string formKey, ObjectNode infoNode);

    ObjectNode changeUserTaskAssignee(string id, string assignee);

    void changeUserTaskAssignee(string id, string assignee, ObjectNode infoNode);

    ObjectNode changeUserTaskOwner(string id, string owner);

    void changeUserTaskOwner(string id, string owner, ObjectNode infoNode);

    ObjectNode changeUserTaskCandidateUser(string id, string candidateUser, bool overwriteOtherChangedEntries);

    void changeUserTaskCandidateUser(string id, string candidateUser, bool overwriteOtherChangedEntries, ObjectNode infoNode);

    ObjectNode changeUserTaskCandidateGroup(string id, string candidateGroup, bool overwriteOtherChangedEntries);

    void changeUserTaskCandidateGroup(string id, string candidateGroup, bool overwriteOtherChangedEntries, ObjectNode infoNode);

    /**
     * Creates a new processDefinitionInfo with {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} for the given BPMN element.
     *
     * <p color="red">
     * Don't forget to call {@link DynamicBpmnService#saveProcessDefinitionInfo(string, ObjectNode)}
     * </p>
     *
     * @param id
     *            the bpmn element id (ex. sid-3392FDEE-DD6F-484E-97FE-55F30BFEA77E)
     * @param candidateUsers
     *            the candidate users.
     * @return a new processDefinitionNode with the candidate users for the given bpmn element.
     */
    ObjectNode changeUserTaskCandidateUsers(string id, List!string candidateUsers);

    /**
     * Updates a processDefinitionInfo's {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} with the new list. Previous values for the BPMN Element with
     * {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} as key are ignored.
     *
     * <p color="red">
     * Don't forget to call {@link DynamicBpmnService#saveProcessDefinitionInfo(string, ObjectNode)}
     * </p>
     *
     * @param id
     *            the bpmn element id (ex. sid-3392FDEE-DD6F-484E-97FE-55F30BFEA77E)
     * @param candidateUsers
     *            the candidate users.
     * @param infoNode
     *            the current processDefinitionInfo. This object will be modified.
     */
    void changeUserTaskCandidateUsers(string id, List!string candidateUsers, ObjectNode infoNode);

    /**
     * Creates a new processDefinitionInfo with {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} for the given BPMN element.
     *
     * <p color="red">
     * Don't forget to call {@link DynamicBpmnService#saveProcessDefinitionInfo(string, ObjectNode)}
     * </p>
     *
     * @param id
     *            the bpmn element id (ex. sid-3392FDEE-DD6F-484E-97FE-55F30BFEA77E)
     * @param candidateGroups
     *            the candidate groups.
     * @return a new processDefinitionNode with the candidate users for the given bpmn element.
     */
    ObjectNode changeUserTaskCandidateGroups(string id, List!string candidateGroups);

    /**
     * Updates a processDefinitionInfo's {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} with the new list. Previous values for the BPMN Element with
     * {@link DynamicBpmnConstants#USER_TASK_CANDIDATE_USERS} as key are ignored.
     *
     * <p color="red">
     * Don't forget to call {@link DynamicBpmnService#saveProcessDefinitionInfo(string, ObjectNode)}
     * </p>
     *
     * @param id
     *            the bpmn element id (ex. sid-3392FDEE-DD6F-484E-97FE-55F30BFEA77E)
     * @param candidateGroups
     *            the candidate groups.
     * @param infoNode
     *            the current processDefinitionInfo. This object will be modified.
     */
    void changeUserTaskCandidateGroups(string id, List!string candidateGroups, ObjectNode infoNode);

    ObjectNode changeMultiInstanceCompletionCondition(string id, string completionCondition);

    void changeMultiInstanceCompletionCondition(string id, string completionCondition, ObjectNode infoNode);

    ObjectNode changeDmnTaskDecisionTableKey(string id, string decisionTableKey);

    void changeDmnTaskDecisionTableKey(string id, string decisionTableKey, ObjectNode infoNode);

    ObjectNode changeSequenceFlowCondition(string id, string condition);

    void changeSequenceFlowCondition(string id, string condition, ObjectNode infoNode);

    ObjectNode changeCallActivityCalledElement(string id, string calledElement);

    void changeCallActivityCalledElement(string id, string calledElement, ObjectNode infoNode);

    ObjectNode getBpmnElementProperties(string id, ObjectNode infoNode);

    ObjectNode changeLocalizationName(string language, string id, string value);

    void changeLocalizationName(string language, string id, string value, ObjectNode infoNode);

    ObjectNode changeLocalizationDescription(string language, string id, string value);

    void changeLocalizationDescription(string language, string id, string value, ObjectNode infoNode);

    ObjectNode getLocalizationElementProperties(string language, string id, ObjectNode infoNode);

    /**
     * <p>
     * Clears the field from the infoNode. So the engine uses the {@link flow.bpmn.model.BpmnModel} value On next instance.
     * </p>
     *
     * <p color="red">
     * Don't forget to save the modified infoNode by calling {@link DynamicBpmnService#saveProcessDefinitionInfo(string, ObjectNode)}
     * </p>
     *
     * @param elementId
     *            the flow elements id.
     * @param property
     *            {@link DynamicBpmnConstants} property
     * @param infoNode
     *            to modify
     */
    void resetProperty(string elementId, string property, ObjectNode infoNode);

    /**
     * Gives a summary between the {@link flow.bpmn.model.BpmnModel} and {@link DynamicBpmnService#getProcessDefinitionInfo(string)}
     *
     * @param processDefinitionId
     *            the process definition id (key:version:sequence)
     * @return DynamicProcessDefinitionSummary if the processdefinition exists
     * @throws IllegalStateException
     *             if there is no processDefinition found for the provided processDefinitionId.
     */
    DynamicProcessDefinitionSummary getDynamicProcessDefinitionSummary(string processDefinitionId);
}
