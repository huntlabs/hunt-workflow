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
module flow.job.service.impl.persistence.entity.data.impl.MybatisTimerJobDataManager;

import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;


import flow.common.db.AbstractDataManager;
import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.job.service.api.Job;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.TimerJobQueryImpl;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntityImpl;
import flow.job.service.impl.persistence.entity.data.TimerJobDataManager;
//import flow.job.service.impl.persistence.entity.data.impl.cachematcher.TimerJobsByExecutionIdMatcher;
//import flow.job.service.impl.persistence.entity.data.impl.cachematcher.TimerJobsByScopeIdAndSubScopeIdMatcher;
import hunt.entity;
import flow.common.persistence.entity.data.DataManager;
import flow.common.AbstractEngineConfiguration;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Vasile Dirla
 * @author Joram Barrez
 */
class MybatisTimerJobDataManager : EntityRepository!( TimerJobEntityImpl , string) , TimerJobDataManager {
    import flow.common.Page;

    protected JobServiceConfiguration jobServiceConfiguration;

    //protected CachedEntityMatcher!TimerJobEntity timerJobsByExecutionIdMatcher = new TimerJobsByExecutionIdMatcher();
    //
    //protected CachedEntityMatcher!TimerJobEntity timerJobsByScopeIdAndSubScopeIdMatcher = new TimerJobsByScopeIdAndSubScopeIdMatcher();

    this(JobServiceConfiguration jobServiceConfiguration) {
        this.jobServiceConfiguration = jobServiceConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }

    //@Override
    //class<? extends TimerJobEntity> getManagedEntityClass() {
    //    return TimerJobEntityImpl.class;
    //}


    public TimerJobEntity create() {
        return new TimerJobEntityImpl();
    }



    public List!Job findJobsByQueryCriteria(TimerJobQueryImpl jobQuery) {
        implementationMissing(false);
        return null;
        //string query = "selectTimerJobByQueryCriteria";
        //return getDbSqlSession().selectList(query, jobQuery);
    }


    public long findJobCountByQueryCriteria(TimerJobQueryImpl jobQuery) {
        implementationMissing(false);
        return 0;
        //return (Long) getDbSqlSession().selectOne("selectTimerJobCountByQueryCriteria", jobQuery);
    }



    public List!TimerJobEntity findTimerJobsToExecute(Page page) {
        implementationMissing(false);
        return null;
        //Map!(string, Object) params = new HashMap<>(2);
        //string jobExecutionScope = jobServiceConfiguration.getJobExecutionScope();
        //params.put("jobExecutionScope", jobExecutionScope);
        //
        //Date now = jobServiceConfiguration.getClock().getCurrentTime();
        //params.put("now", now);
        //
        //return getDbSqlSession().selectList("selectTimerJobsToExecute", params, page);
    }



    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionId(string jobHandlerType, string processDefinitionId) {
        //Map!(string, string) params = new HashMap<>(2);
        //params.put("handlerType", jobHandlerType);
        //params.put("processDefinitionId", processDefinitionId);
        //return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionId", params);
        implementationMissing(false);
        return null;
    }


    public List!TimerJobEntity findJobsByExecutionId( string executionId) {
        implementationMissing(false);
        return null;
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the execution has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    return getListFromCache(timerJobsByExecutionIdMatcher, executionId);
        //}
        //
        //return getList(dbSqlSession, "selectTimerJobsByExecutionId", executionId, timerJobsByExecutionIdMatcher, true);
    }



    public List!TimerJobEntity findJobsByProcessInstanceId( string processInstanceId) {
        implementationMissing(false);
        return null;
        //return getDbSqlSession().selectList("selectTimerJobsByProcessInstanceId", processInstanceId);
    }


    public List!TimerJobEntity findJobsByScopeIdAndSubScopeId(string scopeId, string subScopeId) {
        implementationMissing(false);
        return null;
        //Map!(string, string) paramMap = new HashMap<>();
        //paramMap.put("scopeId", scopeId);
        //paramMap.put("subScopeId", subScopeId);
        //return getList(getDbSqlSession(), "selectTimerJobsByScopeIdAndSubScopeId", paramMap, timerJobsByScopeIdAndSubScopeIdMatcher, true);
    }



    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyNoTenantId(string jobHandlerType, string processDefinitionKey) {
        implementationMissing(false);
        return null;
        //Map!(string, string) params = new HashMap<>(2);
        //params.put("handlerType", jobHandlerType);
        //params.put("processDefinitionKey", processDefinitionKey);
        //return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionKeyNoTenantId", params);
    }



    public List!TimerJobEntity findJobsByTypeAndProcessDefinitionKeyAndTenantId(string jobHandlerType, string processDefinitionKey, string tenantId) {
        implementationMissing(false);
        return null;
        //Map!(string, string) params = new HashMap<>(3);
        //params.put("handlerType", jobHandlerType);
        //params.put("processDefinitionKey", processDefinitionKey);
        //params.put("tenantId", tenantId);
        //return getDbSqlSession().selectList("selectTimerJobByTypeAndProcessDefinitionKeyAndTenantId", params);
    }


    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
        implementationMissing(false);
        //HashMap!(string, Object) params = new HashMap<>();
        //params.put("deploymentId", deploymentId);
        //params.put("tenantId", newTenantId);
        //getDbSqlSession().update("updateTimerJobTenantIdForDeployment", params);
    }

}
