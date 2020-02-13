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


import java.util.List;
import java.util.Objects;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.constants.BpmnXMLConstants;
import org.flowable.bpmn.model.BoundaryEvent;
import flow.common.api.FlowableException;
import flow.common.api.delegate.Expression;
import flow.common.api.scope.ScopeTypes;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.delegate.DelegateExecution;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CorrelationUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.EventInstanceBpmnUtil;
import org.flowable.eventregistry.api.runtime.EventInstance;
import org.flowable.eventregistry.impl.constant.EventConstants;
import org.flowable.eventregistry.model.EventModel;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Tijs Rademakers
 */
class BoundaryEventRegistryEventActivityBehavior extends BoundaryEventActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected string eventDefinitionKey;

    public BoundaryEventRegistryEventActivityBehavior(string eventDefinitionKey, bool interrupting) {
        super(interrupting);
        this.eventDefinitionKey = eventDefinitionKey;
    }

    @Override
    public void execute(DelegateExecution execution) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

        EventModel eventModel = getEventModel(execution);
        EventSubscriptionEntity eventSubscription = (EventSubscriptionEntity) CommandContextUtil.getEventSubscriptionService(commandContext).createEventSubscriptionBuilder()
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
        if (Objects.equals(ProcessEngineConfiguration.NO_TENANT_ID, execution.getTenantId())) {
            eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventDefinitionKey);
        } else {
            eventModel = CommandContextUtil.getEventRepositoryService().getEventModelByKey(eventDefinitionKey, execution.getTenantId());
        }
        return eventModel;
    }

    @Override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        BoundaryEvent boundaryEvent = (BoundaryEvent) execution.getCurrentFlowElement();
        
        Object eventInstance = execution.getTransientVariables().get(EventConstants.EVENT_INSTANCE);
        if (eventInstance instanceof EventInstance) {
            EventInstanceBpmnUtil.handleEventInstanceOutParameters(execution, boundaryEvent, (EventInstance) eventInstance);
        }

        if (boundaryEvent.isCancelActivity()) {
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
            List<EventSubscriptionEntity> eventSubscriptions = executionEntity.getEventSubscriptions();
            
            CommandContext commandContext = Context.getCommandContext();
            EventModel eventModel = getEventModel(commandContext, executionEntity);
            for (EventSubscriptionEntity eventSubscription : eventSubscriptions) {
                if (Objects.equals(eventModel.getKey(), eventSubscription.getEventType())) {
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
        if (StringUtils.isNotEmpty(eventDefinitionKey)) {
            Expression expression = processEngineConfiguration.getExpressionManager().createExpression(eventDefinitionKey);
            key = expression.getValue(executionEntity).toString();
        }

        EventModel eventModel = getEventModel(executionEntity);
        if (eventModel == null) {
            throw new FlowableException("Could not find event model for key " +key);
        }
        return eventModel;
    }
}