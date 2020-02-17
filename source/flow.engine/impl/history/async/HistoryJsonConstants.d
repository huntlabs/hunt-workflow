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
import java.util.List;

interface HistoryJsonConstants {
    
    string JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY = "async-history"; // Backwards compatibility: process engine used this first before the handler was reused
    
    string JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY_ZIPPED = "async-history-zipped"; // Backwards compatibility: process engine used this first before the handler was reused
    
    string TYPE = "type";
    
    List<string> ORDERED_TYPES = Arrays.asList(
            HistoryJsonConstants.TYPE_PROCESS_INSTANCE_START,
            HistoryJsonConstants.TYPE_PROCESS_INSTANCE_PROPERTY_CHANGED,
            HistoryJsonConstants.TYPE_ACTIVITY_START,
            HistoryJsonConstants.TYPE_ACTIVITY_END,
            HistoryJsonConstants.TYPE_ACTIVITY_FULL,
            HistoryJsonConstants.TYPE_TASK_CREATED,
            HistoryJsonConstants.TYPE_TASK_ASSIGNEE_CHANGED,
            HistoryJsonConstants.TYPE_TASK_OWNER_CHANGED,
            HistoryJsonConstants.TYPE_TASK_PROPERTY_CHANGED,
            HistoryJsonConstants.TYPE_TASK_ENDED,
            HistoryJsonConstants.TYPE_VARIABLE_CREATED,
            HistoryJsonConstants.TYPE_VARIABLE_UPDATED,
            HistoryJsonConstants.TYPE_VARIABLE_REMOVED,
            HistoryJsonConstants.TYPE_HISTORIC_DETAIL_VARIABLE_UPDATE,
            HistoryJsonConstants.TYPE_FORM_PROPERTIES_SUBMITTED,
            HistoryJsonConstants.TYPE_SET_PROCESS_DEFINITION,
            HistoryJsonConstants.TYPE_SUBPROCESS_INSTANCE_START,
            HistoryJsonConstants.TYPE_IDENTITY_LINK_CREATED,
            HistoryJsonConstants.TYPE_IDENTITY_LINK_DELETED,
            HistoryJsonConstants.TYPE_PROCESS_INSTANCE_DELETED_BY_PROCDEF_ID,
            HistoryJsonConstants.TYPE_PROCESS_INSTANCE_DELETED,
            HistoryJsonConstants.TYPE_PROCESS_INSTANCE_END
    );
    
    string TYPE_PROCESS_INSTANCE_START = "process-instance-start";
    string TYPE_SUBPROCESS_INSTANCE_START = "subprocess-instance-start";
    string TYPE_PROCESS_INSTANCE_PROPERTY_CHANGED = "process-instance-property-changed";
    string TYPE_SET_PROCESS_DEFINITION = "set-process-definition";
    string TYPE_UPDATE_PROCESS_DEFINITION_CASCADE = "update-process-definition-cascade";
    string TYPE_ACTIVITY_START = "activity-start";
    string TYPE_ACTIVITY_END = "activity-end";
    string TYPE_ACTIVITY_FULL = "activity-full";
    string TYPE_FORM_PROPERTIES_SUBMITTED = "form-properties-submitted";
    string TYPE_HISTORIC_DETAIL_VARIABLE_UPDATE = "historic-detail-variable-update";
    string TYPE_IDENTITY_LINK_CREATED = "identitylink-created";
    string TYPE_IDENTITY_LINK_DELETED = "identitylink-deleted";
    string TYPE_ENTITY_LINK_CREATED = "entitylink-created";
    string TYPE_ENTITY_LINK_DELETED = "entitylink-deleted";
    string TYPE_TASK_CREATED = "task-created";
    string TYPE_TASK_ASSIGNEE_CHANGED = "task-assignee-changed";
    string TYPE_TASK_OWNER_CHANGED = "task-owner-changed";
    string TYPE_TASK_PROPERTY_CHANGED = "task-property-changed";
    string TYPE_TASK_ENDED = "task-ended";
    string TYPE_VARIABLE_CREATED = "variable-created";
    string TYPE_VARIABLE_UPDATED = "variable-updated";
    string TYPE_VARIABLE_REMOVED = "variable-removed";
    string TYPE_PROCESS_INSTANCE_END = "process-instance-end";
    string TYPE_PROCESS_INSTANCE_DELETED = "process-instance-deleted";
    string TYPE_PROCESS_INSTANCE_DELETED_BY_PROCDEF_ID = "process-instance-deleted-by-process-definition-id";
    string TYPE_UPDATE_HISTORIC_ACTIVITY_INSTANCE = "activity-update";
    string TYPE_HISTORIC_TASK_LOG_RECORD = "historic-user-task-log-record";
    string TYPE_HISTORIC_TASK_LOG_DELETE = "historic-user-task-log-delete";


