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

module flow.job.service.impl.persistence.entity.DeadLetterJobEntityManagerImpl;

import hunt.collection.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.DeadLetterJobQueryImpl;
import flow.job.service.impl.persistence.entity.data.DeadLetterJobDataManager;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntityManager;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
/**
 * @author Tijs Rademakers
 */
class DeadLetterJobEntityManagerImpl
    : AbstractJobServiceEngineEntityManager!(DeadLetterJobEntity, DeadLetterJobDataManager)
    , DeadLetterJobEntityManager {

    this(JobServiceConfiguration jobServiceConfiguration, DeadLetterJobDataManager jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }


    public List!DeadLetterJobEntity findJobsByExecutionId(string id) {
        return dataManager.findJobsByExecutionId(id);
    }


    public List!DeadLetterJobEntity findJobsByProcessInstanceId(string id) {
        return dataManager.findJobsByProcessInstanceId(id);
    }


    public List!Job findJobsByQueryCriteria(DeadLetterJobQueryImpl jobQuery) {
        return dataManager.findJobsByQueryCriteria(jobQuery);
    }


    public long findJobCountByQueryCriteria(DeadLetterJobQueryImpl jobQuery) {
        return dataManager.findJobCountByQueryCriteria(jobQuery);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        dataManager.updateJobTenantIdForDeployment(deploymentId, newTenantId);
    }

    override
    public void insert(DeadLetterJobEntity jobEntity, bool fireCreateEvent) {
        if (getServiceConfiguration().getInternalJobManager() !is null) {
            getServiceConfiguration().getInternalJobManager().handleJobInsert(jobEntity);
        }

        jobEntity.setCreateTime(getServiceConfiguration().getClock().getCurrentTime());
        super.insert(jobEntity, fireCreateEvent);
    }

    override
    public void insert(DeadLetterJobEntity jobEntity) {
        insert(jobEntity, true);
    }

    override
    public void dele(DeadLetterJobEntity jobEntity) {
        super.dele(jobEntity);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        if (getServiceConfiguration().getInternalJobManager() !is null) {
            getServiceConfiguration().getInternalJobManager().handleJobDelete(jobEntity);
        }

        // Send event
        if (getEventDispatcher() !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)jobEntity));
        }
    }

    protected DeadLetterJobEntity createDeadLetterJob(AbstractRuntimeJobEntity job) {
        DeadLetterJobEntity newJobEntity = create();
        newJobEntity.setJobHandlerConfiguration(job.getJobHandlerConfiguration());
        newJobEntity.setCustomValues(job.getCustomValues());
        newJobEntity.setJobHandlerType(job.getJobHandlerType());
        newJobEntity.setExclusive(job.isExclusive());
        newJobEntity.setRepeat(job.getRepeat());
        newJobEntity.setRetries(job.getRetries());
        newJobEntity.setEndDate(job.getEndDate());
        newJobEntity.setExecutionId(job.getExecutionId());
        newJobEntity.setProcessInstanceId(job.getProcessInstanceId());
        newJobEntity.setProcessDefinitionId(job.getProcessDefinitionId());
        newJobEntity.setScopeId(job.getScopeId());
        newJobEntity.setSubScopeId(job.getSubScopeId());
        newJobEntity.setScopeType(job.getScopeType());
        newJobEntity.setScopeDefinitionId(job.getScopeDefinitionId());

        // Inherit tenant
        newJobEntity.setTenantId(job.getTenantId());
        newJobEntity.setJobType(job.getJobType());
        return newJobEntity;
    }

}
