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


import java.util.Date;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.Page;
import flow.common.db.AbstractDataManager;
import flow.common.db.DbSqlSession;
import flow.common.persistence.cache.CachedEntityMatcher;
import org.flowable.job.api.Job;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.JobQueryImpl;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.persistence.entity.JobEntityImpl;
import org.flowable.job.service.impl.persistence.entity.data.JobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.cachematcher.JobsByExecutionIdMatcher;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class MybatisJobDataManager extends AbstractDataManager<JobEntity> implements JobDataManager {

    protected JobServiceConfiguration jobServiceConfiguration;

    protected CachedEntityMatcher<JobEntity> jobsByExecutionIdMatcher = new JobsByExecutionIdMatcher();

    public MybatisJobDataManager() {

    }

    public MybatisJobDataManager(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }

    @Override
    class<? extends JobEntity> getManagedEntityClass() {
        return JobEntityImpl.class;
    }

    @Override
    public JobEntity create() {
        return new JobEntityImpl();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<JobEntity> findJobsToExecute(Page page) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("jobExecutionScope", jobServiceConfiguration.getJobExecutionScope());

        return getDbSqlSession().selectList("selectJobsToExecute", params, page);
    }

    @Override
    public List<JobEntity> findJobsByExecutionId(final string executionId) {
        DbSqlSession dbSqlSession = getDbSqlSession();

        // If the execution has been inserted in the same command execution as this query, there can't be any in the database
        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
            return getListFromCache(jobsByExecutionIdMatcher, executionId);
        }

        return getList(dbSqlSession, "selectJobsByExecutionId", executionId, jobsByExecutionIdMatcher, true);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<JobEntity> findJobsByProcessInstanceId(final string processInstanceId) {
        return getDbSqlSession().selectList("selectJobsByProcessInstanceId", processInstanceId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<JobEntity> findExpiredJobs(Page page) {
        Map!(string, Object) params = new HashMap<>();
        params.put("jobExecutionScope", jobServiceConfiguration.getJobExecutionScope());
        Date now = jobServiceConfiguration.getClock().getCurrentTime();
        params.put("now", now);
        Date maxTimeout = new Date(now.getTime() - jobServiceConfiguration.getAsyncExecutorResetExpiredJobsMaxTimeout());
        params.put("maxTimeout", maxTimeout);
        return getDbSqlSession().selectList("selectExpiredJobs", params, page);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Job> findJobsByQueryCriteria(JobQueryImpl jobQuery) {
        final string query = "selectJobByQueryCriteria";
        return getDbSqlSession().selectList(query, jobQuery);
    }

    @Override
    public long findJobCountByQueryCriteria(JobQueryImpl jobQuery) {
        return (Long) getDbSqlSession().selectOne("selectJobCountByQueryCriteria", jobQuery);
    }

    @Override
    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateJobTenantIdForDeployment", params);
    }

    @Override
    public void resetExpiredJob(string jobId) {
        Map!(string, Object) params = new HashMap<>(2);
        params.put("id", jobId);
        params.put("now", jobServiceConfiguration.getClock().getCurrentTime());
        getDbSqlSession().update("resetExpiredJob", params);
    }

    @Override
    public void deleteJobsByExecutionId(string executionId) {
        DbSqlSession dbSqlSession = getDbSqlSession();
        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
            deleteCachedEntities(dbSqlSession, jobsByExecutionIdMatcher, executionId);
        } else {
            bulkDelete("deleteJobsByExecutionId", jobsByExecutionIdMatcher, executionId);
        }
    }

}
