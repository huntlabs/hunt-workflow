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


import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.DbSqlSession;
import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.impl.ActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
import flow.engine.impl.persistence.entity.ActivityInstanceEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ActivityInstanceDataManager;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ActivityInstanceMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.UnfinishedActivityInstanceMatcher;
import flow.engine.runtime.ActivityInstance;

/**
 * @author martin.grofcik
 */
class MybatisActivityInstanceDataManager extends AbstractProcessDataManager<ActivityInstanceEntity> implements ActivityInstanceDataManager {

    protected CachedEntityMatcher<ActivityInstanceEntity> unfinishedActivityInstanceMatcher = new UnfinishedActivityInstanceMatcher();
    protected CachedEntityMatcher<ActivityInstanceEntity> activityInstanceMatcher = new ActivityInstanceMatcher();
    protected CachedEntityMatcher<ActivityInstanceEntity> activitiesByProcessInstanceIdMatcher = new ActivityByProcessInstanceIdMatcher();

    public MybatisActivityInstanceDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends ActivityInstanceEntity> getManagedEntityClass() {
        return ActivityInstanceEntityImpl.class;
    }

    @Override
    public ActivityInstanceEntity create() {
        return new ActivityInstanceEntityImpl();
    }

    @Override
    public List<ActivityInstanceEntity> findUnfinishedActivityInstancesByExecutionAndActivityId(final string executionId, final string activityId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("executionId", executionId);
        params.put("activityId", activityId);
        return getList("selectUnfinishedActivityInstanceExecutionIdAndActivityId", params, unfinishedActivityInstanceMatcher, true);
    }

    @Override
    public List<ActivityInstanceEntity> findActivityInstancesByExecutionIdAndActivityId(final string executionId, final string activityId) {
        Map!(string, Object) params = new HashMap<>();
        params.put("executionId", executionId);
        params.put("activityId", activityId);
        return getList("selectActivityInstanceExecutionIdAndActivityId", params, activityInstanceMatcher, true);
    }

    @Override
    public void deleteActivityInstancesByProcessInstanceId(string processInstanceId) {
        DbSqlSession dbSqlSession = getDbSqlSession();
        deleteCachedEntities(dbSqlSession, activitiesByProcessInstanceIdMatcher, processInstanceId);
        if (!isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
            dbSqlSession.delete("deleteActivityInstancesByProcessInstanceId", processInstanceId, ActivityInstanceEntityImpl.class);
        }
    }

    @Override
    public long findActivityInstanceCountByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery) {
        return (Long) getDbSqlSession().selectOne("selectActivityInstanceCountByQueryCriteria", activityInstanceQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ActivityInstance> findActivityInstancesByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery) {
        return getDbSqlSession().selectList("selectActivityInstancesByQueryCriteria", activityInstanceQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ActivityInstance> findActivityInstancesByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectActivityInstanceByNativeQuery", parameterMap);
    }

    @Override
    public long findActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectActivityInstanceCountByNativeQuery", parameterMap);
    }

}
