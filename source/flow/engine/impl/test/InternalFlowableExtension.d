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
//import static flow.engine.impl.test.TestHelper.EMPTY_LINE;
//
//import java.util.Arrays;
//import hunt.collection.HashSet;
//import hunt.collection.List;
//import hunt.collection.Map;
//import hunt.collection.Set;
//
//import flow.common.api.FlowableOptimisticLockingException;
//import flow.common.db.SchemaManager;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandConfig;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandExecutor;
//import flow.common.test.CleanTest;
//import flow.common.test.EnsureCleanDb;
//import flow.engine.ManagementService;
//import flow.engine.ProcessEngine;
//import flow.engine.ProcessEngineConfiguration;
//import flow.engine.RepositoryService;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.history.DefaultHistoryManager;
//import flow.engine.impl.history.HistoryManager;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.test.Deployment;
//import flow.engine.test.DeploymentId;
//import flow.job.service.api.HistoryJob;
//import org.junit.jupiter.api.TestInstance;
//import org.junit.jupiter.api.extension.AfterAllCallback;
//import org.junit.jupiter.api.extension.AfterEachCallback;
//import org.junit.jupiter.api.extension.BeforeEachCallback;
//import org.junit.jupiter.api.extension.ExtensionContext;
//import org.junit.jupiter.api.extension.ParameterContext;
//import org.junit.jupiter.api.extension.ParameterResolver;
//import org.junit.platform.commons.support.AnnotationSupport;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * Base internal extension for JUnit Jupiter. This is a basis for other internal extensions. It allows:
// * <ul>
// *     <li>
// *         Performs a deployment before each test when a test method is annotated with {@link Deployment}
// *     </li>
// *     <li>
// *         Validates the history data after each test
// *     </li>
// *     <li>
// *         Delete history jobs and deployment after each test
// *     </li>
// *     <li>
// *         Assert and ensure a clean db after each test or after all tests (depending on the {@link TestInstance.Lifecycle}.
// *     </li>
// *     <li>
// *         Support for injecting the {@link ProcessEngine}, services, {@link ProcessEngineConfiguration} and the id of the deployment done via
// *         {@link Deployment} into test methods and lifecycle methods within tests.
// *     </li>
// * </ul>
// * @author Filip Hrisafov
// */
//abstract class InternalFlowableExtension implements AfterEachCallback, BeforeEachCallback, AfterAllCallback, ParameterResolver {
//
//    protected static final string ANNOTATION_DEPLOYMENT_ID_KEY = "deploymentIdFromDeploymentAnnotation";
//
//    protected final Logger logger = LoggerFactory.getLogger(getClass());
//
//    override
//    public void beforeEach(ExtensionContext context) {
//        ProcessEngine processEngine = getProcessEngine(context);
//
//        AnnotationSupport.findAnnotation(context.getTestMethod(), Deployment.class)
//            .ifPresent(deployment -> {
//                string deploymentIdFromDeploymentAnnotation = TestHelper
//                    .annotationDeploymentSetUp(processEngine, context.getRequiredTestClass(), context.getRequiredTestMethod(), deployment);
//                getStore(context).put(context.getUniqueId() + ANNOTATION_DEPLOYMENT_ID_KEY, deploymentIdFromDeploymentAnnotation);
//            });
//    }
//
//    override
//    public void afterEach(ExtensionContext context) throws Exception {
//        ProcessEngine processEngine = getProcessEngine(context);
//
//        // Always reset authenticated user to avoid any mistakes
//        processEngine.getIdentityService().setAuthenticatedUserId(null);
//
//        try {
//            AbstractFlowableTestCase.validateHistoryData(processEngine);
//        } finally {
//            doFinally(context, TestInstance.Lifecycle.PER_METHOD);
//        }
//    }
//
//    override
//    public void afterAll(ExtensionContext context) throws Exception {
//        doFinally(context, TestInstance.Lifecycle.PER_CLASS);
//    }
//
//    protected void doFinally(ExtensionContext context, TestInstance.Lifecycle lifecycleForClean) {
//        ProcessEngine processEngine = getProcessEngine(context);
//        ProcessEngineConfigurationImpl processEngineConfiguration = (ProcessEngineConfigurationImpl) processEngine.getProcessEngineConfiguration();
//        bool isAsyncHistoryEnabled = processEngineConfiguration.isAsyncHistoryEnabled();
//
//        if (isAsyncHistoryEnabled) {
//            ManagementService managementService = processEngine.getManagementService();
//            List!HistoryJob jobs = managementService.createHistoryJobQuery().list();
//            for (HistoryJob job : jobs) {
//                managementService.deleteHistoryJob(job.getId());
//            }
//        }
//
//        HistoryManager asyncHistoryManager = null;
//        try {
//            if (isAsyncHistoryEnabled) {
//                processEngineConfiguration.setAsyncHistoryEnabled(false);
//                asyncHistoryManager = processEngineConfiguration.getHistoryManager();
//                processEngineConfiguration
//                    .setHistoryManager(new DefaultHistoryManager(processEngineConfiguration,
//                            processEngineConfiguration.getHistoryLevel(), processEngineConfiguration.isUsePrefixId()));
//            }
//
//            string annotationDeploymentKey = context.getUniqueId() + ANNOTATION_DEPLOYMENT_ID_KEY;
//            string deploymentIdFromDeploymentAnnotation = getStore(context).get(annotationDeploymentKey, string.class);
//            if (deploymentIdFromDeploymentAnnotation !is null) {
//                TestHelper.annotationDeploymentTearDown(processEngine, deploymentIdFromDeploymentAnnotation, context.getRequiredTestClass(),
//                    context.getRequiredTestMethod().getName());
//                getStore(context).remove(annotationDeploymentKey);
//            }
//
//            AnnotationSupport.findAnnotation(context.getTestMethod(), CleanTest.class)
//                .ifPresent(cleanTest -> removeDeployments(processEngine.getRepositoryService()));
//
//            AbstractFlowableTestCase.cleanDeployments(processEngine);
//
//            if (context.getTestInstanceLifecycle().orElse(TestInstance.Lifecycle.PER_METHOD) == lifecycleForClean
//                    && processEngineConfiguration.isUsingRelationalDatabase()) { // the logic only is applicable to a relational database with tables
//                cleanTestAndAssertAndEnsureCleanDb(context, processEngine);
//            }
//
//        } finally {
//
//            if (isAsyncHistoryEnabled) {
//                processEngineConfiguration.setAsyncHistoryEnabled(true);
//                processEngineConfiguration.setHistoryManager(asyncHistoryManager);
//            }
//
//            processEngineConfiguration.getClock().reset();
//        }
//    }
//
//    protected void cleanTestAndAssertAndEnsureCleanDb(ExtensionContext context, ProcessEngine processEngine) {
//        AnnotationSupport.findAnnotation(context.getRequiredTestClass(), CleanTest.class)
//            .ifPresent(cleanTest -> removeDeployments(getProcessEngine(context).getRepositoryService()));
//        AnnotationSupport.findAnnotation(context.getRequiredTestClass(), EnsureCleanDb.class)
//            .ifPresent(ensureCleanDb -> assertAndEnsureCleanDb(processEngine, context, ensureCleanDb));
//    }
//
//    /**
//     * Each test is assumed to clean up all DB content it entered. After a test method executed, this method scans all tables to see if the DB is completely clean. It throws AssertionFailed in case
//     * the DB is not clean. If the DB is not clean, it is cleaned by performing a create a drop.
//     */
//    protected void assertAndEnsureCleanDb(ProcessEngine processEngine, ExtensionContext context, EnsureCleanDb ensureCleanDb) {
//        logger.debug("verifying that db is clean after test");
//        Set!string tableNamesExcludedFromDbCleanCheck = new HashSet<>(Arrays.asList(ensureCleanDb.excludeTables()));
//        ManagementService managementService = processEngine.getManagementService();
//        ProcessEngineConfiguration processEngineConfiguration = processEngine.getProcessEngineConfiguration();
//        Map!(string, Long) tableCounts = managementService.getTableCount();
//        StringBuilder outputMessage = new StringBuilder();
//        for (string tableName : tableCounts.keySet()) {
//            string tableNameWithoutPrefix = tableName.replace(processEngineConfiguration.getDatabaseTablePrefix(), "");
//            if (!tableNamesExcludedFromDbCleanCheck.contains(tableNameWithoutPrefix)) {
//                Long count = tableCounts.get(tableName);
//                if (count != 0L) {
//                    outputMessage.append("  ").append(tableName).append(": ").append(count).append(" record(s) ");
//                }
//            }
//        }
//        if (outputMessage.length() > 0) {
//            outputMessage.insert(0, "DB NOT CLEAN: \n");
//            logger.error(EMPTY_LINE);
//            logger.error(outputMessage.toString());
//
//            logger.info("dropping and recreating db");
//
//            if (ensureCleanDb.dropDb()) {
//                CommandExecutor commandExecutor = processEngineConfiguration.getCommandExecutor();
//                CommandConfig config = new CommandConfig().transactionNotSupported();
//                commandExecutor.execute(config, new Command!Object() {
//
//                    override
//                    public Object execute(CommandContext commandContext) {
//                        SchemaManager schemaManager = CommandContextUtil.getProcessEngineConfiguration(commandContext).getSchemaManager();
//                        schemaManager.schemaDrop();
//                        schemaManager.schemaCreate();
//                        return null;
//                    }
//                });
//            }
//
//            if (!context.getExecutionException().isPresent()) {
//                throw new AssertionError(outputMessage.toString());
//            }
//        } else {
//            logger.info("database was clean");
//        }
//    }
//
//    protected void removeDeployments(RepositoryService repositoryService) {
//        for (flow.engine.repository.Deployment deployment : repositoryService.createDeploymentQuery().list()) {
//            try {
//                repositoryService.deleteDeployment(deployment.getId(), true);
//            } catch (FlowableOptimisticLockingException flowableOptimisticLockingException) {
//                logger.warn("Caught exception, retrying", flowableOptimisticLockingException);
//                repositoryService.deleteDeployment(deployment.getId(), true);
//            }
//        }
//    }
//
//    override
//    public bool supportsParameter(ParameterContext parameterContext, ExtensionContext context) {
//        Class<?> parameterType = parameterContext.getParameter().getType();
//        return ProcessEngine.class.equals(parameterType) || parameterContext.isAnnotated(DeploymentId.class);
//    }
//
//    override
//    public Object resolveParameter(ParameterContext parameterContext, ExtensionContext context) {
//        if (parameterContext.isAnnotated(DeploymentId.class)) {
//            return getStore(context).get(context.getUniqueId() + ANNOTATION_DEPLOYMENT_ID_KEY, string.class);
//        }
//        return getProcessEngine(context);
//    }
//
//    protected abstract ProcessEngine getProcessEngine(ExtensionContext context);
//
//    protected abstract ExtensionContext.Store getStore(ExtensionContext context);
//}
