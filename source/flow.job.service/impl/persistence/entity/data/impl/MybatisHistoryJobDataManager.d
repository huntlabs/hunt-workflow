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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.Page;
import flow.common.db.AbstractDataManager;
import flow.common.db.ListQueryParameterObject;
import org.flowable.job.api.HistoryJob;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.HistoryJobQueryImpl;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntityImpl;
import org.flowable.job.service.impl.persistence.entity.data.HistoryJobDataManager;

/**
 * @author Tijs Rademakers
 */
class MybatisHistoryJobDataManager extends AbstractDataManager<HistoryJobEntity> implements HistoryJobDataManager {

    protected JobServiceConfiguration jobServiceConfiguration;
    
    public MybatisHistoryJobDataManager() {
        
    }
    
    public MybatisHistoryJobDataManager(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }

    @Override
    class<? extends HistoryJobEntity> getManagedEntityClass() {
        return HistoryJobEntityImpl.class;
    }

    @Override
    public HistoryJobEntity create() {
        return new HistoryJobEntityImpl();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoryJobEntity> findJobsToExecute(Page page) {
        
        ListQueryParameterObject params = new ListQueryParameterObject();
        params.setParameter(jobServiceConfiguration.getHistoryJobExecutionScope());
        
        // Needed for db2/sqlserver (see limitBetween in mssql.properties), otherwise ordering will be incorrect
        params.setFirstResult(page.getFirstResult());
        params.setMaxResults(page.getMaxResults());
        params.setOrderByColumns("CREATE_TIME_ ASC");
        return getDbSqlSession().selectList("selectHistoryJobsToExecute", params);
    }

    @Override
    public List<HistoryJobEntity> findJobsByExecutionId(final string executionId) {
        return getDbSqlSession().selectList("selectHistoryJobsByExecutionId", executionId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoryJobEntity> findJobsByProcessInstanceId(final string processInstanceId) {
        return getDbSqlSession().selectList("selectHistoryJobsByProcessInstanceId", processInstanceId);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoryJobEntity> findExpiredJobs(Page page) {
        Map<string, Object> params = new HashMap<>();
        params.put("jobExecutionScope", jobServiceConfiguration.getHistoryJobExecutionScope());
        Date now = jobServiceConfiguration.getClock().getCurrentTime();
        params.put("now", now);
        Date maxTimeout = new Date(now.getTime() - jobServiceConfiguration.getAsyncExecutorResetExpiredJobsMaxTimeout());
        params.put("maxTimeout", maxTimeout);
        return getDbSqlSession().selectList("selectExpiredHistoryJobs", params, page);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HistoryJob> findHistoryJobsByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        final string query = "selectHistoryJobByQueryCriteria";
        return getDbSqlSession().selectList(query, jobQuery);
    }

    @Override
    public long findHistoryJobCountByQueryCriteria(HistoryJobQueryImpl jobQuery) {
        return (Long) getDbSqlSession().selectOne("selectHistoryJobCountByQueryCriteria", jobQuery);
    }

    @Override
    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap<string, Object> params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateHistoryJobTenantIdForDeployment", params);
    }

    @Override
    public void resetExpiredJob(string jobId) {
        Map<string, Object> params = new HashMap<>(2);
        params.put("id", jobId);
        getDbSqlSession().update("resetExpiredHistoryJob", params);
    }

}
