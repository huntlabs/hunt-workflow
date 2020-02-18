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


import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.api.FlowableOptimisticLockingException;
import flow.common.db.SingleCachedEntityMatcher;
import flow.common.persistence.cache.CachedEntityMatcher;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.cfg.PerformanceSettings;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.ExecutionDataManager;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionByProcessInstanceMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByParentExecutionIdAndActivityIdEntityMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByParentExecutionIdEntityMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByProcessInstanceIdEntityMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsByRootProcessInstanceMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ExecutionsWithSameRootProcessInstanceIdMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsByProcInstMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsInActivityAndProcInstMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.InactiveExecutionsInActivityMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.ProcessInstancesByProcessDefinitionMatcher;
import flow.engine.impl.persistence.entity.data.impl.cachematcher.SubProcessInstanceExecutionBySuperExecutionIdMatcher;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Joram Barrez
 */
class MybatisExecutionDataManager extends AbstractProcessDataManager<ExecutionEntity> implements ExecutionDataManager {

    protected PerformanceSettings performanceSettings;

    protected CachedEntityMatcher<ExecutionEntity> executionsByParentIdMatcher = new ExecutionsByParentExecutionIdEntityMatcher();

    protected CachedEntityMatcher<ExecutionEntity> executionsByProcessInstanceIdMatcher = new ExecutionsByProcessInstanceIdEntityMatcher();

    protected SingleCachedEntityMatcher<ExecutionEntity> subProcessInstanceBySuperExecutionIdMatcher = new SubProcessInstanceExecutionBySuperExecutionIdMatcher();

    protected CachedEntityMatcher<ExecutionEntity> executionsWithSameRootProcessInstanceIdMatcher = new ExecutionsWithSameRootProcessInstanceIdMatcher();

    protected CachedEntityMatcher<ExecutionEntity> inactiveExecutionsInActivityAndProcInstMatcher = new InactiveExecutionsInActivityAndProcInstMatcher();

    protected CachedEntityMatcher<ExecutionEntity> inactiveExecutionsByProcInstMatcher = new InactiveExecutionsByProcInstMatcher();

    protected CachedEntityMatcher<ExecutionEntity> inactiveExecutionsInActivityMatcher = new InactiveExecutionsInActivityMatcher();

    protected CachedEntityMatcher<ExecutionEntity> executionByProcessInstanceMatcher = new ExecutionByProcessInstanceMatcher();

    protected CachedEntityMatcher<ExecutionEntity> executionsByRootProcessInstanceMatcher = new ExecutionsByRootProcessInstanceMatcher();

    protected CachedEntityMatcher<ExecutionEntity> executionsByParentExecutionIdAndActivityIdEntityMatcher = new ExecutionsByParentExecutionIdAndActivityIdEntityMatcher();

    protected CachedEntityMatcher<ExecutionEntity> processInstancesByProcessDefinitionMatcher = new ProcessInstancesByProcessDefinitionMatcher();

