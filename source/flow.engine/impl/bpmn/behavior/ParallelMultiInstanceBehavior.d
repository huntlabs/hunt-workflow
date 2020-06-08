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
module flow.engine.impl.bpmn.behavior.ParallelMultiInstanceBehavior;

import hunt.collection.ArrayList;
import hunt.collection.LinkedList;
import hunt.collection.List;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CallActivity;
import flow.bpmn.model.CompensateEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.SubProcess;
import flow.bpmn.model.Transaction;
import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import hunt.Integer;
import hunt.String;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ParallelMultiInstanceBehavior : MultiInstanceActivityBehavior {


    this(Activity activity, AbstractBpmnActivityBehavior originalActivityBehavior) {
        super(activity, originalActivityBehavior);
    }

    /**
     * Handles the parallel case of spawning the instances. Will create child executions accordingly for every instance needed.
     */
    override
    protected int createInstances(DelegateExecution multiInstanceRootExecution) {
        int nrOfInstances = resolveNrOfInstances(multiInstanceRootExecution);
        if (nrOfInstances < 0) {
            throw new FlowableIllegalArgumentException("Invalid number of instances: must be non-negative integer value" ~ ", but was " );
        }

        setLoopVariable(multiInstanceRootExecution, NUMBER_OF_INSTANCES, new Integer(nrOfInstances));
        setLoopVariable(multiInstanceRootExecution, NUMBER_OF_COMPLETED_INSTANCES, new Integer(0));
        setLoopVariable(multiInstanceRootExecution, NUMBER_OF_ACTIVE_INSTANCES, new Integer(nrOfInstances));

        List!ExecutionEntity concurrentExecutions = new ArrayList!ExecutionEntity();
        for (int loopCounter = 0; loopCounter < nrOfInstances; loopCounter++) {
            ExecutionEntity concurrentExecution = CommandContextUtil.getExecutionEntityManager()
                    .createChildExecution(cast(ExecutionEntity) multiInstanceRootExecution);
            concurrentExecution.setCurrentFlowElement(activity);
            concurrentExecution.setActive(true);
            concurrentExecution.setScope(false);

            concurrentExecutions.add(concurrentExecution);
            logLoopDetails(concurrentExecution, "initialized", loopCounter, 0, nrOfInstances, nrOfInstances);

            //CommandContextUtil.getHistoryManager().recordActivityStart(concurrentExecution);
        }

        // Before the activities are executed, all executions MUST be created up front
        // Do not try to merge this loop with the previous one, as it will lead
        // to bugs, due to possible child execution pruning.
        for (int loopCounter = 0; loopCounter < nrOfInstances; loopCounter++) {
            ExecutionEntity concurrentExecution = concurrentExecutions.get(loopCounter);
            // executions can be inactive, if instances are all automatics
            // (no-waitstate) and completionCondition has been met in the meantime
            if (concurrentExecution.isActive()
                    && !concurrentExecution.isEnded()
                    && !concurrentExecution.getParent().isEnded()) {
                executeOriginalBehavior(concurrentExecution, cast(ExecutionEntity) multiInstanceRootExecution, loopCounter);
            }
        }

        // See ACT-1586: ExecutionQuery returns wrong results when using multi
        // instance on a receive task The parent execution must be set to false, so it wouldn't show up in
        // the execution query when using .activityId(something). Do not we cannot nullify the
        // activityId (that would have been a better solution), as it would break boundary event behavior.
        if (!concurrentExecutions.isEmpty()) {
            multiInstanceRootExecution.setActive(false);
        }

        return nrOfInstances;
    }

    /**
     * Called when the wrapped {@link ActivityBehavior} calls the {@link AbstractBpmnActivityBehavior#leave(DelegateExecution)} method. Handles the completion of one of the parallel instances
     */
    override
    public void leave(DelegateExecution execution) {

        bool zeroNrOfInstances = false;
        if (resolveNrOfInstances(execution) == 0) {
            // Empty collection, just leave.
            zeroNrOfInstances = true;
            super.leave(execution); // Plan the default leave
        }

        int loopCounter = getLoopVariable(execution, getCollectionElementIndexVariable());
        int nrOfInstances = getLoopVariable(execution, NUMBER_OF_INSTANCES);
        int nrOfCompletedInstances = getLoopVariable(execution, NUMBER_OF_COMPLETED_INSTANCES) + 1;
        int nrOfActiveInstances = getLoopVariable(execution, NUMBER_OF_ACTIVE_INSTANCES) - 1;

        DelegateExecution miRootExecution = getMultiInstanceRootExecution(execution);
        if (miRootExecution !is null) { // will be null in case of empty collection
            setLoopVariable(miRootExecution, NUMBER_OF_COMPLETED_INSTANCES, nrOfCompletedInstances);
            setLoopVariable(miRootExecution, NUMBER_OF_ACTIVE_INSTANCES, nrOfActiveInstances);
        }

        CommandContextUtil.getActivityInstanceEntityManager().recordActivityEnd(cast(ExecutionEntity) execution, null);
        callActivityEndListeners(execution);

        logLoopDetails(execution, "instance completed", loopCounter, nrOfCompletedInstances, nrOfActiveInstances, nrOfInstances);

        if (zeroNrOfInstances) {
            return;
        }

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        if (executionEntity.getParent() !is null) {

            executionEntity.inactivate();
            lockFirstParentScope(executionEntity);

            bool isCompletionConditionSatisfied = completionConditionSatisfied(execution.getParent());
            if (nrOfCompletedInstances >= nrOfInstances || isCompletionConditionSatisfied) {

                ExecutionEntity leavingExecution = null;
                if (nrOfInstances > 0) {
                    leavingExecution = executionEntity.getParent();
                } else {
                    CommandContextUtil.getActivityInstanceEntityManager().recordActivityEnd(cast(ExecutionEntity) execution, null);
                    leavingExecution = executionEntity;
                }

                Activity activity = cast(Activity) execution.getCurrentFlowElement();
                verifyCompensation(execution, leavingExecution, activity);
                verifyCallActivity(leavingExecution, activity);

                if (isCompletionConditionSatisfied) {
                    LinkedList!DelegateExecution toVerify = new LinkedList!DelegateExecution(miRootExecution.getExecutions());
                    while (!toVerify.isEmpty()) {
                        DelegateExecution childExecution = toVerify.pop();
                        if ((cast(ExecutionEntity) childExecution).isInserted()) {
                            childExecution.inactivate();
                        }

                        List!DelegateExecution childExecutions = cast(List!DelegateExecution) childExecution.getExecutions();
                        if (childExecutions !is null && !childExecutions.isEmpty()) {
                            toVerify.addAll(childExecutions);
                        }
                    }
                    sendCompletedWithConditionEvent(leavingExecution);
                }
                else {
                    sendCompletedEvent(leavingExecution);
                }

                super.leave(leavingExecution);
              }

        } else {
            sendCompletedEvent(execution);
            super.leave(execution);
        }
    }

    protected Activity verifyCompensation(DelegateExecution execution, ExecutionEntity executionToUse, Activity activity) {
        bool hasCompensation = false;
        if (cast(Transaction)activity !is null) {
            hasCompensation = true;
        } else if (cast(SubProcess)activity !is null) {
            SubProcess subProcess = cast(SubProcess) activity;
            foreach (FlowElement subElement ; subProcess.getFlowElements()) {
                if (cast(Activity)subElement !is null) {
                    Activity subActivity = cast(Activity) subElement;
                    if (subActivity.getBoundaryEvents() !is null && !subActivity.getBoundaryEvents().isEmpty()) {
                        foreach (BoundaryEvent boundaryEvent ; subActivity.getBoundaryEvents()) {
                            if (boundaryEvent.getEventDefinitions() !is null && !boundaryEvent.getEventDefinitions().isEmpty() &&
                                    cast(CompensateEventDefinition)(boundaryEvent.getEventDefinitions().get(0)) !is null) {

                                hasCompensation = true;
                                break;
                            }
                        }
                    }
                }
            }
        }

        if (hasCompensation) {
            ScopeUtil.createCopyOfSubProcessExecutionForCompensation(executionToUse);
        }
        return activity;
    }

    protected void verifyCallActivity(ExecutionEntity executionToUse, Activity activity) {
        if (cast(CallActivity)activity !is null) {
            ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
            if (executionToUse !is null) {
                List!string callActivityExecutionIds = new ArrayList!string;

                // Find all execution entities that are at the call activity
                List!ExecutionEntity childExecutions = executionEntityManager.collectChildren(executionToUse);
                if (childExecutions !is null) {
                    foreach (ExecutionEntity childExecution ; childExecutions) {
                        if (activity.getId() == (childExecution.getCurrentActivityId())) {
                            callActivityExecutionIds.add(childExecution.getId());
                        }
                    }

                    // Now all call activity executions have been collected, loop again and check which should be removed
                    for (int i = childExecutions.size() - 1; i >= 0; i--) {
                        ExecutionEntity childExecution = childExecutions.get(i);
                        if (childExecution.getSuperExecutionId() !is null && childExecution.getSuperExecutionId().length != 0
                                && callActivityExecutionIds.contains(childExecution.getSuperExecutionId())) {

                            executionEntityManager.deleteProcessInstanceExecutionEntity(childExecution.getId(), activity.getId(),
                                    "call activity completion condition met", true, false, true);
                        }
                    }

                }
            }
        }
    }


    protected void lockFirstParentScope(DelegateExecution execution) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

        bool found = false;
        ExecutionEntity parentScopeExecution = null;
        ExecutionEntity currentExecution = cast(ExecutionEntity) execution;
        while (!found && currentExecution !is null && currentExecution.getParentId() !is null && currentExecution.getParentId().length != 0) {
            parentScopeExecution = executionEntityManager.findById(currentExecution.getParentId());
            if (parentScopeExecution !is null && parentScopeExecution.isScope()) {
                found = true;
            }
            currentExecution = parentScopeExecution;
        }

        parentScopeExecution.forceUpdate();
    }
}
