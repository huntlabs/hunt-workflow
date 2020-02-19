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



import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.flowable.bpmn.model.EventSubProcess;
import org.flowable.bpmn.model.Signal;
import org.flowable.bpmn.model.SignalEventDefinition;
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.SubProcess;
import org.flowable.bpmn.model.ValuedDataObject;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import org.flowable.eventsubscription.service.EventSubscriptionService;
import org.flowable.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import org.flowable.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;

/**
 * Implementation of the BPMN 2.0 event subprocess signal start event.
 * 
 * @author Tijs Rademakers
 */
class EventSubProcessSignalStartEventActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected SignalEventDefinition signalEventDefinition;
    protected Signal signal;

    public EventSubProcessSignalStartEventActivityBehavior(SignalEventDefinition signalEventDefinition, Signal signal) {
        this.signalEventDefinition = signalEventDefinition;
        this.signal = signal;
    }

    @Override
    public void execute(DelegateExecution execution) {
        StartEvent startEvent = (StartEvent) execution.getCurrentFlowElement();
        EventSubProcess eventSubProcess = (EventSubProcess) startEvent.getSubProcess();

        execution.setScope(true);

        // initialize the template-defined data objects as variables
        Map<string, Object> dataObjectVars = processDataObjects(eventSubProcess.getDataObjects());
        if (dataObjectVars !is null) {
            execution.setVariablesLocal(dataObjectVars);
        }
    }

    @Override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

        string eventName = null;
        if (signal !is null) {
            eventName = signal.getName();
        } else {
            eventName = signalEventDefinition.getSignalRef();
        }

        StartEvent startEvent = (StartEvent) execution.getCurrentFlowElement();
        if (startEvent.isInterrupting()) {
            List<ExecutionEntity> childExecutions = executionEntityManager.collectChildren(executionEntity.getParent());
            for (int i = childExecutions.size() - 1; i >= 0; i--) {
                ExecutionEntity childExecutionEntity = childExecutions.get(i);
                if (!childExecutionEntity.isEnded() && !childExecutionEntity.getId().equals(executionEntity.getId())) {
                    executionEntityManager.deleteExecutionAndRelatedData(childExecutionEntity,
                            DeleteReason.EVENT_SUBPROCESS_INTERRUPTING + "(" + startEvent.getId() + ")", false);
                }
            }

            EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);
            List<EventSubscriptionEntity> eventSubscriptions = executionEntity.getEventSubscriptions();

            for (EventSubscriptionEntity eventSubscription : eventSubscriptions) {
                if (eventSubscription instanceof SignalEventSubscriptionEntity && eventSubscription.getEventName().equals(eventName)) {

                    eventSubscriptionService.deleteEventSubscription(eventSubscription);
                    CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscription);
                }
            }
        }
        
        ExecutionEntity newSubProcessExecution = executionEntityManager.createChildExecution(executionEntity.getParent());
        newSubProcessExecution.setCurrentFlowElement((SubProcess) executionEntity.getCurrentFlowElement().getParentContainer());
        newSubProcessExecution.setEventScope(false);
        newSubProcessExecution.setScope(true);

        ExecutionEntity outgoingFlowExecution = executionEntityManager.createChildExecution(newSubProcessExecution);
        outgoingFlowExecution.setCurrentFlowElement(startEvent);

        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(outgoingFlowExecution);

        leave(outgoingFlowExecution);
    }

    protected Map<string, Object> processDataObjects(Collection<ValuedDataObject> dataObjects) {
        Map<string, Object> variablesMap = new HashMap<>();
        // convert data objects to process variables
        if (dataObjects !is null) {
            for (ValuedDataObject dataObject : dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
