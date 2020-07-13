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
//module flow.job.service.impl.asyncexecutor.multitenant.ExecutorPerTenantAsyncExecutor;
//
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//import hunt.collection.Set;
//
//import flow.common.cfg.multitenant.TenantInfoHolder;
//import flow.job.service.api.JobInfo;
//import flow.job.service.JobServiceConfiguration;
//import flow.job.service.impl.asyncexecutor.AbstractAsyncExecutor;
//import flow.job.service.impl.asyncexecutor.AsyncExecutor;
//import flow.job.service.impl.asyncexecutor.DefaultAsyncJobExecutor;
//import flow.job.service.impl.asyncexecutor.JobManager;
//import flow.job.service.impl.asyncexecutor.multitenant.TenantAwareAsyncExecutorFactory;
//import flow.job.service.impl.asyncexecutor.multitenant.TenantAwareAsyncExecutor;
///**
// * An {@link AsyncExecutor} that has one {@link AsyncExecutor} per tenant. So each tenant has its own acquiring threads and it's own threadpool for executing jobs.
// *
// * @author Joram Barrez
// */
//class ExecutorPerTenantAsyncExecutor : TenantAwareAsyncExecutor {
//
//    protected TenantInfoHolder tenantInfoHolder;
//    protected TenantAwareAsyncExecutorFactory tenantAwareAyncExecutorFactory;
//
//    protected Map!(string, AsyncExecutor) tenantExecutors  ;//= new HashMap<>();
//
//    protected JobServiceConfiguration jobServiceConfiguration;
//    protected bool active;
//    protected bool autoActivate;
//
//    this(TenantInfoHolder tenantInfoHolder) {
//        this(tenantInfoHolder, null);
//    }
//
//    this(TenantInfoHolder tenantInfoHolder, TenantAwareAsyncExecutorFactory tenantAwareAyncExecutorFactory) {
//        this.tenantInfoHolder = tenantInfoHolder;
//        this.tenantAwareAyncExecutorFactory = tenantAwareAyncExecutorFactory;
//        tenantExecutors = new HashMap!(string, AsyncExecutor);
//    }
//
//
//    public Set!string getTenantIds() {
//        return tenantExecutors.keySet();
//    }
//
//
//    public void addTenantAsyncExecutor(string tenantId, bool startExecutor) {
//        AsyncExecutor tenantExecutor = null;
//
//        if (tenantAwareAyncExecutorFactory is null) {
//            tenantExecutor = new DefaultAsyncJobExecutor();
//        } else {
//            tenantExecutor = tenantAwareAyncExecutorFactory.createAsyncExecutor(tenantId);
//        }
//
//        tenantExecutor.setJobServiceConfiguration(jobServiceConfiguration);
//
//        if (tenantExecutor instanceof AbstractAsyncExecutor) {
//            AbstractAsyncExecutor defaultAsyncJobExecutor = (AbstractAsyncExecutor) tenantExecutor;
//            defaultAsyncJobExecutor.setAsyncJobsDueRunnable(new TenantAwareAcquireAsyncJobsDueRunnable(defaultAsyncJobExecutor, tenantInfoHolder, tenantId));
//            defaultAsyncJobExecutor.setTimerJobRunnable(new TenantAwareAcquireTimerJobsRunnable(defaultAsyncJobExecutor, tenantInfoHolder, tenantId));
//            defaultAsyncJobExecutor.setExecuteAsyncRunnableFactory(new TenantAwareExecuteAsyncRunnableFactory(tenantInfoHolder, tenantId));
//            defaultAsyncJobExecutor.setResetExpiredJobsRunnable(new TenantAwareResetExpiredJobsRunnable(defaultAsyncJobExecutor, tenantInfoHolder, tenantId));
//        }
//
//        tenantExecutors.put(tenantId, tenantExecutor);
//
//        if (startExecutor) {
//            startTenantExecutor(tenantId);
//        }
//    }
//
//
//    public AsyncExecutor getTenantAsyncExecutor(string tenantId) {
//        return tenantExecutors.get(tenantId);
//    }
//
//
//    public void removeTenantAsyncExecutor(string tenantId) {
//        shutdownTenantExecutor(tenantId);
//        tenantExecutors.remove(tenantId);
//    }
//
//    protected AsyncExecutor determineAsyncExecutor() {
//        return tenantExecutors.get(tenantInfoHolder.getCurrentTenantId());
//    }
//
//
//    public bool executeAsyncJob(JobInfo job) {
//        return determineAsyncExecutor().executeAsyncJob(job);
//    }
//
//
//    public int getRemainingCapacity() {
//        return determineAsyncExecutor().getRemainingCapacity();
//    }
//
//    public JobManager getJobManager() {
//        // Should never be accessed on this class, should be accessed on the actual AsyncExecutor
//        throw new UnsupportedOperationException();
//    }
//
//
//    public void setJobServiceConfiguration(JobServiceConfiguration jobServiceConfiguration) {
//        this.jobServiceConfiguration = jobServiceConfiguration;
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setJobServiceConfiguration(jobServiceConfiguration);
//        }
//    }
//
//
//    public JobServiceConfiguration getJobServiceConfiguration() {
//        throw new UnsupportedOperationException();
//    }
//
//
//    public bool isAutoActivate() {
//        return autoActivate;
//    }
//
//
//    public void setAutoActivate(bool isAutoActivate) {
//        autoActivate = isAutoActivate;
//    }
//
//
//    public bool isActive() {
//        return active;
//    }
//
//
//    public void start() {
//        for (string tenantId : tenantExecutors.keySet()) {
//            startTenantExecutor(tenantId);
//        }
//        active = true;
//    }
//
//    protected void startTenantExecutor(string tenantId) {
//        tenantInfoHolder.setCurrentTenantId(tenantId);
//        tenantExecutors.get(tenantId).start();
//        tenantInfoHolder.clearCurrentTenantId();
//    }
//
//
//    public synchronized void shutdown() {
//        for (string tenantId : tenantExecutors.keySet()) {
//            shutdownTenantExecutor(tenantId);
//        }
//        active = false;
//    }
//
//    protected void shutdownTenantExecutor(string tenantId) {
//        LOGGER.info("Shutting down async executor for tenant {}", tenantId);
//        tenantExecutors.get(tenantId).shutdown();
//    }
//
//
//    public string getLockOwner() {
//        return determineAsyncExecutor().getLockOwner();
//    }
//
//
//    public int getTimerLockTimeInMillis() {
//        return determineAsyncExecutor().getTimerLockTimeInMillis();
//    }
//
//
//    public void setTimerLockTimeInMillis(int lockTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setTimerLockTimeInMillis(lockTimeInMillis);
//        }
//    }
//
//
//    public int getAsyncJobLockTimeInMillis() {
//        return determineAsyncExecutor().getAsyncJobLockTimeInMillis();
//    }
//
//
//    public void setAsyncJobLockTimeInMillis(int lockTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setAsyncJobLockTimeInMillis(lockTimeInMillis);
//        }
//    }
//
//
//    public int getDefaultTimerJobAcquireWaitTimeInMillis() {
//        return determineAsyncExecutor().getDefaultTimerJobAcquireWaitTimeInMillis();
//    }
//
//
//    public void setDefaultTimerJobAcquireWaitTimeInMillis(int waitTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setDefaultTimerJobAcquireWaitTimeInMillis(waitTimeInMillis);
//        }
//    }
//
//
//    public int getDefaultAsyncJobAcquireWaitTimeInMillis() {
//        return determineAsyncExecutor().getDefaultAsyncJobAcquireWaitTimeInMillis();
//    }
//
//
//    public void setDefaultAsyncJobAcquireWaitTimeInMillis(int waitTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setDefaultAsyncJobAcquireWaitTimeInMillis(waitTimeInMillis);
//        }
//    }
//
//
//    public int getDefaultQueueSizeFullWaitTimeInMillis() {
//        return determineAsyncExecutor().getDefaultQueueSizeFullWaitTimeInMillis();
//    }
//
//
//    public void setDefaultQueueSizeFullWaitTimeInMillis(int defaultQueueSizeFullWaitTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setDefaultQueueSizeFullWaitTimeInMillis(defaultQueueSizeFullWaitTimeInMillis);
//        }
//    }
//
//
//    public int getMaxAsyncJobsDuePerAcquisition() {
//        return determineAsyncExecutor().getMaxAsyncJobsDuePerAcquisition();
//    }
//
//
//    public void setMaxAsyncJobsDuePerAcquisition(int maxJobs) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setMaxAsyncJobsDuePerAcquisition(maxJobs);
//        }
//    }
//
//
//    public int getMaxTimerJobsPerAcquisition() {
//        return determineAsyncExecutor().getMaxTimerJobsPerAcquisition();
//    }
//
//
//    public void setMaxTimerJobsPerAcquisition(int maxJobs) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setMaxTimerJobsPerAcquisition(maxJobs);
//        }
//    }
//
//
//    public int getRetryWaitTimeInMillis() {
//        return determineAsyncExecutor().getRetryWaitTimeInMillis();
//    }
//
//
//    public void setRetryWaitTimeInMillis(int retryWaitTimeInMillis) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setRetryWaitTimeInMillis(retryWaitTimeInMillis);
//        }
//    }
//
//
//    public int getResetExpiredJobsInterval() {
//        return determineAsyncExecutor().getResetExpiredJobsInterval();
//    }
//
//
//    public void setResetExpiredJobsInterval(int resetExpiredJobsInterval) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setResetExpiredJobsInterval(resetExpiredJobsInterval);
//        }
//    }
//
//
//    public int getResetExpiredJobsPageSize() {
//        return determineAsyncExecutor().getResetExpiredJobsPageSize();
//    }
//
//
//    public void setResetExpiredJobsPageSize(int resetExpiredJobsPageSize) {
//        for (AsyncExecutor asyncExecutor : tenantExecutors.values()) {
//            asyncExecutor.setResetExpiredJobsPageSize(resetExpiredJobsPageSize);
//        }
//    }
//
//}
