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



import hunt.collection.List;

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.Signal;
import flow.bpmn.model.SignalEventDefinition;
import flow.bpmn.model.ThrowEvent;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.scop.ScopeTypes;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.entitylink.service.api.EntityLink;
import flow.entitylink.service.api.EntityLinkType;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

/**
 * @author Tijs Rademakers
 */
class IntermediateThrowSignalEventActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected final SignalEventDefinition signalEventDefinition;
    protected string signalEventName;
    protected string signalExpression;
    protected bool processInstanceScope;

    public IntermediateThrowSignalEventActivityBehavior(ThrowEvent throwEvent, SignalEventDefinition signalEventDefinition, Signal signal) {
        if (signal !is null) {
            signalEventName = signal.getName();
            if (Signal.SCOPE_PROCESS_INSTANCE.equals(signal.getScope())) {
                this.processInstanceScope = true;
            }
        } else if (StringUtils.isNotEmpty(signalEventDefinition.getSignalRef())) {
            signalEventName = signalEventDefinition.getSignalRef();
        } else {
            signalExpression = signalEventDefinition.getSignalExpression();
        }

        this.signalEventDefinition = signalEventDefinition;
    }

    @Override
    public void execute(DelegateExecution execution) {

        CommandContext commandContext = Context.getCommandContext();

        string eventSubscriptionName = null;
        if (signalEventName !is null) {
            eventSubscriptionName = signalEventName;
        } else {
            Expression expressionObject = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(signalExpression);
            eventSubscriptionName = expressionObject.getValue(execution).toString();
        }

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        List<SignalEventSubscriptionEntity> subscriptionEntities = null;
        if (processInstanceScope) {
            subscriptionEntities = eventSubscriptionService.findSignalEventSubscriptionsByProcessInstanceAndEventName(
                            execution.getProcessInstanceId(), eventSubscriptionName);

            if (CommandContextUtil.getProcessEngineConfiguration(commandContext).isEnableEntityLinks()) {
                List<EntityLink> entityLinks = CommandContextUtil.getEntityLinkService(commandContext).findEntityLinksByReferenceScopeIdAndType(
                                execution.getProcessInstanceId(), ScopeTypes.BPMN, EntityLinkType.CHILD);
                if (entityLinks !is null) {
                    for (EntityLink entityLink : entityLinks) {
                        if (ScopeTypes.BPMN.equals(entityLink.getScopeType())) {
                            subscriptionEntities.addAll(eventSubscriptionService.findSignalEventSubscriptionsByProcessInstanceAndEventName(
                                            entityLink.getScopeId(), eventSubscriptionName));

                        } else if (ScopeTypes.CMMN.equals(entityLink.getScopeType())) {
                            subscriptionEntities.addAll(eventSubscriptionService.findSignalEventSubscriptionsByScopeAndEventName(
                                            entityLink.getScopeId(), ScopeTypes.CMMN, eventSubscriptionName));
                        }
                    }
                }
            }

        } else {
            subscriptionEntities = eventSubscriptionService
                    .findSignalEventSubscriptionsByEventName(eventSubscriptionName, execution.getTenantId());
        }

        for (SignalEventSubscriptionEntity signalEventSubscriptionEntity : subscriptionEntities) {
            CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNALED, signalEventSubscriptionEntity.getActivityId(), eventSubscriptionName,
                            null, signalEventSubscriptionEntity.getExecutionId(), signalEventSubscriptionEntity.getProcessInstanceId(),
                            signalEventSubscriptionEntity.getProcessDefinitionId()));

            if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, signalEventSubscriptionEntity.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                compatibilityHandler.signalEventReceived(signalEventSubscriptionEntity, null, signalEventDefinition.isAsync());

            } else {
                EventSubscriptionUtil.eventReceived(signalEventSubscriptionEntity, null, signalEventDefinition.isAsync());
            }
        }

        CommandContextUtil.getAgenda(commandContext).planTakeOutgoingSequenceFlowsOperation((ExecutionEntity) execution, true);
    }

}
