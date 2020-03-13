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

module flow.job.service.impl.persistence.entity.SuspendedJobEntityManagerImpl;

import hunt.collection.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.SuspendedJobQueryImpl;
import flow.job.service.impl.persistence.entity.data.SuspendedJobDataManager;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;
import flow.job.service.impl.persistence.entity.SuspendedJobEntityManager;

/**
 * @author Tijs Rademakers
 */
class SuspendedJobEntityManagerImpl
    : AbstractJobServiceEngineEntityManager!(SuspendedJobEntity, SuspendedJobDataManager)
    ,SuspendedJobEntityManager {

    this(JobServiceConfiguration jobServiceConfiguration, SuspendedJobDataManager jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }


    public List!SuspendedJobEntity findJobsByExecutionId(string id) {
        return dataManager.findJobsByExecutionId(id);
    }


    public List!SuspendedJobEntity findJobsByProcessInstanceId(string id) {
        return dataManager.findJobsByProcessInstanceId(id);
    }


    public List!Job findJobsByQueryCriteria(SuspendedJobQueryImpl jobQuery) {
        return dataManager.findJobsByQueryCriteria(jobQuery);
    }


    public long findJobCountByQueryCriteria(SuspendedJobQueryImpl jobQuery) {
        return dataManager.findJobCountByQueryCriteria(jobQuery);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }


    public void insert(SuspendedJobEntity jobEntity, bool fireCreateEvent) {
        if (serviceConfiguration.getInternalJobManager() !is null) {
            serviceConfiguration.getInternalJobManager().handleJobInsert(jobEntity);
        }

        jobEntity.setCreateTime(getClock().getCurrentTime());
        super.insert(jobEntity, fireCreateEvent);
    }


    public void insert(SuspendedJobEntity jobEntity) {
        insert(jobEntity, true);
    }


    public void dele(SuspendedJobEntity jobEntity) {
        super.dele(jobEntity, false);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        if (serviceConfiguration.getInternalJobManager() !is null) {
            serviceConfiguration.getInternalJobManager().handleJobDelete(jobEntity);
        }

        // Send event
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, jobEntity));
        }
    }

    protected SuspendedJobEntity createSuspendedJob(AbstractRuntimeJobEntity job) {
        SuspendedJobEntity newSuspendedJobEntity = create();
        newSuspendedJobEntity.setJobHandlerConfiguration(job.getJobHandlerConfiguration());
        newSuspendedJobEntity.setCustomValues(job.getCustomValues());
        newSuspendedJobEntity.setJobHandlerType(job.getJobHandlerType());
        newSuspendedJobEntity.setExclusive(job.isExclusive());
        newSuspendedJobEntity.setRepeat(job.getRepeat());
        newSuspendedJobEntity.setRetries(job.getRetries());
        newSuspendedJobEntity.setEndDate(job.getEndDate());
        newSuspendedJobEntity.setExecutionId(job.getExecutionId());
        newSuspendedJobEntity.setProcessInstanceId(job.getProcessInstanceId());
        newSuspendedJobEntity.setProcessDefinitionId(job.getProcessDefinitionId());
        newSuspendedJobEntity.setScopeId(job.getScopeId());
        newSuspendedJobEntity.setSubScopeId(job.getSubScopeId());
        newSuspendedJobEntity.setScopeType(job.getScopeType());
        newSuspendedJobEntity.setScopeDefinitionId(job.getScopeDefinitionId());

        // Inherit tenant
        newSuspendedJobEntity.setTenantId(job.getTenantId());
        newSuspendedJobEntity.setJobType(job.getJobType());
        return newSuspendedJobEntity;
    }

}
