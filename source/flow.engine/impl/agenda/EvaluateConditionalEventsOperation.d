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
module flow.engine.impl.agenda.EvaluateConditionalEventsOperation;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.ConditionalEventDefinition;
import flow.bpmn.model.Event;
import flow.bpmn.model.EventSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.SubProcess;
import flow.common.api.deleg.Expression;
import flow.common.interceptor.CommandContext;
//import flow.engine.debugs.ExecutionTreeUtil;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.deleg.TriggerableActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.impl.agenda.AbstractOperation;
import hunt.Exceptions;
/**
 * Operation that triggers conditional events for which the condition evaluate to true and continues the process, leaving that activity.
 *
 * @author Tijs Rademakers
 */
class EvaluateConditionalEventsOperation : AbstractOperation {

    this(CommandContext commandContext, ExecutionEntity execution) {
        super(commandContext, execution);
    }

    public void run() {
         implementationMissing(false);
        //List<ExecutionEntity> allExecutions = new ArrayList<>();
        //ExecutionTreeUtil.collectChildExecutions(execution, allExecutions);
        //
        //string processDefinitionId = execution.getProcessDefinitionId();
        //flow.bpmn.model.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        //
        //List<EventSubProcess> eventSubProcesses = process.findFlowElementsOfType(EventSubProcess.class, false);
        //evaluateEventSubProcesses(eventSubProcesses, execution);
        //
        //for (ExecutionEntity childExecutionEntity : allExecutions) {
        //    string activityId = childExecutionEntity.getCurrentActivityId();
        //    FlowElement currentFlowElement = process.getFlowElement(activityId, true);
        //    if (currentFlowElement !is null && currentFlowElement instanceof Event) {
        //        Event event = (Event) currentFlowElement;
        //        if (!event.getEventDefinitions().isEmpty() && event.getEventDefinitions().get(0) instanceof ConditionalEventDefinition) {
        //
        //            ActivityBehavior activityBehavior = (ActivityBehavior) ((FlowNode) currentFlowElement).getBehavior();
        //            if (activityBehavior instanceof TriggerableActivityBehavior) {
        //                ((TriggerableActivityBehavior) activityBehavior).trigger(childExecutionEntity, null, null);
        //            }
        //        }
        //
        //    } else if (currentFlowElement !is null && currentFlowElement instanceof SubProcess) {
        //        SubProcess subProcess = (SubProcess) currentFlowElement;
        //        List<EventSubProcess> childEventSubProcesses = subProcess.findAllSubFlowElementInFlowMapOfType(EventSubProcess.class);
        //        evaluateEventSubProcesses(childEventSubProcesses, childExecutionEntity);
        //    }
        //}
    }

    protected void evaluateEventSubProcesses(List!EventSubProcess eventSubProcesses, ExecutionEntity parentExecution) {
        implementationMissing(false);
        //if (eventSubProcesses !is null) {
        //    for (EventSubProcess eventSubProcess : eventSubProcesses) {
        //        List<StartEvent> startEvents = eventSubProcess.findAllSubFlowElementInFlowMapOfType(StartEvent.class);
        //        if (startEvents !is null) {
        //            for (StartEvent startEvent : startEvents) {
        //
        //                if (startEvent.getEventDefinitions() !is null && !startEvent.getEventDefinitions().isEmpty() &&
        //                                startEvent.getEventDefinitions().get(0) instanceof ConditionalEventDefinition) {
        //
        //                    CommandContext commandContext = CommandContextUtil.getCommandContext();
        //                    ConditionalEventDefinition conditionalEventDefinition = (ConditionalEventDefinition) startEvent.getEventDefinitions().get(0);
        //
        //                    bool conditionIsTrue = false;
        //                    string conditionExpression = conditionalEventDefinition.getConditionExpression();
        //                    if (StringUtils.isNotEmpty(conditionExpression)) {
        //                        Expression expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(conditionExpression);
        //                        Object result = expression.getValue(parentExecution);
        //                        if (result !is null && result instanceof bool && (bool) result) {
        //                            conditionIsTrue = true;
        //                        }
        //
        //                    } else {
        //                        conditionIsTrue = true;
        //                    }
        //
        //                    if (conditionIsTrue) {
        //                        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        //                        if (startEvent.isInterrupting()) {
        //                            executionEntityManager.deleteChildExecutions(parentExecution, null, true);
        //                        }
        //
        //                        ExecutionEntity eventSubProcessExecution = executionEntityManager.createChildExecution(parentExecution);
        //                        eventSubProcessExecution.setScope(true);
        //                        eventSubProcessExecution.setCurrentFlowElement(eventSubProcess);
        //
        //                        ExecutionEntity startEventSubProcessExecution = executionEntityManager.createChildExecution(eventSubProcessExecution);
        //                        startEventSubProcessExecution.setCurrentFlowElement(startEvent);
        //
        //                        CommandContextUtil.getAgenda(commandContext).planContinueProcessOperation(startEventSubProcessExecution);
        //                    }
        //                }
        //            }
        //        }
        //    }
        //}
    }

}
