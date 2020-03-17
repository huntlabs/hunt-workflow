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
module flow.job.service.impl.asyncexecutor.DefaultJobManager;

//import java.util.Calendar;
import hunt.time.LocalDateTime;
//import java.util.GregorianCalendar;
import hunt.collection.Map;

//import org.apache.commons.lang3.StringUtils;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.calendar.BusinessCalendar;
import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionState;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.HistoryJob;
import flow.job.service.api.Job;
import flow.job.service.api.JobInfo;
import flow.job.service.HistoryJobHandler;
import flow.job.service.HistoryJobProcessor;
import flow.job.service.HistoryJobProcessorContext;
import flow.job.service.JobHandler;
import flow.job.service.JobProcessor;
import flow.job.service.JobProcessorContext;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.HistoryJobProcessorContextImpl;
import flow.job.service.impl.JobProcessorContextImpl;
import flow.job.service.impl.history.async.AsyncHistorySession;
import flow.job.service.impl.history.async.TriggerAsyncHistoryExecutorTransactionListener;
import flow.job.service.impl.persistence.entity.AbstractJobEntity;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntityManager;
import flow.job.service.impl.util.CommandContextUtil;
import flow.variable.service.api.deleg.VariableScope;
import flow.variable.service.impl.el.NoExecutionVariableScope;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import flow.job.service.impl.asyncexecutor.JobManager;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
import flow.job.service.impl.asyncexecutor.JobAddedTransactionListener;
import hunt.logging;
import hunt.Exceptions;


//import com.fasterxml.jackson.databind.JsonNode;

class DefaultJobManager : JobManager {

    public static  string CYCLE_TYPE = "cycle";

    protected JobServiceConfiguration jobServiceConfiguration;

    this() {
    }

    this(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }


    public void createAsyncJob(JobEntity jobEntity, bool exclusive) {
        // When the async executor is activated, the job is directly passed on to the async executor thread
        if (isAsyncExecutorActive()) {
            internalCreateLockedAsyncJob(jobEntity, exclusive);

        } else {
            internalCreateAsyncJob(jobEntity, exclusive);
        }
    }


    public void scheduleAsyncJob(JobEntity jobEntity) {
        callJobProcessors(JobProcessorContext.Phase.BEFORE_CREATE, jobEntity);
        jobServiceConfiguration.getJobEntityManager().insert(jobEntity);
        triggerExecutorIfNeeded(jobEntity);
    }

    protected void triggerExecutorIfNeeded(JobEntity jobEntity) {
        // When the async executor is activated, the job is directly passed on to the async executor thread
        if (isAsyncExecutorActive()) {
            hintAsyncExecutor(jobEntity);
        }
    }


    public void scheduleTimerJob(TimerJobEntity timerJob) {
        scheduleTimer(timerJob);
        sendTimerScheduledEvent(timerJob);
    }

    private void scheduleTimer(TimerJobEntity timerJob) {
        if (timerJob is null) {
            throw new FlowableException("Empty timer job can not be scheduled");
        }
        callJobProcessors(JobProcessorContext.Phase.BEFORE_CREATE, timerJob);
        jobServiceConfiguration.getTimerJobEntityManager().insert(timerJob);
    }

