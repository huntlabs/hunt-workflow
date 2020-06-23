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
module flow.engine.impl.event.logger.handler.Fields;

/**
 * @author Joram Barrez
 */
interface Fields {

    static string ACTIVITY_ID = "activityId";
    static string ACTIVITY_NAME = "activityName";
    static string ACTIVITY_TYPE = "activityType";
    static string ASSIGNEE = "assignee";
    static string BEHAVIOR_CLASS = "behaviorClass";
    static string BUSINESS_KEY = "businessKey";
    static string CATEGORY = "category";
    static string CREATE_TIME = "createTime";
    static string DESCRIPTION = "description";
    static string DUE_DATE = "dueDate";
    static string DURATION = "duration";
    static string ERROR_CODE = "errorCode";
    static string END_TIME = "endTime";
    static string EXECUTION_ID = "executionId";
    static string FORM_KEY = "formKey";
    static string ID = "id";
    static string MESSAGE_NAME = "messageName";
    static string MESSAGE_DATA = "messageData";
    static string NAME = "name";
    static string OWNER = "owner";
    static string PRIORITY = "priority";
    static string PROCESS_DEFINITION_ID = "processDefinitionId";
    static string TASK_DEFINITION_KEY = "taskDefinitionKey";
    static string PROCESS_INSTANCE_ID = "processInstanceId";
    static string PROCESS_INSTANCE_NAME = "processInstanceName";
    static string SIGNAL_NAME = "signalName";
    static string SIGNAL_DATA = "signalData";
    static string SOURCE_ACTIVITY_ID = "sourceActivityId";
    static string SOURCE_ACTIVITY_NAME = "sourceActivityName";
    static string SOURCE_ACTIVITY_TYPE = "sourceActivityType";
    static string SOURCE_ACTIVITY_BEHAVIOR_CLASS = "sourceActivityBehaviorClass";
    static string TARGET_ACTIVITY_ID = "targetActivityId";
    static string TARGET_ACTIVITY_NAME = "targetActivityName";
    static string TARGET_ACTIVITY_TYPE = "targetActivityType";
    static string TARGET_ACTIVITY_BEHAVIOR_CLASS = "targetActivityBehaviorClass";
    static string TENANT_ID = "tenantId";
    static string TIMESTAMP = "timeStamp";
    static string USER_ID = "userId";
    static string LOCAL_VARIABLES = "localVariables";
    static string VARIABLES = "variables";
    static string VALUE = "value";
    static string VALUE_BOOLEAN = "booleanValue";
    static string VALUE_DATE = "dateValue";
    static string VALUE_DOUBLE = "doubleValue";
    static string VALUE_INTEGER = "integerValue";
    static string VALUE_JSON = "jsonValue";
    static string VALUE_LONG = "longValue";
    static string VALUE_SHORT = "shortValue";
    static string VALUE_STRING = "stringValue";
    static string VALUE_UUID = "uuidValue";
    static string VARIABLE_TYPE = "variableType";

}
