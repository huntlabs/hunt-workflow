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



import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.event.MessageEventHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class MessageEventReceivedCmd : NeedsActiveExecutionCmd!Void {

    private static final long serialVersionUID = 1L;

    protected final Map!(string, Object) payload;
    protected final string messageName;
    protected final bool async;

    public MessageEventReceivedCmd(string messageName, string executionId, Map!(string, Object) processVariables) {
        super(executionId);
        this.messageName = messageName;

        if (processVariables !is null) {
            this.payload = new HashMap<>(processVariables);

        } else {
            this.payload = null;
        }
        this.async = false;
    }

    public MessageEventReceivedCmd(string messageName, string executionId, bool async) {
        super(executionId);
        this.messageName = messageName;
        this.payload = null;
        this.async = async;
    }

    override
    protected Void execute(CommandContext commandContext, ExecutionEntity execution) {
        if (messageName is null) {
            throw new FlowableIllegalArgumentException("messageName cannot be null");
        }

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.messageEventReceived(messageName, executionId, payload, async);
            return null;
        }

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
        List!EventSubscriptionEntity eventSubscriptions = eventSubscriptionService.findEventSubscriptionsByNameAndExecution(MessageEventHandler.EVENT_HANDLER_TYPE, messageName, executionId);

        if (eventSubscriptions.isEmpty()) {
            throw new FlowableException("Execution with id '" + executionId + "' does not have a subscription to a message event with name '" + messageName + "'");
        }

        // there can be only one:
        EventSubscriptionEntity eventSubscriptionEntity = eventSubscriptions.get(0);
        EventSubscriptionUtil.eventReceived(eventSubscriptionEntity, payload, async);

        return null;
    }

}
