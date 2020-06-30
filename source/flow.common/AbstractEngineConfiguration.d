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

module flow.common.AbstractEngineConfiguration;

import flow.common.DefaultTenantProvider;
import core.time;
import flow.common.AbstractServiceConfiguration;
import hunt.stream.Common;
//import hunt.io.InputStreamReader;
//import java.io.Reader;
//import java.sql.Connection;
//import java.sql.DatabaseMetaData;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.time.Duration;
import hunt.collection.ArrayList;
import hunt.collection;
//import java.util.Comparator;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
//import java.util.Properties;
//import java.util.ServiceLoader;
import hunt.collection.Set;
import hunt.collection.ArrayList;
import flow.common.EngineConfigurator;
import hunt.Exceptions;
//import org.apache.commons.lang3.StringUtils;
//import org.apache.ibatis.builder.xml.XMLConfigBuilder;
//import org.apache.ibatis.builder.xml.XMLMapperBuilder;
//import org.apache.ibatis.datasource.pooled.PooledDataSource;
//import org.apache.ibatis.mapping.Environment;
//import org.apache.ibatis.plugin.Interceptor;
//import org.apache.ibatis.session.Configuration;
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.apache.ibatis.session.defaults.DefaultSqlSessionFactory;
//import org.apache.ibatis.transaction.TransactionFactory;
//import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
//import org.apache.ibatis.transaction.managed.ManagedTransactionFactory;
import flow.common.api.FlowableException;
import flow.common.EngineDeployer;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.api.engine.EngineLifecycleListener;
import flow.common.cfg.CommandExecutorImpl;
import flow.common.cfg.IdGenerator;
import flow.common.cfg.TransactionContextFactory;
//import flow.common.cfg.standalone.StandaloneMybatisTransactionContextFactory;
//import flow.common.db.CommonDbSchemaManager;
//import flow.common.db.DbSqlSessionFactory;
//import flow.common.db.LogSqlExecutionTimePlugin;
//import flow.common.db.MybatisTypeAliasConfigurator;
//import flow.common.db.MybatisTypeHandlerConfigurator;
//import flow.common.db.SchemaManager;
import flow.common.event.EventDispatchAction;
import flow.common.event.FlowableEventDispatcherImpl;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContextFactory;
import flow.common.interceptor.CommandContextInterceptor;
import flow.common.interceptor.CommandExecutor;
import flow.common.interceptor.CommandInterceptor;
import flow.common.interceptor.CrDbRetryInterceptor;
import flow.common.interceptor.DefaultCommandInvoker;
import flow.common.interceptor.LogInterceptor;
import flow.common.interceptor.SessionFactory;
import flow.common.interceptor.TransactionContextInterceptor;
//import flow.common.lock.LockManager;
//import flow.common.lock.LockManagerImpl;
//import flow.common.logging.LoggingListener;
//import flow.common.logging.LoggingSession;
//import flow.common.logging.LoggingSessionFactory;
import flow.common.persistence.GenericManagerFactory;
import flow.common.persistence.StrongUuidGenerator;
//import flow.common.persistence.cache.EntityCache;
//import flow.common.persistence.cache.EntityCacheImpl;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.entity.PropertyEntityManager;
import flow.common.persistence.entity.PropertyEntityManagerImpl;
import flow.common.persistence.entity.data.PropertyDataManager;
import flow.common.persistence.entity.data.impl.MybatisPropertyDataManager;
import flow.common.runtime.Clockm;
import flow.common.service.CommonEngineServiceImpl;
import flow.common.util.DefaultClockImpl;
//import flow.common.util.IoUtil;
//import flow.common.util.ReflectUtil;
import flow.event.registry.api.EventRegistryEventConsumer;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import hunt.logging;
import hunt.Object;
import hunt.database;
import hunt.entity.EntityManager;
import hunt.entity.EntityManagerFactory;
import hunt.entity.EntityOption;
import hunt.entity.Persistence;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.common.api.deleg.event.FlowableEventType;
//import com.fasterxml.jackson.databind.ObjectMapper;

__gshared  EntityManagerFactory  entityManagerFactory;

abstract class AbstractEngineConfiguration {


    /** The tenant id indicating 'no tenant' */
    public static  string NO_TENANT_ID = "";

    /**
     * Checks the version of the DB schema against the library when the form engine is being created and throws an exception if the versions don't match.
     */
    public static  string DB_SCHEMA_UPDATE_FALSE = "false";
    public static  string DB_SCHEMA_UPDATE_CREATE = "create";
    public static  string DB_SCHEMA_UPDATE_CREATE_DROP = "create-drop";

    /**
     * Creates the schema when the form engine is being created and drops the schema when the form engine is being closed.
     */
    public static  string DB_SCHEMA_UPDATE_DROP_CREATE = "drop-create";

    /**
     * Upon building of the process engine, a check is performed and an update of the schema is performed if it is necessary.
     */
    public static  string DB_SCHEMA_UPDATE_TRUE = "true";

    protected bool forceCloseMybatisConnectionPool = true;

    protected string databaseType = "mysql";
    protected string jdbcDriver = "org.h2.Driver";
    protected string jdbcUrl = "jdbc:h2:tcp://localhost/~/flowable";
    protected string jdbcUsername = "sa";
    protected string jdbcPassword = "";
    protected string dataSourceJndiName;
    protected int jdbcMaxActiveConnections = 16;
    protected int jdbcMaxIdleConnections = 8;
    protected int jdbcMaxCheckoutTime;
    protected int jdbcMaxWaitTime;
    protected bool jdbcPingEnabled;
    protected string jdbcPingQuery;
    protected int jdbcPingConnectionNotUsedFor;
    protected int jdbcDefaultTransactionIsolationLevel;
    //protected DataSource dataSource;
    //protected SchemaManager commonSchemaManager;
    //protected SchemaManager schemaManager;
    protected Command!Void schemaManagementCmd;

    protected string databaseSchemaUpdate  ;//= DB_SCHEMA_UPDATE_FALSE;

    /**
     * Whether to use a lock when performing the database schema create or update operations.
     */
    protected bool useLockForDatabaseSchemaUpdate = false;

    protected string xmlEncoding = "UTF-8";

    // COMMAND EXECUTORS ///////////////////////////////////////////////

    protected CommandExecutor commandExecutor;
    protected Collection!CommandInterceptor defaultCommandInterceptors;
    protected CommandConfig defaultCommandConfig;
    protected CommandConfig schemaCommandConfig;
    protected CommandContextFactory commandContextFactory;
    protected CommandInterceptor commandInvoker;

    protected List!CommandInterceptor customPreCommandInterceptors;
    protected List!CommandInterceptor customPostCommandInterceptors;
    protected List!CommandInterceptor commandInterceptors;

    protected Map!(string, AbstractEngineConfiguration) engineConfigurations;// = new HashMap<>();
    protected Map!(string, AbstractServiceConfiguration) serviceConfigurations;// = new HashMap<>();

    //protected ClassLoader classLoader;
    /**
     * Either use Class.forName or ClassLoader.loadClass for class loading. See http://forums.activiti.org/content/reflectutilloadclass-and-custom- classloader
     */
    protected bool useClassForNameClassLoading = true;

    protected List!EngineLifecycleListener engineLifecycleListeners;

    // Event Registry //////////////////////////////////////////////////
    protected Map!(string, EventRegistryEventConsumer) eventRegistryEventConsumers  ;//= new HashMap<>();

    // MYBATIS SQL SESSION FACTORY /////////////////////////////////////

    protected bool _isDbHistoryUsed = true;
    //protected DbSqlSessionFactory dbSqlSessionFactory;
    //protected SqlSessionFactory sqlSessionFactory;
    //protected TransactionFactory transactionFactory;
    protected TransactionContextFactory transactionContextFactory;

    /**
     * If set to true, enables bulk insert (grouping sql inserts together). Default true.
     * For some databases (eg DB2+z/OS) needs to be set to false.
     */
    protected bool _isBulkInsertEnabled = true;

    /**
     * Some databases have a limit of how many parameters one sql insert can have (eg SQL Server, 2000 params (!= insert statements) ). Tweak this parameter in case of exceptions indicating too much
     * is being put into one bulk insert, or make it higher if your database can cope with it and there are inserts with a huge amount of data.
     * <p>
     * By default: 100 (75 for mssql server as it has a hard limit of 2000 parameters in a statement)
     */
    protected int maxNrOfStatementsInBulkInsert = 100;

    public int DEFAULT_MAX_NR_OF_STATEMENTS_BULK_INSERT_SQL_SERVER = 60; // currently Execution has most params (31). 2000 / 31 = 64.

    protected string mybatisMappingFile;
    protected Set!TypeInfo customMybatisMappers;
    protected Set!string customMybatisXMLMappers; //org.flowable.eventregistory.db.mapping.mapping.xml; 加载7个xml resources org.flowable.idm.db.mapping.mappings.xml
    //protected List!Interceptor customMybatisInterceptors;

