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
module flow.engine.impl.event.AbstractEventHandler;


import hunt.collection.Map;

import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.engine.impl.event.EventHandler;
/**
 * @author Tijs Rademakers
 */
abstract class AbstractEventHandler : EventHandler {

    public void handleEvent(EventSubscriptionEntity eventSubscription, Object payload, CommandContext commandContext) {
        string executionId = eventSubscription.getExecutionId();
        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
        FlowNode currentFlowElement = cast(FlowNode) execution.getCurrentFlowElement();

        if (currentFlowElement is null) {
            throw new FlowableException("Error while sending signal for event subscription '" ~ eventSubscription.getId() ~ "': " ~ "no activity associated with event subscription");
        }

        if (cast(Map!(string, Object))payload !is null) {
            Map!(string, Object) processVariables = cast(Map!(string, Object)) payload;
            execution.setVariables(processVariables);
        }

        CommandContextUtil.getAgenda().planTriggerExecutionOperation(execution);
    }

}
