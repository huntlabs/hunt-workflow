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


import java.sql.Connection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.api.BatchPart;
import flow.batch.service.api.BatchQuery;
import org.flowable.batch.service.impl.BatchBuilderImpl;
import org.flowable.batch.service.impl.BatchQueryImpl;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.management.TableMetaData;
import flow.common.api.management.TablePageQuery;
import flow.common.cmd.CustomSqlExecution;
import flow.common.cmd.GetPropertiesCmd;
import flow.common.db.DbSqlSession;
import flow.common.db.DbSqlSessionFactory;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.lock.LockManager;
import flow.common.lock.LockManagerImpl;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.ManagementService;
import flow.engine.event.EventLogEntry;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.DeleteBatchCmd;
import flow.engine.impl.cmd.DeleteEventLogEntry;
import flow.engine.impl.cmd.ExecuteCustomSqlCmd;
import flow.engine.impl.cmd.FindBatchPartsByBatchIdCmd;
import flow.engine.impl.cmd.FindBatchesBySearchKeyCmd;
import flow.engine.impl.cmd.GetAllBatchesCmd;
import flow.engine.impl.cmd.GetBatchDocumentCmd;
import flow.engine.impl.cmd.GetBatchPartCmd;
import flow.engine.impl.cmd.GetBatchPartDocumentCmd;
import flow.engine.impl.cmd.GetEventLogEntriesCmd;
import flow.engine.impl.cmd.GetTableCountCmd;
import flow.engine.impl.cmd.GetTableMetaDataCmd;
import flow.engine.impl.cmd.GetTableNameCmd;
import flow.engine.impl.cmd.HandleHistoryCleanupTimerJobCmd;
import flow.engine.impl.cmd.RescheduleTimerJobCmd;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.api.DeadLetterJobQuery;
import flow.job.service.api.HistoryJobQuery;
import flow.job.service.api.Job;
import flow.job.service.api.JobQuery;
import flow.job.service.api.SuspendedJobQuery;
import flow.job.service.api.TimerJobQuery;
import flow.job.service.impl.DeadLetterJobQueryImpl;
import flow.job.service.impl.HistoryJobQueryImpl;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.SuspendedJobQueryImpl;
import flow.job.service.impl.TimerJobQueryImpl;
import flow.job.service.impl.cmd.DeleteDeadLetterJobCmd;
import flow.job.service.impl.cmd.DeleteHistoryJobCmd;
import flow.job.service.impl.cmd.DeleteJobCmd;
import flow.job.service.impl.cmd.DeleteSuspendedJobCmd;
import flow.job.service.impl.cmd.DeleteTimerJobCmd;
import flow.job.service.impl.cmd.ExecuteHistoryJobCmd;
import flow.job.service.impl.cmd.ExecuteJobCmd;
import flow.job.service.impl.cmd.GetJobExceptionStacktraceCmd;
import flow.job.service.impl.cmd.JobType;
import flow.job.service.impl.cmd.MoveDeadLetterJobToExecutableJobCmd;
import flow.job.service.impl.cmd.MoveJobToDeadLetterJobCmd;
import flow.job.service.impl.cmd.MoveSuspendedJobToExecutableJobCmd;
import flow.job.service.impl.cmd.MoveTimerToExecutableJobCmd;
import flow.job.service.impl.cmd.SetJobRetriesCmd;
import flow.job.service.impl.cmd.SetTimerJobRetriesCmd;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Falko Menge
 * @author Saeid Mizaei
 */
class ManagementServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements ManagementService {

