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
import org.flowable.bpmn.model.StartEvent;
import org.flowable.bpmn.model.SubProcess;
import org.flowable.bpmn.model.TimerEventDefinition;
import org.flowable.bpmn.model.ValuedDataObject;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.delegate.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;

/**
 * Implementation of the BPMN 2.0 event subprocess timer start event.
 * 
 * @author Tijs Rademakers
 */
class EventSubProcessTimerStartEventActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected TimerEventDefinition timerEventDefinition;

    public EventSubProcessTimerStartEventActivityBehavior(TimerEventDefinition timerEventDefinition) {
        this.timerEventDefinition = timerEventDefinition;
    }

    @Override
    public void execute(DelegateExecution execution) {
        StartEvent startEvent = (StartEvent) execution.getCurrentFlowElement();
        EventSubProcess eventSubProcess = (EventSubProcess) startEvent.getSubProcess();

        execution.setScope(true);

        // initialize the template-defined data objects as variables
        Map<string, Object> dataObjectVars = processDataObjects(eventSubProcess.getDataObjects());
        if (dataObjectVars != null) {
            execution.setVariablesLocal(dataObjectVars);
        }
    }

    @Override
    public void trigger(DelegateExecution execution, string triggerName, Object triggerData) {
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity executionEntity = (ExecutionEntity) execution;

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
        if (dataObjects != null) {
            for (ValuedDataObject dataObject : dataObjects) {
                variablesMap.put(dataObject.getName(), dataObject.getValue());
            }
        }
        return variablesMap;
    }
}
