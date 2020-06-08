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

module flow.engine.impl.persistence.entity.ExecutionEntity;

import hunt.util.Comparator;
//import java.util.Comparator;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.bpmn.model.FlowElement;
import flow.common.db.HasRevision;
import flow.common.persistence.entity.AlwaysUpdatedPersistentObject;
import flow.common.persistence.entity.Entity;
import flow.engine.deleg.DelegateExecution;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.identitylink.service.impl.persistence.entity.IdentityLinkEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.task.service.impl.persistence.entity.TaskEntity;
//import flow.engine.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Falko Menge
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */

interface ExecutionEntity : DelegateExecution, Execution, ProcessInstance, Entity, AlwaysUpdatedPersistentObject, HasRevision {

    //Comparator!ExecutionEntity EXECUTION_ENTITY_START_TIME_ASC_COMPARATOR = comparing(ProcessInstance::getStartTime);

    void setBusinessKey(string businessKey);

    void setProcessDefinitionId(string processDefinitionId);

    void setProcessDefinitionKey(string processDefinitionKey);

    void setProcessDefinitionName(string processDefinitionName);

    void setProcessDefinitionVersion(int processDefinitionVersion);

    void setDeploymentId(string deploymentId);

    ExecutionEntity getProcessInstance();

    void setProcessInstance(ExecutionEntity processInstance);

    ExecutionEntity getParent();

    void setParent(ExecutionEntity parent);

    ExecutionEntity getSuperExecution();

    void setSuperExecution(ExecutionEntity superExecution);

    ExecutionEntity getSubProcessInstance();

    void setSubProcessInstance(ExecutionEntity subProcessInstance);

    void setRootProcessInstanceId(string rootProcessInstanceId);

    ExecutionEntity getRootProcessInstance();

    void setRootProcessInstance(ExecutionEntity rootProcessInstance);

    List!ExecutionEntity getExecutions();

    void addChildExecution(ExecutionEntity executionEntity);

    List!TaskEntity getTasks();

   // List!EventSubscriptionEntity getEventSubscriptions();

    List!JobEntity getJobs();

    List!TimerJobEntity getTimerJobs();

    List!IdentityLinkEntity getIdentityLinks();

    void setProcessInstanceId(string processInstanceId);

    void setParentId(string parentId);

    void setEnded(bool isEnded);

    string getDeleteReason();

    void setDeleteReason(string deleteReason);

    int getSuspensionState();

    void setSuspensionState(int suspensionState);

    bool isEventScope();

    void setEventScope(bool isEventScope);

    void setName(string name);

    void setDescription(string description);

    void setLocalizedName(string localizedName);

    void setLocalizedDescription(string localizedDescription);

    void setTenantId(string tenantId);

    Date getLockTime();

    void setLockTime(Date lockTime);

    void forceUpdate();

    string getStartActivityId();

    void setStartActivityId(string startActivityId);

    void setStartUserId(string startUserId);

    void setStartTime(Date startTime);

    void setCallbackId(string callbackId);

    void setCallbackType(string callbackType);

    void setVariable(string variableName, Object value, ExecutionEntity sourceExecution, bool fetchAllVariables);

    void setReferenceId(string referenceId);

    void setReferenceType(string referenceType);

    void setPropagatedStageInstanceId(string propagatedStageInstanceId);

    Object setVariableLocal(string variableName, Object value, ExecutionEntity sourceExecution, bool fetchAllVariables);

    FlowElement getOriginatingCurrentFlowElement();

    void setOriginatingCurrentFlowElement(FlowElement flowElement);
}
