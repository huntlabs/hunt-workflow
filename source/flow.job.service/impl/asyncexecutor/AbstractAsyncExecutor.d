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
module flow.job.service.impl.asyncexecutor.AbstractAsyncExecutor;

import hunt.collection.LinkedList;
import std.uuid;

import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.cmd.UnacquireOwnedJobsCmd;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntityManager;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.asyncexecutor.AsyncExecutor;
//import flow.job.service.impl.asyncexecutor.AcquireTimerJobsRunnable;
//import flow.job.service.impl.asyncexecutor.AcquireAsyncJobsDueRunnable;
//import flow.job.service.impl.asyncexecutor.ResetExpiredJobsRunnable;
import flow.job.service.impl.asyncexecutor.ExecuteAsyncRunnableFactory;
import flow.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import hunt.util.Common;
import hunt.util.Runnable;
import hunt.Exceptions;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Marcus Klimstra
 */
abstract class AbstractAsyncExecutor : AsyncExecutor {
    private string tenantId;

    protected bool timerRunnableNeeded = true; // default true for backwards compatibility (History Async executor came later)
   // protected AcquireTimerJobsRunnable timerJobRunnable;
    protected string acquireRunnableThreadName;
    protected JobInfoEntityManager!JobInfoEntity jobEntityManager;
    //protected AcquireAsyncJobsDueRunnable asyncJobsDueRunnable;
    protected string resetExpiredRunnableName;
   // protected ResetExpiredJobsRunnable resetExpiredJobsRunnable;

    protected ExecuteAsyncRunnableFactory executeAsyncRunnableFactory;

    protected AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler;

    protected bool _isAutoActivate;
    protected bool _isActive;
    protected bool _isMessageQueueMode;

    protected int maxTimerJobsPerAcquisition = 1;
    protected int maxAsyncJobsDuePerAcquisition = 1;
    protected int defaultTimerJobAcquireWaitTimeInMillis = 10 * 1000;
    protected int defaultAsyncJobAcquireWaitTimeInMillis = 10 * 1000;
    protected int defaultQueueSizeFullWaitTime;

    protected string lockOwner  ;//= UUID.randomUUID().toString();
    protected int timerLockTimeInMillis = 5 * 60 * 1000;
    protected int asyncJobLockTimeInMillis = 5 * 60 * 1000;
    protected int retryWaitTimeInMillis = 500;

    protected int resetExpiredJobsInterval = 60 * 1000;
    protected int resetExpiredJobsPageSize = 3;

    // Job queue used when async executor is not yet started and jobs are already added.
    // This is mainly used for testing purpose.
    protected LinkedList!JobInfo temporaryJobQueue ;//= new LinkedList<>();

    protected JobServiceConfiguration jobServiceConfiguration;

    this()
    {
      temporaryJobQueue = new LinkedList!JobInfo;
      lockOwner = randomUUID().toString();
    }


    public bool executeAsyncJob(JobInfo job) {
        if (_isMessageQueueMode) {
            // When running with a message queue based job executor,
            // the job is not executed here.
            return true;
        }

        Runnable runnable = null;
        if (_isActive) {
            runnable = createRunnableForJob(job);
            return executeAsyncJob(job, runnable);
        } else {
            temporaryJobQueue.add(job);
        }

        return true;
    }

    protected abstract bool executeAsyncJob(JobInfo job, Runnable runnable);

    protected void unlockOwnedJobs() {
        jobServiceConfiguration.getCommandExecutor().execute(new UnacquireOwnedJobsCmd(lockOwner, tenantId));
    }

    protected Runnable createRunnableForJob( JobInfo job) {
        if (executeAsyncRunnableFactory is null) {
            implementationMissing(false);
            return null;
           // return new ExecuteAsyncRunnable(job, jobServiceConfiguration, jobEntityManager, asyncRunnableExecutionExceptionHandler);
        } else {
            return executeAsyncRunnableFactory.createExecuteAsyncRunnable(job, jobServiceConfiguration);
        }
    }

    /** Starts the async executor */

    public void start() {
        if (_isActive) {
            return;
        }

        _isActive = true;

       // LOGGER.info("Starting up the async job executor [{}].", getClass().getName());

        initializeJobEntityManager();
        initializeRunnables();
        startAdditionalComponents();
        executeTemporaryJobs();
    }

    protected void initializeJobEntityManager() {
        if (jobEntityManager is null) {
            jobEntityManager = cast(JobInfoEntityManager!JobInfoEntity)(jobServiceConfiguration.getJobEntityManager());
        }
    }

