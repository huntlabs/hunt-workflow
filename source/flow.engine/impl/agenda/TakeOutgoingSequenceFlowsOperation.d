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
module flow.engine.impl.agenda.TakeOutgoingSequenceFlowsOperation;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Gateway;
import flow.bpmn.model.InclusiveGateway;
import flow.bpmn.model.ParallelGateway;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.interceptor.CommandContext;
//import flow.common.logging.LoggingSessionConstants;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.Condition;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.el.UelExpressionCondition;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.BpmnLoggingSessionUtil;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.condition.ConditionUtil;

import flow.engine.impl.agenda.AbstractOperation;
import hunt.logging;
import hunt.Exceptions;
/**
 * Operation that leaves the {@link FlowElement} where the {@link ExecutionEntity} is currently at and leaves it following the sequence flow.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class TakeOutgoingSequenceFlowsOperation : AbstractOperation {

    protected bool evaluateConditions;

    this(CommandContext commandContext, ExecutionEntity executionEntity, bool evaluateConditions) {
        super(commandContext, executionEntity);
        this.evaluateConditions = evaluateConditions;
    }

    public void run() {
        FlowElement currentFlowElement = getCurrentFlowElement(execution);

        // Compensation check
        Activity a = cast(Activity)currentFlowElement;
        if ((a !is null)
                && (a).isForCompensation()) {

            /*
             * If the current flow element is part of a compensation, we don't always want to follow the regular rules of leaving an activity. More specifically, if there are no outgoing sequenceflow,
             * we simply must stop the execution there and don't go up in the scopes as we usually do to find the outgoing sequenceflow
             */

            cleanupCompensation();
            return;
        }

        // When leaving the current activity, we need to delete any related execution (eg active boundary events)
        cleanupExecutions(currentFlowElement);
        FlowNode f = cast(FlowNode)currentFlowElement;
        if (f !is null) {
            handleFlowNode(f);
        } else if (cast(SequenceFlow)currentFlowElement !is null) {
            handleSequenceFlow();
        }
    }

    protected void handleFlowNode(FlowNode flowNode) {
        handleActivityEnd(flowNode);
        if (flowNode.getParentContainer() !is null && cast(AdhocSubProcess)flowNode.getParentContainer() !is null) {
            handleAdhocSubProcess(flowNode);
        } else {
            leaveFlowNode(flowNode);
        }
    }

    protected void handleActivityEnd(FlowNode flowNode) {
        // a process instance execution can never leave a flow node, but it can pass here whilst cleaning up
        // hence the check for NOT being a process instance
        if (!execution.isProcessInstanceType()) {

            if (!(flowNode.getExecutionListeners().isEmpty())) {
                executeExecutionListeners(flowNode, ExecutionListener.EVENTNAME_END);
            }

            if (execution.isActive()
                    && !flowNode.getOutgoingFlows().isEmpty()
                    && (cast(ParallelGateway)flowNode is null) // Parallel gw takes care of its own history
                    && (cast(InclusiveGateway)flowNode is null) // Inclusive gw takes care of its own history
                    && (cast(SubProcess)flowNode is null) // Subprocess handling creates and destroys scoped execution. The execution taking the seq flow is different from the one entering
                    && ((cast(Activity)flowNode is null) || (cast(Activity) flowNode).getLoopCharacteristics() is null) // Multi instance root execution leaving the node isn't stored in history
                    ) {
                // If no sequence flow: will be handled by the deletion of executions
                CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityEnd(execution, null);
            }

            if ((cast(SubProcess)execution.getCurrentFlowElement() is null) &&
                !(cast(Activity)flowNode !is null && (cast(Activity) flowNode).hasMultiInstanceLoopCharacteristics())) {
                    CommandContextUtil.getEventDispatcher(commandContext).dispatchEvent(
                            FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_COMPLETED, flowNode.getId(), flowNode.getName(),
                                    execution.getId(), execution.getProcessInstanceId(), execution.getProcessDefinitionId(), flowNode));
            }
        }
    }

    protected void leaveFlowNode(FlowNode flowNode) {

        logInfo("Leaving flow node {} with id '{%s}' by following it's {%d} outgoing sequenceflow",
                 flowNode.getId(), flowNode.getOutgoingFlows().size());

        // Get default sequence flow (if set)
        string defaultSequenceFlowId = null;
        Activity a = cast(Activity)flowNode;
        Gateway g = cast(Gateway)flowNode;
        if (a !is null) {
            defaultSequenceFlowId = (a).getDefaultFlow();
        } else if (g !is null) {
            defaultSequenceFlowId = (g).getDefaultFlow();
        }

        // Determine which sequence flows can be used for leaving
        List!SequenceFlow outgoingSequenceFlows = new ArrayList!SequenceFlow();
        foreach (SequenceFlow sequenceFlow ; flowNode.getOutgoingFlows()) {
            string skipExpressionString = sequenceFlow.getSkipExpression();
            if (!SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionString, sequenceFlow.getId(), execution, commandContext)) {

                if (!evaluateConditions
                        || (evaluateConditions && ConditionUtil.hasTrueCondition(sequenceFlow, execution) && (defaultSequenceFlowId is null || !defaultSequenceFlowId.equals(sequenceFlow.getId())))) {
                    outgoingSequenceFlows.add(sequenceFlow);
                }

            } else if (flowNode.getOutgoingFlows().size() == 1 || SkipExpressionUtil.shouldSkipFlowElement(
                            skipExpressionString, sequenceFlow.getId(), execution, commandContext)) {

                // The 'skip' for a sequence flow means that we skip the condition, not the sequence flow.
                outgoingSequenceFlows.add(sequenceFlow);
            }
        }

        // Check if there is a default sequence flow
        if (outgoingSequenceFlows.size() == 0 && evaluateConditions) { // The elements that set this to false also have no support for default sequence flow
            if (defaultSequenceFlowId !is null) {
                foreach (SequenceFlow sequenceFlow ; flowNode.getOutgoingFlows()) {
                    if (defaultSequenceFlowId.equals(sequenceFlow.getId())) {
                        outgoingSequenceFlows.add(sequenceFlow);
                        break;
                    }
                }
            }
        }

        // No outgoing found. Ending the execution
        if (outgoingSequenceFlows.size() == 0) {
            if (flowNode.getOutgoingFlows() is null || flowNode.getOutgoingFlows().size() == 0) {
                logInfo("No outgoing sequence flow found for flow node '{%s}'.", flowNode.getId());
                agenda.planEndExecutionOperation(execution);

            } else {
                throw new FlowableException("No outgoing sequence flow of element '" ~ flowNode.getId() ~ "' could be selected for continuing the process");
            }

        } else {

            // Leave, and reuse the incoming sequence flow, make executions for all the others (if applicable)

            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
            List!ExecutionEntity>outgoingExecutions = new ArrayList!ExecutionEntity(flowNode.getOutgoingFlows().size());

            SequenceFlow sequenceFlow = outgoingSequenceFlows.get(0);

            // Reuse existing one
            execution.setCurrentFlowElement(sequenceFlow);
            execution.setActive(false);
            outgoingExecutions.add(execution);

            // Executions for all the other one
            if (outgoingSequenceFlows.size() > 1) {
                for (int i = 1; i < outgoingSequenceFlows.size(); i++) {

                    ExecutionEntity parent = execution.getParentId() !is null ? execution.getParent() : execution;
                    ExecutionEntity outgoingExecutionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).createChildExecution(parent);

                    SequenceFlow outgoingSequenceFlow = outgoingSequenceFlows.get(i);
                    outgoingExecutionEntity.setActive(false);
                    outgoingExecutionEntity.setCurrentFlowElement(outgoingSequenceFlow);

                    executionEntityManager.insert(outgoingExecutionEntity);
                    outgoingExecutions.add(outgoingExecutionEntity);
                }
            }

            // Leave (only done when all executions have been made, since some queries depend on this)
            ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
            foreach (ExecutionEntity outgoingExecution ; outgoingExecutions) {
                agenda.planContinueProcessOperation(outgoingExecution);
                //if (processEngineConfiguration.isLoggingSessionEnabled()) {
                //    BpmnLoggingSessionUtil.addSequenceFlowLoggingData(LoggingSessionConstants.TYPE_SEQUENCE_FLOW_TAKE, outgoingExecution);
                //}
            }
        }
    }

    protected void handleAdhocSubProcess(FlowNode flowNode) {
        bool completeAdhocSubProcess = false;
        AdhocSubProcess adhocSubProcess = cast(AdhocSubProcess) flowNode.getParentContainer();
        if (adhocSubProcess.getCompletionCondition() !is null) {
            Expression expression = CommandContextUtil.getProcessEngineConfiguration(commandContext).getExpressionManager().createExpression(adhocSubProcess.getCompletionCondition());
            Condition condition = new UelExpressionCondition(expression);
            if (condition.evaluate(adhocSubProcess.getId(), execution)) {
                completeAdhocSubProcess = true;
            }
        }

        if (flowNode.getOutgoingFlows().size() > 0) {
            leaveFlowNode(flowNode);
        } else {
            CommandContextUtil.getExecutionEntityManager(commandContext).deleteExecutionAndRelatedData(execution, null, false);
        }

        if (completeAdhocSubProcess) {
            bool endAdhocSubProcess = true;
            if (!adhocSubProcess.isCancelRemainingInstances()) {
                List!ExecutionEntity childExecutions = CommandContextUtil.getExecutionEntityManager(commandContext).findChildExecutionsByParentExecutionId(execution.getParentId());
                foreach (ExecutionEntity executionEntity ; childExecutions) {
                    if (executionEntity.getId() != (execution.getId())) {
                        endAdhocSubProcess = false;
                        break;
                    }
                }
            }

            if (endAdhocSubProcess) {
                agenda.planEndExecutionOperation(execution.getParent());
            }
        }
    }

    protected void handleSequenceFlow() {
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityEnd(execution, null);
        agenda.planContinueProcessOperation(execution);
    }

    protected void cleanupCompensation() {

        // The compensation is at the end here. Simply stop the execution.
        CommandContextUtil.getExecutionEntityManager(commandContext).deleteExecutionAndRelatedData(execution, null, false);

        ExecutionEntity parentExecutionEntity = execution.getParent();
        if (parentExecutionEntity.isScope() && !parentExecutionEntity.isProcessInstanceType()) {

            if (allChildExecutionsEnded(parentExecutionEntity, null)) {

                // Go up the hierarchy to check if the next scope is ended too.
                // This could happen if only the compensation activity is still active, but the
                // main process is already finished.

                ExecutionEntity executionEntityToEnd = parentExecutionEntity;
                ExecutionEntity scopeExecutionEntity = findNextParentScopeExecutionWithAllEndedChildExecutions(parentExecutionEntity, parentExecutionEntity);
                while (scopeExecutionEntity !is null) {
                    executionEntityToEnd = scopeExecutionEntity;
                    scopeExecutionEntity = findNextParentScopeExecutionWithAllEndedChildExecutions(scopeExecutionEntity, parentExecutionEntity);
                }

                if (executionEntityToEnd.isProcessInstanceType()) {
                    agenda.planEndExecutionOperation(executionEntityToEnd);
                } else {
                    agenda.planDestroyScopeOperation(executionEntityToEnd);
                }

            }
        }
    }

    protected void cleanupExecutions(FlowElement currentFlowElement) {
        if (execution.getParentId() !is null && execution.isScope()) {

            // If the execution is a scope (and not a process instance), the scope must first be
            // destroyed before we can continue and follow the sequence flow

            agenda.planDestroyScopeOperation(execution);

        } else if (cast(Activity)currentFlowElement !is null) {

            // If the current activity is an activity, we need to remove any currently active boundary events

            Activity activity = cast(Activity) currentFlowElement;
            if (!(activity.getBoundaryEvents().isEmpty())) {

                // Cancel events are not removed
                List!string notToDeleteEvents = new ArrayList!string();
                foreach (BoundaryEvent event ; activity.getBoundaryEvents()) {
                    if (!(event.getEventDefinitions().isEmpty()) &&
                            cast(CancelEventDefinition)(event.getEventDefinitions().get(0)) !is null) {
                        notToDeleteEvents.add(event.getId());
                    }
                }

                // Delete all child executions
                Collection!ExecutionEntity childExecutions = CommandContextUtil.getExecutionEntityManager(commandContext).findChildExecutionsByParentExecutionId(execution.getId());
                foreach (ExecutionEntity childExecution ; childExecutions) {
                    if (childExecution.getCurrentFlowElement() is null || !notToDeleteEvents.contains(childExecution.getCurrentFlowElement().getId())) {
                        CommandContextUtil.getExecutionEntityManager(commandContext).deleteExecutionAndRelatedData(childExecution, null, false);
                    }
                }
            }
        }
    }

    // Compensation helper methods

    /**
     * @param executionEntityToIgnore
     *            The execution entity which we can ignore to be ended, as it's the execution currently being handled in this operation.
     */
    protected ExecutionEntity findNextParentScopeExecutionWithAllEndedChildExecutions(ExecutionEntity executionEntity, ExecutionEntity executionEntityToIgnore) {
        if (executionEntity.getParentId() !is null) {
            ExecutionEntity scopeExecutionEntity = executionEntity.getParent();

            // Find next scope
            while (!scopeExecutionEntity.isScope() || !scopeExecutionEntity.isProcessInstanceType()) {
                scopeExecutionEntity = scopeExecutionEntity.getParent();
            }

            // Return when all child executions for it are ended
            if (allChildExecutionsEnded(scopeExecutionEntity, executionEntityToIgnore)) {
                return scopeExecutionEntity;
            }

        }
        return null;
    }

    protected bool allChildExecutionsEnded(ExecutionEntity parentExecutionEntity, ExecutionEntity executionEntityToIgnore) {
        foreach (ExecutionEntity childExecutionEntity ; parentExecutionEntity.getExecutions()) {
            if (executionEntityToIgnore is null || executionEntityToIgnore.getId() != (childExecutionEntity.getId())) {
                if (!childExecutionEntity.isEnded()) {
                    return false;
                }
                if (childExecutionEntity.getExecutions() !is null && childExecutionEntity.getExecutions().size() > 0) {
                    if (!allChildExecutionsEnded(childExecutionEntity, executionEntityToIgnore)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

}
