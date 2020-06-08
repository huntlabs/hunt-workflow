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
module flow.engine.impl.persistence.entity.data.ExecutionDataManager;

import hunt.collection;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Joram Barrez
 */
interface ExecutionDataManager : DataManager!ExecutionEntity {

    ExecutionEntity findSubProcessInstanceBySuperExecutionId( string superExecutionId);

    List!ExecutionEntity findChildExecutionsByParentExecutionId( string parentExecutionId);

    List!ExecutionEntity findChildExecutionsByProcessInstanceId( string processInstanceId);

    List!ExecutionEntity findExecutionsByParentExecutionAndActivityIds( string parentExecutionId,  Collection!string activityIds);

    long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery);

    List!ExecutionEntity findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery);

    long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List!ProcessInstance findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List!ExecutionEntity findExecutionsByRootProcessInstanceId(string rootProcessInstanceId);

    List!ExecutionEntity findExecutionsByProcessInstanceId(string processInstanceId);

    List!ProcessInstance findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    Collection!ExecutionEntity findInactiveExecutionsByProcessInstanceId( string processInstanceId);

    Collection!ExecutionEntity findInactiveExecutionsByActivityIdAndProcessInstanceId( string activityId,  string processInstanceId);

    List!string findProcessInstanceIdsByProcessDefinitionId(string processDefinitionId);

    List!Execution findExecutionsByNativeQuery(Map!(string, Object) parameterMap);

    List!ProcessInstance findProcessInstanceByNativeQuery(Map!(string, Object) parameterMap);

    long findExecutionCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId);

    void updateProcessInstanceLockTime(string processInstanceId, Date lockDate, Date expirationTime);

    void updateAllExecutionRelatedEntityCountFlags(bool newValue);

    void clearProcessInstanceLockTime(string processInstanceId);

}
