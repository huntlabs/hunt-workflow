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
//module flow.job.service.impl.asyncexecutor.DefaultAsyncJobExecutor;
//
////import java.util.concurrent.ArrayBlockingQueue;
////import java.util.concurrent.BlockingQueue;
////import java.util.concurrent.ExecutorService;
////import java.util.concurrent.RejectedExecutionException;
////import java.util.concurrent.ThreadPoolExecutor;
////import java.util.concurrent.TimeUnit;
//
////import org.apache.commons.lang3.concurrent.BasicThreadFactory;
//import flow.common.cfg.TransactionPropagation;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandConfig;
//import flow.common.interceptor.CommandContext;
//import flow.job.service.api.JobInfo;
//import flow.job.service.impl.util.CommandContextUtil;
//import flow.job.service.impl.asyncexecutor.AbstractAsyncExecutor;
//import hunt.util.Common;
//import hunt.Exceptions;
///**
// * @author Joram Barrez
// * @author Tijs Rademakers
// */
//class DefaultAsyncJobExecutor : AbstractAsyncExecutor {
//
//    /**
//     * If true (default), the thread for acquiring async jobs will be started.
//     */
//    protected bool isAsyncJobAcquisitionEnabled = true;
//
//    /**
//     * If true (default), the thread for acquiring timer jobs will be started.
//     */
//    protected bool isTimerJobAcquisitionEnabled = true;
//
//    /**
//     * If true (default), the thread for acquiring expired jobs will be started.
//     */
//    protected bool isResetExpiredJobEnabled = true;
//
//    /**
//     * Thread responsible for async job acquisition.
//     */
//    protected Thread asyncJobAcquisitionThread;
//
//    /**
//     * Thread responsible for timer job acquisition.
//     */
//    protected Thread timerJobAcquisitionThread;
//
//    /**
//     * Thread responsible for resetting the expired jobs.
//     */
//    protected Thread resetExpiredJobThread;
//
//    /**
//     * The minimal number of threads that are kept alive in the threadpool for
//     * job execution
//     */
//    protected int corePoolSize = 8;
//
//    /**
//     * The maximum number of threads that are kept alive in the threadpool for
//     * job execution
//     */
//    protected int maxPoolSize = 8;
//
//    /**
//     * The time (in milliseconds) a thread used for job execution must be kept
//     * alive before it is destroyed. Default setting is 0. Having a non-default
//     * setting of 0 takes resources, but in the case of many job executions it
//     * avoids creating new threads all the time.
//     */
//    protected long keepAliveTime = 5000L;
//
//    /** The size of the queue on which jobs to be executed are placed */
//    protected int queueSize = 100;
//
//    /** Whether or not core threads can time out (which is needed to scale down the threads) */
//    protected bool allowCoreThreadTimeout = true;
//
//    /**
//     * Whether to unlock jobs that are owned by this executor (have the same
//     * lockOwner) at startup
//     */
//    protected bool unlockOwnedJobs;
//
//    /** The queue used for job execution work */
//    protected BlockingQueue<Runnable> threadPoolQueue;
//
//    /** The executor service used for job execution */
//    protected ExecutorService executorService;
//
//    /**
//     * The time (in seconds) that is waited to gracefully shut down the
//     * threadpool used for job execution
//     */
//    protected long secondsToWaitOnShutdown = 60L;
//
//    protected string threadPoolNamingPattern = "flowable-async-job-executor-thread-%d";
//
//    override
//    protected bool executeAsyncJob( JobInfo job, Runnable runnable) {
//        //try {
//            //executorService.execute(runnable);
//            runnable.run();
//            return true;
//
//        //} catch (RejectedExecutionException e) {
//        //    unacquireJobAfterRejection(job);
//        //
//        //    // Job queue full, returning false so (if wanted) the acquiring can be throttled
//        //    return false;
//        //}
//    }
//
//    protected void unacquireJobAfterRejection( JobInfo job) {
//        implementationMissing(false);
//
//        // When a RejectedExecutionException is caught, this means that the
//        // queue for holding the jobs that are to be executed is full and can't store more.
//        // The job is now 'unlocked', meaning that the lock owner/time is set to null,
//        // so other executors can pick the job up (or this async executor, the next time the
//        // acquire query is executed.
//
//        //CommandConfig commandConfig = new CommandConfig(false, TransactionPropagation.REQUIRES_NEW);
//        //jobServiceConfiguration.getCommandExecutor().execute(commandConfig, new Command<Void>() {
//        //    override
//        //    public Void execute(CommandContext commandContext) {
//        //        CommandContextUtil.getJobManager(commandContext).unacquire(job);
//        //        return null;
//        //    }
//        //});
//    }
//
//    override
//    protected void startAdditionalComponents() {
//        if (!isMessageQueueMode) {
//            initAsyncJobExecutionThreadPool();
//            startJobAcquisitionThread();
//        }
//
//        if (unlockOwnedJobs) {
//            unlockOwnedJobs();
//        }
//
//        if (timerRunnableNeeded) {
//            startTimerAcquisitionThread();
//        }
//        startResetExpiredJobsThread();
//    }
//
//    override
//    protected void shutdownAdditionalComponents() {
//        stopResetExpiredJobsThread();
//        stopTimerAcquisitionThread();
//        stopJobAcquisitionThread();
//        stopExecutingAsyncJobs();
//
//        if (unlockOwnedJobs) {
//            unlockOwnedJobs();
//        }
//
//    }
//
//    protected void initAsyncJobExecutionThreadPool() {
//        if (threadPoolQueue is null) {
//            LOGGER.info("Creating thread pool queue of size {}", queueSize);
//            threadPoolQueue = new ArrayBlockingQueue<>(queueSize);
//        }
//
//        if (executorService is null) {
//            LOGGER.info("Creating executor service with corePoolSize {}, maxPoolSize {} and keepAliveTime {}", corePoolSize, maxPoolSize, keepAliveTime);
//
//            BasicThreadFactory threadFactory = new BasicThreadFactory.Builder().namingPattern(threadPoolNamingPattern).build();
//            ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(corePoolSize, maxPoolSize, keepAliveTime,
//                TimeUnit.MILLISECONDS, threadPoolQueue, threadFactory);
//            threadPoolExecutor.allowCoreThreadTimeOut(allowCoreThreadTimeout);
//            executorService = threadPoolExecutor;
//        }
//    }
//
//    protected void stopExecutingAsyncJobs() {
//        if (executorService !is null) {
//
//            // Ask the thread pool to finish and exit
//            executorService.shutdown();
//
//            // Waits for 1 minute to finish all currently executing jobs
//            try {
//                if (!executorService.awaitTermination(secondsToWaitOnShutdown, TimeUnit.SECONDS)) {
//                    LOGGER.warn("Timeout during shutdown of async job executor. The current running jobs could not end within {} seconds after shutdown operation.",
//                                    secondsToWaitOnShutdown);
//                }
//            } catch (InterruptedException e) {
//                LOGGER.warn("Interrupted while shutting down the async job executor. ", e);
//            }
//
//            executorService = null;
//        }
//    }
//
//    /** Starts the acquisition thread */
//    protected void startJobAcquisitionThread() {
//        if (isAsyncJobAcquisitionEnabled) {
//            if (asyncJobAcquisitionThread is null) {
//                asyncJobAcquisitionThread = new Thread(asyncJobsDueRunnable);
//            }
//            asyncJobAcquisitionThread.start();
//        }
//    }
//
//    protected void startTimerAcquisitionThread() {
//        if (isTimerJobAcquisitionEnabled) {
//            if (timerJobAcquisitionThread is null) {
//                timerJobAcquisitionThread = new Thread(timerJobRunnable);
//            }
//            timerJobAcquisitionThread.start();
//        }
//    }
//
//    /** Stops the acquisition thread */
//    protected void stopJobAcquisitionThread() {
//        if (asyncJobAcquisitionThread !is null) {
//            try {
//                asyncJobAcquisitionThread.join();
//            } catch (InterruptedException e) {
//                LOGGER.warn("Interrupted while waiting for the async job acquisition thread to terminate", e);
//            }
//            asyncJobAcquisitionThread = null;
//        }
//    }
//
//    protected void stopTimerAcquisitionThread() {
//        if (timerJobAcquisitionThread !is null) {
//            try {
//                timerJobAcquisitionThread.join();
//            } catch (InterruptedException e) {
//                LOGGER.warn("Interrupted while waiting for the timer job acquisition thread to terminate", e);
//            }
//            timerJobAcquisitionThread = null;
//        }
//    }
//
//    /** Starts the reset expired jobs thread */
//    protected void startResetExpiredJobsThread() {
//        if (isResetExpiredJobEnabled) {
//            if (resetExpiredJobThread is null) {
//                resetExpiredJobThread = new Thread(resetExpiredJobsRunnable);
//            }
//            resetExpiredJobThread.start();
//        }
//    }
//
//    /** Stops the reset expired jobs thread */
//    protected void stopResetExpiredJobsThread() {
//        if (resetExpiredJobThread !is null) {
//            try {
//                resetExpiredJobThread.join();
//            } catch (InterruptedException e) {
//                LOGGER.warn("Interrupted while waiting for the reset expired jobs thread to terminate", e);
//            }
//
//            resetExpiredJobThread = null;
//        }
//    }
//
//    public bool isAsyncJobAcquisitionEnabled() {
//        return isAsyncJobAcquisitionEnabled;
//    }
//
//    public void setAsyncJobAcquisitionEnabled(bool isAsyncJobAcquisitionEnabled) {
//        this.isAsyncJobAcquisitionEnabled = isAsyncJobAcquisitionEnabled;
//    }
//
//    public bool isTimerJobAcquisitionEnabled() {
//        return isTimerJobAcquisitionEnabled;
//    }
//
//    public void setTimerJobAcquisitionEnabled(bool isTimerJobAcquisitionEnabled) {
//        this.isTimerJobAcquisitionEnabled = isTimerJobAcquisitionEnabled;
//    }
//
//    public bool isResetExpiredJobEnabled() {
//        return isResetExpiredJobEnabled;
//    }
//
//    public void setResetExpiredJobEnabled(bool isResetExpiredJobEnabled) {
//        this.isResetExpiredJobEnabled = isResetExpiredJobEnabled;
//    }
//
//    public Thread getTimerJobAcquisitionThread() {
//        return timerJobAcquisitionThread;
//    }
//
//    public void setTimerJobAcquisitionThread(Thread timerJobAcquisitionThread) {
//        this.timerJobAcquisitionThread = timerJobAcquisitionThread;
//    }
//
//    public Thread getAsyncJobAcquisitionThread() {
//        return asyncJobAcquisitionThread;
//    }
//
//    public void setAsyncJobAcquisitionThread(Thread asyncJobAcquisitionThread) {
//        this.asyncJobAcquisitionThread = asyncJobAcquisitionThread;
//    }
//
//    public Thread getResetExpiredJobThread() {
//        return resetExpiredJobThread;
//    }
//
//    public void setResetExpiredJobThread(Thread resetExpiredJobThread) {
//        this.resetExpiredJobThread = resetExpiredJobThread;
//    }
//
//    public int getQueueSize() {
//        return queueSize;
//    }
//
//    public bool isAllowCoreThreadTimeout() {
//        return allowCoreThreadTimeout;
//    }
//
//    public void setAllowCoreThreadTimeout(bool allowCoreThreadTimeout) {
//        this.allowCoreThreadTimeout = allowCoreThreadTimeout;
//    }
//
//    override
//    public int getRemainingCapacity() {
//        if (threadPoolQueue !is null) {
//            return threadPoolQueue.remainingCapacity();
//        } else {
//            // return plenty of remaining capacity if there's no thread pool queue
//            return 99;
//        }
//    }
//
//    public void setQueueSize(int queueSize) {
//        this.queueSize = queueSize;
//    }
//
//    public int getCorePoolSize() {
//        return corePoolSize;
//    }
//
//    public void setCorePoolSize(int corePoolSize) {
//        this.corePoolSize = corePoolSize;
//    }
//
//    public int getMaxPoolSize() {
//        return maxPoolSize;
//    }
//
//    public void setMaxPoolSize(int maxPoolSize) {
//        this.maxPoolSize = maxPoolSize;
//    }
//
//    public long getKeepAliveTime() {
//        return keepAliveTime;
//    }
//
//    public void setKeepAliveTime(long keepAliveTime) {
//        this.keepAliveTime = keepAliveTime;
//    }
//
//    public long getSecondsToWaitOnShutdown() {
//        return secondsToWaitOnShutdown;
//    }
//
//    public void setSecondsToWaitOnShutdown(long secondsToWaitOnShutdown) {
//        this.secondsToWaitOnShutdown = secondsToWaitOnShutdown;
//    }
//
//    public bool isUnlockOwnedJobs() {
//        return unlockOwnedJobs;
//    }
//
//    public void setUnlockOwnedJobs(bool unlockOwnedJobs) {
//        this.unlockOwnedJobs = unlockOwnedJobs;
//    }
//
//    public BlockingQueue<Runnable> getThreadPoolQueue() {
//        return threadPoolQueue;
//    }
//
//    public void setThreadPoolQueue(BlockingQueue<Runnable> threadPoolQueue) {
//        this.threadPoolQueue = threadPoolQueue;
//    }
//
//    public ExecutorService getExecutorService() {
//        return executorService;
//    }
//
//    public void setExecutorService(ExecutorService executorService) {
//        this.executorService = executorService;
//    }
//
//    public string getThreadPoolNamingPattern() {
//        return threadPoolNamingPattern;
//    }
//
//    public void setThreadPoolNamingPattern(string threadPoolNamingPattern) {
//        this.threadPoolNamingPattern = threadPoolNamingPattern;
//    }
//
//}