    protected Set!string dependentEngineMyBatisXmlMappers;
   // protected List!MybatisTypeAliasConfigurator dependentEngineMybatisTypeAliasConfigs; // 已经被注释；
    //protected List!MybatisTypeHandlerConfigurator dependentEngineMybatisTypeHandlerConfigs;

    // SESSION FACTORIES ///////////////////////////////////////////////
    protected List!SessionFactory customSessionFactories;
    protected Map!(TypeInfo, SessionFactory) sessionFactories;

    protected bool enableEventDispatcher = true;
    protected FlowableEventDispatcher eventDispatcher;
    protected List!FlowableEventListener eventListeners;
    protected Map!(string, List!FlowableEventListener) typedEventListeners;
    protected List!EventDispatchAction additionalEventDispatchActions;

  //  protected LoggingListener loggingListener;

    protected bool transactionsExternallyManaged;

    /**
     * Flag that can be set to configure or not a relational database is used. This is useful for custom implementations that do not use relational databases at all.
     *
     * If true (default), the {@link AbstractEngineConfiguration#getDatabaseSchemaUpdate()} value will be used to determine what needs to happen wrt the database schema.
     *
     * If false, no validation or schema creation will be done. That means that the database schema must have been created 'manually' before but the engine does not validate whether the schema is
     * correct. The {@link AbstractEngineConfiguration#getDatabaseSchemaUpdate()} value will not be used.
     */
    protected bool usingRelationalDatabase = true;

    /**
     * Flag that can be set to configure whether or not a schema is used. This is usefil for custom implementations that do not use relational databases at all.
     * Setting {@link #usingRelationalDatabase} to true will automotically imply using a schema.
     */
    protected bool usingSchemaMgmt = true;

    /**
     * Allows configuring a database table prefix which is used for all runtime operations of the process engine. For example, if you specify a prefix named 'PRE1.', Flowable will query for executions
     * in a table named 'PRE1.ACT_RU_EXECUTION_'.
     *
     * <p />
     * <strong>NOTE: the prefix is not respected by automatic database schema management. If you use {@link AbstractEngineConfiguration#DB_SCHEMA_UPDATE_CREATE_DROP} or
     * {@link AbstractEngineConfiguration#DB_SCHEMA_UPDATE_TRUE}, Flowable will create the database tables using the default names, regardless of the prefix configured here.</strong>
     */
    protected string databaseTablePrefix = "";

    /**
     * Escape character for doing wildcard searches.
     *
     * This will be added at then end of queries that include for example a LIKE clause. For example: SELECT * FROM table WHERE column LIKE '%\%%' ESCAPE '\';
     */
    protected string databaseWildcardEscapeCharacter;

    /**
     * database catalog to use
     */
    protected string databaseCatalog = "";

    /**
     * In some situations you want to set the schema to use for table checks / generation if the database metadata doesn't return that correctly, see https://jira.codehaus.org/browse/ACT-1220,
     * https://jira.codehaus.org/browse/ACT-1062
     */
    protected string databaseSchema;

    /**
     * Set to true in case the defined databaseTablePrefix is a schema-name, instead of an actual table name prefix. This is relevant for checking if Flowable-tables exist, the databaseTablePrefix
     * will not be used here - since the schema is taken into account already, adding a prefix for the table-check will result in wrong table-names.
     */
    protected bool tablePrefixIsSchema;

    /**
     * Set to true if the latest version of a definition should be retrieved, ignoring a possible parent deployment id value
     */
    protected bool alwaysLookupLatestDefinitionVersion;

    /**
     * Set to true if by default lookups should fallback to the default tenant (an empty string by default or a defined tenant value)
     */
    protected bool fallbackToDefaultTenant;

    /**
     * Default tenant provider that is executed when looking up definitions, in case the global or local fallback to default tenant value is true
     */
    protected DefaultTenantProvider defaultTenantProvider ;//= (tenantId, scope, scopeKey) -> NO_TENANT_ID;

    /**
     * Enables the MyBatis plugin that logs the execution time of sql statements.
     */
    protected bool enableLogSqlExecutionTime;

    //protected Properties databaseTypeMappings = getDefaultDatabaseTypeMappings();

    /**
     * Duration between the checks when acquiring a lock.
     */
    protected Duration lockPollRate = dur!"seconds"(10);


    /**
     * Duration to wait for the DB Schema lock before giving up.
     */
    protected Duration schemaLockWaitTime = dur!"minutes"(7);

    // DATA MANAGERS //////////////////////////////////////////////////////////////////

    protected PropertyDataManager propertyDataManager;

    // ENTITY MANAGERS ////////////////////////////////////////////////////////////////

    protected PropertyEntityManager propertyEntityManager;

    protected List!EngineDeployer customPreDeployers;
    protected List!EngineDeployer customPostDeployers;
    protected List!EngineDeployer deployers;

    // CONFIGURATORS ////////////////////////////////////////////////////////////

    protected bool enableConfiguratorServiceLoader = true; // Enabled by default. In certain environments this should be set to false (eg osgi)
    protected List!EngineConfigurator configurators; // The injected configurators
    protected List!EngineConfigurator allConfigurators; // Including auto-discovered configurators
    protected EngineConfigurator idmEngineConfigurator;
    protected EngineConfigurator eventRegistryConfigurator;

    public static  string PRODUCT_NAME_POSTGRES = "PostgreSQL";
    public static  string PRODUCT_NAME_CRDB = "CockroachDB";

    public static  string DATABASE_TYPE_H2 = "h2";
    public static  string DATABASE_TYPE_HSQL = "hsql";
    public static  string DATABASE_TYPE_MYSQL = "mysql";
    public static  string DATABASE_TYPE_ORACLE = "oracle";
    public static  string DATABASE_TYPE_POSTGRES = "postgres";
    public static  string DATABASE_TYPE_MSSQL = "mssql";
    public static  string DATABASE_TYPE_DB2 = "db2";
    public static  string DATABASE_TYPE_COCKROACHDB = "cockroachdb";

    //public static Properties getDefaultDatabaseTypeMappings() {
    //    Properties databaseTypeMappings = new Properties();
    //    databaseTypeMappings.setProperty("H2", DATABASE_TYPE_H2);
    //    databaseTypeMappings.setProperty("HSQL Database Engine", DATABASE_TYPE_HSQL);
    //    databaseTypeMappings.setProperty("MySQL", DATABASE_TYPE_MYSQL);
    //    databaseTypeMappings.setProperty("MariaDB", DATABASE_TYPE_MYSQL);
    //    databaseTypeMappings.setProperty("Oracle", DATABASE_TYPE_ORACLE);
    //    databaseTypeMappings.setProperty(PRODUCT_NAME_POSTGRES, DATABASE_TYPE_POSTGRES);
    //    databaseTypeMappings.setProperty("Microsoft SQL Server", DATABASE_TYPE_MSSQL);
    //    databaseTypeMappings.setProperty(DATABASE_TYPE_DB2, DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/NT", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/NT64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2 UDP", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/LINUX", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/LINUX390", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/LINUXX8664", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/LINUXZ64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/LINUXPPC64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/400 SQL", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/6000", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2 UDB iSeries", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/AIX64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/HPUX", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/HP64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/SUN", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/SUN64", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/PTX", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2/2", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty("DB2 UDB AS400", DATABASE_TYPE_DB2);
    //    databaseTypeMappings.setProperty(PRODUCT_NAME_CRDB, DATABASE_TYPE_COCKROACHDB);
    //    return databaseTypeMappings;
    //}

    protected Map!(Object, Object) beans;

    protected IdGenerator idGenerator;
    protected bool usePrefixId;

    protected Clockm clock;
    //protected ObjectMapper objectMapper = new ObjectMapper();

    // Variables

    public static  int DEFAULT_GENERIC_MAX_LENGTH_STRING = 4000;
    public static  int DEFAULT_ORACLE_MAX_LENGTH_STRING = 2000;

    /**
     * Define a max length for storing string variable types in the database. Mainly used for the Oracle NVARCHAR2 limit of 2000 characters
     */
    protected int maxLengthStringVariableType = -1;

    this()
    {
        engineConfigurations = new HashMap!(string, AbstractEngineConfiguration);
        serviceConfigurations = new HashMap!(string, AbstractServiceConfiguration);
        databaseSchemaUpdate = DB_SCHEMA_UPDATE_FALSE;
    }

    protected void initEngineConfigurations() {
      engineConfigurations.put(getEngineCfgKey(), this);
    }

    // DataSource
    // ///////////////////////////////////////////////////////////////

