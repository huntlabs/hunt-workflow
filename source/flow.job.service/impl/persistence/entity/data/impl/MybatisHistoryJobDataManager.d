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
module flow.job.service.impl.persistence.entity.data.impl.MybatisHistoryJobDataManager;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;


import flow.common.db.AbstractDataManager;
import flow.common.db.ListQueryParameterObject;
import flow.job.service.api.HistoryJob;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.HistoryJobQueryImpl;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.job.service.impl.persistence.entity.HistoryJobEntityImpl;
import flow.job.service.impl.persistence.entity.data.HistoryJobDataManager;
import hunt.entity;
import flow.common.persistence.entity.data.DataManager;
import flow.common.AbstractEngineConfiguration;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class MybatisHistoryJobDataManager : EntityRepository!( HistoryJobEntityImpl , string)  , HistoryJobDataManager {
    import flow.common.Page;
    protected JobServiceConfiguration jobServiceConfiguration;

    alias insert = CrudRepository!( HistoryJobEntityImpl , string).insert;
    alias update = CrudRepository!( HistoryJobEntityImpl , string).update;
    this() {
      super(entityManagerFactory.currentEntityManager());
    }

    this(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //
    //class<? extends HistoryJobEntity> getManagedEntityClass() {
    //    return HistoryJobEntityImpl.class;
    //}


    public HistoryJobEntity create() {
        return new HistoryJobEntityImpl();
    }

    public void insert(HistoryJobEntity entity) {
      insert(cast(HistoryJobEntityImpl)entity);
      //getDbSqlSession().insert(entity);
    }
    //
    //@Override
    public HistoryJobEntity update(HistoryJobEntity entity) {
      return  update(cast(HistoryJobEntityImpl)entity);
      //getDbSqlSession().update(entity);
      //return entity;
    }

    public void dele(HistoryJobEntity entity) {
      if (entity !is null)
      {
        remove(cast(HistoryJobEntityImpl)entity);
      }
      //getDbSqlSession().delete(entity);
    }

    //
    //@Override
    public void dele(string id) {
      HistoryJobEntity entity = findById(id);
      if (entity !is null)
      {
        remove(cast(HistoryJobEntityImpl)entity);
      }
      //delete(entity);
    }

    public List!HistoryJobEntity findJobsToExecute(Page page) {
        implementationMissing(false);
        return null;
        //ListQueryParameterObject params = new ListQueryParameterObject();
        //params.setParameter(jobServiceConfiguration.getHistoryJobExecutionScope());
        //
        //// Needed for db2/sqlserver (see limitBetween in mssql.properties), otherwise ordering will be incorrect
        //params.setFirstResult(page.getFirstResult());
        //params.setMaxResults(page.getMaxResults());
        //params.setOrderByColumns("CREATE_TIME_ ASC");
        //return getDbSqlSession().selectList("selectHistoryJobsToExecute", params);
    }


    public List!HistoryJobEntity findJobsByExecutionId( string executionId) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectHistoryJobsByExecutionId", executionId);
    }



    public List!HistoryJobEntity findJobsByProcessInstanceId( string processInstanceId) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectHistoryJobsByProcessInstanceId", processInstanceId);
    }



    public List!HistoryJobEntity findExpiredJobs(Page page) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>();
        //params.put("jobExecutionScope", jobServiceConfiguration.getHistoryJobExecutionScope());
        //Date now = jobServiceConfiguration.getClock().getCurrentTime();
        //params.put("now", now);
        //Date maxTimeout = new Date(now.getTime() - jobServiceConfiguration.getAsyncExecutorResetExpiredJobsMaxTimeout());
        //params.put("maxTimeout", maxTimeout);
        //return getDbSqlSession().selectList("selectExpiredHistoryJobs", params, page);
    }



    public List!HistoryJob findHistoryJobsByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        implementationMissing(false);
        return null;
        //final string query = "selectHistoryJobByQueryCriteria";
        //return getDbSqlSession().selectList(query, jobQuery);
    }


    public long findHistoryJobCountByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectHistoryJobCountByQueryCriteria", jobQuery);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        implementationMissing(false);

        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateHistoryJobTenantIdForDeployment", params);
    }


    public void resetExpiredJob(string jobId) {
        implementationMissing(false);

        //Map!(string, Object) params = new HashMap<>(2);
        //params.put("id", jobId);
        //getDbSqlSession().update("resetExpiredHistoryJob", params);
    }

}
