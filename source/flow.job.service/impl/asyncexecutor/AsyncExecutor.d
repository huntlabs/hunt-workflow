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


import org.flowable.job.api.JobInfo;
import org.flowable.job.service.JobServiceConfiguration;

/**
 * @author Tijd Rademakers
 * @author Joram Barrez
 */
interface AsyncExecutor {

    /**
     * Starts the Async Executor: jobs will be acquired and executed.
     */
    void start();

    /**
     * Stops executing jobs.
     */
    void shutdown();

    /**
     * Offers the provided {@link JobInfo} to this {@link AsyncExecutor} instance to execute. If the offering does not work for some reason, false will be returned (For example when the job queue is
     * full in the {@link DefaultAsyncJobExecutor}).
     */
    boolean executeAsyncJob(JobInfo job);

    int getRemainingCapacity();

    /* Getters and Setters */

    void setJobServiceConfiguration(JobServiceConfiguration jobServiceConfiguration);

    JobServiceConfiguration getJobServiceConfiguration();

    boolean isAutoActivate();

    void setAutoActivate(boolean isAutoActivate);

    boolean isActive();

    string getLockOwner();

    int getTimerLockTimeInMillis();

    void setTimerLockTimeInMillis(int lockTimeInMillis);

    int getAsyncJobLockTimeInMillis();

    void setAsyncJobLockTimeInMillis(int lockTimeInMillis);

    int getDefaultTimerJobAcquireWaitTimeInMillis();

    void setDefaultTimerJobAcquireWaitTimeInMillis(int waitTimeInMillis);

    int getDefaultAsyncJobAcquireWaitTimeInMillis();

    void setDefaultAsyncJobAcquireWaitTimeInMillis(int waitTimeInMillis);

    public int getDefaultQueueSizeFullWaitTimeInMillis();

    public void setDefaultQueueSizeFullWaitTimeInMillis(int defaultQueueSizeFullWaitTimeInMillis);

    int getMaxAsyncJobsDuePerAcquisition();

    void setMaxAsyncJobsDuePerAcquisition(int maxJobs);

    int getMaxTimerJobsPerAcquisition();

    void setMaxTimerJobsPerAcquisition(int maxJobs);

    int getRetryWaitTimeInMillis();

    void setRetryWaitTimeInMillis(int retryWaitTimeInMillis);

    int getResetExpiredJobsInterval();

    void setResetExpiredJobsInterval(int resetExpiredJobsInterval);

    int getResetExpiredJobsPageSize();

    void setResetExpiredJobsPageSize(int resetExpiredJobsPageSize);

}
