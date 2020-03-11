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


import hunt.collection;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import org.flowable.job.api.DeadLetterJobQuery;
import org.flowable.job.api.HistoryJobQuery;
import org.flowable.job.api.JobInfo;
import org.flowable.job.api.JobQuery;
import org.flowable.job.api.SuspendedJobQuery;
import org.flowable.job.api.TimerJobQuery;
import org.flowable.job.service.JobService;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.event.impl.FlowableJobEventBuilder;
import org.flowable.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntity;
import org.flowable.job.service.impl.persistence.entity.DeadLetterJobEntityManager;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.persistence.entity.JobEntityManager;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntity;
import org.flowable.job.service.impl.persistence.entity.SuspendedJobEntityManager;

/**
 * @author Tijs Rademakers
 */
class JobServiceImpl extends ServiceImpl implements JobService {

    public JobServiceImpl(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }

    @Override
    public JobQuery createJobQuery() {
        return new JobQueryImpl(getCommandExecutor());
    }

    @Override
    public TimerJobQuery createTimerJobQuery() {
        return new TimerJobQueryImpl(getCommandExecutor());
    }

    @Override
    public SuspendedJobQuery createSuspendedJobQuery() {
        return new SuspendedJobQueryImpl(getCommandExecutor());
    }

    @Override
    public DeadLetterJobQuery createDeadLetterJobQuery() {
        return new DeadLetterJobQueryImpl(getCommandExecutor());
    }

    @Override
    public HistoryJobQuery createHistoryJobQuery() {
        return new HistoryJobQueryImpl(getCommandExecutor());
    }

    @Override
    public void scheduleAsyncJob(JobEntity job) {
        getJobManager().scheduleAsyncJob(job);
    }

    @Override
    public JobEntity findJobById(string jobId) {
        return getJobEntityManager().findById(jobId);
    }

    @Override
    public List<JobEntity> findJobsByExecutionId(string executionId) {
        return getJobEntityManager().findJobsByExecutionId(executionId);
    }

    @Override
    public List<SuspendedJobEntity> findSuspendedJobsByExecutionId(string executionId) {
        return getSuspendedJobEntityManager().findJobsByExecutionId(executionId);
    }

    @Override
    public List<DeadLetterJobEntity> findDeadLetterJobsByExecutionId(string executionId) {
        return getDeadLetterJobEntityManager().findJobsByExecutionId(executionId);
    }

    @Override
    public List<JobEntity> findJobsByProcessInstanceId(string processInstanceId) {
        return getJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<SuspendedJobEntity> findSuspendedJobsByProcessInstanceId(string processInstanceId) {
        return getSuspendedJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<DeadLetterJobEntity> findDeadLetterJobsByProcessInstanceId(string processInstanceId) {
        return getDeadLetterJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }

    @Override
    public void updateAllJobTypesTenantIdForDeployment(string deploymentId, string newTenantId) {
        getJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getTimerJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getSuspendedJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getDeadLetterJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }

    @Override
    public AbstractRuntimeJobEntity activateSuspendedJob(SuspendedJobEntity job) {
        if (configuration.getJobParentStateResolver().isSuspended(job)) {
            throw new FlowableIllegalArgumentException("Can not activate job "+ job.getId() +". Parent is suspended.");
        }
        return getJobManager().activateSuspendedJob(job);
    }

    @Override
    public SuspendedJobEntity moveJobToSuspendedJob(AbstractRuntimeJobEntity job) {
        return getJobManager().moveJobToSuspendedJob(job);
    }

    @Override
    public AbstractRuntimeJobEntity moveJobToDeadLetterJob(AbstractRuntimeJobEntity job) {
        return getJobManager().moveJobToDeadLetterJob(job);
    }

    @Override
    public void unacquireWithDecrementRetries(JobInfo job) {
        getJobManager().unacquireWithDecrementRetries(job);
    }

    @Override
    public JobEntity createJob() {
        return getJobEntityManager().create();
    }

    @Override
    public void createAsyncJob(JobEntity job, bool isExclusive) {
        getJobManager().createAsyncJob(job, isExclusive);
    }

    @Override
    public void insertJob(JobEntity job) {
        getJobEntityManager().insert(job);
    }

    @Override
    public DeadLetterJobEntity createDeadLetterJob() {
        return getDeadLetterJobEntityManager().create();
    }

    @Override
    public void insertDeadLetterJob(DeadLetterJobEntity deadLetterJob) {
        getDeadLetterJobEntityManager().insert(deadLetterJob);
    }

    @Override
    public void updateJob(JobEntity job) {
        getJobEntityManager().update(job);
    }

    @Override
    public void deleteJob(string jobId) {
        getJobEntityManager().delete(jobId);
    }

    @Override
    public void deleteJob(JobEntity job) {
        getJobEntityManager().delete(job);
    }

    @Override
    public void deleteJobsByExecutionId(string executionId) {
        JobEntityManager jobEntityManager = getJobEntityManager();
        Collection<JobEntity> jobsForExecution = jobEntityManager.findJobsByExecutionId(executionId);
        for (JobEntity job : jobsForExecution) {
            getJobEntityManager().delete(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, job));
            }
        }
    }

    @Override
    public void deleteSuspendedJobsByExecutionId(string executionId) {
        SuspendedJobEntityManager suspendedJobEntityManager = getSuspendedJobEntityManager();
        Collection<SuspendedJobEntity> suspendedJobsForExecution = suspendedJobEntityManager.findJobsByExecutionId(executionId);
        for (SuspendedJobEntity job : suspendedJobsForExecution) {
            suspendedJobEntityManager.delete(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, job));
            }
        }
    }

    @Override
    public void deleteDeadLetterJobsByExecutionId(string executionId) {
        DeadLetterJobEntityManager deadLetterJobEntityManager = getDeadLetterJobEntityManager();
        Collection<DeadLetterJobEntity> deadLetterJobsForExecution = deadLetterJobEntityManager.findJobsByExecutionId(executionId);
        for (DeadLetterJobEntity job : deadLetterJobsForExecution) {
            deadLetterJobEntityManager.delete(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, job));
            }
        }
    }

}
