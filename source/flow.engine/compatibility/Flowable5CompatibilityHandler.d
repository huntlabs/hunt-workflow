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


//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.engine.compatibility.Flowable5CompatibilityHandler;
 
 
 


import java.io.InputStream;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.MapExceptionEntry;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.runtime.Clock;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.DelegateExecution;
import flow.engine.form.StartFormData;
import flow.engine.form.TaskFormData;
import flow.engine.impl.persistence.deploy.ProcessDefinitionCacheEntry;
import flow.engine.impl.repository.DeploymentBuilderImpl;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.engine.task.Attachment;
import flow.engine.task.Comment;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import org.flowable.job.api.Job;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;
import org.flowable.variable.api.persistence.entity.VariableInstance;

import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
interface Flowable5CompatibilityHandler {

    ProcessDefinition getProcessDefinition(string processDefinitionId);

    ProcessDefinition getProcessDefinitionByKey(string processDefinitionKey);

    org.flowable.bpmn.model.Process getProcessDefinitionProcessObject(string processDefinitionId);

    BpmnModel getProcessDefinitionBpmnModel(string processDefinitionId);

    ObjectNode getProcessDefinitionInfo(string processDefinitionId);

    ProcessDefinitionCacheEntry resolveProcessDefinition(ProcessDefinition processDefinition);

    bool isProcessDefinitionSuspended(string processDefinitionId);

    void addCandidateStarter(string processDefinitionId, string userId, string groupId);

    void deleteCandidateStarter(string processDefinitionId, string userId, string groupId);

    void suspendProcessDefinition(string processDefinitionId, string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate, string tenantId);

    void activateProcessDefinition(string processDefinitionId, string processDefinitionKey, bool activateProcessInstances, Date activationDate, string tenantId);

    void setProcessDefinitionCategory(string processDefinitionId, string category);

    Deployment deploy(DeploymentBuilderImpl deploymentBuilder);

    void setDeploymentCategory(string deploymentId, string category);

    void changeDeploymentTenantId(string deploymentId, string newTenantId);

    void deleteDeployment(string deploymentId, bool cascade);

    ProcessInstance startProcessInstance(string processDefinitionKey, string processDefinitionId, Map<string, Object> variables, Map<string, Object> transientVariables,
            string businessKey, string tenantId, string processInstanceName);

    ProcessInstance startProcessInstanceByMessage(string messageName, Map<string, Object> variables, Map<string, Object> transientVariables, string businessKey, string tenantId);
    
    ProcessInstance getProcessInstance(string processInstanceId);
    
    void setProcessInstanceName(string processInstanceId, string processInstanceName);

    Object getExecutionVariable(string executionId, string variableName, bool isLocal);

    VariableInstance getExecutionVariableInstance(string executionId, string variableName, bool isLocal);

    Map<string, Object> getExecutionVariables(string executionId, Collection<string> variableNames, bool isLocal);

    Map<string, VariableInstance> getExecutionVariableInstances(string executionId, Collection<string> variableNames, bool isLocal);

    void setExecutionVariables(string executionId, Map<string, ? extends Object> variables, bool isLocal);

    void removeExecutionVariables(string executionId, Collection<string> variableNames, bool isLocal);

    void updateBusinessKey(string processInstanceId, string businessKey);

    void suspendProcessInstance(string processInstanceId);

    void activateProcessInstance(string processInstanceId);

    void addIdentityLinkForProcessInstance(string processInstanceId, string userId, string groupId, string identityLinkType);

    void deleteIdentityLinkForProcessInstance(string processInstanceId, string userId, string groupId, string identityLinkType);

    void deleteProcessInstance(string processInstanceId, string deleteReason);

    void deleteHistoricProcessInstance(string processInstanceId);

    void completeTask(TaskEntity taskEntity, Map<string, Object> variables, bool localScope);

    void completeTask(TaskEntity taskEntity, Map<string, Object> variables, Map<string, Object> transientVariables);

    void claimTask(string taskId, string userId);

    void setTaskVariables(string taskId, Map<string, ? extends Object> variables, bool isLocal);

    void removeTaskVariables(string taskId, Collection<string> variableNames, bool isLocal);

    void setTaskDueDate(string taskId, Date dueDate);

    void setTaskPriority(string taskId, int priority);

    void deleteTask(string taskId, string deleteReason, bool cascade);

    void deleteHistoricTask(string taskId);

    StartFormData getStartFormData(string processDefinitionId);

    string getFormKey(string processDefinitionId, string taskDefinitionKey);

    Object getRenderedStartForm(string processDefinitionId, string formEngineName);

    ProcessInstance submitStartFormData(string processDefinitionId, string businessKey, Map<string, string> properties);
    
    TaskFormData getTaskFormData(string taskId);

    void submitTaskFormData(string taskId, Map<string, string> properties, bool completeTask);

    void saveTask(TaskEntity task);

    void addIdentityLink(string taskId, string identityId, int identityIdType, string identityType);

    void deleteIdentityLink(string taskId, string userId, string groupId, string identityLinkType);

    Comment addComment(string taskId, string processInstanceId, string type, string message);

    void deleteComment(string commentId, string taskId, string processInstanceId);

    Attachment createAttachment(string attachmentType, string taskId, string processInstanceId, string attachmentName, string attachmentDescription, InputStream content, string url);

    void saveAttachment(Attachment attachment);

    void deleteAttachment(string attachmentId);

    void trigger(string executionId, Map<string, Object> processVariables, Map<string, Object> transientVariables);

    void messageEventReceived(string messageName, string executionId, Map<string, Object> processVariables, bool async);

    void signalEventReceived(string signalName, string executionId, Map<string, Object> processVariables, bool async, string tenantId);

    void signalEventReceived(SignalEventSubscriptionEntity signalEventSubscriptionEntity, Object payload, bool async);

    void executeJob(Job job);

    void executeJobWithLockAndRetry(Job job);

    void handleFailedJob(Job job, Throwable exception);

    void deleteJob(string jobId);

    void leaveExecution(DelegateExecution execution);

    void propagateError(BpmnError bpmnError, DelegateExecution execution);

    bool mapException(Exception camelException, DelegateExecution execution, List<MapExceptionEntry> mapExceptions);

    Map<string, Object> getVariables(ProcessInstance processInstance);

    Object getScriptingEngineValue(string payloadExpressionValue, string languageValue, DelegateExecution execution);

    void throwErrorEvent(FlowableEvent event);

    void setClock(Clock clock);

    void resetClock();

    Object getRawProcessEngine();

    Object getRawProcessConfiguration();

    Object getRawCommandExecutor();

    ProcessEngineConfiguration getFlowable6ProcessEngineConfiguration();

    void setFlowable6ProcessEngineConfiguration(ProcessEngineConfiguration processEngineConfiguration);

    Object getCamelContextObject(string camelContextValue);

    void setJobProcessor(List<Object> flowable5JobProcessors);

}
