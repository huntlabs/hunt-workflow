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
module flow.engine.impl.bpmn.behavior.SendEventTaskActivityBehavior;


import hunt.collection;
import hunt.collection.Collections;
import hunt.collection.List;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.SendEventServiceTask;
import flow.common.api.FlowableException;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.jobexecutor.AsyncSendEventJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CorrelationUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.EventInstanceBpmnUtil;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.api.runtime.EventPayloadInstance;
import flow.event.registry.constant.EventConstants;
import flow.event.registry.runtime.EventInstanceImpl;
import flow.event.registry.model.EventModel;
//import flow.eventsubscription.service.EventSubscriptionService;
//import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
/**
 * Sends an event to the event registry
 *
 * @author Tijs Rademakers
 */
class SendEventTaskActivityBehavior : AbstractBpmnActivityBehavior {

    protected SendEventServiceTask sendEventServiceTask;

    this(SendEventServiceTask sendEventServiceTask) {
        this.sendEventServiceTask = sendEventServiceTask;
    }

    override
    public void execute(DelegateExecution execution) {
        EventRegistry eventRegistry = CommandContextUtil.getEventRegistry();

        EventModel eventDefinition = null;
        if (ProcessEngineConfiguration.NO_TENANT_ID == execution.getTenantId()) {
            eventDefinition = CommandContextUtil.getEventRepositoryService().getEventModelByKey(sendEventServiceTask.getEventType());
        } else {
            eventDefinition = CommandContextUtil.getEventRepositoryService().getEventModelByKey(sendEventServiceTask.getEventType(),
                            execution.getTenantId());
        }

        if (eventDefinition is null) {
            throw new FlowableException("No event definition found for event key " ~ sendEventServiceTask.getEventType());
        }
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        bool sendSynchronously = sendEventServiceTask.isSendSynchronously();
        if (!sendSynchronously) {
            JobService jobService = CommandContextUtil.getJobService();

            JobEntity job = jobService.createJob();
            job.setExecutionId(execution.getId());
            job.setProcessInstanceId(execution.getProcessInstanceId());
            job.setProcessDefinitionId(execution.getProcessDefinitionId());
            job.setElementId(sendEventServiceTask.getId());
            job.setElementName(sendEventServiceTask.getName());
            job.setJobHandlerType(AsyncSendEventJobHandler.TYPE);

            // Inherit tenant id (if applicable)
            if (execution.getTenantId() !is null) {
                job.setTenantId(execution.getTenantId());
            }

            executionEntity.getJobs().add(job);

            jobService.createAsyncJob(job, true);
            jobService.scheduleAsyncJob(job);
        } else {
            Collection!EventPayloadInstance eventPayloadInstances = EventInstanceBpmnUtil.createEventPayloadInstances(executionEntity,
                CommandContextUtil.getProcessEngineConfiguration(CommandContextUtil.getCommandContext()).getExpressionManager(),
                execution.getCurrentFlowElement(),
                eventDefinition);
            EventInstanceImpl eventInstance = new EventInstanceImpl(eventDefinition, Collections.emptyList(), eventPayloadInstances);
            eventRegistry.sendEventOutbound(eventInstance);
        }

        if (sendEventServiceTask.isTriggerable()) {
            EventModel triggerEventDefinition = null;
            if (sendEventServiceTask.getTriggerEventType() !is null && sendEventServiceTask.getTriggerEventType().length != 0 ) {

                if (ProcessEngineConfiguration.NO_TENANT_ID == execution.getTenantId()) {
                    triggerEventDefinition = CommandContextUtil.getEventRepositoryService().getEventModelByKey(sendEventServiceTask.getTriggerEventType());
                } else {
                    triggerEventDefinition = CommandContextUtil.getEventRepositoryService().getEventModelByKey(sendEventServiceTask.getTriggerEventType(),
                                    execution.getTenantId());
                }

            } else {
                triggerEventDefinition = eventDefinition;
            }

            EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService().createEventSubscriptionBuilder()
                    .eventType(triggerEventDefinition.getKey())
                    .executionId(execution.getId())
                    .processInstanceId(execution.getProcessInstanceId())
                    .activityId(execution.getCurrentActivityId())
                    .processDefinitionId(execution.getProcessDefinitionId())
                    .scopeType(ScopeTypes.BPMN)
                    .tenantId(execution.getTenantId())
                    .configuration(CorrelationUtil.getCorrelationKey(BpmnXMLConstants.ELEMENT_TRIGGER_EVENT_CORRELATION_PARAMETER,
                                    Context.getCommandContext(), executionEntity))
                    .create();

            CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
            executionEntity.getEventSubscriptions().add(eventSubscription);
        } else if (sendSynchronously) {
            // If ths send task is specifically marked to send synchronously and is not triggerable then leave
            leave(execution);
        }
    }

    override
    public void trigger(DelegateExecution execution, string signalName, Object signalData) {
        if (sendEventServiceTask.isTriggerable()) {
            Object eventInstance = execution.getTransientVariables().get(EventConstants.EVENT_INSTANCE);
            if (cast(EventInstance)eventInstance !is null) {
                EventInstanceBpmnUtil.handleEventInstanceOutParameters(execution, sendEventServiceTask, cast(EventInstance) eventInstance);
            }

            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
            List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();

            string eventType = null;
            if (sendEventServiceTask.getTriggerEventType() !is null && sendEventServiceTask.getTriggerEventType().length != 0) {
                eventType = sendEventServiceTask.getTriggerEventType();
            } else {
                eventType = sendEventServiceTask.getEventType();
            }

            EventModel eventModel = null;
            if (ProcessEngineConfiguration.NO_TENANT_ID == execution.getTenantId()) {
                eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventType);
            } else {
                eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventType, execution.getTenantId());
            }

            foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
                if (eventModel.getKey() == eventSubscription.getEventType()) {
                    eventSubscriptionService.deleteEventSubscription(eventSubscription);
                }
            }

            leave(execution);
        }
    }
}
