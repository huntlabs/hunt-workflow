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
module flow.idm.engine.IdmEngineConfiguration;

import hunt.stream.Common;
import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
//import flow.idm.engine.MybatisGroupDataManager;
import flow.idm.engine.IdmEngines;
import flow.idm.engine.IdmEngine;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.AbstractEngineConfiguration;
import flow.common.cfg.BeansConfigurationHelper;
import flow.common.cfg.IdGenerator;
import flow.common.db.DbSqlSessionFactory;
import flow.common.event.FlowableEventDispatcherImpl;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandInterceptor;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.common.interceptor.SessionFactory;
import flow.common.runtime.Clockm;
import flow.idm.api.IdmEngineConfigurationApi;
import flow.idm.api.IdmIdentityService;
import flow.idm.api.IdmManagementService;
import flow.idm.api.PasswordEncoder;
import flow.idm.api.PasswordSalt;
import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.engine.impl.IdmEngineImpl;
import flow.idm.engine.impl.IdmIdentityServiceImpl;
import flow.idm.engine.impl.IdmManagementServiceImpl;
import flow.idm.engine.impl.SchemaOperationsIdmEngineBuild;
//import flow.idm.engine.impl.authentication.BlankSalt;
//import flow.idm.engine.impl.authentication.ClearTextPasswordEncoder;
import flow.idm.engine.impl.cfg.StandaloneIdmEngineConfiguration;
import flow.idm.engine.impl.cfg.StandaloneInMemIdmEngineConfiguration;
//import flow.idm.engine.impl.db.EntityDependencyOrder;
//import flow.idm.engine.impl.db.IdmDbSchemaManager;
import flow.idm.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.idm.engine.impl.persistence.entity.ByteArrayEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.GroupEntityManager;
import flow.idm.engine.impl.persistence.entity.GroupEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManager;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManager;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.PropertyEntityManager;
import flow.idm.engine.impl.persistence.entity.PropertyEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.TableDataManager;
import flow.idm.engine.impl.persistence.entity.TableDataManagerImpl;
import flow.idm.engine.impl.persistence.entity.TokenEntityManager;
import flow.idm.engine.impl.persistence.entity.TokenEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.UserEntityManager;
import flow.idm.engine.impl.persistence.entity.UserEntityManagerImpl;
import flow.idm.engine.impl.persistence.entity.data.ByteArrayDataManager;
import flow.idm.engine.impl.persistence.entity.data.GroupDataManager;
import flow.idm.engine.impl.persistence.entity.data.IdentityInfoDataManager;
import flow.idm.engine.impl.persistence.entity.data.MembershipDataManager;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeDataManager;
import flow.idm.engine.impl.persistence.entity.data.PrivilegeMappingDataManager;
import flow.idm.engine.impl.persistence.entity.data.PropertyDataManager;
import flow.idm.engine.impl.persistence.entity.data.TokenDataManager;
import flow.idm.engine.impl.persistence.entity.data.UserDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisByteArrayDataManager;
//import flow.idm.engine.impl.persistence.entity.data.impl.MybatisGroupDataManager;
//import flow.idm.engine.impl.persistence.entity.data.impl.MybatisIdentityInfoDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisMembershipDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisPrivilegeDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisPrivilegeMappingDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisPropertyDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisTokenDataManager;
import flow.idm.engine.impl.persistence.entity.data.impl.MybatisUserDataManager;
import flow.common.api.deleg.event.FlowableEventType;



import hunt.Exceptions;

class IdmEngineConfiguration : AbstractEngineConfiguration , IdmEngineConfigurationApi {

    public static  string DEFAULT_MYBATIS_MAPPING_FILE = "org/flowable/idm/db/mapping/mappings.xml";

