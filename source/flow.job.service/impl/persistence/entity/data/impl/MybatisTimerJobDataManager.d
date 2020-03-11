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
import org.flowable.job.service.impl.TimerJobQueryImpl;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntityImpl;
import org.flowable.job.service.impl.persistence.entity.data.TimerJobDataManager;
import org.flowable.job.service.impl.persistence.entity.data.impl.cachematcher.TimerJobsByExecutionIdMatcher;
import org.flowable.job.service.impl.persistence.entity.data.impl.cachematcher.TimerJobsByScopeIdAndSubScopeIdMatcher;

/**
 * @author Tijs Rademakers
 * @author Vasile Dirla
 * @author Joram Barrez
 */
class MybatisTimerJobDataManager extends AbstractDataManager<TimerJobEntity> implements TimerJobDataManager {

    protected JobServiceConfiguration jobServiceConfiguration;

    protected CachedEntityMatcher<TimerJobEntity> timerJobsByExecutionIdMatcher = new TimerJobsByExecutionIdMatcher();

    protected CachedEntityMatcher<TimerJobEntity> timerJobsByScopeIdAndSubScopeIdMatcher = new TimerJobsByScopeIdAndSubScopeIdMatcher();

    public MybatisTimerJobDataManager(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
    }

    @Override
    class<? extends TimerJobEntity> getManagedEntityClass() {
        return TimerJobEntityImpl.class;
    }

    @Override
    public TimerJobEntity create() {
        return new TimerJobEntityImpl();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Job> findJobsByQueryCriteria(TimerJobQueryImpl jobQuery) {
        string query = "selectTimerJobByQueryCriteria";
        return getDbSqlSession().selectList(query, jobQuery);
    }

    @Override
    public long findJobCountByQueryCriteria(TimerJobQueryImpl jobQuery) {
        return (Long) getDbSqlSession().selectOne("selectTimerJobCountByQueryCriteria", jobQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TimerJobEntity> findTimerJobsToExecute(Page page) {
        Map!(string, Object) params = new HashMap<>(2);
        string jobExecutionScope = jobServiceConfiguration.getJobExecutionScope();
        params.put("jobExecutionScope", jobExecutionScope);

        Date now = jobServiceConfiguration.getClock().getCurrentTime();
        params.put("now", now);

        return getDbSqlSession().selectList("selectTimerJobsToExecute", params, page);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionId(string jobHandlerType, string processDefinitionId) {
        Map!(string, string) params = new HashMap<>(2);
        params.put("handlerType", jobHandlerType);
        params.put("processDefinitionId", processDefinitionId);
        return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionId", params);

    }

    @Override
    public List<TimerJobEntity> findJobsByExecutionId(final string executionId) {
        DbSqlSession dbSqlSession = getDbSqlSession();

        // If the execution has been inserted in the same command execution as this query, there can't be any in the database
        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
            return getListFromCache(timerJobsByExecutionIdMatcher, executionId);
        }

        return getList(dbSqlSession, "selectTimerJobsByExecutionId", executionId, timerJobsByExecutionIdMatcher, true);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TimerJobEntity> findJobsByProcessInstanceId(final string processInstanceId) {
        return getDbSqlSession().selectList("selectTimerJobsByProcessInstanceId", processInstanceId);
    }

    @Override
    public List<TimerJobEntity> findJobsByScopeIdAndSubScopeId(string scopeId, string subScopeId) {
        Map!(string, string) paramMap = new HashMap<>();
        paramMap.put("scopeId", scopeId);
        paramMap.put("subScopeId", subScopeId);
        return getList(getDbSqlSession(), "selectTimerJobsByScopeIdAndSubScopeId", paramMap, timerJobsByScopeIdAndSubScopeIdMatcher, true);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionKeyNoTenantId(string jobHandlerType, string processDefinitionKey) {
        Map!(string, string) params = new HashMap<>(2);
        params.put("handlerType", jobHandlerType);
        params.put("processDefinitionKey", processDefinitionKey);
        return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionKeyNoTenantId", params);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TimerJobEntity> findJobsByTypeAndProcessDefinitionKeyAndTenantId(string jobHandlerType, string processDefinitionKey, string tenantId) {
        Map!(string, string) params = new HashMap<>(3);
        params.put("handlerType", jobHandlerType);
        params.put("processDefinitionKey", processDefinitionKey);
        params.put("tenantId", tenantId);
        return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionKeyAndTenantId", params);
    }

    @Override
    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateTimerJobTenantIdForDeployment", params);
    }

}
