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
module flow.bpmn.converter.constants.BpmnXMLConstants;

/**
 * @author Tijs Rademakers
 */
interface BpmnXMLConstants {

    public static  string BPMN2_NAMESPACE = "http://www.omg.org/spec/BPMN/20100524/MODEL";
    public static  string XSI_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance";
    public static  string XSI_PREFIX = "xsi";
    public static  string SCHEMA_NAMESPACE = "http://www.w3.org/2001/XMLSchema";
    public static  string XSD_PREFIX = "xsd";
    public static  string TYPE_LANGUAGE_ATTRIBUTE = "typeLanguage";
    public static  string XPATH_NAMESPACE = "http://www.w3.org/1999/XPath";
    public static  string EXPRESSION_LANGUAGE_ATTRIBUTE = "expressionLanguage";
    public static  string PROCESS_NAMESPACE = "http://www.flowable.org/test";
    public static  string TARGET_NAMESPACE_ATTRIBUTE = "targetNamespace";
    public static  string FLOWABLE_EXTENSIONS_NAMESPACE = "http://flowable.org/bpmn";
    public static  string FLOWABLE_EXTENSIONS_PREFIX = "flowable";
    public static  string ACTIVITI_EXTENSIONS_NAMESPACE = "http://activiti.org/bpmn";
    public static  string ACTIVITI_EXTENSIONS_PREFIX = "activiti";
    public static  string BPMNDI_NAMESPACE = "http://www.omg.org/spec/BPMN/20100524/DI";
    public static  string BPMNDI_PREFIX = "bpmndi";
    public static  string OMGDC_NAMESPACE = "http://www.omg.org/spec/DD/20100524/DC";
    public static  string OMGDC_PREFIX = "omgdc";
    public static  string OMGDI_NAMESPACE = "http://www.omg.org/spec/DD/20100524/DI";
    public static  string OMGDI_PREFIX = "omgdi";

    public static  string ATTRIBUTE_ID = "id";
    public static  string ATTRIBUTE_NAME = "name";
    public static  string ATTRIBUTE_TYPE = "type";
    public static  string ATTRIBUTE_DEFAULT = "default";
    public static  string ATTRIBUTE_ITEM_REF = "itemRef";
    public static  string ELEMENT_DEFINITIONS = "definitions";
    public static  string ELEMENT_DOCUMENTATION = "documentation";

    public static  string ELEMENT_SIGNAL = "signal";
    public static  string ELEMENT_MESSAGE = "message";
    public static  string ELEMENT_ERROR = "error";
    public static  string ELEMENT_ESCALATION = "escalation";
    public static  string ELEMENT_COLLABORATION = "collaboration";
    public static  string ELEMENT_PARTICIPANT = "participant";
    public static  string ELEMENT_MESSAGE_FLOW = "messageFlow";
    public static  string ELEMENT_LANESET = "laneSet";
    public static  string ELEMENT_LANE = "lane";
    public static  string ELEMENT_FLOWNODE_REF = "flowNodeRef";
    public static  string ATTRIBUTE_PROCESS_REF = "processRef";
    public static  string ELEMENT_RESOURCE = "resource";

    public static  string ELEMENT_PROCESS = "process";
    public static  string ATTRIBUTE_PROCESS_EXECUTABLE = "isExecutable";
    public static  string ATTRIBUTE_PROCESS_EAGER_EXECUTION_FETCHING = "isEagerExecutionFetching";
    public static  string ELEMENT_POTENTIAL_STARTER = "potentialStarter";
    public static  string ATTRIBUTE_PROCESS_CANDIDATE_USERS = "candidateStarterUsers";
    public static  string ATTRIBUTE_PROCESS_CANDIDATE_GROUPS = "candidateStarterGroups";
    public static  string ELEMENT_SUBPROCESS = "subProcess";
    public static  string ATTRIBUTE_TRIGGERED_BY = "triggeredByEvent";
    public static  string ELEMENT_TRANSACTION = "transaction";
    public static  string ELEMENT_ADHOC_SUBPROCESS = "adHocSubProcess";
    public static  string ATTRIBUTE_ORDERING = "ordering";
    public static  string ATTRIBUTE_CANCEL_REMAINING_INSTANCES = "cancelRemainingInstances";
    public static  string ELEMENT_COMPLETION_CONDITION = "completionCondition";
    public static  string ATTRIBUTE_MESSAGE_EXPRESSION = "messageExpression";
    public static  string ATTRIBUTE_SIGNAL_EXPRESSION = "signalExpression";