    private void sendTimerScheduledEvent(TimerJobEntity timerJob) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(
                    FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.TIMER_SCHEDULED, timerJob));
        }
    }


    public JobEntity moveTimerJobToExecutableJob(TimerJobEntity timerJob) {
        if (timerJob is null) {
            throw new FlowableException("Empty timer job can not be scheduled");
        }

        JobEntity executableJob = createExecutableJobFromOtherJob(timerJob);
        bool insertSuccessful = jobServiceConfiguration.getJobEntityManager().insertJobEntity(executableJob);
        if (insertSuccessful) {
            jobServiceConfiguration.getTimerJobEntityManager().dele(timerJob);
            triggerExecutorIfNeeded(executableJob);
            return executableJob;
        }
        return null;
    }


    public TimerJobEntity moveJobToTimerJob(AbstractRuntimeJobEntity job) {
        TimerJobEntity timerJob = createTimerJobFromOtherJob(job);
        bool insertSuccessful = jobServiceConfiguration.getTimerJobEntityManager().insertTimerJobEntity(timerJob);
        if (insertSuccessful) {
            JobEntity jb  = cast(JobEntity)job;
            SuspendedJobEntity sj = cast(SuspendedJobEntity)job;
            if (jb !is null) {
                jobServiceConfiguration.getJobEntityManager().dele(jb);
            } else if (sj !is null) {
                jobServiceConfiguration.getSuspendedJobEntityManager().dele(sj);
            }

            return timerJob;
        }
        return null;
    }


    public SuspendedJobEntity moveJobToSuspendedJob(AbstractRuntimeJobEntity job) {
        SuspendedJobEntity suspendedJob = createSuspendedJobFromOtherJob(job);
        jobServiceConfiguration.getSuspendedJobEntityManager().insert(suspendedJob);
        TimerJobEntity tj = cast(TimerJobEntity)job;
        JobEntity jb = cast(JobEntity)job;
        if (tj !is null) {
            jobServiceConfiguration.getTimerJobEntityManager().dele(tj);
        } else if (jb !is null) {
            jobServiceConfiguration.getJobEntityManager().dele(jb);
        }

        return suspendedJob;
    }


    public AbstractRuntimeJobEntity activateSuspendedJob(SuspendedJobEntity job) {
        AbstractRuntimeJobEntity activatedJob = null;
        if (Job.JOB_TYPE_TIMER == (job.getJobType())) {
            activatedJob = createTimerJobFromOtherJob(job);
            jobServiceConfiguration.getTimerJobEntityManager().insert(cast(TimerJobEntity) activatedJob);

        } else {
            activatedJob = createExecutableJobFromOtherJob(job);
            JobEntity jobEntity = cast(JobEntity) activatedJob;
            jobServiceConfiguration.getJobEntityManager().insert(jobEntity);
            triggerExecutorIfNeeded(jobEntity);
        }

        jobServiceConfiguration.getSuspendedJobEntityManager().dele(job);
        return activatedJob;
    }


    public DeadLetterJobEntity moveJobToDeadLetterJob(AbstractRuntimeJobEntity job) {
        DeadLetterJobEntity deadLetterJob = createDeadLetterJobFromOtherJob(job);
        jobServiceConfiguration.getDeadLetterJobEntityManager().insert(deadLetterJob);
        TimerJobEntity tj = cast(TimerJobEntity)job;
        JobEntity jb = cast(JobEntity)job;
        if (tj !is null) {
            jobServiceConfiguration.getTimerJobEntityManager().dele(tj);

        } else if (jb !is null) {
            jobServiceConfiguration.getJobEntityManager().dele(jb);
        }

        return deadLetterJob;
    }


    public JobEntity moveDeadLetterJobToExecutableJob(DeadLetterJobEntity deadLetterJobEntity, int retries) {
        if (deadLetterJobEntity is null) {
            throw new FlowableIllegalArgumentException("Null job provided");
        }

        JobEntity executableJob = createExecutableJobFromOtherJob(deadLetterJobEntity);
        executableJob.setRetries(retries);
        bool insertSuccessful = jobServiceConfiguration.getJobEntityManager().insertJobEntity(executableJob);
        if (insertSuccessful) {
            jobServiceConfiguration.getDeadLetterJobEntityManager().dele(deadLetterJobEntity);
            triggerExecutorIfNeeded(executableJob);
            return executableJob;
        }
        return null;
    }


    public void execute(JobInfo job) {
        HistoryJobEntity hj = cast(HistoryJobEntity)job;
        JobEntity jb = cast(JobEntity)job;
        if (hj !is null) {
            callHistoryJobProcessors(HistoryJobProcessorContext.Phase.BEFORE_EXECUTE, hj);
            executeHistoryJob(hj);
        } else if (jb !is null) {
            callJobProcessors(JobProcessorContext.Phase.BEFORE_EXECUTE, jb);
            if (Job.JOB_TYPE_MESSAGE == ((cast(Job) job).getJobType())) {
                executeMessageJob(jb);
            } else if (Job.JOB_TYPE_TIMER == ((cast(Job) job).getJobType())) {
                executeTimerJob(jb);
            }

        } else {
            throw new FlowableException("Only jobs with type JobEntity are supported to be executed");
        }
    }


    public void unacquire(JobInfo job) {
        HistoryJob hj = cast (HistoryJob)job;
        if (hj !is null) {

            HistoryJobEntity jobEntity = cast(HistoryJobEntity) job;

            HistoryJobEntity newJobEntity = jobServiceConfiguration.getHistoryJobEntityManager().create();
            copyHistoryJobInfo(newJobEntity, jobEntity);
            newJobEntity.setId(null); // We want a new id to be assigned to this job
            newJobEntity.setLockExpirationTime(null);
            newJobEntity.setLockOwner(null);
            jobServiceConfiguration.getHistoryJobEntityManager().insert(newJobEntity);
            jobServiceConfiguration.getHistoryJobEntityManager().deleteNoCascade(jobEntity);

        } else if ( cast(JobEntity)job !is null) {

            // Deleting the old job and inserting it again with another id,
            // will avoid that the job is immediately is picked up again (for example
            // when doing lots of exclusive jobs for the same process instance)

            JobEntity jobEntity = cast(JobEntity) job;

            JobEntity newJobEntity = jobServiceConfiguration.getJobEntityManager().create();
            copyJobInfo(newJobEntity, jobEntity);
            newJobEntity.setId(null); // We want a new id to be assigned to this job
            newJobEntity.setLockExpirationTime(null);
            newJobEntity.setLockOwner(null);
            jobServiceConfiguration.getJobEntityManager().insert(newJobEntity);
            jobServiceConfiguration.getJobEntityManager().dele(jobEntity.getId());

            // We're not calling triggerExecutorIfNeeded here after the insert. The unacquire happened
            // for a reason (eg queue full or exclusive lock failure). No need to try it immediately again,
            // as the chance of failure will be high.

        } else {
            if (job !is null) {
                // It could be a v5 job, so simply unlock it.
                jobServiceConfiguration.getJobEntityManager().resetExpiredJob(job.getId());
            } else {
                throw new FlowableException("Programmatic error: null job passed");
            }
        }

    }


    public void unacquireWithDecrementRetries(JobInfo job) {
        if ( cast(HistoryJob)job !is null ) {
            HistoryJobEntity historyJobEntity = cast(HistoryJobEntity) job;

            if (historyJobEntity.getRetries() > 0) {
                HistoryJobEntity newHistoryJobEntity = jobServiceConfiguration.getHistoryJobEntityManager().create();
                copyHistoryJobInfo(newHistoryJobEntity, historyJobEntity);
                newHistoryJobEntity.setId(null); // We want a new id to be assigned to this job
                newHistoryJobEntity.setLockExpirationTime(null);
                newHistoryJobEntity.setLockOwner(null);
                newHistoryJobEntity.setCreateTime(jobServiceConfiguration.getClock().getCurrentTime());

                newHistoryJobEntity.setRetries(newHistoryJobEntity.getRetries() - 1);
                jobServiceConfiguration.getHistoryJobEntityManager().insert(newHistoryJobEntity);
                jobServiceConfiguration.getHistoryJobEntityManager().deleteNoCascade(historyJobEntity);

            } else {
                jobServiceConfiguration.getHistoryJobEntityManager().dele(historyJobEntity);
            }

        } else {
            JobEntity jobEntity = cast(JobEntity) job;

            JobEntity newJobEntity = jobServiceConfiguration.getJobEntityManager().create();
            copyJobInfo(newJobEntity, jobEntity);
            newJobEntity.setId(null); // We want a new id to be assigned to this job
            newJobEntity.setLockExpirationTime(null);
            newJobEntity.setLockOwner(null);

            if (newJobEntity.getRetries() > 0) {
                newJobEntity.setRetries(newJobEntity.getRetries() - 1);
                jobServiceConfiguration.getJobEntityManager().insert(newJobEntity);

            } else {
                DeadLetterJobEntity deadLetterJob = createDeadLetterJobFromOtherJob(newJobEntity);
                jobServiceConfiguration.getDeadLetterJobEntityManager().insert(deadLetterJob);
            }

            jobServiceConfiguration.getJobEntityManager().dele(jobEntity.getId());

            // We're not calling triggerExecutorIfNeeded here after the insert. The unacquire happened
            // for a reason (eg queue full or exclusive lock failure). No need to try it immediately again,
            // as the chance of failure will be high.

        }
    }

    protected void executeMessageJob(JobEntity jobEntity) {
        executeJobHandler(jobEntity);
        if (jobEntity.getId() !is null) {
            CommandContextUtil.getJobEntityManager().dele(jobEntity);
        }
    }

    protected void executeHistoryJob(HistoryJobEntity historyJobEntity) {
        executeHistoryJobHandler(historyJobEntity);
        if (historyJobEntity.getId() !is null) {
            CommandContextUtil.getHistoryJobEntityManager().dele(historyJobEntity);
        }
    }

    protected void executeTimerJob(JobEntity timerEntity) {
        TimerJobEntityManager timerJobEntityManager = jobServiceConfiguration.getTimerJobEntityManager();

        VariableScope variableScope = null;
        if (jobServiceConfiguration.getInternalJobManager() !is null) {
            variableScope = jobServiceConfiguration.getInternalJobManager().resolveVariableScope(timerEntity);
        }

        if (variableScope is null) {
            variableScope = NoExecutionVariableScope.getSharedInstance();
        }

        if (jobServiceConfiguration.getInternalJobManager() !is null) {
            jobServiceConfiguration.getInternalJobManager().preTimerJobDelete(timerEntity, variableScope);
        }

        if (timerEntity.getDuedate() !is null && !isValidTime(timerEntity, timerEntity.getDuedate(), variableScope)) {
            logInfo("Timer {%s} fired. but the dueDate is after the endDate.  Deleting timer.", timerEntity.getId());
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Timer {} fired. but the dueDate is after the endDate.  Deleting timer.", timerEntity.getId());
            //}
            jobServiceConfiguration.getJobEntityManager().dele(timerEntity);
            return;
        }

        executeJobHandler(timerEntity);
        jobServiceConfiguration.getJobEntityManager().dele(timerEntity);

        logInfo("Timer {%s} fired. Deleting timer.",timerEntity.getId());
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Timer {} fired. Deleting timer.", timerEntity.getId());
        //}

        if (timerEntity.getRepeat() !is null) {
            TimerJobEntity newTimerJobEntity = timerJobEntityManager.createAndCalculateNextTimer(timerEntity, variableScope);
            if (newTimerJobEntity !is null) {
                if (jobServiceConfiguration.getInternalJobManager() !is null) {
                    jobServiceConfiguration.getInternalJobManager().preRepeatedTimerSchedule(newTimerJobEntity, variableScope);
                }

                scheduleTimerJob(newTimerJobEntity);
            }
        }
    }

    protected void executeJobHandler(JobEntity jobEntity) {
        VariableScope variableScope = null;
        if (jobServiceConfiguration.getInternalJobManager() !is null) {
            variableScope = jobServiceConfiguration.getInternalJobManager().resolveVariableScope(jobEntity);
        }

        if (variableScope is null) {
            variableScope = NoExecutionVariableScope.getSharedInstance();
        }

        Map!(string, JobHandler) jobHandlers = jobServiceConfiguration.getJobHandlers();
        if (jobEntity.getJobHandlerType() !is null) {

            if (jobHandlers !is null) {
                JobHandler jobHandler = jobHandlers.get(jobEntity.getJobHandlerType());
                if (jobHandler !is null) {
                    jobHandler.execute(jobEntity, jobEntity.getJobHandlerConfiguration(), variableScope, getCommandContext());
                } else {
                    throw new FlowableException("No job handler registered for type " ~ jobEntity.getJobHandlerType() ~
                                    " in job config for engine: " ~ jobServiceConfiguration.getEngineName());
                }

            } else {
                throw new FlowableException("No job handler registered for type " ~ jobEntity.getJobHandlerType() ~
                                " in job config for engine: " ~ jobServiceConfiguration.getEngineName());
            }

        } else {
            throw new FlowableException("Job has no job handler type in job config for engine: " ~ jobServiceConfiguration.getEngineName());
        }
    }

    protected void executeHistoryJobHandler(HistoryJobEntity historyJobEntity) {
        Map!(string, HistoryJobHandler) jobHandlers = jobServiceConfiguration.getHistoryJobHandlers();
        if (historyJobEntity.getJobHandlerType() !is null) {
            if (jobHandlers !is null) {
                HistoryJobHandler jobHandler = jobHandlers.get(historyJobEntity.getJobHandlerType());
                if (jobHandler !is null) {
                    jobHandler.execute(historyJobEntity, historyJobEntity.getJobHandlerConfiguration(), getCommandContext());
                } else {
                    throw new FlowableException("No history job handler registered for type " ~ historyJobEntity.getJobHandlerType() ~
                                    " in job config for engine: " ~ jobServiceConfiguration.getEngineName());
                }

            } else {
                throw new FlowableException("No history job handler registered for type " ~ historyJobEntity.getJobHandlerType() ~
                                " in job config for engine: " ~ jobServiceConfiguration.getEngineName());
            }

        } else {
            throw new FlowableException("Async history job has no job handler type in job config for engine: " ~ jobServiceConfiguration.getEngineName());
        }
    }

    protected bool isValidTime(JobEntity timerEntity, Date newTimerDate, VariableScope variableScope) {
        implementationMissing(false);
        //BusinessCalendar businessCalendar = jobServiceConfiguration.getBusinessCalendarManager().getBusinessCalendar(
        //        getBusinessCalendarName(timerEntity, variableScope));
        //return businessCalendar.validateDuedate(timerEntity.getRepeat(), timerEntity.getMaxIterations(), timerEntity.getEndDate(), newTimerDate);
    }

    protected void hintAsyncExecutor(JobEntity job) {
        // Verify that correct properties have been set when the async executor will be hinted
        if (job.getLockOwner() is null || job.getLockExpirationTime() is null) {
            createAsyncJob(job, job.isExclusive());
        }
        createHintListeners(getAsyncExecutor(), job);
    }

    protected void createHintListeners(AsyncExecutor asyncExecutor, JobInfoEntity job) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        if (Context.getTransactionContext() !is null) {
            JobAddedTransactionListener jobAddedTransactionListener = new JobAddedTransactionListener(job, asyncExecutor,
                            CommandContextUtil.getJobServiceConfiguration(commandContext).getCommandExecutor());
            Context.getTransactionContext().addTransactionListener(TransactionState.COMMITTED, jobAddedTransactionListener);

        } else {
            AsyncJobAddedNotification jobAddedNotification = new AsyncJobAddedNotification(job, asyncExecutor);
            commandContext.addCloseListener(jobAddedNotification);

        }
    }


    public string getBusinessCalendarName(JobEntity timerEntity, VariableScope variableScope) {
        implementationMissing(false);
        return null;
        //string calendarValue = null;
        //if (timerEntity.getJobHandlerConfiguration() !is null && timerEntity.getJobHandlerConfiguration().length != 0) {
        //    try {
        //        JsonNode jobConfigNode = jobServiceConfiguration.getObjectMapper().readTree(timerEntity.getJobHandlerConfiguration());
        //        JsonNode calendarNameNode = jobConfigNode.get("calendarName");
        //        if (calendarNameNode !is null && !calendarNameNode.isNull()) {
        //            calendarValue = calendarNameNode.asText();
        //        }
        //
        //    } catch (Exception e) {
        //        // ignore JSON exception
        //    }
        //}
        //
        //return getBusinessCalendarName(calendarValue, variableScope);
    }

    protected string getBusinessCalendarName(string calendarName, VariableScope variableScope) {
        implementationMissing(false);
        return null;
        //string businessCalendarName = CYCLE_TYPE;
        //if (StringUtils.isNotEmpty(calendarName)) {
        //    businessCalendarName = (string) CommandContextUtil.getJobServiceConfiguration().getExpressionManager()
        //            .createExpression(calendarName).getValue(variableScope);
        //}
        //return businessCalendarName;
    }


    public HistoryJobEntity scheduleHistoryJob(HistoryJobEntity historyJobEntity) {
        callHistoryJobProcessors(HistoryJobProcessorContext.Phase.BEFORE_CREATE, historyJobEntity);
        jobServiceConfiguration.getHistoryJobEntityManager().insert(historyJobEntity);
        triggerAsyncHistoryExecutorIfNeeded(historyJobEntity);
        return historyJobEntity;
    }

    protected void triggerAsyncHistoryExecutorIfNeeded(HistoryJobEntity historyJobEntity) {
        if (isAsyncHistoryExecutorActive()) {
            hintAsyncHistoryExecutor(historyJobEntity);
        }
    }

    protected void hintAsyncHistoryExecutor(HistoryJobEntity historyJobEntity) {
        if (historyJobEntity.getLockOwner() is null || historyJobEntity.getLockExpirationTime() is null) {
            setLockTimeAndOwner(getAsyncHistoryExecutor(), historyJobEntity);
        }
        createAsyncHistoryHintListeners(historyJobEntity);
    }

    protected void createAsyncHistoryHintListeners(HistoryJobEntity historyJobEntity) {
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        AsyncHistorySession asyncHistorySession = commandContext.getSession(typeid(AsyncHistorySession));
        if (asyncHistorySession !is null) {
            TransactionContext transactionContext = asyncHistorySession.getTransactionContext();
            if (transactionContext !is null) {
                transactionContext.addTransactionListener(TransactionState.COMMITTED, new TriggerAsyncHistoryExecutorTransactionListener(commandContext, historyJobEntity));
            }
        }
    }

    protected void internalCreateAsyncJob(JobEntity jobEntity, bool exclusive) {
        fillDefaultAsyncJobInfo(jobEntity, exclusive);
    }

    protected void internalCreateLockedAsyncJob(JobEntity jobEntity, bool exclusive) {
        fillDefaultAsyncJobInfo(jobEntity, exclusive);
        setLockTimeAndOwner(getAsyncExecutor(), jobEntity);
    }

    protected void setLockTimeAndOwner(AsyncExecutor asyncExecutor , JobInfoEntity jobInfoEntity) {
        GregorianCalendar gregorianCalendar = new GregorianCalendar();
        gregorianCalendar.setTime(jobServiceConfiguration.getClock().getCurrentTime());
        gregorianCalendar.add(Calendar.MILLISECOND, asyncExecutor.getAsyncJobLockTimeInMillis());
        jobInfoEntity.setLockExpirationTime(gregorianCalendar.getTime());
        jobInfoEntity.setLockOwner(asyncExecutor.getLockOwner());
    }

    protected void fillDefaultAsyncJobInfo(JobEntity jobEntity, bool exclusive) {
        jobEntity.setJobType(JobEntity.JOB_TYPE_MESSAGE);
        jobEntity.setRevision(1);
        jobEntity.setRetries(jobServiceConfiguration.getAsyncExecutorNumberOfRetries());
        jobEntity.setExclusive(exclusive);
    }


    public JobEntity createExecutableJobFromOtherJob(AbstractRuntimeJobEntity job) {
        JobEntity executableJob = jobServiceConfiguration.getJobEntityManager().create();
        copyJobInfo(executableJob, job);

        if (isAsyncExecutorActive()) {
            GregorianCalendar gregorianCalendar = new GregorianCalendar();
            gregorianCalendar.setTime(jobServiceConfiguration.getClock().getCurrentTime());
            gregorianCalendar.add(Calendar.MILLISECOND, getAsyncExecutor().getTimerLockTimeInMillis());
            executableJob.setLockExpirationTime(gregorianCalendar.getTime());
            executableJob.setLockOwner(getAsyncExecutor().getLockOwner());
        }

        return executableJob;
    }


    public TimerJobEntity createTimerJobFromOtherJob(AbstractRuntimeJobEntity otherJob) {
        TimerJobEntity timerJob = jobServiceConfiguration.getTimerJobEntityManager().create();
        copyJobInfo(timerJob, otherJob);
        return timerJob;
    }


    public SuspendedJobEntity createSuspendedJobFromOtherJob(AbstractRuntimeJobEntity otherJob) {
        SuspendedJobEntity suspendedJob = jobServiceConfiguration.getSuspendedJobEntityManager().create();
        copyJobInfo(suspendedJob, otherJob);
        return suspendedJob;
    }


    public DeadLetterJobEntity createDeadLetterJobFromOtherJob(AbstractRuntimeJobEntity otherJob) {
        DeadLetterJobEntity deadLetterJob = jobServiceConfiguration.getDeadLetterJobEntityManager().create();
        copyJobInfo(deadLetterJob, otherJob);
        return deadLetterJob;
    }


    public AbstractRuntimeJobEntity copyJobInfo(AbstractRuntimeJobEntity copyToJob, AbstractRuntimeJobEntity copyFromJob) {
        copyToJob.setDuedate(copyFromJob.getDuedate());
        copyToJob.setEndDate(copyFromJob.getEndDate());
        copyToJob.setExclusive(copyFromJob.isExclusive());
        copyToJob.setExecutionId(copyFromJob.getExecutionId());
        copyToJob.setId(copyFromJob.getId());
        copyToJob.setJobHandlerConfiguration(copyFromJob.getJobHandlerConfiguration());
        copyToJob.setCustomValues(copyFromJob.getCustomValues());
        copyToJob.setJobHandlerType(copyFromJob.getJobHandlerType());
        copyToJob.setJobType(copyFromJob.getJobType());
        copyToJob.setExceptionMessage(copyFromJob.getExceptionMessage());
        copyToJob.setExceptionStacktrace(copyFromJob.getExceptionStacktrace());
        copyToJob.setMaxIterations(copyFromJob.getMaxIterations());
        copyToJob.setProcessDefinitionId(copyFromJob.getProcessDefinitionId());
        copyToJob.setElementId(copyFromJob.getElementId());
        copyToJob.setElementName(copyFromJob.getElementName());
        copyToJob.setProcessInstanceId(copyFromJob.getProcessInstanceId());
        copyToJob.setScopeId(copyFromJob.getScopeId());
        copyToJob.setSubScopeId(copyFromJob.getSubScopeId());
        copyToJob.setScopeType(copyFromJob.getScopeType());
        copyToJob.setScopeDefinitionId(copyFromJob.getScopeDefinitionId());
        copyToJob.setRepeat(copyFromJob.getRepeat());
        copyToJob.setRetries(copyFromJob.getRetries());
        copyToJob.setRevision(copyFromJob.getRevision());
        copyToJob.setTenantId(copyFromJob.getTenantId());

        return copyToJob;
    }

    protected HistoryJobEntity copyHistoryJobInfo(HistoryJobEntity copyToJob, HistoryJobEntity copyFromJob) {
        copyToJob.setId(copyFromJob.getId());
        copyToJob.setJobHandlerConfiguration(copyFromJob.getJobHandlerConfiguration());
        if (copyFromJob.getAdvancedJobHandlerConfigurationByteArrayRef() !is null) {
            JobByteArrayRef configurationByteArrayRefCopy = copyFromJob.getAdvancedJobHandlerConfigurationByteArrayRef().copy();
            copyToJob.setAdvancedJobHandlerConfigurationByteArrayRef(configurationByteArrayRefCopy);
        }
        if (copyFromJob.getExceptionByteArrayRef() !is null) {
            JobByteArrayRef exceptionByteArrayRefCopy = copyFromJob.getExceptionByteArrayRef();
            copyToJob.setExceptionByteArrayRef(exceptionByteArrayRefCopy);
        }
        if (copyFromJob.getCustomValuesByteArrayRef() !is null) {
            JobByteArrayRef customValuesByteArrayRefCopy = copyFromJob.getCustomValuesByteArrayRef().copy();
            copyToJob.setCustomValuesByteArrayRef(customValuesByteArrayRefCopy);
        }
        copyToJob.setJobHandlerType(copyFromJob.getJobHandlerType());
        copyToJob.setExceptionMessage(copyFromJob.getExceptionMessage());
        copyToJob.setExceptionStacktrace(copyFromJob.getExceptionStacktrace());
        copyToJob.setCustomValues(copyFromJob.getCustomValues());
        copyToJob.setRetries(copyFromJob.getRetries());
        copyToJob.setRevision(copyFromJob.getRevision());
        copyToJob.setScopeType(copyFromJob.getScopeType());
        copyToJob.setTenantId(copyFromJob.getTenantId());

        return copyToJob;
    }

    public JobServiceConfiguration getJobServiceConfiguration() {
        return jobServiceConfiguration;
    }


    public void setJobServiceConfiguration(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }

    protected bool isAsyncExecutorActive() {
        return isExecutorActive(jobServiceConfiguration.getAsyncExecutor());
    }

    protected bool isAsyncHistoryExecutorActive() {
        return isExecutorActive(jobServiceConfiguration.getAsyncHistoryExecutor());
    }

    protected bool isExecutorActive(AsyncExecutor asyncExecutor) {
        return asyncExecutor !is null && asyncExecutor.isActive();
    }

    protected CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    protected AsyncExecutor getAsyncExecutor() {
        return jobServiceConfiguration.getAsyncExecutor();
    }

    protected AsyncExecutor getAsyncHistoryExecutor() {
        return jobServiceConfiguration.getAsyncHistoryExecutor();
    }

    protected void callJobProcessors(JobProcessorContext.Phase processorType, AbstractJobEntity abstractJobEntity) {
        if (jobServiceConfiguration.getJobProcessors() !is null) {
            JobProcessorContextImpl jobProcessorContext = new JobProcessorContextImpl(processorType, abstractJobEntity);
            foreach (JobProcessor jobProcessor ; jobServiceConfiguration.getJobProcessors()) {
                jobProcessor.process(jobProcessorContext);
            }
        }
    }

    protected void callHistoryJobProcessors(HistoryJobProcessorContext.Phase processorType, HistoryJobEntity historyJobEntity) {
        if (jobServiceConfiguration.getHistoryJobProcessors() !is null) {
            HistoryJobProcessorContextImpl historyJobProcessorContext = new HistoryJobProcessorContextImpl(processorType, historyJobEntity);
            foreach (HistoryJobProcessor historyJobProcessor ; jobServiceConfiguration.getHistoryJobProcessors()) {
                historyJobProcessor.process(historyJobProcessorContext);
            }
        }
    }

}
