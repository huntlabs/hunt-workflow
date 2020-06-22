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

module flow.event.registry.EventRegistryEngineConfiguration;



import flow.event.registry.DefaultOutboundEventProcessor;
import flow.event.registry.DefaultInboundEventProcessor;
import flow.event.registry.EventRepositoryServiceImpl;
import flow.event.registry.EventManagementServiceImpl;
import hunt.stream.Common;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;
import hunt.Exceptions;
import flow.common.AbstractEngineConfiguration;
import flow.common.HasExpressionManagerEngineConfiguration;
import flow.common.cfg.BeansConfigurationHelper;
import flow.common.db.DbSqlSessionFactory;
//import flow.common.el.DefaultExpressionManager;
import flow.common.el.ExpressionManager;
import flow.common.interceptor.CommandInterceptor;
import flow.common.interceptor.EngineConfigurationConstants;
//import flow.common.persistence.deploy.DefaultDeploymentCache;
//import flow.common.persistence.deploy.DeploymentCache;
//import flow.common.persistence.deploy.FullDeploymentCache;
import flow.event.registry.api.ChannelModelProcessor;
import flow.event.registry.api.EventManagementService;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRegistryConfigurationApi;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.api.InboundEventProcessor;
import flow.event.registry.api.OutboundEventProcessor;
import flow.event.registry.api.management.EventRegistryChangeDetectionExecutor;
import flow.event.registry.api.management.EventRegistryChangeDetectionManager;
import flow.event.registry.cfg.StandaloneEventRegistryEngineConfiguration;
import flow.event.registry.cfg.StandaloneInMemEventRegistryEngineConfiguration;
import flow.event.registry.DefaultEventRegistry;
//import flow.event.registry.cmd.SchemaOperationsEventRegistryEngineBuild;
//import flow.event.registry.db.EntityDependencyOrder;
//import flow.event.registry.db.EventDbSchemaManager;
//import flow.event.registry.deployer.CachingAndArtifactsManager;
//import flow.event.registry.deployer.ChannelDefinitionDeploymentHelper;
//import flow.event.registry.deployer.EventDefinitionDeployer;
//import flow.event.registry.deployer.EventDefinitionDeploymentHelper;
//import flow.event.registry.deployer.ParsedDeploymentBuilderFactory;
//import flow.event.registry.management.DefaultEventRegistryChangeDetectionExecutor;
//import flow.event.registry.management.DefaultEventRegistryChangeDetectionManager;
//import flow.event.registry.parser.ChannelDefinitionParseFactory;
import flow.event.registry.parser.EventDefinitionParseFactory;
import flow.event.registry.persistence.deploy.ChannelDefinitionCacheEntry;
import flow.event.registry.persistence.deploy.Deployer;
import flow.event.registry.persistence.deploy.EventDefinitionCacheEntry;
//import flow.event.registry.persistence.deploy.EventDeploymentManager;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityManager;
import flow.event.registry.persistence.entity.ChannelDefinitionEntityManagerImpl;
import flow.event.registry.persistence.entity.EventDefinitionEntityManager;
import flow.event.registry.persistence.entity.EventDefinitionEntityManagerImpl;
import flow.event.registry.persistence.entity.EventDeploymentEntityManager;
import flow.event.registry.persistence.entity.EventDeploymentEntityManagerImpl;
import flow.event.registry.persistence.entity.EventResourceEntityManager;
import flow.event.registry.persistence.entity.EventResourceEntityManagerImpl;
import flow.event.registry.persistence.entity.data.ChannelDefinitionDataManager;
import flow.event.registry.persistence.entity.data.EventDefinitionDataManager;
import flow.event.registry.persistence.entity.data.EventDeploymentDataManager;
import flow.event.registry.persistence.entity.data.EventResourceDataManager;
import flow.event.registry.persistence.entity.data.TableDataManager;
import flow.event.registry.persistence.entity.data.impl.MybatisChannelDefinitionDataManager;
import flow.event.registry.persistence.entity.data.impl.MybatisEventDefinitionDataManager;
import flow.event.registry.persistence.entity.data.impl.MybatisEventDeploymentDataManager;
import flow.event.registry.persistence.entity.data.impl.MybatisEventResourceDataManager;
//import flow.event.registry.persistence.entity.data.impl.TableDataManagerImpl;
//import flow.event.registry.pipeline.DelegateExpressionInboundChannelModelProcessor;
//import flow.event.registry.pipeline.DelegateExpressionOutboundChannelModelProcessor;
//import flow.event.registry.pipeline.InboundChannelModelProcessor;
//import flow.event.registry.pipeline.OutboundChannelModelProcessor;
//import flow.event.registry.json.converter.ChannelJsonConverter;
//import flow.event.registry.json.converter.EventJsonConverter;

