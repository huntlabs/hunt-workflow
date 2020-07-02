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
module flow.job.service.impl.JobServiceImpl;

import hunt.collection;
import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.job.service.api.DeadLetterJobQuery;
import flow.job.service.api.HistoryJobQuery;
import flow.job.service.api.JobInfo;
import flow.job.service.api.JobQuery;
import flow.job.service.api.SuspendedJobQuery;
import flow.job.service.api.TimerJobQuery;
import flow.job.service.JobService;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntityManager;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.JobEntityManager;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.persistence.entity.SuspendedJobEntityManager;
import flow.job.service.impl.ServiceImpl;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.TimerJobQueryImpl;
import flow.job.service.impl.SuspendedJobQueryImpl;
import flow.job.service.impl.DeadLetterJobQueryImpl;
import flow.job.service.impl.HistoryJobQueryImpl;
/**
 * @author Tijs Rademakers
 */
class JobServiceImpl : ServiceImpl , JobService {

    this(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }


    public JobQuery createJobQuery() {
        return new JobQueryImpl(getCommandExecutor());
    }


    public TimerJobQuery createTimerJobQuery() {
        return new TimerJobQueryImpl(getCommandExecutor());
    }


    public SuspendedJobQuery createSuspendedJobQuery() {
        return new SuspendedJobQueryImpl(getCommandExecutor());
    }


    public DeadLetterJobQuery createDeadLetterJobQuery() {
        return new DeadLetterJobQueryImpl(getCommandExecutor());
    }


    public HistoryJobQuery createHistoryJobQuery() {
        return new HistoryJobQueryImpl(getCommandExecutor());
    }


    public void scheduleAsyncJob(JobEntity job) {
        getJobManager().scheduleAsyncJob(job);
    }


    public JobEntity findJobById(string jobId) {
        return getJobEntityManager().findById(jobId);
    }


    public List!JobEntity findJobsByExecutionId(string executionId) {
        return getJobEntityManager().findJobsByExecutionId(executionId);
    }


    public List!SuspendedJobEntity findSuspendedJobsByExecutionId(string executionId) {
        return getSuspendedJobEntityManager().findJobsByExecutionId(executionId);
    }


    public List!DeadLetterJobEntity findDeadLetterJobsByExecutionId(string executionId) {
        return getDeadLetterJobEntityManager().findJobsByExecutionId(executionId);
    }


    public List!JobEntity findJobsByProcessInstanceId(string processInstanceId) {
        return getJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }


    public List!SuspendedJobEntity findSuspendedJobsByProcessInstanceId(string processInstanceId) {
        return getSuspendedJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }


    public List!DeadLetterJobEntity findDeadLetterJobsByProcessInstanceId(string processInstanceId) {
        return getDeadLetterJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }


    public void updateAllJobTypesTenantIdForDeployment(string deploymentId, string newTenantId) {
        getJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getTimerJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getSuspendedJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
        getDeadLetterJobEntityManager().updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }


    public AbstractRuntimeJobEntity activateSuspendedJob(SuspendedJobEntity job) {
        if (configuration.getJobParentStateResolver().isSuspended(job)) {
            throw new FlowableIllegalArgumentException("Can not activate job "~ job.getId() ~". Parent is suspended.");
        }
        return getJobManager().activateSuspendedJob(job);
    }


    public SuspendedJobEntity moveJobToSuspendedJob(AbstractRuntimeJobEntity job) {
        return getJobManager().moveJobToSuspendedJob(job);
    }


    public AbstractRuntimeJobEntity moveJobToDeadLetterJob(AbstractRuntimeJobEntity job) {
        return getJobManager().moveJobToDeadLetterJob(job);
    }


    public void unacquireWithDecrementRetries(JobInfo job) {
        getJobManager().unacquireWithDecrementRetries(job);
    }


    public JobEntity createJob() {
        return getJobEntityManager().create();
    }


    public void createAsyncJob(JobEntity job, bool isExclusive) {
        getJobManager().createAsyncJob(job, isExclusive);
    }


    public void insertJob(JobEntity job) {
        getJobEntityManager().insert(job);
    }


    public DeadLetterJobEntity createDeadLetterJob() {
        return getDeadLetterJobEntityManager().create();
    }


    public void insertDeadLetterJob(DeadLetterJobEntity deadLetterJob) {
        getDeadLetterJobEntityManager().insert(deadLetterJob);
    }


    public void updateJob(JobEntity job) {
        getJobEntityManager().update(job);
    }


    public void deleteJob(string jobId) {
        getJobEntityManager().dele(jobId);
    }


    public void deleteJob(JobEntity job) {
        getJobEntityManager().dele(job);
    }


    public void deleteJobsByExecutionId(string executionId) {
        JobEntityManager jobEntityManager = getJobEntityManager();
        Collection!JobEntity jobsForExecution = jobEntityManager.findJobsByExecutionId(executionId);
        foreach (JobEntity job ; jobsForExecution) {
            getJobEntityManager().dele(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, cast(Object)job));
            }
        }
    }


    public void deleteSuspendedJobsByExecutionId(string executionId) {
        SuspendedJobEntityManager suspendedJobEntityManager = getSuspendedJobEntityManager();
        Collection!SuspendedJobEntity suspendedJobsForExecution = suspendedJobEntityManager.findJobsByExecutionId(executionId);
        foreach (SuspendedJobEntity job ; suspendedJobsForExecution) {
            suspendedJobEntityManager.dele(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, cast(Object)job));
            }
        }
    }


    public void deleteDeadLetterJobsByExecutionId(string executionId) {
        DeadLetterJobEntityManager deadLetterJobEntityManager = getDeadLetterJobEntityManager();
        Collection!DeadLetterJobEntity deadLetterJobsForExecution = deadLetterJobEntityManager.findJobsByExecutionId(executionId);
        foreach (DeadLetterJobEntity job ; deadLetterJobsForExecution) {
            deadLetterJobEntityManager.dele(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, cast(Object)job));
            }
        }
    }

}