    string DATA = "data";

    string ID = "id";
    
    string NAME = "name";

    string DESCRIPTION = "description";
    
    string REVISION = "revision";

    string CATEGORY = "category";

    string EXECUTION_ID = "executionId";
    
    string SOURCE_EXECUTION_ID = "sourceExecutionId";
    
    string IS_MULTI_INSTANCE_ROOT_EXECUTION = "isMiRootExecution";

    string PROCESS_INSTANCE_ID = "processInstanceId";
    
    string TASK_ID = "taskId";

    string BUSINESS_KEY = "businessKey";

    string PROCESS_DEFINITION_ID = "processDefinitionId";

    string PROCESS_DEFINITION_KEY = "processDefinitionKey";

    string PROCESS_DEFINITION_NAME = "processDefinitionName";

    string PROCESS_DEFINITION_VERSION = "processDefinitionVersion";
    
    string PROCESS_DEFINITION_CATEGORY = "processDefinitionCategory";

    string PROCESS_DEFINITIN_DERIVED_FROM = "processDefinitionDerivedFrom";
    
    string PROCESS_DEFINITIN_DERIVED_FROM_ROOT = "processDefinitionDerivedFromRoot";
    
    string PROCESS_DEFINITIN_DERIVED_VERSION = "processDefinitionDerivedVersion";
    
    string DEPLOYMENT_ID = "deploymentId";

    string START_TIME = "startTime";

    string END_TIME = "endTime";
    
    string CREATE_TIME = "createTime";

    string CLAIM_TIME = "claimTime";
    
    string LAST_UPDATED_TIME = "lastUpdatedTime";

    string START_USER_ID = "startUserId";

    string START_ACTIVITY_ID = "startActivityId";

    string ACTIVITY_ID = "activityId";

    string ACTIVITY_NAME = "activityName";

    string ACTIVITY_TYPE = "activityType";

    string SUPER_PROCESS_INSTANCE_ID = "superProcessInstanceId";

    string DELETE_REASON = "deleteReason";

    string PARENT_TASK_ID = "parentTaskId";

    string ASSIGNEE = "assignee";
    
    string ACTIVITY_ASSIGNEE_HANDLED = "activityAssigneeHandled";

    string OWNER = "owner";
    
    string IDENTITY_LINK_TYPE = "identityLinkType";
    
    string ENTITY_LINK_TYPE = "entityLinkType";

    string TASK_DEFINITION_KEY = "taskDefinitionKey";
    
    string TASK_DEFINITION_ID = "taskDefinitionId";

    string FORM_KEY = "formKey";

    string PRIORITY = "priority";

    string DUE_DATE = "dueDate";

    string PROPERTY = "property";
    
    string VARIABLE_TYPE = "variableType";
    
    string VARIABLE_TEXT_VALUE = "variableTextValue";
    
    string VARIABLE_TEXT_VALUE2 = "variableTextValue2";
    
    string VARIABLE_DOUBLE_VALUE = "variableDoubleValue";
    
    string VARIABLE_LONG_VALUE = "variableLongValue";
    
    string VARIABLE_BYTES_VALUE = "variableBytesValue";
    
    string FORM_PROPERTY_ID = "formPropertyId";
    
    string FORM_PROPERTY_VALUE = "formPropertyValue";
    
    string USER_ID = "userId";
    
    string GROUP_ID = "groupId";

    string TENANT_ID = "tenantId";
    
    string CALLBACK_ID = "callbackId";
    
    string CALLBACK_TYPE = "callbackType";

    string REFERENCE_ID = "referenceId";

    string REFERENCE_TYPE = "referenceType";

    string CALLED_PROCESS_INSTANCE_ID = "calledProcessInstanceId";

    string SCOPE_ID = "scopeId";
    
    string SUB_SCOPE_ID = "subScopeId";
    
    string SCOPE_TYPE = "scopeType";
    
    string SCOPE_DEFINITION_ID = "scopeDefinitionId";
    
    string REF_SCOPE_ID = "referenceScopeId";
    
    string REF_SCOPE_TYPE = "referenceScopeType";
    
    string REF_SCOPE_DEFINITION_ID = "referenceScopeDefinitionId";

    string HIERARCHY_TYPE = "hierarchyType";

    string RUNTIME_ACTIVITY_INSTANCE_ID = "runtimeActivityInstanceId";

    string TIMESTAMP = "__timeStamp"; // Two underscores to avoid clashes with other fields

    string LOG_ENTRY_TYPE = "logEntryType";

    string LOG_ENTRY_DATA = "logEntryData";

    string LOG_ENTRY_LOGNUMBER = "logNumber";
}