    public static  string ELEMENT_DATA_STATE = "dataState";

    public static  string ELEMENT_EXTENSIONS = "extensionElements";

    public static  string ELEMENT_EXECUTION_LISTENER = "executionListener";
    public static  string ELEMENT_EVENT_LISTENER = "eventListener";
    public static  string ELEMENT_TASK_LISTENER = "taskListener";
    public static  string ATTRIBUTE_LISTENER_EVENT = "event";
    public static  string ATTRIBUTE_LISTENER_EVENTS = "events";
    public static  string ATTRIBUTE_LISTENER_ENTITY_TYPE = "entityType";
    public static  string ATTRIBUTE_LISTENER_CLASS = "class";
    public static  string ATTRIBUTE_LISTENER_EXPRESSION = "expression";
    public static  string ATTRIBUTE_LISTENER_DELEGATEEXPRESSION = "delegateExpression";
    public static  string ATTRIBUTE_LISTENER_THROW_EVENT_TYPE = "throwEvent";
    public static  string ATTRIBUTE_LISTENER_THROW_SIGNAL_EVENT_NAME = "signalName";
    public static  string ATTRIBUTE_LISTENER_THROW_MESSAGE_EVENT_NAME = "messageName";
    public static  string ATTRIBUTE_LISTENER_THROW_ERROR_EVENT_CODE = "errorCode";
    public static  string ATTRIBUTE_LISTENER_ON_TRANSACTION = "onTransaction";
    public static  string ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_CLASS = "customPropertiesResolverClass";
    public static  string ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_EXPRESSION = "customPropertiesResolverExpression";
    public static  string ATTRIBUTE_LISTENER_CUSTOM_PROPERTIES_RESOLVER_DELEGATEEXPRESSION = "customPropertiesResolverDelegateExpression";

    public static  string ELEMENT_HTTP_REQUEST_HANDLER = "httpRequestHandler";
    public static  string ELEMENT_HTTP_RESPONSE_HANDLER = "httpResponseHandler";

    public static  string ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_SIGNAL = "signal";
    public static  string ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_GLOBAL_SIGNAL = "globalSignal";
    public static  string ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_MESSAGE = "message";
    public static  string ATTRIBUTE_LISTENER_THROW_EVENT_TYPE_ERROR = "error";

    public static  string ATTRIBUTE_VALUE_TRUE = "true";
    public static  string ATTRIBUTE_VALUE_FALSE = "false";

    public static  string ATTRIBUTE_ACTIVITY_ASYNCHRONOUS = "async";
    public static  string ATTRIBUTE_ACTIVITY_EXCLUSIVE = "exclusive";
    public static  string ATTRIBUTE_ACTIVITY_ISFORCOMPENSATION = "isForCompensation";
    public static  string ATTRIBUTE_ACTIVITY_TRIGGERABLE = "triggerable";

    public static  string ELEMENT_IMPORT = "import";
    public static  string ATTRIBUTE_IMPORT_TYPE = "importType";
    public static  string ATTRIBUTE_LOCATION = "location";
    public static  string ATTRIBUTE_NAMESPACE = "namespace";

    public static  string ELEMENT_INTERFACE = "interface";
    public static  string ELEMENT_OPERATION = "operation";
    public static  string ATTRIBUTE_IMPLEMENTATION_REF = "implementationRef";
    public static  string ELEMENT_IN_MESSAGE = "inMessageRef";
    public static  string ELEMENT_OUT_MESSAGE = "outMessageRef";

    public static  string ELEMENT_ITEM_DEFINITION = "itemDefinition";
    public static  string ATTRIBUTE_STRUCTURE_REF = "structureRef";
    public static  string ATTRIBUTE_ITEM_KIND = "itemKind";

    public static  string ELEMENT_DATA_STORE = "dataStore";
    public static  string ELEMENT_DATA_STORE_REFERENCE = "dataStoreReference";
    public static  string ATTRIBUTE_ITEM_SUBJECT_REF = "itemSubjectRef";
    public static  string ATTRIBUTE_DATA_STORE_REF = "dataStoreRef";