    protected string idmEngineName  = "default";

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected IdmIdentityService idmIdentityService = new IdmIdentityServiceImpl();
    protected IdmManagementService idmManagementService = new IdmManagementServiceImpl();

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected ByteArrayDataManager byteArrayDataManager;
    protected GroupDataManager groupDataManager;
    protected IdentityInfoDataManager identityInfoDataManager;
    protected MembershipDataManager membershipDataManager;
    protected PropertyDataManager idmPropertyDataManager;
    protected TokenDataManager tokenDataManager;
    protected UserDataManager userDataManager;
    protected PrivilegeDataManager privilegeDataManager;
    protected PrivilegeMappingDataManager privilegeMappingDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////
    protected ByteArrayEntityManager byteArrayEntityManager;
    protected GroupEntityManager groupEntityManager;
    protected IdentityInfoEntityManager identityInfoEntityManager;
    protected MembershipEntityManager membershipEntityManager;
    protected PropertyEntityManager idmPropertyEntityManager;
    protected TableDataManager tableDataManager;
    protected TokenEntityManager tokenEntityManager;
    protected UserEntityManager userEntityManager;
    protected PrivilegeEntityManager privilegeEntityManager;
    protected PrivilegeMappingEntityManager privilegeMappingEntityManager;

   // protected PasswordEncoder passwordEncoder;
    protected PasswordSalt passwordSalt;

    public static IdmEngineConfiguration createIdmEngineConfigurationFromResourceDefault() {
        return createIdmEngineConfigurationFromResource("flowable.idm.cfg.xml", "idmEngineConfiguration");
    }

    public static IdmEngineConfiguration createIdmEngineConfigurationFromResource(string resource) {
        return createIdmEngineConfigurationFromResource(resource, "idmEngineConfiguration");
    }

    public static IdmEngineConfiguration createIdmEngineConfigurationFromResource(string resource, string beanName) {
       // return (IdmEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromResource(resource, beanName);
        implementationMissing(false);
        return null;
    }

    public static IdmEngineConfiguration createIdmEngineConfigurationFromInputStream(InputStream inputStream) {
        return createIdmEngineConfigurationFromInputStream(inputStream, "idmEngineConfiguration");
    }

    public static IdmEngineConfiguration createIdmEngineConfigurationFromInputStream(InputStream inputStream, string beanName) {
        implementationMissing(false);
        return null;
       // return (IdmEngineConfiguration) BeansConfigurationHelper.parseEngineConfigurationFromInputStream(inputStream, beanName);
    }

    public static IdmEngineConfiguration createStandaloneIdmEngineConfiguration() {
        return new StandaloneIdmEngineConfiguration();
    }

    public static IdmEngineConfiguration createStandaloneInMemIdmEngineConfiguration() {
        return new StandaloneInMemIdmEngineConfiguration();
    }

  this() {
    }

    // buildProcessEngine
    // ///////////////////////////////////////////////////////

