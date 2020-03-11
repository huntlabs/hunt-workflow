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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.impl.cfg.ProcessEngineConfigurationImpl;




import  hunt.util.Common;
import hunt.io.Common;
//import java.net.URL;
import flow.common.EngineConfigurator;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
//import java.util.concurrent.ArrayBlockingQueue;
//import java.util.concurrent.BlockingQueue;
//import java.util.concurrent.ConcurrentHashMap;
//import java.util.concurrent.ConcurrentMap;

//import javax.xml.namespace.QName;

//import org.apache.ibatis.session.Configuration;
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.apache.ibatis.transaction.TransactionFactory;
//import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
//import org.apache.ibatis.transaction.managed.ManagedTransactionFactory;
//import org.apache.ibatis.type.JdbcType;
//import org.flowable.batch.service.BatchServiceConfiguration;
//import org.flowable.batch.service.impl.db.BatchDbSchemaManager;
import flow.engine.ProcessEngineImpl;
import flow.common.api.FlowableException;
import flow.common.api.deleg.FlowableExpressionEnhancer;
import flow.common.api.deleg.FlowableFunctionDelegate;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.api.scop.ScopeTypes;
import flow.common.AbstractEngineConfiguration;
import flow.common.EngineConfigurator;
import flow.common.EngineDeployer;
import flow.common.HasExpressionManagerEngineConfiguration;
import flow.common.HasVariableTypes;
import flow.common.ScriptingEngineAwareEngineConfiguration;
import flow.common.calendar.BusinessCalendarManager;
import flow.common.calendar.CycleBusinessCalendar;
import flow.common.calendar.DueDateBusinessCalendar;
import flow.common.calendar.DurationBusinessCalendar;
import flow.common.calendar.MapBusinessCalendarManager;
import flow.common.callback.RuntimeInstanceStateChangeCallback;
import flow.common.cfg.IdGenerator;
import flow.common.db.AbstractDataManager;
import flow.common.db.SchemaManager;
import flow.common.el.ExpressionManager;
import flow.common.el.function.FlowableShortHandExpressionFunction;
import flow.common.el.function.VariableBase64ExpressionFunction;
import flow.common.el.function.VariableContainsAnyExpressionFunction;
import flow.common.el.function.VariableContainsExpressionFunction;
import flow.common.el.function.VariableEqualsExpressionFunction;
import flow.common.el.function.VariableExistsExpressionFunction;
import flow.common.el.function.VariableGetExpressionFunction;
import flow.common.el.function.VariableGetOrDefaultExpressionFunction;
import flow.common.el.function.VariableGreaterThanExpressionFunction;
import flow.common.el.function.VariableGreaterThanOrEqualsExpressionFunction;
import flow.common.el.function.VariableIsEmptyExpressionFunction;
import flow.common.el.function.VariableIsNotEmptyExpressionFunction;
import flow.common.el.function.VariableLowerThanExpressionFunction;
import flow.common.el.function.VariableLowerThanOrEqualsExpressionFunction;
import flow.common.el.function.VariableNotEqualsExpressionFunction;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandInterceptor;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.common.interceptor.SessionFactory;
import flow.common.logging.LoggingSession;
import flow.common.logging.LoggingSessionFactory;
import flow.common.persistence.GenericManagerFactory;
import flow.common.persistence.cache.EntityCache;
import flow.common.persistence.cache.EntityCacheImpl;
import flow.common.persistence.deploy.DefaultDeploymentCache;
import flow.common.persistence.deploy.DeploymentCache;
import flow.common.persistence.entity.PropertyEntityManager;
import flow.common.persistence.entity.data.PropertyDataManager;
import flow.common.runtime.Clock;
import flow.common.scripting.BeansResolverFactory;
import flow.common.scripting.ResolverFactory;
import flow.common.scripting.ScriptBindingsFactory;
import flow.common.scripting.ScriptingEngines;
import flow.engine.CandidateManager;
import flow.engine.DecisionTableVariableManager;
import flow.engine.DefaultCandidateManager;
import flow.engine.DefaultHistoryCleaningManager;
import flow.engine.DynamicBpmnService;
import flow.engine.FlowableEngineAgenda;
import flow.engine.FlowableEngineAgendaFactory;
import flow.engine.FormService;
import flow.engine.HistoryService;
import flow.engine.IdentityService;
import flow.engine.InternalProcessLocalizationManager;
import flow.engine.ManagementService;
import flow.engine.ProcessEngine;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.ProcessMigrationService;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.TaskService;
import flow.engine.app.AppResourceConverter;
import flow.engine.compatibility.DefaultFlowable5CompatibilityHandlerFactory;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.compatibility.Flowable5CompatibilityHandlerFactory;
import flow.engine.deleg.event.impl.BpmnModelEventDispatchAction;
import flow.engine.dynamic.DynamicStateManager;
import flow.engine.form.AbstractFormType;
import flow.engine.DefaultProcessJobParentStateResolver;
import flow.engine.DefaultProcessLocalizationManager;
import flow.engine.DynamicBpmnServiceImpl;
import flow.engine.FormServiceImpl;
import flow.engine.HistoryServiceImpl;
import flow.engine.IdentityServiceImpl;
import flow.engine.ManagementServiceImpl;
import flow.engine.ProcessEngineImpl;
import flow.engine.ProcessMigrationServiceImpl;
import flow.engine.RepositoryServiceImpl;
import flow.engine.RuntimeServiceImpl;
import flow.engine.SchemaOperationProcessEngineClose;
import flow.engine.SchemaOperationsProcessEngineBuild;
import flow.engine.TaskServiceImpl;
import flow.engine.agenda.AgendaSessionFactory;
import flow.engine.agenda.DefaultFlowableEngineAgendaFactory;
import flow.engine.app.AppDeployer;
import flow.engine.app.AppResourceConverterImpl;
import flow.engine.bpmn.deployer.BpmnDeployer;
import flow.engine.bpmn.deployer.BpmnDeploymentHelper;
import flow.engine.bpmn.deployer.CachingAndArtifactsManager;
import flow.engine.bpmn.deployer.EventSubscriptionManager;
import flow.engine.bpmn.deployer.ParsedDeploymentBuilderFactory;
import flow.engine.bpmn.deployer.ProcessDefinitionDiagramHelper;
import flow.engine.bpmn.deployer.TimerManager;
import flow.engine.bpmn.listener.ListenerNotificationHelper;
import flow.engine.bpmn.parser.BpmnParseHandlers;
import flow.engine.bpmn.parser.BpmnParser;
import flow.engine.bpmn.parser.factory.AbstractBehaviorFactory;
import flow.engine.bpmn.parser.factory.ActivityBehaviorFactory;
import flow.engine.bpmn.parser.factory.DefaultActivityBehaviorFactory;
import flow.engine.bpmn.parser.factory.DefaultListenerFactory;
import flow.engine.bpmn.parser.factory.DefaultXMLImporterFactory;
import flow.engine.bpmn.parser.factory.ListenerFactory;
import flow.engine.bpmn.parser.factory.XMLImporterFactory;
import flow.engine.bpmn.parser.handler.AdhocSubProcessParseHandler;
import flow.engine.bpmn.parser.handler.BoundaryEventParseHandler;
import flow.engine.bpmn.parser.handler.BusinessRuleParseHandler;
import flow.engine.bpmn.parser.handler.CallActivityParseHandler;
import flow.engine.bpmn.parser.handler.CancelEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.CaseServiceTaskParseHandler;
import flow.engine.bpmn.parser.handler.CompensateEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.ConditionalEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.EndEventParseHandler;
import flow.engine.bpmn.parser.handler.ErrorEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.EscalationEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.EventBasedGatewayParseHandler;
import flow.engine.bpmn.parser.handler.EventSubProcessParseHandler;
import flow.engine.bpmn.parser.handler.ExclusiveGatewayParseHandler;
import flow.engine.bpmn.parser.handler.HttpServiceTaskParseHandler;
import flow.engine.bpmn.parser.handler.InclusiveGatewayParseHandler;
import flow.engine.bpmn.parser.handler.IntermediateCatchEventParseHandler;
import flow.engine.bpmn.parser.handler.IntermediateThrowEventParseHandler;
import flow.engine.bpmn.parser.handler.ManualTaskParseHandler;
import flow.engine.bpmn.parser.handler.MessageEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.ParallelGatewayParseHandler;
import flow.engine.bpmn.parser.handler.ProcessParseHandler;
import flow.engine.bpmn.parser.handler.ReceiveTaskParseHandler;
import flow.engine.bpmn.parser.handler.ScriptTaskParseHandler;
import flow.engine.bpmn.parser.handler.SendEventServiceTaskParseHandler;
import flow.engine.bpmn.parser.handler.SendTaskParseHandler;
import flow.engine.bpmn.parser.handler.SequenceFlowParseHandler;
import flow.engine.bpmn.parser.handler.ServiceTaskParseHandler;
import flow.engine.bpmn.parser.handler.SignalEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.StartEventParseHandler;
import flow.engine.bpmn.parser.handler.SubProcessParseHandler;
import flow.engine.bpmn.parser.handler.TaskParseHandler;
import flow.engine.bpmn.parser.handler.TimerEventDefinitionParseHandler;
import flow.engine.bpmn.parser.handler.TransactionParseHandler;
import flow.engine.bpmn.parser.handler.UserTaskParseHandler;
import flow.engine.cmd.RedeployV5ProcessDefinitionsCmd;
import flow.engine.cmd.ValidateExecutionRelatedEntityCountCfgCmd;
import flow.engine.cmd.ValidateTaskRelatedEntityCountCfgCmd;
import flow.engine.cmd.ValidateV5EntitiesCmd;
import flow.engine.cmmn.CaseInstanceService;
import flow.engine.db.DbIdGenerator;
import flow.engine.db.EntityDependencyOrder;
import flow.engine.db.ProcessDbSchemaManager;
import flow.engine.delegate.invocation.DefaultDelegateInterceptor;
import flow.engine.dynamic.DefaultDynamicStateManager;
import flow.engine.el.FlowableDateFunctionDelegate;
import flow.engine.el.ProcessExpressionManager;
import flow.engine.event.CompensationEventHandler;
import flow.engine.event.EventHandler;
import flow.engine.event.MessageEventHandler;
import flow.engine.event.SignalEventHandler;
import flow.engine.event.logger.EventLogger;
import flow.engine.eventregistry.BpmnEventRegistryEventConsumer;
import flow.engine.form.BooleanFormType;
import flow.engine.form.DateFormType;
import flow.engine.form.DoubleFormType;
import flow.engine.form.FormEngine;
import flow.engine.form.FormHandlerHelper;
import flow.engine.form.FormTypes;
import flow.engine.form.JuelFormEngine;
import flow.engine.form.LongFormType;
import flow.engine.form.StringFormType;
import flow.engine.formhandler.DefaultFormFieldHandler;
import flow.engine.history.DefaultHistoryManager;
import flow.engine.history.DefaultHistoryTaskManager;
import flow.engine.history.DefaultHistoryVariableManager;
import flow.engine.history.HistoryManager;
import flow.engine.history.async.AsyncHistoryManager;
import flow.engine.history.async.HistoryJsonConstants;
import flow.engine.history.async.json.transformer.ActivityEndHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ActivityFullHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ActivityStartHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ActivityUpdateHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.EntityLinkCreatedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.EntityLinkDeletedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.FormPropertiesSubmittedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.HistoricDetailVariableUpdateHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.HistoricUserTaskLogDeleteJsonTransformer;
import flow.engine.history.async.json.transformer.HistoricUserTaskLogRecordJsonTransformer;
import flow.engine.history.async.json.transformer.IdentityLinkCreatedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.IdentityLinkDeletedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ProcessInstanceDeleteHistoryByProcessDefinitionIdJsonTransformer;
import flow.engine.history.async.json.transformer.ProcessInstanceDeleteHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ProcessInstanceEndHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ProcessInstancePropertyChangedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.ProcessInstanceStartHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.SetProcessDefinitionHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.SubProcessInstanceStartHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.TaskAssigneeChangedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.TaskCreatedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.TaskEndedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.TaskOwnerChangedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.TaskPropertyChangedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.UpdateProcessDefinitionCascadeHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.VariableCreatedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.VariableRemovedHistoryJsonTransformer;
import flow.engine.history.async.json.transformer.VariableUpdatedHistoryJsonTransformer;
import flow.engine.interceptor.BpmnOverrideContextInterceptor;
import flow.engine.interceptor.CommandInvoker;
import flow.engine.interceptor.DefaultIdentityLinkInterceptor;
import flow.engine.interceptor.DelegateInterceptor;
import flow.engine.interceptor.LoggingExecutionTreeCommandInvoker;
import flow.engine.jobexecutor.AsyncCompleteCallActivityJobHandler;
import flow.engine.jobexecutor.AsyncContinuationJobHandler;
import flow.engine.jobexecutor.AsyncSendEventJobHandler;
import flow.engine.jobexecutor.AsyncTriggerJobHandler;
import flow.engine.jobexecutor.BpmnHistoryCleanupJobHandler;
import flow.engine.jobexecutor.DefaultFailedJobCommandFactory;
import flow.engine.jobexecutor.ProcessEventJobHandler;
import flow.engine.jobexecutor.ProcessInstanceMigrationJobHandler;
import flow.engine.jobexecutor.ProcessInstanceMigrationStatusJobHandler;
import flow.engine.jobexecutor.TimerActivateProcessDefinitionHandler;
import flow.engine.jobexecutor.TimerStartEventJobHandler;
import flow.engine.jobexecutor.TimerSuspendProcessDefinitionHandler;
import flow.engine.jobexecutor.TriggerTimerEventJobHandler;
import flow.engine.migration.ProcessInstanceMigrationManagerImpl;
import flow.engine.persistence.deploy.DeploymentManager;
import flow.engine.persistence.deploy.ProcessDefinitionCacheEntry;
import flow.engine.persistence.deploy.ProcessDefinitionInfoCache;
import flow.engine.persistence.deploy.ProcessDefinitionInfoCacheObject;
import flow.engine.persistence.entity.ActivityInstanceEntityManager;
import flow.engine.persistence.entity.ActivityInstanceEntityManagerImpl;
import flow.engine.persistence.entity.AttachmentEntityManager;
import flow.engine.persistence.entity.AttachmentEntityManagerImpl;
import flow.engine.persistence.entity.ByteArrayEntityManager;
import flow.engine.persistence.entity.ByteArrayEntityManagerImpl;
import flow.engine.persistence.entity.CommentEntityManager;
import flow.engine.persistence.entity.CommentEntityManagerImpl;
import flow.engine.persistence.entity.DeploymentEntityManager;
import flow.engine.persistence.entity.DeploymentEntityManagerImpl;
import flow.engine.persistence.entity.EventLogEntryEntityImpl;
import flow.engine.persistence.entity.EventLogEntryEntityManager;
import flow.engine.persistence.entity.EventLogEntryEntityManagerImpl;
import flow.engine.persistence.entity.ExecutionEntityManager;
import flow.engine.persistence.entity.ExecutionEntityManagerImpl;
import flow.engine.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.persistence.entity.HistoricActivityInstanceEntityManagerImpl;
import flow.engine.persistence.entity.HistoricDetailEntityManager;
import flow.engine.persistence.entity.HistoricDetailEntityManagerImpl;
import flow.engine.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.persistence.entity.HistoricProcessInstanceEntityManagerImpl;
import flow.engine.persistence.entity.ModelEntityManager;
import flow.engine.persistence.entity.ModelEntityManagerImpl;
import flow.engine.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.persistence.entity.ProcessDefinitionEntityManagerImpl;
import flow.engine.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.persistence.entity.ProcessDefinitionInfoEntityManagerImpl;
import flow.engine.persistence.entity.ResourceEntityManager;
import flow.engine.persistence.entity.ResourceEntityManagerImpl;
import flow.engine.persistence.entity.TableDataManager;
import flow.engine.persistence.entity.TableDataManagerImpl;
import flow.engine.persistence.entity.data.ActivityInstanceDataManager;
import flow.engine.persistence.entity.data.AttachmentDataManager;
import flow.engine.persistence.entity.data.ByteArrayDataManager;
import flow.engine.persistence.entity.data.CommentDataManager;
import flow.engine.persistence.entity.data.DeploymentDataManager;
import flow.engine.persistence.entity.data.EventLogEntryDataManager;
import flow.engine.persistence.entity.data.ExecutionDataManager;
import flow.engine.persistence.entity.data.HistoricActivityInstanceDataManager;
import flow.engine.persistence.entity.data.HistoricDetailDataManager;
import flow.engine.persistence.entity.data.HistoricProcessInstanceDataManager;
import flow.engine.persistence.entity.data.ModelDataManager;
import flow.engine.persistence.entity.data.ProcessDefinitionDataManager;
import flow.engine.persistence.entity.data.ProcessDefinitionInfoDataManager;
import flow.engine.persistence.entity.data.ResourceDataManager;
import flow.engine.persistence.entity.data.impl.MybatisActivityInstanceDataManager;
import flow.engine.persistence.entity.data.impl.MybatisAttachmentDataManager;
import flow.engine.persistence.entity.data.impl.MybatisByteArrayDataManager;
import flow.engine.persistence.entity.data.impl.MybatisCommentDataManager;
import flow.engine.persistence.entity.data.impl.MybatisDeploymentDataManager;
import flow.engine.persistence.entity.data.impl.MybatisEventLogEntryDataManager;
import flow.engine.persistence.entity.data.impl.MybatisExecutionDataManager;
import flow.engine.persistence.entity.data.impl.MybatisHistoricActivityInstanceDataManager;
import flow.engine.persistence.entity.data.impl.MybatisHistoricDetailDataManager;
import flow.engine.persistence.entity.data.impl.MybatisHistoricProcessInstanceDataManager;
import flow.engine.persistence.entity.data.impl.MybatisModelDataManager;
import flow.engine.persistence.entity.data.impl.MybatisProcessDefinitionDataManager;
import flow.engine.persistence.entity.data.impl.MybatisProcessDefinitionInfoDataManager;
import flow.engine.persistence.entity.data.impl.MybatisResourceDataManager;
import flow.engine.repository.DefaultProcessDefinitionLocalizationManager;
import flow.engine.scripting.VariableScopeResolverFactory;
import flow.engine.util.ProcessInstanceHelper;
import flow.engine.interceptor.CreateUserTaskInterceptor;
import flow.engine.interceptor.ExecutionQueryInterceptor;
import flow.engine.interceptor.HistoricProcessInstanceQueryInterceptor;
import flow.engine.interceptor.IdentityLinkInterceptor;
import flow.engine.interceptor.ProcessInstanceQueryInterceptor;
import flow.engine.interceptor.StartProcessInstanceInterceptor;
import flow.engine.migration.ProcessInstanceMigrationManager;
import flow.engine.parse.BpmnParseHandler;
import flow.engine.repository.InternalProcessDefinitionLocalizationManager;
import org.flowable.entitylink.service.EntityLinkServiceConfiguration;
import org.flowable.entitylink.service.impl.db.EntityLinkDbSchemaManager;
import flow.event.registry.api.EventRegistryEventConsumer;
import flow.event.registry.configurator.EventRegistryEngineConfigurator;
import org.flowable.eventsubscription.service.EventSubscriptionServiceConfiguration;
import org.flowable.eventsubscription.service.impl.db.EventSubscriptionDbSchemaManager;
import flow.form.api.FormFieldHandler;
import org.flowable.identitylink.service.IdentityLinkEventHandler;
import org.flowable.identitylink.service.IdentityLinkServiceConfiguration;
import org.flowable.identitylink.service.impl.db.IdentityLinkDbSchemaManager;
import flow.idm.api.IdmEngineConfigurationApi;
import org.flowable.idm.engine.configurator.IdmEngineConfigurator;
import org.flowable.image.impl.DefaultProcessDiagramGenerator;
import org.flowable.job.service.HistoryJobHandler;
import org.flowable.job.service.HistoryJobProcessor;
import org.flowable.job.service.InternalJobCompatibilityManager;
import org.flowable.job.service.InternalJobManager;
import org.flowable.job.service.InternalJobParentStateResolver;
import org.flowable.job.service.JobHandler;
import org.flowable.job.service.JobProcessor;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.asyncexecutor.AsyncExecutor;
import org.flowable.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import org.flowable.job.service.impl.asyncexecutor.DefaultAsyncHistoryJobExecutor;
import org.flowable.job.service.impl.asyncexecutor.DefaultAsyncJobExecutor;
import org.flowable.job.service.impl.asyncexecutor.DefaultAsyncRunnableExecutionExceptionHandler;
import org.flowable.job.service.impl.asyncexecutor.ExecuteAsyncRunnableFactory;
import org.flowable.job.service.impl.asyncexecutor.FailedJobCommandFactory;
import org.flowable.job.service.impl.asyncexecutor.JobManager;
import org.flowable.job.service.impl.db.JobDbSchemaManager;
import org.flowable.job.service.impl.history.async.AsyncHistoryJobHandler;
import org.flowable.job.service.impl.history.async.AsyncHistoryJobZippedHandler;
import org.flowable.job.service.impl.history.async.AsyncHistoryListener;
import org.flowable.job.service.impl.history.async.AsyncHistorySession;
import org.flowable.job.service.impl.history.async.AsyncHistorySessionFactory;
import org.flowable.job.service.impl.history.async.DefaultAsyncHistoryJobProducer;
import org.flowable.job.service.impl.history.async.transformer.HistoryJsonTransformer;
import flow.task.api.TaskQueryInterceptor;
import flow.task.api.history.HistoricTaskQueryInterceptor;
import org.flowable.task.service.InternalTaskAssignmentManager;
import org.flowable.task.service.InternalTaskLocalizationManager;
import org.flowable.task.service.InternalTaskVariableScopeResolver;
import org.flowable.task.service.TaskServiceConfiguration;
import org.flowable.task.service.history.InternalHistoryTaskManager;
import org.flowable.task.service.impl.DefaultTaskPostProcessor;
import org.flowable.task.service.impl.db.TaskDbSchemaManager;
import org.flowable.validation.ProcessValidator;
import org.flowable.validation.ProcessValidatorFactory;
import org.flowable.variable.api.types.VariableType;
import org.flowable.variable.api.types.VariableTypes;
import org.flowable.variable.service.VariableServiceConfiguration;
import org.flowable.variable.service.history.InternalHistoryVariableManager;
import org.flowable.variable.service.impl.db.IbatisVariableTypeHandler;
import org.flowable.variable.service.impl.db.VariableDbSchemaManager;
import org.flowable.variable.service.impl.types.BooleanType;
import org.flowable.variable.service.impl.types.ByteArrayType;
import org.flowable.variable.service.impl.types.DateType;
import org.flowable.variable.service.impl.types.DefaultVariableTypes;
import org.flowable.variable.service.impl.types.DoubleType;
import org.flowable.variable.service.impl.types.EntityManagerSession;
import org.flowable.variable.service.impl.types.EntityManagerSessionFactory;
import org.flowable.variable.service.impl.types.InstantType;
import org.flowable.variable.service.impl.types.IntegerType;
import org.flowable.variable.service.impl.types.JPAEntityListVariableType;
import org.flowable.variable.service.impl.types.JPAEntityVariableType;
import org.flowable.variable.service.impl.types.JodaDateTimeType;
import org.flowable.variable.service.impl.types.JodaDateType;
import org.flowable.variable.service.impl.types.JsonType;
import org.flowable.variable.service.impl.types.LocalDateTimeType;
import org.flowable.variable.service.impl.types.LocalDateType;
import org.flowable.variable.service.impl.types.LongJsonType;
import org.flowable.variable.service.impl.types.LongStringType;
import org.flowable.variable.service.impl.types.LongType;
import org.flowable.variable.service.impl.types.NullType;
import org.flowable.variable.service.impl.types.SerializableType;
import org.flowable.variable.service.impl.types.ShortType;
import org.flowable.variable.service.impl.types.StringType;
import org.flowable.variable.service.impl.types.UUIDType;
import flow.engine.RepositoryServiceImpl;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
abstract class ProcessEngineConfigurationImpl : ProcessEngineConfiguration ,
        ScriptingEngineAwareEngineConfiguration, HasExpressionManagerEngineConfiguration, HasVariableTypes {

    public static  string DEFAULT_WS_SYNC_FACTORY = "flow.engine.webservice.CxfWebServiceClientFactory";

    public static  string DEFAULT_WS_IMPORTER = "flow.engine.webservice.CxfWSDLImporter";

    public static  string DEFAULT_MYBATIS_MAPPING_FILE = "org/flowable/db/mapping/mappings.xml";

    // SERVICES /////////////////////////////////////////////////////////////////

    protected RepositoryService repositoryService ;// = new RepositoryServiceImpl();
    protected RuntimeService runtimeService ;// = new RuntimeServiceImpl();
    protected HistoryService historyService ;//= new HistoryServiceImpl(this);
    protected IdentityService identityService;// = new IdentityServiceImpl(this);
    protected TaskService taskService ;//= new TaskServiceImpl(this);
    protected FormService formService ;//= new FormServiceImpl();
    protected ManagementService managementService ;//= new ManagementServiceImpl(this);
    protected DynamicBpmnService dynamicBpmnService;// = new DynamicBpmnServiceImpl(this);
    protected ProcessMigrationService processInstanceMigrationService ;//= new ProcessMigrationServiceImpl(this);

    // IDM ENGINE /////////////////////////////////////////////////////
    protected bool disableIdmEngine;

    // EVENT REGISTRY /////////////////////////////////////////////////////
    protected bool disableEventRegistry;

    // DATA MANAGERS /////////////////////////////////////////////////////////////

    protected AttachmentDataManager attachmentDataManager;
    protected ByteArrayDataManager byteArrayDataManager;
    protected CommentDataManager commentDataManager;
    protected DeploymentDataManager deploymentDataManager;
    protected EventLogEntryDataManager eventLogEntryDataManager;
    protected ExecutionDataManager executionDataManager;
    protected ActivityInstanceDataManager activityInstanceDataManager;
    protected HistoricActivityInstanceDataManager historicActivityInstanceDataManager;
    protected HistoricDetailDataManager historicDetailDataManager;
    protected HistoricProcessInstanceDataManager historicProcessInstanceDataManager;
    protected ModelDataManager modelDataManager;
    protected ProcessDefinitionDataManager processDefinitionDataManager;
    protected ProcessDefinitionInfoDataManager processDefinitionInfoDataManager;
    protected ResourceDataManager resourceDataManager;

    // ENTITY MANAGERS ///////////////////////////////////////////////////////////

    protected AttachmentEntityManager attachmentEntityManager;
    protected ByteArrayEntityManager byteArrayEntityManager;
    protected CommentEntityManager commentEntityManager;
    protected DeploymentEntityManager deploymentEntityManager;
    protected EventLogEntryEntityManager eventLogEntryEntityManager;
    protected ExecutionEntityManager executionEntityManager;
    protected ActivityInstanceEntityManager activityInstanceEntityManager;
    protected HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager;
    protected HistoricDetailEntityManager historicDetailEntityManager;
    protected HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager;
    protected ModelEntityManager modelEntityManager;
    protected ProcessDefinitionEntityManager processDefinitionEntityManager;
    protected ProcessDefinitionInfoEntityManager processDefinitionInfoEntityManager;
    protected ResourceEntityManager resourceEntityManager;
    protected TableDataManager tableDataManager;

    // Candidate Manager

    protected CandidateManager candidateManager;

    // History Manager

    protected HistoryManager historyManager;

    protected bool isAsyncHistoryEnabled;
    protected bool isAsyncHistoryJsonGzipCompressionEnabled;
    protected bool isAsyncHistoryJsonGroupingEnabled;
    protected int asyncHistoryJsonGroupingThreshold = 10;
    protected AsyncHistoryListener asyncHistoryListener;

    // Job Manager

    protected JobManager jobManager;

    // Dynamic state manager

    protected DynamicStateManager dynamicStateManager;

    protected ProcessInstanceMigrationManager processInstanceMigrationManager;

    // Decision table variable manager

    protected DecisionTableVariableManager decisionTableVariableManager;

    protected VariableServiceConfiguration variableServiceConfiguration;
    protected IdentityLinkServiceConfiguration identityLinkServiceConfiguration;
    protected EntityLinkServiceConfiguration entityLinkServiceConfiguration;
    protected EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration;
    protected TaskServiceConfiguration taskServiceConfiguration;
    protected JobServiceConfiguration jobServiceConfiguration;
    protected BatchServiceConfiguration batchServiceConfiguration;

    protected bool enableEntityLinks;

    // DEPLOYERS //////////////////////////////////////////////////////////////////

    protected BpmnDeployer bpmnDeployer;
    protected AppDeployer appDeployer;
    protected BpmnParser bpmnParser;
    protected ParsedDeploymentBuilderFactory parsedDeploymentBuilderFactory;
    protected TimerManager timerManager;
    protected EventSubscriptionManager eventSubscriptionManager;
    protected BpmnDeploymentHelper bpmnDeploymentHelper;
    protected CachingAndArtifactsManager cachingAndArtifactsManager;
    protected ProcessDefinitionDiagramHelper processDefinitionDiagramHelper;
    protected DeploymentManager deploymentManager;

    protected int processDefinitionCacheLimit = -1; // By default, no limit
    protected DeploymentCache!ProcessDefinitionCacheEntry processDefinitionCache;

    protected int processDefinitionInfoCacheLimit = -1; // By default, no limit
    protected DeploymentCache!ProcessDefinitionInfoCacheObject processDefinitionInfoCache;

    protected int knowledgeBaseCacheLimit = -1;
    protected DeploymentCache!Object knowledgeBaseCache;

    protected int appResourceCacheLimit = -1;
    protected DeploymentCache!Object appResourceCache;

    protected AppResourceConverter appResourceConverter;

    // JOB EXECUTOR /////////////////////////////////////////////////////////////

    protected List!JobHandler customJobHandlers;
    protected Map!(string, JobHandler) jobHandlers;
    protected List!AsyncRunnableExecutionExceptionHandler customAsyncRunnableExecutionExceptionHandlers;
    protected bool addDefaultExceptionHandler = true;

    protected Map!(string, HistoryJobHandler) historyJobHandlers;
    protected List!HistoryJobHandler customHistoryJobHandlers;
    protected List!HistoryJsonTransformer customHistoryJsonTransformers;

    // HELPERS //////////////////////////////////////////////////////////////////
    protected ProcessInstanceHelper processInstanceHelper;
    protected ListenerNotificationHelper listenerNotificationHelper;
    protected FormHandlerHelper formHandlerHelper;

    protected CaseInstanceService caseInstanceService;

    // ASYNC EXECUTOR ///////////////////////////////////////////////////////////

    /**
     * The number of retries for a job.
     */
    protected int asyncExecutorNumberOfRetries = 3;

    /**
     * The minimal number of threads that are kept alive in the threadpool for job execution. Default value = 2. (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorCorePoolSize = 8;

    /**
     * The maximum number of threads that are created in the threadpool for job execution. Default value = 10. (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorMaxPoolSize = 8;

    /**
     * The time (in milliseconds) a thread used for job execution must be kept alive before it is destroyed. Default setting is 5 seconds. Having a setting > 0 takes resources, but in the case of many
     * job executions it avoids creating new threads all the time. If 0, threads will be destroyed after they've been used for job execution.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected long asyncExecutorThreadKeepAliveTime = 5000L;

    /**
     * The size of the queue on which jobs to be executed are placed, before they are actually executed. Default value = 100. (This property is only applicable when using the
     * {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorThreadPoolQueueSize = 100;

    /**
     * The queue onto which jobs will be placed before they are actually executed. Threads form the async executor threadpool will take work from this queue.
     * <p>
     * By default null. If null, an {@link ArrayBlockingQueue} will be created of size {@link #asyncExecutorThreadPoolQueueSize}.
     * <p>
     * When the queue is full, the job will be executed by the calling thread (ThreadPoolExecutor.CallerRunsPolicy())
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected BlockingQueue<Runnable> asyncExecutorThreadPoolQueue;

    /**
     * The time (in seconds) that is waited to gracefully shut down the threadpool used for job execution when the a shutdown on the executor (or process engine) is requested. Default value = 60.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected long asyncExecutorSecondsToWaitOnShutdown = 60L;

    /**
     * Whether or not core threads can time out (which is needed to scale down the threads). Default true.
     *
     * This property is only applicable when using the threadpool-based async executor.
     */
    protected bool asyncExecutorAllowCoreThreadTimeout = true;

    /**
     * The number of timer jobs that are acquired during one query (before a job is executed, an acquirement thread fetches jobs from the database and puts them on the queue).
     * <p>
     * Default value = 1, as this lowers the potential on optimistic locking exceptions. Change this value if you know what you are doing.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorMaxTimerJobsPerAcquisition = 1;

    /**
     * The number of async jobs that are acquired during one query (before a job is executed, an acquirement thread fetches jobs from the database and puts them on the queue).
     * <p>
     * Default value = 1, as this lowers the potential on optimistic locking exceptions. Change this value if you know what you are doing.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorMaxAsyncJobsDuePerAcquisition = 1;

    /**
     * The time (in milliseconds) the timer acquisition thread will wait to execute the next acquirement query. This happens when no new timer jobs were found or when less timer jobs have been fetched
     * than set in {@link #asyncExecutorMaxTimerJobsPerAcquisition}. Default value = 10 seconds.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorDefaultTimerJobAcquireWaitTime = 10 * 1000;

    /**
     * The time (in milliseconds) the async job acquisition thread will wait to execute the next acquirement query. This happens when no new async jobs were found or when less async jobs have been
     * fetched than set in {@link #asyncExecutorMaxAsyncJobsDuePerAcquisition}. Default value = 10 seconds.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorDefaultAsyncJobAcquireWaitTime = 10 * 1000;

    /**
     * The time (in milliseconds) the async job (both timer and async continuations) acquisition thread will wait when the queue is full to execute the next query. By default set to 0 (for backwards
     * compatibility)
     */
    protected int asyncExecutorDefaultQueueSizeFullWaitTime;

    /**
     * When a job is acquired, it is locked so other async executors can't lock and execute it. While doing this, the 'name' of the lock owner is written into a column of the job.
     * <p>
     * By default, a random UUID will be generated when the executor is created.
     * <p>
     * It is important that each async executor instance in a cluster of Flowable engines has a different name!
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected string asyncExecutorLockOwner;

    /**
     * The amount of time (in milliseconds) a timer job is locked when acquired by the async executor. During this period of time, no other async executor will try to acquire and lock this job.
     * <p>
     * Default value = 5 minutes;
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorTimerLockTimeInMillis = 5 * 60 * 1000;

    /**
     * The amount of time (in milliseconds) an async job is locked when acquired by the async executor. During this period of time, no other async executor will try to acquire and lock this job.
     * <p>
     * Default value = 5 minutes;
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected int asyncExecutorAsyncJobLockTimeInMillis = 5 * 60 * 1000;

    /**
     * The amount of time (in milliseconds) that is between two consecutive checks of 'expired jobs'. Expired jobs are jobs that were locked (a lock owner + time was written by some executor, but the
     * job was never completed).
     * <p>
     * During such a check, jobs that are expired are again made available, meaning the lock owner and lock time will be removed. Other executors will now be able to pick it up.
     * <p>
     * A job is deemed expired if the current time has passed the lock time.
     * <p>
     * By default one minute.
     */
    protected int asyncExecutorResetExpiredJobsInterval = 60 * 1000;

    /**
     * The amount of time (in milliseconds) a job can maximum be in the 'executable' state before being deemed expired.
     * Note that this won't happen when using the threadpool based executor, as the acquire thread will fetch these kind of jobs earlier.
     * However, in the message queue based execution, it could be some job is posted to a queue but then never is locked nor executed.
     * <p>
     * By default 24 hours, as this should be a very exceptional case.
     */
    protected int asyncExecutorResetExpiredJobsMaxTimeout = 24 * 60 * 60 * 1000;

    /**
     * The {@link AsyncExecutor} has a 'cleanup' thread that resets expired jobs so they can be re-acquired by other executors. This setting defines the size of the page being used when fetching these
     * expired jobs.
     */
    protected int asyncExecutorResetExpiredJobsPageSize = 3;

    /**
     * Flags to control which threads (when using the default threadpool-based async executor) are started.
     * This can be used to boot up engine instances that still execute jobs originating from this instance itself,
     * but don't fetch new jobs themselves.
     */
    protected bool isAsyncExecutorAsyncJobAcquisitionEnabled = true;
    protected bool isAsyncExecutorTimerJobAcquisitionEnabled = true;
    protected bool isAsyncExecutorResetExpiredJobsEnabled = true;

    /**
     * Experimental!
     * <p>
     * Set this to true when using the message queue based job executor.
     */
    protected bool asyncExecutorMessageQueueMode;

    // More info: see similar async executor properties.
    protected bool asyncHistoryExecutorMessageQueueMode;
    protected int asyncHistoryExecutorNumberOfRetries = 10;
    protected int asyncHistoryExecutorCorePoolSize = 8;
    protected int asyncHistoryExecutorMaxPoolSize = 8;
    protected long asyncHistoryExecutorThreadKeepAliveTime = 5000L;
    protected int asyncHistoryExecutorThreadPoolQueueSize = 100;
    protected BlockingQueue!Runnable asyncHistoryExecutorThreadPoolQueue;
    protected long asyncHistoryExecutorSecondsToWaitOnShutdown = 60L;
    protected int asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime = 10 * 1000;
    protected int asyncHistoryExecutorDefaultQueueSizeFullWaitTime;
    protected string asyncHistoryExecutorLockOwner;
    protected int asyncHistoryExecutorAsyncJobLockTimeInMillis = 5 * 60 * 1000;
    protected int asyncHistoryExecutorResetExpiredJobsInterval = 60 * 1000;
    protected int asyncHistoryExecutorResetExpiredJobsPageSize = 3;
    protected bool isAsyncHistoryExecutorAsyncJobAcquisitionEnabled = true;
    protected bool isAsyncHistoryExecutorTimerJobAcquisitionEnabled = true;
    protected bool isAsyncHistoryExecutorResetExpiredJobsEnabled = true;

    protected string jobExecutionScope;
    protected string historyJobExecutionScope;

    protected string asyncExecutorTenantId = AbstractEngineConfiguration.NO_TENANT_ID;

    protected string batchStatusTimeCycleConfig = "30 * * * * ?";

    /**
     * Allows to define a custom factory for creating the {@link Runnable} that is executed by the async executor.
     * <p>
     * (This property is only applicable when using the {@link DefaultAsyncJobExecutor}).
     */
    protected ExecuteAsyncRunnableFactory asyncExecutorExecuteAsyncRunnableFactory;
    protected InternalJobParentStateResolver internalJobParentStateResolver;

    // JUEL functions ///////////////////////////////////////////////////////////
    protected List!FlowableFunctionDelegate flowableFunctionDelegates;
    protected List!FlowableFunctionDelegate customFlowableFunctionDelegates;
    protected List!FlowableExpressionEnhancer expressionEnhancers;
    protected List!FlowableExpressionEnhancer customExpressionEnhancers;
    protected List!FlowableShortHandExpressionFunction shortHandExpressionFunctions;

    // BPMN PARSER //////////////////////////////////////////////////////////////

    protected List!BpmnParseHandler preBpmnParseHandlers;
    protected List!BpmnParseHandler postBpmnParseHandlers;
    protected List!BpmnParseHandler customDefaultBpmnParseHandlers;
    protected ActivityBehaviorFactory activityBehaviorFactory;
    protected ListenerFactory listenerFactory;
    protected BpmnParseFactory bpmnParseFactory;

    // PROCESS VALIDATION ///////////////////////////////////////////////////////

    protected ProcessValidator processValidator;

    // OTHER ////////////////////////////////////////////////////////////////////

    protected List!FormEngine customFormEngines;
    protected Map!(string, FormEngine) formEngines;

    protected List!AbstractFormType customFormTypes;
    protected FormTypes formTypes;

    protected List!VariableType customPreVariableTypes;
    protected List!VariableType customPostVariableTypes;
    protected VariableTypes variableTypes;

    protected InternalHistoryVariableManager internalHistoryVariableManager;
    protected InternalTaskVariableScopeResolver internalTaskVariableScopeResolver;
    protected InternalHistoryTaskManager internalHistoryTaskManager;
    protected InternalTaskAssignmentManager internalTaskAssignmentManager;
    protected IdentityLinkEventHandler identityLinkEventHandler;
    protected InternalTaskLocalizationManager internalTaskLocalizationManager;
    protected InternalProcessLocalizationManager internalProcessLocalizationManager;
    protected InternalProcessDefinitionLocalizationManager internalProcessDefinitionLocalizationManager;
    protected InternalJobManager internalJobManager;
    protected InternalJobCompatibilityManager internalJobCompatibilityManager;

    protected Map!(string, List!RuntimeInstanceStateChangeCallback) processInstanceStateChangedCallbacks;

    /**
     * This flag determines whether variables of the type 'serializable' will be tracked. This means that, when true, in a JavaDelegate you can write
     * <p>
     * MySerializableVariable myVariable = (MySerializableVariable) execution.getVariable("myVariable"); myVariable.setNumber(123);
     * <p>
     * And the changes to the java object will be reflected in the database. Otherwise, a manual call to setVariable will be needed.
     * <p>
     * By default true for backwards compatibility.
     */
    protected bool serializableVariableTypeTrackDeserializedObjects = true;

    protected ExpressionManager expressionManager;
    protected List!string customScriptingEngineClasses;
    protected ScriptingEngines scriptingEngines;
    protected List!ResolverFactory resolverFactories;

    protected bool isExpressionCacheEnabled = true;
    protected int expressionCacheSize = 4096;
    protected int expressionTextLengthCacheLimit = -1; // negative value to have no max length

    protected BusinessCalendarManager businessCalendarManager;

    protected StartProcessInstanceInterceptor startProcessInstanceInterceptor;
    protected CreateUserTaskInterceptor createUserTaskInterceptor;
    protected IdentityLinkInterceptor identityLinkInterceptor;
    protected ProcessInstanceQueryInterceptor processInstanceQueryInterceptor;
    protected ExecutionQueryInterceptor executionQueryInterceptor;
    protected HistoricProcessInstanceQueryInterceptor historicProcessInstanceQueryInterceptor;
    protected TaskQueryInterceptor taskQueryInterceptor;
    protected HistoricTaskQueryInterceptor historicTaskQueryInterceptor;
    protected int executionQueryLimit = 20000;
    protected int taskQueryLimit = 20000;
    protected int historicTaskQueryLimit = 20000;
    protected int historicProcessInstancesQueryLimit = 20000;

    protected string wsSyncFactoryClassName = DEFAULT_WS_SYNC_FACTORY;
    //protected XMLImporterFactory wsWsdlImporterFactory;
    //protected ConcurrentMap<QName, URL> wsOverridenEndpointAddresses = new ConcurrentHashMap<>();

    protected DelegateInterceptor delegateInterceptor;

    protected Map!(string, EventHandler) eventHandlers;
    protected List!EventHandler customEventHandlers;

    protected FailedJobCommandFactory failedJobCommandFactory;

    protected FormFieldHandler formFieldHandler;
    protected bool isFormFieldValidationEnabled;

    protected EventRegistryEventConsumer eventRegistryEventConsumer;

    /**
     * Set this to true if you want to have extra checks on the BPMN xml that is parsed. See http://www.jorambarrez.be/blog/2013/02/19/uploading-a-funny-xml -can-bring-down-your-server/
     * <p>
     * Unfortunately, this feature is not available on some platforms (JDK 6, JBoss), hence the reason why it is disabled by default. If your platform allows the use of StaxSource during XML parsing,
     * do enable it.
     */
    protected bool enableSafeBpmnXml;

    /**
     * The following settings will determine the amount of entities loaded at once when the engine needs to load multiple entities (eg. when suspending a process definition with all its process
     * instances).
     * <p>
     * The default setting is quite low, as not to surprise anyone with sudden memory spikes. Change it to something higher if the environment Flowable runs in allows it.
     */
    protected int batchSizeProcessInstances = 25;
    protected int batchSizeTasks = 25;

    // Event logging to database
    protected bool enableDatabaseEventLogging;
    protected bool enableHistoricTaskLogging;

    /**
     * Using field injection together with a delegate expression for a service task / execution listener / task listener is not thread-sade , see user guide section 'Field Injection' for more
     * information.
     * <p>
     * Set this flag to false to throw an exception at runtime when a field is injected and a delegateExpression is used.
     *
     * @since 5.21
     */
    protected DelegateExpressionFieldInjectionMode delegateExpressionFieldInjectionMode = DelegateExpressionFieldInjectionMode.MIXED;

    protected List!Object flowable5JobProcessors = Collections.emptyList();
    protected List!JobProcessor jobProcessors = Collections.emptyList();
    protected List!HistoryJobProcessor historyJobProcessors = Collections.emptyList();

    /**
     * Enabled a very verbose debug output of the execution tree whilst executing operations. Most useful for core engine developers or people fiddling around with the execution tree.
     */
    protected bool enableVerboseExecutionTreeLogging;

    protected PerformanceSettings performanceSettings = new PerformanceSettings();

    // agenda factory
    protected FlowableEngineAgendaFactory agendaFactory;

    protected SchemaManager identityLinkSchemaManager;
    protected SchemaManager entityLinkSchemaManager;
    protected SchemaManager eventSubscriptionSchemaManager;
    protected SchemaManager variableSchemaManager;
    protected SchemaManager taskSchemaManager;
    protected SchemaManager jobSchemaManager;
    protected SchemaManager batchSchemaManager;

    protected bool handleProcessEngineExecutorsAfterEngineCreate = true;

    // Backwards compatibility //////////////////////////////////////////////////////////////

    protected bool flowable5CompatibilityEnabled; // Default flowable 5 backwards compatibility is disabled!
    protected bool validateFlowable5EntitiesEnabled = true; // When disabled no checks are performed for existing flowable 5 entities in the db
    protected bool redeployFlowable5ProcessDefinitions;
    protected Flowable5CompatibilityHandlerFactory flowable5CompatibilityHandlerFactory;
    protected Flowable5CompatibilityHandler flowable5CompatibilityHandler;

    // Can't have a dependency on the Flowable5-engine module
    protected Object flowable5ActivityBehaviorFactory;
    protected Object flowable5ListenerFactory;
    protected List!Object flowable5PreBpmnParseHandlers;
    protected List!Object flowable5PostBpmnParseHandlers;
    protected List!Object flowable5CustomDefaultBpmnParseHandlers;
    protected Set!TypeInfo flowable5CustomMybatisMappers;
    protected Set!string flowable5CustomMybatisXMLMappers;
    protected Object flowable5ExpressionManager;

    this() {
        mybatisMappingFile = DEFAULT_MYBATIS_MAPPING_FILE;
    }

    // buildProcessEngine
    // ///////////////////////////////////////////////////////

    override
    public ProcessEngine buildProcessEngine() {
        init();
        ProcessEngineImpl processEngine = new ProcessEngineImpl(this);

        if (handleProcessEngineExecutorsAfterEngineCreate) {
            processEngine.startExecutors();
        }

        // trigger build of Flowable 5 Engine
        if (flowable5CompatibilityEnabled && flowable5CompatibilityHandler !is null) {
            commandExecutor.execute(new Command<Void>() {

                override
                public Void execute(CommandContext commandContext) {
                    flowable5CompatibilityHandler.getRawProcessEngine();
                    return null;
                }
            });
        }

        postProcessEngineInitialisation();

        return processEngine;
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initEngineConfigurations();
        initConfigurators();
        configuratorsBeforeInit();
        //initProcessDiagramGenerator();
        initHistoryLevel();
        initShortHandExpressionFunctions();
        initFunctionDelegates();
        initExpressionEnhancers();
        initDelegateInterceptor();
        initExpressionManager();
        initAgendaFactory();

        if (usingRelationalDatabase) {
            initDataSource();
        } else {
            initNonRelationalDataSource();
        }

        if (usingRelationalDatabase || usingSchemaMgmt) {
            initSchemaManager();
            initSchemaManagementCommand();
        }

        initHelpers();
        initVariableTypes();
        initBeans();
        initFormEngines();
        initFormTypes();
        initScriptingEngines();
        initClock();
        initBusinessCalendarManager();
        initCommandContextFactory();
        initTransactionContextFactory();
        initCommandExecutors();
        initServices();
        initIdGenerator();
        initWsdlImporterFactory();
        initBehaviorFactory();
        initListenerFactory();
        initBpmnParser();
        initProcessDefinitionCache();
        initProcessDefinitionInfoCache();
        initAppResourceCache();
        initKnowledgeBaseCache();
        initJobHandlers();
        initHistoryJobHandlers();

        initTransactionFactory();

        if (usingRelationalDatabase) {
            initSqlSessionFactory();
        }

        initSessionFactories();
        initDataManagers();
        initEntityManagers();
        initCandidateManager();
        initHistoryManager();
        initDynamicStateManager();
        initProcessInstanceMigrationValidationManager();
        initIdentityLinkInterceptor();
        initJpa();
        initDeployers();
        initEventHandlers();
        initFailedJobCommandFactory();
        initEventDispatcher();
        initProcessValidator();
        initFormFieldHandler();
        initDatabaseEventLogging();
        initFlowable5CompatibilityHandler();
        initVariableServiceConfiguration();
        initIdentityLinkServiceConfiguration();
        initEntityLinkServiceConfiguration();
        initEventSubscriptionServiceConfiguration();
        initTaskServiceConfiguration();
        initJobServiceConfiguration();
        initBatchServiceConfiguration();
        initAsyncExecutor();
        initAsyncHistoryExecutor();

        configuratorsAfterInit();
        afterInitTaskServiceConfiguration();
        afterInitEventRegistryEventBusConsumer();

        initHistoryCleaningManager();
        initLocalizationManagers();
    }

    // failedJobCommandFactory
    // ////////////////////////////////////////////////////////

    public void initFailedJobCommandFactory() {
        if (failedJobCommandFactory is null) {
            failedJobCommandFactory = new DefaultFailedJobCommandFactory();
        }
    }

    // command executors
    // ////////////////////////////////////////////////////////

    override
    public void initCommandExecutors() {
        initDefaultCommandConfig();
        initSchemaCommandConfig();
        initCommandInvoker();
        initCommandInterceptors();
        initCommandExecutor();
    }

    override
    public void initCommandInvoker() {
        if (commandInvoker is null) {
            if (enableVerboseExecutionTreeLogging) {
                commandInvoker = new LoggingExecutionTreeCommandInvoker();
            } else {
                commandInvoker = new CommandInvoker();
            }
        }
    }

    override
    public string getEngineCfgKey() {
        return EngineConfigurationConstants.KEY_PROCESS_ENGINE_CONFIG;
    }

    override
    public List!CommandInterceptor getAdditionalDefaultCommandInterceptors() {
        return Collections.singletonList!CommandInterceptor(new BpmnOverrideContextInterceptor());
    }
    // services
    // /////////////////////////////////////////////////////////////////

    public void initServices() {
        initService(repositoryService);
        initService(runtimeService);
        initService(historyService);
        initService(identityService);
        initService(taskService);
        initService(formService);
        initService(managementService);
        initService(dynamicBpmnService);
        initService(processInstanceMigrationService);
    }

    override
    public void initSchemaManager() {
        super.initSchemaManager();

        initProcessSchemaManager();
        initIdentityLinkSchemaManager();
        initEntityLinkSchemaManager();
        initEventSubscriptionSchemaManager();
        initVariableSchemaManager();
        initTaskSchemaManager();
        initJobSchemaManager();
        initBatchSchemaManager();
    }

    public void initNonRelationalDataSource() {
        // for subclassing
    }

    protected void initProcessSchemaManager() {
        if (this.schemaManager is null) {
            this.schemaManager = new ProcessDbSchemaManager();
        }
    }

    protected void initVariableSchemaManager() {
        if (this.variableSchemaManager is null) {
            this.variableSchemaManager = new VariableDbSchemaManager();
        }
    }

    protected void initTaskSchemaManager() {
        if (this.taskSchemaManager is null) {
            this.taskSchemaManager = new TaskDbSchemaManager();
        }
    }

    protected void initIdentityLinkSchemaManager() {
        if (this.identityLinkSchemaManager is null) {
            this.identityLinkSchemaManager = new IdentityLinkDbSchemaManager();
        }
    }

    protected void initEntityLinkSchemaManager() {
        if (this.entityLinkSchemaManager is null) {
            this.entityLinkSchemaManager = new EntityLinkDbSchemaManager();
        }
    }

    protected void initEventSubscriptionSchemaManager() {
        if (this.eventSubscriptionSchemaManager is null) {
            this.eventSubscriptionSchemaManager = new EventSubscriptionDbSchemaManager();
        }
    }

    protected void initJobSchemaManager() {
        if (this.jobSchemaManager is null) {
            this.jobSchemaManager = new JobDbSchemaManager();
        }
    }

    protected void initBatchSchemaManager() {
        if (this.batchSchemaManager is null) {
            this.batchSchemaManager = new BatchDbSchemaManager();
        }
    }

    public void initSchemaManagementCommand() {
        if (schemaManagementCmd is null) {
            if (usingRelationalDatabase && databaseSchemaUpdate !is null) {
                this.schemaManagementCmd = new SchemaOperationsProcessEngineBuild();
            }
        }
    }

    override
    public void initMybatisTypeHandlers(Configuration configuration) {
        configuration.getTypeHandlerRegistry().register(VariableType.class, JdbcType.VARCHAR, new IbatisVariableTypeHandler(variableTypes));
    }

    override
    public InputStream getMyBatisXmlConfigurationStream() {
        return getResourceAsStream(mybatisMappingFile);
    }

    override
    public ProcessEngineConfigurationImpl setCustomMybatisMappers(Set<Class<?>> customMybatisMappers) {
        this.customMybatisMappers = customMybatisMappers;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setCustomMybatisXMLMappers(Set!string customMybatisXMLMappers) {
        this.customMybatisXMLMappers = customMybatisXMLMappers;
        return this;
    }

    // Data managers ///////////////////////////////////////////////////////////

    override
    @SuppressWarnings("rawtypes")
    public void initDataManagers() {
        super.initDataManagers();
        if (attachmentDataManager is null) {
            attachmentDataManager = new MybatisAttachmentDataManager(this);
        }
        if (byteArrayDataManager is null) {
            byteArrayDataManager = new MybatisByteArrayDataManager(this);
        }
        if (commentDataManager is null) {
            commentDataManager = new MybatisCommentDataManager(this);
        }
        if (deploymentDataManager is null) {
            deploymentDataManager = new MybatisDeploymentDataManager(this);
        }
        if (eventLogEntryDataManager is null) {
            eventLogEntryDataManager = new MybatisEventLogEntryDataManager(this);
        }
        if (executionDataManager is null) {
            executionDataManager = new MybatisExecutionDataManager(this);
        }
        if (dbSqlSessionFactory !is null && executionDataManager instanceof AbstractDataManager) {
            dbSqlSessionFactory.addLogicalEntityClassMapping("execution", ((AbstractDataManager) executionDataManager).getManagedEntityClass());
        }
        if (historicActivityInstanceDataManager is null) {
            historicActivityInstanceDataManager = new MybatisHistoricActivityInstanceDataManager(this);
        }
        if (activityInstanceDataManager is null) {
            activityInstanceDataManager = new MybatisActivityInstanceDataManager(this);
        }
        if (historicDetailDataManager is null) {
            historicDetailDataManager = new MybatisHistoricDetailDataManager(this);
        }
        if (historicProcessInstanceDataManager is null) {
            historicProcessInstanceDataManager = new MybatisHistoricProcessInstanceDataManager(this);
        }
        if (modelDataManager is null) {
            modelDataManager = new MybatisModelDataManager(this);
        }
        if (processDefinitionDataManager is null) {
            processDefinitionDataManager = new MybatisProcessDefinitionDataManager(this);
        }
        if (processDefinitionInfoDataManager is null) {
            processDefinitionInfoDataManager = new MybatisProcessDefinitionInfoDataManager(this);
        }
        if (resourceDataManager is null) {
            resourceDataManager = new MybatisResourceDataManager(this);
        }
    }

    // Entity managers //////////////////////////////////////////////////////////

    override
    public void initEntityManagers() {
        super.initEntityManagers();
        if (attachmentEntityManager is null) {
            attachmentEntityManager = new AttachmentEntityManagerImpl(this, attachmentDataManager);
        }
        if (byteArrayEntityManager is null) {
            byteArrayEntityManager = new ByteArrayEntityManagerImpl(this, byteArrayDataManager);
        }
        if (commentEntityManager is null) {
            commentEntityManager = new CommentEntityManagerImpl(this, commentDataManager);
        }
        if (deploymentEntityManager is null) {
            deploymentEntityManager = new DeploymentEntityManagerImpl(this, deploymentDataManager);
        }
        if (eventLogEntryEntityManager is null) {
            eventLogEntryEntityManager = new EventLogEntryEntityManagerImpl(this, eventLogEntryDataManager);
        }
        if (executionEntityManager is null) {
            executionEntityManager = new ExecutionEntityManagerImpl(this, executionDataManager);
        }
        if (activityInstanceEntityManager is null) {
            activityInstanceEntityManager = new ActivityInstanceEntityManagerImpl(this, activityInstanceDataManager);
        }
        if (historicActivityInstanceEntityManager is null) {
            historicActivityInstanceEntityManager = new HistoricActivityInstanceEntityManagerImpl(this, historicActivityInstanceDataManager);
        }
        if (historicDetailEntityManager is null) {
            historicDetailEntityManager = new HistoricDetailEntityManagerImpl(this, historicDetailDataManager);
        }
        if (historicProcessInstanceEntityManager is null) {
            historicProcessInstanceEntityManager = new HistoricProcessInstanceEntityManagerImpl(this, historicProcessInstanceDataManager);
        }
        if (modelEntityManager is null) {
            modelEntityManager = new ModelEntityManagerImpl(this, modelDataManager);
        }
        if (processDefinitionEntityManager is null) {
            processDefinitionEntityManager = new ProcessDefinitionEntityManagerImpl(this, processDefinitionDataManager);
        }
        if (processDefinitionInfoEntityManager is null) {
            processDefinitionInfoEntityManager = new ProcessDefinitionInfoEntityManagerImpl(this, processDefinitionInfoDataManager);
        }
        if (resourceEntityManager is null) {
            resourceEntityManager = new ResourceEntityManagerImpl(this, resourceDataManager);
        }
        if (tableDataManager is null) {
            tableDataManager = new TableDataManagerImpl(this);
        }
    }

    // CandidateManager //////////////////////////////

    public void initCandidateManager() {
        if (candidateManager is null) {
            candidateManager = new DefaultCandidateManager(this);
        }
    }

    // History manager ///////////////////////////////////////////////////////////

    public void initHistoryManager() {
        if (historyManager is null) {
            if (isAsyncHistoryEnabled) {
                historyManager = new AsyncHistoryManager(this, historyLevel, usePrefixId);
            } else {
                historyManager = new DefaultHistoryManager(this, historyLevel, usePrefixId);
            }
        }
    }

    // Dynamic state manager ////////////////////////////////////////////////////

    public void initDynamicStateManager() {
        if (dynamicStateManager is null) {
            dynamicStateManager = new DefaultDynamicStateManager();
        }
    }

    public void initProcessInstanceMigrationValidationManager() {
        if (processInstanceMigrationManager is null) {
            processInstanceMigrationManager = new ProcessInstanceMigrationManagerImpl();
        }
    }

    // identity link interceptor ///////////////////////////////////////////////
    public void initIdentityLinkInterceptor() {
        if (identityLinkInterceptor is null) {
            identityLinkInterceptor = new DefaultIdentityLinkInterceptor();
        }
    }

    // session factories ////////////////////////////////////////////////////////

    override
    public void initSessionFactories() {
        if (sessionFactories is null) {
            sessionFactories = new HashMap<>();

            if (usingRelationalDatabase) {
                initDbSqlSessionFactory();
            }

            if (isAsyncHistoryEnabled) {
                initAsyncHistorySessionFactory();
            }

            if (agendaFactory !is null) {
                addSessionFactory(new AgendaSessionFactory(agendaFactory));
            }

            addSessionFactory(new GenericManagerFactory(EntityCache.class, EntityCacheImpl.class));

            commandContextFactory.setSessionFactories(sessionFactories);

        } else {
            if (isAsyncHistoryEnabled) {
                if (!sessionFactories.containsKey(AsyncHistorySession.class)) {
                    initAsyncHistorySessionFactory();
                }
            }

            if (!sessionFactories.containsKey(FlowableEngineAgenda.class)) {
                if (agendaFactory !is null) {
                    addSessionFactory(new AgendaSessionFactory(agendaFactory));
                }
            }
        }

        if (isLoggingSessionEnabled()) {
            if (!sessionFactories.containsKey(LoggingSession.class)) {
                LoggingSessionFactory loggingSessionFactory = new LoggingSessionFactory();
                loggingSessionFactory.setLoggingListener(loggingListener);
                loggingSessionFactory.setObjectMapper(objectMapper);
                sessionFactories.put(LoggingSession.class, loggingSessionFactory);
            }
        }

        if (customSessionFactories !is null) {
            for (SessionFactory sessionFactory : customSessionFactories) {
                addSessionFactory(sessionFactory);
            }
        }

    }

    override
    protected void initDbSqlSessionFactoryEntitySettings() {
        defaultInitDbSqlSessionFactoryEntitySettings(EntityDependencyOrder.INSERT_ORDER, EntityDependencyOrder.DELETE_ORDER);

        // Oracle doesn't support bulk inserting for event log entries
        if (isBulkInsertEnabled && "oracle".equals(databaseType)) {
            dbSqlSessionFactory.getBulkInserteableEntityClasses().remove(EventLogEntryEntityImpl.class);
        }
    }

    public void initAsyncHistorySessionFactory() {
        if (!sessionFactories.containsKey(AsyncHistorySession.class)) {
            AsyncHistorySessionFactory asyncHistorySessionFactory = new AsyncHistorySessionFactory();
            if (asyncHistoryListener is null) {
                initDefaultAsyncHistoryListener();
            }
            asyncHistorySessionFactory.setAsyncHistoryListener(asyncHistoryListener);
            sessionFactories.put(AsyncHistorySession.class, asyncHistorySessionFactory);
        }

        ((AsyncHistorySessionFactory) sessionFactories.get(AsyncHistorySession.class)).registerJobDataTypes(HistoryJsonConstants.ORDERED_TYPES);
    }

    protected void initDefaultAsyncHistoryListener() {
        asyncHistoryListener = new DefaultAsyncHistoryJobProducer();
    }

    public void initVariableServiceConfiguration() {
        this.variableServiceConfiguration = instantiateVariableServiceConfiguration();
        this.variableServiceConfiguration.setHistoryLevel(this.historyLevel);
        this.variableServiceConfiguration.setClock(this.clock);
        this.variableServiceConfiguration.setObjectMapper(this.objectMapper);
        this.variableServiceConfiguration.setEventDispatcher(this.eventDispatcher);

        this.variableServiceConfiguration.setVariableTypes(this.variableTypes);

        if (this.internalHistoryVariableManager !is null) {
            this.variableServiceConfiguration.setInternalHistoryVariableManager(this.internalHistoryVariableManager);
        } else {
            this.variableServiceConfiguration.setInternalHistoryVariableManager(new DefaultHistoryVariableManager(this));
        }

        this.variableServiceConfiguration.setMaxLengthString(this.getMaxLengthString());
        this.variableServiceConfiguration.setSerializableVariableTypeTrackDeserializedObjects(this.isSerializableVariableTypeTrackDeserializedObjects());
        this.variableServiceConfiguration.setLoggingSessionEnabled(isLoggingSessionEnabled());

        this.variableServiceConfiguration.init();

        addServiceConfiguration(EngineConfigurationConstants.KEY_VARIABLE_SERVICE_CONFIG, this.variableServiceConfiguration);
    }

    protected VariableServiceConfiguration instantiateVariableServiceConfiguration() {
        return new VariableServiceConfiguration(ScopeTypes.BPMN);
    }

    public void initIdentityLinkServiceConfiguration() {
        this.identityLinkServiceConfiguration = instantiateIdentityLinkServiceConfiguration();
        this.identityLinkServiceConfiguration.setHistoryLevel(this.historyLevel);
        this.identityLinkServiceConfiguration.setClock(this.clock);
        this.identityLinkServiceConfiguration.setObjectMapper(this.objectMapper);
        this.identityLinkServiceConfiguration.setEventDispatcher(this.eventDispatcher);
        this.identityLinkServiceConfiguration.setIdentityLinkEventHandler(this.identityLinkEventHandler);

        this.identityLinkServiceConfiguration.init();

        addServiceConfiguration(EngineConfigurationConstants.KEY_IDENTITY_LINK_SERVICE_CONFIG, this.identityLinkServiceConfiguration);
    }

    protected IdentityLinkServiceConfiguration instantiateIdentityLinkServiceConfiguration() {
        return new IdentityLinkServiceConfiguration(ScopeTypes.BPMN);
    }

    public void initEntityLinkServiceConfiguration() {
        if (this.enableEntityLinks) {
            this.entityLinkServiceConfiguration = instantiateEntityLinkServiceConfiguration();
            this.entityLinkServiceConfiguration.setHistoryLevel(this.historyLevel);
            this.entityLinkServiceConfiguration.setClock(this.clock);
            this.entityLinkServiceConfiguration.setObjectMapper(this.objectMapper);
            this.entityLinkServiceConfiguration.setEventDispatcher(this.eventDispatcher);

            this.entityLinkServiceConfiguration.init();

            addServiceConfiguration(EngineConfigurationConstants.KEY_ENTITY_LINK_SERVICE_CONFIG, this.entityLinkServiceConfiguration);
        }
    }

    protected EntityLinkServiceConfiguration instantiateEntityLinkServiceConfiguration() {
        return new EntityLinkServiceConfiguration(ScopeTypes.BPMN);
    }

    public void initEventSubscriptionServiceConfiguration() {
        this.eventSubscriptionServiceConfiguration = instantiateEventSubscriptionServiceConfiguration();
        this.eventSubscriptionServiceConfiguration.setClock(this.clock);
        this.eventSubscriptionServiceConfiguration.setObjectMapper(this.objectMapper);
        this.eventSubscriptionServiceConfiguration.setEventDispatcher(this.eventDispatcher);

        this.eventSubscriptionServiceConfiguration.init();

        addServiceConfiguration(EngineConfigurationConstants.KEY_EVENT_SUBSCRIPTION_SERVICE_CONFIG, this.eventSubscriptionServiceConfiguration);
    }

    protected EventSubscriptionServiceConfiguration instantiateEventSubscriptionServiceConfiguration() {
        return new EventSubscriptionServiceConfiguration(ScopeTypes.BPMN);
    }

    public void initTaskServiceConfiguration() {
        this.taskServiceConfiguration = instantiateTaskServiceConfiguration();
        this.taskServiceConfiguration.setHistoryLevel(this.historyLevel);
        this.taskServiceConfiguration.setClock(this.clock);
        this.taskServiceConfiguration.setObjectMapper(this.objectMapper);
        this.taskServiceConfiguration.setEventDispatcher(this.eventDispatcher);
        this.taskServiceConfiguration.setEnableHistoricTaskLogging(this.enableHistoricTaskLogging);

        if (this.taskPostProcessor !is null) {
            this.taskServiceConfiguration.setTaskPostProcessor(this.taskPostProcessor);
        } else {
            this.taskServiceConfiguration.setTaskPostProcessor(new DefaultTaskPostProcessor());
        }

        if (this.internalHistoryTaskManager !is null) {
            this.taskServiceConfiguration.setInternalHistoryTaskManager(this.internalHistoryTaskManager);
        } else {
            this.taskServiceConfiguration.setInternalHistoryTaskManager(new DefaultHistoryTaskManager(this));
        }

        if (this.internalTaskVariableScopeResolver !is null) {
            this.taskServiceConfiguration.setInternalTaskVariableScopeResolver(this.internalTaskVariableScopeResolver);
        } else {
            this.taskServiceConfiguration.setInternalTaskVariableScopeResolver(new DefaultTaskVariableScopeResolver(this));
        }

        if (this.internalTaskAssignmentManager !is null) {
            this.taskServiceConfiguration.setInternalTaskAssignmentManager(this.internalTaskAssignmentManager);
        } else {
            this.taskServiceConfiguration.setInternalTaskAssignmentManager(new DefaultTaskAssignmentManager());
        }

        if (this.internalTaskLocalizationManager !is null) {
            this.taskServiceConfiguration.setInternalTaskLocalizationManager(this.internalTaskLocalizationManager);
        } else {
            this.taskServiceConfiguration.setInternalTaskLocalizationManager(new DefaultTaskLocalizationManager(this));
        }

        this.taskServiceConfiguration.setEnableTaskRelationshipCounts(this.performanceSettings.isEnableTaskRelationshipCounts());
        this.taskServiceConfiguration.setEnableLocalization(this.performanceSettings.isEnableLocalization());
        this.taskServiceConfiguration.setTaskQueryInterceptor(this.taskQueryInterceptor);
        this.taskServiceConfiguration.setHistoricTaskQueryInterceptor(this.historicTaskQueryInterceptor);
        this.taskServiceConfiguration.setTaskQueryLimit(this.taskQueryLimit);
        this.taskServiceConfiguration.setHistoricTaskQueryLimit(this.historicTaskQueryLimit);

        this.taskServiceConfiguration.init();

        if (dbSqlSessionFactory !is null && taskServiceConfiguration.getTaskDataManager() instanceof AbstractDataManager) {
            dbSqlSessionFactory.addLogicalEntityClassMapping("task", ((AbstractDataManager) taskServiceConfiguration.getTaskDataManager()).getManagedEntityClass());
        }

        addServiceConfiguration(EngineConfigurationConstants.KEY_TASK_SERVICE_CONFIG, this.taskServiceConfiguration);
    }

    protected TaskServiceConfiguration instantiateTaskServiceConfiguration() {
        return new TaskServiceConfiguration(ScopeTypes.BPMN);
    }

    public void initJobServiceConfiguration() {
        if (jobServiceConfiguration is null) {
            this.jobServiceConfiguration = instantiateJobServiceConfiguration();
            this.jobServiceConfiguration.setHistoryLevel(this.historyLevel);
            this.jobServiceConfiguration.setClock(this.clock);
            this.jobServiceConfiguration.setObjectMapper(this.objectMapper);
            this.jobServiceConfiguration.setEventDispatcher(this.eventDispatcher);
            this.jobServiceConfiguration.setCommandExecutor(this.commandExecutor);
            this.jobServiceConfiguration.setExpressionManager(this.expressionManager);
            this.jobServiceConfiguration.setBusinessCalendarManager(this.businessCalendarManager);

            this.jobServiceConfiguration.setFailedJobCommandFactory(this.failedJobCommandFactory);

            List!AsyncRunnableExecutionExceptionHandler exceptionHandlers = new ArrayList<>();
            if (customAsyncRunnableExecutionExceptionHandlers !is null) {
                exceptionHandlers.addAll(customAsyncRunnableExecutionExceptionHandlers);
            }

            if (addDefaultExceptionHandler) {
                exceptionHandlers.add(new DefaultAsyncRunnableExecutionExceptionHandler());
            }

            if (internalJobParentStateResolver !is null) {
                this.jobServiceConfiguration.setJobParentStateResolver(internalJobParentStateResolver);
            } else {
                this.jobServiceConfiguration.setJobParentStateResolver(new DefaultProcessJobParentStateResolver(this));
            }

            this.jobServiceConfiguration.setAsyncRunnableExecutionExceptionHandlers(exceptionHandlers);
            this.jobServiceConfiguration.setAsyncExecutorNumberOfRetries(this.asyncExecutorNumberOfRetries);
            this.jobServiceConfiguration.setAsyncExecutorResetExpiredJobsMaxTimeout(this.asyncExecutorResetExpiredJobsMaxTimeout);

            if (this.jobManager !is null) {
                this.jobServiceConfiguration.setJobManager(this.jobManager);
            }

            if (this.internalJobManager !is null) {
                this.jobServiceConfiguration.setInternalJobManager(this.internalJobManager);
            } else {
                this.jobServiceConfiguration.setInternalJobManager(new DefaultInternalJobManager(this));
            }

            if (this.internalJobCompatibilityManager !is null) {
                this.jobServiceConfiguration.setInternalJobCompatibilityManager(internalJobCompatibilityManager);
            } else {
                this.jobServiceConfiguration.setInternalJobCompatibilityManager(new DefaultInternalJobCompatibilityManager(this));
            }

            // Async history job config
            jobServiceConfiguration.setJobTypeAsyncHistory(HistoryJsonConstants.JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY);
            jobServiceConfiguration.setJobTypeAsyncHistoryZipped(HistoryJsonConstants.JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY_ZIPPED);
            jobServiceConfiguration.setAsyncHistoryJsonGzipCompressionEnabled(isAsyncHistoryJsonGzipCompressionEnabled);
            jobServiceConfiguration.setAsyncHistoryJsonGroupingEnabled(isAsyncHistoryJsonGroupingEnabled);
            jobServiceConfiguration.setAsyncHistoryJsonGroupingThreshold(asyncHistoryJsonGroupingThreshold);

            // set the job processors
            this.jobServiceConfiguration.setJobProcessors(this.jobProcessors);
            this.jobServiceConfiguration.setHistoryJobProcessors(this.historyJobProcessors);

            this.jobServiceConfiguration.setJobExecutionScope(this.jobExecutionScope);
            this.jobServiceConfiguration.setHistoryJobExecutionScope(this.historyJobExecutionScope);

            this.jobServiceConfiguration.init();
        }

        if (this.jobHandlers !is null) {
            for (string type : this.jobHandlers.keySet()) {
                this.jobServiceConfiguration.addJobHandler(type, this.jobHandlers.get(type));
            }
        }

        if (this.historyJobHandlers !is null) {
            for (string type : this.historyJobHandlers.keySet()) {
                this.jobServiceConfiguration.addHistoryJobHandler(type, this.historyJobHandlers.get(type));
            }
        }

        addServiceConfiguration(EngineConfigurationConstants.KEY_JOB_SERVICE_CONFIG, this.jobServiceConfiguration);
    }

    protected JobServiceConfiguration instantiateJobServiceConfiguration() {
        return new JobServiceConfiguration(ScopeTypes.BPMN);
    }

    public void addJobHandler(JobHandler jobHandler) {
        this.jobHandlers.put(jobHandler.getType(), jobHandler);
        if (this.jobServiceConfiguration !is null) {
            this.jobServiceConfiguration.addJobHandler(jobHandler.getType(), jobHandler);
        }
    }

    public void removeJobHandler(string jobHandlerType) {
        this.jobHandlers.remove(jobHandlerType);
        if (this.jobServiceConfiguration !is null) {
            this.jobServiceConfiguration.getJobHandlers().remove(jobHandlerType);
        }
    }

    public void addHistoryJobHandler(HistoryJobHandler historyJobHandler) {
        this.historyJobHandlers.put(historyJobHandler.getType(), historyJobHandler);
        if (this.jobServiceConfiguration !is null) {
            this.jobServiceConfiguration.addHistoryJobHandler(historyJobHandler.getType(), historyJobHandler);
        }
    }

    public void initBatchServiceConfiguration() {
        if (batchServiceConfiguration is null) {
            this.batchServiceConfiguration = instantiateBatchServiceConfiguration();
            this.batchServiceConfiguration.setClock(this.clock);
            this.batchServiceConfiguration.setObjectMapper(this.objectMapper);
            this.batchServiceConfiguration.setEventDispatcher(this.eventDispatcher);

            this.batchServiceConfiguration.init();
        }

        addServiceConfiguration(EngineConfigurationConstants.KEY_BATCH_SERVICE_CONFIG, this.batchServiceConfiguration);
    }

    protected BatchServiceConfiguration instantiateBatchServiceConfiguration() {
        return new BatchServiceConfiguration(ScopeTypes.BPMN);
    }

    public void afterInitTaskServiceConfiguration() {
        if (engineConfigurations.containsKey(EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG)) {
            IdmEngineConfigurationApi idmEngineConfiguration = (IdmEngineConfigurationApi) engineConfigurations.get(EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG);
            this.taskServiceConfiguration.setIdmIdentityService(idmEngineConfiguration.getIdmIdentityService());
        }
    }

    public void afterInitEventRegistryEventBusConsumer() {
        EventRegistryEventConsumer bpmnEventRegistryEventConsumer = null;
        if (eventRegistryEventConsumer !is null) {
            bpmnEventRegistryEventConsumer = eventRegistryEventConsumer;
        } else {
            bpmnEventRegistryEventConsumer = new BpmnEventRegistryEventConsumer(this);
        }

        addEventRegistryEventConsumer(bpmnEventRegistryEventConsumer.getConsumerKey(), bpmnEventRegistryEventConsumer);
    }

    public void initHistoryCleaningManager() {
        if (historyCleaningManager is null) {
            historyCleaningManager = new DefaultHistoryCleaningManager(this);
        }
    }

    public void removeHistoryJobHandler(string historyJobHandlerType) {
        this.historyJobHandlers.remove(historyJobHandlerType);
        if (this.jobServiceConfiguration !is null) {
            this.jobServiceConfiguration.getHistoryJobHandlers().remove(historyJobHandlerType);
        }
    }

    // deployers
    // ////////////////////////////////////////////////////////////////

    public void initProcessDefinitionCache() {
        if (processDefinitionCache is null) {
            if (processDefinitionCacheLimit <= 0) {
                processDefinitionCache = new DefaultDeploymentCache<>();
            } else {
                processDefinitionCache = new DefaultDeploymentCache<>(processDefinitionCacheLimit);
            }
        }
    }

    public void initProcessDefinitionInfoCache() {
        if (processDefinitionInfoCache is null) {
            if (processDefinitionInfoCacheLimit <= 0) {
                processDefinitionInfoCache = new ProcessDefinitionInfoCache(commandExecutor);
            } else {
                processDefinitionInfoCache = new ProcessDefinitionInfoCache(commandExecutor, processDefinitionInfoCacheLimit);
            }
        }
    }

    public void initAppResourceCache() {
        if (appResourceCache is null) {
            if (appResourceCacheLimit <= 0) {
                appResourceCache = new DefaultDeploymentCache<>();
            } else {
                appResourceCache = new DefaultDeploymentCache<>(appResourceCacheLimit);
            }
        }
    }

    public void initKnowledgeBaseCache() {
        if (knowledgeBaseCache is null) {
            if (knowledgeBaseCacheLimit <= 0) {
                knowledgeBaseCache = new DefaultDeploymentCache<>();
            } else {
                knowledgeBaseCache = new DefaultDeploymentCache<>(knowledgeBaseCacheLimit);
            }
        }
    }

    public void initDeployers() {
        if (this.deployers is null) {
            this.deployers = new ArrayList<>();
            if (customPreDeployers !is null) {
                this.deployers.addAll(customPreDeployers);
            }
            this.deployers.addAll(getDefaultDeployers());
            if (customPostDeployers !is null) {
                this.deployers.addAll(customPostDeployers);
            }
        }

        if (deploymentManager is null) {
            deploymentManager = new DeploymentManager();
            deploymentManager.setDeployers(deployers);

            deploymentManager.setProcessDefinitionCache(processDefinitionCache);
            deploymentManager.setProcessDefinitionInfoCache(processDefinitionInfoCache);
            deploymentManager.setAppResourceCache(appResourceCache);
            deploymentManager.setKnowledgeBaseCache(knowledgeBaseCache);
            deploymentManager.setProcessEngineConfiguration(this);
            deploymentManager.setProcessDefinitionEntityManager(processDefinitionEntityManager);
            deploymentManager.setDeploymentEntityManager(deploymentEntityManager);
        }

        if (appResourceConverter is null) {
            appResourceConverter = new AppResourceConverterImpl(objectMapper);
        }
    }

    public void initBpmnDeployerDependencies() {

        if (parsedDeploymentBuilderFactory is null) {
            parsedDeploymentBuilderFactory = new ParsedDeploymentBuilderFactory();
        }
        if (parsedDeploymentBuilderFactory.getBpmnParser() is null) {
            parsedDeploymentBuilderFactory.setBpmnParser(bpmnParser);
        }

        if (timerManager is null) {
            timerManager = new TimerManager();
        }

        if (eventSubscriptionManager is null) {
            eventSubscriptionManager = new EventSubscriptionManager();
        }

        if (bpmnDeploymentHelper is null) {
            bpmnDeploymentHelper = new BpmnDeploymentHelper();
        }
        if (bpmnDeploymentHelper.getTimerManager() is null) {
            bpmnDeploymentHelper.setTimerManager(timerManager);
        }
        if (bpmnDeploymentHelper.getEventSubscriptionManager() is null) {
            bpmnDeploymentHelper.setEventSubscriptionManager(eventSubscriptionManager);
        }

        if (cachingAndArtifactsManager is null) {
            cachingAndArtifactsManager = new CachingAndArtifactsManager();
        }

        if (processDefinitionDiagramHelper is null) {
            processDefinitionDiagramHelper = new ProcessDefinitionDiagramHelper();
        }
    }

    public Collection<? extends EngineDeployer> getDefaultDeployers() {
        List<EngineDeployer> defaultDeployers = new ArrayList<>();

        if (bpmnDeployer is null) {
            bpmnDeployer = new BpmnDeployer();
        }

        initBpmnDeployerDependencies();

        bpmnDeployer.setIdGenerator(idGenerator);
        bpmnDeployer.setParsedDeploymentBuilderFactory(parsedDeploymentBuilderFactory);
        bpmnDeployer.setBpmnDeploymentHelper(bpmnDeploymentHelper);
        bpmnDeployer.setCachingAndArtifactsManager(cachingAndArtifactsManager);
        bpmnDeployer.setProcessDefinitionDiagramHelper(processDefinitionDiagramHelper);
        bpmnDeployer.setUsePrefixId(usePrefixId);

        defaultDeployers.add(bpmnDeployer);

        if (appDeployer is null) {
            appDeployer = new AppDeployer();
        }

        defaultDeployers.add(appDeployer);

        return defaultDeployers;
    }

    public void initListenerFactory() {
        if (listenerFactory is null) {
            DefaultListenerFactory defaultListenerFactory = new DefaultListenerFactory();
            defaultListenerFactory.setExpressionManager(expressionManager);
            listenerFactory = defaultListenerFactory;
        } else if ((listenerFactory instanceof AbstractBehaviorFactory) && ((AbstractBehaviorFactory) listenerFactory).getExpressionManager() is null) {
            ((AbstractBehaviorFactory) listenerFactory).setExpressionManager(expressionManager);
        }
    }

    public void initWsdlImporterFactory() {
        if (wsWsdlImporterFactory is null) {
            DefaultXMLImporterFactory defaultListenerFactory = new DefaultXMLImporterFactory();
            wsWsdlImporterFactory = defaultListenerFactory;
        }
    }

    public void initBehaviorFactory() {
        if (activityBehaviorFactory is null) {
            DefaultActivityBehaviorFactory defaultActivityBehaviorFactory = new DefaultActivityBehaviorFactory();
            defaultActivityBehaviorFactory.setExpressionManager(expressionManager);
            activityBehaviorFactory = defaultActivityBehaviorFactory;
        } else if ((activityBehaviorFactory instanceof AbstractBehaviorFactory) && ((AbstractBehaviorFactory) activityBehaviorFactory).getExpressionManager() is null) {
            ((AbstractBehaviorFactory) activityBehaviorFactory).setExpressionManager(expressionManager);
        }
    }

    public void initBpmnParser() {
        if (bpmnParser is null) {
            bpmnParser = new BpmnParser();
        }

        if (bpmnParseFactory is null) {
            bpmnParseFactory = new DefaultBpmnParseFactory();
        }

        bpmnParser.setBpmnParseFactory(bpmnParseFactory);
        bpmnParser.setActivityBehaviorFactory(activityBehaviorFactory);
        bpmnParser.setListenerFactory(listenerFactory);

        List!BpmnParseHandler parseHandlers = new ArrayList<>();
        if (getPreBpmnParseHandlers() !is null) {
            parseHandlers.addAll(getPreBpmnParseHandlers());
        }
        parseHandlers.addAll(getDefaultBpmnParseHandlers());
        if (getPostBpmnParseHandlers() !is null) {
            parseHandlers.addAll(getPostBpmnParseHandlers());
        }

        BpmnParseHandlers bpmnParseHandlers = new BpmnParseHandlers();
        bpmnParseHandlers.addHandlers(parseHandlers);
        bpmnParser.setBpmnParserHandlers(bpmnParseHandlers);
    }

    public List!BpmnParseHandler getDefaultBpmnParseHandlers() {

        // Alphabetic list of default parse handler classes
        List!BpmnParseHandler bpmnParserHandlers = new ArrayList<>();
        bpmnParserHandlers.add(new BoundaryEventParseHandler());
        bpmnParserHandlers.add(new BusinessRuleParseHandler());
        bpmnParserHandlers.add(new CallActivityParseHandler());
        bpmnParserHandlers.add(new CaseServiceTaskParseHandler());
        bpmnParserHandlers.add(new CancelEventDefinitionParseHandler());
        bpmnParserHandlers.add(new CompensateEventDefinitionParseHandler());
        bpmnParserHandlers.add(new ConditionalEventDefinitionParseHandler());
        bpmnParserHandlers.add(new EndEventParseHandler());
        bpmnParserHandlers.add(new ErrorEventDefinitionParseHandler());
        bpmnParserHandlers.add(new EscalationEventDefinitionParseHandler());
        bpmnParserHandlers.add(new EventBasedGatewayParseHandler());
        bpmnParserHandlers.add(new ExclusiveGatewayParseHandler());
        bpmnParserHandlers.add(new InclusiveGatewayParseHandler());
        bpmnParserHandlers.add(new IntermediateCatchEventParseHandler());
        bpmnParserHandlers.add(new IntermediateThrowEventParseHandler());
        bpmnParserHandlers.add(new ManualTaskParseHandler());
        bpmnParserHandlers.add(new MessageEventDefinitionParseHandler());
        bpmnParserHandlers.add(new ParallelGatewayParseHandler());
        bpmnParserHandlers.add(new ProcessParseHandler());
        bpmnParserHandlers.add(new ReceiveTaskParseHandler());
        bpmnParserHandlers.add(new ScriptTaskParseHandler());
        bpmnParserHandlers.add(new SendEventServiceTaskParseHandler());
        bpmnParserHandlers.add(new SendTaskParseHandler());
        bpmnParserHandlers.add(new SequenceFlowParseHandler());
        bpmnParserHandlers.add(new ServiceTaskParseHandler());
        bpmnParserHandlers.add(new HttpServiceTaskParseHandler());
        bpmnParserHandlers.add(new SignalEventDefinitionParseHandler());
        bpmnParserHandlers.add(new StartEventParseHandler());
        bpmnParserHandlers.add(new SubProcessParseHandler());
        bpmnParserHandlers.add(new EventSubProcessParseHandler());
        bpmnParserHandlers.add(new AdhocSubProcessParseHandler());
        bpmnParserHandlers.add(new TaskParseHandler());
        bpmnParserHandlers.add(new TimerEventDefinitionParseHandler());
        bpmnParserHandlers.add(new TransactionParseHandler());
        bpmnParserHandlers.add(new UserTaskParseHandler());

        // Replace any default handler if the user wants to replace them
        if (customDefaultBpmnParseHandlers !is null) {

            Map<Class<?>, BpmnParseHandler> customParseHandlerMap = new HashMap<>();
            for (BpmnParseHandler bpmnParseHandler : customDefaultBpmnParseHandlers) {
                for (Class<?> handledType : bpmnParseHandler.getHandledTypes()) {
                    customParseHandlerMap.put(handledType, bpmnParseHandler);
                }
            }

            for (int i = 0; i < bpmnParserHandlers.size(); i++) {
                // All the default handlers support only one type
                BpmnParseHandler defaultBpmnParseHandler = bpmnParserHandlers.get(i);
                if (defaultBpmnParseHandler.getHandledTypes().size() != 1) {
                    StringBuilder supportedTypes = new StringBuilder();
                    for (Class<?> type : defaultBpmnParseHandler.getHandledTypes()) {
                        supportedTypes.append(" ").append(type.getCanonicalName()).append(" ");
                    }
                    throw new FlowableException("The default BPMN parse handlers should only support one type, but " + defaultBpmnParseHandler.getClass() + " supports " + supportedTypes
                        + ". This is likely a programmatic error");
                } else {
                    Class<?> handledType = defaultBpmnParseHandler.getHandledTypes().iterator().next();
                    if (customParseHandlerMap.containsKey(handledType)) {
                        BpmnParseHandler newBpmnParseHandler = customParseHandlerMap.get(handledType);
                        logger.info("Replacing default BpmnParseHandler {} with {}", defaultBpmnParseHandler.getClass().getName(), newBpmnParseHandler.getClass().getName());
                        bpmnParserHandlers.set(i, newBpmnParseHandler);
                    }
                }
            }
        }

        return bpmnParserHandlers;
    }

    public void initProcessDiagramGenerator() {
        if (processDiagramGenerator is null) {
            processDiagramGenerator = new DefaultProcessDiagramGenerator();
        }
    }

    public void initJobHandlers() {
        jobHandlers = new HashMap<>();

        AsyncContinuationJobHandler asyncContinuationJobHandler = new AsyncContinuationJobHandler();
        jobHandlers.put(asyncContinuationJobHandler.getType(), asyncContinuationJobHandler);

        AsyncTriggerJobHandler asyncTriggerJobHandler = new AsyncTriggerJobHandler();
        jobHandlers.put(asyncTriggerJobHandler.getType(), asyncTriggerJobHandler);

        TriggerTimerEventJobHandler triggerTimerEventJobHandler = new TriggerTimerEventJobHandler();
        jobHandlers.put(triggerTimerEventJobHandler.getType(), triggerTimerEventJobHandler);

        TimerStartEventJobHandler timerStartEvent = new TimerStartEventJobHandler();
        jobHandlers.put(timerStartEvent.getType(), timerStartEvent);

        TimerSuspendProcessDefinitionHandler suspendProcessDefinitionHandler = new TimerSuspendProcessDefinitionHandler();
        jobHandlers.put(suspendProcessDefinitionHandler.getType(), suspendProcessDefinitionHandler);

        TimerActivateProcessDefinitionHandler activateProcessDefinitionHandler = new TimerActivateProcessDefinitionHandler();
        jobHandlers.put(activateProcessDefinitionHandler.getType(), activateProcessDefinitionHandler);

        ProcessEventJobHandler processEventJobHandler = new ProcessEventJobHandler();
        jobHandlers.put(processEventJobHandler.getType(), processEventJobHandler);

        AsyncCompleteCallActivityJobHandler asyncCompleteCallActivityJobHandler = new AsyncCompleteCallActivityJobHandler();
        jobHandlers.put(asyncCompleteCallActivityJobHandler.getType(), asyncCompleteCallActivityJobHandler);

        AsyncSendEventJobHandler asyncSendEventJobHandler = new AsyncSendEventJobHandler();
        jobHandlers.put(asyncSendEventJobHandler.getType(), asyncSendEventJobHandler);

        BpmnHistoryCleanupJobHandler bpmnHistoryCleanupJobHandler = new BpmnHistoryCleanupJobHandler();
        jobHandlers.put(bpmnHistoryCleanupJobHandler.getType(), bpmnHistoryCleanupJobHandler);

        ProcessInstanceMigrationJobHandler processInstanceMigrationJobHandler = new ProcessInstanceMigrationJobHandler();
        jobHandlers.put(processInstanceMigrationJobHandler.getType(), processInstanceMigrationJobHandler);

        ProcessInstanceMigrationStatusJobHandler processInstanceMigrationStatusJobHandler = new ProcessInstanceMigrationStatusJobHandler();
        jobHandlers.put(processInstanceMigrationStatusJobHandler.getType(), processInstanceMigrationStatusJobHandler);

        // if we have custom job handlers, register them
        if (getCustomJobHandlers() !is null) {
            for (JobHandler customJobHandler : getCustomJobHandlers()) {
                jobHandlers.put(customJobHandler.getType(), customJobHandler);
            }
        }
    }

    protected void initHistoryJobHandlers() {
        if (isAsyncHistoryEnabled) {
            historyJobHandlers = new HashMap<>();

            List!HistoryJsonTransformer allHistoryJsonTransformers = new ArrayList<>(initDefaultHistoryJsonTransformers());
            if (customHistoryJsonTransformers !is null) {
                allHistoryJsonTransformers.addAll(customHistoryJsonTransformers);
            }

            AsyncHistoryJobHandler asyncHistoryJobHandler = new AsyncHistoryJobHandler(HistoryJsonConstants.JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY);
            allHistoryJsonTransformers.forEach(asyncHistoryJobHandler::addHistoryJsonTransformer);
            asyncHistoryJobHandler.setAsyncHistoryJsonGroupingEnabled(isAsyncHistoryJsonGroupingEnabled);
            historyJobHandlers.put(asyncHistoryJobHandler.getType(), asyncHistoryJobHandler);

            AsyncHistoryJobZippedHandler asyncHistoryJobZippedHandler = new AsyncHistoryJobZippedHandler(HistoryJsonConstants.JOB_HANDLER_TYPE_DEFAULT_ASYNC_HISTORY_ZIPPED);
            allHistoryJsonTransformers.forEach(asyncHistoryJobZippedHandler::addHistoryJsonTransformer);
            asyncHistoryJobZippedHandler.setAsyncHistoryJsonGroupingEnabled(isAsyncHistoryJsonGroupingEnabled);
            historyJobHandlers.put(asyncHistoryJobZippedHandler.getType(), asyncHistoryJobZippedHandler);

            if (getCustomHistoryJobHandlers() !is null) {
                for (HistoryJobHandler customJobHandler : getCustomHistoryJobHandlers()) {
                    historyJobHandlers.put(customJobHandler.getType(), customJobHandler);
                }
            }
        }
    }

    protected List!HistoryJsonTransformer initDefaultHistoryJsonTransformers() {
        List!HistoryJsonTransformer historyJsonTransformers = new ArrayList<>();
        historyJsonTransformers.add(new ProcessInstanceStartHistoryJsonTransformer());
        historyJsonTransformers.add(new ProcessInstanceEndHistoryJsonTransformer());
        historyJsonTransformers.add(new ProcessInstanceDeleteHistoryJsonTransformer());
        historyJsonTransformers.add(new ProcessInstanceDeleteHistoryByProcessDefinitionIdJsonTransformer());
        historyJsonTransformers.add(new ProcessInstancePropertyChangedHistoryJsonTransformer());
        historyJsonTransformers.add(new SubProcessInstanceStartHistoryJsonTransformer());
        historyJsonTransformers.add(new SetProcessDefinitionHistoryJsonTransformer());
        historyJsonTransformers.add(new UpdateProcessDefinitionCascadeHistoryJsonTransformer());

        historyJsonTransformers.add(new ActivityStartHistoryJsonTransformer());
        historyJsonTransformers.add(new ActivityEndHistoryJsonTransformer());
        historyJsonTransformers.add(new ActivityFullHistoryJsonTransformer());
        historyJsonTransformers.add(new ActivityUpdateHistoryJsonTransformer());

        historyJsonTransformers.add(new TaskCreatedHistoryJsonTransformer());
        historyJsonTransformers.add(new TaskEndedHistoryJsonTransformer());

        historyJsonTransformers.add(new TaskPropertyChangedHistoryJsonTransformer());
        historyJsonTransformers.add(new TaskAssigneeChangedHistoryJsonTransformer());
        historyJsonTransformers.add(new TaskOwnerChangedHistoryJsonTransformer());

        historyJsonTransformers.add(new IdentityLinkCreatedHistoryJsonTransformer());
        historyJsonTransformers.add(new IdentityLinkDeletedHistoryJsonTransformer());

        historyJsonTransformers.add(new EntityLinkCreatedHistoryJsonTransformer());
        historyJsonTransformers.add(new EntityLinkDeletedHistoryJsonTransformer());

        historyJsonTransformers.add(new VariableCreatedHistoryJsonTransformer());
        historyJsonTransformers.add(new VariableUpdatedHistoryJsonTransformer());
        historyJsonTransformers.add(new VariableRemovedHistoryJsonTransformer());
        historyJsonTransformers.add(new HistoricDetailVariableUpdateHistoryJsonTransformer());
        historyJsonTransformers.add(new FormPropertiesSubmittedHistoryJsonTransformer());

        historyJsonTransformers.add(new HistoricUserTaskLogRecordJsonTransformer());
        historyJsonTransformers.add(new HistoricUserTaskLogDeleteJsonTransformer());
        return historyJsonTransformers;
    }

    // async executor
    // /////////////////////////////////////////////////////////////

    public void initAsyncExecutor() {
        if (asyncExecutor is null) {
            DefaultAsyncJobExecutor defaultAsyncExecutor = new DefaultAsyncJobExecutor();
            if (asyncExecutorExecuteAsyncRunnableFactory !is null) {
                defaultAsyncExecutor.setExecuteAsyncRunnableFactory(asyncExecutorExecuteAsyncRunnableFactory);
            }

            // Message queue mode
            defaultAsyncExecutor.setMessageQueueMode(asyncExecutorMessageQueueMode);

            // Thread pool config
            defaultAsyncExecutor.setCorePoolSize(asyncExecutorCorePoolSize);
            defaultAsyncExecutor.setMaxPoolSize(asyncExecutorMaxPoolSize);
            defaultAsyncExecutor.setKeepAliveTime(asyncExecutorThreadKeepAliveTime);

            // Threadpool queue
            if (asyncExecutorThreadPoolQueue !is null) {
                defaultAsyncExecutor.setThreadPoolQueue(asyncExecutorThreadPoolQueue);
            }
            defaultAsyncExecutor.setQueueSize(asyncExecutorThreadPoolQueueSize);

            // Thread flags
            defaultAsyncExecutor.setAsyncJobAcquisitionEnabled(isAsyncExecutorAsyncJobAcquisitionEnabled);
            defaultAsyncExecutor.setTimerJobAcquisitionEnabled(isAsyncExecutorTimerJobAcquisitionEnabled);
            defaultAsyncExecutor.setResetExpiredJobEnabled(isAsyncExecutorResetExpiredJobsEnabled);

            // Acquisition wait time
            defaultAsyncExecutor.setDefaultTimerJobAcquireWaitTimeInMillis(asyncExecutorDefaultTimerJobAcquireWaitTime);
            defaultAsyncExecutor.setDefaultAsyncJobAcquireWaitTimeInMillis(asyncExecutorDefaultAsyncJobAcquireWaitTime);

            // Queue full wait time
            defaultAsyncExecutor.setDefaultQueueSizeFullWaitTimeInMillis(asyncExecutorDefaultQueueSizeFullWaitTime);

            // Job locking
            defaultAsyncExecutor.setTimerLockTimeInMillis(asyncExecutorTimerLockTimeInMillis);
            defaultAsyncExecutor.setAsyncJobLockTimeInMillis(asyncExecutorAsyncJobLockTimeInMillis);
            if (asyncExecutorLockOwner !is null) {
                defaultAsyncExecutor.setLockOwner(asyncExecutorLockOwner);
            }

            // Reset expired
            defaultAsyncExecutor.setResetExpiredJobsInterval(asyncExecutorResetExpiredJobsInterval);
            defaultAsyncExecutor.setResetExpiredJobsPageSize(asyncExecutorResetExpiredJobsPageSize);

            // Core thread timeout
            defaultAsyncExecutor.setAllowCoreThreadTimeout(asyncExecutorAllowCoreThreadTimeout);

            // Shutdown
            defaultAsyncExecutor.setSecondsToWaitOnShutdown(asyncExecutorSecondsToWaitOnShutdown);

            // Tenant
            defaultAsyncExecutor.setTenantId(asyncExecutorTenantId);

            asyncExecutor = defaultAsyncExecutor;
        }

        asyncExecutor.setJobServiceConfiguration(jobServiceConfiguration);
        asyncExecutor.setAutoActivate(asyncExecutorActivate);
        jobServiceConfiguration.setAsyncExecutor(asyncExecutor);
    }

    public void initAsyncHistoryExecutor() {
        if (isAsyncHistoryEnabled) {
            if (asyncHistoryExecutor is null) {
                DefaultAsyncHistoryJobExecutor defaultAsyncHistoryExecutor = new DefaultAsyncHistoryJobExecutor();

                // Message queue mode
                defaultAsyncHistoryExecutor.setMessageQueueMode(asyncHistoryExecutorMessageQueueMode);

                // Thread pool config
                defaultAsyncHistoryExecutor.setCorePoolSize(asyncHistoryExecutorCorePoolSize);
                defaultAsyncHistoryExecutor.setMaxPoolSize(asyncHistoryExecutorMaxPoolSize);
                defaultAsyncHistoryExecutor.setKeepAliveTime(asyncHistoryExecutorThreadKeepAliveTime);

                // Threadpool queue
                if (asyncHistoryExecutorThreadPoolQueue !is null) {
                    defaultAsyncHistoryExecutor.setThreadPoolQueue(asyncHistoryExecutorThreadPoolQueue);
                }
                defaultAsyncHistoryExecutor.setQueueSize(asyncHistoryExecutorThreadPoolQueueSize);

                // Thread flags
                defaultAsyncHistoryExecutor.setAsyncJobAcquisitionEnabled(isAsyncHistoryExecutorAsyncJobAcquisitionEnabled);
                defaultAsyncHistoryExecutor.setTimerJobAcquisitionEnabled(isAsyncHistoryExecutorTimerJobAcquisitionEnabled);
                defaultAsyncHistoryExecutor.setResetExpiredJobEnabled(isAsyncHistoryExecutorResetExpiredJobsEnabled);

                // Acquisition wait time
                defaultAsyncHistoryExecutor.setDefaultAsyncJobAcquireWaitTimeInMillis(asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime);

                // Queue full wait time
                defaultAsyncHistoryExecutor.setDefaultQueueSizeFullWaitTimeInMillis(asyncHistoryExecutorDefaultQueueSizeFullWaitTime);

                // Job locking
                defaultAsyncHistoryExecutor.setAsyncJobLockTimeInMillis(asyncHistoryExecutorAsyncJobLockTimeInMillis);
                if (asyncHistoryExecutorLockOwner !is null) {
                    defaultAsyncHistoryExecutor.setLockOwner(asyncHistoryExecutorLockOwner);
                }

                // Reset expired
                defaultAsyncHistoryExecutor.setResetExpiredJobsInterval(asyncHistoryExecutorResetExpiredJobsInterval);
                defaultAsyncHistoryExecutor.setResetExpiredJobsPageSize(asyncHistoryExecutorResetExpiredJobsPageSize);

                // Shutdown
                defaultAsyncHistoryExecutor.setSecondsToWaitOnShutdown(asyncHistoryExecutorSecondsToWaitOnShutdown);

                asyncHistoryExecutor = defaultAsyncHistoryExecutor;

                if (asyncHistoryExecutor.getJobServiceConfiguration() is null) {
                    asyncHistoryExecutor.setJobServiceConfiguration(jobServiceConfiguration);
                }
                asyncHistoryExecutor.setAutoActivate(asyncHistoryExecutorActivate);

            } else {
                // In case an async history executor was injected, only the job handlers are set.
                // In the normal case, these are set on the jobServiceConfiguration, but these are not shared between instances
                if (historyJobHandlers !is null) {
                    if (asyncHistoryExecutor.getJobServiceConfiguration() is null) {
                        asyncHistoryExecutor.setJobServiceConfiguration(jobServiceConfiguration);
                    }
                    historyJobHandlers.forEach((type, handler) -> {
                        asyncHistoryExecutor.getJobServiceConfiguration().mergeHistoryJobHandler(handler);
                    });
                }

            }

        }

        if (asyncHistoryExecutor !is null) {
            jobServiceConfiguration.setAsyncHistoryExecutor(asyncHistoryExecutor);
            jobServiceConfiguration.setAsyncHistoryExecutorNumberOfRetries(asyncHistoryExecutorNumberOfRetries);
        }
    }

    // history
    // //////////////////////////////////////////////////////////////////

    public void initHistoryLevel() {
        if (historyLevel is null) {
            historyLevel = HistoryLevel.getHistoryLevelForKey(getHistory());
        }
    }

    // id generator
    // /////////////////////////////////////////////////////////////

    override
    public void initIdGenerator() {
        if (idGenerator is null) {
            DbIdGenerator dbIdGenerator = new DbIdGenerator();
            dbIdGenerator.setIdBlockSize(idBlockSize);
            idGenerator = dbIdGenerator;
        }

        if (idGenerator instanceof DbIdGenerator) {
            DbIdGenerator dbIdGenerator = (DbIdGenerator) idGenerator;
            if (dbIdGenerator.getIdBlockSize() == 0) {
                dbIdGenerator.setIdBlockSize(idBlockSize);
            }
            if (dbIdGenerator.getCommandExecutor() is null) {
                dbIdGenerator.setCommandExecutor(getCommandExecutor());
            }
            if (dbIdGenerator.getCommandConfig() is null) {
                dbIdGenerator.setCommandConfig(getDefaultCommandConfig().transactionRequiresNew());
            }
        }
    }

    // OTHER
    // ////////////////////////////////////////////////////////////////////

    override
    public void initTransactionFactory() {
        if (transactionFactory is null) {
            if (transactionsExternallyManaged) {
                transactionFactory = new ManagedTransactionFactory();
            } else {
                transactionFactory = new JdbcTransactionFactory();
            }
        }
    }

    public void initHelpers() {
        if (processInstanceHelper is null) {
            processInstanceHelper = new ProcessInstanceHelper();
        }
        if (listenerNotificationHelper is null) {
            listenerNotificationHelper = new ListenerNotificationHelper();
        }
        if (formHandlerHelper is null) {
            formHandlerHelper = new FormHandlerHelper();
        }
    }

    public void initVariableTypes() {
        if (variableTypes is null) {
            variableTypes = new DefaultVariableTypes();
            if (customPreVariableTypes !is null) {
                for (VariableType customVariableType : customPreVariableTypes) {
                    variableTypes.addType(customVariableType);
                }
            }
            variableTypes.addType(new NullType());
            variableTypes.addType(new StringType(getMaxLengthString()));
            variableTypes.addType(new LongStringType(getMaxLengthString() + 1));
            variableTypes.addType(new BooleanType());
            variableTypes.addType(new ShortType());
            variableTypes.addType(new IntegerType());
            variableTypes.addType(new LongType());
            variableTypes.addType(new DateType());
            variableTypes.addType(new InstantType());
            variableTypes.addType(new LocalDateType());
            variableTypes.addType(new LocalDateTimeType());
            variableTypes.addType(new JodaDateType());
            variableTypes.addType(new JodaDateTimeType());
            variableTypes.addType(new DoubleType());
            variableTypes.addType(new UUIDType());
            variableTypes.addType(new JsonType(getMaxLengthString(), objectMapper));
            variableTypes.addType(new LongJsonType(getMaxLengthString() + 1, objectMapper));
            variableTypes.addType(new ByteArrayType());
            variableTypes.addType(new SerializableType(serializableVariableTypeTrackDeserializedObjects));
            if (customPostVariableTypes !is null) {
                for (VariableType customVariableType : customPostVariableTypes) {
                    variableTypes.addType(customVariableType);
                }
            }
        }
    }

    public void initFormEngines() {
        if (formEngines is null) {
            formEngines = new HashMap<>();
            FormEngine defaultFormEngine = new JuelFormEngine();
            formEngines.put(null, defaultFormEngine); // default form engine is
            // looked up with null
            formEngines.put(defaultFormEngine.getName(), defaultFormEngine);
        }
        if (customFormEngines !is null) {
            for (FormEngine formEngine : customFormEngines) {
                formEngines.put(formEngine.getName(), formEngine);
            }
        }
    }

    public void initFormTypes() {
        if (formTypes is null) {
            formTypes = new FormTypes();
            formTypes.addFormType(new StringFormType());
            formTypes.addFormType(new LongFormType());
            formTypes.addFormType(new DateFormType("dd/MM/yyyy"));
            formTypes.addFormType(new BooleanFormType());
            formTypes.addFormType(new DoubleFormType());
        }
        if (customFormTypes !is null) {
            for (AbstractFormType customFormType : customFormTypes) {
                formTypes.addFormType(customFormType);
            }
        }
    }

    public void initScriptingEngines() {
        if (resolverFactories is null) {
            resolverFactories = new ArrayList<>();
            resolverFactories.add(new VariableScopeResolverFactory());
            resolverFactories.add(new BeansResolverFactory());
        }
        if (scriptingEngines is null) {
            scriptingEngines = new ScriptingEngines(new ScriptBindingsFactory(this, resolverFactories));
        }
    }

    public void initExpressionManager() {
        if (expressionManager is null) {
            ProcessExpressionManager processExpressionManager = new ProcessExpressionManager(delegateInterceptor, beans);

            if (isExpressionCacheEnabled) {
                processExpressionManager.setExpressionCache(new DefaultDeploymentCache<>(expressionCacheSize));
                processExpressionManager.setExpressionTextLengthCacheLimit(expressionTextLengthCacheLimit);
            }

            expressionManager = processExpressionManager;
        }
        expressionManager.setFunctionDelegates(flowableFunctionDelegates);
        expressionManager.setExpressionEnhancers(expressionEnhancers);
    }

    public void initBusinessCalendarManager() {
        if (businessCalendarManager is null) {
            MapBusinessCalendarManager mapBusinessCalendarManager = new MapBusinessCalendarManager();
            mapBusinessCalendarManager.addBusinessCalendar(DurationBusinessCalendar.NAME, new DurationBusinessCalendar(this.clock));
            mapBusinessCalendarManager.addBusinessCalendar(DueDateBusinessCalendar.NAME, new DueDateBusinessCalendar(this.clock));
            mapBusinessCalendarManager.addBusinessCalendar(CycleBusinessCalendar.NAME, new CycleBusinessCalendar(this.clock));

            businessCalendarManager = mapBusinessCalendarManager;
        }
    }

    public void initAgendaFactory() {
        if (this.agendaFactory is null) {
            this.agendaFactory = new DefaultFlowableEngineAgendaFactory();
        }
    }

    public void initDelegateInterceptor() {
        if (delegateInterceptor is null) {
            delegateInterceptor = new DefaultDelegateInterceptor();
        }
    }

    public void initEventHandlers() {
        if (eventHandlers is null) {
            eventHandlers = new HashMap<>();

            SignalEventHandler signalEventHandler = new SignalEventHandler();
            eventHandlers.put(signalEventHandler.getEventHandlerType(), signalEventHandler);

            CompensationEventHandler compensationEventHandler = new CompensationEventHandler();
            eventHandlers.put(compensationEventHandler.getEventHandlerType(), compensationEventHandler);

            MessageEventHandler messageEventHandler = new MessageEventHandler();
            eventHandlers.put(messageEventHandler.getEventHandlerType(), messageEventHandler);

        }
        if (customEventHandlers !is null) {
            for (EventHandler eventHandler : customEventHandlers) {
                eventHandlers.put(eventHandler.getEventHandlerType(), eventHandler);
            }
        }
    }

    // JPA
    // //////////////////////////////////////////////////////////////////////

    public void initJpa() {
        if (jpaPersistenceUnitName !is null) {
            jpaEntityManagerFactory = JpaHelper.createEntityManagerFactory(jpaPersistenceUnitName);
        }
        if (jpaEntityManagerFactory !is null) {
            sessionFactories.put(EntityManagerSession.class, new EntityManagerSessionFactory(jpaEntityManagerFactory, jpaHandleTransaction, jpaCloseEntityManager));
            VariableType jpaType = variableTypes.getVariableType(JPAEntityVariableType.TYPE_NAME);
            // Add JPA-type
            if (jpaType is null) {
                // We try adding the variable right before SerializableType, if
                // available
                int serializableIndex = variableTypes.getTypeIndex(SerializableType.TYPE_NAME);
                if (serializableIndex > -1) {
                    variableTypes.addType(new JPAEntityVariableType(), serializableIndex);
                } else {
                    variableTypes.addType(new JPAEntityVariableType());
                }
            }

            jpaType = variableTypes.getVariableType(JPAEntityListVariableType.TYPE_NAME);

            // Add JPA-list type after regular JPA type if not already present
            if (jpaType is null) {
                variableTypes.addType(new JPAEntityListVariableType(), variableTypes.getTypeIndex(JPAEntityVariableType.TYPE_NAME));
            }
        }
    }

    public void initProcessValidator() {
        if (this.processValidator is null) {
            this.processValidator = new ProcessValidatorFactory().createDefaultProcessValidator();
        }
    }

    override
    protected void initAdditionalEventDispatchActions() {
        if (this.additionalEventDispatchActions is null) {
            this.additionalEventDispatchActions = new ArrayList<>();
            this.additionalEventDispatchActions.add(new BpmnModelEventDispatchAction());
        }
    }

    public void initFormFieldHandler() {
        if (this.formFieldHandler is null) {
            this.formFieldHandler = new DefaultFormFieldHandler();
        }
    }

    public void initShortHandExpressionFunctions() {
        if (shortHandExpressionFunctions is null) {
            shortHandExpressionFunctions = new ArrayList<>();

            shortHandExpressionFunctions.add(new VariableGetExpressionFunction());
            shortHandExpressionFunctions.add(new VariableGetOrDefaultExpressionFunction());

            shortHandExpressionFunctions.add(new VariableContainsAnyExpressionFunction());
            shortHandExpressionFunctions.add(new VariableContainsExpressionFunction());

            shortHandExpressionFunctions.add(new VariableEqualsExpressionFunction());
            shortHandExpressionFunctions.add(new VariableNotEqualsExpressionFunction());

            shortHandExpressionFunctions.add(new VariableExistsExpressionFunction());
            shortHandExpressionFunctions.add(new VariableIsEmptyExpressionFunction());
            shortHandExpressionFunctions.add(new VariableIsNotEmptyExpressionFunction());

            shortHandExpressionFunctions.add(new VariableLowerThanExpressionFunction());
            shortHandExpressionFunctions.add(new VariableLowerThanOrEqualsExpressionFunction());
            shortHandExpressionFunctions.add(new VariableGreaterThanExpressionFunction());
            shortHandExpressionFunctions.add(new VariableGreaterThanOrEqualsExpressionFunction());

            shortHandExpressionFunctions.add(new VariableBase64ExpressionFunction());
        }
    }

    public void initFunctionDelegates() {
        if (this.flowableFunctionDelegates is null) {
            this.flowableFunctionDelegates = new ArrayList<>();
            this.flowableFunctionDelegates.add(new FlowableDateFunctionDelegate());
            flowableFunctionDelegates.addAll(shortHandExpressionFunctions);
        }

        if (this.customFlowableFunctionDelegates !is null) {
            this.flowableFunctionDelegates.addAll(this.customFlowableFunctionDelegates);
        }
    }

    public void initExpressionEnhancers() {
        if (expressionEnhancers is null) {
            expressionEnhancers = new ArrayList<>();
            expressionEnhancers.addAll(shortHandExpressionFunctions);
        }

        if (customExpressionEnhancers !is null) {
            expressionEnhancers.addAll(customExpressionEnhancers);
        }
    }

    public void initDatabaseEventLogging() {
        if (enableDatabaseEventLogging) {
            // Database event logging uses the default logging mechanism and adds
            // a specific event listener to the list of event listeners
            getEventDispatcher().addEventListener(new EventLogger(clock, objectMapper));
        }
    }

    public void initFlowable5CompatibilityHandler() {

        // If Flowable 5 compatibility is disabled, no need to do anything
        // If handler is injected, no need to do anything
        if (flowable5CompatibilityEnabled && flowable5CompatibilityHandler is null) {

            // Create default factory if nothing set
            if (flowable5CompatibilityHandlerFactory is null) {
                flowable5CompatibilityHandlerFactory = new DefaultFlowable5CompatibilityHandlerFactory();
            }

            // Create handler instance
            flowable5CompatibilityHandler = flowable5CompatibilityHandlerFactory.createFlowable5CompatibilityHandler();

            if (flowable5CompatibilityHandler !is null) {
                logger.info("Found compatibility handler instance : {}", flowable5CompatibilityHandler.getClass());

                flowable5CompatibilityHandler.setFlowable6ProcessEngineConfiguration(this);
            }
        }

    }

    /**
     * Called when the {@link ProcessEngine} is initialized, but before it is returned
     */
    protected void postProcessEngineInitialisation() {
        if (validateFlowable5EntitiesEnabled) {
            commandExecutor.execute(new ValidateV5EntitiesCmd());
        }

        if (redeployFlowable5ProcessDefinitions) {
            commandExecutor.execute(new RedeployV5ProcessDefinitionsCmd());
        }

        if (performanceSettings.isValidateExecutionRelationshipCountConfigOnBoot()) {
            commandExecutor.execute(new ValidateExecutionRelatedEntityCountCfgCmd());
        }

        if (performanceSettings.isValidateTaskRelationshipCountConfigOnBoot()) {
            commandExecutor.execute(new ValidateTaskRelatedEntityCountCfgCmd());
        }

        // if Flowable 5 support is needed configure the Flowable 5 job processors via the compatibility handler
        if (flowable5CompatibilityEnabled) {
            flowable5CompatibilityHandler.setJobProcessor(this.flowable5JobProcessors);
        }
    }

    public Runnable getProcessEngineCloseRunnable() {
        return new class Runnable {
             void run() {
                commandExecutor.execute(getSchemaCommandConfig(), new SchemaOperationProcessEngineClose());
            }
        }
    }

    override
    protected List!EngineConfigurator getEngineSpecificEngineConfigurators() {
        if (!disableIdmEngine || !disableEventRegistry) {

            List!EngineConfigurator specificConfigurators = new ArrayList!EngineConfigurator();

           if (!disableEventRegistry) {
                if (eventRegistryConfiurator !is null) {
                    specificConfigurators.add(eventRegistryConfigurator);
                    } else {
                    specificConfigurators.add(new EventRegistryEngineConfigurator());
                }
            }
            if (!disableIdmEngine) {
                if (idmEngineConfigurator !is null) {
                    specificConfigurators.add(idmEngineConfigurator);
                } else {
                    specificConfigurators.add(new IdmEngineConfigurator());
                }
            }

            return specificConfigurators;
        }
        return Collections.emptyList();
    }

    override
    public ProcessEngineConfigurationImpl addConfigurator(EngineConfigurator configurator) {
        super.addConfigurator(configurator);
        return this;
    }

    public void initLocalizationManagers() {
        if (this.internalProcessLocalizationManager is null) {
            this.setInternalProcessLocalizationManager(new DefaultProcessLocalizationManager(this));
        }

        if(this.internalProcessDefinitionLocalizationManager is null) {
            this.setInternalProcessDefinitionLocalizationManager(new DefaultProcessDefinitionLocalizationManager(this));
        }

    }

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public ProcessEngineConfigurationImpl setEngineName(string processEngineName) {
        this.processEngineName = processEngineName;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setDatabaseSchemaUpdate(string databaseSchemaUpdate) {
        this.databaseSchemaUpdate = databaseSchemaUpdate;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setJdbcUrl(string jdbcUrl) {
        this.jdbcUrl = jdbcUrl;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setDefaultCommandConfig(CommandConfig defaultCommandConfig) {
        this.defaultCommandConfig = defaultCommandConfig;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setSchemaCommandConfig(CommandConfig schemaCommandConfig) {
        this.schemaCommandConfig = schemaCommandConfig;
        return this;
    }

    override
    public List<CommandInterceptor> getCustomPreCommandInterceptors() {
        return customPreCommandInterceptors;
    }

    override
    public ProcessEngineConfigurationImpl setCustomPreCommandInterceptors(List<CommandInterceptor> customPreCommandInterceptors) {
        this.customPreCommandInterceptors = customPreCommandInterceptors;
        return this;
    }

    override
    public List<CommandInterceptor> getCustomPostCommandInterceptors() {
        return customPostCommandInterceptors;
    }

    override
    public ProcessEngineConfigurationImpl setCustomPostCommandInterceptors(List<CommandInterceptor> customPostCommandInterceptors) {
        this.customPostCommandInterceptors = customPostCommandInterceptors;
        return this;
    }

    override
    public List<CommandInterceptor> getCommandInterceptors() {
        return commandInterceptors;
    }

    override
    public ProcessEngineConfigurationImpl setCommandInterceptors(List<CommandInterceptor> commandInterceptors) {
        this.commandInterceptors = commandInterceptors;
        return this;
    }

    override
    public RepositoryService getRepositoryService() {
        return repositoryService;
    }

    public ProcessEngineConfigurationImpl setRepositoryService(RepositoryService repositoryService) {
        this.repositoryService = repositoryService;
        return this;
    }

    override
    public RuntimeService getRuntimeService() {
        return runtimeService;
    }

    public ProcessEngineConfigurationImpl setRuntimeService(RuntimeService runtimeService) {
        this.runtimeService = runtimeService;
        return this;
    }

    override
    public HistoryService getHistoryService() {
        return historyService;
    }

    public ProcessEngineConfigurationImpl setHistoryService(HistoryService historyService) {
        this.historyService = historyService;
        return this;
    }

    override
    public IdentityService getIdentityService() {
        return identityService;
    }

    public ProcessEngineConfigurationImpl setIdentityService(IdentityService identityService) {
        this.identityService = identityService;
        return this;
    }

    override
    public TaskService getTaskService() {
        return taskService;
    }

    public ProcessEngineConfigurationImpl setTaskService(TaskService taskService) {
        this.taskService = taskService;
        return this;
    }

    override
    public FormService getFormService() {
        return formService;
    }

    public ProcessEngineConfigurationImpl setFormService(FormService formService) {
        this.formService = formService;
        return this;
    }

    override
    public ManagementService getManagementService() {
        return managementService;
    }

    public ProcessEngineConfigurationImpl setManagementService(ManagementService managementService) {
        this.managementService = managementService;
        return this;
    }

    public DynamicBpmnService getDynamicBpmnService() {
        return dynamicBpmnService;
    }

    public ProcessEngineConfigurationImpl setDynamicBpmnService(DynamicBpmnService dynamicBpmnService) {
        this.dynamicBpmnService = dynamicBpmnService;
        return this;
    }

    public ProcessMigrationService getProcessMigrationService() {
        return processInstanceMigrationService;
    }

    public void setProcessInstanceMigrationService(ProcessMigrationService processInstanceMigrationService) {
        this.processInstanceMigrationService = processInstanceMigrationService;
    }

    override
    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return this;
    }

    public bool isDisableIdmEngine() {
        return disableIdmEngine;
    }

    public ProcessEngineConfigurationImpl setDisableIdmEngine(bool disableIdmEngine) {
        this.disableIdmEngine = disableIdmEngine;
        return this;
    }

    public bool isDisableEventRegistry() {
        return disableEventRegistry;
    }

    public ProcessEngineConfigurationImpl setDisableEventRegistry(bool disableEventRegistry) {
        this.disableEventRegistry = disableEventRegistry;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setSessionFactories(Map<Class<?>, SessionFactory> sessionFactories) {
        this.sessionFactories = sessionFactories;
        return this;
    }

    public BpmnDeployer getBpmnDeployer() {
        return bpmnDeployer;
    }

    public ProcessEngineConfigurationImpl setBpmnDeployer(BpmnDeployer bpmnDeployer) {
        this.bpmnDeployer = bpmnDeployer;
        return this;
    }

    public BpmnParser getBpmnParser() {
        return bpmnParser;
    }

    public ProcessEngineConfigurationImpl setBpmnParser(BpmnParser bpmnParser) {
        this.bpmnParser = bpmnParser;
        return this;
    }

    public ParsedDeploymentBuilderFactory getParsedDeploymentBuilderFactory() {
        return parsedDeploymentBuilderFactory;
    }

    public ProcessEngineConfigurationImpl setParsedDeploymentBuilderFactory(ParsedDeploymentBuilderFactory parsedDeploymentBuilderFactory) {
        this.parsedDeploymentBuilderFactory = parsedDeploymentBuilderFactory;
        return this;
    }

    public TimerManager getTimerManager() {
        return timerManager;
    }

    public void setTimerManager(TimerManager timerManager) {
        this.timerManager = timerManager;
    }

    public EventSubscriptionManager getEventSubscriptionManager() {
        return eventSubscriptionManager;
    }

    public void setEventSubscriptionManager(EventSubscriptionManager eventSubscriptionManager) {
        this.eventSubscriptionManager = eventSubscriptionManager;
    }

    public BpmnDeploymentHelper getBpmnDeploymentHelper() {
        return bpmnDeploymentHelper;
    }

    public ProcessEngineConfigurationImpl setBpmnDeploymentHelper(BpmnDeploymentHelper bpmnDeploymentHelper) {
        this.bpmnDeploymentHelper = bpmnDeploymentHelper;
        return this;
    }

    public CachingAndArtifactsManager getCachingAndArtifactsManager() {
        return cachingAndArtifactsManager;
    }

    public void setCachingAndArtifactsManager(CachingAndArtifactsManager cachingAndArtifactsManager) {
        this.cachingAndArtifactsManager = cachingAndArtifactsManager;
    }

    public ProcessDefinitionDiagramHelper getProcessDefinitionDiagramHelper() {
        return processDefinitionDiagramHelper;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionDiagramHelper(ProcessDefinitionDiagramHelper processDefinitionDiagramHelper) {
        this.processDefinitionDiagramHelper = processDefinitionDiagramHelper;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setIdGenerator(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
        return this;
    }

    public string getWsSyncFactoryClassName() {
        return wsSyncFactoryClassName;
    }

    public ProcessEngineConfigurationImpl setWsSyncFactoryClassName(string wsSyncFactoryClassName) {
        this.wsSyncFactoryClassName = wsSyncFactoryClassName;
        return this;
    }

    public XMLImporterFactory getWsdlImporterFactory() {
        return wsWsdlImporterFactory;
    }

    public ProcessEngineConfigurationImpl setWsdlImporterFactory(XMLImporterFactory wsWsdlImporterFactory) {
        this.wsWsdlImporterFactory = wsWsdlImporterFactory;
        return this;
    }

    /**
     * Add or replace the address of the given web-service endpoint with the given value
     *
     * @param endpointName
     *     The endpoint name for which a new address must be set
     * @param address
     *     The new address of the endpoint
     */
    public ProcessEngineConfiguration addWsEndpointAddress(QName endpointName, URL address) {
        this.wsOverridenEndpointAddresses.put(endpointName, address);
        return this;
    }

    /**
     * Remove the address definition of the given web-service endpoint
     *
     * @param endpointName
     *     The endpoint name for which the address definition must be removed
     */
    public ProcessEngineConfiguration removeWsEndpointAddress(QName endpointName) {
        this.wsOverridenEndpointAddresses.remove(endpointName);
        return this;
    }

    public ConcurrentMap<QName, URL> getWsOverridenEndpointAddresses() {
        return this.wsOverridenEndpointAddresses;
    }

    public ProcessEngineConfiguration setWsOverridenEndpointAddresses( ConcurrentMap<QName, URL> wsOverridenEndpointAddress) {
        this.wsOverridenEndpointAddresses.putAll(wsOverridenEndpointAddress);
        return this;
    }

    public Map!(string, FormEngine) getFormEngines() {
        return formEngines;
    }

    public ProcessEngineConfigurationImpl setFormEngines(Map!(string, FormEngine) formEngines) {
        this.formEngines = formEngines;
        return this;
    }

    public FormTypes getFormTypes() {
        return formTypes;
    }

    public ProcessEngineConfigurationImpl setFormTypes(FormTypes formTypes) {
        this.formTypes = formTypes;
        return this;
    }

    override
    public ScriptingEngines getScriptingEngines() {
        return scriptingEngines;
    }

    override
    public ProcessEngineConfigurationImpl setScriptingEngines(ScriptingEngines scriptingEngines) {
        this.scriptingEngines = scriptingEngines;
        return this;
    }

    override
    public VariableTypes getVariableTypes() {
        return variableTypes;
    }

    override
    public ProcessEngineConfigurationImpl setVariableTypes(VariableTypes variableTypes) {
        this.variableTypes = variableTypes;
        return this;
    }

    public InternalHistoryVariableManager getInternalHistoryVariableManager() {
        return internalHistoryVariableManager;
    }

    public ProcessEngineConfigurationImpl setInternalHistoryVariableManager(InternalHistoryVariableManager internalHistoryVariableManager) {
        this.internalHistoryVariableManager = internalHistoryVariableManager;
        return this;
    }

    public InternalTaskVariableScopeResolver getInternalTaskVariableScopeResolver() {
        return internalTaskVariableScopeResolver;
    }

    public ProcessEngineConfigurationImpl setInternalTaskVariableScopeResolver(InternalTaskVariableScopeResolver internalTaskVariableScopeResolver) {
        this.internalTaskVariableScopeResolver = internalTaskVariableScopeResolver;
        return this;
    }

    public InternalHistoryTaskManager getInternalHistoryTaskManager() {
        return internalHistoryTaskManager;
    }

    public ProcessEngineConfigurationImpl setInternalHistoryTaskManager(InternalHistoryTaskManager internalHistoryTaskManager) {
        this.internalHistoryTaskManager = internalHistoryTaskManager;
        return this;
    }

    public InternalTaskAssignmentManager getInternalTaskAssignmentManager() {
        return internalTaskAssignmentManager;
    }

    public ProcessEngineConfigurationImpl setInternalTaskAssignmentManager(InternalTaskAssignmentManager internalTaskAssignmentManager) {
        this.internalTaskAssignmentManager = internalTaskAssignmentManager;
        return this;
    }

    public IdentityLinkEventHandler getIdentityLinkEventHandler() {
        return identityLinkEventHandler;
    }

    public ProcessEngineConfigurationImpl setIdentityLinkEventHandler(IdentityLinkEventHandler identityLinkEventHandler) {
        this.identityLinkEventHandler = identityLinkEventHandler;
        return this;
    }

    public InternalTaskLocalizationManager getInternalTaskLocalizationManager() {
        return internalTaskLocalizationManager;
    }

    public ProcessEngineConfigurationImpl setInternalTaskLocalizationManager(InternalTaskLocalizationManager internalTaskLocalizationManager) {
        this.internalTaskLocalizationManager = internalTaskLocalizationManager;
        return this;
    }

    public InternalProcessLocalizationManager getInternalProcessLocalizationManager() {
        return internalProcessLocalizationManager;
    }

    public ProcessEngineConfigurationImpl setInternalProcessLocalizationManager(InternalProcessLocalizationManager internalProcessLocalizationManager) {
        this.internalProcessLocalizationManager = internalProcessLocalizationManager;
        return this;
    }

    public InternalProcessDefinitionLocalizationManager getInternalProcessDefinitionLocalizationManager() {
        return internalProcessDefinitionLocalizationManager;
    }

    public ProcessEngineConfigurationImpl setInternalProcessDefinitionLocalizationManager(InternalProcessDefinitionLocalizationManager internalProcessDefinitionLocalizationManager) {
        this.internalProcessDefinitionLocalizationManager = internalProcessDefinitionLocalizationManager;
        return this;
    }

    public InternalJobManager getInternalJobManager() {
        return internalJobManager;
    }

    public ProcessEngineConfigurationImpl setInternalJobManager(InternalJobManager internalJobManager) {
        this.internalJobManager = internalJobManager;
        return this;
    }

    public InternalJobCompatibilityManager getInternalJobCompatibilityManager() {
        return internalJobCompatibilityManager;
    }

    public ProcessEngineConfigurationImpl setInternalJobCompatibilityManager(InternalJobCompatibilityManager internalJobCompatibilityManager) {
        this.internalJobCompatibilityManager = internalJobCompatibilityManager;
        return this;
    }

    public bool isSerializableVariableTypeTrackDeserializedObjects() {
        return serializableVariableTypeTrackDeserializedObjects;
    }

    public void setSerializableVariableTypeTrackDeserializedObjects(bool serializableVariableTypeTrackDeserializedObjects) {
        this.serializableVariableTypeTrackDeserializedObjects = serializableVariableTypeTrackDeserializedObjects;
    }

    override
    public ExpressionManager getExpressionManager() {
        return expressionManager;
    }

    override
    public ProcessEngineConfigurationImpl setExpressionManager(ExpressionManager expressionManager) {
        this.expressionManager = expressionManager;
        return this;
    }

    public bool isExpressionCacheEnabled() {
        return isExpressionCacheEnabled;
    }

    public ProcessEngineConfigurationImpl setExpressionCacheEnabled(bool isExpressionCacheEnabled) {
        this.isExpressionCacheEnabled = isExpressionCacheEnabled;
        return this;
    }

    public int getExpressionCacheSize() {
        return expressionCacheSize;
    }

    public ProcessEngineConfigurationImpl setExpressionCacheSize(int expressionCacheSize) {
        this.expressionCacheSize = expressionCacheSize;
        return this;
    }

    public int getExpressionTextLengthCacheLimit() {
        return expressionTextLengthCacheLimit;
    }

    public ProcessEngineConfigurationImpl setExpressionTextLengthCacheLimit(int expressionTextLengthCacheLimit) {
        this.expressionTextLengthCacheLimit = expressionTextLengthCacheLimit;
        return this;
    }

    public BusinessCalendarManager getBusinessCalendarManager() {
        return businessCalendarManager;
    }

    public ProcessEngineConfigurationImpl setBusinessCalendarManager(BusinessCalendarManager businessCalendarManager) {
        this.businessCalendarManager = businessCalendarManager;
        return this;
    }

    public StartProcessInstanceInterceptor getStartProcessInstanceInterceptor() {
        return startProcessInstanceInterceptor;
    }

    public ProcessEngineConfigurationImpl setStartProcessInstanceInterceptor(StartProcessInstanceInterceptor startProcessInstanceInterceptor) {
        this.startProcessInstanceInterceptor = startProcessInstanceInterceptor;
        return this;
    }

    public CreateUserTaskInterceptor getCreateUserTaskInterceptor() {
        return createUserTaskInterceptor;
    }

    public ProcessEngineConfigurationImpl setCreateUserTaskInterceptor(CreateUserTaskInterceptor createUserTaskInterceptor) {
        this.createUserTaskInterceptor = createUserTaskInterceptor;
        return this;
    }

    public ProcessInstanceQueryInterceptor getProcessInstanceQueryInterceptor() {
        return processInstanceQueryInterceptor;
    }

    public ProcessEngineConfigurationImpl setProcessInstanceQueryInterceptor(ProcessInstanceQueryInterceptor processInstanceQueryInterceptor) {
        this.processInstanceQueryInterceptor = processInstanceQueryInterceptor;
        return this;
    }

    public ExecutionQueryInterceptor getExecutionQueryInterceptor() {
        return executionQueryInterceptor;
    }

    public ProcessEngineConfigurationImpl setExecutionQueryInterceptor(ExecutionQueryInterceptor executionQueryInterceptor) {
        this.executionQueryInterceptor = executionQueryInterceptor;
        return this;
    }

    public HistoricProcessInstanceQueryInterceptor getHistoricProcessInstanceQueryInterceptor() {
        return historicProcessInstanceQueryInterceptor;
    }

    public ProcessEngineConfigurationImpl setHistoricProcessInstanceQueryInterceptor(HistoricProcessInstanceQueryInterceptor historicProcessInstanceQueryInterceptor) {
        this.historicProcessInstanceQueryInterceptor = historicProcessInstanceQueryInterceptor;
        return this;
    }

    public TaskQueryInterceptor getTaskQueryInterceptor() {
        return taskQueryInterceptor;
    }

    public ProcessEngineConfigurationImpl setTaskQueryInterceptor(TaskQueryInterceptor taskQueryInterceptor) {
        this.taskQueryInterceptor = taskQueryInterceptor;
        return this;
    }

    public HistoricTaskQueryInterceptor getHistoricTaskQueryInterceptor() {
        return historicTaskQueryInterceptor;
    }

    public ProcessEngineConfigurationImpl setHistoricTaskQueryInterceptor(HistoricTaskQueryInterceptor historicTaskQueryInterceptor) {
        this.historicTaskQueryInterceptor = historicTaskQueryInterceptor;
        return this;
    }

    public int getExecutionQueryLimit() {
        return executionQueryLimit;
    }

    public ProcessEngineConfigurationImpl setExecutionQueryLimit(int executionQueryLimit) {
        this.executionQueryLimit = executionQueryLimit;
        return this;
    }

    public int getTaskQueryLimit() {
        return taskQueryLimit;
    }

    public ProcessEngineConfigurationImpl setTaskQueryLimit(int taskQueryLimit) {
        this.taskQueryLimit = taskQueryLimit;
        return this;
    }

    public int getHistoricTaskQueryLimit() {
        return historicTaskQueryLimit;
    }

    public ProcessEngineConfigurationImpl setHistoricTaskQueryLimit(int historicTaskQueryLimit) {
        this.historicTaskQueryLimit = historicTaskQueryLimit;
        return this;
    }

    public int getHistoricProcessInstancesQueryLimit() {
        return historicProcessInstancesQueryLimit;
    }

    public ProcessEngineConfigurationImpl setHistoricProcessInstancesQueryLimit(int historicProcessInstancesQueryLimit) {
        this.historicProcessInstancesQueryLimit = historicProcessInstancesQueryLimit;
        return this;
    }

    public FlowableEngineAgendaFactory getAgendaFactory() {
        return agendaFactory;
    }

    public ProcessEngineConfigurationImpl setAgendaFactory(FlowableEngineAgendaFactory agendaFactory) {
        this.agendaFactory = agendaFactory;
        return this;
    }

    public Map!(string, JobHandler) getJobHandlers() {
        return jobHandlers;
    }

    public ProcessEngineConfigurationImpl setJobHandlers(Map!(string, JobHandler) jobHandlers) {
        this.jobHandlers = jobHandlers;
        return this;
    }

    public Map!(string, HistoryJobHandler) getHistoryJobHandlers() {
        return historyJobHandlers;
    }

    public ProcessEngineConfigurationImpl setHistoryJobHandlers(Map!(string, HistoryJobHandler) historyJobHandlers) {
        this.historyJobHandlers = historyJobHandlers;
        return this;
    }

    public ProcessInstanceHelper getProcessInstanceHelper() {
        return processInstanceHelper;
    }

    public ProcessEngineConfigurationImpl setProcessInstanceHelper(ProcessInstanceHelper processInstanceHelper) {
        this.processInstanceHelper = processInstanceHelper;
        return this;
    }

    public ListenerNotificationHelper getListenerNotificationHelper() {
        return listenerNotificationHelper;
    }

    public ProcessEngineConfigurationImpl setListenerNotificationHelper(ListenerNotificationHelper listenerNotificationHelper) {
        this.listenerNotificationHelper = listenerNotificationHelper;
        return this;
    }

    public FormHandlerHelper getFormHandlerHelper() {
        return formHandlerHelper;
    }

    public ProcessEngineConfigurationImpl setFormHandlerHelper(FormHandlerHelper formHandlerHelper) {
        this.formHandlerHelper = formHandlerHelper;
        return this;
    }

    public CaseInstanceService getCaseInstanceService() {
        return caseInstanceService;
    }

    public ProcessEngineConfigurationImpl setCaseInstanceService(CaseInstanceService caseInstanceService) {
        this.caseInstanceService = caseInstanceService;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setTransactionFactory(TransactionFactory transactionFactory) {
        this.transactionFactory = transactionFactory;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl addCustomSessionFactory(SessionFactory sessionFactory) {
        super.addCustomSessionFactory(sessionFactory);
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setCustomSessionFactories(List!SessionFactory customSessionFactories) {
        this.customSessionFactories = customSessionFactories;
        return this;
    }

    public List!JobHandler getCustomJobHandlers() {
        return customJobHandlers;
    }

    public ProcessEngineConfigurationImpl setCustomJobHandlers(List!JobHandler customJobHandlers) {
        this.customJobHandlers = customJobHandlers;
        return this;
    }

    public ProcessEngineConfigurationImpl addCustomJobHandler(JobHandler customJobHandler) {
        if (this.customJobHandlers is null) {
            this.customJobHandlers = new ArrayList<>();
        }
        this.customJobHandlers.add(customJobHandler);
        return this;
    }

    public List!HistoryJobHandler getCustomHistoryJobHandlers() {
        return customHistoryJobHandlers;
    }

    public ProcessEngineConfigurationImpl setCustomHistoryJobHandlers(List!HistoryJobHandler customHistoryJobHandlers) {
        this.customHistoryJobHandlers = customHistoryJobHandlers;
        return this;
    }

    public List!HistoryJsonTransformer getCustomHistoryJsonTransformers() {
        return customHistoryJsonTransformers;
    }

    public ProcessEngineConfigurationImpl setCustomHistoryJsonTransformers(List!HistoryJsonTransformer customHistoryJsonTransformers) {
        this.customHistoryJsonTransformers = customHistoryJsonTransformers;
        return this;
    }

    public List!FormEngine getCustomFormEngines() {
        return customFormEngines;
    }

    public ProcessEngineConfigurationImpl setCustomFormEngines(List!FormEngine customFormEngines) {
        this.customFormEngines = customFormEngines;
        return this;
    }

    public List!AbstractFormType getCustomFormTypes() {
        return customFormTypes;
    }

    public ProcessEngineConfigurationImpl setCustomFormTypes(List!AbstractFormType customFormTypes) {
        this.customFormTypes = customFormTypes;
        return this;
    }

    public List!string getCustomScriptingEngineClasses() {
        return customScriptingEngineClasses;
    }

    public ProcessEngineConfigurationImpl setCustomScriptingEngineClasses(List!string customScriptingEngineClasses) {
        this.customScriptingEngineClasses = customScriptingEngineClasses;
        return this;
    }

    public List!VariableType getCustomPreVariableTypes() {
        return customPreVariableTypes;
    }

    public ProcessEngineConfigurationImpl setCustomPreVariableTypes(List!VariableType customPreVariableTypes) {
        this.customPreVariableTypes = customPreVariableTypes;
        return this;
    }

    public List!VariableType getCustomPostVariableTypes() {
        return customPostVariableTypes;
    }

    public ProcessEngineConfigurationImpl setCustomPostVariableTypes(List!VariableType customPostVariableTypes) {
        this.customPostVariableTypes = customPostVariableTypes;
        return this;
    }

    public List!BpmnParseHandler getPreBpmnParseHandlers() {
        return preBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setPreBpmnParseHandlers(List!BpmnParseHandler preBpmnParseHandlers) {
        this.preBpmnParseHandlers = preBpmnParseHandlers;
        return this;
    }

    public List!BpmnParseHandler getCustomDefaultBpmnParseHandlers() {
        return customDefaultBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setCustomDefaultBpmnParseHandlers(List!BpmnParseHandler customDefaultBpmnParseHandlers) {
        this.customDefaultBpmnParseHandlers = customDefaultBpmnParseHandlers;
        return this;
    }

    public List!BpmnParseHandler getPostBpmnParseHandlers() {
        return postBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setPostBpmnParseHandlers(List!BpmnParseHandler postBpmnParseHandlers) {
        this.postBpmnParseHandlers = postBpmnParseHandlers;
        return this;
    }

    public ActivityBehaviorFactory getActivityBehaviorFactory() {
        return activityBehaviorFactory;
    }

    public ProcessEngineConfigurationImpl setActivityBehaviorFactory(ActivityBehaviorFactory activityBehaviorFactory) {
        this.activityBehaviorFactory = activityBehaviorFactory;
        return this;
    }

    public ListenerFactory getListenerFactory() {
        return listenerFactory;
    }

    public ProcessEngineConfigurationImpl setListenerFactory(ListenerFactory listenerFactory) {
        this.listenerFactory = listenerFactory;
        return this;
    }

    public BpmnParseFactory getBpmnParseFactory() {
        return bpmnParseFactory;
    }

    public ProcessEngineConfigurationImpl setBpmnParseFactory(BpmnParseFactory bpmnParseFactory) {
        this.bpmnParseFactory = bpmnParseFactory;
        return this;
    }

    public List!ResolverFactory getResolverFactories() {
        return resolverFactories;
    }

    public ProcessEngineConfigurationImpl setResolverFactories(List!ResolverFactory resolverFactories) {
        this.resolverFactories = resolverFactories;
        return this;
    }

    public DeploymentManager getDeploymentManager() {
        return deploymentManager;
    }

    public ProcessEngineConfigurationImpl setDeploymentManager(DeploymentManager deploymentManager) {
        this.deploymentManager = deploymentManager;
        return this;
    }

    public ProcessEngineConfigurationImpl setDelegateInterceptor(DelegateInterceptor delegateInterceptor) {
        this.delegateInterceptor = delegateInterceptor;
        return this;
    }

    public DelegateInterceptor getDelegateInterceptor() {
        return delegateInterceptor;
    }

    public EventHandler getEventHandler(string eventType) {
        return eventHandlers.get(eventType);
    }

    public ProcessEngineConfigurationImpl setEventHandlers(Map!(string, EventHandler) eventHandlers) {
        this.eventHandlers = eventHandlers;
        return this;
    }

    public Map!(string, EventHandler) getEventHandlers() {
        return eventHandlers;
    }

    public List!EventHandler getCustomEventHandlers() {
        return customEventHandlers;
    }

    public ProcessEngineConfigurationImpl setCustomEventHandlers(List!EventHandler customEventHandlers) {
        this.customEventHandlers = customEventHandlers;
        return this;
    }

    public FailedJobCommandFactory getFailedJobCommandFactory() {
        return failedJobCommandFactory;
    }

    public ProcessEngineConfigurationImpl setFailedJobCommandFactory(FailedJobCommandFactory failedJobCommandFactory) {
        this.failedJobCommandFactory = failedJobCommandFactory;
        return this;
    }

    public int getBatchSizeProcessInstances() {
        return batchSizeProcessInstances;
    }

    public ProcessEngineConfigurationImpl setBatchSizeProcessInstances(int batchSizeProcessInstances) {
        this.batchSizeProcessInstances = batchSizeProcessInstances;
        return this;
    }

    public int getBatchSizeTasks() {
        return batchSizeTasks;
    }

    public ProcessEngineConfigurationImpl setBatchSizeTasks(int batchSizeTasks) {
        this.batchSizeTasks = batchSizeTasks;
        return this;
    }

    public int getProcessDefinitionCacheLimit() {
        return processDefinitionCacheLimit;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionCacheLimit(int processDefinitionCacheLimit) {
        this.processDefinitionCacheLimit = processDefinitionCacheLimit;
        return this;
    }

    public DeploymentCache!ProcessDefinitionCacheEntry getProcessDefinitionCache() {
        return processDefinitionCache;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionCache(DeploymentCache!ProcessDefinitionCacheEntry processDefinitionCache) {
        this.processDefinitionCache = processDefinitionCache;
        return this;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionInfoCache(DeploymentCache!ProcessDefinitionInfoCacheObject processDefinitionInfoCache){
        this.processDefinitionInfoCache = processDefinitionInfoCache;
        return this;
    }

    public DeploymentCache!ProcessDefinitionInfoCacheObject getProcessDefinitionInfoCache() {
        return processDefinitionInfoCache;
    }

    public int getKnowledgeBaseCacheLimit() {
        return knowledgeBaseCacheLimit;
    }

    public ProcessEngineConfigurationImpl setKnowledgeBaseCacheLimit(int knowledgeBaseCacheLimit) {
        this.knowledgeBaseCacheLimit = knowledgeBaseCacheLimit;
        return this;
    }

    public DeploymentCache!Object getKnowledgeBaseCache() {
        return knowledgeBaseCache;
    }

    public ProcessEngineConfigurationImpl setKnowledgeBaseCache(DeploymentCache!Object knowledgeBaseCache) {
        this.knowledgeBaseCache = knowledgeBaseCache;
        return this;
    }

    public DeploymentCache!Object getAppResourceCache() {
        return appResourceCache;
    }

    public ProcessEngineConfigurationImpl setAppResourceCache(DeploymentCache!Object appResourceCache) {
        this.appResourceCache = appResourceCache;
        return this;
    }

    public int getAppResourceCacheLimit() {
        return appResourceCacheLimit;
    }

    public ProcessEngineConfigurationImpl setAppResourceCacheLimit(int appResourceCacheLimit) {
        this.appResourceCacheLimit = appResourceCacheLimit;
        return this;
    }

    public AppResourceConverter getAppResourceConverter() {
        return appResourceConverter;
    }

    public ProcessEngineConfigurationImpl setAppResourceConverter(AppResourceConverter appResourceConverter) {
        this.appResourceConverter = appResourceConverter;
        return this;
    }

    public bool isEnableSafeBpmnXml() {
        return enableSafeBpmnXml;
    }

    public ProcessEngineConfigurationImpl setEnableSafeBpmnXml(bool enableSafeBpmnXml) {
        this.enableSafeBpmnXml = enableSafeBpmnXml;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setEventDispatcher(FlowableEventDispatcher eventDispatcher) {
        this.eventDispatcher = eventDispatcher;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setEnableEventDispatcher(bool enableEventDispatcher) {
        this.enableEventDispatcher = enableEventDispatcher;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setTypedEventListeners(Map!(string, List!FlowableEventListener) typedListeners) {
        this.typedEventListeners = typedListeners;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setEventListeners(List!FlowableEventListener eventListeners) {
        this.eventListeners = eventListeners;
        return this;
    }

    public ProcessValidator getProcessValidator() {
        return processValidator;
    }

    public ProcessEngineConfigurationImpl setProcessValidator(ProcessValidator processValidator) {
        this.processValidator = processValidator;
        return this;
    }

    public FormFieldHandler getFormFieldHandler() {
        return formFieldHandler;
    }

    public ProcessEngineConfigurationImpl setFormFieldHandler(FormFieldHandler formFieldHandler) {
        this.formFieldHandler = formFieldHandler;
        return this;
    }

    public bool isFormFieldValidationEnabled() {
        return this.isFormFieldValidationEnabled;
    }

    public ProcessEngineConfigurationImpl setFormFieldValidationEnabled(bool flag) {
        this.isFormFieldValidationEnabled = flag;
        return this;
    }

    public EventRegistryEventConsumer getEventRegistryEventConsumer() {
        return eventRegistryEventConsumer;
    }

    public ProcessEngineConfigurationImpl setEventRegistryEventConsumer(EventRegistryEventConsumer eventRegistryEventConsumer) {
        this.eventRegistryEventConsumer = eventRegistryEventConsumer;
        return this;
    }

    public List!FlowableFunctionDelegate getFlowableFunctionDelegates() {
        return flowableFunctionDelegates;
    }

    public ProcessEngineConfigurationImpl setFlowableFunctionDelegates(List!FlowableFunctionDelegate flowableFunctionDelegates) {
        this.flowableFunctionDelegates = flowableFunctionDelegates;
        return this;
    }

    public List!FlowableFunctionDelegate getCustomFlowableFunctionDelegates() {
        return customFlowableFunctionDelegates;
    }

    public ProcessEngineConfigurationImpl setCustomFlowableFunctionDelegates(List!FlowableFunctionDelegate customFlowableFunctionDelegates) {
        this.customFlowableFunctionDelegates = customFlowableFunctionDelegates;
        return this;
    }

    public List!FlowableExpressionEnhancer getExpressionEnhancers() {
        return expressionEnhancers;
    }

    public ProcessEngineConfigurationImpl setExpressionEnhancers(List!FlowableExpressionEnhancer expressionEnhancers) {
        this.expressionEnhancers = expressionEnhancers;
        return this;
    }

    public List!FlowableExpressionEnhancer getCustomExpressionEnhancers() {
        return customExpressionEnhancers;
    }

    public ProcessEngineConfigurationImpl setCustomExpressionEnhancers(List!FlowableExpressionEnhancer customExpressionEnhancers) {
        this.customExpressionEnhancers = customExpressionEnhancers;
        return this;
    }

    public List!FlowableShortHandExpressionFunction getShortHandExpressionFunctions() {
        return shortHandExpressionFunctions;
    }

    public ProcessEngineConfigurationImpl setShortHandExpressionFunctions(List!FlowableShortHandExpressionFunction shortHandExpressionFunctions) {
        this.shortHandExpressionFunctions = shortHandExpressionFunctions;
        return this;
    }

    public bool isEnableDatabaseEventLogging() {
        return enableDatabaseEventLogging;
    }

    public ProcessEngineConfigurationImpl setEnableDatabaseEventLogging(bool enableDatabaseEventLogging) {
        this.enableDatabaseEventLogging = enableDatabaseEventLogging;
        return this;
    }

    public bool isEnableHistoricTaskLogging() {
        return enableHistoricTaskLogging;
    }

    public ProcessEngineConfigurationImpl setEnableHistoricTaskLogging(bool enableHistoricTaskLogging) {
        this.enableHistoricTaskLogging = enableHistoricTaskLogging;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setUsingRelationalDatabase(bool usingRelationalDatabase) {
        this.usingRelationalDatabase = usingRelationalDatabase;
        return this;
    }

    public bool isEnableVerboseExecutionTreeLogging() {
        return enableVerboseExecutionTreeLogging;
    }

    public ProcessEngineConfigurationImpl setEnableVerboseExecutionTreeLogging(bool enableVerboseExecutionTreeLogging) {
        this.enableVerboseExecutionTreeLogging = enableVerboseExecutionTreeLogging;
        return this;
    }

    public ProcessEngineConfigurationImpl setEnableEagerExecutionTreeFetching(bool enableEagerExecutionTreeFetching) {
        this.performanceSettings.setEnableEagerExecutionTreeFetching(enableEagerExecutionTreeFetching);
        return this;
    }

    public ProcessEngineConfigurationImpl setEnableExecutionRelationshipCounts(bool enableExecutionRelationshipCounts) {
        this.performanceSettings.setEnableExecutionRelationshipCounts(enableExecutionRelationshipCounts);
        return this;
    }

    public ProcessEngineConfigurationImpl setEnableTaskRelationshipCounts(bool enableTaskRelationshipCounts) {
        this.performanceSettings.setEnableTaskRelationshipCounts(enableTaskRelationshipCounts);
        return this;
    }

    public PerformanceSettings getPerformanceSettings() {
        return performanceSettings;
    }

    public void setPerformanceSettings(PerformanceSettings performanceSettings) {
        this.performanceSettings = performanceSettings;
    }

    public ProcessEngineConfigurationImpl setEnableLocalization(bool enableLocalization) {
        this.performanceSettings.setEnableLocalization(enableLocalization);
        return this;
    }

    public AttachmentDataManager getAttachmentDataManager() {
        return attachmentDataManager;
    }

    public ProcessEngineConfigurationImpl setAttachmentDataManager(AttachmentDataManager attachmentDataManager) {
        this.attachmentDataManager = attachmentDataManager;
        return this;
    }

    public ByteArrayDataManager getByteArrayDataManager() {
        return byteArrayDataManager;
    }

    public ProcessEngineConfigurationImpl setByteArrayDataManager(ByteArrayDataManager byteArrayDataManager) {
        this.byteArrayDataManager = byteArrayDataManager;
        return this;
    }

    public CommentDataManager getCommentDataManager() {
        return commentDataManager;
    }

    public ProcessEngineConfigurationImpl setCommentDataManager(CommentDataManager commentDataManager) {
        this.commentDataManager = commentDataManager;
        return this;
    }

    public DeploymentDataManager getDeploymentDataManager() {
        return deploymentDataManager;
    }

    public ProcessEngineConfigurationImpl setDeploymentDataManager(DeploymentDataManager deploymentDataManager) {
        this.deploymentDataManager = deploymentDataManager;
        return this;
    }

    public EventLogEntryDataManager getEventLogEntryDataManager() {
        return eventLogEntryDataManager;
    }

    public ProcessEngineConfigurationImpl setEventLogEntryDataManager(EventLogEntryDataManager eventLogEntryDataManager) {
        this.eventLogEntryDataManager = eventLogEntryDataManager;
        return this;
    }

    public ExecutionDataManager getExecutionDataManager() {
        return executionDataManager;
    }

    public ProcessEngineConfigurationImpl setExecutionDataManager(ExecutionDataManager executionDataManager) {
        this.executionDataManager = executionDataManager;
        return this;
    }

    public ActivityInstanceDataManager getActivityInstanceDataManager() {
        return activityInstanceDataManager;
    }

    public ProcessEngineConfigurationImpl setActivityInstanceDataManager(ActivityInstanceDataManager activityInstanceDataManager) {
        this.activityInstanceDataManager = activityInstanceDataManager;
        return this;
    }

    public HistoricActivityInstanceDataManager getHistoricActivityInstanceDataManager() {
        return historicActivityInstanceDataManager;
    }

    public ProcessEngineConfigurationImpl setHistoricActivityInstanceDataManager(HistoricActivityInstanceDataManager historicActivityInstanceDataManager) {
        this.historicActivityInstanceDataManager = historicActivityInstanceDataManager;
        return this;
    }

    public HistoricDetailDataManager getHistoricDetailDataManager() {
        return historicDetailDataManager;
    }

    public ProcessEngineConfigurationImpl setHistoricDetailDataManager(HistoricDetailDataManager historicDetailDataManager) {
        this.historicDetailDataManager = historicDetailDataManager;
        return this;
    }

    public HistoricProcessInstanceDataManager getHistoricProcessInstanceDataManager() {
        return historicProcessInstanceDataManager;
    }

    public ProcessEngineConfigurationImpl setHistoricProcessInstanceDataManager(HistoricProcessInstanceDataManager historicProcessInstanceDataManager) {
        this.historicProcessInstanceDataManager = historicProcessInstanceDataManager;
        return this;
    }

    public ModelDataManager getModelDataManager() {
        return modelDataManager;
    }

    public ProcessEngineConfigurationImpl setModelDataManager(ModelDataManager modelDataManager) {
        this.modelDataManager = modelDataManager;
        return this;
    }

    public ProcessDefinitionDataManager getProcessDefinitionDataManager() {
        return processDefinitionDataManager;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionDataManager(ProcessDefinitionDataManager processDefinitionDataManager) {
        this.processDefinitionDataManager = processDefinitionDataManager;
        return this;
    }

    public ProcessDefinitionInfoDataManager getProcessDefinitionInfoDataManager() {
        return processDefinitionInfoDataManager;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionInfoDataManager(ProcessDefinitionInfoDataManager processDefinitionInfoDataManager) {
        this.processDefinitionInfoDataManager = processDefinitionInfoDataManager;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setPropertyDataManager(PropertyDataManager propertyDataManager) {
        this.propertyDataManager = propertyDataManager;
        return this;
    }

    public ResourceDataManager getResourceDataManager() {
        return resourceDataManager;
    }

    public ProcessEngineConfigurationImpl setResourceDataManager(ResourceDataManager resourceDataManager) {
        this.resourceDataManager = resourceDataManager;
        return this;
    }

    public AttachmentEntityManager getAttachmentEntityManager() {
        return attachmentEntityManager;
    }

    public ProcessEngineConfigurationImpl setAttachmentEntityManager(AttachmentEntityManager attachmentEntityManager) {
        this.attachmentEntityManager = attachmentEntityManager;
        return this;
    }

    public ByteArrayEntityManager getByteArrayEntityManager() {
        return byteArrayEntityManager;
    }

    public ProcessEngineConfigurationImpl setByteArrayEntityManager(ByteArrayEntityManager byteArrayEntityManager) {
        this.byteArrayEntityManager = byteArrayEntityManager;
        return this;
    }

    public CommentEntityManager getCommentEntityManager() {
        return commentEntityManager;
    }

    public ProcessEngineConfigurationImpl setCommentEntityManager(CommentEntityManager commentEntityManager) {
        this.commentEntityManager = commentEntityManager;
        return this;
    }

    public DeploymentEntityManager getDeploymentEntityManager() {
        return deploymentEntityManager;
    }

    public ProcessEngineConfigurationImpl setDeploymentEntityManager(DeploymentEntityManager deploymentEntityManager) {
        this.deploymentEntityManager = deploymentEntityManager;
        return this;
    }

    public EventLogEntryEntityManager getEventLogEntryEntityManager() {
        return eventLogEntryEntityManager;
    }

    public ProcessEngineConfigurationImpl setEventLogEntryEntityManager(EventLogEntryEntityManager eventLogEntryEntityManager) {
        this.eventLogEntryEntityManager = eventLogEntryEntityManager;
        return this;
    }

    public ExecutionEntityManager getExecutionEntityManager() {
        return executionEntityManager;
    }

    public ProcessEngineConfigurationImpl setExecutionEntityManager(ExecutionEntityManager executionEntityManager) {
        this.executionEntityManager = executionEntityManager;
        return this;
    }

    public ActivityInstanceEntityManager getActivityInstanceEntityManager() {
        return activityInstanceEntityManager;
    }

    public ProcessEngineConfigurationImpl setActivityInstanceEntityManager(ActivityInstanceEntityManager activityInstanceEntityManager) {
        this.activityInstanceEntityManager = activityInstanceEntityManager;
        return this;
    }

    public HistoricActivityInstanceEntityManager getHistoricActivityInstanceEntityManager() {
        return historicActivityInstanceEntityManager;
    }

    public ProcessEngineConfigurationImpl setHistoricActivityInstanceEntityManager(HistoricActivityInstanceEntityManager historicActivityInstanceEntityManager) {
        this.historicActivityInstanceEntityManager = historicActivityInstanceEntityManager;
        return this;
    }

    public HistoricDetailEntityManager getHistoricDetailEntityManager() {
        return historicDetailEntityManager;
    }

    public ProcessEngineConfigurationImpl setHistoricDetailEntityManager(HistoricDetailEntityManager historicDetailEntityManager) {
        this.historicDetailEntityManager = historicDetailEntityManager;
        return this;
    }

    public HistoricProcessInstanceEntityManager getHistoricProcessInstanceEntityManager() {
        return historicProcessInstanceEntityManager;
    }

    public ProcessEngineConfigurationImpl setHistoricProcessInstanceEntityManager(HistoricProcessInstanceEntityManager historicProcessInstanceEntityManager) {
        this.historicProcessInstanceEntityManager = historicProcessInstanceEntityManager;
        return this;
    }

    public ModelEntityManager getModelEntityManager() {
        return modelEntityManager;
    }

    public ProcessEngineConfigurationImpl setModelEntityManager(ModelEntityManager modelEntityManager) {
        this.modelEntityManager = modelEntityManager;
        return this;
    }

    public ProcessDefinitionEntityManager getProcessDefinitionEntityManager() {
        return processDefinitionEntityManager;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionEntityManager(ProcessDefinitionEntityManager processDefinitionEntityManager) {
        this.processDefinitionEntityManager = processDefinitionEntityManager;
        return this;
    }

    public ProcessDefinitionInfoEntityManager getProcessDefinitionInfoEntityManager() {
        return processDefinitionInfoEntityManager;
    }

    public ProcessEngineConfigurationImpl setProcessDefinitionInfoEntityManager(ProcessDefinitionInfoEntityManager processDefinitionInfoEntityManager) {
        this.processDefinitionInfoEntityManager = processDefinitionInfoEntityManager;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setPropertyEntityManager(PropertyEntityManager propertyEntityManager) {
        this.propertyEntityManager = propertyEntityManager;
        return this;
    }

    public ResourceEntityManager getResourceEntityManager() {
        return resourceEntityManager;
    }

    public ProcessEngineConfigurationImpl setResourceEntityManager(ResourceEntityManager resourceEntityManager) {
        this.resourceEntityManager = resourceEntityManager;
        return this;
    }

    public TableDataManager getTableDataManager() {
        return tableDataManager;
    }

    public ProcessEngineConfigurationImpl setTableDataManager(TableDataManager tableDataManager) {
        this.tableDataManager = tableDataManager;
        return this;
    }

    public CandidateManager getCandidateManager() {
        return candidateManager;
    }

    public void setCandidateManager(CandidateManager candidateManager) {
        this.candidateManager = candidateManager;
    }

    public List!AsyncRunnableExecutionExceptionHandler getCustomAsyncRunnableExecutionExceptionHandlers() {
        return customAsyncRunnableExecutionExceptionHandlers;
    }

    public ProcessEngineConfigurationImpl setCustomAsyncRunnableExecutionExceptionHandlers(
        List!AsyncRunnableExecutionExceptionHandler customAsyncRunnableExecutionExceptionHandlers) {

        this.customAsyncRunnableExecutionExceptionHandlers = customAsyncRunnableExecutionExceptionHandlers;
        return this;
    }

    public bool isAddDefaultExceptionHandler() {
        return addDefaultExceptionHandler;
    }

    public ProcessEngineConfigurationImpl setAddDefaultExceptionHandler(bool addDefaultExceptionHandler) {
        this.addDefaultExceptionHandler = addDefaultExceptionHandler;
        return this;
    }

    public HistoryManager getHistoryManager() {
        return historyManager;
    }

    public ProcessEngineConfigurationImpl setHistoryManager(HistoryManager historyManager) {
        this.historyManager = historyManager;
        return this;
    }

    public bool isAsyncHistoryEnabled() {
        return isAsyncHistoryEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryEnabled(bool isAsyncHistoryEnabled) {
        this.isAsyncHistoryEnabled = isAsyncHistoryEnabled;
        return this;
    }

    public bool isAsyncHistoryJsonGzipCompressionEnabled() {
        return isAsyncHistoryJsonGzipCompressionEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryJsonGzipCompressionEnabled(bool isAsyncHistoryJsonGzipCompressionEnabled) {
        this.isAsyncHistoryJsonGzipCompressionEnabled = isAsyncHistoryJsonGzipCompressionEnabled;
        return this;
    }

    public bool isAsyncHistoryJsonGroupingEnabled() {
        return isAsyncHistoryJsonGroupingEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryJsonGroupingEnabled(bool isAsyncHistoryJsonGroupingEnabled) {
        this.isAsyncHistoryJsonGroupingEnabled = isAsyncHistoryJsonGroupingEnabled;
        return this;
    }

    public int getAsyncHistoryJsonGroupingThreshold() {
        return asyncHistoryJsonGroupingThreshold;
    }

    public void setAsyncHistoryJsonGroupingThreshold(int asyncHistoryJsonGroupingThreshold) {
        this.asyncHistoryJsonGroupingThreshold = asyncHistoryJsonGroupingThreshold;
    }

    public AsyncHistoryListener getAsyncHistoryListener() {
        return asyncHistoryListener;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryListener(AsyncHistoryListener asyncHistoryListener) {
        this.asyncHistoryListener = asyncHistoryListener;
        return this;
    }

    public JobManager getJobManager() {
        return jobManager;
    }

    public ProcessEngineConfigurationImpl setJobManager(JobManager jobManager) {
        this.jobManager = jobManager;
        return this;
    }

    public DynamicStateManager getDynamicStateManager() {
        return dynamicStateManager;
    }

    public ProcessEngineConfigurationImpl setDynamicStateManager(DynamicStateManager dynamicStateManager) {
        this.dynamicStateManager = dynamicStateManager;
        return this;
    }

    public ProcessInstanceMigrationManager getProcessInstanceMigrationManager() {
        return processInstanceMigrationManager;
    }

    public ProcessEngineConfigurationImpl setProcessInstanceMigrationManager(ProcessInstanceMigrationManager processInstanceMigrationValidationMananger) {
        this.processInstanceMigrationManager = processInstanceMigrationValidationMananger;
        return this;
    }

    public DecisionTableVariableManager getDecisionTableVariableManager() {
        return decisionTableVariableManager;
    }

    public ProcessEngineConfigurationImpl setDecisionTableVariableManager(DecisionTableVariableManager decisionTableVariableManager) {
        this.decisionTableVariableManager = decisionTableVariableManager;
        return this;
    }

    public IdentityLinkInterceptor getIdentityLinkInterceptor() {
        return identityLinkInterceptor;
    }

    public ProcessEngineConfigurationImpl setIdentityLinkInterceptor(IdentityLinkInterceptor identityLinkInterceptor) {
        this.identityLinkInterceptor = identityLinkInterceptor;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setClock(Clock clock) {
        if (this.clock is null) {
            this.clock = clock;
        } else {
            this.clock.setCurrentCalendar(clock.getCurrentCalendar());
        }

        if (flowable5CompatibilityEnabled && flowable5CompatibilityHandler !is null) {
            getFlowable5CompatibilityHandler().setClock(clock);
        }
        return this;
    }

    public void resetClock() {
        if (this.clock !is null) {
            clock.reset();
            if (flowable5CompatibilityEnabled && flowable5CompatibilityHandler !is null) {
                getFlowable5CompatibilityHandler().resetClock();
            }
        }
    }

    public DelegateExpressionFieldInjectionMode getDelegateExpressionFieldInjectionMode() {
        return delegateExpressionFieldInjectionMode;
    }

    public ProcessEngineConfigurationImpl setDelegateExpressionFieldInjectionMode(DelegateExpressionFieldInjectionMode delegateExpressionFieldInjectionMode) {
        this.delegateExpressionFieldInjectionMode = delegateExpressionFieldInjectionMode;
        return this;
    }

    public List!Object getFlowable5JobProcessors() {
        return flowable5JobProcessors;
    }

    public ProcessEngineConfigurationImpl setFlowable5JobProcessors(List!Object jobProcessors) {
        this.flowable5JobProcessors = jobProcessors;
        return this;
    }

    public List!JobProcessor getJobProcessors() {
        return jobProcessors;
    }

    public ProcessEngineConfigurationImpl setJobProcessors(List!JobProcessor jobProcessors) {
        this.jobProcessors = jobProcessors;
        return this;
    }

    public List!HistoryJobProcessor getHistoryJobProcessors() {
        return historyJobProcessors;
    }

    public ProcessEngineConfigurationImpl setHistoryJobProcessors(List!HistoryJobProcessor historyJobProcessors) {
        this.historyJobProcessors = historyJobProcessors;
        return this;
    }

    public Map!(string, List!RuntimeInstanceStateChangeCallback) getProcessInstanceStateChangedCallbacks() {
        return processInstanceStateChangedCallbacks;
    }

    public ProcessEngineConfigurationImpl setProcessInstanceStateChangedCallbacks(Map!(string, List!RuntimeInstanceStateChangeCallback) processInstanceStateChangedCallbacks) {
        this.processInstanceStateChangedCallbacks = processInstanceStateChangedCallbacks;
        return this;
    }

    public SchemaManager getVariableSchemaManager() {
        return variableSchemaManager;
    }

    public ProcessEngineConfigurationImpl setVariableSchemaManager(SchemaManager variableSchemaManager) {
        this.variableSchemaManager = variableSchemaManager;
        return this;
    }

    public SchemaManager getTaskSchemaManager() {
        return taskSchemaManager;
    }

    public ProcessEngineConfigurationImpl setTaskSchemaManager(SchemaManager taskSchemaManager) {
        this.taskSchemaManager = taskSchemaManager;
        return this;
    }

    public SchemaManager getIdentityLinkSchemaManager() {
        return identityLinkSchemaManager;
    }

    public ProcessEngineConfigurationImpl setIdentityLinkSchemaManager(SchemaManager identityLinkSchemaManager) {
        this.identityLinkSchemaManager = identityLinkSchemaManager;
        return this;
    }

    public SchemaManager getEntityLinkSchemaManager() {
        return entityLinkSchemaManager;
    }

    public ProcessEngineConfigurationImpl setEntityLinkSchemaManager(SchemaManager entityLinkSchemaManager) {
        this.entityLinkSchemaManager = entityLinkSchemaManager;
        return this;
    }

    public SchemaManager getEventSubscriptionSchemaManager() {
        return eventSubscriptionSchemaManager;
    }

    public ProcessEngineConfigurationImpl setEventSubscriptionSchemaManager(SchemaManager eventSubscriptionSchemaManager) {
        this.eventSubscriptionSchemaManager = eventSubscriptionSchemaManager;
        return this;
    }

    public SchemaManager getJobSchemaManager() {
        return jobSchemaManager;
    }

    public ProcessEngineConfigurationImpl setJobSchemaManager(SchemaManager jobSchemaManager) {
        this.jobSchemaManager = jobSchemaManager;
        return this;
    }

    public SchemaManager getBatchSchemaManager() {
        return batchSchemaManager;
    }

    public ProcessEngineConfigurationImpl setBatchSchemaManager(SchemaManager batchSchemaManager) {
        this.batchSchemaManager = batchSchemaManager;
        return this;
    }

    public bool isEnableEntityLinks() {
        return enableEntityLinks;
    }

    public ProcessEngineConfigurationImpl setEnableEntityLinks(bool enableEntityLinks) {
        this.enableEntityLinks = enableEntityLinks;
        return this;
    }

    public bool isHandleProcessEngineExecutorsAfterEngineCreate() {
        return handleProcessEngineExecutorsAfterEngineCreate;
    }

    public void setHandleProcessEngineExecutorsAfterEngineCreate(bool handleProcessEngineExecutorsAfterEngineCreate) {
        this.handleProcessEngineExecutorsAfterEngineCreate = handleProcessEngineExecutorsAfterEngineCreate;
    }

    // Flowable 5

    public bool isFlowable5CompatibilityEnabled() {
        return flowable5CompatibilityEnabled;
    }

    public ProcessEngineConfigurationImpl setFlowable5CompatibilityEnabled(bool flowable5CompatibilityEnabled) {
        this.flowable5CompatibilityEnabled = flowable5CompatibilityEnabled;
        return this;
    }

    public bool isValidateFlowable5EntitiesEnabled() {
        return validateFlowable5EntitiesEnabled;
    }

    public ProcessEngineConfigurationImpl setValidateFlowable5EntitiesEnabled(bool validateFlowable5EntitiesEnabled) {
        this.validateFlowable5EntitiesEnabled = validateFlowable5EntitiesEnabled;
        return this;
    }

    public bool isRedeployFlowable5ProcessDefinitions() {
        return redeployFlowable5ProcessDefinitions;
    }

    public ProcessEngineConfigurationImpl setRedeployFlowable5ProcessDefinitions(bool redeployFlowable5ProcessDefinitions) {
        this.redeployFlowable5ProcessDefinitions = redeployFlowable5ProcessDefinitions;
        return this;
    }

    public Flowable5CompatibilityHandlerFactory getFlowable5CompatibilityHandlerFactory() {
        return flowable5CompatibilityHandlerFactory;
    }

    public ProcessEngineConfigurationImpl setFlowable5CompatibilityHandlerFactory(Flowable5CompatibilityHandlerFactory flowable5CompatibilityHandlerFactory) {
        this.flowable5CompatibilityHandlerFactory = flowable5CompatibilityHandlerFactory;
        return this;
    }

    public Flowable5CompatibilityHandler getFlowable5CompatibilityHandler() {
        return flowable5CompatibilityHandler;
    }

    public ProcessEngineConfigurationImpl setFlowable5CompatibilityHandler(Flowable5CompatibilityHandler flowable5CompatibilityHandler) {
        this.flowable5CompatibilityHandler = flowable5CompatibilityHandler;
        return this;
    }

    public Object getFlowable5ActivityBehaviorFactory() {
        return flowable5ActivityBehaviorFactory;
    }

    public ProcessEngineConfigurationImpl setFlowable5ActivityBehaviorFactory(Object flowable5ActivityBehaviorFactory) {
        this.flowable5ActivityBehaviorFactory = flowable5ActivityBehaviorFactory;
        return this;
    }

    public Object getFlowable5ExpressionManager() {
        return flowable5ExpressionManager;
    }

    public ProcessEngineConfigurationImpl setFlowable5ExpressionManager(Object flowable5ExpressionManager) {
        this.flowable5ExpressionManager = flowable5ExpressionManager;
        return this;
    }

    public Object getFlowable5ListenerFactory() {
        return flowable5ListenerFactory;
    }

    public ProcessEngineConfigurationImpl setFlowable5ListenerFactory(Object flowable5ListenerFactory) {
        this.flowable5ListenerFactory = flowable5ListenerFactory;
        return this;
    }

    public List!Object getFlowable5PreBpmnParseHandlers() {
        return flowable5PreBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setFlowable5PreBpmnParseHandlers(List!Object flowable5PreBpmnParseHandlers) {
        this.flowable5PreBpmnParseHandlers = flowable5PreBpmnParseHandlers;
        return this;
    }

    public List!Object getFlowable5PostBpmnParseHandlers() {
        return flowable5PostBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setFlowable5PostBpmnParseHandlers(List!Object flowable5PostBpmnParseHandlers) {
        this.flowable5PostBpmnParseHandlers = flowable5PostBpmnParseHandlers;
        return this;
    }

    public List!Object getFlowable5CustomDefaultBpmnParseHandlers() {
        return flowable5CustomDefaultBpmnParseHandlers;
    }

    public ProcessEngineConfigurationImpl setFlowable5CustomDefaultBpmnParseHandlers(List!Object flowable5CustomDefaultBpmnParseHandlers) {
        this.flowable5CustomDefaultBpmnParseHandlers = flowable5CustomDefaultBpmnParseHandlers;
        return this;
    }

    public Set<Class<?>> getFlowable5CustomMybatisMappers() {
        return flowable5CustomMybatisMappers;
    }

    public ProcessEngineConfigurationImpl setFlowable5CustomMybatisMappers(Set<Class<?>> flowable5CustomMybatisMappers) {
        this.flowable5CustomMybatisMappers = flowable5CustomMybatisMappers;
        return this;
    }

    public Set!string getFlowable5CustomMybatisXMLMappers() {
        return flowable5CustomMybatisXMLMappers;
    }

    public ProcessEngineConfigurationImpl setFlowable5CustomMybatisXMLMappers(Set!string flowable5CustomMybatisXMLMappers) {
        this.flowable5CustomMybatisXMLMappers = flowable5CustomMybatisXMLMappers;
        return this;
    }

    override
    public ProcessEngineConfigurationImpl setAsyncExecutorActivate(bool asyncExecutorActivate) {
        this.asyncExecutorActivate = asyncExecutorActivate;
        return this;
    }

    public int getAsyncExecutorCorePoolSize() {
        return asyncExecutorCorePoolSize;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorCorePoolSize(int asyncExecutorCorePoolSize) {
        this.asyncExecutorCorePoolSize = asyncExecutorCorePoolSize;
        return this;
    }

    public int getAsyncExecutorNumberOfRetries() {
        return asyncExecutorNumberOfRetries;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorNumberOfRetries(int asyncExecutorNumberOfRetries) {
        this.asyncExecutorNumberOfRetries = asyncExecutorNumberOfRetries;
        return this;
    }

    public int getAsyncHistoryExecutorNumberOfRetries() {
        return asyncHistoryExecutorNumberOfRetries;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorNumberOfRetries(int asyncHistoryExecutorNumberOfRetries) {
        this.asyncHistoryExecutorNumberOfRetries = asyncHistoryExecutorNumberOfRetries;
        return this;
    }

    public int getAsyncExecutorMaxPoolSize() {
        return asyncExecutorMaxPoolSize;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorMaxPoolSize(int asyncExecutorMaxPoolSize) {
        this.asyncExecutorMaxPoolSize = asyncExecutorMaxPoolSize;
        return this;
    }

    public long getAsyncExecutorThreadKeepAliveTime() {
        return asyncExecutorThreadKeepAliveTime;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorThreadKeepAliveTime(long asyncExecutorThreadKeepAliveTime) {
        this.asyncExecutorThreadKeepAliveTime = asyncExecutorThreadKeepAliveTime;
        return this;
    }

    public int getAsyncExecutorThreadPoolQueueSize() {
        return asyncExecutorThreadPoolQueueSize;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorThreadPoolQueueSize(int asyncExecutorThreadPoolQueueSize) {
        this.asyncExecutorThreadPoolQueueSize = asyncExecutorThreadPoolQueueSize;
        return this;
    }

    public BlockingQueue<Runnable> getAsyncExecutorThreadPoolQueue() {
        return asyncExecutorThreadPoolQueue;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorThreadPoolQueue(BlockingQueue<Runnable> asyncExecutorThreadPoolQueue) {
        this.asyncExecutorThreadPoolQueue = asyncExecutorThreadPoolQueue;
        return this;
    }

    public long getAsyncExecutorSecondsToWaitOnShutdown() {
        return asyncExecutorSecondsToWaitOnShutdown;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorSecondsToWaitOnShutdown(long asyncExecutorSecondsToWaitOnShutdown) {
        this.asyncExecutorSecondsToWaitOnShutdown = asyncExecutorSecondsToWaitOnShutdown;
        return this;
    }

    public bool isAsyncExecutorAllowCoreThreadTimeout() {
        return asyncExecutorAllowCoreThreadTimeout;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorAllowCoreThreadTimeout(bool asyncExecutorAllowCoreThreadTimeout) {
        this.asyncExecutorAllowCoreThreadTimeout = asyncExecutorAllowCoreThreadTimeout;
        return this;
    }

    public int getAsyncExecutorMaxTimerJobsPerAcquisition() {
        return asyncExecutorMaxTimerJobsPerAcquisition;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorMaxTimerJobsPerAcquisition(int asyncExecutorMaxTimerJobsPerAcquisition) {
        this.asyncExecutorMaxTimerJobsPerAcquisition = asyncExecutorMaxTimerJobsPerAcquisition;
        return this;
    }

    public int getAsyncExecutorMaxAsyncJobsDuePerAcquisition() {
        return asyncExecutorMaxAsyncJobsDuePerAcquisition;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorMaxAsyncJobsDuePerAcquisition(int asyncExecutorMaxAsyncJobsDuePerAcquisition) {
        this.asyncExecutorMaxAsyncJobsDuePerAcquisition = asyncExecutorMaxAsyncJobsDuePerAcquisition;
        return this;
    }

    public int getAsyncExecutorDefaultTimerJobAcquireWaitTime() {
        return asyncExecutorDefaultTimerJobAcquireWaitTime;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorDefaultTimerJobAcquireWaitTime(int asyncExecutorDefaultTimerJobAcquireWaitTime) {
        this.asyncExecutorDefaultTimerJobAcquireWaitTime = asyncExecutorDefaultTimerJobAcquireWaitTime;
        return this;
    }

    public int getAsyncExecutorDefaultAsyncJobAcquireWaitTime() {
        return asyncExecutorDefaultAsyncJobAcquireWaitTime;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorDefaultAsyncJobAcquireWaitTime(int asyncExecutorDefaultAsyncJobAcquireWaitTime) {
        this.asyncExecutorDefaultAsyncJobAcquireWaitTime = asyncExecutorDefaultAsyncJobAcquireWaitTime;
        return this;
    }

    public int getAsyncExecutorDefaultQueueSizeFullWaitTime() {
        return asyncExecutorDefaultQueueSizeFullWaitTime;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorDefaultQueueSizeFullWaitTime(int asyncExecutorDefaultQueueSizeFullWaitTime) {
        this.asyncExecutorDefaultQueueSizeFullWaitTime = asyncExecutorDefaultQueueSizeFullWaitTime;
        return this;
    }

    public string getAsyncExecutorLockOwner() {
        return asyncExecutorLockOwner;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorLockOwner(string asyncExecutorLockOwner) {
        this.asyncExecutorLockOwner = asyncExecutorLockOwner;
        return this;
    }

    public int getAsyncExecutorTimerLockTimeInMillis() {
        return asyncExecutorTimerLockTimeInMillis;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorTimerLockTimeInMillis(int asyncExecutorTimerLockTimeInMillis) {
        this.asyncExecutorTimerLockTimeInMillis = asyncExecutorTimerLockTimeInMillis;
        return this;
    }

    public int getAsyncExecutorAsyncJobLockTimeInMillis() {
        return asyncExecutorAsyncJobLockTimeInMillis;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorAsyncJobLockTimeInMillis(int asyncExecutorAsyncJobLockTimeInMillis) {
        this.asyncExecutorAsyncJobLockTimeInMillis = asyncExecutorAsyncJobLockTimeInMillis;
        return this;
    }

    public int getAsyncExecutorResetExpiredJobsInterval() {
        return asyncExecutorResetExpiredJobsInterval;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorResetExpiredJobsInterval(int asyncExecutorResetExpiredJobsInterval) {
        this.asyncExecutorResetExpiredJobsInterval = asyncExecutorResetExpiredJobsInterval;
        return this;
    }

    public int getAsyncExecutorResetExpiredJobsMaxTimeout() {
        return asyncExecutorResetExpiredJobsMaxTimeout;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorResetExpiredJobsMaxTimeout(int asyncExecutorResetExpiredJobsMaxTimeout) {
        this.asyncExecutorResetExpiredJobsMaxTimeout = asyncExecutorResetExpiredJobsMaxTimeout;
        return this;
    }

    public ExecuteAsyncRunnableFactory getAsyncExecutorExecuteAsyncRunnableFactory() {
        return asyncExecutorExecuteAsyncRunnableFactory;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorExecuteAsyncRunnableFactory(ExecuteAsyncRunnableFactory asyncExecutorExecuteAsyncRunnableFactory) {
        this.asyncExecutorExecuteAsyncRunnableFactory = asyncExecutorExecuteAsyncRunnableFactory;
        return this;
    }

    public int getAsyncExecutorResetExpiredJobsPageSize() {
        return asyncExecutorResetExpiredJobsPageSize;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorResetExpiredJobsPageSize(int asyncExecutorResetExpiredJobsPageSize) {
        this.asyncExecutorResetExpiredJobsPageSize = asyncExecutorResetExpiredJobsPageSize;
        return this;
    }

    public bool isAsyncExecutorIsMessageQueueMode() {
        return asyncExecutorMessageQueueMode;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorMessageQueueMode(bool asyncExecutorMessageQueueMode) {
        this.asyncExecutorMessageQueueMode = asyncExecutorMessageQueueMode;
        return this;
    }

    public bool isAsyncHistoryExecutorIsMessageQueueMode() {
        return asyncHistoryExecutorMessageQueueMode;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorMessageQueueMode(bool asyncHistoryExecutorMessageQueueMode) {
        this.asyncHistoryExecutorMessageQueueMode = asyncHistoryExecutorMessageQueueMode;
        return this;
    }

    public string getJobExecutionScope() {
        return jobExecutionScope;
    }

    public ProcessEngineConfigurationImpl setJobExecutionScope(string jobExecutionScope) {
        this.jobExecutionScope = jobExecutionScope;
        return this;
    }

    public string getHistoryJobExecutionScope() {
        return historyJobExecutionScope;
    }

    public ProcessEngineConfigurationImpl setHistoryJobExecutionScope(string historyJobExecutionScope) {
        this.historyJobExecutionScope = historyJobExecutionScope;
        return this;
    }

    public int getAsyncHistoryExecutorCorePoolSize() {
        return asyncHistoryExecutorCorePoolSize;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorCorePoolSize(int asyncHistoryExecutorCorePoolSize) {
        this.asyncHistoryExecutorCorePoolSize = asyncHistoryExecutorCorePoolSize;
        return this;
    }

    public int getAsyncHistoryExecutorMaxPoolSize() {
        return asyncHistoryExecutorMaxPoolSize;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorMaxPoolSize(int asyncHistoryExecutorMaxPoolSize) {
        this.asyncHistoryExecutorMaxPoolSize = asyncHistoryExecutorMaxPoolSize;
        return this;
    }

    public long getAsyncHistoryExecutorThreadKeepAliveTime() {
        return asyncHistoryExecutorThreadKeepAliveTime;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorThreadKeepAliveTime(long asyncHistoryExecutorThreadKeepAliveTime) {
        this.asyncHistoryExecutorThreadKeepAliveTime = asyncHistoryExecutorThreadKeepAliveTime;
        return this;
    }

    public int getAsyncHistoryExecutorThreadPoolQueueSize() {
        return asyncHistoryExecutorThreadPoolQueueSize;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorThreadPoolQueueSize(int asyncHistoryExecutorThreadPoolQueueSize) {
        this.asyncHistoryExecutorThreadPoolQueueSize = asyncHistoryExecutorThreadPoolQueueSize;
        return this;
    }

    public BlockingQueue<Runnable> getAsyncHistoryExecutorThreadPoolQueue() {
        return asyncHistoryExecutorThreadPoolQueue;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorThreadPoolQueue(BlockingQueue<Runnable> asyncHistoryExecutorThreadPoolQueue) {
        this.asyncHistoryExecutorThreadPoolQueue = asyncHistoryExecutorThreadPoolQueue;
        return this;
    }

    public long getAsyncHistoryExecutorSecondsToWaitOnShutdown() {
        return asyncHistoryExecutorSecondsToWaitOnShutdown;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorSecondsToWaitOnShutdown(long asyncHistoryExecutorSecondsToWaitOnShutdown) {
        this.asyncHistoryExecutorSecondsToWaitOnShutdown = asyncHistoryExecutorSecondsToWaitOnShutdown;
        return this;
    }

    public int getAsyncHistoryExecutorDefaultAsyncJobAcquireWaitTime() {
        return asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorDefaultAsyncJobAcquireWaitTime(int asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime) {
        this.asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime = asyncHistoryExecutorDefaultAsyncJobAcquireWaitTime;
        return this;
    }

    public int getAsyncHistoryExecutorDefaultQueueSizeFullWaitTime() {
        return asyncHistoryExecutorDefaultQueueSizeFullWaitTime;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorDefaultQueueSizeFullWaitTime(int asyncHistoryExecutorDefaultQueueSizeFullWaitTime) {
        this.asyncHistoryExecutorDefaultQueueSizeFullWaitTime = asyncHistoryExecutorDefaultQueueSizeFullWaitTime;
        return this;
    }

    public string getAsyncHistoryExecutorLockOwner() {
        return asyncHistoryExecutorLockOwner;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorLockOwner(string asyncHistoryExecutorLockOwner) {
        this.asyncHistoryExecutorLockOwner = asyncHistoryExecutorLockOwner;
        return this;
    }

    public int getAsyncHistoryExecutorAsyncJobLockTimeInMillis() {
        return asyncHistoryExecutorAsyncJobLockTimeInMillis;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorAsyncJobLockTimeInMillis(int asyncHistoryExecutorAsyncJobLockTimeInMillis) {
        this.asyncHistoryExecutorAsyncJobLockTimeInMillis = asyncHistoryExecutorAsyncJobLockTimeInMillis;
        return this;
    }

    public int getAsyncHistoryExecutorResetExpiredJobsInterval() {
        return asyncHistoryExecutorResetExpiredJobsInterval;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorResetExpiredJobsInterval(int asyncHistoryExecutorResetExpiredJobsInterval) {
        this.asyncHistoryExecutorResetExpiredJobsInterval = asyncHistoryExecutorResetExpiredJobsInterval;
        return this;
    }

    public int getAsyncHistoryExecutorResetExpiredJobsPageSize() {
        return asyncHistoryExecutorResetExpiredJobsPageSize;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorResetExpiredJobsPageSize(int asyncHistoryExecutorResetExpiredJobsPageSize) {
        this.asyncHistoryExecutorResetExpiredJobsPageSize = asyncHistoryExecutorResetExpiredJobsPageSize;
        return this;
    }

    public bool isAsyncExecutorMessageQueueMode() {
        return asyncExecutorMessageQueueMode;
    }

    public bool isAsyncHistoryExecutorMessageQueueMode() {
        return asyncHistoryExecutorMessageQueueMode;
    }

    public bool isAsyncExecutorAsyncJobAcquisitionEnabled() {
        return isAsyncExecutorAsyncJobAcquisitionEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorAsyncJobAcquisitionEnabled(bool isAsyncExecutorAsyncJobAcquisitionEnabled) {
        this.isAsyncExecutorAsyncJobAcquisitionEnabled = isAsyncExecutorAsyncJobAcquisitionEnabled;
        return this;
    }

    public bool isAsyncExecutorTimerJobAcquisitionEnabled() {
        return isAsyncExecutorTimerJobAcquisitionEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorTimerJobAcquisitionEnabled(bool isAsyncExecutorTimerJobAcquisitionEnabled) {
        this.isAsyncExecutorTimerJobAcquisitionEnabled = isAsyncExecutorTimerJobAcquisitionEnabled;
        return this;
    }

    public bool isAsyncExecutorResetExpiredJobsEnabled() {
        return isAsyncExecutorResetExpiredJobsEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncExecutorResetExpiredJobsEnabled(bool isAsyncExecutorResetExpiredJobsEnabled) {
        this.isAsyncExecutorResetExpiredJobsEnabled = isAsyncExecutorResetExpiredJobsEnabled;
        return this;
    }

    public bool isAsyncHistoryExecutorAsyncJobAcquisitionEnabled() {
        return isAsyncHistoryExecutorAsyncJobAcquisitionEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorAsyncJobAcquisitionEnabled(bool isAsyncHistoryExecutorAsyncJobAcquisitionEnabled) {
        this.isAsyncHistoryExecutorAsyncJobAcquisitionEnabled = isAsyncHistoryExecutorAsyncJobAcquisitionEnabled;
        return this;
    }

    public bool isAsyncHistoryExecutorTimerJobAcquisitionEnabled() {
        return isAsyncHistoryExecutorTimerJobAcquisitionEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorTimerJobAcquisitionEnabled(bool isAsyncHistoryExecutorTimerJobAcquisitionEnabled) {
        this.isAsyncHistoryExecutorTimerJobAcquisitionEnabled = isAsyncHistoryExecutorTimerJobAcquisitionEnabled;
        return this;
    }

    public bool isAsyncHistoryExecutorResetExpiredJobsEnabled() {
        return isAsyncHistoryExecutorResetExpiredJobsEnabled;
    }

    public ProcessEngineConfigurationImpl setAsyncHistoryExecutorResetExpiredJobsEnabled(bool isAsyncHistoryExecutorResetExpiredJobsEnabled) {
        this.isAsyncHistoryExecutorResetExpiredJobsEnabled = isAsyncHistoryExecutorResetExpiredJobsEnabled;
        return this;
    }

    public JobServiceConfiguration getJobServiceConfiguration() {
        return jobServiceConfiguration;
    }

    public ProcessEngineConfigurationImpl setJobServiceConfiguration(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
        return this;
    }

    public string getAsyncExecutorTenantId() {
        return asyncExecutorTenantId;
    }

    public void setAsyncExecutorTenantId(string asyncExecutorTenantId) {
        this.asyncExecutorTenantId = asyncExecutorTenantId;
    }

    public string getBatchStatusTimeCycleConfig() {
        return batchStatusTimeCycleConfig;
    }

    public void setBatchStatusTimeCycleConfig(string batchStatusTimeCycleConfig) {
        this.batchStatusTimeCycleConfig = batchStatusTimeCycleConfig;
    }

}