    protected void initDataSource() {
        //if (dataSource is null) {
        //    if (dataSourceJndiName !is null) {
        //        try {
        //            dataSource = (DataSource) new InitialContext().lookup(dataSourceJndiName);
        //        } catch (Exception e) {
        //            throw new FlowableException("couldn't lookup datasource from " + dataSourceJndiName + ": " + e.getMessage(), e);
        //        }
        //
        //    } else if (jdbcUrl !is null) {
        //        if ((jdbcDriver is null) || (jdbcUsername is null)) {
        //            throw new FlowableException("DataSource or JDBC properties have to be specified in a process engine configuration");
        //        }
        //
        //        logger.debug("initializing datasource to db: {}", jdbcUrl);
        //
        //        if (logger.isInfoEnabled()) {
        //            logger.info("Configuring Datasource with following properties (omitted password for security)");
        //            logger.info("datasource driver : {}", jdbcDriver);
        //            logger.info("datasource url : {}", jdbcUrl);
        //            logger.info("datasource user name : {}", jdbcUsername);
        //        }
        //
        //        PooledDataSource pooledDataSource = new PooledDataSource(this.getClass().getClassLoader(), jdbcDriver, jdbcUrl, jdbcUsername, jdbcPassword);
        //
        //        if (jdbcMaxActiveConnections > 0) {
        //            pooledDataSource.setPoolMaximumActiveConnections(jdbcMaxActiveConnections);
        //        }
        //        if (jdbcMaxIdleConnections > 0) {
        //            pooledDataSource.setPoolMaximumIdleConnections(jdbcMaxIdleConnections);
        //        }
        //        if (jdbcMaxCheckoutTime > 0) {
        //            pooledDataSource.setPoolMaximumCheckoutTime(jdbcMaxCheckoutTime);
        //        }
        //        if (jdbcMaxWaitTime > 0) {
        //            pooledDataSource.setPoolTimeToWait(jdbcMaxWaitTime);
        //        }
        //        if (jdbcPingEnabled) {
        //            pooledDataSource.setPoolPingEnabled(true);
        //            if (jdbcPingQuery !is null) {
        //                pooledDataSource.setPoolPingQuery(jdbcPingQuery);
        //            }
        //            pooledDataSource.setPoolPingConnectionsNotUsedFor(jdbcPingConnectionNotUsedFor);
        //        }
        //        if (jdbcDefaultTransactionIsolationLevel > 0) {
        //            pooledDataSource.setDefaultTransactionIsolationLevel(jdbcDefaultTransactionIsolationLevel);
        //        }
        //        dataSource = pooledDataSource;
        //    }
        //}
        //
        //if (databaseType is null) {
        //    initDatabaseType();
        //}
      //implementationMissing(false);
      EntityOption option = new EntityOption();
      option.database.driver = databaseType;
      option.database.host = "10.1.223.62";
      option.database.port = 3306;
      option.database.database = "testflow";
      option.database.username = "dev-user";
      option.database.password = "putao.123";
      option.database.charset = "utf8mb4";
      option.database.prefix = "";
      entityManagerFactory  = Persistence.createEntityManagerFactory(option);
    }

    public void initDatabaseType() {
        //Connection connection = null;
        //try {
        //    connection = dataSource.getConnection();
        //    DatabaseMetaData databaseMetaData = connection.getMetaData();
        //    string databaseProductName = databaseMetaData.getDatabaseProductName();
        //    logger.debug("database product name: '{}'", databaseProductName);
        //
        //    // CRDB does not expose the version through the jdbc driver, so we need to fetch it through version().
        //    if (PRODUCT_NAME_POSTGRES.equalsIgnoreCase(databaseProductName)) {
        //        try (PreparedStatement preparedStatement = connection.prepareStatement("select version() as version;");
        //                ResultSet resultSet = preparedStatement.executeQuery()) {
        //            string version = null;
        //            if (resultSet.next()) {
        //                version = resultSet.getString("version");
        //            }
        //
        //            if (StringUtils.isNotEmpty(version) && version.toLowerCase().startsWith(PRODUCT_NAME_CRDB.toLowerCase())) {
        //                databaseProductName = PRODUCT_NAME_CRDB;
        //                logger.info("CockroachDB version '{}' detected", version);
        //            }
        //        }
        //    }
        //
        //    databaseType = databaseTypeMappings.getProperty(databaseProductName);
        //    if (databaseType is null) {
        //        throw new FlowableException("couldn't deduct database type from database product name '" + databaseProductName + "'");
        //    }
        //    logger.debug("using database type: {}", databaseType);
        //
        //} catch (SQLException e) {
        //    logger.error("Exception while initializing Database connection", e);
        //} finally {
        //    try {
        //        if (connection !is null) {
        //            connection.close();
        //        }
        //    } catch (SQLException e) {
        //        logger.error("Exception while closing the Database connection", e);
        //    }
        //}
        //
        //// Special care for MSSQL, as it has a hard limit of 2000 params per statement (incl bulk statement).
        //// Especially with executions, with 100 as default, this limit is passed.
        //if (DATABASE_TYPE_MSSQL.equals(databaseType)) {
        //    maxNrOfStatementsInBulkInsert = DEFAULT_MAX_NR_OF_STATEMENTS_BULK_INSERT_SQL_SERVER;
        //}
      implementationMissing(false);

    }

    public void initSchemaManager() {
        //if (this.commonSchemaManager is null) {
        //    this.commonSchemaManager = new CommonDbSchemaManager();
        //}
    }

    // session factories ////////////////////////////////////////////////////////

    public void addSessionFactory(SessionFactory sessionFactory) {
        sessionFactories.put(sessionFactory.getSessionType(), sessionFactory);
    }

    public void initCommandContextFactory() {
        if (commandContextFactory is null) {
            commandContextFactory = new CommandContextFactory();
        }
    }

    public void initTransactionContextFactory() {
        //if (transactionContextFactory is null) {
        //    transactionContextFactory = new StandaloneMybatisTransactionContextFactory();
        //}
    }

    public void initCommandExecutors() {
        initDefaultCommandConfig();
        initSchemaCommandConfig();
        initCommandInvoker();
        initCommandInterceptors();
        initCommandExecutor();
    }


    public void initDefaultCommandConfig() {
        if (defaultCommandConfig is null) {
            defaultCommandConfig = new CommandConfig();
        }
    }

    public void initSchemaCommandConfig() {
        if (schemaCommandConfig is null) {
            schemaCommandConfig = new CommandConfig();
        }
    }

    public void initCommandInvoker() {
        if (commandInvoker is null) {
            commandInvoker = new DefaultCommandInvoker();
        }
    }

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

    public Collection!CommandInterceptor getDefaultCommandInterceptors() {
        if (defaultCommandInterceptors is null) {
            List!CommandInterceptor interceptors = new ArrayList!CommandInterceptor();
            interceptors.add(new LogInterceptor());

            if (DATABASE_TYPE_COCKROACHDB == (databaseType)) {
                implementationMissing(false);
              //  interceptors.add(new CrDbRetryInterceptor());
            }

            CommandInterceptor transactionInterceptor = createTransactionInterceptor();
            if (transactionInterceptor !is null) {
                interceptors.add(transactionInterceptor);
            }

            if (commandContextFactory !is null) {
                string engineCfgKey = getEngineCfgKey();
                CommandContextInterceptor commandContextInterceptor = new CommandContextInterceptor(commandContextFactory);
                engineConfigurations.put(engineCfgKey, this);
                commandContextInterceptor.setEngineConfigurations(engineConfigurations);
                commandContextInterceptor.setServiceConfigurations(serviceConfigurations);
                commandContextInterceptor.setCurrentEngineConfigurationKey(engineCfgKey);
                interceptors.add(commandContextInterceptor);
            }

            if (transactionContextFactory !is null) {
                interceptors.add(new TransactionContextInterceptor(transactionContextFactory));
            }

            List!CommandInterceptor additionalCommandInterceptors = getAdditionalDefaultCommandInterceptors();
            if (additionalCommandInterceptors !is null) {
                interceptors.addAll(additionalCommandInterceptors);
            }

            defaultCommandInterceptors = interceptors;
        }
        return defaultCommandInterceptors;
    }

    abstract string getEngineCfgKey();

    public List!CommandInterceptor getAdditionalDefaultCommandInterceptors() {
        return null;
    }

    public void initCommandExecutor() {
        if (commandExecutor is null) {
            CommandInterceptor first = initInterceptorChain(commandInterceptors);
            commandExecutor = new CommandExecutorImpl(getDefaultCommandConfig(), first);
        }
    }

    public CommandInterceptor initInterceptorChain(List!CommandInterceptor chain) {
        if (chain is null || chain.isEmpty()) {
            throw new FlowableException("invalid command interceptor chain configuration: " );
        }
        for (int i = 0; i < chain.size() - 1; i++) {
            chain.get(i).setNext(chain.get(i + 1));
        }
        return chain.get(0);
    }

