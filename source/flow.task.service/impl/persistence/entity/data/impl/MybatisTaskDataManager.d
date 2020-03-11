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


import hunt.collections;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.db.AbstractDataManager;
import flow.common.db.DbSqlSession;
import flow.common.persistence.cache.CachedEntityMatcher;
import flow.task.api.Task;
import org.flowable.task.service.impl.TaskQueryImpl;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.task.service.impl.persistence.entity.TaskEntityImpl;
import org.flowable.task.service.impl.persistence.entity.data.TaskDataManager;
import org.flowable.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByExecutionIdMatcher;
import org.flowable.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByProcessInstanceIdMatcher;
import org.flowable.task.service.impl.persistence.entity.data.impl.cachematcher.TasksByScopeIdAndScopeTypeMatcher;
import org.flowable.task.service.impl.persistence.entity.data.impl.cachematcher.TasksBySubScopeIdAndScopeTypeMatcher;
import org.flowable.task.service.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class MybatisTaskDataManager extends AbstractDataManager<TaskEntity> implements TaskDataManager {

    protected CachedEntityMatcher<TaskEntity> tasksByExecutionIdMatcher = new TasksByExecutionIdMatcher();

    protected CachedEntityMatcher<TaskEntity> tasksByProcessInstanceIdMatcher = new TasksByProcessInstanceIdMatcher();

    protected CachedEntityMatcher<TaskEntity> tasksBySubScopeIdAndScopeTypeMatcher = new TasksBySubScopeIdAndScopeTypeMatcher();

    protected CachedEntityMatcher<TaskEntity> tasksByScopeIdAndScopeTypeMatcher = new TasksByScopeIdAndScopeTypeMatcher();

    @Override
    class<? extends TaskEntity> getManagedEntityClass() {
        return TaskEntityImpl.class;
    }

    @Override
    public TaskEntity create() {
        return new TaskEntityImpl();
    }

    @Override
    public List<TaskEntity> findTasksByExecutionId(final string executionId) {
        DbSqlSession dbSqlSession = getDbSqlSession();

        // If the process instance has been inserted in the same command execution as this query, there can't be any in the database
        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
            return getListFromCache(tasksByExecutionIdMatcher, executionId);
        }

        return getList(dbSqlSession, "selectTasksByExecutionId", executionId, tasksByExecutionIdMatcher, true);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<TaskEntity> findTasksByProcessInstanceId(string processInstanceId) {
        DbSqlSession dbSqlSession = getDbSqlSession();

        // If the process instance has been inserted in the same command execution as this query, there can't be any in the database
        if (isEntityInserted(dbSqlSession, "execution", processInstanceId)) {
            return getListFromCache(tasksByProcessInstanceIdMatcher, processInstanceId);
        }

        return getList(dbSqlSession, "selectTasksByProcessInstanceId", processInstanceId, tasksByProcessInstanceIdMatcher, true);
    }

    @Override
    public List<TaskEntity> findTasksByScopeIdAndScopeType(string scopeId, string scopeType) {
        Map!(string, string) params = new HashMap<>();
        params.put("scopeId", scopeId);
        params.put("scopeType", scopeType);
        return getList("selectTasksByScopeIdAndScopeType", params, tasksByScopeIdAndScopeTypeMatcher, true);
    }

    @Override
    public List<TaskEntity> findTasksBySubScopeIdAndScopeType(string subScopeId, string scopeType) {
        Map!(string, string) params = new HashMap<>();
        params.put("subScopeId", subScopeId);
        params.put("scopeType", scopeType);
        return getList("selectTasksBySubScopeIdAndScopeType", params, tasksBySubScopeIdAndScopeTypeMatcher, true);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Task> findTasksByQueryCriteria(TaskQueryImpl taskQuery) {
        final string query = "selectTaskByQueryCriteria";
        return getDbSqlSession().selectList(query, taskQuery, getManagedEntityClass());
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Task> findTasksWithRelatedEntitiesByQueryCriteria(TaskQueryImpl taskQuery) {
        final string query = "selectTasksWithRelatedEntitiesByQueryCriteria";
        // paging doesn't work for combining task instances and variables due to
        // an outer join, so doing it in-memory

        int firstResult = taskQuery.getFirstResult();
        int maxResults = taskQuery.getMaxResults();

        // setting max results, limit to 20000 results for performance reasons
        if (taskQuery.getTaskVariablesLimit() !is null) {
            taskQuery.setMaxResults(taskQuery.getTaskVariablesLimit());
        } else {
            taskQuery.setMaxResults(CommandContextUtil.getTaskServiceConfiguration().getTaskQueryLimit());
        }
        taskQuery.setFirstResult(0);

        List<Task> instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(query, taskQuery, getManagedEntityClass());

        if (instanceList !is null && !instanceList.isEmpty()) {
            if (firstResult > 0) {
                if (firstResult <= instanceList.size()) {
                    int toIndex = firstResult + Math.min(maxResults, instanceList.size() - firstResult);
                    return instanceList.subList(firstResult, toIndex);
                } else {
                    return Collections.EMPTY_LIST;
                }
            } else {
                int toIndex = maxResults > 0 ?  Math.min(maxResults, instanceList.size()) : instanceList.size();
                return instanceList.subList(0, toIndex);
            }
        }
        return Collections.EMPTY_LIST;
    }

    @Override
    public long findTaskCountByQueryCriteria(TaskQueryImpl taskQuery) {
        return (Long) getDbSqlSession().selectOne("selectTaskCountByQueryCriteria", taskQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Task> findTasksByNativeQuery(Map!(string, Object) parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectTaskByNativeQuery", parameterMap);
    }

    @Override
    public long findTaskCountByNativeQuery(Map!(string, Object) parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectTaskCountByNativeQuery", parameterMap);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<Task> findTasksByParentTaskId(string parentTaskId) {
        return getDbSqlSession().selectList("selectTasksByParentTaskId", parentTaskId);
    }

    @Override
    public void updateTaskTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap!(string, Object) params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateTaskTenantIdForDeployment", params);
    }

    @Override
    public void updateAllTaskRelatedEntityCountFlags(bool newValue) {
        getDbSqlSession().update("updateTaskRelatedEntityCountEnabled", newValue);
    }

    @Override
    public void deleteTasksByExecutionId(string executionId) {
        DbSqlSession dbSqlSession = getDbSqlSession();
        if (isEntityInserted(dbSqlSession, "execution", executionId)) {
            deleteCachedEntities(dbSqlSession, tasksByExecutionIdMatcher, executionId);
        } else {
            bulkDelete("deleteTasksByExecutionId", tasksByExecutionIdMatcher, executionId);
        }
    }

}
