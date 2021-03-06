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
//module flow.job.service.impl.asyncexecutor.multitenant.SharedExecutorServiceAsyncExecutor;
//
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//import hunt.collection.Set;
//import java.util.concurrent.ExecutorService;
//
//import flow.common.cfg.multitenant.TenantInfoHolder;
//import flow.job.service.api.JobInfo;
//import flow.job.service.JobServiceConfiguration;
//import flow.job.service.impl.asyncexecutor.AsyncExecutor;
//import flow.job.service.impl.asyncexecutor.DefaultAsyncJobExecutor;
//import flow.job.service.impl.asyncexecutor.ExecuteAsyncRunnableFactory;
//import flow.job.service.impl.cmd.UnacquireOwnedJobsCmd;
//
///**
// * Multi tenant {@link AsyncExecutor}.
// *
// * For each tenant, there will be acquire threads, but only one {@link ExecutorService} will be used once the jobs are acquired.
// *
// * @author Joram Barrez
// */
//class SharedExecutorServiceAsyncExecutor extends DefaultAsyncJobExecutor implements TenantAwareAsyncExecutor {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(SharedExecutorServiceAsyncExecutor.class);
//
//    protected TenantInfoHolder tenantInfoHolder;
//
//    protected Map<string, Thread> timerJobAcquisitionThreads = new HashMap<>();
//    protected Map<string, TenantAwareAcquireTimerJobsRunnable> timerJobAcquisitionRunnables = new HashMap<>();
//
//    protected Map<string, Thread> asyncJobAcquisitionThreads = new HashMap<>();
//    protected Map<string, TenantAwareAcquireAsyncJobsDueRunnable> asyncJobAcquisitionRunnables = new HashMap<>();
//
//    protected Map<string, Thread> resetExpiredJobsThreads = new HashMap<>();
//    protected Map<string, TenantAwareResetExpiredJobsRunnable> resetExpiredJobsRunnables = new HashMap<>();
//
//    public SharedExecutorServiceAsyncExecutor(TenantInfoHolder tenantInfoHolder) {
//        this.tenantInfoHolder = tenantInfoHolder;
//
//        setExecuteAsyncRunnableFactory(new ExecuteAsyncRunnableFactory() {
//
//            @Override
//            public Runnable createExecuteAsyncRunnable(JobInfo job, JobServiceConfiguration jobServiceConfiguration) {
//
//                // Here, the runnable will be created by for example the acquire thread, which has already set the current id.
//                // But it will be executed later on, by the executorService and thus we need to set it explicitly again then
//
//                return new TenantAwareExecuteAsyncRunnable(job, jobServiceConfiguration,
//                        SharedExecutorServiceAsyncExecutor.this.tenantInfoHolder,
//                        SharedExecutorServiceAsyncExecutor.this.tenantInfoHolder.getCurrentTenantId());
//            }
//
//        });
//    }
//
//    @Override
//    public Set!string getTenantIds() {
//        return timerJobAcquisitionRunnables.keySet();
//    }
//
//    @Override
//    public void addTenantAsyncExecutor(string tenantId, bool startExecutor) {
//
//        TenantAwareAcquireTimerJobsRunnable timerRunnable = new TenantAwareAcquireTimerJobsRunnable(this, tenantInfoHolder, tenantId);
//        timerJobAcquisitionRunnables.put(tenantId, timerRunnable);
//        timerJobAcquisitionThreads.put(tenantId, new Thread(timerRunnable));
//
//        TenantAwareAcquireAsyncJobsDueRunnable asyncJobsRunnable = new TenantAwareAcquireAsyncJobsDueRunnable(this, tenantInfoHolder, tenantId);
//        asyncJobAcquisitionRunnables.put(tenantId, asyncJobsRunnable);
//        asyncJobAcquisitionThreads.put(tenantId, new Thread(asyncJobsRunnable));
//
//        TenantAwareResetExpiredJobsRunnable resetExpiredJobsRunnable = new TenantAwareResetExpiredJobsRunnable(this, tenantInfoHolder, tenantId);
//        resetExpiredJobsRunnables.put(tenantId, resetExpiredJobsRunnable);
//        resetExpiredJobsThreads.put(tenantId, new Thread(resetExpiredJobsRunnable));
//
//        if (startExecutor) {
//            startTimerJobAcquisitionForTenant(tenantId);
//            startAsyncJobAcquisitionForTenant(tenantId);
//            startResetExpiredJobsForTenant(tenantId);
//        }
//    }
//
//    @Override
//    public AsyncExecutor getTenantAsyncExecutor(string tenantId) {
//        return this;
//    }
//
//    @Override
//    public void removeTenantAsyncExecutor(string tenantId) {
//        stopThreadsForTenant(tenantId);
//    }
//
//    @Override
//    protected void unlockOwnedJobs() {
//        for (string tenantId : timerJobAcquisitionThreads.keySet()) {
//            tenantInfoHolder.setCurrentTenantId(tenantId);
//            jobServiceConfiguration.getCommandExecutor().execute(new UnacquireOwnedJobsCmd(lockOwner, tenantId));
//            tenantInfoHolder.clearCurrentTenantId();
//        }
//    }
//
//    @Override
//    public void start() {
//        for (string tenantId : timerJobAcquisitionRunnables.keySet()) {
//            startTimerJobAcquisitionForTenant(tenantId);
//            startAsyncJobAcquisitionForTenant(tenantId);
//            startResetExpiredJobsForTenant(tenantId);
//        }
//    }
//
//    protected void startTimerJobAcquisitionForTenant(string tenantId) {
//        timerJobAcquisitionThreads.get(tenantId).start();
//    }
//
//    protected void startAsyncJobAcquisitionForTenant(string tenantId) {
//        asyncJobAcquisitionThreads.get(tenantId).start();
//    }
//
//    protected void startResetExpiredJobsForTenant(string tenantId) {
//        resetExpiredJobsThreads.get(tenantId).start();
//    }
//
//    @Override
//    protected void stopJobAcquisitionThread() {
//        for (string tenantId : timerJobAcquisitionRunnables.keySet()) {
//            stopThreadsForTenant(tenantId);
//        }
//    }
//
//    protected void stopThreadsForTenant(string tenantId) {
//        timerJobAcquisitionRunnables.get(tenantId).stop();
//        asyncJobAcquisitionRunnables.get(tenantId).stop();
//        resetExpiredJobsRunnables.get(tenantId).stop();
//
//        try {
//            timerJobAcquisitionThreads.get(tenantId).join();
//        } catch (InterruptedException e) {
//            LOGGER.warn("Interrupted while waiting for the timer job acquisition thread to terminate", e);
//        }
//
//        try {
//            asyncJobAcquisitionThreads.get(tenantId).join();
//        } catch (InterruptedException e) {
//            LOGGER.warn("Interrupted while waiting for the timer job acquisition thread to terminate", e);
//        }
//
//        try {
//            resetExpiredJobsThreads.get(tenantId).join();
//        } catch (InterruptedException e) {
//            LOGGER.warn("Interrupted while waiting for the reset expired jobs thread to terminate", e);
//        }
//    }
//
//}
