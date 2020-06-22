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
module flow.job.service.impl.persistence.entity.data.impl.MybatisJobDataManager;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;


import flow.common.db.AbstractDataManager;
import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.JobEntityImpl;
import flow.job.service.impl.persistence.entity.data.JobDataManager;
//import flow.job.service.impl.persistence.entity.data.impl.cachematcher.JobsByExecutionIdMatcher;
import hunt.entity;
import flow.common.persistence.entity.data.DataManager;
import flow.common.AbstractEngineConfiguration;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class MybatisJobDataManager : EntityRepository!( JobEntityImpl , string) , JobDataManager {
    import flow.common.Page;
    protected JobServiceConfiguration jobServiceConfiguration;

   // protected CachedEntityMatcher!JobEntity jobsByExecutionIdMatcher = new JobsByExecutionIdMatcher();

    this() {
      super(entityManagerFactory.createEntityManager());
    }

    this(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
        super(entityManagerFactory.createEntityManager());
    }

    //
    //class<? extends JobEntity> getManagedEntityClass() {
    //    return JobEntityImpl.class;
    //}


    public JobEntity create() {
        return new JobEntityImpl();
    }



    public List!JobEntity findJobsToExecute(Page page) {
        implementationMissing(false);
        return null;
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("jobExecutionScope", jobServiceConfiguration.getJobExecutionScope());
        //
        //return getDbSqlSession().selectList("selectJobsToExecute", params, page);
    }


    public List!JobEntity findJobsByExecutionId(final string executionId) {
        implementationMissing(false);
        return null;
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the execution has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    return getListFromCache(jobsByExecutionIdMatcher, executionId);
        //}
        //
        //return getList(dbSqlSession, "selectJobsByExecutionId", executionId, jobsByExecutionIdMatcher, true);
    }



    public List!JobEntity findJobsByProcessInstanceId(final string processInstanceId) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectJobsByProcessInstanceId", processInstanceId);
    }



    public List!JobEntity findExpiredJobs(Page page) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("jobExecutionScope", jobServiceConfiguration.getJobExecutionScope());
        //Date now = jobServiceConfiguration.getClock().getCurrentTime();
        //params.put("now", now);
        //Date maxTimeout = new Date(now.getTime() - jobServiceConfiguration.getAsyncExecutorResetExpiredJobsMaxTimeout());
        //params.put("maxTimeout", maxTimeout);
        //return getDbSqlSession().selectList("selectExpiredJobs", params, page);
    }



    public List!Job findJobsByQueryCriteria(JobQueryImpl jobQuery) {
        implementationMissing(false);
        return null;
        //final string query = "selectJobByQueryCriteria";
        //return getDbSqlSession().selectList(query, jobQuery);
    }


    public long findJobCountByQueryCriteria(JobQueryImpl jobQuery) {
        implementationMissing(false);
        return 0;
       // return (Long) getDbSqlSession().selectOne("selectJobCountByQueryCriteria", jobQuery);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        implementationMissing(false);

        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateJobTenantIdForDeployment", params);
    }


    public void resetExpiredJob(string jobId) {
        implementationMissing(false);
        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("id", jobId);
        //params.put("now", jobServiceConfiguration.getClock().getCurrentTime());
        //getDbSqlSession().update("resetExpiredJob", params);
    }


    public void deleteJobsByExecutionId(string executionId) {
        implementationMissing(false);
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    deleteCachedEntities(dbSqlSession, jobsByExecutionIdMatcher, executionId);
        //} else {
        //    bulkDelete("deleteJobsByExecutionId", jobsByExecutionIdMatcher, executionId);
        //}
    }

}
