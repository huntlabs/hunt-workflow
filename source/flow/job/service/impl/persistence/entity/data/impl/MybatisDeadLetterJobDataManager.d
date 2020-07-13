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
//
//
//import hunt.collection.HashMap;
//import hunt.collection.List;
//
//import flow.common.db.AbstractDataManager;
//import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
//import flow.job.service.api.Job;
//import flow.job.service.impl.DeadLetterJobQueryImpl;
//import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
//import flow.job.service.impl.persistence.entity.DeadLetterJobEntityImpl;
//import flow.job.service.impl.persistence.entity.data.DeadLetterJobDataManager;
//import flow.job.service.impl.persistence.entity.data.impl.cachematcher.DeadLetterJobsByExecutionIdMatcher;
//
///**
// * @author Tijs Rademakers
// */
//class MybatisDeadLetterJobDataManager extends AbstractDataManager<DeadLetterJobEntity> implements DeadLetterJobDataManager {
//
//    protected CachedEntityMatcher<DeadLetterJobEntity> deadLetterByExecutionIdMatcher = new DeadLetterJobsByExecutionIdMatcher();
//
//    @Override
//    class<? extends DeadLetterJobEntity> getManagedEntityClass() {
//        return DeadLetterJobEntityImpl.class;
//    }
//
//    @Override
//    public DeadLetterJobEntity create() {
//        return new DeadLetterJobEntityImpl();
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<Job> findJobsByQueryCriteria(DeadLetterJobQueryImpl jobQuery) {
//        string query = "selectDeadLetterJobByQueryCriteria";
//        return getDbSqlSession().selectList(query, jobQuery);
//    }
//
//    @Override
//    public long findJobCountByQueryCriteria(DeadLetterJobQueryImpl jobQuery) {
//        return (Long) getDbSqlSession().selectOne("selectDeadLetterJobCountByQueryCriteria", jobQuery);
//    }
//
//    @Override
//    public List<DeadLetterJobEntity> findJobsByExecutionId(string executionId) {
//        DbSqlSession dbSqlSession = getDbSqlSession();
//
//        // If the execution has been inserted in the same command execution as this query, there can't be any in the database
//        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
//            return getListFromCache(deadLetterByExecutionIdMatcher, executionId);
//        }
//
//        return getList(dbSqlSession, "selectDeadLetterJobsByExecutionId", executionId, deadLetterByExecutionIdMatcher, true);
//    }
//
//    @Override
//    @SuppressWarnings("unchecked")
//    public List<DeadLetterJobEntity> findJobsByProcessInstanceId(final string processInstanceId) {
//        return getDbSqlSession().selectList("selectDeadLetterJobsByProcessInstanceId", processInstanceId);
//    }
//
//    @Override
//    public void updateJobTenantIdForDeployment(string deploymentId, string newTenantId) {
//        HashMap!(string, Object) params = new HashMap<>();
//        params.put("deploymentId", deploymentId);
//        params.put("tenantId", newTenantId);
//        getDbSqlSession().update("updateDeadLetterJobTenantIdForDeployment", params);
//    }
//
//}
