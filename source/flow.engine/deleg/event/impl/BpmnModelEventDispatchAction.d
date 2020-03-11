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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.deleg.event.impl.BpmnModelEventDispatchAction;




import flow.bpmn.model.BpmnModel;
import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.event.EventDispatchAction;
import flow.common.event.FlowableEventSupport;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;

class BpmnModelEventDispatchAction : EventDispatchAction {

    @Override
    public void dispatchEvent(CommandContext commandContext, FlowableEventSupport eventSupport, FlowableEvent event) {
        if (event.getType() == FlowableEngineEventType.ENTITY_DELETED && event instanceof FlowableEntityEvent) {
            FlowableEntityEvent entityEvent = (FlowableEntityEvent) event;
            if (entityEvent.getEntity() instanceof ProcessDefinition) {
                // process definition deleted event doesn't need to be dispatched to event listeners
                return;
            }
        }

        // Try getting hold of the Process definition, based on the process definition key, if a context is active
        if (commandContext !is null) {
            BpmnModel bpmnModel = extractBpmnModelFromEvent(event);
            if (bpmnModel !is null) {
                ((FlowableEventSupport) bpmnModel.getEventSupport()).dispatchEvent(event);
            }
        }
    }

    /**
     * In case no process-context is active, this method attempts to extract a process-definition based on the event. In case it's an event related to an entity, this can be deducted by inspecting the
     * entity, without additional queries to the database.
     *
     * If not an entity-related event, the process-definition will be retrieved based on the processDefinitionId (if filled in). This requires an additional query to the database in case not already
     * cached. However, queries will only occur when the definition is not yet in the cache, which is very unlikely to happen, unless evicted.
     *
     * @param event
     * @return
     */
    protected BpmnModel extractBpmnModelFromEvent(FlowableEvent event) {
        BpmnModel result = null;

        if (result is null && event instanceof FlowableEngineEvent && ((FlowableEngineEvent) event).getProcessDefinitionId() !is null) {
            ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(
                    ((FlowableEngineEvent) event).getProcessDefinitionId(), true);

            if (processDefinition !is null) {
                result = CommandContextUtil.getProcessEngineConfiguration().getDeploymentManager().resolveProcessDefinition(processDefinition).getBpmnModel();
            }
        }

        return result;
    }

}