    public static  string ELEMENT_IOSPECIFICATION = "ioSpecification";
    public static  string ELEMENT_DATA_INPUT = "dataInput";
    public static  string ELEMENT_DATA_OUTPUT = "dataOutput";
    public static  string ELEMENT_DATA_INPUT_REFS = "dataInputRefs";
    public static  string ELEMENT_DATA_OUTPUT_REFS = "dataOutputRefs";

    public static  string ELEMENT_INPUT_ASSOCIATION = "dataInputAssociation";
    public static  string ELEMENT_OUTPUT_ASSOCIATION = "dataOutputAssociation";
    public static  string ELEMENT_SOURCE_REF = "sourceRef";
    public static  string ELEMENT_TARGET_REF = "targetRef";
    public static  string ELEMENT_TRANSFORMATION = "transformation";
    public static  string ELEMENT_ASSIGNMENT = "assignment";
    public static  string ELEMENT_FROM = "from";
    public static  string ELEMENT_TO = "to";

    // fake element for mail task
    public static  string ELEMENT_TASK_MAIL = "mailTask";

    public static  string ELEMENT_TASK = "task";
    public static  string ELEMENT_TASK_BUSINESSRULE = "businessRuleTask";
    public static  string ELEMENT_TASK_MANUAL = "manualTask";
    public static  string ELEMENT_TASK_RECEIVE = "receiveTask";
    public static  string ELEMENT_TASK_SCRIPT = "scriptTask";
    public static  string ELEMENT_TASK_SEND = "sendTask";
    public static  string ELEMENT_TASK_SERVICE = "serviceTask";
    public static  string ELEMENT_TASK_USER = "userTask";
    public static  string ELEMENT_CALL_ACTIVITY = "callActivity";

    public static  string ATTRIBUTE_EVENT_START_INITIATOR = "initiator";
    public static  string ATTRIBUTE_EVENT_START_INTERRUPTING = "isInterrupting";
    public static  string ATTRIBUTE_FORM_FORMKEY = "formKey";
    public static  string ATTRIBUTE_FORM_FIELD_VALIDATION = "formFieldValidation";

    public static  string ELEMENT_MULTIINSTANCE = "multiInstanceLoopCharacteristics";
    public static  string ELEMENT_MULTIINSTANCE_CARDINALITY = "loopCardinality";
    public static  string ELEMENT_MULTIINSTANCE_DATAINPUT = "loopDataInputRef";
    public static  string ELEMENT_MULTIINSTANCE_DATAITEM = "inputDataItem";
    public static  string ELEMENT_MULTIINSTANCE_COLLECTION = "collection";
    public static  string ELEMENT_MULTIINSTANCE_COLLECTION_EXPRESSION = "expression";
    public static  string ELEMENT_MULTIINSTANCE_COLLECTION_STRING = "string";
    public static  string ELEMENT_MULTIINSTANCE_CONDITION = "completionCondition";
    public static  string ATTRIBUTE_MULTIINSTANCE_SEQUENTIAL = "isSequential";
    public static  string ATTRIBUTE_MULTIINSTANCE_COLLECTION = "collection";
    public static  string ATTRIBUTE_MULTIINSTANCE_VARIABLE = "elementVariable";
    public static  string ATTRIBUTE_MULTIINSTANCE_INDEX_VARIABLE = "elementIndexVariable";
    public static  string ATTRIBUTE_MULTIINSTANCE_COLLECTION_CLASS = "class";
    public static  string ATTRIBUTE_MULTIINSTANCE_COLLECTION_DELEGATEEXPRESSION = "delegateExpression";

    public static  string ATTRIBUTE_TASK_IMPLEMENTATION = "implementation";
    public static  string ATTRIBUTE_TASK_OPERATION_REF = "operationRef";

    public static  string ATTRIBUTE_TASK_SCRIPT_TEXT = "script";
    public static  string ATTRIBUTE_TASK_SCRIPT_FORMAT = "scriptFormat";
    public static  string ATTRIBUTE_TASK_SCRIPT_RESULTVARIABLE = "resultVariable";
    public static  string ATTRIBUTE_TASK_SCRIPT_AUTO_STORE_VARIABLE = "autoStoreVariables";

