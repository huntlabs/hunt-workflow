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
import java.util.Date;
import java.util.List;
import java.util.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Joram Barrez
 */
interface ExecutionDataManager extends DataManager<ExecutionEntity> {

    ExecutionEntity findSubProcessInstanceBySuperExecutionId(final string superExecutionId);

    List<ExecutionEntity> findChildExecutionsByParentExecutionId(final string parentExecutionId);

    List<ExecutionEntity> findChildExecutionsByProcessInstanceId(final string processInstanceId);

    List<ExecutionEntity> findExecutionsByParentExecutionAndActivityIds(final string parentExecutionId, final Collection<string> activityIds);

    long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery);

    List<ExecutionEntity> findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery);

    long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List<ProcessInstance> findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List<ExecutionEntity> findExecutionsByRootProcessInstanceId(string rootProcessInstanceId);

    List<ExecutionEntity> findExecutionsByProcessInstanceId(string processInstanceId);

    List<ProcessInstance> findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    Collection<ExecutionEntity> findInactiveExecutionsByProcessInstanceId(final string processInstanceId);

    Collection<ExecutionEntity> findInactiveExecutionsByActivityIdAndProcessInstanceId(final string activityId, final string processInstanceId);

    List<string> findProcessInstanceIdsByProcessDefinitionId(string processDefinitionId);

    List<Execution> findExecutionsByNativeQuery(Map<string, Object> parameterMap);

    List<ProcessInstance> findProcessInstanceByNativeQuery(Map<string, Object> parameterMap);

    long findExecutionCountByNativeQuery(Map<string, Object> parameterMap);

    void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId);

    void updateProcessInstanceLockTime(string processInstanceId, Date lockDate, Date expirationTime);

    void updateAllExecutionRelatedEntityCountFlags(boolean newValue);

    void clearProcessInstanceLockTime(string processInstanceId);

}
