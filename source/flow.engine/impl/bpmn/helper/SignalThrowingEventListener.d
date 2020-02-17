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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.delegate.event.FlowableEngineEvent;
import flow.common.api.delegate.event.FlowableEvent;
import flow.common.api.delegate.event.FlowableEventListener;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.engine.repository.ProcessDefinition;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

/**
 * An {@link FlowableEventListener} that throws a signal event when an event is dispatched to it.
 * 
 * @author Frederik Heremans
 * 
 */
class SignalThrowingEventListener extends BaseDelegateEventListener {

    protected string signalName;
    protected bool processInstanceScope = true;

    @Override
    public void onEvent(FlowableEvent event) {
        if (isValidEvent(event) && event instanceof FlowableEngineEvent) {

            FlowableEngineEvent engineEvent = (FlowableEngineEvent) event;

            if (engineEvent.getProcessInstanceId() == null && processInstanceScope) {
                throw new FlowableIllegalArgumentException("Cannot throw process-instance scoped signal, since the dispatched event is not part of an ongoing process instance");
            }

            CommandContext commandContext = Context.getCommandContext();
            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
            List<SignalEventSubscriptionEntity> subscriptionEntities = null;
            if (processInstanceScope) {
                subscriptionEntities = eventSubscriptionService.findSignalEventSubscriptionsByProcessInstanceAndEventName(engineEvent.getProcessInstanceId(), signalName);
            } else {
                string tenantId = null;
                if (engineEvent.getProcessDefinitionId() != null) {
                    ProcessDefinition processDefinition = CommandContextUtil.getProcessEngineConfiguration(commandContext)
                            .getDeploymentManager()
                            .findDeployedProcessDefinitionById(engineEvent.getProcessDefinitionId());
                    tenantId = processDefinition.getTenantId();
                }
                subscriptionEntities = eventSubscriptionService.findSignalEventSubscriptionsByEventName(signalName, tenantId);
            }

            for (SignalEventSubscriptionEntity signalEventSubscriptionEntity : subscriptionEntities) {
                EventSubscriptionUtil.eventReceived(signalEventSubscriptionEntity, null, false);
            }
        }
    }

    public void setSignalName(string signalName) {
        this.signalName = signalName;
    }

    public void setProcessInstanceScope(bool processInstanceScope) {
        this.processInstanceScope = processInstanceScope;
    }

    @Override
    public bool isFailOnException() {
        return true;
    }
}
