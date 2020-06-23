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

module flow.job.service.impl.asyncexecutor.ExecuteAsyncRunnable;
import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.common.api.FlowableException;
import flow.common.api.FlowableOptimisticLockingException;
import flow.common.context.Context;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.HistoryJob;
import flow.job.service.api.Job;
import flow.job.service.api.JobInfo;
import flow.job.service.InternalJobCompatibilityManager;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.cmd.ExecuteAsyncJobCmd;
import flow.job.service.impl.cmd.LockExclusiveJobCmd;
import flow.job.service.impl.cmd.UnlockExclusiveJobCmd;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntityManager;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import hunt.util.Common;
import hunt.Exceptions;
import hunt.logging;
import hunt.Object;
import hunt.util.Runnable;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ExecuteAsyncRunnable : Runnable {

    protected string jobId;
    protected JobInfo job;
    protected JobServiceConfiguration jobServiceConfiguration;
    protected JobInfoEntityManager!JobInfoEntity jobEntityManager;
    protected List!AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandlers;

    this(string jobId, JobServiceConfiguration jobServiceConfiguration,
            JobInfoEntityManager!JobInfoEntity jobEntityManager,
            AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler) {

        initialize(jobId, null, jobServiceConfiguration, jobEntityManager, asyncRunnableExecutionExceptionHandler);
    }

    this(JobInfo job, JobServiceConfiguration jobServiceConfiguration,
                                JobInfoEntityManager!JobInfoEntity jobEntityManager,
                                AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler) {

        initialize(job.getId(), job, jobServiceConfiguration, jobEntityManager, asyncRunnableExecutionExceptionHandler);
    }

    private void initialize(string jobId, JobInfo job, JobServiceConfiguration jobServiceConfiguration, JobInfoEntityManager!JobInfoEntity jobEntityManager, AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler) {
        this.job = job;
        this.jobId = jobId;
        this.jobServiceConfiguration = jobServiceConfiguration;
        this.jobEntityManager = jobEntityManager;
        this.asyncRunnableExecutionExceptionHandlers = initializeExceptionHandlers(jobServiceConfiguration, asyncRunnableExecutionExceptionHandler);
    }

    private List!AsyncRunnableExecutionExceptionHandler initializeExceptionHandlers(JobServiceConfiguration jobServiceConfiguration, AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler) {
        List!AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandlers = new ArrayList!AsyncRunnableExecutionExceptionHandler();
        if (asyncRunnableExecutionExceptionHandler !is null) {
            asyncRunnableExecutionExceptionHandlers.add(asyncRunnableExecutionExceptionHandler);
        }

        if (jobServiceConfiguration.getAsyncRunnableExecutionExceptionHandlers() !is null) {
            asyncRunnableExecutionExceptionHandlers.addAll(jobServiceConfiguration.getAsyncRunnableExecutionExceptionHandlers());
        }

        return asyncRunnableExecutionExceptionHandlers;
    }

    public void run() {

        if (job is null) {
            job = jobServiceConfiguration.getCommandExecutor().execute(new class Command!JobInfoEntity {
                public JobInfoEntity execute(CommandContext commandContext) {
                    return jobEntityManager.findById(jobId);
                }
            });
        }

        Job jobObject = cast(Job) job;
        if (jobObject !is null) {
            InternalJobCompatibilityManager internalJobCompatibilityManager = jobServiceConfiguration.getInternalJobCompatibilityManager();
            if (internalJobCompatibilityManager !is null && internalJobCompatibilityManager.isFlowable5Job(jobObject)) {
                internalJobCompatibilityManager.executeV5JobWithLockAndRetry(jobObject);
                return;
            }
        }
        AbstractRuntimeJobEntity aj = cast(AbstractRuntimeJobEntity)job;
        if (aj !is null) {
            bool lockingNeeded = aj.isExclusive();
            bool executeJob = true;
            if (lockingNeeded) {
                executeJob = lockJob();
            }
            if (executeJob) {
                executeJob(lockingNeeded);
            }

        } else { // history jobs
            executeJob(false); // no locking for history jobs needed

        }

    }

    protected void executeJob(final bool unlock) {
        try {
            jobServiceConfiguration.getCommandExecutor().execute(new class Command!Void {
                public Void execute(CommandContext commandContext) {
                    new ExecuteAsyncJobCmd(jobId, jobEntityManager).execute(commandContext);
                    if (unlock) {
                        // Part of the same transaction to avoid a race condition with the
                        // potentially new jobs (wrt process instance locking) that are created
                        // during the execution of the original job
                        new UnlockExclusiveJobCmd(cast(Job) job).execute(commandContext);
                    }
                    return null;
                }
            });

        } catch ( FlowableOptimisticLockingException e) {
            try {
                handleFailedJob(e);
            } catch (Exception fe) {
                // no additional handling is needed
            }

            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Optimistic locking exception during job execution. If you have multiple async executors running against the same database, "
            //            + "this exception means that this thread tried to acquire an exclusive job, which already was changed by another async executor thread."
            //            + "This is expected behavior in a clustered environment. " + "You can ignore this message if you indeed have multiple job executor threads running against the same database. "
            //            + "Exception message: {}", e.getMessage());
            //}

        } catch (Throwable exception) {
            handleFailedJob(exception);
        }
    }

    protected void unlockJobIfNeeded() {
        if (cast(HistoryJob)this.job !is null) {
            return;
            // no unlocking needed for history job
        }

        Job job = cast(Job) this.job; // This method is only called for a regular Job
        try {
            if (job.isExclusive()) {
                jobServiceConfiguration.getCommandExecutor().execute(new UnlockExclusiveJobCmd(job));
            }

        } catch (FlowableOptimisticLockingException optimisticLockingException) {
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Optimistic locking exception while unlocking the job. If you have multiple async executors running against the same database, "
            //            + "this exception means that this thread tried to acquire an exclusive job, which already was changed by another async executor thread."
            //            + "This is expected behavior in a clustered environment. " + "You can ignore this message if you indeed have multiple job executor acquisition threads running against the same database. "
            //            + "Exception message: {}", optimisticLockingException.getMessage());
            //}

        } catch (Throwable t) {
            logError("Error while unlocking exclusive job {%s} %s",job.getId(),t.msg);
            //LOGGER.error("Error while unlocking exclusive job {}", job.getId(), t);
        }
    }

    protected bool lockJob() {
        Job job = cast(Job) this.job; // This method is only called for a regular Job
        try {
            jobServiceConfiguration.getCommandExecutor().execute(new LockExclusiveJobCmd(job));

        } catch (Throwable lockException) {
            //if (LOGGER.isDebugEnabled()) {
            //    LOGGER.debug("Could not lock exclusive job. Unlocking job so it can be acquired again. Caught exception: {}", lockException.getMessage());
            //}

            // Release the job again so it can be acquired later or by another node
            unacquireJob();

            return false;
        }

        return true;
    }

    protected void unacquireJob() {
        CommandContext commandContext = Context.getCommandContext();
        if (commandContext !is null) {
            CommandContextUtil.getJobManager(commandContext).unacquire(job);
        } else {
            jobServiceConfiguration.getCommandExecutor().execute(new class Command!Void {
                public Void execute(CommandContext commandContext) {
                    CommandContextUtil.getJobManager(commandContext).unacquire(job);
                    return null;
                }
            });
        }
    }

    protected void handleFailedJob(final Throwable exception) {
        foreach (AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler ; asyncRunnableExecutionExceptionHandlers) {
            if (asyncRunnableExecutionExceptionHandler.handleException(this.jobServiceConfiguration, this.job, exception)) {

                // Needs to run in a separate transaction as the original transaction has been marked for rollback
                unlockJobIfNeeded();

                return;
            }
        }
        logError("Unable to handle exception {%s} for job {}.",exception.msg);
       // LOGGER.error("Unable to handle exception {} for job {}.", exception, job);
        throw new FlowableException("Unable to handle exception " ~ exception.msg() ~ " for job " ~ job.getId());
    }

}