    public ManagementServiceImpl(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    public Map<string, Long> getTableCount() {
        return commandExecutor.execute(new GetTableCountCmd());
    }

    @Override
    public string getTableName(Class<?> entityClass) {
        return commandExecutor.execute(new GetTableNameCmd(entityClass));
    }

    @Override
    public string getTableName(Class<?> entityClass, bool includePrefix) {
        return commandExecutor.execute(new GetTableNameCmd(entityClass, includePrefix));
    }

    @Override
    public TableMetaData getTableMetaData(string tableName) {
        return commandExecutor.execute(new GetTableMetaDataCmd(tableName));
    }

    @Override
    public void executeJob(string jobId) {
        try {
            commandExecutor.execute(new ExecuteJobCmd(jobId));

        } catch (RuntimeException e) {
            if (e instanceof FlowableException) {
                throw e;
            } else {
                throw new FlowableException("Job " + jobId + " failed", e);
            }
        }
    }

    @Override
    public void executeHistoryJob(string historyJobId) {
        commandExecutor.execute(new ExecuteHistoryJobCmd(historyJobId));
    }

    @Override
    public Job moveTimerToExecutableJob(string jobId) {
        return commandExecutor.execute(new MoveTimerToExecutableJobCmd(jobId));
    }

    @Override
    public Job moveJobToDeadLetterJob(string jobId) {
        return commandExecutor.execute(new MoveJobToDeadLetterJobCmd(jobId));
    }

    @Override
    public Job moveDeadLetterJobToExecutableJob(string jobId, int retries) {
        return commandExecutor.execute(new MoveDeadLetterJobToExecutableJobCmd(jobId, retries));
    }

    @Override
    public Job moveSuspendedJobToExecutableJob(string jobId) {
        return commandExecutor.execute(new MoveSuspendedJobToExecutableJobCmd(jobId));
    }

    @Override
    public void deleteJob(string jobId) {
        commandExecutor.execute(new DeleteJobCmd(jobId));
    }

    @Override
    public void deleteTimerJob(string jobId) {
        commandExecutor.execute(new DeleteTimerJobCmd(jobId));
    }

    @Override
    public void deleteSuspendedJob(string jobId) {
        commandExecutor.execute(new DeleteSuspendedJobCmd(jobId));
    }

    @Override
    public void deleteDeadLetterJob(string jobId) {
        commandExecutor.execute(new DeleteDeadLetterJobCmd(jobId));
    }

    @Override
    public void deleteHistoryJob(string jobId) {
        commandExecutor.execute(new DeleteHistoryJobCmd(jobId));
    }

    @Override
    public void setJobRetries(string jobId, int retries) {
        commandExecutor.execute(new SetJobRetriesCmd(jobId, retries));
    }

    @Override
    public void setTimerJobRetries(string jobId, int retries) {
        commandExecutor.execute(new SetTimerJobRetriesCmd(jobId, retries));
    }

    @Override
    public Job rescheduleTimeDateJob(string jobId, string timeDate) {
        return commandExecutor.execute(new RescheduleTimerJobCmd(jobId, timeDate, null, null, null, null));
    }

    @Override
    public Job rescheduleTimeDurationJob(string jobId, string timeDuration) {
        return commandExecutor.execute(new RescheduleTimerJobCmd(jobId, null, timeDuration, null, null, null));
    }

    @Override
    public Job rescheduleTimeCycleJob(string jobId, string timeCycle) {
        return commandExecutor.execute(new RescheduleTimerJobCmd(jobId, null, null, timeCycle, null, null));
    }

    @Override
    public Job rescheduleTimerJob(string jobId, string timeDate, string timeDuration, string timeCycle, string endDate, string calendarName) {
        return commandExecutor.execute(new RescheduleTimerJobCmd(jobId, timeDate, timeDuration, timeCycle, endDate, calendarName));
    }

    @Override
    public TablePageQuery createTablePageQuery() {
        return new TablePageQueryImpl(commandExecutor);
    }

    @Override
    public JobQuery createJobQuery() {
        return new JobQueryImpl(commandExecutor);
    }

    @Override
    public TimerJobQuery createTimerJobQuery() {
        return new TimerJobQueryImpl(commandExecutor);
    }

    @Override
    public SuspendedJobQuery createSuspendedJobQuery() {
        return new SuspendedJobQueryImpl(commandExecutor);
    }

    @Override
    public DeadLetterJobQuery createDeadLetterJobQuery() {
        return new DeadLetterJobQueryImpl(commandExecutor);
    }

    @Override
    public HistoryJobQuery createHistoryJobQuery() {
        return new HistoryJobQueryImpl(commandExecutor);
    }

    @Override
    public string getJobExceptionStacktrace(string jobId) {
        return commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.ASYNC));
    }

    @Override
    public string getTimerJobExceptionStacktrace(string jobId) {
        return commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.TIMER));
    }

    @Override
    public string getSuspendedJobExceptionStacktrace(string jobId) {
        return commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.SUSPENDED));
    }

    @Override
    public string getDeadLetterJobExceptionStacktrace(string jobId) {
        return commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.DEADLETTER));
    }

    @Override
    public void handleHistoryCleanupTimerJob() {
        commandExecutor.execute(new HandleHistoryCleanupTimerJobCmd());
    }

    @Override
    public List<Batch> getAllBatches() {
        return commandExecutor.execute(new GetAllBatchesCmd());
    }

    @Override
    public List<Batch> findBatchesBySearchKey(string searchKey) {
        return commandExecutor.execute(new FindBatchesBySearchKeyCmd(searchKey));
    }

    @Override
    public string getBatchDocument(string batchId) {
        return commandExecutor.execute(new GetBatchDocumentCmd(batchId));
    }

    @Override
    public BatchPart getBatchPart(string batchPartId) {
        return commandExecutor.execute(new GetBatchPartCmd(batchPartId));
    }

    @Override
    public List<BatchPart> findBatchPartsByBatchId(string batchId) {
        return commandExecutor.execute(new FindBatchPartsByBatchIdCmd(batchId));
    }

    @Override
    public List<BatchPart> findBatchPartsByBatchIdAndStatus(string batchId, string status) {
        return commandExecutor.execute(new FindBatchPartsByBatchIdCmd(batchId, status));
    }

    @Override
    public string getBatchPartDocument(string batchPartId) {
        return commandExecutor.execute(new GetBatchPartDocumentCmd(batchPartId));
    }

    @Override
    public BatchQuery createBatchQuery() {
        return new BatchQueryImpl(commandExecutor);
    }

    @Override
    public BatchBuilder createBatchBuilder() {
        return new BatchBuilderImpl(commandExecutor);
    }

    @Override
    public void deleteBatch(string batchId) {
        commandExecutor.execute(new DeleteBatchCmd(batchId));
    }

    @Override
    public Map!(string, string) getProperties() {
        return commandExecutor.execute(new GetPropertiesCmd());
    }

    @Override
    public string databaseSchemaUpgrade(final Connection connection, final string catalog, final string schema) {
        CommandConfig config = commandExecutor.getDefaultConfig().transactionNotSupported();
        return commandExecutor.execute(config, new Command!string() {
            @Override
            public string execute(CommandContext commandContext) {
                DbSqlSessionFactory dbSqlSessionFactory = (DbSqlSessionFactory) commandContext.getSessionFactories().get(DbSqlSession.class);
                DbSqlSession dbSqlSession = new DbSqlSession(dbSqlSessionFactory, CommandContextUtil.getEntityCache(commandContext), connection, catalog, schema);
                commandContext.getSessions().put(DbSqlSession.class, dbSqlSession);
                return CommandContextUtil.getProcessEngineConfiguration(commandContext).getSchemaManager().schemaUpdate();
            }
        });
    }

    @Override
    public <T> T executeCommand(Command<T> command) {
        if (command is null) {
            throw new FlowableIllegalArgumentException("The command is null");
        }
        return commandExecutor.execute(command);
    }

    @Override
    public <T> T executeCommand(CommandConfig config, Command<T> command) {
        if (config is null) {
            throw new FlowableIllegalArgumentException("The config is null");
        }
        if (command is null) {
            throw new FlowableIllegalArgumentException("The command is null");
        }
        return commandExecutor.execute(config, command);
    }

    @Override
    public LockManager getLockManager(string lockName) {
        return new LockManagerImpl(commandExecutor, lockName, getConfiguration().getLockPollRate());
    }

    @Override
    public <MapperType, ResultType> ResultType executeCustomSql(CustomSqlExecution<MapperType, ResultType> customSqlExecution) {
        Class<MapperType> mapperClass = customSqlExecution.getMapperClass();
        return commandExecutor.execute(new ExecuteCustomSqlCmd<>(mapperClass, customSqlExecution));
    }

    @Override
    public List<EventLogEntry> getEventLogEntries(Long startLogNr, Long pageSize) {
        return commandExecutor.execute(new GetEventLogEntriesCmd(startLogNr, pageSize));
    }

    @Override
    public List<EventLogEntry> getEventLogEntriesByProcessInstanceId(string processInstanceId) {
        return commandExecutor.execute(new GetEventLogEntriesCmd(processInstanceId));
    }

    @Override
    public void deleteEventLogEntry(long logNr) {
        commandExecutor.execute(new DeleteEventLogEntry(logNr));
    }

}
