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
module flow.engine.impl.bpmn.helper.MessageThrowingEventListener;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.engine.impl.bpmn.helper.BaseDelegateEventListener;
/**
 * An {@link FlowableEventListener} that throws a message event when an event is dispatched to it. Sends the message to the execution the event was fired from. If the execution is not subscribed to a
 * message, the process-instance is checked.
 *
 * @author Tijs Rademakers
 *
 */
class MessageThrowingEventListener : BaseDelegateEventListener {

    protected string messageName;
    protected TypeInfo entityClass;

    public void onEvent(FlowableEvent event) {
        if (isValidEvent(event) && cast(FlowableEngineEvent)event !is null) {

            FlowableEngineEvent engineEvent = cast(FlowableEngineEvent) event;

            if (engineEvent.getProcessInstanceId() is null || engineEvent.getProcessInstanceId().length == 0) {
                throw new FlowableIllegalArgumentException("Cannot throw process-instance scoped message, since the dispatched event is not part of an ongoing process instance");
            }

            List!MessageEventSubscriptionEntity subscriptionEntities = CommandContextUtil.getEventSubscriptionService().findMessageEventSubscriptionsByProcessInstanceAndEventName(
                    engineEvent.getProcessInstanceId(), messageName);

            foreach (EventSubscriptionEntity messageEventSubscriptionEntity ; subscriptionEntities) {
                EventSubscriptionUtil.eventReceived(messageEventSubscriptionEntity, null, false);
            }
        }
    }

    public void setMessageName(string messageName) {
        this.messageName = messageName;
    }

    public bool isFailOnException() {
        return true;
    }
}