    public static  string ATTRIBUTE_TASK_SERVICE_CLASS = "class";
    public static  string ATTRIBUTE_TASK_SERVICE_EXPRESSION = "expression";
    public static  string ATTRIBUTE_TASK_SERVICE_DELEGATEEXPRESSION = "delegateExpression";
    public static  string ATTRIBUTE_TASK_SERVICE_RESULTVARIABLE = "resultVariableName";
    public static  string ATTRIBUTE_TASK_SERVICE_EXTENSIONID = "extensionId";
    public static  string ATTRIBUTE_TASK_SERVICE_SKIP_EXPRESSION = "skipExpression";
    public static  string ATTRIBUTE_TASK_SERVICE_USE_LOCAL_SCOPE_FOR_RESULT_VARIABLE = "useLocalScopeForResultVariable";

    public static  string ATTRIBUTE_TASK_USER_ASSIGNEE = "assignee";
    public static  string ATTRIBUTE_TASK_USER_OWNER = "owner";
    public static  string ATTRIBUTE_TASK_USER_CANDIDATEUSERS = "candidateUsers";
    public static  string ATTRIBUTE_TASK_USER_CANDIDATEGROUPS = "candidateGroups";
    public static  string ATTRIBUTE_TASK_USER_DUEDATE = "dueDate";
    public static  string ATTRIBUTE_TASK_USER_BUSINESS_CALENDAR_NAME = "businessCalendarName";
    public static  string ATTRIBUTE_TASK_USER_CATEGORY = "category";
    public static  string ATTRIBUTE_TASK_USER_PRIORITY = "priority";
    public static  string ATTRIBUTE_TASK_USER_SKIP_EXPRESSION = "skipExpression";

    public static  string ATTRIBUTE_TASK_RULE_VARIABLES_INPUT = "ruleVariablesInput";
    public static  string ATTRIBUTE_TASK_RULE_RESULT_VARIABLE = "resultVariable";
    public static  string ATTRIBUTE_TASK_RULE_RULES = "rules";
    public static  string ATTRIBUTE_TASK_RULE_EXCLUDE = "exclude";
    public static  string ATTRIBUTE_TASK_RULE_CLASS = "class";

    public static  string ATTRIBUTE_BUSINESS_KEY = "businessKey";
    public static  string ATTRIBUTE_INHERIT_BUSINESS_KEY = "inheritBusinessKey";
    public static  string ATTRIBUTE_SAME_DEPLOYMENT = "sameDeployment";
    public static  string ATTRIBUTE_FALLBACK_TO_DEFAULT_TENANT = "fallbackToDefaultTenant";
    public static  string ATTRIBUTE_ID_VARIABLE_NAME = "idVariableName";
    public static  string ELEMENT_IN_PARAMETERS = "in";
    public static  string ELEMENT_OUT_PARAMETERS = "out";

    public static  string ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENT = "calledElement";
    public static  string ATTRIBUTE_CALL_ACTIVITY_CALLEDELEMENTTYPE = "calledElementType";
    public static  string ATTRIBUTE_CALL_ACTIVITY_PROCESS_INSTANCE_NAME = "processInstanceName";
    public static  string ATTRIBUTE_CALL_ACTIVITY_INHERITVARIABLES = "inheritVariables";
    public static  string ATTRIBUTE_CALL_ACTIVITY_USE_LOCALSCOPE_FOR_OUTPARAMETERS = "useLocalScopeForOutParameters";
    public static  string ATTRIBUTE_CALL_ACTIVITY_COMPLETE_ASYNC = "completeAsync";
    public static  string ATTRIBUTE_IOPARAMETER_SOURCE = "source";
    public static  string ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION = "sourceExpression";
    public static  string ATTRIBUTE_IOPARAMETER_TARGET = "target";
    public static  string ATTRIBUTE_IOPARAMETER_TARGET_EXPRESSION = "targetExpression";
    public static  string ATTRIBUTE_IOPARAMETER_TRANSIENT = "transient";

    public static  string ATTRIBUTE_CASE_TASK_CASE_DEFINITION_KEY = "caseDefinitionKey";
    public static  string ATTRIBUTE_CASE_TASK_CASE_INSTANCE_NAME = "caseInstanceName";