    public IdmEngine buildIdmEngine() {
        init();
        return new IdmEngineImpl(this);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    protected void init() {
        initEngineConfigurations();
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
        //initPasswordEncoder();
        initServices();
        initDataManagers();
        initEntityManagers();
        initClock();
        initEventDispatcher();
    }

    override
    public void initSchemaManager() {
        implementationMissing(false);
        //super.initSchemaManager();
        //if (this.schemaManager is null) {
        //    this.schemaManager = new IdmDbSchemaManager();
        //}
    }

    public void initSchemaManagementCommand() {
        implementationMissing(false);
        //if (schemaManagementCmd is null) {
        //    if (usingRelationalDatabase && databaseSchemaUpdate !is null) {
        //        this.schemaManagementCmd = new SchemaOperationsIdmEngineBuild();
        //    }
        //}
    }

    // services
    // /////////////////////////////////////////////////////////////////

    protected void initServices() {
        initService(cast(Object)idmIdentityService);
        initService(cast(Object)idmManagementService);
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    override
    public void initDataManagers() {
        super.initDataManagers();
        if (byteArrayDataManager is null) {
            byteArrayDataManager = new MybatisByteArrayDataManager(this);
        }
        if (groupDataManager is null) {
          //  groupDataManager = new MybatisGroupDataManager(this);
        }
        if (identityInfoDataManager is null) {
            //identityInfoDataManager = new MybatisIdentityInfoDataManager(this);
        }
        if (membershipDataManager is null) {
            membershipDataManager = new MybatisMembershipDataManager(this);
        }
        if (idmPropertyDataManager is null) {
            idmPropertyDataManager = new MybatisPropertyDataManager(this);
        }
        if (tokenDataManager is null) {
            tokenDataManager = new MybatisTokenDataManager(this);
        }
        if (userDataManager is null) {
            userDataManager = new MybatisUserDataManager(this);
        }
        if (privilegeDataManager is null) {
            privilegeDataManager = new MybatisPrivilegeDataManager(this);
        }
        if (privilegeMappingDataManager is null) {
            privilegeMappingDataManager = new MybatisPrivilegeMappingDataManager(getIdmEngineConfiguration());
        }
    }

    override
    public void initEntityManagers() {
        super.initEntityManagers();
        if (byteArrayEntityManager is null) {
            byteArrayEntityManager = new ByteArrayEntityManagerImpl(this, byteArrayDataManager);
        }
        if (groupEntityManager is null) {
            groupEntityManager = new GroupEntityManagerImpl(this, groupDataManager);
        }
        if (identityInfoEntityManager is null) {
            identityInfoEntityManager = new IdentityInfoEntityManagerImpl(this, identityInfoDataManager);
        }
        if (membershipEntityManager is null) {
            membershipEntityManager = new MembershipEntityManagerImpl(this, membershipDataManager);
        }
        if (idmPropertyEntityManager is null) {
            idmPropertyEntityManager = new PropertyEntityManagerImpl(this, idmPropertyDataManager);
        }
        //if (tableDataManager is null) {
        //    tableDataManager = new TableDataManagerImpl(this);
        //}
        if (tokenEntityManager is null) {
            tokenEntityManager = new TokenEntityManagerImpl(this, tokenDataManager);
        }
        if (userEntityManager is null) {
            userEntityManager = new UserEntityManagerImpl(this, userDataManager);
        }
        if (privilegeEntityManager is null) {
            privilegeEntityManager = new PrivilegeEntityManagerImpl(this, privilegeDataManager);
        }
        if (privilegeMappingEntityManager is null) {
            privilegeMappingEntityManager = new PrivilegeMappingEntityManagerImpl(this, privilegeMappingDataManager);
        }
    }

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


    //public DbSqlSessionFactory createDbSqlSessionFactory() {
    //    return new DbSqlSessionFactory(usePrefixId);
    //}
    //
    //
    override
    protected void initDbSqlSessionFactoryEntitySettings() {
        //defaultInitDbSqlSessionFactoryEntitySettings(EntityDependencyOrder.INSERT_ORDER, EntityDependencyOrder.DELETE_ORDER);
    }
    //
    //public void initPasswordEncoder() {
    //    if (passwordEncoder is null) {
    //        passwordEncoder = ClearTextPasswordEncoder.getInstance();
    //    }
    //
    //    if (passwordSalt is null) {
    //        passwordSalt = BlankSalt.getInstance();
    //    }
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
        return EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG;
    }

    override
    public CommandInterceptor createTransactionInterceptor() {
        // Should be overridden by subclasses
        return null;
    }

    // OTHER
    // ////////////////////////////////////////////////////////////////////

    override
    public InputStream getMyBatisXmlConfigurationStream() {
        return getResourceAsStream(DEFAULT_MYBATIS_MAPPING_FILE);
    }

    override
    public void initEventDispatcher() {
        if (this.eventDispatcher is null) {
            this.eventDispatcher = new FlowableEventDispatcherImpl();
        }

        this.eventDispatcher.setEnabled(enableEventDispatcher);

        if (eventListeners !is null) {
            foreach (FlowableEventListener listenerToAdd ; eventListeners) {
                this.eventDispatcher.addEventListener(listenerToAdd);
            }
        }

        if (typedEventListeners !is null) {
            foreach (MapEntry!(string, List!FlowableEventListener) listenersToAdd ; typedEventListeners) {
                // Extract types from the given string
                FlowableIdmEventType[] types = FlowableIdmEventType.getTypesFromString(listenersToAdd.getKey());
                FlowableEventType[] castTypes;
                foreach (FlowableIdmEventType f ; types) //FlowableEventType
                {
                     castTypes ~= cast(FlowableEventType)f;
                }
                foreach (FlowableEventListener listenerToAdd ; listenersToAdd.getValue()) {
                    this.eventDispatcher.addEventListener(listenerToAdd, castTypes);
                }
            }
        }

    }

    // getters and setters
    // //////////////////////////////////////////////////////

    override
    public string getEngineName() {
        return idmEngineName;
    }

    public IdmEngineConfiguration setEngineName(string idmEngineName) {
        this.idmEngineName = idmEngineName;
        return this;
    }


    override
    public IdmEngineConfiguration setJdbcPassword(string jdbcPassword) {
        this.jdbcPassword = jdbcPassword;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcMaxActiveConnections(int jdbcMaxActiveConnections) {
        this.jdbcMaxActiveConnections = jdbcMaxActiveConnections;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcMaxIdleConnections(int jdbcMaxIdleConnections) {
        this.jdbcMaxIdleConnections = jdbcMaxIdleConnections;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcMaxCheckoutTime(int jdbcMaxCheckoutTime) {
        this.jdbcMaxCheckoutTime = jdbcMaxCheckoutTime;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcMaxWaitTime(int jdbcMaxWaitTime) {
        this.jdbcMaxWaitTime = jdbcMaxWaitTime;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcPingEnabled(bool jdbcPingEnabled) {
        this.jdbcPingEnabled = jdbcPingEnabled;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcPingConnectionNotUsedFor(int jdbcPingConnectionNotUsedFor) {
        this.jdbcPingConnectionNotUsedFor = jdbcPingConnectionNotUsedFor;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcDefaultTransactionIsolationLevel(int jdbcDefaultTransactionIsolationLevel) {
        this.jdbcDefaultTransactionIsolationLevel = jdbcDefaultTransactionIsolationLevel;
        return this;
    }

    override
    public IdmEngineConfiguration setJdbcPingQuery(string jdbcPingQuery) {
        this.jdbcPingQuery = jdbcPingQuery;
        return this;
    }

    override
    public IdmEngineConfiguration setDataSourceJndiName(string dataSourceJndiName) {
        this.dataSourceJndiName = dataSourceJndiName;
        return this;
    }

    override
    public IdmEngineConfiguration setSchemaCommandConfig(CommandConfig schemaCommandConfig) {
        this.schemaCommandConfig = schemaCommandConfig;
        return this;
    }

    override
    public IdmEngineConfiguration setTransactionsExternallyManaged(bool transactionsExternallyManaged) {
        this.transactionsExternallyManaged = transactionsExternallyManaged;
        return this;
    }

    override
    public IdmEngineConfiguration setIdGenerator(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
        return this;
    }

    override
    public IdmEngineConfiguration setXmlEncoding(string xmlEncoding) {
        this.xmlEncoding = xmlEncoding;
        return this;
    }

    override
    public IdmEngineConfiguration setBeans(Map!(Object, Object) beans) {
        this.beans = beans;
        return this;
    }

    override
    public IdmEngineConfiguration setDefaultCommandConfig(CommandConfig defaultCommandConfig) {
        this.defaultCommandConfig = defaultCommandConfig;
        return this;
    }


    public IdmIdentityService getIdmIdentityService() {
        return idmIdentityService;
    }

    public IdmEngineConfiguration setIdmIdentityService(IdmIdentityService idmIdentityService) {
        this.idmIdentityService = idmIdentityService;
        return this;
    }


    public IdmManagementService getIdmManagementService() {
        return idmManagementService;
    }

    public IdmEngineConfiguration setIdmManagementService(IdmManagementService idmManagementService) {
        this.idmManagementService = idmManagementService;
        return this;
    }

    public IdmEngineConfiguration getIdmEngineConfiguration() {
        return this;
    }

    public ByteArrayDataManager getByteArrayDataManager() {
        return byteArrayDataManager;
    }

    public IdmEngineConfiguration setByteArrayDataManager(ByteArrayDataManager byteArrayDataManager) {
        this.byteArrayDataManager = byteArrayDataManager;
        return this;
    }

    public GroupDataManager getGroupDataManager() {
        return groupDataManager;
    }

    public IdmEngineConfiguration setGroupDataManager(GroupDataManager groupDataManager) {
        this.groupDataManager = groupDataManager;
        return this;
    }

    public IdentityInfoDataManager getIdentityInfoDataManager() {
        return identityInfoDataManager;
    }

    public IdmEngineConfiguration setIdentityInfoDataManager(IdentityInfoDataManager identityInfoDataManager) {
        this.identityInfoDataManager = identityInfoDataManager;
        return this;
    }

    public MembershipDataManager getMembershipDataManager() {
        return membershipDataManager;
    }

    public IdmEngineConfiguration setMembershipDataManager(MembershipDataManager membershipDataManager) {
        this.membershipDataManager = membershipDataManager;
        return this;
    }

    public PropertyDataManager getIdmPropertyDataManager() {
        return idmPropertyDataManager;
    }

    public IdmEngineConfiguration setIdmPropertyDataManager(PropertyDataManager idmPropertyDataManager) {
        this.idmPropertyDataManager = idmPropertyDataManager;
        return this;
    }

    public TokenDataManager getTokenDataManager() {
        return tokenDataManager;
    }

    public IdmEngineConfiguration setTokenDataManager(TokenDataManager tokenDataManager) {
        this.tokenDataManager = tokenDataManager;
        return this;
    }

    public UserDataManager getUserDataManager() {
        return userDataManager;
    }

    public IdmEngineConfiguration setUserDataManager(UserDataManager userDataManager) {
        this.userDataManager = userDataManager;
        return this;
    }

    public PrivilegeDataManager getPrivilegeDataManager() {
        return privilegeDataManager;
    }

    public IdmEngineConfiguration setPrivilegeDataManager(PrivilegeDataManager privilegeDataManager) {
        this.privilegeDataManager = privilegeDataManager;
        return this;
    }

    public PrivilegeMappingDataManager getPrivilegeMappingDataManager() {
        return privilegeMappingDataManager;
    }

    public IdmEngineConfiguration setPrivilegeMappingDataManager(PrivilegeMappingDataManager privilegeMappingDataManager) {
        this.privilegeMappingDataManager = privilegeMappingDataManager;
        return this;
    }

    public ByteArrayEntityManager getByteArrayEntityManager() {
        return byteArrayEntityManager;
    }

    public IdmEngineConfiguration setByteArrayEntityManager(ByteArrayEntityManager byteArrayEntityManager) {
        this.byteArrayEntityManager = byteArrayEntityManager;
        return this;
    }

    public GroupEntityManager getGroupEntityManager() {
        return groupEntityManager;
    }

    public IdmEngineConfiguration setGroupEntityManager(GroupEntityManager groupEntityManager) {
        this.groupEntityManager = groupEntityManager;
        return this;
    }

    public IdentityInfoEntityManager getIdentityInfoEntityManager() {
        return identityInfoEntityManager;
    }

    public IdmEngineConfiguration setIdentityInfoEntityManager(IdentityInfoEntityManager identityInfoEntityManager) {
        this.identityInfoEntityManager = identityInfoEntityManager;
        return this;
    }

    public MembershipEntityManager getMembershipEntityManager() {
        return membershipEntityManager;
    }

    public IdmEngineConfiguration setMembershipEntityManager(MembershipEntityManager membershipEntityManager) {
        this.membershipEntityManager = membershipEntityManager;
        return this;
    }

    public PropertyEntityManager getIdmPropertyEntityManager() {
        return idmPropertyEntityManager;
    }

    public IdmEngineConfiguration setIdmPropertyEntityManager(PropertyEntityManager idmPropertyEntityManager) {
        this.idmPropertyEntityManager = idmPropertyEntityManager;
        return this;
    }

    public TokenEntityManager getTokenEntityManager() {
        return tokenEntityManager;
    }

    public IdmEngineConfiguration setTokenEntityManager(TokenEntityManager tokenEntityManager) {
        this.tokenEntityManager = tokenEntityManager;
        return this;
    }

    public UserEntityManager getUserEntityManager() {
        return userEntityManager;
    }

    public IdmEngineConfiguration setUserEntityManager(UserEntityManager userEntityManager) {
        this.userEntityManager = userEntityManager;
        return this;
    }

    public PrivilegeEntityManager getPrivilegeEntityManager() {
        return privilegeEntityManager;
    }

    public IdmEngineConfiguration setPrivilegeEntityManager(PrivilegeEntityManager privilegeEntityManager) {
        this.privilegeEntityManager = privilegeEntityManager;
        return this;
    }

    public PrivilegeMappingEntityManager getPrivilegeMappingEntityManager() {
        return privilegeMappingEntityManager;
    }

    public IdmEngineConfiguration setPrivilegeMappingEntityManager(PrivilegeMappingEntityManager privilegeMappingEntityManager) {
        this.privilegeMappingEntityManager = privilegeMappingEntityManager;
        return this;
    }

    public TableDataManager getTableDataManager() {
        return tableDataManager;
    }

    public IdmEngineConfiguration setTableDataManager(TableDataManager tableDataManager) {
        this.tableDataManager = tableDataManager;
        return this;
    }


    //public IdmEngineConfiguration setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
    //    this.sqlSessionFactory = sqlSessionFactory;
    //    return this;
    //}
    //
    //
    //public IdmEngineConfiguration setTransactionFactory(TransactionFactory transactionFactory) {
    //    this.transactionFactory = transactionFactory;
    //    return this;
    //}
    //
    //
    //public IdmEngineConfiguration setCustomMybatisMappers(Set<Class<?>> customMybatisMappers) {
    //    this.customMybatisMappers = customMybatisMappers;
    //    return this;
    //}

    override
    public IdmEngineConfiguration setCustomMybatisXMLMappers(Set!string customMybatisXMLMappers) {
        this.customMybatisXMLMappers = customMybatisXMLMappers;
        return this;
    }

    override
    public IdmEngineConfiguration setCustomSessionFactories(List!SessionFactory customSessionFactories) {
        this.customSessionFactories = customSessionFactories;
        return this;
    }

    override
    public IdmEngineConfiguration setUsingRelationalDatabase(bool usingRelationalDatabase) {
        this.usingRelationalDatabase = usingRelationalDatabase;
        return this;
    }

    override
    public IdmEngineConfiguration setDatabaseTablePrefix(string databaseTablePrefix) {
        this.databaseTablePrefix = databaseTablePrefix;
        return this;
    }

    override
    public IdmEngineConfiguration setDatabaseWildcardEscapeCharacter(string databaseWildcardEscapeCharacter) {
        this.databaseWildcardEscapeCharacter = databaseWildcardEscapeCharacter;
        return this;
    }

    override
    public IdmEngineConfiguration setDatabaseCatalog(string databaseCatalog) {
        this.databaseCatalog = databaseCatalog;
        return this;
    }

    override
    public IdmEngineConfiguration setDatabaseSchema(string databaseSchema) {
        this.databaseSchema = databaseSchema;
        return this;
    }

    override
    public IdmEngineConfiguration setTablePrefixIsSchema(bool tablePrefixIsSchema) {
        this.tablePrefixIsSchema = tablePrefixIsSchema;
        return this;
    }

    //public PasswordEncoder getPasswordEncoder() {
    //    return passwordEncoder;
    //}
    //
    //public IdmEngineConfiguration setPasswordEncoder(PasswordEncoder passwordEncoder) {
    //    this.passwordEncoder = passwordEncoder;
    //    return this;
    //}

    public PasswordSalt getPasswordSalt() {
        return passwordSalt;
    }

    public IdmEngineConfiguration setPasswordSalt(PasswordSalt passwordSalt) {
        this.passwordSalt = passwordSalt;
        return this;
    }


    public IdmEngineConfiguration setSessionFactories(Map!(TypeInfo, SessionFactory) sessionFactories) {
        this.sessionFactories = sessionFactories;
        return this;
    }

    override
    public IdmEngineConfiguration setDatabaseSchemaUpdate(string databaseSchemaUpdate) {
        this.databaseSchemaUpdate = databaseSchemaUpdate;
        return this;
    }

    override
    public IdmEngineConfiguration setEnableEventDispatcher(bool enableEventDispatcher) {
        this.enableEventDispatcher = enableEventDispatcher;
        return this;
    }

    override
    public IdmEngineConfiguration setEventDispatcher(FlowableEventDispatcher eventDispatcher) {
        this.eventDispatcher = eventDispatcher;
        return this;
    }

    override
    public IdmEngineConfiguration setEventListeners(List!FlowableEventListener eventListeners) {
        this.eventListeners = eventListeners;
        return this;
    }

    override
    public IdmEngineConfiguration setTypedEventListeners(Map!(string, List!FlowableEventListener) typedEventListeners) {
        this.typedEventListeners = typedEventListeners;
        return this;
    }

    override
    public IdmEngineConfiguration setClock(Clockm clock) {
        this.clock = clock;
        return this;
    }
}
