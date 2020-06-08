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



import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.service.CommonEngineServiceImpl;
import flow.engine.RuntimeService;
import flow.engine.form.FormData;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.ActivateProcessInstanceCmd;
import flow.engine.impl.cmd.AddEventConsumerCommand;
import flow.engine.impl.cmd.AddEventListenerCommand;
import flow.engine.impl.cmd.AddIdentityLinkForProcessInstanceCmd;
import flow.engine.impl.cmd.AddMultiInstanceExecutionCmd;
import flow.engine.impl.cmd.ChangeActivityStateCmd;
import flow.engine.impl.cmd.CompleteAdhocSubProcessCmd;
import flow.engine.impl.cmd.DeleteIdentityLinkForProcessInstanceCmd;
import flow.engine.impl.cmd.DeleteMultiInstanceExecutionCmd;
import flow.engine.impl.cmd.DeleteProcessInstanceCmd;
import flow.engine.impl.cmd.DispatchEventCommand;
import flow.engine.impl.cmd.EvaluateConditionalEventsCmd;
import flow.engine.impl.cmd.ExecuteActivityForAdhocSubProcessCmd;
import flow.engine.impl.cmd.FindActiveActivityIdsCmd;
import flow.engine.impl.cmd.GetActiveAdhocSubProcessesCmd;
import flow.engine.impl.cmd.GetDataObjectCmd;
import flow.engine.impl.cmd.GetDataObjectsCmd;
import flow.engine.impl.cmd.GetEnabledActivitiesForAdhocSubProcessCmd;
import flow.engine.impl.cmd.GetEntityLinkChildrenForProcessInstanceCmd;
import flow.engine.impl.cmd.GetEntityLinkChildrenForTaskCmd;
import flow.engine.impl.cmd.GetEntityLinkParentsForProcessInstanceCmd;
import flow.engine.impl.cmd.GetEntityLinkParentsForTaskCmd;
import flow.engine.impl.cmd.GetExecutionVariableCmd;
import flow.engine.impl.cmd.GetExecutionVariableInstanceCmd;
import flow.engine.impl.cmd.GetExecutionVariableInstancesCmd;
import flow.engine.impl.cmd.GetExecutionVariablesCmd;
import flow.engine.impl.cmd.GetExecutionsVariablesCmd;
import flow.engine.impl.cmd.GetIdentityLinksForProcessInstanceCmd;
import flow.engine.impl.cmd.GetProcessInstanceEventsCmd;
import flow.engine.impl.cmd.GetStartFormCmd;
import flow.engine.impl.cmd.GetStartFormModelCmd;
import flow.engine.impl.cmd.HasExecutionVariableCmd;
import flow.engine.impl.cmd.MessageEventReceivedCmd;
import flow.engine.impl.cmd.RemoveEventConsumerCommand;
import flow.engine.impl.cmd.RemoveEventListenerCommand;
import flow.engine.impl.cmd.RemoveExecutionVariablesCmd;
import flow.engine.impl.cmd.SetExecutionVariablesCmd;
import flow.engine.impl.cmd.SetProcessInstanceBusinessKeyCmd;
import flow.engine.impl.cmd.SetProcessInstanceNameCmd;
import flow.engine.impl.cmd.SignalEventReceivedCmd;
import flow.engine.impl.cmd.StartProcessInstanceAsyncCmd;
import flow.engine.impl.cmd.StartProcessInstanceByMessageCmd;
import flow.engine.impl.cmd.StartProcessInstanceCmd;
import flow.engine.impl.cmd.SuspendProcessInstanceCmd;
import flow.engine.impl.cmd.TriggerCmd;
import flow.engine.impl.runtime.ChangeActivityStateBuilderImpl;
import flow.engine.impl.runtime.ProcessInstanceBuilderImpl;
import flow.engine.runtime.ChangeActivityStateBuilder;
import flow.engine.runtime.DataObject;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ExecutionQuery;
import flow.engine.runtime.NativeExecutionQuery;
import flow.engine.runtime.NativeProcessInstanceQuery;
import flow.engine.runtime.ProcessInstance;
import flow.engine.runtime.ProcessInstanceBuilder;
import flow.engine.runtime.ProcessInstanceQuery;
import flow.engine.task.Event;
import flow.entitylink.service.api.EntityLink;
import flow.event.registry.api.EventRegistryEventConsumer;
import flow.eventsubscription.service.api.EventSubscriptionQuery;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.form.api.FormInfo;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.variable.service.api.persistence.entity.VariableInstance;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 */
class RuntimeServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl implements RuntimeService {

