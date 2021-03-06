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
module flow.engine.impl.persistence.entity.ExecutionEntityManager;

import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.FlowElement;
import flow.common.persistence.entity.EntityManager;
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;
import flow.engine.impl.persistence.entity.ExecutionEntity;
/**
 * @author Joram Barrez
 */
interface ExecutionEntityManager : EntityManager!ExecutionEntity {

    ExecutionEntity createProcessInstanceExecution(ProcessDefinition processDefinition, string predefinedProcessInstanceId,
                    string businessKey, string processInstanceName, string callbackId, string callbackType, string referenceId, string referenceType,
                    string propagatedStageInstanceId, string tenantId, string initiatorVariableName, string startActivityId);

    ExecutionEntity createChildExecution(ExecutionEntity parentExecutionEntity);

    ExecutionEntity createSubprocessInstance(ProcessDefinition processDefinition, ExecutionEntity superExecutionEntity,
                    string businessKey, string startActivityId);

    /**
     * Finds the {@link ExecutionEntity} for the given root process instance id. All children will have been fetched and initialized.
     */
    ExecutionEntity findByRootProcessInstanceId(string rootProcessInstanceId);

    ExecutionEntity findSubProcessInstanceBySuperExecutionId(string superExecutionId);

    List!ExecutionEntity findChildExecutionsByParentExecutionId(string parentExecutionId);

    List!ExecutionEntity findChildExecutionsByProcessInstanceId(string processInstanceId);

    List!ExecutionEntity findExecutionsByParentExecutionAndActivityIds(string parentExecutionId, Collection!string activityIds);

    long findExecutionCountByQueryCriteria(ExecutionQueryImpl executionQuery);

    List!ExecutionEntity findExecutionsByQueryCriteria(ExecutionQueryImpl executionQuery);

    long findProcessInstanceCountByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List!ProcessInstance findProcessInstanceByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    List!ProcessInstance findProcessInstanceAndVariablesByQueryCriteria(ProcessInstanceQueryImpl executionQuery);

    Collection!ExecutionEntity findInactiveExecutionsByProcessInstanceId(string processInstanceId);

    Collection!ExecutionEntity findInactiveExecutionsByActivityIdAndProcessInstanceId(string activityId, string processInstanceId);

    List!Execution findExecutionsByNativeQuery(Map!(string, Object) parameterMap);

    List!ProcessInstance findProcessInstanceByNativeQuery(Map!(string, Object) parameterMap);

    long findExecutionCountByNativeQuery(Map!(string, Object) parameterMap);

    /**
     * Returns all child executions of a given {@link ExecutionEntity}.
     * In the list, child executions will be behind parent executions.
     * Children include subprocessinstances and its children.
     */
    List!ExecutionEntity collectChildren(ExecutionEntity executionEntity);

    ExecutionEntity findFirstScope(ExecutionEntity executionEntity);

    ExecutionEntity findFirstMultiInstanceRoot(ExecutionEntity executionEntity);

    void updateExecutionTenantIdForDeployment(string deploymentId, string newTenantId);

    string updateProcessInstanceBusinessKey(ExecutionEntity executionEntity, string businessKey);

    void deleteProcessInstancesByProcessDefinition(string processDefinitionId, string deleteReason, bool cascade);

    void deleteProcessInstance(string processInstanceId, string deleteReason, bool cascade);

    void deleteProcessInstanceExecutionEntity(string processInstanceId, string currentFlowElementId,
            string deleteReason, bool cascade, bool cancel, bool fireEvents);

    void deleteChildExecutions(ExecutionEntity executionEntity, Collection!string executionIdsNotToDelete,
            Collection!string executionIdsNotToSendCancelledEventsFor, string deleteReason, bool cancel, FlowElement cancelActivity);

    void deleteChildExecutions(ExecutionEntity executionEntity, string deleteReason, bool cancel);

    void deleteExecutionAndRelatedData(ExecutionEntity executionEntity, string deleteReason, bool deleteHistory, bool cancel, FlowElement cancelActivity);

    void deleteExecutionAndRelatedData(ExecutionEntity executionEntity, string deleteReason, bool deleteHistory);

    void deleteRelatedDataForExecution(ExecutionEntity executionEntity, string deleteReason);

    void updateProcessInstanceLockTime(string processInstanceId);

    void clearProcessInstanceLockTime(string processInstanceId);

}
