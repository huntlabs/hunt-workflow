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
module flow.job.service.impl.TimerJobServiceImpl;

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
import flow.job.service.impl.ServiceImpl;
/**
 * @author Tijs Rademakers
 */
class TimerJobServiceImpl : ServiceImpl , TimerJobService {

    this(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }


    public TimerJobEntity findTimerJobById(string jobId) {
        return getTimerJobEntityManager().findById(jobId);
    }


    public List!TimerJobEntity findTimerJobsByExecutionId(string executionId) {
        return getTimerJobEntityManager().findJobsByExecutionId(executionId);
    }


    public List!TimerJobEntity findTimerJobsByProcessInstanceId(string processInstanceId) {
        return getTimerJobEntityManager().findJobsByProcessInstanceId(processInstanceId);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionId(string type, string processDefinitionId) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionId(type, processDefinitionId);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyNoTenantId(string type, string processDefinitionKey) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionKeyNoTenantId(type, processDefinitionKey);
    }


    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyAndTenantId(string type, string processDefinitionKey, string tenantId) {
        return getTimerJobEntityManager().findJobsByTypeAndProcessDefinitionKeyAndTenantId(type, processDefinitionKey, tenantId);
    }


    public void scheduleTimerJob(TimerJobEntity timerJob) {
        getJobManager().scheduleTimerJob(timerJob);
    }


    public AbstractRuntimeJobEntity moveJobToTimerJob(JobEntity job) {
        return getJobManager().moveJobToTimerJob(job);
    }


    public TimerJobEntity createTimerJob() {
        return getTimerJobEntityManager().create();
    }


    public void insertTimerJob(TimerJobEntity timerJob) {
        getTimerJobEntityManager().insert(timerJob);
    }


    public void deleteTimerJob(TimerJobEntity timerJob) {
        getTimerJobEntityManager().dele(timerJob);
    }


    public void deleteTimerJobsByExecutionId(string executionId) {
        TimerJobEntityManager timerJobEntityManager = getTimerJobEntityManager();
        Collection!TimerJobEntity timerJobsForExecution = timerJobEntityManager.findJobsByExecutionId(executionId);
        foreach (TimerJobEntity job ; timerJobsForExecution) {
            timerJobEntityManager.dele(job);
            if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
                getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, job));
            }
        }
    }
}