    protected void initializeRunnables() {
        implementationMissing(false);
        //if (timerRunnableNeeded && timerJobRunnable is null) {
        //    timerJobRunnable = new AcquireTimerJobsRunnable(this, jobServiceConfiguration.getJobManager());
        //}
        //
        //JobInfoEntityManager!JobInfoEntity jobEntityManagerToUse = jobEntityManager !is null
        //        ? jobEntityManager : CommandContextUtil.getJobServiceConfiguration().getJobEntityManager();
        //
        //if (resetExpiredJobsRunnable is null) {
        //    string resetRunnableName = resetExpiredRunnableName !is null ?
        //            resetExpiredRunnableName : "flowable-" ~ getJobServiceConfiguration().getEngineName() ~ "-reset-expired-jobs";
        //    resetExpiredJobsRunnable = new ResetExpiredJobsRunnable(resetRunnableName, this, jobEntityManagerToUse);
        //}
        //
        //if (!isMessageQueueMode && asyncJobsDueRunnable is null) {
        //    string acquireJobsRunnableName = acquireRunnableThreadName !is null ?
        //            acquireRunnableThreadName : "flowable-" ~ getJobServiceConfiguration().getEngineName() ~ "-acquire-async-jobs";
        //    asyncJobsDueRunnable = new AcquireAsyncJobsDueRunnable(acquireJobsRunnableName, this, jobEntityManagerToUse);
        //}
    }

    protected abstract void startAdditionalComponents();

    protected void executeTemporaryJobs() {
        while (!temporaryJobQueue.isEmpty()) {
            JobInfo job = temporaryJobQueue.pop();
            executeAsyncJob(job);
        }
    }

    /** Shuts down the whole job executor */

    public  void shutdown() {
        if (!_isActive) {
            return;
        }
       // LOGGER.info("Shutting down the async job executor [{}].", getClass().getName());

        stopRunnables();
        shutdownAdditionalComponents();

        _isActive = false;
    }

    protected void stopRunnables() {
        //if (timerJobRunnable !is null) {
        //    timerJobRunnable.stop();
        //}
        //if (asyncJobsDueRunnable !is null) {
        //    asyncJobsDueRunnable.stop();
        //}
        //if (resetExpiredJobsRunnable !is null) {
        //    resetExpiredJobsRunnable.stop();
        //}
        //
        //timerJobRunnable = null;
        //asyncJobsDueRunnable = null;
        //resetExpiredJobsRunnable = null;
    }

    protected abstract void shutdownAdditionalComponents();

    /* getters and setters */


    public JobServiceConfiguration getJobServiceConfiguration() {
        return jobServiceConfiguration;
    }


    public void setJobServiceConfiguration(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }


    public bool isAutoActivate() {
        return _isAutoActivate;
    }


    public void setAutoActivate(bool isAutoActivate) {
        this._isAutoActivate = isAutoActivate;
    }


    public bool isActive() {
        return _isActive;
    }

    public bool isMessageQueueMode() {
        return _isMessageQueueMode;
    }

    public void setMessageQueueMode(bool isMessageQueueMode) {
        this._isMessageQueueMode = isMessageQueueMode;
    }


    public string getLockOwner() {
        return lockOwner;
    }

    public void setLockOwner(string lockOwner) {
        this.lockOwner = lockOwner;
    }


    public int getTimerLockTimeInMillis() {
        return timerLockTimeInMillis;
    }


    public void setTimerLockTimeInMillis(int timerLockTimeInMillis) {
        this.timerLockTimeInMillis = timerLockTimeInMillis;
    }


    public int getAsyncJobLockTimeInMillis() {
        return asyncJobLockTimeInMillis;
    }


    public void setAsyncJobLockTimeInMillis(int asyncJobLockTimeInMillis) {
        this.asyncJobLockTimeInMillis = asyncJobLockTimeInMillis;
    }


    public int getMaxTimerJobsPerAcquisition() {
        return maxTimerJobsPerAcquisition;
    }


    public void setMaxTimerJobsPerAcquisition(int maxTimerJobsPerAcquisition) {
        this.maxTimerJobsPerAcquisition = maxTimerJobsPerAcquisition;
    }


    public int getMaxAsyncJobsDuePerAcquisition() {
        return maxAsyncJobsDuePerAcquisition;
    }


    public void setMaxAsyncJobsDuePerAcquisition(int maxAsyncJobsDuePerAcquisition) {
        this.maxAsyncJobsDuePerAcquisition = maxAsyncJobsDuePerAcquisition;
    }


