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

module flow.engine.impl.RuntimeServiceImpl;

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
import hunt.Exceptions;
//import flow.engine.impl.runtime.ChangeActivityStateBuilderImpl;
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
import flow.engine.impl.ExecutionQueryImpl;
import flow.engine.impl.ProcessInstanceQueryImpl;
import flow.engine.impl.ActivityInstanceQueryImpl;
import hunt.Boolean;
//import flow.engine.impl.NativeExecutionQueryImpl;
//import flow.engine.impl.NativeProcessInstanceQueryImpl;
//import flow.engine.impl.NativeProcessInstanceQueryImpl;
/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 */
class RuntimeServiceImpl : CommonEngineServiceImpl!ProcessEngineConfigurationImpl , RuntimeService {


    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, null, null)));
    }


    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, businessKey, null)));
    }


    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, Map!(string, Object) variables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, null, variables)));
    }


    public ProcessInstance startProcessInstanceByKey(string processDefinitionKey, string businessKey, Map!(string, Object) variables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, businessKey, variables)));
    }


    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, null, null, tenantId)));
    }


    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, businessKey, null, tenantId)));
    }


    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, Map!(string, Object) variables, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, null, variables, tenantId)));
    }


    public ProcessInstance startProcessInstanceByKeyAndTenantId(string processDefinitionKey, string businessKey, Map!(string, Object) variables, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processDefinitionKey, null, businessKey, variables, tenantId)));
    }


    public ProcessInstance startProcessInstanceById(string processDefinitionId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(null, processDefinitionId, null, null)));
    }


    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(null, processDefinitionId, businessKey, null)));
    }


    public ProcessInstance startProcessInstanceById(string processDefinitionId, Map!(string, Object) variables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(null, processDefinitionId, null, variables)));
    }


    public ProcessInstance startProcessInstanceById(string processDefinitionId, string businessKey, Map!(string, Object) variables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(null, processDefinitionId, businessKey, variables)));
    }


    public ProcessInstance startProcessInstanceWithForm(string processDefinitionId, string outcome, Map!(string, Object) variables, string processInstanceName) {
        ProcessInstanceBuilder processInstanceBuilder = createProcessInstanceBuilder()
            .processDefinitionId(processDefinitionId)
            .outcome(outcome)
            .startFormVariables(variables)
            .name(processInstanceName);
        return processInstanceBuilder.start();
    }


    public FormInfo getStartFormModel(string processDefinitionId, string processInstanceId) {
        return cast(FormInfo)(commandExecutor.execute(new GetStartFormModelCmd(processDefinitionId, processInstanceId)));
    }


    public void deleteProcessInstance(string processInstanceId, string deleteReason) {
        commandExecutor.execute(new DeleteProcessInstanceCmd(processInstanceId, deleteReason));
    }


    public ExecutionQuery createExecutionQuery() {
        return new ExecutionQueryImpl(commandExecutor);
    }


    public NativeExecutionQuery createNativeExecutionQuery() {
          implementationMissing(false);
          return null;
       // return new NativeExecutionQueryImpl(commandExecutor);
    }
    //
    //
    public NativeProcessInstanceQuery createNativeProcessInstanceQuery() {
          implementationMissing(false);
          return null;
       // return new NativeProcessInstanceQueryImpl(commandExecutor);
    }
    //
    //
    //public NativeActivityInstanceQueryImpl createNativeActivityInstanceQuery() {
    //    return new NativeActivityInstanceQueryImpl(commandExecutor);
    //}


    public EventSubscriptionQuery createEventSubscriptionQuery() {
        return new EventSubscriptionQueryImpl(commandExecutor);
    }


    public void updateBusinessKey(string processInstanceId, string businessKey) {
        commandExecutor.execute(new SetProcessInstanceBusinessKeyCmd(processInstanceId, businessKey));
    }


    public Map!(string, Object) getVariables(string executionId) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, false)));
    }


    public Map!(string, VariableInstance) getVariableInstances(string executionId) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, false)));
    }


    public List!VariableInstance getVariableInstancesByExecutionIds(Set!string executionIds) {
        return cast(List!VariableInstance)(commandExecutor.execute(new GetExecutionsVariablesCmd(executionIds)));
    }


    public Map!(string, Object) getVariablesLocal(string executionId) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetExecutionVariablesCmd(executionId, null, true)));
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(string executionId) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, null, true)));
    }


    public Map!(string, Object) getVariables(string executionId, Collection!string variableNames) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, false)));
    }


    public Map!(string, VariableInstance) getVariableInstances(string executionId, Collection!string variableNames) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, false)));
    }


    public Map!(string, Object) getVariablesLocal(string executionId, Collection!string variableNames) {
        return cast(Map!(string, Object))(commandExecutor.execute(new GetExecutionVariablesCmd(executionId, variableNames, true)));
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(string executionId, Collection!string variableNames) {
        return cast(Map!(string, VariableInstance))(commandExecutor.execute(new GetExecutionVariableInstancesCmd(executionId, variableNames, true)));
    }


    public Object getVariable(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, false));
    }


    public VariableInstance getVariableInstance(string executionId, string variableName) {
        return cast(VariableInstance)(commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, false)));
    }


    //public <T> T getVariable(string executionId, string variableName, Class!T variableClass) {
    //    return variableClass.cast(getVariable(executionId, variableName));
    //}


    public bool hasVariable(string executionId, string variableName) {
        return (cast(Boolean)(commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, false)))).booleanValue();
    }


    public Object getVariableLocal(string executionId, string variableName) {
        return commandExecutor.execute(new GetExecutionVariableCmd(executionId, variableName, true));
    }


    public VariableInstance getVariableInstanceLocal(string executionId, string variableName) {
        return cast(VariableInstance)(commandExecutor.execute(new GetExecutionVariableInstanceCmd(executionId, variableName, true)));
    }


    //public <T> T getVariableLocal(string executionId, string variableName, Class!T variableClass) {
    //    return variableClass.cast(getVariableLocal(executionId, variableName));
    //}


    public bool hasVariableLocal(string executionId, string variableName) {
        return (cast(Boolean)(commandExecutor.execute(new HasExecutionVariableCmd(executionId, variableName, true)))).booleanValue();
    }


    public void setVariable(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap!(string, Object)();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }


    public void setVariableLocal(string executionId, string variableName, Object value) {
        if (variableName is null) {
            throw new FlowableIllegalArgumentException("variableName is null");
        }
        Map!(string, Object) variables = new HashMap!(string, Object)();
        variables.put(variableName, value);
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }


    public void setVariables(string executionId, Map!(string, Object) variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, false));
    }


    public void setVariablesLocal(string executionId, Map!(string, Object) variables) {
        commandExecutor.execute(new SetExecutionVariablesCmd(executionId, variables, true));
    }


    public void removeVariable(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList!string(1);
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }


    public void removeVariableLocal(string executionId, string variableName) {
        Collection!string variableNames = new ArrayList!string();
        variableNames.add(variableName);
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }


    public void removeVariables(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, false));
    }


    public void removeVariablesLocal(string executionId, Collection!string variableNames) {
        commandExecutor.execute(new RemoveExecutionVariablesCmd(executionId, variableNames, true));
    }


    public Map!(string, DataObject) getDataObjects(string executionId) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false)));
    }


    public Map!(string, DataObject) getDataObjects(string executionId, string locale, bool withLocalizationFallback) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, null, false, locale, withLocalizationFallback)));
    }


    public Map!(string, DataObject) getDataObjectsLocal(string executionId) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true)));
    }


    public Map!(string, DataObject) getDataObjectsLocal(string executionId, string locale, bool withLocalizationFallback) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, null, true, locale, withLocalizationFallback)));
    }


    public Map!(string, DataObject) getDataObjects(string executionId, Collection!string dataObjectNames) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false)));
    }


    public Map!(string, DataObject) getDataObjects(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, false, locale, withLocalizationFallback)));
    }


    public Map!(string, DataObject) getDataObjectsLocal(string executionId, Collection!string dataObjects) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjects, true)));
    }


    public Map!(string, DataObject) getDataObjectsLocal(string executionId, Collection!string dataObjectNames, string locale, bool withLocalizationFallback) {
        return cast(Map!(string, DataObject))(commandExecutor.execute(new GetDataObjectsCmd(executionId, dataObjectNames, true, locale, withLocalizationFallback)));
    }


    public DataObject getDataObject(string executionId, string dataObject) {
        return cast(DataObject)(commandExecutor.execute(new GetDataObjectCmd(executionId, dataObject, false)));
    }


    public DataObject getDataObject(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return cast(DataObject)(commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, false, locale, withLocalizationFallback)));
    }


    public DataObject getDataObjectLocal(string executionId, string dataObjectName) {
        return cast(DataObject)(commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true)));
    }


    public DataObject getDataObjectLocal(string executionId, string dataObjectName, string locale, bool withLocalizationFallback) {
        return cast(DataObject)(commandExecutor.execute(new GetDataObjectCmd(executionId, dataObjectName, true, locale, withLocalizationFallback)));
    }

    public void signal(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }


    public void trigger(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null));
    }


    public void triggerAsync(string executionId) {
        commandExecutor.execute(new TriggerCmd(executionId, null, true));
    }

    public void signal(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }


    public void trigger(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables));
    }


    public void triggerAsync(string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, true));
    }


    public void trigger(string executionId, Map!(string, Object) processVariables, Map!(string, Object) transientVariables) {
        commandExecutor.execute(new TriggerCmd(executionId, processVariables, transientVariables));
    }


    public void evaluateConditionalEvents(string processInstanceId) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, null));
    }


    public void evaluateConditionalEvents(string processInstanceId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new EvaluateConditionalEventsCmd(processInstanceId, processVariables));
    }


    public void addUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }


    public void addGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }


    public void addParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }


    public void addParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new AddIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }


    public void deleteParticipantUser(string processInstanceId, string userId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, IdentityLinkType.PARTICIPANT));
    }


    public void deleteParticipantGroup(string processInstanceId, string groupId) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, IdentityLinkType.PARTICIPANT));
    }


    public void deleteUserIdentityLink(string processInstanceId, string userId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, userId, null, identityLinkType));
    }


    public void deleteGroupIdentityLink(string processInstanceId, string groupId, string identityLinkType) {
        commandExecutor.execute(new DeleteIdentityLinkForProcessInstanceCmd(processInstanceId, null, groupId, identityLinkType));
    }


    public List!IdentityLink getIdentityLinksForProcessInstance(string processInstanceId) {
        return cast(List!IdentityLink)(commandExecutor.execute(new GetIdentityLinksForProcessInstanceCmd(processInstanceId)));
    }


    public List!EntityLink getEntityLinkChildrenForProcessInstance(string processInstanceId) {
        return cast(List!EntityLink)(commandExecutor.execute(new GetEntityLinkChildrenForProcessInstanceCmd(processInstanceId)));
    }


    public List!EntityLink getEntityLinkChildrenForTask(string taskId) {
        return cast(List!EntityLink)(commandExecutor.execute(new GetEntityLinkChildrenForTaskCmd(taskId)));
    }


    public List!EntityLink getEntityLinkParentsForProcessInstance(string processInstanceId) {
        return cast(List!EntityLink)(commandExecutor.execute(new GetEntityLinkParentsForProcessInstanceCmd(processInstanceId)));
    }


    public List!EntityLink getEntityLinkParentsForTask(string taskId) {
        return cast(List!EntityLink)(commandExecutor.execute(new GetEntityLinkParentsForTaskCmd(taskId)));
    }


    public ProcessInstanceQuery createProcessInstanceQuery() {
        return new ProcessInstanceQueryImpl(commandExecutor);
    }


    public ActivityInstanceQueryImpl createActivityInstanceQuery() {
        return new ActivityInstanceQueryImpl(commandExecutor);
    }


    public List!string getActiveActivityIds(string executionId) {
        return cast(List!string)(commandExecutor.execute(new FindActiveActivityIdsCmd(executionId)));
    }

    public FormData getFormInstanceById(string processDefinitionId) {
        return cast(FormData)(commandExecutor.execute(new GetStartFormCmd(processDefinitionId)));
    }


    public void suspendProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new SuspendProcessInstanceCmd(processInstanceId));
    }


    public void activateProcessInstanceById(string processInstanceId) {
        commandExecutor.execute(new ActivateProcessInstanceCmd(processInstanceId));
    }


    public ProcessInstance startProcessInstanceByMessage(string messageName) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, null)));
    }


    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, null, tenantId)));
    }


    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, null)));
    }


    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, null, tenantId)));
    }


    public ProcessInstance startProcessInstanceByMessage(string messageName, Map!(string, Object) processVariables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, null)));
    }


    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, Map!(string, Object) processVariables, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, null, processVariables, tenantId)));
    }


    public ProcessInstance startProcessInstanceByMessage(string messageName, string businessKey, Map!(string, Object) processVariables) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, null)));
    }


    public ProcessInstance startProcessInstanceByMessageAndTenantId(string messageName, string businessKey, Map!(string, Object) processVariables, string tenantId) {
        return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(messageName, businessKey, processVariables, tenantId)));
    }


    public void signalEventReceived(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, null));
    }


    public void signalEventReceivedWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, null, tenantId));
    }


    public void signalEventReceivedAsync(string signalName) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, null));
    }


    public void signalEventReceivedAsyncWithTenantId(string signalName, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, true, tenantId));
    }


    public void signalEventReceived(string signalName, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, null));
    }


    public void signalEventReceivedWithTenantId(string signalName, Map!(string, Object) processVariables, string tenantId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, null, processVariables, tenantId));
    }


    public void signalEventReceived(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, null, null));
    }


    public void signalEventReceived(string signalName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, processVariables, null));
    }


    public void signalEventReceivedAsync(string signalName, string executionId) {
        commandExecutor.execute(new SignalEventReceivedCmd(signalName, executionId, true, null));
    }


    public void messageEventReceived(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, null));
    }


    public void messageEventReceived(string messageName, string executionId, Map!(string, Object) processVariables) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, processVariables));
    }


    public void messageEventReceivedAsync(string messageName, string executionId) {
        commandExecutor.execute(new MessageEventReceivedCmd(messageName, executionId, true));
    }


    public void addEventListener(FlowableEventListener listenerToAdd) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd));
    }


    public void addEventListener(FlowableEventListener listenerToAdd, FlowableEngineEventType[] types) {
        commandExecutor.execute(new AddEventListenerCommand(listenerToAdd, types));
    }


    public void removeEventListener(FlowableEventListener listenerToRemove) {
        commandExecutor.execute(new RemoveEventListenerCommand(listenerToRemove));
    }


    public void dispatchEvent(FlowableEvent event) {
        commandExecutor.execute(new DispatchEventCommand(event));
    }


    public void addEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new AddEventConsumerCommand(eventConsumer));
    }


    public void removeEventRegistryConsumer(EventRegistryEventConsumer eventConsumer) {
        commandExecutor.execute(new RemoveEventConsumerCommand(eventConsumer));
    }


    public void setProcessInstanceName(string processInstanceId, string name) {
        commandExecutor.execute(new SetProcessInstanceNameCmd(processInstanceId, name));
    }


    public List!Event getProcessInstanceEvents(string processInstanceId) {
        return cast(List!Event)(commandExecutor.execute(new GetProcessInstanceEventsCmd(processInstanceId)));
    }


    public List!Execution getAdhocSubProcessExecutions(string processInstanceId) {
        return cast(List!Execution)(commandExecutor.execute(new GetActiveAdhocSubProcessesCmd(processInstanceId)));
    }


    public List!FlowNode getEnabledActivitiesFromAdhocSubProcess(string executionId) {
        return cast(List!FlowNode)(commandExecutor.execute(new GetEnabledActivitiesForAdhocSubProcessCmd(executionId)));
    }


    public Execution executeActivityInAdhocSubProcess(string executionId, string activityId) {
        return cast(Execution)(commandExecutor.execute(new ExecuteActivityForAdhocSubProcessCmd(executionId, activityId)));
    }


    public void completeAdhocSubProcess(string executionId) {
        commandExecutor.execute(new CompleteAdhocSubProcessCmd(executionId));
    }


    public ProcessInstanceBuilder createProcessInstanceBuilder() {
        return new ProcessInstanceBuilderImpl(this);
    }


    public ChangeActivityStateBuilder createChangeActivityStateBuilder() {
          implementationMissing(false);
          return null;
        //return new ChangeActivityStateBuilderImpl(this);
    }


    public Execution addMultiInstanceExecution(string activityId, string parentExecutionId, Map!(string, Object) executionVariables) {
        return cast(Execution)(commandExecutor.execute(new AddMultiInstanceExecutionCmd(activityId, parentExecutionId, executionVariables)));
    }


    public void deleteMultiInstanceExecution(string executionId, bool executionIsCompleted) {
        commandExecutor.execute(new DeleteMultiInstanceExecutionCmd(executionId, executionIsCompleted));
    }

    public ProcessInstance startProcessInstance(ProcessInstanceBuilderImpl processInstanceBuilder) {
        if ((processInstanceBuilder.getProcessDefinitionId() !is null && processInstanceBuilder.getProcessDefinitionId().length != 0)|| (processInstanceBuilder.getProcessDefinitionKey() !is null && processInstanceBuilder.getProcessDefinitionKey().length !=0 )) {
            return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceCmd(processInstanceBuilder)));
        } else if (processInstanceBuilder.getMessageName() !is null && processInstanceBuilder.getMessageName().length != 0) {
            return cast(ProcessInstance)(commandExecutor.execute(new StartProcessInstanceByMessageCmd(processInstanceBuilder)));
        } else {
            throw new FlowableIllegalArgumentException("No processDefinitionId, processDefinitionKey nor messageName provided");
        }
    }

    public ProcessInstance startProcessInstanceAsync(ProcessInstanceBuilderImpl processInstanceBuilder) {
        if ((processInstanceBuilder.getProcessDefinitionId() !is null && processInstanceBuilder.getProcessDefinitionId().length != 0)|| (processInstanceBuilder.getProcessDefinitionKey() !is null && processInstanceBuilder.getProcessDefinitionKey().length != 0)) {
            return cast(ProcessInstance) commandExecutor.execute(new StartProcessInstanceAsyncCmd(processInstanceBuilder));
        } else {
            throw new FlowableIllegalArgumentException("No processDefinitionId, processDefinitionKey provided");
        }
    }

    //public void changeActivityState(ChangeActivityStateBuilderImpl changeActivityStateBuilder) {
    //    commandExecutor.execute(new ChangeActivityStateCmd(changeActivityStateBuilder));
    //}

}
