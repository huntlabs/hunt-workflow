///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//module flow.job.service.impl.persistence.entity.data.impl.MybatisSuspendedJobDataManager;
//
//import hunt.collection.HashMap;
//import hunt.collection.List;
//
//import flow.common.db.AbstractDataManager;
//import flow.common.db.DbSqlSession;
////import flow.common.persistence.cache.CachedEntityMatcher;
//import flow.job.service.api.Job;
//import flow.job.service.impl.SuspendedJobQueryImpl;
//import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
//import flow.job.service.impl.persistence.entity.SuspendedJobEntityImpl;
//import flow.job.service.impl.persistence.entity.data.SuspendedJobDataManager;
////import flow.job.service.impl.persistence.entity.data.impl.cachematcher.SuspendedJobsByExecutionIdMatcher;
//import hunt.entity;
//import flow.common.persistence.entity.data.DataManager;
//import flow.common.AbstractEngineConfiguration;
//import hunt.Exceptions;
///**
// * @author Tijs Rademakers
// */
//class MybatisSuspendedJobDataManager : EntityRepository!( SuspendedJobEntityImpl , string) , SuspendedJobDataManager {
//
//    protected CachedEntityMatcher<SuspendedJobEntity> suspendedJobsByExecutionIdMatcher = new SuspendedJobsByExecutionIdMatcher();
//
//    @Override
//    class<? extends SuspendedJobEntity> getManagedEntityClass() {
//        return SuspendedJobEntityImpl.class;
//    }
//
//    @Override
//    public SuspendedJobEntity create() {
//        return new SuspendedJobEntityImpl();
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<Job> findJobsByQueryCriteria(SuspendedJobQueryImpl jobQuery) {
//        string query = "selectSuspendedJobByQueryCriteria";
//        return getDbSqlSession().selectList(query, jobQuery);
//    }
//
//    @Override
//    public long findJobCountByQueryCriteria(SuspendedJobQueryImpl jobQuery) {
//        return (Long) getDbSqlSession().selectOne("selectSuspendedJobCountByQueryCriteria", jobQuery);
//    }
//
//    @Override
//    public List<SuspendedJobEntity> findJobsByExecutionId(string executionId) {
//        DbSqlSession dbSqlSession = getDbSqlSession();
//
//        // If the execution has been inserted in the same command execution as this query, there can't be any in the database
//        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
//            return getListFromCache(suspendedJobsByExecutionIdMatcher, executionId);
//        }
//
//        return getList(dbSqlSession, "selectSuspendedJobsByExecutionId", executionId, suspendedJobsByExecutionIdMatcher, true);
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<SuspendedJobEntity> findJobsByProcessInstanceId(final string processInstanceId) {
//        return getDbSqlSession().selectList("selectSuspendedJobsByProcessInstanceId", processInstanceId);
//    }
//
//    @Override
//    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
//        HashMap!(string, Object) params = new HashMap<>();
//        params.put("deploymentId", deploymentId);
//        params.put("tenantId", newTenantId);
//        getDbSqlSession().update("updateSuspendedJobTenantIdForDeployment", params);
//    }
//
//}
