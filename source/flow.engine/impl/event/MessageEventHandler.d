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

module flow.engine.impl.event.MessageEventHandler;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.engine.impl.event.AbstractEventHandler;
/**
 * @author Daniel Meyer
 */
class MessageEventHandler : AbstractEventHandler {

    public static  string EVENT_HANDLER_TYPE = "message";

    public string getEventHandlerType() {
        return EVENT_HANDLER_TYPE;
    }

    override
    public void handleEvent(EventSubscriptionEntity eventSubscription, Object payload, CommandContext commandContext) {
        // As stated in the FlowableEventType java-doc, the message-event is
        // thrown before the actual message has been sent
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        FlowableEventDispatcher eventDispatcher = processEngineConfiguration.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            string executionId = eventSubscription.getExecutionId();
            ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
            eventDispatcher.dispatchEvent(
                            FlowableEventBuilder.createMessageEvent(FlowableEngineEventType.ACTIVITY_MESSAGE_RECEIVED, eventSubscription.getActivityId(), eventSubscription.getEventName(), payload,
                                    eventSubscription.getExecutionId(), eventSubscription.getProcessInstanceId(), execution.getProcessDefinitionId()));
        }

        super.handleEvent(eventSubscription, payload, commandContext);
    }

}
