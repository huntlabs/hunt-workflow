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
import org.flowable.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.form.api.FormInfo;
import flow.identitylink.api.IdentityLink;
import flow.identitylink.api.IdentityLinkType;
import flow.variable.service.api.persistence.entity.VariableInstance;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 */
class RuntimeServiceImpl extends CommonEngineServiceImpl<ProcessEngineConfigurationImpl> implements RuntimeService {

    @Override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, null, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, businessKey, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, null, variables));
    }

    @Override
    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, businessKey, variables));
    }

    @Override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, null, null, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, businessKey, null, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, Map!(string, Object) variables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, null, variables, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, Map!(string, Object) variables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processDefinitionKey, null, businessKey, variables, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceById(string processDefinitionId) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(null, processDefinitionId, null, null));
    }

    @Override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(null, processDefinitionId, businessKey, null));
    }

    @Override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(null, processDefinitionId, null, variables));
    }

    @Override
    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey, Map!(string, Object) variables) {
        return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(null, processDefinitionId, businessKey, variables));
    }

    @Override
    public ProcessInstance startProcessInstanceWithForm(string processDefinitionId, string outcome, Map!(string, Object) variables, string processInstanceName) {
        ProcessInstanceBuilder processInstanceBuilder = createProcessInstanceBuilder()
            .processDefinitionId(processDefinitionId)
            .outcome(outcome)
            .startFormVariables(variables)
            .name(processInstanceName);
        return processInstanceBuilder.start();
    }

    @Override
    public FormInfo getStartFormModel(string processDefinitionId, string processInstanceId) {
        return commandExecutor.execute(new GetStartFormModelCmd(processDefinitionId, processInstanceId));
    }

    @Override
    public void deleteProcessInstance(string processInstanceId, string deleteReason) {
        commandExecutor.execute(new DeleteProcessInstanceCmd(processInstanceId, deleteReason));
    }

    @Override
    public ExecutionQuery createExecutionQuery() {
        return new ExecutionQueryImpl(commandExecutor);
    }

    @Override
    public NativeExecutionQuery createNativeExecutionQuery() {
        return new NativeExecutionQueryImpl(commandExecutor);
    }

    @Override
    public NativeProcessInstanceQuery createNativeProcessInstanceQuery() {
        return new NativeProcessInstanceQueryImpl(commandExecutor);
    }

    @Override
    public NativeActivityInstanceQueryImpl createNativeActivityInstanceQuery() {
        return new NativeActivityInstanceQueryImpl(commandExecutor);
    }

    @Override
    public EventSubscriptionQuery createEventSubscriptionQuery() {
        return new EventSubscriptionQueryImpl(commandExecutor);
    }

    @Override
    public void updateBusinessKey(string processInstanceId, string businessKey) {
        commandExecutor.execute(new SetProcessInstanceBusinessKeyCmd(processInstanceId, businessKey));
    }

    @Override
    public Map!(string, Object) getVariables(string executionId) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, false));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstances(string executionId) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, false));
    }

    @Override
    public List<VariableInstance> getVariableInstancesByExecutionIds(Set!string executionIds) {
        return commandExecutor.execute(new GetExecutionsVariablesCmd(executionIds));
    }

    @Override
    public Map!(string, Object) getVariablesLocal(string executionId) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, true));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstancesLocal(string executionId) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, true));
    }

    @Override
    public Map!(string, Object) getVariables(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, false));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstances(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, false));
    }

    @Override
    public Map!(string, Object) getVariablesLocal(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, true));
    }

    @Override
    public Map<string, VariableInstance> getVariableInstancesLocal(string executionId, Collection!string variableNames) {
        return commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, true));
    }

    @Override
    public Object getVariable(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, false));
    }

    @Override
    public VariableInstance getVariableInstance(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, false));
    }

    @Override
    public <T> T getVariable(string executionId, string variableName, Class<T> variableClass) {
        return variableClass.cast(getVariable(executionId, variableName));
    }

    @Override
    public bool hasVariable(string executionId, string variableName) {
        return commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, false));
    }

    @Override
    public Object getVariableLocal(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, true));
    }

    @Override
    public VariableInstance getVariableInstanceLocal(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, true));
    }

    @Override
    public <T> T getVariableLocal(string executionId, string variableName, Class<T> variableClass) {
        return variableClass.cast(getVariableLocal(executionId, variableName));
    }

    @Override
    public bool hasVariableLocal(string executionId, string variableName) {
        return commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, true));
    }

    @Override
    public void setVariable(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }

    @Override
    public void setVariableLocal(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap<>();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }

    @Override
    public void setVariables(string executionId, Map<string, ?> variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }

    @Override
    public void setVariablesLocal(string executionId, Map<string, ?> variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }

    @Override
    public void removeVariable(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList<>(1);
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }

    @Override
    public void removeVariableLocal(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList<>();
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }

    @Override
    public void removeVariables(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }

    @Override
    public void removeVariablesLocal(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string executionId) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string executionId, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false, locale, withLocalizationFallback));
    }

    @Override
    public Map<string, DataObject> getDataObjectsLocal(string executionId) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true));
    }

    @Override
    public Map<string, DataObject> getDataObjectsLocal(string executionId, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true, locale, withLocalizationFallback));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string executionId, Collection!string dataObjectNames) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false));
    }

    @Override
    public Map<string, DataObject> getDataObjects(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false, locale, withLocalizationFallback));
    }

    @Override
    public Map<string, DataObject> getDataObjectsLocal(string executionId, Collection!string dataObjects) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjects, true));
    }

    @Override
    public Map<string, DataObject> getDataObjectsLocal(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, true, locale, withLocalizationFallback));
    }

    @Override
    public DataObject getDataObject(string executionId, string dataObject) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObject, false));
    }

    @Override
    public DataObject getDataObject(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, false, locale, withLocalizationFallback));
    }

    @Override
    public DataObject getDataObjectLocal(string executionId, string dataObjectName) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true));
    }

    @Override
    public DataObject getDataObjectLocal(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true, locale, withLocalizationFallback));
    }

    public void signal(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }

    @Override
    public void trigger(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }

    @Override
    public void triggerAsync(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null, true));
    }

    public void signal(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }

    @Override
    public void trigger(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }

    @Override
    public void triggerAsync(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, true));
    }

    @Override
    public void trigger(string executionId, Map!(string, Object) processVariables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, transientVariables));
    }

    @Override
    public void evaluateConditionalEvents(string processInstanceId) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, null));
    }

    @Override
    public void evaluateConditionalEvents(string processInstanceId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, processVariables));
    }

    @Override
    public void addUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }

    @Override
    public void addGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }

    @Override
    public void addParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }

    @Override
    public void addParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }

    @Override
    public void deleteParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }

    @Override
    public void deleteParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }

    @Override
    public void deleteUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }

    @Override
    public void deleteGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }

    @Override
    public List!IdentityLink getIdentityLinksForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetIdentityLinksForProcessInstanceCmd(processInstanceId));
    }

    @Override
    public List<EntityLink> getEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetEntityLinkChildrenForProcessInstanceCmd(processInstanceId));
    }

    @Override
    public List<EntityLink> getEntityLinkChildrenForTask(string taskId) {
        return commandExecutor.execute(new GetEntityLinkChildrenForTaskCmd(taskId));
    }

    @Override
    public List<EntityLink> getEntityLinkParentsForProcessInstance(string processInstanceId) {
        return commandExecutor.execute(new GetEntityLinkParentsForProcessInstanceCmd(processInstanceId));
    }

    @Override
    public List<EntityLink> getEntityLinkParentsForTask(string taskId) {
        return commandExecutor.execute(new GetEntityLinkParentsForTaskCmd(taskId));
    }

    @Override
    public ProcessInstanceQuery createProcessInstanceQuery() {
        return new ProcessInstanceQueryImpl(commandExecutor);
    }

    @Override
    public ActivityInstanceQueryImpl createActivityInstanceQuery() {
        return new ActivityInstanceQueryImpl(commandExecutor);
    }

    @Override
    public List!string getActiveActivityIds(string executionId) {
        return commandExecutor.execute(new FindActiveActivityIdsCmd(executionId));
    }

    public FormData getFormInstanceById(string processDefinitionId) {
        return commandExecutor.execute(new GetStartFormCmd(processDefinitionId));
    }

    @Override
    public void suspendProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new SuspendProcessInstanceCmd(processInstanceId));
    }

    @Override
    public void activateProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new ActivateProcessInstanceCmd(processInstanceId));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessage(string messageName) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessage(string messageName, Map!(string, Object) processVariables) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, Map!(string, Object) processVariables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, tenantId));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey, Map!(string, Object) processVariables) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, null));
    }

    @Override
    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, Map!(string, Object) processVariables, string tenantId) {
        return commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, tenantId));
    }

    @Override
    public void signalEventReceived(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, null));
    }

    @Override
    public void signalEventReceivedWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, tenantId));
    }

    @Override
    public void signalEventReceivedAsync(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, null));
    }

    @Override
    public void signalEventReceivedAsyncWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, tenantId));
    }

    @Override
    public void signalEventReceived(string signalName, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, null));
    }

    @Override
    public void signalEventReceivedWithTenantId(string signalName, Map!(string, Object) processVariables, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, tenantId));
    }

    @Override
    public void signalEventReceived(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, null, null));
    }

    @Override
    public void signalEventReceived(string signalName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, processVariables, null));
    }

    @Override
    public void signalEventReceivedAsync(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, true, null));
    }

    @Override
    public void messageEventReceived(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, null));
    }

    @Override
    public void messageEventReceived(string messageName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, processVariables));
    }

    @Override
    public void messageEventReceivedAsync(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, true));
    }

    @Override
    public void addEventListener(FlowableEventListener listenerToAdd) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd));
    }

    @Override
    public void addEventListener(FlowableEventListener listenerToAdd, FlowableEngineEventType... types) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd, types));
    }

    @Override
    public void removeEventListener(FlowableEventListener listenerToRemove) {
        commandExecutor.execute(new RemoveEventListenerCommand(listenerToRemove));
    }

    @Override
    public void dispatchEvent(FlowableEvent event) {
        commandExecutor.execute(new DispatchEventCommand(event));
    }

    @Override
    public void addEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new AddEventConsumerCommand(eventConsumer));
    }

    @Override
    public void removeEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new RemoveEventConsumerCommand(eventConsumer));
    }

    @Override
    public void setProcessInstanceName(string processInstanceId, string name) {
        commandExecutor.execute(new SetProcessInstanceNameCmd(processInstanceId, name));
    }

    @Override
    public List<Event> getProcessInstanceEvents(string processInstanceId) {
        return commandExecutor.execute(new GetProcessInstanceEventsCmd(processInstanceId));
    }

    @Override
    public List<Execution> getAdhocSubProcessExecutions(string processInstanceId) {
        return commandExecutor.execute(new GetActiveAdhocSubProcessesCmd(processInstanceId));
    }

    @Override
    public List<FlowNode> getEnabledActivitiesFromAdhocSubProcess(string executionId) {
        return commandExecutor.execute(new GetEnabledActivitiesForAdhocSubProcessCmd(executionId));
    }

    @Override
    public Execution executeActivityInAdhocSubProcess(string executionId, string activityId) {
        return commandExecutor.execute(new ExecuteActivityForAdhocSubProcessCmd(executionId, activityId));
    }

    @Override
    public void completeAdhocSubProcess(string executionId) {
        commandExecutor.execute(new CompleteAdhocSubProcessCmd(executionId));
    }

    @Override
    public ProcessInstanceBuilder createProcessInstanceBuilder() {
        return new ProcessInstanceBuilderImpl(this);
    }

    @Override
    public ChangeActivityStateBuilder createChangeActivityStateBuilder() {
        return new ChangeActivityStateBuilderImpl(this);
    }

    @Override
    public Execution addMultiInstanceExecution(string activityId, string parentExecutionId, Map!(string, Object) executionVariables) {
        return commandExecutor.execute(new AddMultiInstanceExecutionCmd(activityId, parentExecutionId, executionVariables));
    }

    @Override
    public void deleteMultiInstanceExecution(string executionId, bool executionIsCompleted) {
        commandExecutor.execute(new DeleteMultiInstanceExecutionCmd(executionId, executionIsCompleted));
    }

    public ProcessInstance startProcessInstance(ProcessInstanceBuilderImpl processInstanceBuilder) {
        if (processInstanceBuilder.getProcessDefinitionId() !is null || processInstanceBuilder.getProcessDefinitionKey() !is null) {
            return commandExecutor.execute(new StartProcessInstanceCmd<ProcessInstance>(processInstanceBuilder));
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