    public int getDefaultTimerJobAcquireWaitTimeInMillis() {
        return defaultTimerJobAcquireWaitTimeInMillis;
    }


    public void setDefaultTimerJobAcquireWaitTimeInMillis(int defaultTimerJobAcquireWaitTimeInMillis) {
        this.defaultTimerJobAcquireWaitTimeInMillis = defaultTimerJobAcquireWaitTimeInMillis;
    }


    public int getDefaultAsyncJobAcquireWaitTimeInMillis() {
        return defaultAsyncJobAcquireWaitTimeInMillis;
    }


    public void setDefaultAsyncJobAcquireWaitTimeInMillis(int defaultAsyncJobAcquireWaitTimeInMillis) {
        this.defaultAsyncJobAcquireWaitTimeInMillis = defaultAsyncJobAcquireWaitTimeInMillis;
    }

    //public void setTimerJobRunnable(AcquireTimerJobsRunnable timerJobRunnable) {
    //    this.timerJobRunnable = timerJobRunnable;
    //}


    public int getDefaultQueueSizeFullWaitTimeInMillis() {
        return defaultQueueSizeFullWaitTime;
    }


    public void setDefaultQueueSizeFullWaitTimeInMillis(int defaultQueueSizeFullWaitTime) {
        this.defaultQueueSizeFullWaitTime = defaultQueueSizeFullWaitTime;
    }

    //public void setAsyncJobsDueRunnable(AcquireAsyncJobsDueRunnable asyncJobsDueRunnable) {
    //    this.asyncJobsDueRunnable = asyncJobsDueRunnable;
    //}

    public void setTimerRunnableNeeded(bool timerRunnableNeeded) {
        this.timerRunnableNeeded = timerRunnableNeeded;
    }

    public void setAcquireRunnableThreadName(string acquireRunnableThreadName) {
        this.acquireRunnableThreadName = acquireRunnableThreadName;
    }

    public void setJobEntityManager(JobInfoEntityManager!JobInfoEntity jobEntityManager) {
        this.jobEntityManager = jobEntityManager;
    }

    public void setResetExpiredRunnableName(string resetExpiredRunnableName) {
        this.resetExpiredRunnableName = resetExpiredRunnableName;
    }

    //public void setResetExpiredJobsRunnable(ResetExpiredJobsRunnable resetExpiredJobsRunnable) {
    //    this.resetExpiredJobsRunnable = resetExpiredJobsRunnable;
    //}


    public int getRetryWaitTimeInMillis() {
        return retryWaitTimeInMillis;
    }


    public void setRetryWaitTimeInMillis(int retryWaitTimeInMillis) {
        this.retryWaitTimeInMillis = retryWaitTimeInMillis;
    }


    public int getResetExpiredJobsInterval() {
        return resetExpiredJobsInterval;
    }


    public void setResetExpiredJobsInterval(int resetExpiredJobsInterval) {
        this.resetExpiredJobsInterval = resetExpiredJobsInterval;
    }


    public int getResetExpiredJobsPageSize() {
        return resetExpiredJobsPageSize;
    }


    public void setResetExpiredJobsPageSize(int resetExpiredJobsPageSize) {
        this.resetExpiredJobsPageSize = resetExpiredJobsPageSize;
    }

    public ExecuteAsyncRunnableFactory getExecuteAsyncRunnableFactory() {
        return executeAsyncRunnableFactory;
    }

    public void setExecuteAsyncRunnableFactory(ExecuteAsyncRunnableFactory executeAsyncRunnableFactory) {
        this.executeAsyncRunnableFactory = executeAsyncRunnableFactory;
    }

    public AsyncRunnableExecutionExceptionHandler getAsyncRunnableExecutionExceptionHandler() {
        return asyncRunnableExecutionExceptionHandler;
    }

    //public void setAsyncRunnableExecutionExceptionHandler(AsyncRunnableExecutionExceptionHandler asyncRunnableExecutionExceptionHandler) {
    //    this.asyncRunnableExecutionExceptionHandler = asyncRunnableExecutionExceptionHandler;
    //}
    //
    //public AcquireTimerJobsRunnable getTimerJobRunnable() {
    //    return timerJobRunnable;
    //}
    //
    //public AcquireAsyncJobsDueRunnable getAsyncJobsDueRunnable() {
    //    return asyncJobsDueRunnable;
    //}
    //
    //public ResetExpiredJobsRunnable getResetExpiredJobsRunnable() {
    //    return resetExpiredJobsRunnable;
    //}

    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

}
