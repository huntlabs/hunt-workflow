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
//
//import java.sql.Connection;
//import java.sql.DatabaseMetaData;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import hunt.collection.ArrayList;
//import hunt.collections;
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import org.apache.ibatis.session.RowBounds;
//import flow.common.api.FlowableException;
//import flow.common.api.management.TableMetaData;
//import flow.common.api.management.TablePage;
//import flow.common.db.DbSqlSession;
//import flow.common.persistence.entity.Entity;
//import flow.common.persistence.entity.PropertyEntity;
//import flow.engine.history.HistoricActivityInstance;
//import flow.engine.history.HistoricDetail;
//import flow.engine.history.HistoricFormProperty;
//import flow.engine.history.HistoricProcessInstance;
//import flow.engine.history.HistoricVariableUpdate;
//import flow.engine.impl.TablePageQueryImpl;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.AbstractManager;
//import flow.engine.repository.Deployment;
//import flow.engine.repository.Model;
//import flow.engine.repository.ProcessDefinition;
//import flow.engine.runtime.Execution;
//import flow.engine.runtime.ProcessInstance;
//import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
//import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
//import flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;
//import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
//import flow.job.service.api.Job;
//import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
//import flow.job.service.impl.persistence.entity.JobEntity;
//import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
//import flow.job.service.impl.persistence.entity.TimerJobEntity;
//import flow.task.api.Task;
//import flow.task.api.history.HistoricTaskLogEntry;
//import flow.task.api.history.HistoricTaskInstance;
//import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
//import flow.task.service.impl.persistence.entity.HistoricTaskLogEntryEntity;
//import flow.task.service.impl.persistence.entity.TaskEntity;
//import flow.variable.service.api.history.HistoricVariableInstance;
//import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
//import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * @author Tom Baeyens
// */
//class TableDataManagerImpl : AbstractManager implements TableDataManager {
//
//    public TableDataManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
//        super(processEngineConfiguration);
//    }
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(TableDataManagerImpl.class);
//
//    public static Map<Class<?>, string> apiTypeToTableNameMap = new HashMap<>();
//    public static Map<Class<? : Entity>, string> entityToTableNameMap = new HashMap<>();
//
//    static {
//        // runtime
//        entityToTableNameMap.put(TaskEntity.class, "ACT_RU_TASK");
//        entityToTableNameMap.put(ExecutionEntity.class, "ACT_RU_EXECUTION");
//        entityToTableNameMap.put(IdentityLinkEntity.class, "ACT_RU_IDENTITYLINK");
//        entityToTableNameMap.put(VariableInstanceEntity.class, "ACT_RU_VARIABLE");
//
//        entityToTableNameMap.put(JobEntity.class, "ACT_RU_JOB");
//        entityToTableNameMap.put(TimerJobEntity.class, "ACT_RU_TIMER_JOB");
//        entityToTableNameMap.put(SuspendedJobEntity.class, "ACT_RU_SUSPENDED_JOB");
//        entityToTableNameMap.put(DeadLetterJobEntity.class, "ACT_RU_DEADLETTER_JOB");
//
//        entityToTableNameMap.put(EventSubscriptionEntity.class, "ACT_RU_EVENT_SUBSCR");
//        entityToTableNameMap.put(CompensateEventSubscriptionEntity.class, "ACT_RU_EVENT_SUBSCR");
//        entityToTableNameMap.put(MessageEventSubscriptionEntity.class, "ACT_RU_EVENT_SUBSCR");
//        entityToTableNameMap.put(SignalEventSubscriptionEntity.class, "ACT_RU_EVENT_SUBSCR");
//        entityToTableNameMap.put(ActivityInstanceEntity.class, "ACT_RU_ACTINST");
//
//        // repository
//        entityToTableNameMap.put(DeploymentEntity.class, "ACT_RE_DEPLOYMENT");
//        entityToTableNameMap.put(ProcessDefinitionEntity.class, "ACT_RE_PROCDEF");
//        entityToTableNameMap.put(ModelEntity.class, "ACT_RE_MODEL");
//        entityToTableNameMap.put(ProcessDefinitionInfoEntity.class, "ACT_PROCDEF_INFO");
//
//        // history
//        entityToTableNameMap.put(CommentEntity.class, "ACT_HI_COMMENT");
//
//        entityToTableNameMap.put(HistoricActivityInstanceEntity.class, "ACT_HI_ACTINST");
//        entityToTableNameMap.put(AttachmentEntity.class, "ACT_HI_ATTACHMENT");
//        entityToTableNameMap.put(HistoricProcessInstanceEntity.class, "ACT_HI_PROCINST");
//        entityToTableNameMap.put(HistoricVariableInstanceEntity.class, "ACT_HI_VARINST");
//        entityToTableNameMap.put(HistoricTaskInstanceEntity.class, "ACT_HI_TASKINST");
//        entityToTableNameMap.put(HistoricTaskLogEntryEntity.class, "ACT_HI_TSK_LOG");
//        entityToTableNameMap.put(HistoricIdentityLinkEntity.class, "ACT_HI_IDENTITYLINK");
//
//        // a couple of stuff goes to the same table
//        entityToTableNameMap.put(HistoricDetailAssignmentEntity.class, "ACT_HI_DETAIL");
//        entityToTableNameMap.put(HistoricFormPropertyEntity.class, "ACT_HI_DETAIL");
//        entityToTableNameMap.put(HistoricDetailVariableInstanceUpdateEntity.class, "ACT_HI_DETAIL");
//        entityToTableNameMap.put(HistoricDetailEntity.class, "ACT_HI_DETAIL");
//
//        // general
//        entityToTableNameMap.put(PropertyEntity.class, "ACT_GE_PROPERTY");
//        entityToTableNameMap.put(ByteArrayEntity.class, "ACT_GE_BYTEARRAY");
//        entityToTableNameMap.put(ResourceEntity.class, "ACT_GE_BYTEARRAY");
//
//        entityToTableNameMap.put(EventLogEntryEntity.class, "ACT_EVT_LOG");
//
//        // and now the map for the API types (does not cover all cases)
//        apiTypeToTableNameMap.put(Task.class, "ACT_RU_TASK");
//        apiTypeToTableNameMap.put(Execution.class, "ACT_RU_EXECUTION");
//        apiTypeToTableNameMap.put(ProcessInstance.class, "ACT_RU_EXECUTION");
//        apiTypeToTableNameMap.put(ProcessDefinition.class, "ACT_RE_PROCDEF");
//        apiTypeToTableNameMap.put(Deployment.class, "ACT_RE_DEPLOYMENT");
//        apiTypeToTableNameMap.put(Job.class, "ACT_RU_JOB");
//        apiTypeToTableNameMap.put(Model.class, "ACT_RE_MODEL");
//
//        // history
//        apiTypeToTableNameMap.put(HistoricProcessInstance.class, "ACT_HI_PROCINST");
//        apiTypeToTableNameMap.put(HistoricActivityInstance.class, "ACT_HI_ACTINST");
//        apiTypeToTableNameMap.put(HistoricDetail.class, "ACT_HI_DETAIL");
//        apiTypeToTableNameMap.put(HistoricVariableUpdate.class, "ACT_HI_DETAIL");
//        apiTypeToTableNameMap.put(HistoricFormProperty.class, "ACT_HI_DETAIL");
//        apiTypeToTableNameMap.put(HistoricTaskInstance.class, "ACT_HI_TASKINST");
//        apiTypeToTableNameMap.put(HistoricTaskLogEntry.class, "ACT_HI_TSK_LOG");
//        apiTypeToTableNameMap.put(HistoricVariableInstance.class, "ACT_HI_VARINST");
//
//        // TODO: Identity skipped for the moment as no SQL injection is provided
//        // here
//    }
//
//    protected DbSqlSession getDbSqlSession() {
//        return getSession(DbSqlSession.class);
//    }
//
//    override
//    public Map!(string, Long) getTableCount() {
//        Map!(string, Long) tableCount = new HashMap<>();
//        try {
//            for (string tableName : getTablesPresentInDatabase()) {
//                tableCount.put(tableName, getTableCount(tableName));
//            }
//            LOGGER.debug("Number of rows per flowable table: {}", tableCount);
//        } catch (Exception e) {
//            throw new FlowableException("couldn't get table counts", e);
//        }
//        return tableCount;
//    }
//
//    override
//    public List!string getTablesPresentInDatabase() {
//        List!string tableNames = new ArrayList<>();
//        try {
//            Connection connection = getDbSqlSession().getSqlSession().getConnection();
//            DatabaseMetaData databaseMetaData = connection.getMetaData();
//            LOGGER.debug("retrieving flowable tables from jdbc metadata");
//            string databaseTablePrefix = getDbSqlSession().getDbSqlSessionFactory().getDatabaseTablePrefix();
//            string tableNameFilter = databaseTablePrefix + "ACT_%";
//            if ("postgres".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())
//                    || "cockroachdb".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())) {
//                tableNameFilter = databaseTablePrefix + "act_%";
//            }
//            if ("oracle".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())) {
//                tableNameFilter = databaseTablePrefix + "ACT" + databaseMetaData.getSearchStringEscape() + "_%";
//            }
//
//            string catalog = null;
//            if (getProcessEngineConfiguration().getDatabaseCatalog() !is null && getProcessEngineConfiguration().getDatabaseCatalog().length() > 0) {
//                catalog = getProcessEngineConfiguration().getDatabaseCatalog();
//            }
//
//            string schema = null;
//            if (getProcessEngineConfiguration().getDatabaseSchema() !is null && getProcessEngineConfiguration().getDatabaseSchema().length() > 0) {
//                if ("oracle".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())) {
//                    schema = getProcessEngineConfiguration().getDatabaseSchema().toUpperCase();
//                } else {
//                    schema = getProcessEngineConfiguration().getDatabaseSchema();
//                }
//            }
//
//            try (ResultSet tables = databaseMetaData.getTables(catalog, schema, tableNameFilter, DbSqlSession.JDBC_METADATA_TABLE_TYPES)) {
//                while (tables.next()) {
//                    string tableName = tables.getString("TABLE_NAME");
//                    tableName = tableName.toUpperCase();
//                    tableNames.add(tableName);
//                    LOGGER.debug("retrieved flowable table name {}", tableName);
//                }
//            }
//        } catch (Exception e) {
//            throw new FlowableException("couldn't get flowable table names using metadata: " + e.getMessage(), e);
//        }
//        return tableNames;
//    }
//
//    protected long getTableCount(string tableName) {
//        LOGGER.debug("selecting table count for {}", tableName);
//        Long count = (Long) getDbSqlSession().selectOne("flow.engine.impl.TablePageMap.selectTableCount", Collections.singletonMap("tableName", tableName));
//        return count;
//    }
//
//    override
//    @SuppressWarnings("unchecked")
//    public TablePage getTablePage(TablePageQueryImpl tablePageQuery, int firstResult, int maxResults) {
//
//        TablePage tablePage = new TablePage();
//
//        @SuppressWarnings("rawtypes")
//        List tableData = getDbSqlSession().getSqlSession().selectList("flow.engine.impl.TablePageMap.selectTableData", tablePageQuery, new RowBounds(firstResult, maxResults));
//
//        tablePage.setTableName(tablePageQuery.getTableName());
//        tablePage.setTotal(getTableCount(tablePageQuery.getTableName()));
//        tablePage.setRows((List<Map!(string, Object)>) tableData);
//        tablePage.setFirstResult(firstResult);
//
//        return tablePage;
//    }
//
//    override
//    public string getTableName(Class<?> entityClass, bool withPrefix) {
//        string databaseTablePrefix = getDbSqlSession().getDbSqlSessionFactory().getDatabaseTablePrefix();
//        string tableName = null;
//
//        if (Entity.class.isAssignableFrom(entityClass)) {
//            tableName = entityToTableNameMap.get(entityClass);
//        } else {
//            tableName = apiTypeToTableNameMap.get(entityClass);
//        }
//        if (withPrefix) {
//            return databaseTablePrefix + tableName;
//        } else {
//            return tableName;
//        }
//    }
//
//    override
//    public TableMetaData getTableMetaData(string tableName) {
//        TableMetaData result = new TableMetaData();
//        try {
//            result.setTableName(tableName);
//            DatabaseMetaData metaData = getDbSqlSession().getSqlSession().getConnection().getMetaData();
//
//            if ("postgres".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())
//                    || "cockroachdb".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())) {
//                tableName = tableName.toLowerCase();
//            }
//
//            string catalog = null;
//            if (getProcessEngineConfiguration().getDatabaseCatalog() !is null && getProcessEngineConfiguration().getDatabaseCatalog().length() > 0) {
//                catalog = getProcessEngineConfiguration().getDatabaseCatalog();
//            }
//
//            string schema = null;
//            if (getProcessEngineConfiguration().getDatabaseSchema() !is null && getProcessEngineConfiguration().getDatabaseSchema().length() > 0) {
//                if ("oracle".equals(getDbSqlSession().getDbSqlSessionFactory().getDatabaseType())) {
//                    schema = getProcessEngineConfiguration().getDatabaseSchema().toUpperCase();
//                } else {
//                    schema = getProcessEngineConfiguration().getDatabaseSchema();
//                }
//            }
//
//            ResultSet resultSet = metaData.getColumns(catalog, schema, tableName, null);
//            while (resultSet.next()) {
//                bool wrongSchema = false;
//                if (schema !is null && schema.length() > 0) {
//                    for (int i = 0; i < resultSet.getMetaData().getColumnCount(); i++) {
//                        string columnName = resultSet.getMetaData().getColumnName(i + 1);
//                        if ("TABLE_SCHEM".equalsIgnoreCase(columnName) || "TABLE_SCHEMA".equalsIgnoreCase(columnName)) {
//                            if (!schema.equalsIgnoreCase(resultSet.getString(resultSet.getMetaData().getColumnName(i + 1)))) {
//                                wrongSchema = true;
//                            }
//                            break;
//                        }
//                    }
//                }
//
//                if (!wrongSchema) {
//                    string name = resultSet.getString("COLUMN_NAME").toUpperCase();
//                    string type = resultSet.getString("TYPE_NAME").toUpperCase();
//                    result.addColumnMetaData(name, type);
//                }
//            }
//
//        } catch (SQLException e) {
//            throw new FlowableException("Could not retrieve database metadata: " + e.getMessage());
//        }
//
//        if (result.getColumnNames().isEmpty()) {
//            // According to API, when a table doesn't exist, null should be returned
//            result = null;
//        }
//        return result;
//    }
//
//}