    public MybatisExecutionDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
        this.performanceSettings = processEngineConfiguration.getPerformanceSettings();
    }

    @Override
    class<? extends ExecutionEntity> getManagedEntityClass() {
        return ExecutionEntityImpl.class;
    }

    @Override
    public ExecutionEntity create() {
        return ExecutionEntityImpl.createWithEmptyRelationshipCollections();
    }

    @Override
    public ExecutionEntity findById(string executionId) {
        if (isExecutionTreeFetched(executionId)) {
            return getEntityCache().findInCache(getManagedEntityClass(), executionId);
        }
        return super.findById(executionId);
    }
    
    /**
     * Fetches the execution tree related to the execution (if the process definition has been configured to do so)
     * @return True if the tree has been fetched, false otherwise or if fetching is disabled.  
     */
    protected bool isExecutionTreeFetched(final string executionId) {
        
        // The setting needs to be globally enabled
        if (!performanceSettings.isEnableEagerExecutionTreeFetching()) {
            return false;
        }
        
        // Need to get the cache result before doing the findById
        ExecutionEntity cachedExecutionEntity = getEntityCache().findInCache(getManagedEntityClass(), executionId);
        
        // Find execution in db or cache to check process definition setting for execution fetch.
        // If not set, no extra work is done. The execution is in the cache however now as a side-effect of calling this method.
        ExecutionEntity executionEntity = (cachedExecutionEntity !is null) ? cachedExecutionEntity : super.findById(executionId);
        if (!ProcessDefinitionUtil.getProcess(executionEntity.getProcessDefinitionId()).isEnableEagerExecutionTreeFetching()) {
            return false;
        }
        
        // If it's in the cache, the execution and its tree have been fetched before. No need to do anything more.
        if (cachedExecutionEntity !is null) {
            return true;
        }
        
        // Fetches execution tree. This will store them in the cache and thus avoind extra database calls.
        getList("selectExecutionsWithSameRootProcessInstanceId", executionId,
                executionsWithSameRootProcessInstanceIdMatcher, true);
        
        return true;
    }

    @Override
    public ExecutionEntity findSubProcessInstanceBySuperExecutionId(final string superExecutionId) {
        bool treeFetched = isExecutionTreeFetched(superExecutionId);
        return getEntity("selectSubProcessInstanceBySuperExecutionId",
                superExecutionId,
                subProcessInstanceBySuperExecutionIdMatcher,
                !treeFetched);
    }

    @Override
    public List<ExecutionEntity> findChildExecutionsByParentExecutionId(final string parentExecutionId) {
        if (isExecutionTreeFetched(parentExecutionId)) {
            return getListFromCache(executionsByParentIdMatcher, parentExecutionId);
        } else {
            return getList("selectExecutionsByParentExecutionId", parentExecutionId, executionsByParentIdMatcher, true);
        }
    }

    @Override
    public List<ExecutionEntity> findChildExecutionsByProcessInstanceId(final string processInstanceId) {
        if (isExecutionTreeFetched(processInstanceId)) {
            return getListFromCache(executionsByProcessInstanceIdMatcher, processInstanceId);
        } else {
            return getList("selectChildExecutionsByProcessInstanceId", processInstanceId, executionsByProcessInstanceIdMatcher, true);
        }
    }

    @Override
    public List<ExecutionEntity> findExecutionsByParentExecutionAndActivityIds(final string parentExecutionId, final Collection<string> activityIds) {
        Map<string, Object> parameters = new HashMap<>(2);
        parameters.put("parentExecutionId", parentExecutionId);
        parameters.put("activityIds", activityIds);

        if (isExecutionTreeFetched(parentExecutionId)) {
            return getListFromCache(executionsByParentExecutionIdAndActivityIdEntityMatcher, parameters);
        } else {
            return getList("selectExecutionsByParentExecutionAndActivityIds", parameters, executionsByParentExecutionIdAndActivityIdEntityMatcher, true);
        }
    }

    @Override
    public List<ExecutionEntity> findExecutionsByRootProcessInstanceId(final string rootProcessInstanceId) {
        if (isExecutionTreeFetched(rootProcessInstanceId)) {
            return getListFromCache(executionsByRootProcessInstanceMatcher, rootProcessInstanceId);
        } else {
            return getList("selectExecutionsByRootProcessInstanceId", rootProcessInstanceId, executionsByRootProcessInstanceMatcher, true);
        }
    }

    @Override
    public List<ExecutionEntity> findExecutionsByProcessInstanceId(final string processInstanceId) {
        if (isExecutionTreeFetched(processInstanceId)) {
            return getListFromCache(executionByProcessInstanceMatcher, processInstanceId);
        } else {
            return getList("selectExecutionsByProcessInstanceId", processInstanceId, executionByProcessInstanceMatcher, true);
        }
    }

    @Override
    public Collection<ExecutionEntity> findInactiveExecutionsByProcessInstanceId(final string processInstanceId) {
        HashMap<string, Object> params = new HashMap<>(2);
        params.put("processInstanceId", processInstanceId);
        params.put("isActive", false);

        if (isExecutionTreeFetched(processInstanceId)) {
            return getListFromCache(inactiveExecutionsByProcInstMatcher, params);
        } else {
            return getList("selectInactiveExecutionsForProcessInstance", params, inactiveExecutionsByProcInstMatcher, true);
        }
    }

    @Override
    public Collection<ExecutionEntity> findInactiveExecutionsByActivityIdAndProcessInstanceId(final string activityId, final string processInstanceId) {
        HashMap<string, Object> params = new HashMap<>(3);
        params.put("activityId", activityId);
        params.put("processInstanceId", processInstanceId);
        params.put("isActive", false);

        if (isExecutionTreeFetched(processInstanceId)) {
            return getListFromCache(inactiveExecutionsInActivityAndProcInstMatcher, params);
        } else {
            return getList("selectInactiveExecutionsInActivityAndProcessInstance", params, inactiveExecutionsInActivityAndProcInstMatcher, true);
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<string> findProcessInstanceIdsByProcessDefinitionId(string processDefinitionId) {
        return getDbSqlSession().selectListNoCacheLoadAndStore("selectProcessInstanceIdsByProcessDefinitionId", processDefinitionId);
    }

    @Override
    public long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery) {
        return (Long) getDbSqlSession().selectOne("selectExecutionCountByQueryCriteria", executionQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ExecutionEntity> findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery) {
        // False -> executions should not be cached if using executionTreeFetching
        bool useCache = !performanceSettings.isEnableEagerExecutionTreeFetching();
        if (useCache) {
            return getDbSqlSession().selectList("selectExecutionsByQueryCriteria", executionQuery, getManagedEntityClass());
        } else {
            return getDbSqlSession().selectListNoCacheLoadAndStore("selectExecutionsByQueryCriteria", executionQuery);
        }
    }

    @Override
    public long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        return (Long) getDbSqlSession().selectOne("selectProcessInstanceCountByQueryCriteria", executionQuery);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ProcessInstance> findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        // False -> executions should not be cached if using executionTreeFetching
        bool useCache = !performanceSettings.isEnableEagerExecutionTreeFetching();
        if (useCache) {
            return getDbSqlSession().selectList("selectProcessInstanceByQueryCriteria", executionQuery, getManagedEntityClass());
        } else {
            return getDbSqlSession().selectListNoCacheLoadAndStore("selectProcessInstanceByQueryCriteria", executionQuery, getManagedEntityClass());
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ProcessInstance> findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery) {
        // paging doesn't work for combining process instances and variables due
        // to an outer join, so doing it in-memory

        int firstResult = executionQuery.getFirstResult();
        int maxResults = executionQuery.getMaxResults();

        // setting max results, limit to 20000 results for performance reasons
        if (executionQuery.getProcessInstanceVariablesLimit() !is null) {
            executionQuery.setMaxResults(executionQuery.getProcessInstanceVariablesLimit());
        } else {
            executionQuery.setMaxResults(getProcessEngineConfiguration().getExecutionQueryLimit());
        }
        executionQuery.setFirstResult(0);

        List<ProcessInstance> instanceList = getDbSqlSession().selectListWithRawParameterNoCacheLoadAndStore(
                        "selectProcessInstanceWithVariablesByQueryCriteria", executionQuery, getManagedEntityClass());

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
    @SuppressWarnings("unchecked")
    public List<Execution> findExecutionsByNativeQuery(Map<string, Object> parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectExecutionByNativeQuery", parameterMap);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<ProcessInstance> findProcessInstanceByNativeQuery(Map<string, Object> parameterMap) {
        return getDbSqlSession().selectListWithRawParameter("selectExecutionByNativeQuery", parameterMap);
    }

    @Override
    public long findExecutionCountByNativeQuery(Map<string, Object> parameterMap) {
        return (Long) getDbSqlSession().selectOne("selectExecutionCountByNativeQuery", parameterMap);
    }

    @Override
    public void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId) {
        HashMap<string, Object> params = new HashMap<>();
        params.put("deploymentId", deploymentId);
        params.put("tenantId", newTenantId);
        getDbSqlSession().update("updateExecutionTenantIdForDeployment", params);
    }

    @Override
    public void updateProcessInstanceLockTime(string processInstanceId, Date lockDate, Date expirationTime) {
        HashMap<string, Object> params = new HashMap<>();
        params.put("id", processInstanceId);
        params.put("lockTime", lockDate);
        params.put("expirationTime", expirationTime);

        int result = getDbSqlSession().update("updateProcessInstanceLockTime", params);
        if (result == 0) {
            throw new FlowableOptimisticLockingException("Could not lock process instance");
        }
    }

    @Override
    public void updateAllExecutionRelatedEntityCountFlags(bool newValue) {
        getDbSqlSession().update("updateExecutionRelatedEntityCountEnabled", newValue);
    }

    @Override
    public void clearProcessInstanceLockTime(string processInstanceId) {
        HashMap<string, Object> params = new HashMap<>();
        params.put("id", processInstanceId);
        getDbSqlSession().update("clearProcessInstanceLockTime", params);
    }
    
}
