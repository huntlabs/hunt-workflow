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

module flow.engine.ProcessEngineConfiguration;

//import java.io.InputStream;
//import hunt.collection.ArrayList;
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import javax.sql.DataSource;
import hunt.collection.Map;
import flow.common.api.engine.EngineLifecycleListener;
import flow.common.AbstractEngineConfiguration;
import flow.common.cfg.BeansConfigurationHelper;
import flow.common.history.HistoryLevel;
import flow.common.runtime.Clockm;
import flow.engine.cfg.HttpClientConfig;
import flow.engine.impl.cfg.StandaloneInMemProcessEngineConfiguration;
import flow.engine.impl.cfg.StandaloneProcessEngineConfiguration;
//import org.flowable.image.ProcessDiagramGenerator;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import flow.task.service.TaskPostProcessor;
import flow.engine.ProcessEngines;
import flow.engine.ProcessEngine;
import hunt.Exceptions;
import hunt.stream.Common;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.FormService;
import flow.engine.TaskService;
import flow.engine.ManagementService;
import flow.engine.IdentityService;
import flow.engine.HistoryService;
import flow.engine.ProcessEngineLifecycleListener;
/**
 * Configuration information from which a process engine can be build.
 *
 * <p>
 * Most common is to create a process engine based on the default configuration file:
 *
 * <pre>
 * ProcessEngine processEngine = ProcessEngineConfiguration.createProcessEngineConfigurationFromResourceDefault().buildProcessEngine();
 * </pre>
 *
 * </p>
 *
 * <p>
 * To create a process engine programmatic, without a configuration file, the first option is {@link #createStandaloneProcessEngineConfiguration()}
 *
 * <pre>
 * ProcessEngine processEngine = ProcessEngineConfiguration.createStandaloneProcessEngineConfiguration().buildProcessEngine();
 * </pre>
 *
 * This creates a new process engine with all the defaults to connect to a remote h2 database (jdbc:h2:tcp://localhost/flowable) in standalone mode. Standalone mode means that the process engine will
 * manage the transactions on the JDBC connections that it creates. One transaction per service method. For a description of how to write the configuration files, see the userguide.
 * </p>
 *
 * <p>
 * The second option is great for testing: {@link #createStandaloneInMemProcessEngineConfiguration()}
 *
 * <pre>
 * ProcessEngine processEngine = ProcessEngineConfiguration.createStandaloneInMemProcessEngineConfiguration().buildProcessEngine();
 * </pre>
 *
 * This creates a new process engine with all the defaults to connect to an memory h2 database (jdbc:h2:tcp://localhost/flowable) in standalone mode. The DB schema strategy default is in this case
 * <code>create-drop</code>. Standalone mode means that Flowable will manage the transactions on the JDBC connections that it creates. One transaction per service method.
 * </p>
 *
 * <p>
 * On all forms of creating a process engine, you can first customize the configuration before calling the {@link #buildProcessEngine()} method by calling any of the setters like this:
 *
 * <pre>
 * ProcessEngine processEngine = ProcessEngineConfiguration.createProcessEngineConfigurationFromResourceDefault().setMailServerHost(&quot;gmail.com&quot;).setJdbcUsername(&quot;mickey&quot;).setJdbcPassword(&quot;mouse&quot;)
 *         .buildProcessEngine();
 * </pre>
 *
 * </p>
 *
 * @see ProcessEngines
 * @author Tom Baeyens
 */
 class ProcessEngineConfiguration : AbstractEngineConfiguration {

    protected string processEngineName = ProcessEngines.NAME_DEFAULT;
    protected int idBlockSize = 2500;
    protected string history ;
    protected bool asyncExecutorActivate;
    protected bool asyncHistoryExecutorActivate;

    protected string mailServerHost = "localhost";
    protected string mailServerUsername; // by default no name and password are provided, which
    protected string mailServerPassword; // means no authentication for mail server
    protected int mailServerPort = 25;
    protected bool useSSL;
    protected bool useTLS;
    protected string mailServerDefaultFrom = "flowable@localhost";
    protected string mailServerForceTo;
    protected string mailSessionJndi;
    //protected Map!(string, MailServerInfo) mailServers = new HashMap<>();
    //protected Map!(string, string) mailSessionsJndi = new HashMap<>();

    // Set Http Client config defaults
    protected HttpClientConfig httpClientConfig;// = new HttpClientConfig();

    protected HistoryLevel historyLevel;
    protected bool enableProcessDefinitionHistoryLevel;

    protected string jpaPersistenceUnitName;
    protected Object jpaEntityManagerFactory;
    protected bool jpaHandleTransaction;
    protected bool jpaCloseEntityManager;

    protected AsyncExecutor asyncExecutor;
    protected AsyncExecutor asyncHistoryExecutor;
    /**
     * Define the default lock time for an async job in seconds.


    protected ProcessEngineLifecycleListener processEngineLife The lock time is used when creating an async job and when it expires the async executor assumes that the job has failed. It will be
     * retried again.
     */
    protected int lockTimeAsyncJobWaitTime = 60;
    /** define the default wait time for a failed job in seconds */
    protected int defaultFailedJobWaitTime = 10;
    /** define the default wait time for a failed async job in seconds */
    protected int asyncFailedJobWaitTime = 10;

    /**
     * Process diagram generator. Default value is DefaultProcessDiagramGenerator
     */
   // protected ProcessDiagramGenerator processDiagramGenerator;

    protected bool isCreateDiagramOnDeploy = true;

    /**
     *  include the sequence flow name in case there's no Label DI,
     */
    protected bool drawSequenceFlowNameWithNoLabelDI = false;

    protected string defaultCamelContext = "camelContext";

    protected string activityFontName = "Arial";
    protected string labelFontName = "Arial";
    protected string annotationFontName = "Arial";

    protected bool enableProcessDefinitionInfoCache;

    // History Cleanup
    protected bool enableHistoryCleaning = false;
    protected string historyCleaningTimeCycleConfig = "0 0 1 * * ?";
    protected int cleanInstancesEndedAfterNumberOfDays = 365;
   // protected HistoryCleaningManager historyCleaningManager;
    protected ProcessEngineLifecycleListener processEngineLifecycleListener;

    /** postprocessor for a task builder */
    //protected TaskPostProcessor taskPostProcessor = null;

    /** use one of the static createXxxx methods instead */
    this() {
        this.history =  HistoryLevel.AUDIT.getKey();
        this.httpClientConfig =  new HttpClientConfig();
    }

    abstract ProcessEngine buildProcessEngine();

    public static ProcessEngineConfiguration createProcessEngineConfigurationFromResourceDefault() {
        return createProcessEngineConfigurationFromResource("flowable.cfg.xml", "processEngineConfiguration");
    }

    public static ProcessEngineConfiguration createProcessEngineConfigurationFromResource(string resource) {
        return createProcessEngineConfigurationFromResource(resource, "processEngineConfiguration");
    }

    public static ProcessEngineConfiguration createProcessEngineConfigurationFromResource(string resource, string beanName) {
      //  return cast(ProcessEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromResource(resource, beanName);
        implementationMissing(false);
        return null;
    }

    public static ProcessEngineConfiguration createProcessEngineConfigurationFromInputStream(InputStream inputStream) {
        return createProcessEngineConfigurationFromInputStream(inputStream, "processEngineConfiguration");
    }

    public static ProcessEngineConfiguration createProcessEngineConfigurationFromInputStream(InputStream inputStream, string beanName) {
        //return (ProcessEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromInputStream(inputStream, beanName);
        implementationMissing(false);
        return null;
    }

    public static ProcessEngineConfiguration createStandaloneProcessEngineConfiguration() {
        return new StandaloneProcessEngineConfiguration();
    }

    public static ProcessEngineConfiguration createStandaloneInMemProcessEngineConfiguration() {
        return new StandaloneInMemProcessEngineConfiguration();
    }

    public ProcessEngineConfiguration setProcessEngineLifecycleListener(ProcessEngineLifecycleListener processEngineLifecycleListener) {
        this.processEngineLifecycleListener = processEngineLifecycleListener;
        return this;
    }

    public ProcessEngineLifecycleListener getProcessEngineLifecycleListener() {
        return this.processEngineLifecycleListener;
    }

    // TODO add later when we have test coverage for this
    // public static ProcessEngineConfiguration
    // createJtaProcessEngineConfiguration() {
    // return new JtaProcessEngineConfiguration();
    // }

    abstract RepositoryService getRepositoryService();

    abstract RuntimeService getRuntimeService();

    abstract FormService getFormService();

    abstract TaskService getTaskService();

    abstract HistoryService getHistoryService();

    abstract IdentityService getIdentityService();

    abstract ManagementService getManagementService();

    abstract ProcessEngineConfiguration getProcessEngineConfiguration();

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public string getEngineName() {
        return processEngineName;
    }

    public ProcessEngineConfiguration setEngineName(string processEngineName) {
        this.processEngineName = processEngineName;
        return this;
    }

    public int getIdBlockSize() {
        return idBlockSize;
    }

    public ProcessEngineConfiguration setIdBlockSize(int idBlockSize) {
        this.idBlockSize = idBlockSize;
        return this;
    }

    public string getHistory() {
        return history;
    }

    public ProcessEngineConfiguration setHistory(string history) {
        this.history = history;
        return this;
    }

    public string getMailServerHost() {
        return mailServerHost;
    }

    public ProcessEngineConfiguration setMailServerHost(string mailServerHost) {
        this.mailServerHost = mailServerHost;
        return this;
    }

    public string getMailServerUsername() {
        return mailServerUsername;
    }

    public ProcessEngineConfiguration setMailServerUsername(string mailServerUsername) {
        this.mailServerUsername = mailServerUsername;
        return this;
    }

    public string getMailServerPassword() {
        return mailServerPassword;
    }

    public ProcessEngineConfiguration setMailServerPassword(string mailServerPassword) {
        this.mailServerPassword = mailServerPassword;
        return this;
    }

    public string getMailSessionJndi() {
        return mailSessionJndi;
    }

    public ProcessEngineConfiguration setMailSessionJndi(string mailSessionJndi) {
        this.mailSessionJndi = mailSessionJndi;
        return this;
    }

    public int getMailServerPort() {
        return mailServerPort;
    }

    public ProcessEngineConfiguration setMailServerPort(int mailServerPort) {
        this.mailServerPort = mailServerPort;
        return this;
    }

    public bool getMailServerUseSSL() {
        return useSSL;
    }

    public ProcessEngineConfiguration setMailServerUseSSL(bool useSSL) {
        this.useSSL = useSSL;
        return this;
    }

    public bool getMailServerUseTLS() {
        return useTLS;
    }

    public ProcessEngineConfiguration setMailServerUseTLS(bool useTLS) {
        this.useTLS = useTLS;
        return this;
    }

    public string getMailServerDefaultFrom() {
        return mailServerDefaultFrom;
    }

    public ProcessEngineConfiguration setMailServerDefaultFrom(string mailServerDefaultFrom) {
        this.mailServerDefaultFrom = mailServerDefaultFrom;
        return this;
    }

    public string getMailServerForceTo() {
        return mailServerForceTo;
    }

    public ProcessEngineConfiguration setMailServerForceTo(string mailServerForceTo) {
        this.mailServerForceTo = mailServerForceTo;
        return this;
    }

    //public MailServerInfo getMailServer(string tenantId) {
    //    return mailServers.get(tenantId);
    //}
    //
    //public Map!(string, MailServerInfo) getMailServers() {
    //    return mailServers;
    //}
    //
    //public ProcessEngineConfiguration setMailServers(Map!(string, MailServerInfo) mailServers) {
    //    this.mailServers.putAll(mailServers);
    //    return this;
    //}
    //
    //public string getMailSessionJndi(string tenantId) {
    //    return mailSessionsJndi.get(tenantId);
    //}
    //
    //public Map!(string, string) getMailSessionsJndi() {
    //    return mailSessionsJndi;
    //}
    //
    //public ProcessEngineConfiguration setMailSessionsJndi(Map!(string, string) mailSessionsJndi) {
    //    this.mailSessionsJndi.putAll(mailSessionsJndi);
    //    return this;
    //}

    public HttpClientConfig getHttpClientConfig() {
        return httpClientConfig;
    }

    public void setHttpClientConfig(HttpClientConfig httpClientConfig) {
        this.httpClientConfig.merge(httpClientConfig);
    }

    override
    public ProcessEngineConfiguration setDatabaseType(string databaseType) {
        this.databaseType = databaseType;
        return this;
    }

    override
    public ProcessEngineConfiguration setDatabaseSchemaUpdate(string databaseSchemaUpdate) {
        this.databaseSchemaUpdate = databaseSchemaUpdate;
        return this;
    }

    //override
    //public ProcessEngineConfiguration setDataSource(DataSource dataSource) {
    //    this.dataSource = dataSource;
    //    return this;
    //}

    override
    public ProcessEngineConfiguration setJdbcDriver(string jdbcDriver) {
        this.jdbcDriver = jdbcDriver;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcUrl(string jdbcUrl) {
        this.jdbcUrl = jdbcUrl;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcUsername(string jdbcUsername) {
        this.jdbcUsername = jdbcUsername;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcPassword(string jdbcPassword) {
        this.jdbcPassword = jdbcPassword;
        return this;
    }

    override
    public ProcessEngineConfiguration setTransactionsExternallyManaged(bool transactionsExternallyManaged) {
        this.transactionsExternallyManaged = transactionsExternallyManaged;
        return this;
    }

    public HistoryLevel getHistoryLevel() {
        return historyLevel;
    }

    public ProcessEngineConfiguration setHistoryLevel(HistoryLevel historyLevel) {
        this.historyLevel = historyLevel;
        return this;
    }

    public bool isEnableProcessDefinitionHistoryLevel() {
        return enableProcessDefinitionHistoryLevel;
    }

    public ProcessEngineConfiguration setEnableProcessDefinitionHistoryLevel(bool enableProcessDefinitionHistoryLevel) {
        this.enableProcessDefinitionHistoryLevel = enableProcessDefinitionHistoryLevel;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcMaxActiveConnections(int jdbcMaxActiveConnections) {
        this.jdbcMaxActiveConnections = jdbcMaxActiveConnections;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcMaxIdleConnections(int jdbcMaxIdleConnections) {
        this.jdbcMaxIdleConnections = jdbcMaxIdleConnections;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcMaxCheckoutTime(int jdbcMaxCheckoutTime) {
        this.jdbcMaxCheckoutTime = jdbcMaxCheckoutTime;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcMaxWaitTime(int jdbcMaxWaitTime) {
        this.jdbcMaxWaitTime = jdbcMaxWaitTime;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcPingEnabled(bool jdbcPingEnabled) {
        this.jdbcPingEnabled = jdbcPingEnabled;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcPingQuery(string jdbcPingQuery) {
        this.jdbcPingQuery = jdbcPingQuery;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcPingConnectionNotUsedFor(int jdbcPingNotUsedFor) {
        this.jdbcPingConnectionNotUsedFor = jdbcPingNotUsedFor;
        return this;
    }

    override
    public ProcessEngineConfiguration setJdbcDefaultTransactionIsolationLevel(int jdbcDefaultTransactionIsolationLevel) {
        this.jdbcDefaultTransactionIsolationLevel = jdbcDefaultTransactionIsolationLevel;
        return this;
    }

    public bool isAsyncExecutorActivate() {
        return asyncExecutorActivate;
    }

    public ProcessEngineConfiguration setAsyncExecutorActivate(bool asyncExecutorActivate) {
        this.asyncExecutorActivate = asyncExecutorActivate;
        return this;
    }

    public bool isAsyncHistoryExecutorActivate() {
        return asyncHistoryExecutorActivate;
    }

    public ProcessEngineConfiguration setAsyncHistoryExecutorActivate(bool asyncHistoryExecutorActivate) {
        this.asyncHistoryExecutorActivate = asyncHistoryExecutorActivate;
        return this;
    }

    //override
    //public ProcessEngineConfiguration setClassLoader(ClassLoader classLoader) {
    //    this.classLoader = classLoader;
    //    return this;
    //}

    override
    public ProcessEngineConfiguration setUseClassForNameClassLoading(bool useClassForNameClassLoading) {
        this.useClassForNameClassLoading = useClassForNameClassLoading;
        return this;
    }

    public Object getJpaEntityManagerFactory() {
        return jpaEntityManagerFactory;
    }

    public ProcessEngineConfiguration setJpaEntityManagerFactory(Object jpaEntityManagerFactory) {
        this.jpaEntityManagerFactory = jpaEntityManagerFactory;
        return this;
    }

    public bool isJpaHandleTransaction() {
        return jpaHandleTransaction;
    }

    public ProcessEngineConfiguration setJpaHandleTransaction(bool jpaHandleTransaction) {
        this.jpaHandleTransaction = jpaHandleTransaction;
        return this;
    }

    public bool isJpaCloseEntityManager() {
        return jpaCloseEntityManager;
    }

    public ProcessEngineConfiguration setJpaCloseEntityManager(bool jpaCloseEntityManager) {
        this.jpaCloseEntityManager = jpaCloseEntityManager;
        return this;
    }

    public string getJpaPersistenceUnitName() {
        return jpaPersistenceUnitName;
    }

    public ProcessEngineConfiguration setJpaPersistenceUnitName(string jpaPersistenceUnitName) {
        this.jpaPersistenceUnitName = jpaPersistenceUnitName;
        return this;
    }

    override
    public ProcessEngineConfiguration setDataSourceJndiName(string dataSourceJndiName) {
        this.dataSourceJndiName = dataSourceJndiName;
        return this;
    }

    public string getDefaultCamelContext() {
        return defaultCamelContext;
    }

    public ProcessEngineConfiguration setDefaultCamelContext(string defaultCamelContext) {
        this.defaultCamelContext = defaultCamelContext;
        return this;
    }

    public bool isCreateDiagramOnDeploy() {
        return isCreateDiagramOnDeploy;
    }

    public ProcessEngineConfiguration setCreateDiagramOnDeploy(bool createDiagramOnDeploy) {
        this.isCreateDiagramOnDeploy = createDiagramOnDeploy;
        return this;
    }

    public bool isDrawSequenceFlowNameWithNoLabelDI() {
        return drawSequenceFlowNameWithNoLabelDI;
    }

    public ProcessEngineConfiguration setDrawSequenceFlowNameWithNoLabelDI(bool drawSequenceFlowNameWithNoLabelDI) {
        this.drawSequenceFlowNameWithNoLabelDI = drawSequenceFlowNameWithNoLabelDI;
        return this;
    }

    public string getActivityFontName() {
        return activityFontName;
    }

    public ProcessEngineConfiguration setActivityFontName(string activityFontName) {
        this.activityFontName = activityFontName;
        return this;
    }

    /**
     * @deprecated Use {@link #setEngineLifecycleListeners(List)}.
     */
    //@Deprecated
    //public ProcessEngineConfiguration setProcessEngineLifecycleListener(ProcessEngineLifecycleListener processEngineLifecycleListener) {
    //    // Backwards compatibility (when there was only one typed engine listener)
    //    if (engineLifecycleListeners is null || engineLifecycleListeners.isEmpty()) {
    //        List!EngineLifecycleListener engineLifecycleListeners = new ArrayList<>(1);
    //        engineLifecycleListeners.add(processEngineLifecycleListener);
    //        super.setEngineLifecycleListeners(engineLifecycleListeners);
    //
    //    } else {
    //        ProcessEngineLifecycleListener originalEngineLifecycleListener = (ProcessEngineLifecycleListener) engineLifecycleListeners.get(0);
    //
    //        ProcessEngineLifecycleListener wrappingEngineLifecycleListener = new ProcessEngineLifecycleListener() {
    //
    //            override
    //            public void onProcessEngineBuilt(ProcessEngine processEngine) {
    //                originalEngineLifecycleListener.onProcessEngineBuilt(processEngine);
    //            }
    //            override
    //            public void onProcessEngineClosed(ProcessEngine processEngine) {
    //                originalEngineLifecycleListener.onProcessEngineClosed(processEngine);
    //            }
    //        };
    //
    //        engineLifecycleListeners.set(0, wrappingEngineLifecycleListener);
    //
    //    }
    //
    //    return this;
    //}
    //
    ///**
    // * @deprecated Use {@link #getEngineLifecycleListeners()}.
    // */
    //@Deprecated
    //public ProcessEngineLifecycleListener getProcessEngineLifecycleListener() {
    //    // Backwards compatibility (when there was only one typed engine listener)
    //    if (engineLifecycleListeners !is null && !engineLifecycleListeners.isEmpty()) {
    //        return (ProcessEngineLifecycleListener) engineLifecycleListeners.get(0);
    //    }
    //    return null;
    //}

    public string getLabelFontName() {
        return labelFontName;
    }

    public ProcessEngineConfiguration setLabelFontName(string labelFontName) {
        this.labelFontName = labelFontName;
        return this;
    }

    public string getAnnotationFontName() {
        return annotationFontName;
    }

    public ProcessEngineConfiguration setAnnotationFontName(string annotationFontName) {
        this.annotationFontName = annotationFontName;
        return this;
    }

    override
    public ProcessEngineConfiguration setDatabaseTablePrefix(string databaseTablePrefix) {
        this.databaseTablePrefix = databaseTablePrefix;
        return this;
    }

    override
    public ProcessEngineConfiguration setTablePrefixIsSchema(bool tablePrefixIsSchema) {
        this.tablePrefixIsSchema = tablePrefixIsSchema;
        return this;
    }

    override
    public ProcessEngineConfiguration setDatabaseWildcardEscapeCharacter(string databaseWildcardEscapeCharacter) {
        this.databaseWildcardEscapeCharacter = databaseWildcardEscapeCharacter;
        return this;
    }

    override
    public ProcessEngineConfiguration setDatabaseCatalog(string databaseCatalog) {
        this.databaseCatalog = databaseCatalog;
        return this;
    }

    override
    public ProcessEngineConfiguration setDatabaseSchema(string databaseSchema) {
        this.databaseSchema = databaseSchema;
        return this;
    }

    override
    public ProcessEngineConfiguration setXmlEncoding(string xmlEncoding) {
        this.xmlEncoding = xmlEncoding;
        return this;
    }

    override
    public ProcessEngineConfiguration setClock(Clockm clock) {
        this.clock = clock;
        return this;
    }

    //public ProcessDiagramGenerator getProcessDiagramGenerator() {
    //    return this.processDiagramGenerator;
    //}
    //
    //public ProcessEngineConfiguration setProcessDiagramGenerator(ProcessDiagramGenerator processDiagramGenerator) {
    //    this.processDiagramGenerator = processDiagramGenerator;
    //    return this;
    //}

    public AsyncExecutor getAsyncExecutor() {
        return asyncExecutor;
    }

    public ProcessEngineConfiguration setAsyncExecutor(AsyncExecutor asyncExecutor) {
        this.asyncExecutor = asyncExecutor;
        return this;
    }

    public AsyncExecutor getAsyncHistoryExecutor() {
        return asyncHistoryExecutor;
    }

    public ProcessEngineConfiguration setAsyncHistoryExecutor(AsyncExecutor asyncHistoryExecutor) {
        this.asyncHistoryExecutor = asyncHistoryExecutor;
        return this;
    }

    public int getLockTimeAsyncJobWaitTime() {
        return lockTimeAsyncJobWaitTime;
    }

    public ProcessEngineConfiguration setLockTimeAsyncJobWaitTime(int lockTimeAsyncJobWaitTime) {
        this.lockTimeAsyncJobWaitTime = lockTimeAsyncJobWaitTime;
        return this;
    }

    public int getDefaultFailedJobWaitTime() {
        return defaultFailedJobWaitTime;
    }

    public ProcessEngineConfiguration setDefaultFailedJobWaitTime(int defaultFailedJobWaitTime) {
        this.defaultFailedJobWaitTime = defaultFailedJobWaitTime;
        return this;
    }

    public int getAsyncFailedJobWaitTime() {
        return asyncFailedJobWaitTime;
    }

    public ProcessEngineConfiguration setAsyncFailedJobWaitTime(int asyncFailedJobWaitTime) {
        this.asyncFailedJobWaitTime = asyncFailedJobWaitTime;
        return this;
    }

    public bool isEnableProcessDefinitionInfoCache() {
        return enableProcessDefinitionInfoCache;
    }

    public ProcessEngineConfiguration setEnableProcessDefinitionInfoCache(bool enableProcessDefinitionInfoCache) {
        this.enableProcessDefinitionInfoCache = enableProcessDefinitionInfoCache;
        return this;
    }

    //public TaskPostProcessor getTaskPostProcessor() {
    //    return taskPostProcessor;
    //}
    //
    //public void setTaskPostProcessor(TaskPostProcessor processor) {
    //    this.taskPostProcessor = processor;
    //}


    public bool isEnableHistoryCleaning() {
        return enableHistoryCleaning;
    }

    public ProcessEngineConfiguration setEnableHistoryCleaning(bool enableHistoryCleaning) {
        this.enableHistoryCleaning = enableHistoryCleaning;
        return this;
    }

    public string getHistoryCleaningTimeCycleConfig() {
        return historyCleaningTimeCycleConfig;
    }

    public ProcessEngineConfiguration setHistoryCleaningTimeCycleConfig(string historyCleaningTimeCycleConfig) {
        this.historyCleaningTimeCycleConfig = historyCleaningTimeCycleConfig;
        return this;
    }

    public int getCleanInstancesEndedAfterNumberOfDays() {
        return cleanInstancesEndedAfterNumberOfDays;
    }

    public ProcessEngineConfiguration setCleanInstancesEndedAfterNumberOfDays(int cleanInstancesEndedAfterNumberOfDays) {
        this.cleanInstancesEndedAfterNumberOfDays = cleanInstancesEndedAfterNumberOfDays;
        return this;
    }

    //public HistoryCleaningManager getHistoryCleaningManager() {
    //    return historyCleaningManager;
    //}
    //
    //public ProcessEngineConfiguration setHistoryCleaningManager(HistoryCleaningManager historyCleaningManager) {
    //    this.historyCleaningManager = historyCleaningManager;
    //    return this;
    //}
}