    public static  string ELEMENT_EVENT_TYPE = "eventType";
    public static  string ELEMENT_TRIGGER_EVENT_TYPE = "triggerEventType";
    public static  string ELEMENT_SEND_SYNCHRONOUSLY = "sendSynchronously";
    public static  string START_EVENT_CORRELATION_CONFIGURATION = "startEventCorrelationConfiguration";
    public static  string START_EVENT_CORRELATION_STORE_AS_UNIQUE_REFERENCE_ID = "storeAsUniqueReferenceId";

    public static  string ATTRIBUTE_TRIGGERABLE = "triggerable";
    public static  string ELEMENT_TRIGGER_EVENT_CORRELATION_PARAMETER = "triggerEventCorrelationParameter";

    public static  string ELEMENT_SEQUENCE_FLOW = "sequenceFlow";
    public static  string ELEMENT_FLOW_CONDITION = "conditionExpression";
    public static  string ATTRIBUTE_FLOW_SOURCE_REF = "sourceRef";
    public static  string ATTRIBUTE_FLOW_TARGET_REF = "targetRef";
    public static  string ATTRIBUTE_FLOW_SKIP_EXPRESSION = "skipExpression";

    public static  string ELEMENT_TEXT_ANNOTATION = "textAnnotation";
    public static  string ATTRIBUTE_TEXTFORMAT = "textFormat";
    public static  string ELEMENT_TEXT_ANNOTATION_TEXT = "text";

    public static  string ELEMENT_ASSOCIATION = "association";

    public static  string ELEMENT_GATEWAY_EXCLUSIVE = "exclusiveGateway";
    public static  string ELEMENT_GATEWAY_EVENT = "eventBasedGateway";
    public static  string ELEMENT_GATEWAY_INCLUSIVE = "inclusiveGateway";
    public static  string ELEMENT_GATEWAY_PARALLEL = "parallelGateway";
    public static  string ELEMENT_GATEWAY_COMPLEX = "complexGateway";

    public static  string ELEMENT_EVENT_START = "startEvent";
    public static  string ELEMENT_EVENT_END = "endEvent";
    public static  string ELEMENT_EVENT_BOUNDARY = "boundaryEvent";
    public static  string ELEMENT_EVENT_THROW = "intermediateThrowEvent";
    public static  string ELEMENT_EVENT_CATCH = "intermediateCatchEvent";

    public static  string ATTRIBUTE_BOUNDARY_ATTACHEDTOREF = "attachedToRef";
    public static  string ATTRIBUTE_BOUNDARY_CANCELACTIVITY = "cancelActivity";

    public static  string ELEMENT_EVENT_CONDITIONALDEFINITION = "conditionalEventDefinition";
    public static  string ELEMENT_CONDITION = "condition";

    public static  string ELEMENT_EVENT_ERRORDEFINITION = "errorEventDefinition";
    public static  string ATTRIBUTE_ERROR_REF = "errorRef";
    public static  string ATTRIBUTE_ERROR_CODE = "errorCode";

    public static  string ELEMENT_EVENT_MESSAGEDEFINITION = "messageEventDefinition";
    public static  string ATTRIBUTE_MESSAGE_REF = "messageRef";

    public static  string ELEMENT_EVENT_SIGNALDEFINITION = "signalEventDefinition";
    public static  string ATTRIBUTE_SIGNAL_REF = "signalRef";
    public static  string ATTRIBUTE_SCOPE = "scope";

    public static  string ELEMENT_EVENT_TIMERDEFINITION = "timerEventDefinition";
    public static  string ATTRIBUTE_CALENDAR_NAME = "businessCalendarName";
    public static  string ATTRIBUTE_TIMER_DATE = "timeDate";
    public static  string ATTRIBUTE_TIMER_CYCLE = "timeCycle";
    public static  string ATTRIBUTE_END_DATE = "endDate";
    public static  string ATTRIBUTE_TIMER_DURATION = "timeDuration";

    public static  string ELEMENT_EVENT_ESCALATIONDEFINITION = "escalationEventDefinition";
    public static  string ATTRIBUTE_ESCALATION_REF = "escalationRef";
    public static  string ATTRIBUTE_ESCALATION_CODE = "escalationCode";

    public static  string ELEMENT_EVENT_TERMINATEDEFINITION = "terminateEventDefinition";
    public static  string ATTRIBUTE_TERMINATE_ALL = "terminateAll";
    public static  string ATTRIBUTE_TERMINATE_MULTI_INSTANCE = "terminateMultiInstance";