    abstract CommandInterceptor createTransactionInterceptor();


    public void initBeans() {
        if (beans is null) {
            beans = new HashMap!(Object, Object)();
        }
    }

    // id generator
    // /////////////////////////////////////////////////////////////

    public void initIdGenerator() {
        if (idGenerator is null) {
            idGenerator = new StrongUuidGenerator();
        }
    }

    public void initClock() {
        if (clock is null) {
            clock = new DefaultClockImpl();
        }
    }

    // Data managers ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (propertyDataManager is null) {
            propertyDataManager = new MybatisPropertyDataManager();
        }
    }

    // Entity managers //////////////////////////////////////////////////////////

    public void initEntityManagers() {
        if (propertyEntityManager is null) {
            propertyEntityManager = new PropertyEntityManagerImpl(this, propertyDataManager);
        }
    }

    // services
    // /////////////////////////////////////////////////////////////////

    protected void initService(Object service) {
      CommonEngineServiceImpl!ProcessEngineConfigurationImpl c = cast(CommonEngineServiceImpl!ProcessEngineConfigurationImpl)service;
      if (c !is null) {
            c.setCommandExecutor(commandExecutor);
        }
    }

    // myBatis SqlSessionFactory
    // ////////////////////////////////////////////////

    public void initSessionFactories() {
        implementationMissing(false);
        //if (sessionFactories is null) {
        //    sessionFactories = new HashMap!(TypeInfo, SessionFactory);
        //
        //    if (usingRelationalDatabase) {
        //        initDbSqlSessionFactory();
        //    }
        //
        //    addSessionFactory(new GenericManagerFactory(EntityCache.class, EntityCacheImpl.class));
        //
        //    if (isLoggingSessionEnabled()) {
        //        if (!sessionFactories.containsKey(LoggingSession.class)) {
        //            LoggingSessionFactory loggingSessionFactory = new LoggingSessionFactory();
        //            loggingSessionFactory.setLoggingListener(loggingListener);
        //            loggingSessionFactory.setObjectMapper(objectMapper);
        //            sessionFactories.put(LoggingSession.class, loggingSessionFactory);
        //        }
        //    }
        //
        //    commandContextFactory.setSessionFactories(sessionFactories);
        //}
        //
        //if (customSessionFactories !is null) {
        //    for (SessionFactory sessionFactory : customSessionFactories) {
        //        addSessionFactory(sessionFactory);
        //    }
        //}
    }

    public void initDbSqlSessionFactory() {
        //if (dbSqlSessionFactory is null) {
        //    dbSqlSessionFactory = createDbSqlSessionFactory();
        //}
        //dbSqlSessionFactory.setDatabaseType(databaseType);
        //dbSqlSessionFactory.setSqlSessionFactory(sqlSessionFactory);
        //dbSqlSessionFactory.setDbHistoryUsed(isDbHistoryUsed);
        //dbSqlSessionFactory.setDatabaseTablePrefix(databaseTablePrefix);
        //dbSqlSessionFactory.setTablePrefixIsSchema(tablePrefixIsSchema);
        //dbSqlSessionFactory.setDatabaseCatalog(databaseCatalog);
        //dbSqlSessionFactory.setDatabaseSchema(databaseSchema);
        //dbSqlSessionFactory.setMaxNrOfStatementsInBulkInsert(maxNrOfStatementsInBulkInsert);
        //
        //initDbSqlSessionFactoryEntitySettings();
        //
        //addSessionFactory(dbSqlSessionFactory);
    }

    //public DbSqlSessionFactory createDbSqlSessionFactory() {
    //    return new DbSqlSessionFactory(usePrefixId);
    //}

    protected abstract void initDbSqlSessionFactoryEntitySettings();

    //protected void defaultInitDbSqlSessionFactoryEntitySettings(List<Class<? extends Entity>> insertOrder, List<Class<? extends Entity>> deleteOrder) {
    //    if (insertOrder !is null) {
    //        for (Class<? extends Entity> clazz : insertOrder) {
    //            dbSqlSessionFactory.getInsertionOrder().add(clazz);
    //
    //            if (isBulkInsertEnabled) {
    //                dbSqlSessionFactory.getBulkInserteableEntityClasses().add(clazz);
    //            }
    //        }
    //    }
    //
    //    if (deleteOrder !is null) {
    //        for (Class<? extends Entity> clazz : deleteOrder) {
    //            dbSqlSessionFactory.getDeletionOrder().add(clazz);
    //        }
    //    }
    //}

    public void initTransactionFactory() {
        //if (transactionFactory is null) {
        //    if (transactionsExternallyManaged) {
        //        transactionFactory = new ManagedTransactionFactory();
        //        Properties properties = new Properties();
        //        properties.put("closeConnection", "false");
        //        this.transactionFactory.setProperties(properties);
        //    } else {
        //        transactionFactory = new JdbcTransactionFactory();
        //    }
    }

    public void initSqlSessionFactory() {
        //if (sqlSessionFactory is null) {
        //    InputStream inputStream = null;
        //    try {
        //        inputStream = getMyBatisXmlConfigurationStream();
        //
        //        Environment environment = new Environment("default", transactionFactory, dataSource);
        //        Reader reader = new InputStreamReader(inputStream);
        //        Properties properties = new Properties();
        //        properties.put("prefix", databaseTablePrefix);
        //
        //        string wildcardEscapeClause = "";
        //        if ((databaseWildcardEscapeCharacter !is null) && (databaseWildcardEscapeCharacter.length() != 0)) {
        //            wildcardEscapeClause = " escape '" + databaseWildcardEscapeCharacter + "'";
        //        }
        //        properties.put("wildcardEscapeClause", wildcardEscapeClause);
        //
        //        // set default properties
        //        properties.put("limitBefore", "");
        //        properties.put("limitAfter", "");
        //        properties.put("limitBetween", "");
        //        properties.put("limitBetweenNoDistinct", "");
        //        properties.put("limitOuterJoinBetween", "");
        //        properties.put("limitBeforeNativeQuery", "");
        //        properties.put("blobType", "BLOB");
        //        properties.put("boolValue", "TRUE");
        //
        //        if (databaseType !is null) {
        //            properties.load(getResourceAsStream(pathToEngineDbProperties()));
        //        }
        //
        //        Configuration configuration = initMybatisConfiguration(environment, reader, properties);
        //        sqlSessionFactory = new DefaultSqlSessionFactory(configuration);
        //
        //    } catch (Exception e) {
        //        throw new FlowableException("Error while building ibatis SqlSessionFactory: " + e.getMessage(), e);
        //    } finally {
        //        IoUtil.closeSilently(inputStream);
        //    }
        //}
    }

    public string pathToEngineDbProperties() {
        return "org/flowable/common/db/properties/" ~ databaseType ~ ".properties";
    }

    //public Configuration initMybatisConfiguration(Environment environment, Reader reader, Properties properties) {
    //    XMLConfigBuilder parser = new XMLConfigBuilder(reader, "", properties);
    //    Configuration configuration = parser.getConfiguration();
    //
    //    if (databaseType !is null) {
    //        configuration.setDatabaseId(databaseType);
    //    }
    //
    //    configuration.setEnvironment(environment);
    //
    //    initCustomMybatisMappers(configuration);
    //    initMybatisTypeHandlers(configuration);
    //    initCustomMybatisInterceptors(configuration);
    //    if (isEnableLogSqlExecutionTime()) {
    //        initMyBatisLogSqlExecutionTimePlugin(configuration);
    //    }
    //
    //    configuration = parseMybatisConfiguration(parser);
    //    return configuration;
    //}

    //public void initCustomMybatisMappers(Configuration configuration) {
    //    if (getCustomMybatisMappers() !is null) {
    //        for (Class<?> clazz : getCustomMybatisMappers()) {
    //            configuration.addMapper(clazz);
    //        }
    //    }
    //}

    //public void initMybatisTypeHandlers(Configuration configuration) {
    //    // To be extended
    //}

    //public void initCustomMybatisInterceptors(Configuration configuration) {
    //  if (customMybatisInterceptors!=null){
    //    for (Interceptor interceptor :customMybatisInterceptors){
    //        configuration.addInterceptor(interceptor);
    //    }
    //  }
    //}

    //public void initMyBatisLogSqlExecutionTimePlugin(Configuration configuration) {
    //    configuration.addInterceptor(new LogSqlExecutionTimePlugin());
    //}

    //public Configuration parseMybatisConfiguration(XMLConfigBuilder parser) {
    //    Configuration configuration = parser.parse();
    //
    //    if (dependentEngineMybatisTypeAliasConfigs !is null) {
    //        for (MybatisTypeAliasConfigurator typeAliasConfig : dependentEngineMybatisTypeAliasConfigs) {
    //            typeAliasConfig.configure(configuration.getTypeAliasRegistry());
    //        }
    //    }
    //    if (dependentEngineMybatisTypeHandlerConfigs !is null) {
    //        for (MybatisTypeHandlerConfigurator typeHandlerConfig : dependentEngineMybatisTypeHandlerConfigs) {
    //            typeHandlerConfig.configure(configuration.getTypeHandlerRegistry());
    //        }
    //    }
    //
    //    parseDependentEngineMybatisXMLMappers(configuration);
    //    parseCustomMybatisXMLMappers(configuration);
    //    return configuration;
    //}
    //
    //public void parseCustomMybatisXMLMappers(Configuration configuration) {
    //    if (getCustomMybatisXMLMappers() !is null) {
    //        for (string resource : getCustomMybatisXMLMappers()) {
    //            parseMybatisXmlMapping(configuration, resource);
    //        }
    //    }
    //}
    //
    //public void parseDependentEngineMybatisXMLMappers(Configuration configuration) {
    //    if (getDependentEngineMyBatisXmlMappers() !is null) {
    //        for (string resource : getDependentEngineMyBatisXmlMappers()) {
    //            parseMybatisXmlMapping(configuration, resource);
    //        }
    //    }
    //}

    //protected void parseMybatisXmlMapping(Configuration configuration, string resource) {
    //    // see XMLConfigBuilder.mapperElement()
    //    XMLMapperBuilder mapperParser = new XMLMapperBuilder(getResourceAsStream(resource), configuration, resource, configuration.getSqlFragments());
    //    mapperParser.parse();
    //}

    protected InputStream getResourceAsStream(string resource) {
        implementationMissing(false);
        return null;
        //ClassLoader classLoader = getClassLoader();
        //if (classLoader !is null) {
        //    return getClassLoader().getResourceAsStream(resource);
        //} else {
        //    return this.getClass().getClassLoader().getResourceAsStream(resource);
        //}
    }

    public void setMybatisMappingFile(string file) {
        this.mybatisMappingFile = file;
    }

    public string getMybatisMappingFile() {
        return mybatisMappingFile;
    }
    InputStream getMyBatisXmlConfigurationStream(){
        implementationMissing(false);
        return null;
    }

    public void initConfigurators() {

        allConfigurators = new ArrayList!EngineConfigurator;
        allConfigurators.addAll(getEngineSpecificEngineConfigurators());

        // Configurators that are explicitly added to the config
        if (configurators !is null) {
            allConfigurators.addAll(configurators);
        }

        // Auto discovery through ServiceLoader
        if (enableConfiguratorServiceLoader) {
            //ClassLoader classLoader = getClassLoader();
            //if (classLoader is null) {
            //    classLoader = ReflectUtil.getClassLoader();
            //}
            //
            //ServiceLoader<EngineConfigurator> configuratorServiceLoader = ServiceLoader.load(EngineConfigurator.class, classLoader);
            //int nrOfServiceLoadedConfigurators = 0;
            //for (EngineConfigurator configurator : configuratorServiceLoader) {
            //    allConfigurators.add(configurator);
            //    nrOfServiceLoadedConfigurators++;
            //}
            //
            //if (nrOfServiceLoadedConfigurators > 0) {
            //    logger.info("Found {} auto-discoverable Process Engine Configurator{}", nrOfServiceLoadedConfigurators, nrOfServiceLoadedConfigurators > 1 ? "s" : "");
            //}

            if (!allConfigurators.isEmpty()) {

                // Order them according to the priorities (useful for dependent
                // configurator)
                //Collections.sort(allConfigurators, new Comparator<EngineConfigurator>() {
                //    @Override
                //    public int compare(EngineConfigurator configurator1, EngineConfigurator configurator2) {
                //        int priority1 = configurator1.getPriority();
                //        int priority2 = configurator2.getPriority();
                //
                //        if (priority1 < priority2) {
                //            return -1;
                //        } else if (priority1 > priority2) {
                //            return 1;
                //        }
                //        return 0;
                //    }
                //});

                // Execute the configurators
                logInfo("Found {%d} Engine Configurators in total:", allConfigurators.size());
                foreach (EngineConfigurator configurator ; allConfigurators) {
                    logInfo("{} (priority:{%d})",  configurator.getPriority());
                }

            }

        }
    }

    public void close()
    {
        //if (forceCloseMybatisConnectionPool && dataSource instanceof PooledDataSource) {
        //    /*
        //     * When the datasource is created by a Flowable engine (i.e. it's an instance of PooledDataSource),
        //     * the connection pool needs to be closed when closing the engine.
        //     * Note that calling forceCloseAll() multiple times (as is the case when running with multiple engine) is ok.
        //     */
        //    ((PooledDataSource) dataSource).forceCloseAll();
        //}
      implementationMissing(false);
    }

    protected List!EngineConfigurator getEngineSpecificEngineConfigurators() {
        // meant to be overridden if needed
        return Collections.emptyList!EngineConfigurator();
    }

    public void configuratorsBeforeInit() {
        foreach (EngineConfigurator configurator ; allConfigurators) {
            logInfo("Executing beforeInit() of {} (priority:{ %d})", configurator.getPriority());
            configurator.beforeInit(this);
        }
    }

    public void configuratorsAfterInit() {
        foreach (EngineConfigurator configurator ; allConfigurators) {
            logInfo("Executing configure() of {} (priority:{%d})" ,configurator.getPriority());
            configurator.configure(this);
        }
    }

    //public LockManager getLockManager(string lockName) {
    //    return new LockManagerImpl(commandExecutor, lockName, getLockPollRate());
    //}

    // getters and setters
    // //////////////////////////////////////////////////////

    abstract string getEngineName();

    //public ClassLoader getClassLoader() {
    //    return classLoader;
    //}

    //public AbstractEngineConfiguration setClassLoader(ClassLoader classLoader) {
    //    this.classLoader = classLoader;
    //    return this;
    //}

    public bool isUseClassForNameClassLoading() {
        return useClassForNameClassLoading;
    }

    public AbstractEngineConfiguration setUseClassForNameClassLoading(bool useClassForNameClassLoading) {
        this.useClassForNameClassLoading = useClassForNameClassLoading;
        return this;
    }

    public void addEngineLifecycleListener(EngineLifecycleListener engineLifecycleListener) {
        if (this.engineLifecycleListeners is null) {
            this.engineLifecycleListeners = new ArrayList!EngineLifecycleListener();
        }
        this.engineLifecycleListeners.add(engineLifecycleListener);
    }

    public List!EngineLifecycleListener getEngineLifecycleListeners() {
        return engineLifecycleListeners;
    }

    public AbstractEngineConfiguration setEngineLifecycleListeners(List!EngineLifecycleListener engineLifecycleListeners) {
        this.engineLifecycleListeners = engineLifecycleListeners;
        return this;
    }

    public string getDatabaseType() {
        return databaseType;
    }

    public AbstractEngineConfiguration setDatabaseType(string databaseType) {
        this.databaseType = databaseType;
        return this;
    }

    //public DataSource getDataSource() {
    //    return dataSource;
    //}
    //
    //public AbstractEngineConfiguration setDataSource(DataSource dataSource) {
    //    this.dataSource = dataSource;
    //    return this;
    //}
    //
    //public SchemaManager getSchemaManager() {
    //    return schemaManager;
    //}
    //
    //public AbstractEngineConfiguration setSchemaManager(SchemaManager schemaManager) {
    //    this.schemaManager = schemaManager;
    //    return this;
    //}
    //
    //public SchemaManager getCommonSchemaManager() {
    //    return commonSchemaManager;
    //}
    //
    //public AbstractEngineConfiguration setCommonSchemaManager(SchemaManager commonSchemaManager) {
    //    this.commonSchemaManager = commonSchemaManager;
    //    return this;
    //}
    //
    //public Command<Void> getSchemaManagementCmd() {
    //    return schemaManagementCmd;
    //}
    //
    //public AbstractEngineConfiguration setSchemaManagementCmd(Command<Void> schemaManagementCmd) {
    //    this.schemaManagementCmd = schemaManagementCmd;
    //    return this;
    //}

    public string getJdbcDriver() {
        return jdbcDriver;
    }

    public AbstractEngineConfiguration setJdbcDriver(string jdbcDriver) {
        this.jdbcDriver = jdbcDriver;
        return this;
    }

    public string getJdbcUrl() {
        return jdbcUrl;
    }

    public AbstractEngineConfiguration setJdbcUrl(string jdbcUrl) {
        this.jdbcUrl = jdbcUrl;
        return this;
    }

    public string getJdbcUsername() {
        return jdbcUsername;
    }

    public AbstractEngineConfiguration setJdbcUsername(string jdbcUsername) {
        this.jdbcUsername = jdbcUsername;
        return this;
    }

    public string getJdbcPassword() {
        return jdbcPassword;
    }

    public AbstractEngineConfiguration setJdbcPassword(string jdbcPassword) {
        this.jdbcPassword = jdbcPassword;
        return this;
    }

    public int getJdbcMaxActiveConnections() {
        return jdbcMaxActiveConnections;
    }

    public AbstractEngineConfiguration setJdbcMaxActiveConnections(int jdbcMaxActiveConnections) {
        this.jdbcMaxActiveConnections = jdbcMaxActiveConnections;
        return this;
    }

    public int getJdbcMaxIdleConnections() {
        return jdbcMaxIdleConnections;
    }

    public AbstractEngineConfiguration setJdbcMaxIdleConnections(int jdbcMaxIdleConnections) {
        this.jdbcMaxIdleConnections = jdbcMaxIdleConnections;
        return this;
    }

    public int getJdbcMaxCheckoutTime() {
        return jdbcMaxCheckoutTime;
    }

    public AbstractEngineConfiguration setJdbcMaxCheckoutTime(int jdbcMaxCheckoutTime) {
        this.jdbcMaxCheckoutTime = jdbcMaxCheckoutTime;
        return this;
    }

    public int getJdbcMaxWaitTime() {
        return jdbcMaxWaitTime;
    }

    public AbstractEngineConfiguration setJdbcMaxWaitTime(int jdbcMaxWaitTime) {
        this.jdbcMaxWaitTime = jdbcMaxWaitTime;
        return this;
    }

    public bool isJdbcPingEnabled() {
        return jdbcPingEnabled;
    }

    public AbstractEngineConfiguration setJdbcPingEnabled(bool jdbcPingEnabled) {
        this.jdbcPingEnabled = jdbcPingEnabled;
        return this;
    }

    public int getJdbcPingConnectionNotUsedFor() {
        return jdbcPingConnectionNotUsedFor;
    }

    public AbstractEngineConfiguration setJdbcPingConnectionNotUsedFor(int jdbcPingConnectionNotUsedFor) {
        this.jdbcPingConnectionNotUsedFor = jdbcPingConnectionNotUsedFor;
        return this;
    }

    public int getJdbcDefaultTransactionIsolationLevel() {
        return jdbcDefaultTransactionIsolationLevel;
    }

    public AbstractEngineConfiguration setJdbcDefaultTransactionIsolationLevel(int jdbcDefaultTransactionIsolationLevel) {
        this.jdbcDefaultTransactionIsolationLevel = jdbcDefaultTransactionIsolationLevel;
        return this;
    }

    public string getJdbcPingQuery() {
        return jdbcPingQuery;
    }

    public AbstractEngineConfiguration setJdbcPingQuery(string jdbcPingQuery) {
        this.jdbcPingQuery = jdbcPingQuery;
        return this;
    }

    public string getDataSourceJndiName() {
        return dataSourceJndiName;
    }

    public AbstractEngineConfiguration setDataSourceJndiName(string dataSourceJndiName) {
        this.dataSourceJndiName = dataSourceJndiName;
        return this;
    }

    public CommandConfig getSchemaCommandConfig() {
        return schemaCommandConfig;
    }

    public AbstractEngineConfiguration setSchemaCommandConfig(CommandConfig schemaCommandConfig) {
        this.schemaCommandConfig = schemaCommandConfig;
        return this;
    }

    public bool isTransactionsExternallyManaged() {
        return transactionsExternallyManaged;
    }

    public AbstractEngineConfiguration setTransactionsExternallyManaged(bool transactionsExternallyManaged) {
        this.transactionsExternallyManaged = transactionsExternallyManaged;
        return this;
    }

    public Map!(Object, Object) getBeans() {
        return beans;
    }

    public AbstractEngineConfiguration setBeans(Map!(Object, Object) beans) {
        this.beans = beans;
        return this;
    }

    public IdGenerator getIdGenerator() {
        return idGenerator;
    }

    public AbstractEngineConfiguration setIdGenerator(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
        return this;
    }

    public bool isUsePrefixId() {
        return usePrefixId;
    }

    public AbstractEngineConfiguration setUsePrefixId(bool usePrefixId) {
        this.usePrefixId = usePrefixId;
        return this;
    }

    public string getXmlEncoding() {
        return xmlEncoding;
    }

    public AbstractEngineConfiguration setXmlEncoding(string xmlEncoding) {
        this.xmlEncoding = xmlEncoding;
        return this;
    }

    public CommandConfig getDefaultCommandConfig() {
        return defaultCommandConfig;
    }

    public AbstractEngineConfiguration setDefaultCommandConfig(CommandConfig defaultCommandConfig) {
        this.defaultCommandConfig = defaultCommandConfig;
        return this;
    }

    public CommandExecutor getCommandExecutor() {
        return commandExecutor;
    }

    public AbstractEngineConfiguration setCommandExecutor(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
        return this;
    }

    public CommandContextFactory getCommandContextFactory() {
        return commandContextFactory;
    }

    public AbstractEngineConfiguration setCommandContextFactory(CommandContextFactory commandContextFactory) {
        this.commandContextFactory = commandContextFactory;
        return this;
    }

    public CommandInterceptor getCommandInvoker() {
        return commandInvoker;
    }

    public AbstractEngineConfiguration setCommandInvoker(CommandInterceptor commandInvoker) {
        this.commandInvoker = commandInvoker;
        return this;
    }

    public List!CommandInterceptor getCustomPreCommandInterceptors() {
        return customPreCommandInterceptors;
    }

    public AbstractEngineConfiguration setCustomPreCommandInterceptors(List!CommandInterceptor customPreCommandInterceptors) {
        this.customPreCommandInterceptors = customPreCommandInterceptors;
        return this;
    }

    public List!CommandInterceptor getCustomPostCommandInterceptors() {
        return customPostCommandInterceptors;
    }

    public AbstractEngineConfiguration setCustomPostCommandInterceptors(List!CommandInterceptor customPostCommandInterceptors) {
        this.customPostCommandInterceptors = customPostCommandInterceptors;
        return this;
    }

    public List!CommandInterceptor getCommandInterceptors() {
        return commandInterceptors;
    }

    public AbstractEngineConfiguration setCommandInterceptors(List!CommandInterceptor commandInterceptors) {
        this.commandInterceptors = commandInterceptors;
        return this;
    }

    public Map!(string, AbstractEngineConfiguration) getEngineConfigurations() {
        return engineConfigurations;
    }

    public AbstractEngineConfiguration setEngineConfigurations(Map!(string, AbstractEngineConfiguration) engineConfigurations) {
        this.engineConfigurations = engineConfigurations;
        return this;
    }

    public void addEngineConfiguration(string key, AbstractEngineConfiguration engineConfiguration) {
        if (engineConfigurations is null) {
            engineConfigurations = new HashMap!(string, AbstractEngineConfiguration)();
        }
        engineConfigurations.put(key, engineConfiguration);
    }

    public Map!(string, AbstractServiceConfiguration) getServiceConfigurations() {
        return serviceConfigurations;
    }

    public AbstractEngineConfiguration setServiceConfigurations(Map!(string, AbstractServiceConfiguration) serviceConfigurations) {
        this.serviceConfigurations = serviceConfigurations;
        return this;
    }

    public void addServiceConfiguration(string key, AbstractServiceConfiguration serviceConfiguration) {
        if (serviceConfigurations is null) {
            serviceConfigurations = new HashMap!(string, AbstractServiceConfiguration)();
        }
        serviceConfigurations.put(key, serviceConfiguration);
    }

    public Map!(string, EventRegistryEventConsumer) getEventRegistryEventConsumers() {
        return eventRegistryEventConsumers;
    }

    public AbstractEngineConfiguration setEventRegistryEventConsumers(Map!(string, EventRegistryEventConsumer) eventRegistryEventConsumers) {
        this.eventRegistryEventConsumers = eventRegistryEventConsumers;
        return this;
    }

    public void addEventRegistryEventConsumer(string key, EventRegistryEventConsumer eventRegistryEventConsumer) {
        if (eventRegistryEventConsumers is null) {
            eventRegistryEventConsumers = new HashMap!(string, EventRegistryEventConsumer)();
        }
        eventRegistryEventConsumers.put(key, eventRegistryEventConsumer);
    }

    public AbstractEngineConfiguration setDefaultCommandInterceptors(Collection!CommandInterceptor defaultCommandInterceptors) {
        this.defaultCommandInterceptors = defaultCommandInterceptors;
        return this;
    }

    //public SqlSessionFactory getSqlSessionFactory() {
    //    return sqlSessionFactory;
    //}
    //
    //public AbstractEngineConfiguration setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
    //    this.sqlSessionFactory = sqlSessionFactory;
    //    return this;
    //}

    public bool isDbHistoryUsed() {
        return _isDbHistoryUsed;
    }

    public AbstractEngineConfiguration setDbHistoryUsed(bool isDbHistoryUsed) {
        this._isDbHistoryUsed = isDbHistoryUsed;
        return this;
    }

    //public DbSqlSessionFactory getDbSqlSessionFactory() {
    //    return dbSqlSessionFactory;
    //}
    //
    //public AbstractEngineConfiguration setDbSqlSessionFactory(DbSqlSessionFactory dbSqlSessionFactory) {
    //    this.dbSqlSessionFactory = dbSqlSessionFactory;
    //    return this;
    //}
    //
    //public TransactionFactory getTransactionFactory() {
    //    return transactionFactory;
    //}
    //
    //public AbstractEngineConfiguration setTransactionFactory(TransactionFactory transactionFactory) {
    //    this.transactionFactory = transactionFactory;
    //    return this;
    //}

    public TransactionContextFactory getTransactionContextFactory() {
        return transactionContextFactory;
    }

    public AbstractEngineConfiguration setTransactionContextFactory(TransactionContextFactory transactionContextFactory) {
        this.transactionContextFactory = transactionContextFactory;
        return this;
    }

    public int getMaxNrOfStatementsInBulkInsert() {
        return maxNrOfStatementsInBulkInsert;
    }

    public AbstractEngineConfiguration setMaxNrOfStatementsInBulkInsert(int maxNrOfStatementsInBulkInsert) {
        this.maxNrOfStatementsInBulkInsert = maxNrOfStatementsInBulkInsert;
        return this;
    }

    public bool isBulkInsertEnabled() {
        return _isBulkInsertEnabled;
    }

    public AbstractEngineConfiguration setBulkInsertEnabled(bool isBulkInsertEnabled) {
        this._isBulkInsertEnabled = isBulkInsertEnabled;
        return this;
    }

    //public Set<Class<?>> getCustomMybatisMappers() {
    //    return customMybatisMappers;
    //}

    //public AbstractEngineConfiguration setCustomMybatisMappers(Set<Class<?>> customMybatisMappers) {
    //    this.customMybatisMappers = customMybatisMappers;
    //    return this;
    //}

    public Set!string getCustomMybatisXMLMappers() {
        return customMybatisXMLMappers;
    }

    public AbstractEngineConfiguration setCustomMybatisXMLMappers(Set!string customMybatisXMLMappers) {
        this.customMybatisXMLMappers = customMybatisXMLMappers;
        return this;
    }

    public Set!string getDependentEngineMyBatisXmlMappers() {
        return dependentEngineMyBatisXmlMappers;
    }

    //public AbstractEngineConfiguration setCustomMybatisInterceptors(List<Interceptor> customMybatisInterceptors) {
    //    this.customMybatisInterceptors = customMybatisInterceptors;
    //    return  this;
    //}
    //
    //public List<Interceptor> getCustomMybatisInterceptors() {
    //    return customMybatisInterceptors;
    //}

    public AbstractEngineConfiguration setDependentEngineMyBatisXmlMappers(Set!string dependentEngineMyBatisXmlMappers) {
        this.dependentEngineMyBatisXmlMappers = dependentEngineMyBatisXmlMappers;
        return this;
    }

    //public List<MybatisTypeAliasConfigurator> getDependentEngineMybatisTypeAliasConfigs() {
    //    return dependentEngineMybatisTypeAliasConfigs;
    //}
    //
    //public AbstractEngineConfiguration setDependentEngineMybatisTypeAliasConfigs(List<MybatisTypeAliasConfigurator> dependentEngineMybatisTypeAliasConfigs) {
    //    this.dependentEngineMybatisTypeAliasConfigs = dependentEngineMybatisTypeAliasConfigs;
    //    return this;
    //}
    //
    //public List<MybatisTypeHandlerConfigurator> getDependentEngineMybatisTypeHandlerConfigs() {
    //    return dependentEngineMybatisTypeHandlerConfigs;
    //}
    //
    //public AbstractEngineConfiguration setDependentEngineMybatisTypeHandlerConfigs(List<MybatisTypeHandlerConfigurator> dependentEngineMybatisTypeHandlerConfigs) {
    //    this.dependentEngineMybatisTypeHandlerConfigs = dependentEngineMybatisTypeHandlerConfigs;
    //    return this;
    //}

    public List!SessionFactory getCustomSessionFactories() {
        return customSessionFactories;
    }

    public AbstractEngineConfiguration addCustomSessionFactory(SessionFactory sessionFactory) {
        if (customSessionFactories is null) {
            customSessionFactories = new ArrayList!SessionFactory();
        }
        customSessionFactories.add(sessionFactory);
        return this;
    }

    public AbstractEngineConfiguration setCustomSessionFactories(List!SessionFactory customSessionFactories) {
        this.customSessionFactories = customSessionFactories;
        return this;
    }

    public bool isUsingRelationalDatabase() {
        return usingRelationalDatabase;
    }

    public AbstractEngineConfiguration setUsingRelationalDatabase(bool usingRelationalDatabase) {
        this.usingRelationalDatabase = usingRelationalDatabase;
        return this;
    }

    public bool isUsingSchemaMgmt() {
        return usingSchemaMgmt;
    }

    public AbstractEngineConfiguration setUsingSchemaMgmt(bool usingSchema) {
        this.usingSchemaMgmt = usingSchema;
        return this;
    }

    public string getDatabaseTablePrefix() {
        return databaseTablePrefix;
    }

    public AbstractEngineConfiguration setDatabaseTablePrefix(string databaseTablePrefix) {
        this.databaseTablePrefix = databaseTablePrefix;
        return this;
    }

    public string getDatabaseWildcardEscapeCharacter() {
        return databaseWildcardEscapeCharacter;
    }

    public AbstractEngineConfiguration setDatabaseWildcardEscapeCharacter(string databaseWildcardEscapeCharacter) {
        this.databaseWildcardEscapeCharacter = databaseWildcardEscapeCharacter;
        return this;
    }

    public string getDatabaseCatalog() {
        return databaseCatalog;
    }

    public AbstractEngineConfiguration setDatabaseCatalog(string databaseCatalog) {
        this.databaseCatalog = databaseCatalog;
        return this;
    }

    public string getDatabaseSchema() {
        return databaseSchema;
    }

    public AbstractEngineConfiguration setDatabaseSchema(string databaseSchema) {
        this.databaseSchema = databaseSchema;
        return this;
    }

    public bool isTablePrefixIsSchema() {
        return tablePrefixIsSchema;
    }

    public AbstractEngineConfiguration setTablePrefixIsSchema(bool tablePrefixIsSchema) {
        this.tablePrefixIsSchema = tablePrefixIsSchema;
        return this;
    }

    public bool isAlwaysLookupLatestDefinitionVersion() {
        return alwaysLookupLatestDefinitionVersion;
    }

    public AbstractEngineConfiguration setAlwaysLookupLatestDefinitionVersion(bool alwaysLookupLatestDefinitionVersion) {
        this.alwaysLookupLatestDefinitionVersion = alwaysLookupLatestDefinitionVersion;
        return this;
    }

    public bool isFallbackToDefaultTenant() {
        return fallbackToDefaultTenant;
    }

    public AbstractEngineConfiguration setFallbackToDefaultTenant(bool fallbackToDefaultTenant) {
        this.fallbackToDefaultTenant = fallbackToDefaultTenant;
        return this;
    }

    /**
     * @return name of the default tenant
     * @deprecated use {@link AbstractEngineConfiguration#getDefaultTenantProvider()} instead
     */
    public string getDefaultTenantValue() {
        implementationMissing(false);
        return "";
        //return getDefaultTenantProvider().getDefaultTenant(null, null, null);
    }

    //public AbstractEngineConfiguration setDefaultTenantValue(string defaultTenantValue) {
    //    this.defaultTenantProvider = (tenantId, scope, scopeKey) -> defaultTenantValue;
    //    return this;
    //}
    //
    public DefaultTenantProvider getDefaultTenantProvider() {
        return defaultTenantProvider;
    }
    //
    public AbstractEngineConfiguration setDefaultTenantProvider(DefaultTenantProvider defaultTenantProvider) {
        this.defaultTenantProvider = defaultTenantProvider;
        return this;
    }

    public bool isEnableLogSqlExecutionTime() {
        return enableLogSqlExecutionTime;
    }

    public void setEnableLogSqlExecutionTime(bool enableLogSqlExecutionTime) {
        this.enableLogSqlExecutionTime = enableLogSqlExecutionTime;
    }

    //public Map<Class<?>, SessionFactory> getSessionFactories() {
    //    return sessionFactories;
    //}
    //
    //public AbstractEngineConfiguration setSessionFactories(Map<Class<?>, SessionFactory> sessionFactories) {
    //    this.sessionFactories = sessionFactories;
    //    return this;
    //}

    public string getDatabaseSchemaUpdate() {
        return databaseSchemaUpdate;
    }

    public AbstractEngineConfiguration setDatabaseSchemaUpdate(string databaseSchemaUpdate) {
        this.databaseSchemaUpdate = databaseSchemaUpdate;
        return this;
    }

    public bool isUseLockForDatabaseSchemaUpdate() {
        return useLockForDatabaseSchemaUpdate;
    }

    public AbstractEngineConfiguration setUseLockForDatabaseSchemaUpdate(bool useLockForDatabaseSchemaUpdate) {
        this.useLockForDatabaseSchemaUpdate = useLockForDatabaseSchemaUpdate;
        return this;
    }

    public bool isEnableEventDispatcher() {
        return enableEventDispatcher;
    }

    public AbstractEngineConfiguration setEnableEventDispatcher(bool enableEventDispatcher) {
        this.enableEventDispatcher = enableEventDispatcher;
        return this;
    }

    public FlowableEventDispatcher getEventDispatcher() {
        return eventDispatcher;
    }

    public AbstractEngineConfiguration setEventDispatcher(FlowableEventDispatcher eventDispatcher) {
        this.eventDispatcher = eventDispatcher;
        return this;
    }

    public List!FlowableEventListener getEventListeners() {
        return eventListeners;
    }

    public AbstractEngineConfiguration setEventListeners(List!FlowableEventListener eventListeners) {
        this.eventListeners = eventListeners;
        return this;
    }

    public Map!(string, List!FlowableEventListener) getTypedEventListeners() {
        return typedEventListeners;
    }

    public AbstractEngineConfiguration setTypedEventListeners(Map!(string, List!FlowableEventListener) typedEventListeners) {
        this.typedEventListeners = typedEventListeners;
        return this;
    }

    public List!EventDispatchAction getAdditionalEventDispatchActions() {
        return additionalEventDispatchActions;
    }

    public AbstractEngineConfiguration setAdditionalEventDispatchActions(List!EventDispatchAction additionalEventDispatchActions) {
        this.additionalEventDispatchActions = additionalEventDispatchActions;
        return this;
    }

    public void initEventDispatcher() {
        if (this.eventDispatcher is null) {
            this.eventDispatcher = new FlowableEventDispatcherImpl();
        }

        initAdditionalEventDispatchActions();

        this.eventDispatcher.setEnabled(enableEventDispatcher);

        initEventListeners();
        initTypedEventListeners();
    }

    protected void initEventListeners() {
        if (eventListeners !is null) {
            foreach (FlowableEventListener listenerToAdd ; eventListeners) {
                this.eventDispatcher.addEventListener(listenerToAdd);
            }
        }
    }

    protected void initAdditionalEventDispatchActions() {
        if (this.additionalEventDispatchActions is null) {
            this.additionalEventDispatchActions = new ArrayList!EventDispatchAction();
        }
    }

    protected void initTypedEventListeners() {
        if (typedEventListeners !is null) {
            foreach (MapEntry!(string, List!FlowableEventListener) listenersToAdd ; typedEventListeners) {
                // Extract types from the given string
                FlowableEngineEventType[] types = FlowableEngineEventType.getTypesFromString(listenersToAdd.getKey());
                FlowableEventType[] castTypes;
                foreach(FlowableEngineEventType t ; types)
                {
                    castTypes ~= cast(FlowableEventType)t;
                }

                foreach (FlowableEventListener listenerToAdd ; listenersToAdd.getValue()) {
                    this.eventDispatcher.addEventListener(listenerToAdd, castTypes);
                }
            }
        }
    }

    //public bool isLoggingSessionEnabled() {
    //    return loggingListener !is null;
    //}
    //
    //public LoggingListener getLoggingListener() {
    //    return loggingListener;
    //}
    //
    //public void setLoggingListener(LoggingListener loggingListener) {
    //    this.loggingListener = loggingListener;
    //}

    public Clockm getClock() {
        return clock;
    }

    public AbstractEngineConfiguration setClock(Clockm clock) {
        this.clock = clock;
        return this;
    }

    //public ObjectMapper getObjectMapper() {
    //    return objectMapper;
    //}
    //
    //public AbstractEngineConfiguration setObjectMapper(ObjectMapper objectMapper) {
    //    this.objectMapper = objectMapper;
    //    return this;
    //}

    public int getMaxLengthString() {
        return -1;
        //if (maxLengthStringVariableType == -1) {
        //    if ("oracle".equalsIgnoreCase(databaseType)) {
        //        return DEFAULT_ORACLE_MAX_LENGTH_STRING;
        //    } else {
        //        return DEFAULT_GENERIC_MAX_LENGTH_STRING;
        //    }
        //} else {
        //    return maxLengthStringVariableType;
        //}
    }

    public int getMaxLengthStringVariableType() {
        return maxLengthStringVariableType;
    }

    public AbstractEngineConfiguration setMaxLengthStringVariableType(int maxLengthStringVariableType) {
        this.maxLengthStringVariableType = maxLengthStringVariableType;
        return this;
    }

    public PropertyDataManager getPropertyDataManager() {
        return propertyDataManager;
    }

    public Duration getLockPollRate() {
        return lockPollRate;
    }

    public AbstractEngineConfiguration setLockPollRate(Duration lockPollRate) {
        this.lockPollRate = lockPollRate;
        return this;
    }

    public Duration getSchemaLockWaitTime() {
        return schemaLockWaitTime;
    }

    public void setSchemaLockWaitTime(Duration schemaLockWaitTime) {
        this.schemaLockWaitTime = schemaLockWaitTime;
    }

    public AbstractEngineConfiguration setPropertyDataManager(PropertyDataManager propertyDataManager) {
        this.propertyDataManager = propertyDataManager;
        return this;
    }

    public PropertyEntityManager getPropertyEntityManager() {
        return propertyEntityManager;
    }

    public AbstractEngineConfiguration setPropertyEntityManager(PropertyEntityManager propertyEntityManager) {
        this.propertyEntityManager = propertyEntityManager;
        return this;
    }

    public List!EngineDeployer getDeployers() {
        return deployers;
    }

    public AbstractEngineConfiguration setDeployers(List!EngineDeployer deployers) {
        this.deployers = deployers;
        return this;
    }

    public List!EngineDeployer getCustomPreDeployers() {
        return customPreDeployers;
    }

    public AbstractEngineConfiguration setCustomPreDeployers(List!EngineDeployer customPreDeployers) {
        this.customPreDeployers = customPreDeployers;
        return this;
    }

    public List!EngineDeployer getCustomPostDeployers() {
        return customPostDeployers;
    }

    public AbstractEngineConfiguration setCustomPostDeployers(List!EngineDeployer customPostDeployers) {
        this.customPostDeployers = customPostDeployers;
        return this;
    }

    public bool isEnableConfiguratorServiceLoader() {
        return enableConfiguratorServiceLoader;
    }

    public AbstractEngineConfiguration setEnableConfiguratorServiceLoader(bool enableConfiguratorServiceLoader) {
        this.enableConfiguratorServiceLoader = enableConfiguratorServiceLoader;
        return this;
    }

    public List!EngineConfigurator getConfigurators() {
        return configurators;
    }

    public AbstractEngineConfiguration addConfigurator(EngineConfigurator configurator) {
        if (configurators is null) {
            configurators = new ArrayList!EngineConfigurator();
        }
        configurators.add(configurator);
        return this;
    }

    /**
     * @return All {@link EngineConfigurator} instances. Will only contain values after init of the engine.
     * Use the {@link #getConfigurators()} or {@link #addConfigurator(EngineConfigurator)} methods otherwise.
     */
    public List!EngineConfigurator getAllConfigurators() {
        return allConfigurators;
    }

    public AbstractEngineConfiguration setConfigurators(List!EngineConfigurator configurators) {
        this.configurators = configurators;
        return this;
    }

    public EngineConfigurator getIdmEngineConfigurator() {
        return idmEngineConfigurator;
    }

    public AbstractEngineConfiguration setIdmEngineConfigurator(EngineConfigurator idmEngineConfigurator) {
        this.idmEngineConfigurator = idmEngineConfigurator;
        return this;
    }

    public EngineConfigurator getEventRegistryConfigurator() {
        return eventRegistryConfigurator;
    }

    public AbstractEngineConfiguration setEventRegistryConfigurator(EngineConfigurator eventRegistryConfigurator) {
        this.eventRegistryConfigurator = eventRegistryConfigurator;
        return this;
    }

    public AbstractEngineConfiguration setForceCloseMybatisConnectionPool(bool forceCloseMybatisConnectionPool) {
        this.forceCloseMybatisConnectionPool = forceCloseMybatisConnectionPool;
        return this;
    }

    public bool isForceCloseMybatisConnectionPool() {
        return forceCloseMybatisConnectionPool;
    }
}
