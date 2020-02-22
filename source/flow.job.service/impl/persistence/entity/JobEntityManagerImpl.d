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



import java.util.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import org.flowable.job.api.Job;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.event.impl.FlowableJobEventBuilder;
import org.flowable.job.service.impl.JobQueryImpl;
import org.flowable.job.service.impl.persistence.entity.data.JobDataManager;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class JobEntityManagerImpl
    extends JobInfoEntityManagerImpl<JobEntity, JobDataManager>
    implements JobEntityManager {

    public JobEntityManagerImpl(JobServiceConfiguration jobServiceConfiguration, JobDataManager jobDataManager) {
        super(jobServiceConfiguration, jobDataManager);
    }

    @Override
    public bool insertJobEntity(JobEntity timerJobEntity) {
        return doInsert(timerJobEntity, true);
    }

    @Override
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

    @Override
    public List<Job> findJobsByQueryCriteria(JobQueryImpl jobQuery) {
        return dataManager.findJobsByQueryCriteria(jobQuery);
    }

    @Override
    public long findJobCountByQueryCriteria(JobQueryImpl jobQuery) {
        return dataManager.findJobCountByQueryCriteria(jobQuery);
    }

    @Override
    public void delete(JobEntity jobEntity) {
        super.delete(jobEntity, false);

        deleteByteArrayRef(jobEntity.getExceptionByteArrayRef());
        deleteByteArrayRef(jobEntity.getCustomValuesByteArrayRef());

        // Send event
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, jobEntity));
        }
    }

    @Override
    public void delete(JobEntity entity, bool fireDeleteEvent) {
        if (serviceConfiguration.getInternalJobManager() !is null) {
            serviceConfiguration.getInternalJobManager().handleJobDelete(entity);
        }
        
        super.delete(entity, fireDeleteEvent);
    }

}