    public static  string ELEMENT_EVENT_CANCELDEFINITION = "cancelEventDefinition";

    public static  string ELEMENT_EVENT_COMPENSATEDEFINITION = "compensateEventDefinition";
    public static  string ATTRIBUTE_COMPENSATE_ACTIVITYREF = "activityRef";
    public static  string ATTRIBUTE_COMPENSATE_WAITFORCOMPLETION = "waitForCompletion";

    public static  string ELEMENT_EVENT_CORRELATION_PARAMETER = "eventCorrelationParameter";
    public static  string ELEMENT_EVENT_IN_PARAMETER = "eventInParameter";
    public static  string ELEMENT_EVENT_OUT_PARAMETER = "eventOutParameter";

    public static  string ELEMENT_FORMPROPERTY = "formProperty";
    public static  string ATTRIBUTE_FORM_ID = "id";
    public static  string ATTRIBUTE_FORM_NAME = "name";
    public static  string ATTRIBUTE_FORM_TYPE = "type";
    public static  string ATTRIBUTE_FORM_EXPRESSION = "expression";
    public static  string ATTRIBUTE_FORM_VARIABLE = "variable";
    public static  string ATTRIBUTE_FORM_READABLE = "readable";
    public static  string ATTRIBUTE_FORM_WRITABLE = "writable";
    public static  string ATTRIBUTE_FORM_REQUIRED = "required";
    public static  string ATTRIBUTE_FORM_DEFAULT = "default";
    public static  string ATTRIBUTE_FORM_DATEPATTERN = "datePattern";
    public static  string ELEMENT_VALUE = "value";

    public static  string ELEMENT_FIELD = "field";
    public static  string ATTRIBUTE_FIELD_NAME = "name";
    public static  string ATTRIBUTE_FIELD_STRING = "stringValue";
    public static  string ATTRIBUTE_FIELD_EXPRESSION = "expression";
    public static  string ELEMENT_FIELD_STRING = "string";

    public static  string ALFRESCO_TYPE = "alfrescoScriptType";

    public static  string ELEMENT_DI_DIAGRAM = "BPMNDiagram";
    public static  string ELEMENT_DI_PLANE = "BPMNPlane";
    public static  string ELEMENT_DI_SHAPE = "BPMNShape";
    public static  string ELEMENT_DI_EDGE = "BPMNEdge";
    public static  string ELEMENT_DI_LABEL = "BPMNLabel";
    public static  string ELEMENT_DI_BOUNDS = "Bounds";
    public static  string ELEMENT_DI_WAYPOINT = "waypoint";
    public static  string ATTRIBUTE_DI_BPMNELEMENT = "bpmnElement";
    public static  string ATTRIBUTE_DI_IS_EXPANDED = "isExpanded";
    public static  string ATTRIBUTE_DI_WIDTH = "width";
    public static  string ATTRIBUTE_DI_HEIGHT = "height";
    public static  string ATTRIBUTE_DI_X = "x";
    public static  string ATTRIBUTE_DI_Y = "y";

    public static  string ELEMENT_DATA_OBJECT = "dataObject";
    public static  string ATTRIBUTE_DATA_ID = "id";
    public static  string ATTRIBUTE_DATA_NAME = "name";
    public static  string ATTRIBUTE_DATA_ITEM_REF = "itemSubjectRef";

    // only used by valued data objects
    public static  string ELEMENT_DATA_VALUE = "value";

    public static  string ELEMENT_CUSTOM_RESOURCE = "customResource";
    public static  string ELEMENT_RESOURCE_ASSIGNMENT = "resourceAssignmentExpression";
    public static  string ELEMENT_FORMAL_EXPRESSION = "formalExpression";
    public static  string ELEMENT_RESOURCE_REF = "resourceRef";
    public static  string ATTRIBUTE_ASSOCIATION_DIRECTION = "associationDirection";

    public static  string FAILED_JOB_RETRY_TIME_CYCLE = "failedJobRetryTimeCycle";
    public static  string MAP_EXCEPTION = "mapException";
    public static  string MAP_EXCEPTION_ERRORCODE = "errorCode";
    public static  string MAP_EXCEPTION_ANDCHILDREN = "includeChildExceptions";
    public static  string MAP_EXCEPTION_ROOTCAUSE = "rootCause";

}
