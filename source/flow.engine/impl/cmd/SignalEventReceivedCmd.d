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



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.runtime.Execution;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class SignalEventReceivedCmd implements Command<Void> {

    protected final string eventName;
    protected final string executionId;
    protected final Map<string, Object> payload;
    protected final bool async;
    protected string tenantId;

    public SignalEventReceivedCmd(string eventName, string executionId, Map<string, Object> processVariables, string tenantId) {
        this.eventName = eventName;
        this.executionId = executionId;
        if (processVariables !is null) {
            this.payload = new HashMap<>(processVariables);

        } else {
            this.payload = null;
        }
        this.async = false;
        this.tenantId = tenantId;
    }

    public SignalEventReceivedCmd(string eventName, string executionId, bool async, string tenantId) {
        this.eventName = eventName;
        this.executionId = executionId;
        this.async = async;
        this.payload = null;
        this.tenantId = tenantId;
    }

    @Override
    public Void execute(CommandContext commandContext) {

        List<SignalEventSubscriptionEntity> signalEvents = null;

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        if (executionId is null) {
            signalEvents = eventSubscriptionService.findSignalEventSubscriptionsByEventName(eventName, tenantId);
        } else {

            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);

            if (execution is null) {
                throw new FlowableObjectNotFoundException("Cannot find execution with id '" + executionId + "'", Execution.class);
            }

            if (execution.isSuspended()) {
                throw new FlowableException("Cannot throw signal event '" + eventName + "' because execution '" + executionId + "' is suspended");
            }

            if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                compatibilityHandler.signalEventReceived(eventName, executionId, payload, async, tenantId);
                return null;
            }

            signalEvents = eventSubscriptionService.findSignalEventSubscriptionsByNameAndExecution(eventName, executionId);

            if (signalEvents.isEmpty()) {
                throw new FlowableException("Execution '" + executionId + "' has not subscribed to a signal event with name '" + eventName + "'.");
            }
        }

        for (SignalEventSubscriptionEntity signalEventSubscriptionEntity : signalEvents) {
            // We only throw the event to globally scoped signals.
            // Process instance scoped signals must be thrown within the process itself
            if (signalEventSubscriptionEntity.isGlobalScoped()) {

                if (executionId is null && Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, signalEventSubscriptionEntity.getProcessDefinitionId())) {
                    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                    compatibilityHandler.signalEventReceived(signalEventSubscriptionEntity, payload, async);

                } else {
                    CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher().dispatchEvent(
                            FlowableEventBuilder.createSignalEvent(FlowableEngineEventType.ACTIVITY_SIGNALED, signalEventSubscriptionEntity.getActivityId(), eventName,
                                    payload, signalEventSubscriptionEntity.getExecutionId(), signalEventSubscriptionEntity.getProcessInstanceId(),
                                    signalEventSubscriptionEntity.getProcessDefinitionId()));

                    EventSubscriptionUtil.eventReceived(signalEventSubscriptionEntity, payload, async);
                }
            }
        }

        return null;
    }

}
