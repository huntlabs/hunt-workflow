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

  static string BPMN_NODE = "bpmn";
  static string LOCALIZATION_NODE = "localization";

  static string GLOBAL_PROCESS_DEFINITION_PROPERTIES = "_flowableGlobalProcessDefinitionProperties";
  static string ENABLE_SKIP_EXPRESSION = "enableSkipExpression";
  static string TASK_SKIP_EXPRESSION = "taskSkipExpression";

  static string SERVICE_TASK_CLASS_NAME = "serviceTaskClassName";
  static string SERVICE_TASK_EXPRESSION = "serviceTaskExpression";
  static string SERVICE_TASK_DELEGATE_EXPRESSION = "serviceTaskDelegateExpression";

  static string SCRIPT_TASK_SCRIPT = "scriptTaskScript";

  static string USER_TASK_NAME = "userTaskName";
  static string USER_TASK_DESCRIPTION = "userTaskDescription";
  static string USER_TASK_DUEDATE = "userTaskDueDate";
  static string USER_TASK_PRIORITY = "userTaskPriority";
  static string USER_TASK_CATEGORY = "userTaskCategory";
  static string USER_TASK_FORM_KEY = "userTaskFormKey";
  static string USER_TASK_ASSIGNEE = "userTaskAssignee";
  static string USER_TASK_OWNER = "userTaskOwner";
  static string USER_TASK_CANDIDATE_USERS = "userTaskCandidateUsers";
  static string USER_TASK_CANDIDATE_GROUPS = "userTaskCandidateGroups";

  static string MULTI_INSTANCE_COMPLETION_CONDITION = "multiInstanceCompletionCondition";

  static string DMN_TASK_DECISION_TABLE_KEY = "dmnTaskDecisionTableKey";

  static string SEQUENCE_FLOW_CONDITION = "sequenceFlowCondition";

  static string CALL_ACTIVITY_CALLED_ELEMENT =  "callActivityCalledElement";

  static string LOCALIZATION_LANGUAGE = "language";
  static string LOCALIZATION_NAME = "name";
  static string LOCALIZATION_DESCRIPTION = "description";
}
