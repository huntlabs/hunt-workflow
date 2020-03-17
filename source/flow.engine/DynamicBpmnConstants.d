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
module flow.engine.DynamicBpmnConstants;

interface DynamicBpmnConstants {

    string BPMN_NODE = "bpmn";
    string LOCALIZATION_NODE = "localization";

    string GLOBAL_PROCESS_DEFINITION_PROPERTIES = "_flowableGlobalProcessDefinitionProperties";
    string ENABLE_SKIP_EXPRESSION = "enableSkipExpression";
    string TASK_SKIP_EXPRESSION = "taskSkipExpression";

    string SERVICE_TASK_CLASS_NAME = "serviceTaskClassName";
    string SERVICE_TASK_EXPRESSION = "serviceTaskExpression";
    string SERVICE_TASK_DELEGATE_EXPRESSION = "serviceTaskDelegateExpression";

    string SCRIPT_TASK_SCRIPT = "scriptTaskScript";

    string USER_TASK_NAME = "userTaskName";
    string USER_TASK_DESCRIPTION = "userTaskDescription";
    string USER_TASK_DUEDATE = "userTaskDueDate";
    string USER_TASK_PRIORITY = "userTaskPriority";
    string USER_TASK_CATEGORY = "userTaskCategory";
    string USER_TASK_FORM_KEY = "userTaskFormKey";
    string USER_TASK_ASSIGNEE = "userTaskAssignee";
    string USER_TASK_OWNER = "userTaskOwner";
    string USER_TASK_CANDIDATE_USERS = "userTaskCandidateUsers";
    string USER_TASK_CANDIDATE_GROUPS = "userTaskCandidateGroups";

    string MULTI_INSTANCE_COMPLETION_CONDITION = "multiInstanceCompletionCondition";

    string DMN_TASK_DECISION_TABLE_KEY = "dmnTaskDecisionTableKey";

    string SEQUENCE_FLOW_CONDITION = "sequenceFlowCondition";

    string CALL_ACTIVITY_CALLED_ELEMENT =  "callActivityCalledElement";

    string LOCALIZATION_LANGUAGE = "language";
    string LOCALIZATION_NAME = "name";
    string LOCALIZATION_DESCRIPTION = "description";
}