//import liquibase.Liquibase;
//import liquibase.database.Database;
//import liquibase.exception.DatabaseException;

class EventRegistryEngineConfiguration : AbstractEngineConfiguration
        , EventRegistryConfigurationApi, HasExpressionManagerEngineConfiguration {

    public static  string DEFAULT_MYBATIS_MAPPING_FILE = "org/flowable/eventregistry/db/mapping/mappings.xml";

    public static  string LIQUIBASE_CHANGELOG_PREFIX = "FLW_EV_";

    protected string eventRegistryEngineName = "default";

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected EventRepositoryService eventRepositoryService ;// = new EventRepositoryServiceImpl(this);
    protected EventManagementService eventManagementService ;//= new EventManagementServiceImpl(this);

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected EventDeploymentDataManager deploymentDataManager;
    protected EventDefinitionDataManager eventDefinitionDataManager;
    protected ChannelDefinitionDataManager channelDefinitionDataManager;
    protected EventResourceDataManager resourceDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////
    protected EventDeploymentEntityManager deploymentEntityManager;
    protected EventDefinitionEntityManager eventDefinitionEntityManager;
    protected ChannelDefinitionEntityManager channelDefinitionEntityManager;
    protected EventResourceEntityManager resourceEntityManager;
    protected TableDataManager tableDataManager;

    protected ExpressionManager expressionManager;

   // protected EventJsonConverter eventJsonConverter = new EventJsonConverter();
    //protected ChannelJsonConverter channelJsonConverter = new ChannelJsonConverter();

    // DEPLOYERS
    // ////////////////////////////////////////////////////////////////

    //protected EventDefinitionDeployer eventDeployer;
    //protected EventDefinitionParseFactory eventParseFactory;
    //protected ChannelDefinitionParseFactory channelParseFactory;
    //protected ParsedDeploymentBuilderFactory parsedDeploymentBuilderFactory;
    //protected EventDefinitionDeploymentHelper eventDeploymentHelper;
    //protected ChannelDefinitionDeploymentHelper channelDeploymentHelper;
    //protected CachingAndArtifactsManager cachingAndArtifactsManager;
    protected List!Deployer customPreDeployers;
    protected List!Deployer customPostDeployers;
    protected List!Deployer deployers;
    //protected EventDeploymentManager deploymentManager;

    protected int eventDefinitionCacheLimit = -1; // By default, no limit
   // protected DeploymentCache<EventDefinitionCacheEntry> eventDefinitionCache;
    //protected DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache;

    protected Collection!ChannelModelProcessor channelModelProcessors ;//= new ArrayList<>();

    // Event registry
    protected EventRegistry eventRegistry;
    protected InboundEventProcessor inboundEventProcessor;
    protected OutboundEventProcessor outboundEventProcessor;

    // Change detection
    protected bool enableEventRegistryChangeDetection;
    protected long eventRegistryChangeDetectionInitialDelayInMs = 10000L;
    protected long eventRegistryChangeDetectionDelayInMs = 60000L;
    protected EventRegistryChangeDetectionManager eventRegistryChangeDetectionManager;
    protected EventRegistryChangeDetectionExecutor eventRegistryChangeDetectionExecutor;

    protected bool enableEventRegistryChangeDetectionAfterEngineCreate = true;

    this()
    {
      eventRepositoryService = new EventRepositoryServiceImpl(this);
      eventManagementService = new EventManagementServiceImpl(this);
      channelModelProcessors = new ArrayList!ChannelModelProcessor;
    }

    public static EventRegistryEngineConfiguration createEventRegistryEngineConfigurationFromResourceDefault() {
        return createEventRegistryEngineConfigurationFromResource("flowable.eventregistry.cfg.xml", "eventRegistryEngineConfiguration");
    }

    public static EventRegistryEngineConfiguration createEventRegistryEngineConfigurationFromResource(string resource) {
        return createEventRegistryEngineConfigurationFromResource(resource, "eventRegistryEngineConfiguration");
    }

    public static EventRegistryEngineConfiguration createEventRegistryEngineConfigurationFromResource(string resource, string beanName) {
        implementationMissing(factory);
        return null;
      //  return cast(EventRegistryEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromResource(resource, beanName);
    }

    public static EventRegistryEngineConfiguration createEventRegistryEngineConfigurationFromInputStream(InputStream inputStream) {
        return createEventRegistryEngineConfigurationFromInputStream(inputStream, "eventRegistryEngineConfiguration");
    }

    public static EventRegistryEngineConfiguration createEventRegistryEngineConfigurationFromInputStream(InputStream inputStream, string beanName) {
        implementationMissing(factory);
        return null;
      //return cast(EventRegistryEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromInputStream(inputStream, beanName);
    }

    public static EventRegistryEngineConfiguration createStandaloneEventRegistryEngineConfiguration() {
        return new StandaloneEventRegistryEngineConfiguration();
    }

    public static EventRegistryEngineConfiguration createStandaloneInMemEventRegistryEngineConfiguration() {
        return new StandaloneInMemEventRegistryEngineConfiguration();
    }

    // buildEventRegistryEngine
    // ///////////////////////////////////////////////////////

    //public EventRegistryEngine buildEventRegistryEngine() {
    //    init();
    //    EventRegistryEngineImpl eventRegistryEngine = new EventRegistryEngineImpl(this);
    //
    //    if (enableEventRegistryChangeDetectionAfterEngineCreate) {
    //
    //        eventRegistryEngine.handleDeployedChannelDefinitions();
    //
    //        if (enableEventRegistryChangeDetection) {
    //            eventRegistryChangeDetectionExecutor.initialize();
    //        }
    //    }
    //
    //    return eventRegistryEngine;
    //}

    // init
    // /////////////////////////////////////////////////////////////////////

    protected void init() {
        initEngineConfigurations();
        initConfigurators();
        configuratorsBeforeInit();
        initExpressionManager();
        initCommandContextFactory();
        initTransactionContextFactory();
        initCommandExecutors();
        initIdGenerator();

        if (usingRelationalDatabase) {
            initDataSource();
        }

        if (usingRelationalDatabase || usingSchemaMgmt) {
            initSchemaManager();
            initSchemaManagementCommand();
        }

        initBeans();
        initTransactionFactory();

        if (usingRelationalDatabase) {
            initSqlSessionFactory();
        }

        initSessionFactories();
        initServices();
        configuratorsAfterInit();
        initDataManagers();
        initEntityManagers();
        initEventRegistry();
        initInboundEventProcessor();
        initOutboundEventProcessor();
        initChannelDefinitionProcessors();
        initDeployers();
        initClock();
        initChangeDetectionManager();
        initChangeDetectionExecutor();
    }

    // services
    // /////////////////////////////////////////////////////////////////

    protected void initServices() {
        initService(eventRepositoryService);
        initService(eventManagementService);
    }

    public void initExpressionManager() {
        //if (expressionManager is null) {
        //    expressionManager = new DefaultExpressionManager(beans);
        //}
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    override
    public void initDataManagers() {
        super.initDataManagers();
        if (deploymentDataManager is null) {
            deploymentDataManager = new MybatisEventDeploymentDataManager(this);
        }
        if (eventDefinitionDataManager is null) {
            eventDefinitionDataManager = new MybatisEventDefinitionDataManager(this);
        }
        if (channelDefinitionDataManager is null) {
            channelDefinitionDataManager = new MybatisChannelDefinitionDataManager(this);
        }
        if (resourceDataManager is null) {
            resourceDataManager = new MybatisEventResourceDataManager(this);
        }
    }

    override
    public void initEntityManagers() {
        super.initEntityManagers();
        if (deploymentEntityManager is null) {
            deploymentEntityManager = new EventDeploymentEntityManagerImpl(this, deploymentDataManager);
        }
        if (eventDefinitionEntityManager is null) {
            eventDefinitionEntityManager = new EventDefinitionEntityManagerImpl(this, eventDefinitionDataManager);
        }
        if (channelDefinitionEntityManager is null) {
            channelDefinitionEntityManager = new ChannelDefinitionEntityManagerImpl(this, channelDefinitionDataManager);
        }
        if (resourceEntityManager is null) {
            resourceEntityManager = new EventResourceEntityManagerImpl(this, resourceDataManager);
        }
        //if (tableDataManager is null) {
        //    tableDataManager = new TableDataManagerImpl();
        //}
    }

    // data model ///////////////////////////////////////////////////////////////

    override
    public void initSchemaManager() {
        super.initSchemaManager();
        //if (this.schemaManager is null) {
        //    this.schemaManager = new EventDbSchemaManager();
        //}
    }

    public void initSchemaManagementCommand() {
        if (schemaManagementCmd is null) {
            if (usingRelationalDatabase && databaseSchemaUpdate !is null) {
              //  this.schemaManagementCmd = new SchemaOperationsEventRegistryEngineBuild();
            }
        }
    }

    //private void closeDatabase(Liquibase liquibase) {
    //    if (liquibase !is null) {
    //        Database database = liquibase.getDatabase();
    //        if (database !is null) {
    //            try {
    //                database.close();
    //            } catch (DatabaseException e) {
    //                logger.warn("Error closing database", e);
    //            }
    //        }
    //    }
    //}

    // session factories ////////////////////////////////////////////////////////

    override
    public void initDbSqlSessionFactory() {
        //if (dbSqlSessionFactory is null) {
        //    dbSqlSessionFactory = createDbSqlSessionFactory();
        //    dbSqlSessionFactory.setDatabaseType(databaseType);
        //    dbSqlSessionFactory.setSqlSessionFactory(sqlSessionFactory);
        //    dbSqlSessionFactory.setDatabaseTablePrefix(databaseTablePrefix);
        //    dbSqlSessionFactory.setTablePrefixIsSchema(tablePrefixIsSchema);
        //    dbSqlSessionFactory.setDatabaseCatalog(databaseCatalog);
        //    dbSqlSessionFactory.setDatabaseSchema(databaseSchema);
        //    addSessionFactory(dbSqlSessionFactory);
        //}
        initDbSqlSessionFactoryEntitySettings();
    }

    override
    protected void initDbSqlSessionFactoryEntitySettings() {
        //defaultInitDbSqlSessionFactoryEntitySettings(EntityDependencyOrder.INSERT_ORDER, EntityDependencyOrder.DELETE_ORDER);
    }

    //override
    //public DbSqlSessionFactory createDbSqlSessionFactory() {
    //    return new DbSqlSessionFactory(usePrefixId);
    //}

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
    public void initCommandInterceptors() {
        if (commandInterceptors is null) {
            commandInterceptors = new ArrayList!CommandInterceptor();
            if (customPreCommandInterceptors !is null) {
                commandInterceptors.addAll(customPreCommandInterceptors);
            }
            commandInterceptors.addAll(getDefaultCommandInterceptors());
            if (customPostCommandInterceptors !is null) {
                commandInterceptors.addAll(customPostCommandInterceptors);
            }
            commandInterceptors.add(commandInvoker);
        }
    }

    override
    public string getEngineCfgKey() {
        return EngineConfigurationConstants.KEY_EVENT_REGISTRY_CONFIG;
    }

    override
    public CommandInterceptor createTransactionInterceptor() {
        return null;
    }

    // deployers
    // ////////////////////////////////////////////////////////////////

    protected void initDeployers() {
        //if (eventParseFactory is null) {
        //    eventParseFactory = new EventDefinitionParseFactory();
        //}
        //
        //if (channelParseFactory is null) {
        //    channelParseFactory = new ChannelDefinitionParseFactory();
        //}

        //if (this.eventDeployer is null) {
        //    this.deployers = new ArrayList<>();
        //    if (customPreDeployers !is null) {
        //        this.deployers.addAll(customPreDeployers);
        //    }
        //    this.deployers.addAll(getDefaultDeployers());
        //    if (customPostDeployers !is null) {
        //        this.deployers.addAll(customPostDeployers);
        //    }
        //}

        //if (eventDefinitionCache is null) {
        //    if (eventDefinitionCacheLimit <= 0) {
        //        eventDefinitionCache = new DefaultDeploymentCache<>();
        //    } else {
        //        eventDefinitionCache = new DefaultDeploymentCache<>(eventDefinitionCacheLimit);
        //    }
        //}

        //if (channelDefinitionCache is null) {
        //    channelDefinitionCache = new FullDeploymentCache<>();
        //}
        //
        //deploymentManager = new EventDeploymentManager(eventDefinitionCache, channelDefinitionCache, this);
        //deploymentManager.setDeployers(deployers);
        //deploymentManager.setDeploymentEntityManager(deploymentEntityManager);
        //deploymentManager.setEventDefinitionEntityManager(eventDefinitionEntityManager);
        //deploymentManager.setChannelDefinitionEntityManager(channelDefinitionEntityManager);
    }

    public Collection!Deployer getDefaultDeployers() {
        List!Deployer defaultDeployers = new ArrayList!Deployer();

        //if (eventDeployer is null) {
        //    eventDeployer = new EventDefinitionDeployer();
        //}

        initEventDeployerDependencies();

        //eventDeployer.setIdGenerator(idGenerator);
        //eventDeployer.setParsedDeploymentBuilderFactory(parsedDeploymentBuilderFactory);
        //eventDeployer.setEventDeploymentHelper(eventDeploymentHelper);
        //eventDeployer.setChannelDeploymentHelper(channelDeploymentHelper);
        //eventDeployer.setCachingAndArtifactsManager(cachingAndArtifactsManager);
        //eventDeployer.setUsePrefixId(usePrefixId);
        //
        //defaultDeployers.add(eventDeployer);
        return defaultDeployers;
    }

    public void initEventDeployerDependencies() {
        //if (parsedDeploymentBuilderFactory is null) {
        //    parsedDeploymentBuilderFactory = new ParsedDeploymentBuilderFactory();
        //}
        //
        //if (parsedDeploymentBuilderFactory.getEventParseFactory() is null) {
        //    parsedDeploymentBuilderFactory.setEventParseFactory(eventParseFactory);
        //}
        //
        //if (parsedDeploymentBuilderFactory.getChannelParseFactory() is null) {
        //    parsedDeploymentBuilderFactory.setChannelParseFactory(channelParseFactory);
        //}
        //
        //if (eventDeploymentHelper is null) {
        //    eventDeploymentHelper = new EventDefinitionDeploymentHelper();
        //}
        //
        //if (channelDeploymentHelper is null) {
        //    channelDeploymentHelper = new ChannelDefinitionDeploymentHelper();
        //}
        //
        //if (cachingAndArtifactsManager is null) {
        //    cachingAndArtifactsManager = new CachingAndArtifactsManager();
        //}
    }

    public void initEventRegistry() {
        if (this.eventRegistry is null) {
            this.eventRegistry = new DefaultEventRegistry(this);
        }
    }

    public void initInboundEventProcessor() {
        if (this.inboundEventProcessor is null) {
            this.inboundEventProcessor = new DefaultInboundEventProcessor(eventRegistry);
        }
        this.eventRegistry.setInboundEventProcessor(this.inboundEventProcessor);
    }

    public void initOutboundEventProcessor() {
        if (this.outboundEventProcessor is null) {
            this.outboundEventProcessor = new DefaultOutboundEventProcessor(eventRepositoryService, fallbackToDefaultTenant);
        }
        this.eventRegistry.setOutboundEventProcessor(outboundEventProcessor);
    }

    public void initChannelDefinitionProcessors() {
        //channelModelProcessors.add(new DelegateExpressionInboundChannelModelProcessor(this));
        //channelModelProcessors.add(new DelegateExpressionOutboundChannelModelProcessor(this));
        //channelModelProcessors.add(new InboundChannelModelProcessor());
        //channelModelProcessors.add(new OutboundChannelModelProcessor());
    }

    public void initChangeDetectionManager() {
        if (this.eventRegistryChangeDetectionManager is null) {
          //  this.eventRegistryChangeDetectionManager = new DefaultEventRegistryChangeDetectionManager(this);
        }
    }

    public void initChangeDetectionExecutor() {
        if (this.eventRegistryChangeDetectionExecutor is null) {
            //this.eventRegistryChangeDetectionExecutor = new DefaultEventRegistryChangeDetectionExecutor(eventRegistryChangeDetectionManager,
            //    eventRegistryChangeDetectionInitialDelayInMs, eventRegistryChangeDetectionDelayInMs);
        }
    }

    // myBatis SqlSessionFactory
    // ////////////////////////////////////////////////

    override
    public InputStream getMyBatisXmlConfigurationStream() {
        return getResourceAsStream(DEFAULT_MYBATIS_MAPPING_FILE);
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public string getEngineName() {
        return eventRegistryEngineName;
    }

    public EventRegistryEngineConfiguration setEngineName(string eventRegistryEngineName) {
        this.eventRegistryEngineName = eventRegistryEngineName;
        return this;
    }

    override
    public EventRepositoryService getEventRepositoryService() {
        return eventRepositoryService;
    }

    public EventRegistryEngineConfiguration setEventRepositoryService(EventRepositoryService eventRepositoryService) {
        this.eventRepositoryService = eventRepositoryService;
        return this;
    }

    override
    public EventManagementService getEventManagementService() {
        return eventManagementService;
    }

    public EventRegistryEngineConfiguration setEventManagementService(EventManagementService eventManagementService) {
        this.eventManagementService = eventManagementService;
        return this;
    }

    //public EventDeploymentManager getDeploymentManager() {
    //    return deploymentManager;
    //}

    public EventRegistryEngineConfiguration getFormEngineConfiguration() {
        return this;
    }

    //public EventDefinitionDeployer getEventDeployer() {
    //    return eventDeployer;
    //}

    //public EventRegistryEngineConfiguration setEventDeployer(EventDefinitionDeployer eventDeployer) {
    //    this.eventDeployer = eventDeployer;
    //    return this;
    //}

    //public EventDefinitionParseFactory getEventParseFactory() {
    //    return eventParseFactory;
    //}

    //public EventRegistryEngineConfiguration setEventParseFactory(EventDefinitionParseFactory eventParseFactory) {
    //    this.eventParseFactory = eventParseFactory;
    //    return this;
    //}

    override
    public EventRegistry getEventRegistry() {
        return eventRegistry;
    }

    public EventRegistryEngineConfiguration setEventRegistry(EventRegistry eventRegistry) {
        this.eventRegistry = eventRegistry;
        return this;
    }

    public InboundEventProcessor getInboundEventProcessor() {
        return inboundEventProcessor;
    }

    public EventRegistryEngineConfiguration setInboundEventProcessor(InboundEventProcessor inboundEventProcessor) {
        this.inboundEventProcessor = inboundEventProcessor;
        return this;
    }

    public OutboundEventProcessor getOutboundEventProcessor() {
        return outboundEventProcessor;
    }

    public EventRegistryEngineConfiguration setOutboundEventProcessor(OutboundEventProcessor outboundEventProcessor) {
        this.outboundEventProcessor = outboundEventProcessor;
        return this;
    }

    public bool isEnableEventRegistryChangeDetection() {
        return enableEventRegistryChangeDetection;
    }

    public EventRegistryEngineConfiguration setEnableEventRegistryChangeDetection(bool enableEventRegistryChangeDetection) {
        this.enableEventRegistryChangeDetection = enableEventRegistryChangeDetection;
        return this;
    }

    public long getEventRegistryChangeDetectionInitialDelayInMs() {
        return eventRegistryChangeDetectionInitialDelayInMs;
    }

    public EventRegistryEngineConfiguration setEventRegistryChangeDetectionInitialDelayInMs(long eventRegistryChangeDetectionInitialDelayInMs) {
        this.eventRegistryChangeDetectionInitialDelayInMs = eventRegistryChangeDetectionInitialDelayInMs;
        return this;
    }

    public long getEventRegistryChangeDetectionDelayInMs() {
        return eventRegistryChangeDetectionDelayInMs;
    }

    public EventRegistryEngineConfiguration setEventRegistryChangeDetectionDelayInMs(long eventRegistryChangeDetectionDelayInMs) {
        this.eventRegistryChangeDetectionDelayInMs = eventRegistryChangeDetectionDelayInMs;
        return this;
    }

    public EventRegistryChangeDetectionManager getEventRegistryChangeDetectionManager() {
        return eventRegistryChangeDetectionManager;
    }

    public EventRegistryEngineConfiguration setEventRegistryChangeDetectionManager(EventRegistryChangeDetectionManager eventRegistryChangeDetectionManager) {
        this.eventRegistryChangeDetectionManager = eventRegistryChangeDetectionManager;
        return this;
    }

    public EventRegistryChangeDetectionExecutor getEventRegistryChangeDetectionExecutor() {
        return eventRegistryChangeDetectionExecutor;
    }
    public EventRegistryEngineConfiguration setEventRegistryChangeDetectionExecutor(EventRegistryChangeDetectionExecutor eventRegistryChangeDetectionExecutor) {
        this.eventRegistryChangeDetectionExecutor = eventRegistryChangeDetectionExecutor;
        return this;
    }

    public int getEventDefinitionCacheLimit() {
        return eventDefinitionCacheLimit;
    }

    public EventRegistryEngineConfiguration setEventDefinitionCacheLimit(int eventDefinitionCacheLimit) {
        this.eventDefinitionCacheLimit = eventDefinitionCacheLimit;
        return this;
    }

    //public DeploymentCache<EventDefinitionCacheEntry> getEventDefinitionCache() {
    //    return eventDefinitionCache;
    //}
    //
    //public EventRegistryEngineConfiguration setEventDefinitionCache(DeploymentCache<EventDefinitionCacheEntry> eventDefinitionCache) {
    //    this.eventDefinitionCache = eventDefinitionCache;
    //    return this;
    //}
    //
    //public DeploymentCache<ChannelDefinitionCacheEntry> getChannelDefinitionCache() {
    //    return channelDefinitionCache;
    //}
    //
    //public EventRegistryEngineConfiguration setChannelDefinitionCache(DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache) {
    //    this.channelDefinitionCache = channelDefinitionCache;
    //    return this;
    //}

    public Collection!ChannelModelProcessor getChannelModelProcessors() {
        return channelModelProcessors;
    }

    public void addChannelModelProcessor(ChannelModelProcessor channelModelProcessor) {
        if (this.channelModelProcessors is null) {
            this.channelModelProcessors = new ArrayList!ChannelModelProcessor();
        }
        this.channelModelProcessors.add(channelModelProcessor);
    }

    public void setChannelModelProcessors(Collection!ChannelModelProcessor channelModelProcessors) {
        this.channelModelProcessors = channelModelProcessors;
    }

    public EventDeploymentDataManager getDeploymentDataManager() {
        return deploymentDataManager;
    }

    public EventRegistryEngineConfiguration setDeploymentDataManager(EventDeploymentDataManager deploymentDataManager) {
        this.deploymentDataManager = deploymentDataManager;
        return this;
    }

    public EventDefinitionDataManager getEventDefinitionDataManager() {
        return eventDefinitionDataManager;
    }

    public EventRegistryEngineConfiguration setEventDefinitionDataManager(EventDefinitionDataManager eventDefinitionDataManager) {
        this.eventDefinitionDataManager = eventDefinitionDataManager;
        return this;
    }

    public EventResourceDataManager getResourceDataManager() {
        return resourceDataManager;
    }

    public EventRegistryEngineConfiguration setResourceDataManager(EventResourceDataManager resourceDataManager) {
        this.resourceDataManager = resourceDataManager;
        return this;
    }

    public EventDeploymentEntityManager getDeploymentEntityManager() {
        return deploymentEntityManager;
    }

    public EventRegistryEngineConfiguration setDeploymentEntityManager(EventDeploymentEntityManager deploymentEntityManager) {
        this.deploymentEntityManager = deploymentEntityManager;
        return this;
    }

    public EventDefinitionEntityManager getEventDefinitionEntityManager() {
        return eventDefinitionEntityManager;
    }

    public EventRegistryEngineConfiguration setEventDefinitionEntityManager(EventDefinitionEntityManager eventDefinitionEntityManager) {
        this.eventDefinitionEntityManager = eventDefinitionEntityManager;
        return this;
    }

    public ChannelDefinitionEntityManager getChannelDefinitionEntityManager() {
        return channelDefinitionEntityManager;
    }

    public EventRegistryEngineConfiguration setChannelDefinitionEntityManager(ChannelDefinitionEntityManager channelDefinitionEntityManager) {
        this.channelDefinitionEntityManager = channelDefinitionEntityManager;
        return this;
    }

    public EventResourceEntityManager getResourceEntityManager() {
        return resourceEntityManager;
    }

    public EventRegistryEngineConfiguration setResourceEntityManager(EventResourceEntityManager resourceEntityManager) {
        this.resourceEntityManager = resourceEntityManager;
        return this;
    }

    public TableDataManager getTableDataManager() {
        return tableDataManager;
    }

    public EventRegistryEngineConfiguration setTableDataManager(TableDataManager tableDataManager) {
        this.tableDataManager = tableDataManager;
        return this;
    }

    override
    public ExpressionManager getExpressionManager() {
        return expressionManager;
    }

    override
    public EventRegistryEngineConfiguration setExpressionManager(ExpressionManager expressionManager) {
        this.expressionManager = expressionManager;
        return this;
    }

    //public EventJsonConverter getEventJsonConverter() {
    //    return eventJsonConverter;
    //}
    //
    //public EventRegistryEngineConfiguration setEventJsonConverter(EventJsonConverter eventJsonConverter) {
    //    this.eventJsonConverter = eventJsonConverter;
    //    return this;
    //}
    //
    //public ChannelJsonConverter getChannelJsonConverter() {
    //    return channelJsonConverter;
    //}
    //
    //public EventRegistryEngineConfiguration setChannelJsonConverter(ChannelJsonConverter channelJsonConverter) {
    //    this.channelJsonConverter = channelJsonConverter;
    //    return this;
    //}

    public bool isEnableEventRegistryChangeDetectionAfterEngineCreate() {
        return enableEventRegistryChangeDetectionAfterEngineCreate;
    }

    public EventRegistryEngineConfiguration setEnableEventRegistryChangeDetectionAfterEngineCreate(bool enableEventRegistryChangeDetectionAfterEngineCreate) {
        this.enableEventRegistryChangeDetectionAfterEngineCreate = enableEventRegistryChangeDetectionAfterEngineCreate;
        return this;
    }

}
