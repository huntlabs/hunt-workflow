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



import java.util.Map;

import org.flowable.bpmn.model.FlowElement;
import flow.common.api.FlowableException;
import flow.common.api.scope.ScopeTypes;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.repository.ProcessDefinition;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;

/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class SignalEventHandler extends AbstractEventHandler {

    public static final string EVENT_HANDLER_TYPE = "signal";

    @Override
    public string getEventHandlerType() {
        return EVENT_HANDLER_TYPE;
    }

    @SuppressWarnings("unchecked")
    @Override
    public void handleEvent(EventSubscriptionEntity eventSubscription, Object payload, CommandContext commandContext) {
        if (eventSubscription.getExecutionId() !is null) {

            super.handleEvent(eventSubscription, payload, commandContext);

        } else if (eventSubscription.getProcessDefinitionId() !is null) {

            // Find initial flow element matching the signal start event
            string processDefinitionId = eventSubscription.getProcessDefinitionId();
            org.flowable.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
            ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);

            if (processDefinition.isSuspended()) {
                throw new FlowableException("Could not handle signal: process definition with id: " + processDefinitionId + " is suspended");
            }

            FlowElement flowElement = process.getFlowElement(eventSubscription.getActivityId(), true);
            if (flowElement is null) {
                throw new FlowableException("Could not find matching FlowElement for activityId " + eventSubscription.getActivityId());
            }

            // Start process instance via that flow element
            Map<string, Object> variables = null;
            if (payload instanceof Map) {
                variables = (Map<string, Object>) payload;
            }
            ProcessInstanceHelper processInstanceHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();
            processInstanceHelper.createAndStartProcessInstanceWithInitialFlowElement(processDefinition, null, null, flowElement, process, variables, null, true);

        } else if (eventSubscription.getScopeId() !is null && ScopeTypes.CMMN.equals(eventSubscription.getScopeType())) {
            CommandContextUtil.getProcessEngineConfiguration(commandContext).getCaseInstanceService().handleSignalEvent(eventSubscription);
        
        } else {
            throw new FlowableException("Invalid signal handling: no execution nor process definition set");
        }
    }

}
