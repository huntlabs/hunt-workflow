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
module flow.engine.impl.ManagementServiceImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.batch.service.api.Batch;
import flow.batch.service.api.BatchBuilder;
import flow.batch.service.api.BatchPart;
import flow.batch.service.api.BatchQuery;
import flow.batch.service.impl.BatchBuilderImpl;
import flow.batch.service.impl.BatchQueryImpl;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.management.TableMetaData;
import flow.common.api.management.TablePageQuery;
//import flow.common.cmd.CustomSqlExecution;
import flow.common.cmd.GetPropertiesCmd;
//import flow.common.db.DbSqlSession;
import flow.common.db.DbSqlSessionFactory;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
//import flow.common.lock.LockManager;
//import flow.common.lock.LockManagerImpl;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.ManagementService;
import flow.engine.event.EventLogEntry;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.DeleteBatchCmd;
import flow.engine.impl.cmd.DeleteEventLogEntry;
//import flow.engine.impl.cmd.ExecuteCustomSqlCmd;
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
//import flow.engine.impl.cmd.HandleHistoryCleanupTimerJobCmd;
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
import hunt.Exceptions;
import hunt.String;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Falko Menge
 * @author Saeid Mizaei
 */
class ManagementServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , ManagementService {

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }


    public Map!(string, long) getTableCount() {
        //return commandExecutor.execute(new GetTableCountCmd());
        implementationMissing(false);
        return null;
    }


    public string getTableName(TypeInfo entityClass) {
        implementationMissing(false);
        return "";
       // return commandExecutor.execute(new GetTableNameCmd(entityClass));
    }


    public string getTableName(TypeInfo entityClass, bool includePrefix) {
        implementationMissing(false);
        return "";
       // return commandExecutor.execute(new GetTableNameCmd(entityClass, includePrefix));
    }


    public TableMetaData getTableMetaData(string tableName) {
        implementationMissing(false);
        return null;
      //  return commandExecutor.execute(new GetTableMetaDataCmd(tableName));
    }


    public void executeJob(string jobId) {
        try {
            commandExecutor.execute(new ExecuteJobCmd(jobId));

        } catch (RuntimeException e) {

            //if (e instanceof FlowableException) {
            //    throw e;
            //} else {
            //    throw new FlowableException("Job " + jobId + " failed", e);
            //}
        }
    }


    public void executeHistoryJob(string historyJobId) {
        commandExecutor.execute(new ExecuteHistoryJobCmd(historyJobId));
    }


    public Job moveTimerToExecutableJob(string jobId) {
        return cast(Job)(commandExecutor.execute(new MoveTimerToExecutableJobCmd(jobId)));
    }


    public Job moveJobToDeadLetterJob(string jobId) {
        return cast(Job)(commandExecutor.execute(new MoveJobToDeadLetterJobCmd(jobId)));
    }


    public Job moveDeadLetterJobToExecutableJob(string jobId, int retries) {
        return cast(Job)(commandExecutor.execute(new MoveDeadLetterJobToExecutableJobCmd(jobId, retries)));
    }


    public Job moveSuspendedJobToExecutableJob(string jobId) {
        return cast(Job)(commandExecutor.execute(new MoveSuspendedJobToExecutableJobCmd(jobId)));
    }


    public void deleteJob(string jobId) {
        commandExecutor.execute(new DeleteJobCmd(jobId));
    }


    public void deleteTimerJob(string jobId) {
        commandExecutor.execute(new DeleteTimerJobCmd(jobId));
    }


    public void deleteSuspendedJob(string jobId) {
        commandExecutor.execute(new DeleteSuspendedJobCmd(jobId));
    }


    public void deleteDeadLetterJob(string jobId) {
        commandExecutor.execute(new DeleteDeadLetterJobCmd(jobId));
    }


    public void deleteHistoryJob(string jobId) {
        commandExecutor.execute(new DeleteHistoryJobCmd(jobId));
    }


    public void setJobRetries(string jobId, int retries) {
        commandExecutor.execute(new SetJobRetriesCmd(jobId, retries));
    }


    public void setTimerJobRetries(string jobId, int retries) {
        commandExecutor.execute(new SetTimerJobRetriesCmd(jobId, retries));
    }


    public Job rescheduleTimeDateJob(string jobId, string timeDate) {
        return cast(Job)(commandExecutor.execute(new RescheduleTimerJobCmd(jobId, timeDate, null, null, null, null)));
    }


    public Job rescheduleTimeDurationJob(string jobId, string timeDuration) {
        return cast(Job)(commandExecutor.execute(new RescheduleTimerJobCmd(jobId, null, timeDuration, null, null, null)));
    }


    public Job rescheduleTimeCycleJob(string jobId, string timeCycle) {
        return cast(Job)(commandExecutor.execute(new RescheduleTimerJobCmd(jobId, null, null, timeCycle, null, null)));
    }


    public Job rescheduleTimerJob(string jobId, string timeDate, string timeDuration, string timeCycle, string endDate, string calendarName) {
        return cast(Job)(commandExecutor.execute(new RescheduleTimerJobCmd(jobId, timeDate, timeDuration, timeCycle, endDate, calendarName)));
    }


    public TablePageQuery createTablePageQuery() {
       // return new TablePageQueryImpl(commandExecutor);
        return null;
    }


    public JobQuery createJobQuery() {
        return new JobQueryImpl(commandExecutor);
    }


    public TimerJobQuery createTimerJobQuery() {
        return new TimerJobQueryImpl(commandExecutor);
    }


    public SuspendedJobQuery createSuspendedJobQuery() {
        return new SuspendedJobQueryImpl(commandExecutor);
    }


    public DeadLetterJobQuery createDeadLetterJobQuery() {
        return new DeadLetterJobQueryImpl(commandExecutor);
    }


    public HistoryJobQuery createHistoryJobQuery() {
        return new HistoryJobQueryImpl(commandExecutor);
    }


    public string getJobExceptionStacktrace(string jobId) {
        return (cast(String)(commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.ASYNC)))).value;
    }


    public string getTimerJobExceptionStacktrace(string jobId) {
        return (cast(String)(commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.TIMER)))).value;
    }


    public string getSuspendedJobExceptionStacktrace(string jobId) {
        return (cast(String)(commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.SUSPENDED)))).value;
    }


    public string getDeadLetterJobExceptionStacktrace(string jobId) {
        return (cast(String)(commandExecutor.execute(new GetJobExceptionStacktraceCmd(jobId, JobType.DEADLETTER)))).value;
    }


    public void handleHistoryCleanupTimerJob() {
      //  commandExecutor.execute(new HandleHistoryCleanupTimerJobCmd());
    }


    public List!Batch getAllBatches() {
        return cast(List!Batch)(commandExecutor.execute(new GetAllBatchesCmd()));
    }


    public List!Batch findBatchesBySearchKey(string searchKey) {
        return cast(List!Batch)(commandExecutor.execute(new FindBatchesBySearchKeyCmd(searchKey)));
    }


    public string getBatchDocument(string batchId) {
        return (cast(String)(commandExecutor.execute(new GetBatchDocumentCmd(batchId)))).value;
    }


    public BatchPart getBatchPart(string batchPartId) {
        return cast(BatchPart)(commandExecutor.execute(new GetBatchPartCmd(batchPartId)));
    }


    public List!BatchPart findBatchPartsByBatchId(string batchId) {
        return cast(List!BatchPart)(commandExecutor.execute(new FindBatchPartsByBatchIdCmd(batchId)));
    }


    public List!BatchPart findBatchPartsByBatchIdAndStatus(string batchId, string status) {
        return cast(List!BatchPart)(commandExecutor.execute(new FindBatchPartsByBatchIdCmd(batchId, status)));
    }


    public string getBatchPartDocument(string batchPartId) {
        return (cast(String)(commandExecutor.execute(new GetBatchPartDocumentCmd(batchPartId)))).value;
    }


    public BatchQuery createBatchQuery() {
        return new BatchQueryImpl(commandExecutor);
    }


    public BatchBuilder createBatchBuilder() {
        return new BatchBuilderImpl(commandExecutor);
    }


    public void deleteBatch(string batchId) {
        commandExecutor.execute(new DeleteBatchCmd(batchId));
    }


    public Map!(string, string) getProperties() {
        return cast(Map!(string, string))(commandExecutor.execute(new GetPropertiesCmd()));
    }


    //public string databaseSchemaUpgrade( Connection connection,  string catalog,  string schema) {
        //CommandConfig config = commandExecutor.getDefaultConfig().transactionNotSupported();
        //return commandExecutor.execute(config, new Command!string() {
        //
        //    public string execute(CommandContext commandContext) {
        //        DbSqlSessionFactory dbSqlSessionFactory = (DbSqlSessionFactory) commandContext.getSessionFactories().get(DbSqlSession.class);
        //        DbSqlSession dbSqlSession = new DbSqlSession(dbSqlSessionFactory, CommandContextUtil.getEntityCache(commandContext), connection, catalog, schema);
        //        commandContext.getSessions().put(DbSqlSession.class, dbSqlSession);
        //        return CommandContextUtil.getProcessEngineConfiguration(commandContext).getSchemaManager().schemaUpdate();
        //    }
        //});
    //}


    public Object executeCommand(CommandAbstract command) {
        implementationMissing(false);
        return null;
        //if (command is null) {
        //    throw new FlowableIllegalArgumentException("The command is null");
        //}
        //return commandExecutor.execute(command);
    }


    public Object executeCommand(CommandConfig config, CommandAbstract command) {
        implementationMissing(false);
        return null;
        //if (config is null) {
        //    throw new FlowableIllegalArgumentException("The config is null");
        //}
        //if (command is null) {
        //    throw new FlowableIllegalArgumentException("The command is null");
        //}
        //return commandExecutor.execute(config, command);
    }


    //public LockManager getLockManager(string lockName) {
    //    return new LockManagerImpl(commandExecutor, lockName, getConfiguration().getLockPollRate());
    //}
    //
    //
    //public <MapperType, ResultType> ResultType executeCustomSql(CustomSqlExecution!(MapperType, ResultType) customSqlExecution) {
    //    Class!MapperType mapperClass = customSqlExecution.getMapperClass();
    //    return commandExecutor.execute(new ExecuteCustomSqlCmd<>(mapperClass, customSqlExecution));
    //}


    public List!EventLogEntry getEventLogEntries(long startLogNr, long pageSize) {
        return cast(List!EventLogEntry)(commandExecutor.execute(new GetEventLogEntriesCmd(startLogNr, pageSize)));
    }


    public List!EventLogEntry getEventLogEntriesByProcessInstanceId(string processInstanceId) {
        return cast(List!EventLogEntry)(commandExecutor.execute(new GetEventLogEntriesCmd(processInstanceId)));
    }


    public void deleteEventLogEntry(long logNr) {
        commandExecutor.execute(new DeleteEventLogEntry(logNr));
    }

}
