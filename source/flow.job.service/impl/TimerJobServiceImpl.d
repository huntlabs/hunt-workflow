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

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.TimerJobService;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntityManager;

/**
 * @author Tijs Rademakers
 */
class TimerJobServiceImpl extends ServiceImpl implements TimerJobService {

    public TimerJobServiceImpl(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }

    @Override
    public TimerJobEntity findTimerJobById(string jobId) {
        return getTimerJobEntityManager().findById(jobId);
    }

    @Override
    public List<TimerJobEntity> findTimerJobsByExecutionId(string executionId) {
        return getTimerJobEntityManager().findJobsByExecutionId(executionId);
    }

    @Override
    public List<TimerJobEntity> findTimerJobsByProcessInstanceId(string processInstanceId) {
        return getTimerJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }

    @Override
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionId(string type, string processDefinitionId) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionId(type, processDefinitionId);
    }

    @Override
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionKeyNoTenantId(string type, string processDefinitionKey) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionKeyNoTenantId(type, processDefinitionKey);
    }

    @Override
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionKeyAndTenantId(string type, string processDefinitionKey, string tenantId) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionKeyAndTenantId(type, processDefinitionKey, tenantId);
    }

    @Override
    public void scheduleTimerJob(TimerJobEntity timerJob) {
        getJobManager().scheduleTimerJob(timerJob);
    }

    @Override
    public AbstractRuntimeJobEntity moveJobToTimerJob(JobEntity job) {
        return getJobManager().moveJobToTimerJob(job);
    }

    @Override
    public TimerJobEntity createTimerJob() {
        return getTimerJobEntityManager().create();
    }

    @Override
    public void insertTimerJob(TimerJobEntity timerJob) {
        getTimerJobEntityManager().insert(timerJob);
    }

    @Override
    public void deleteTimerJob(TimerJobEntity timerJob) {
        getTimerJobEntityManager().delete(timerJob);
    }

    @Override
    public void deleteTimerJobsByExecutionId(string executionId) {
        TimerJobEntityManager timerJobEntityManager = getTimerJobEntityManager();
        Collection<TimerJobEntity> timerJobsForExecution = timerJobEntityManager.findJobsByExecutionId(executionId);
        for (TimerJobEntity job : timerJobsForExecution) {
            timerJobEntityManager.delete(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, job));
            }
        }
    }
}
