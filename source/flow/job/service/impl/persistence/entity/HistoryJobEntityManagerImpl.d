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

module flow.job.service.impl.persistence.entity.HistoryJobEntityManagerImpl;

import flow.common.Page;
import hunt.collection.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.job.service.api.HistoryJob;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.HistoryJobQueryImpl;
import flow.job.service.impl.persistence.entity.data.HistoryJobDataManager;
import flow.job.service.impl.persistence.entity.JobInfoEntityManagerImpl;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntityManager;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class HistoryJobEntityManagerImpl
    : JobInfoEntityManagerImpl!(HistoryJobEntity, HistoryJobDataManager)
    , HistoryJobEntityManager {


    this(JobServiceConfiguration jobServiceConfiguration, HistoryJobDataManager historyJobDataManager) {
        super(jobServiceConfiguration, historyJobDataManager);
    }


    public List!HistoryJob findHistoryJobsByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        return dataManager.findHistoryJobsByQueryCriteria(jobQuery);
    }


    public long findHistoryJobCountByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        return dataManager.findHistoryJobCountByQueryCriteria(jobQuery);
    }

    override
    public void dele(HistoryJobEntity jobEntity) {
        super.dele(jobEntity, false);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getAdvancedJobHandlerConfigurationByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        // Send event
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && getEventDispatcher().isEnabled()) {
            getEventDispatcher().dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)jobEntity));
        }
    }


    public void deleteNoCascade(HistoryJobEntity historyJobEntity) {
        super.dele(historyJobEntity);
    }


     override
     List!(HistoryJobEntity) findJobsToExecute(Page page)
     {
          return super.findJobsToExecute(page);
     }

    override
    List!(HistoryJobEntity) findJobsByExecutionId(string executionId)
    {
        return super.findJobsByExecutionId(executionId);
    }

    override
   List!(HistoryJobEntity) findJobsByProcessInstanceId(string processInstanceId)
   {
        return super.findJobsByProcessInstanceId(processInstanceId);
   }

    override
    List!(HistoryJobEntity) findExpiredJobs(Page page)
    {
        return super.findExpiredJobs(page);
    }

    override
     void resetExpiredJob(string jobId)
     {
          super.resetExpiredJob(jobId);
     }

    override
    void updateJobTenantIdForDeployment(string deploymentId, string newTenantId)
    {
          super.updateJobTenantIdForDeployment(deploymentId,newTenantId);
    }

}
