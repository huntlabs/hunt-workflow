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
module flow.engine.impl.bpmn.behavior.BoundaryEventRegistryEventActivityBehavior;

import hunt.collection.List;

import flow.bpmn.converter.constants.BpmnXMLConstants;
import flow.bpmn.model.BoundaryEvent;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CorrelationUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.EventInstanceBpmnUtil;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.constant.EventConstants;
import flow.event.registry.model.EventModel;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.engine.impl.bpmn.behavior.BoundaryEventActivityBehavior;
import hunt.String;
/**
 * @author Tijs Rademakers
 */
class BoundaryEventRegistryEventActivityBehavior : BoundaryEventActivityBehavior {

    protected string eventDefinitionKey;

    this(string eventDefinitionKey, bool interrupting) {
        super(interrupting);
        this.eventDefinitionKey = eventDefinitionKey;
    }

    override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        EventModel eventModel = getEventModel(execution);
        EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
                        .eventType(eventModel.getKey())
                        .executionId(executionEntity.getId())
                        .processInstanceId(executionEntity.getProcessInstanceId())
                        .activityId(executionEntity.getCurrentActivityId())
                        .processDefinitionId(executionEntity.getProcessDefinitionId())
                        .scopeType(ScopeTypes.BPMN)
                        .tenantId(executionEntity.getTenantId())
                        .configuration(CorrelationUtil.getCorrelationKey(BpmnXMLConstants.ELEMENT_EVENT_CORRELATION_PARAMETER, commandContext, executionEntity))
                        .create();

        CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);
        executionEntity.getEventSubscriptions().add(eventSubscription);
    }

    protected EventModel getEventModel(DelegateExecution execution) {
        EventModel eventModel = null;
        if (ProcessEngineConfiguration.NO_TENANT_ID == execution.getTenantId()) {
            eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventDefinitionKey);
        } else {
            eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventDefinitionKey, execution.getTenantId());
        }
        return eventModel;
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        BoundaryEvent boundaryEvent = cast(BoundaryEvent) execution.getCurrentFlowElement();

        Object eventInstance = execution.getTransientVariables().get(EventConstants.EVENT_INSTANCE);
        if (cast(EventInstance)eventInstance !is null) {
            EventInstanceBpmnUtil.handleEventInstanceOutParameters(execution, boundaryEvent, cast(EventInstance) eventInstance);
        }

        if (boundaryEvent.isCancelActivity()) {
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();

            CommandContext commandContext = Context.getCommandContext();
            EventModel eventModel = getEventModel(commandContext, executionEntity);
            foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
                if (eventModel.getKey() == eventSubscription.getEventType()) {
                    eventSubscriptionService.deleteEventSubscription(eventSubscription);
                    CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
                }
            }
        }

        super.trigger(executionEntity, triggerName, triggerData);
    }

    protected EventModel getEventModel(CommandContext commandContext, ExecutionEntity executionEntity) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        string key = null;
        if (eventDefinitionKey !is null && eventDefinitionKey.length != 0) {
            Expression expression = processEngineConfiguration.getExpressionManager().createExpression(eventDefinitionKey);
            key = (cast(String) expression.getValue(executionEntity)).value;
        }

        EventModel eventModel = getEventModel(executionEntity);
        if (eventModel is null) {
            throw new FlowableException("Could not find event model for key " ~key);
        }
        return eventModel;
    }
}
