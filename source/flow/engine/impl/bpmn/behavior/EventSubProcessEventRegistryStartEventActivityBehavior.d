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

module flow.engine.impl.bpmn.behavior.EventSubProcessEventRegistryStartEventActivityBehavior;
import hunt.Exceptions;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.ValuedDataObject;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
/**
 * Implementation of the BPMN 2.0 event subprocess event registry start event.
 *
 * @author Tijs Rademakers
 */
class EventSubProcessEventRegistryStartEventActivityBehavior : AbstractBpmnActivityBehavior {

    protected string eventDefinitionKey;

    this(string eventDefinitionKey) {
        this.eventDefinitionKey = eventDefinitionKey;
    }

    override
    public void execute(DelegateExecution execution) {
        StartEvent startEvent = cast(StartEvent) execution.getCurrentFlowElement();
        EventSubProcess eventSubProcess = cast(EventSubProcess) startEvent.getSubProcess();

        execution.setScope(true);

        // initialize the template-defined data objects as variables
        Map!(string, Object) dataObjectVars = processDataObjects(eventSubProcess.getDataObjects());
        if (dataObjectVars !is null) {
            execution.setVariablesLocal(dataObjectVars);
        }
    }

    override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;

        StartEvent startEvent = cast(StartEvent) execution.getCurrentFlowElement();
        if (startEvent.isInterrupting()) {
            List!ExecutionEntity childExecutions = executionEntityManager.collectChildren(executionEntity.getParent());
            for (int i = childExecutions.size() - 1; i >= 0; i--) {
                ExecutionEntity childExecutionEntity = childExecutions.get(i);
                if (!childExecutionEntity.isEnded() && childExecutionEntity.getId()!=(executionEntity.getId())) {
                    executionEntityManager.deleteExecutionAndRelatedData(childExecutionEntity,
                            DeleteReason.EVENT_SUBPROCESS_INTERRUPTING ~ "(" ~ startEvent.getId() ~ ")", false);
                }
            }

            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
            implementationMissing(false);
            //List!EventSubscriptionEntity eventSubscriptions = executionEntity.getEventSubscriptions();
            //
            //foreach (EventSubscriptionEntity eventSubscription ; eventSubscriptions) {
            //    if (eventDefinitionKey == eventSubscription.getEventType()) {
            //        eventSubscriptionService.deleteEventSubscription(eventSubscription);
            //        CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
            //    }
            //}
        }

        ExecutionEntity newSubProcessExecution = executionEntityManager.createChildExecution(executionEntity.getParent());
        newSubProcessExecution.setCurrentFlowElement(cast(SubProcess) executionEntity.getCurrentFlowElement().getParentContainer());
        newSubProcessExecution.setEventScope(false);
        newSubProcessExecution.setScope(true);

        ExecutionEntity outgoingFlowExecution = executionEntityManager.createChildExecution(newSubProcessExecution);
        outgoingFlowExecution.setCurrentFlowElement(startEvent);

        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(outgoingFlowExecution);

        leave(outgoingFlowExecution);
    }

    protected Map!(string, Object) processDataObjects(Collection!ValuedDataObject dataObjects) {
        Map!(string, Object) variablesMap = new HashMap!(string, Object)();
        // convert data objects to process variables
        if (dataObjects !is null) {
            foreach (ValuedDataObject dataObject ; dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