    override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, null, null));
    }

    override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, businessKey, null));
    }

    override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, null, variables));
    }

    override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, businessKey, variables));
    }

    override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, null, null, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, businessKey, null, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, Map!(string, Object) variables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, null, variables, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, Map!(string, Object) variables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processDefinitionKey, null, businessKey, variables, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceById(string processDefinitionId) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(null, processDefinitionId, null, null));
    }

    override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(null, processDefinitionId, businessKey, null));
    }

    override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(null, processDefinitionId, null, variables));
    }

    override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(null, processDefinitionId, businessKey, variables));
    }

    override
    public ProcessInstance startProcessInstanceWithForm(string processDefinitionId, string outcome, Map!(string, Object) variables, string processInstanceName) {
        ProcessInstanceBuilder processInstanceBuilder = createProcessInstanceBuilder()
            .processDefinitionId(processDefinitionId)
            .outcome(outcome)
            .startFormVariables(variables)
            .name(processInstanceName);
        return processInstanceBuilder.start();
    }

    override
    public FormInfo getStartFormModel(string processDefinitionId, string processInstanceId) {
        return commandExecutor.execute(new GetStartFormModelCmd(processDefinitionId, processInstanceId));
    }

    override
    public void deleteProcessInstance(string processInstanceId, string deleteReason) {
        commandExecutor.execute(new DeleteProcessInstanceCmd(processInstanceId, deleteReason));
    }

    override
    public ExecutionQuery createExecutionQuery() {
        return new ExecutionQueryImpl(commandExecutor);
    }

    override
    public NativeExecutionQuery createNativeExecutionQuery() {
        return new NativeExecutionQueryImpl(commandExecutor);
    }

    override
    public NativeProcessInstanceQuery createNativeProcessInstanceQuery() {
        return new NativeProcessInstanceQueryImpl(commandExecutor);
    }

    override
    public NativeActivityInstanceQueryImpl createNativeActivityInstanceQuery() {
        return new NativeActivityInstanceQueryImpl(commandExecutor);
    }

    override
    public EventSubscriptionQuery createEventSubscriptionQuery() {
        return new EventSubscriptionQueryImpl(commandExecutor);
    }

    override
    public void updateBusinessKey(string processInstanceId, string businessKey) {
        commandExecutor.execute(new SetProcessInstanceBusinessKeyCmd(processInstanceId, businessKey));
    }

    override
    public Map!(string, Object) getVariables(string executionId) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, false));
    }

    override
    public Map!(string, VariableInstance) getVariableInstances(string executionId) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, false));
    }

    override
    public List!VariableInstance getVariableInstancesByExecutionIds(Set!string executionIds) {
        return commandExecutor.execute(new GetExecutionsVariablesCmd(executionIds));
    }

    override
    public Map!(string, Object) getVariablesLocal(string executionId) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, true));
    }

    override
    public Map!(string, VariableInstance) getVariableInstancesLocal(string executionId) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, true));
    }

    override
    public Map!(string, Object) getVariables(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, false));
    }

    override
    public Map!(string, VariableInstance) getVariableInstances(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, false));
    }

    override
    public Map!(string, Object) getVariablesLocal(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, true));
    }

    override
    public Map!(string, VariableInstance) getVariableInstancesLocal(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, true));
    }

    override
    public Object getVariable(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, false));
    }

    override
    public VariableInstance getVariableInstance(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, false));
    }

    override
    public <T> T getVariable(string executionId, string variableName, Class!T variableClass) {
        return variableClass.cast(getVariable(executionId, variableName));
    }

    override
    public bool hasVariable(string executionId, string variableName) {
        return commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, false));
    }

    override
    public Object getVariableLocal(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, true));
    }

    override
    public VariableInstance getVariableInstanceLocal(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, true));
    }

    override
    public <T> T getVariableLocal(string executionId, string variableName, Class!T variableClass) {
        return variableClass.cast(getVariableLocal(executionId, variableName));
    }

    override
    public bool hasVariableLocal(string executionId, string variableName) {
        return commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, true));
    }

    override
    public void setVariable(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }

    override
    public void setVariableLocal(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }

    override
    public void setVariables(string executionId, Map<string, ?> variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }

    override
    public void setVariablesLocal(string executionId, Map<string, ?> variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }

    override
    public void removeVariable(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList<>(1);
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }

    override
    public void removeVariableLocal(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList<>();
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }

    override
    public void removeVariables(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }

    override
    public void removeVariablesLocal(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }

    override
    public Map!(string, DataObject) getDataObjects(string executionId) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false));
    }

    override
    public Map!(string, DataObject) getDataObjects(string executionId, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false, locale, withLocalizationFallback));
    }

    override
    public Map!(string, DataObject) getDataObjectsLocal(string executionId) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true));
    }

    override
    public Map!(string, DataObject) getDataObjectsLocal(string executionId, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true, locale, withLocalizationFallback));
    }

    override
    public Map!(string, DataObject) getDataObjects(string executionId, Collection!string dataObjectNames) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false));
    }

    override
    public Map!(string, DataObject) getDataObjects(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false, locale, withLocalizationFallback));
    }

    override
    public Map!(string, DataObject) getDataObjectsLocal(string executionId, Collection!string dataObjects) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjects, true));
    }

    override
    public Map!(string, DataObject) getDataObjectsLocal(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, true, locale, withLocalizationFallback));
    }

    override
    public DataObject getDataObject(string executionId, string dataObject) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObject, false));
    }

    override
    public DataObject getDataObject(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, false, locale, withLocalizationFallback));
    }

    override
    public DataObject getDataObjectLocal(string executionId, string dataObjectName) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true));
    }

    override
    public DataObject getDataObjectLocal(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true, locale, withLocalizationFallback));
    }

    public void signal(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }

    override
    public void trigger(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }

    override
    public void triggerAsync(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null, true));
    }

    public void signal(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }

    override
    public void trigger(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }

    override
    public void triggerAsync(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, true));
    }

    override
    public void trigger(string executionId, Map!(string, Object) processVariables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, transientVariables));
    }

    override
    public void evaluateConditionalEvents(string processInstanceId) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, null));
    }

    override
    public void evaluateConditionalEvents(string processInstanceId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, processVariables));
    }

    override
    public void addUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }

    override
    public void addGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }

    override
    public void addParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }

    override
    public void addParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }

    override
    public void deleteParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }

    override
    public void deleteParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }

    override
    public void deleteUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }

    override
    public void deleteGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }

    override
    public List!IdentityLink getIdentityLinksForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetIdentityLinksForProcessInstanceCmd(processInstanceId));
    }

    override
    public List!EntityLink getEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetEntityLinkChildrenForProcessInstanceCmd(processInstanceId));
    }

    override
    public List!EntityLink getEntityLinkChildrenForTask(string taskId) {
        return commandExecutor.execute(new GetEntityLinkChildrenForTaskCmd(taskId));
    }

    override
    public List!EntityLink getEntityLinkParentsForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetEntityLinkParentsForProcessInstanceCmd(processInstanceId));
    }

    override
    public List!EntityLink getEntityLinkParentsForTask(string taskId) {
        return commandExecutor.execute(new GetEntityLinkParentsForTaskCmd(taskId));
    }

    override
    public ProcessInstanceQuery createProcessInstanceQuery() {
        return new ProcessInstanceQueryImpl(commandExecutor);
    }

    override
    public ActivityInstanceQueryImpl createActivityInstanceQuery() {
        return new ActivityInstanceQueryImpl(commandExecutor);
    }

    override
    public List!string getActiveActivityIds(string executionId) {
        return commandExecutor.execute(new FindActiveActivityIdsCmd(executionId));
    }

    public FormData getFormInstanceById(string processDefinitionId) {
        return commandExecutor.execute(new GetStartFormCmd(processDefinitionId));
    }

    override
    public void suspendProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new SuspendProcessInstanceCmd(processInstanceId));
    }

    override
    public void activateProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new ActivateProcessInstanceCmd(processInstanceId));
    }

    override
    public ProcessInstance startProcessInstanceByMessage(string messageName) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, null));
    }

    override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, null));
    }

    override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByMessage(string messageName, Map!(string, Object) processVariables) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, null));
    }

    override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, Map!(string, Object) processVariables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, tenantId));
    }

    override
    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey, Map!(string, Object) processVariables) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, null));
    }

    override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, Map!(string, Object) processVariables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, tenantId));
    }

    override
    public void signalEventReceived(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, null));
    }

    override
    public void signalEventReceivedWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, tenantId));
    }

    override
    public void signalEventReceivedAsync(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, null));
    }

    override
    public void signalEventReceivedAsyncWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, tenantId));
    }

    override
    public void signalEventReceived(string signalName, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, null));
    }

    override
    public void signalEventReceivedWithTenantId(string signalName, Map!(string, Object) processVariables, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, tenantId));
    }

    override
    public void signalEventReceived(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, null, null));
    }

    override
    public void signalEventReceived(string signalName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, processVariables, null));
    }

    override
    public void signalEventReceivedAsync(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, true, null));
    }

    override
    public void messageEventReceived(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, null));
    }

    override
    public void messageEventReceived(string messageName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, processVariables));
    }

    override
    public void messageEventReceivedAsync(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, true));
    }

    override
    public void addEventListener(FlowableEventListener listenerToAdd) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd));
    }

    override
    public void addEventListener(FlowableEventListener listenerToAdd, FlowableEngineEventType... types) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd, types));
    }

    override
    public void removeEventListener(FlowableEventListener listenerToRemove) {
        commandExecutor.execute(new RemoveEventListenerCommand(listenerToRemove));
    }

    override
    public void dispatchEvent(FlowableEvent event) {
        commandExecutor.execute(new DispatchEventCommand(event));
    }

    override
    public void addEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new AddEventConsumerCommand(eventConsumer));
    }

    override
    public void removeEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new RemoveEventConsumerCommand(eventConsumer));
    }

    override
    public void setProcessInstanceName(string processInstanceId, string name) {
        commandExecutor.execute(new SetProcessInstanceNameCmd(processInstanceId, name));
    }

    override
    public List!Event getProcessInstanceEvents(string processInstanceId) {
        return commandExecutor.execute(new GetProcessInstanceEventsCmd(processInstanceId));
    }

    override
    public List!Execution getAdhocSubProcessExecutions(string processInstanceId) {
        return commandExecutor.execute(new GetActiveAdhocSubProcessesCmd(processInstanceId));
    }

    override
    public List!FlowNode getEnabledActivitiesFromAdhocSubProcess(string executionId) {
        return commandExecutor.execute(new GetEnabledActivitiesForAdhocSubProcessCmd(executionId));
    }

    override
    public Execution executeActivityInAdhocSubProcess(string executionId, string activityId) {
        return commandExecutor.execute(new ExecuteActivityForAdhocSubProcessCmd(executionId, activityId));
    }

    override
    public void completeAdhocSubProcess(string executionId) {
        commandExecutor.execute(new CompleteAdhocSubProcessCmd(executionId));
    }

    override
    public ProcessInstanceBuilder createProcessInstanceBuilder() {
        return new ProcessInstanceBuilderImpl(this);
    }

    override
    public ChangeActivityStateBuilder createChangeActivityStateBuilder() {
        return new ChangeActivityStateBuilderImpl(this);
    }

    override
    public Execution addMultiInstanceExecution(string activityId, string parentExecutionId, Map!(string, Object) executionVariables) {
        return commandExecutor.execute(new AddMultiInstanceExecutionCmd(activityId, parentExecutionId, executionVariables));
    }

    override
    public void deleteMultiInstanceExecution(string executionId, bool executionIsCompleted) {
        commandExecutor.execute(new DeleteMultiInstanceExecutionCmd(executionId, executionIsCompleted));
    }

    public ProcessInstance startProcessInstance(ProcessInstanceBuilderImpl processInstanceBuilder) {
        if (processInstanceBuilder.getProcessDefinitionId() !is null || processInstanceBuilder.getProcessDefinitionKey() !is null) {
            return commandExecutor.execute(new StartProcessInstanceCmd!ProcessInstance(processInstanceBuilder));
        } else if (processInstanceBuilder.getMessageName() !is null) {
            return commandExecutor.execute(new StartProcessInstanceByMessageCmd(processInstanceBuilder));
        } else {
            throw new FlowableIllegalArgumentException("No processDefinitionId, processDefinitionKey nor messageName provided");
        }
    }

    public ProcessInstance startProcessInstanceAsync(ProcessInstanceBuilderImpl processInstanceBuilder) {
        if (processInstanceBuilder.getProcessDefinitionId() !is null || processInstanceBuilder.getProcessDefinitionKey() !is null) {
            return (ProcessInstance) commandExecutor.execute(new StartProcessInstanceAsyncCmd(processInstanceBuilder));
        } else {
            throw new FlowableIllegalArgumentException("No processDefinitionId, processDefinitionKey provided");
        }
    }

    public void changeActivityState(ChangeActivityStateBuilderImpl changeActivityStateBuilder) {
        commandExecutor.execute(new ChangeActivityStateCmd(changeActivityStateBuilder));
    }

}
