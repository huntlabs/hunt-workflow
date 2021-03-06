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
module flow.engine.impl.eventregistry.BpmnEventRegistryEventConsumer;

import hunt.collection;
import hunt.collection.Collections;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.Exceptions;
import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.StartEvent;
import flow.common.api.constant.ReferenceTypes;
import flow.common.api.scop.ScopeTypes;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.RuntimeService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.runtime.ProcessInstanceBuilder;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.constant.EventConstants;
import flow.event.registry.consumer.BaseEventRegistryEventConsumer;
import flow.event.registry.consumer.CorrelationKey;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.api.EventSubscriptionQuery;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;

class BpmnEventRegistryEventConsumer : BaseEventRegistryEventConsumer  {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

   this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);

        this.processEngineConfiguration = processEngineConfiguration;
    }

    public string getConsumerKey() {
        return "bpmnEventConsumer";
    }

    override
    protected void eventReceived(EventInstance eventInstance) {

        // Fetching the event subscriptions happens in one transaction,
        // executing them one per subscription. There is no overarching transaction.
        // The reason for this is that the handling of one event subscription
        // should not influence (i.e. roll back) the handling of another.

        Collection!CorrelationKey correlationKeys = generateCorrelationKeys(eventInstance.getCorrelationParameterInstances());
        List!EventSubscription eventSubscriptions = findEventSubscriptions(ScopeTypes.BPMN, eventInstance, correlationKeys);
        RuntimeService runtimeService = processEngineConfiguration.getRuntimeService();
        foreach (EventSubscription eventSubscription ; eventSubscriptions) {
            handleEventSubscription(runtimeService, eventSubscription, eventInstance, correlationKeys);
        }
    }

    protected void handleEventSubscription(RuntimeService runtimeService, EventSubscription eventSubscription,
            EventInstance eventInstance, Collection!CorrelationKey correlationKeys) {

        if (eventSubscription.getExecutionId() !is null) {

            // When an executionId is set, this means that the process instance is waiting at that step for an event

            Map!(string, Object) transientVariableMap = new HashMap!(string, Object)();
            transientVariableMap.put(EventConstants.EVENT_INSTANCE, cast(Object)eventInstance);
            runtimeService.trigger(eventSubscription.getExecutionId(), null, transientVariableMap);

        } else if (eventSubscription.getProcessDefinitionId() !is null
                        && eventSubscription.getProcessInstanceId() is null && eventSubscription.getExecutionId() is null) {

            // If there is no execution/process instance set, but a definition id is set, this means that it's a start event

            ProcessInstanceBuilder processInstanceBuilder = runtimeService.createProcessInstanceBuilder()
                .processDefinitionId(eventSubscription.getProcessDefinitionId())
                .transientVariable(EventConstants.EVENT_INSTANCE, cast(Object)eventInstance);

            if (eventInstance.getTenantId() !is null && (ProcessEngineConfiguration.NO_TENANT_ID != eventInstance.getTenantId())) {
                processInstanceBuilder.overrideProcessDefinitionTenantId(eventInstance.getTenantId());
            }

            if (correlationKeys !is null) {
                string startCorrelationConfiguration = getStartCorrelationConfiguration(eventSubscription);

                if (startCorrelationConfiguration ==  BpmnXMLConstants.START_EVENT_CORRELATION_STORE_AS_UNIQUE_REFERENCE_ID) {

                    CorrelationKey correlationKeyWithAllParameters = getCorrelationKeyWithAllParameters(correlationKeys);

                    long processInstanceCount = runtimeService.createProcessInstanceQuery()
                        .processDefinitionId(eventSubscription.getProcessDefinitionId())
                        .processInstanceReferenceId(correlationKeyWithAllParameters.getValue())
                        .processInstanceReferenceType(ReferenceTypes.EVENT_PROCESS)
                        .count();

                    if (processInstanceCount > 0) {
                        // Returning, no new instance should be started
                      //  LOGGER.debug("Event received to start a new process instance, but a unique instance already exists.");
                        return;
                    }

                    processInstanceBuilder.referenceId(correlationKeyWithAllParameters.getValue());
                    processInstanceBuilder.referenceType(ReferenceTypes.EVENT_PROCESS);

                }
            }

            processInstanceBuilder.startAsync();
        }

    }

    protected string getStartCorrelationConfiguration(EventSubscription eventSubscription) {
        BpmnModel bpmnModel = processEngineConfiguration.getRepositoryService().getBpmnModel(eventSubscription.getProcessDefinitionId());
        if (bpmnModel !is null) {

            // There are potentially multiple start events, with different configurations.
            // The one that has the matching eventType needs to be used
            implementationMissing(false);

            //List!StartEvent startEvents = bpmnModel.getMainProcess().findFlowElementsOfType!StartEvent(typeid(StartEvent));
            //foreach (StartEvent startEvent ; startEvents) {
            //    List!ExtensionElement eventTypes = startEvent.getExtensionElements().get(BpmnXMLConstants.ELEMENT_EVENT_TYPE);
            //    if (eventTypes !is null && !eventTypes.isEmpty()
            //            && (eventSubscription.getEventType() ==  eventTypes.get(0).getElementText())) {
            //
            //        List!ExtensionElement correlationCfgExtensions = startEvent.getExtensionElements()
            //            .getOrDefault(BpmnXMLConstants.START_EVENT_CORRELATION_CONFIGURATION, Collections.emptyList!ExtensionElement());
            //        if (!correlationCfgExtensions.isEmpty()) {
            //            return correlationCfgExtensions.get(0).getElementText();
            //        }
            //    }
            //}

        }

        return null;
    }

    override
    protected EventSubscriptionQuery createEventSubscriptionQuery() {
        return new EventSubscriptionQueryImpl(commandExecutor);
    }

}
