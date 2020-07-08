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

module flow.job.service.impl.persistence.entity.JobEntityManagerImpl;

import hunt.collection.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.persistence.entity.data.JobDataManager;
import flow.job.service.impl.persistence.entity.JobInfoEntityManagerImpl;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.JobEntityManager;
import flow.common.Page;
import hunt.time.LocalDateTime;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class JobEntityManagerImpl
    : JobInfoEntityManagerImpl!(JobEntity, JobDataManager)
    , JobEntityManager {

    this(JobServiceConfiguration jobServiceConfiguration, JobDataManager jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }



    public bool insertJobEntity(JobEntity timerJobEntity) {
        return doInsert(timerJobEntity, true);
    }

    override
    public void insert(JobEntity jobEntity, bool fireCreateEvent) {
        doInsert(jobEntity, fireCreateEvent);
    }

    protected bool doInsert(JobEntity jobEntity, bool fireCreateEvent) {
        if (serviceConfiguration.getInternalJobManager() !is null) {
            bool handledJob = serviceConfiguration.getInternalJobManager().handleJobInsert(jobEntity);
            if (!handledJob) {
                return false;
            }
        }

        jobEntity.setCreateTime(getClock().getCurrentTime());
        super.insert(jobEntity, fireCreateEvent);
        return true;
    }


    public List!Job findJobsByQueryCriteria(JobQueryImpl jobQuery) {
        return dataManager.findJobsByQueryCriteria(jobQuery);
    }


    public long findJobCountByQueryCriteria(JobQueryImpl jobQuery) {
        return dataManager.findJobCountByQueryCriteria(jobQuery);
    }

    override
    public void dele(JobEntity jobEntity) {
        super.dele(jobEntity, false);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        // Send event
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)jobEntity));
        }
    }

    override
    public void dele(JobEntity entity, bool fireDeleteEvent) {
        if (serviceConfiguration.getInternalJobManager() !is null) {
            serviceConfiguration.getInternalJobManager().handleJobDelete(entity);
        }

        super.dele(entity, fireDeleteEvent);
    }

     override
     List!(JobEntity) findJobsToExecute(Page page)
     {
          return super.findJobsToExecute(page);
     }

    override
    List!(JobEntity) findJobsByExecutionId(string executionId)
    {
        return super.findJobsByExecutionId(executionId);
    }

    override
    List!(JobEntity) findJobsByProcessInstanceId(string processInstanceId)
    {
        return super.findJobsByProcessInstanceId(processInstanceId);
    }

    override
     List!(JobEntity) findExpiredJobs(Page page)
     {
        return super.findExpiredJobs(page);
     }

      override
      void resetExpiredJob(string jobId)
      {
          return super.resetExpiredJob(jobId);
      }

      override
      void updateJobTenantIdForDeployment(string deploymentId, string newTenantId)
      {
          return super.updateJobTenantIdForDeployment(deploymentId, newTenantId);
      }
}
