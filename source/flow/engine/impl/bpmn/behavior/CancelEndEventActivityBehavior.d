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

module flow.engine.impl.bpmn.behavior.CancelEndEventActivityBehavior;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;

import flow.bpmn.model.BoundaryEvent;
import flow.bpmn.model.CancelEventDefinition;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.behavior.FlowNodeActivityBehavior;
/**
 * @author Tijs Rademakers
 */
class CancelEndEventActivityBehavior : FlowNodeActivityBehavior {

    override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = cast(ExecutionEntity) execution;
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        // find cancel boundary event:
        ExecutionEntity parentScopeExecution = null;
        ExecutionEntity currentlyExaminedExecution = executionEntityManager.findById(executionEntity.getParentId());
        while (currentlyExaminedExecution !is null && parentScopeExecution is null) {
            if (cast(SubProcess) currentlyExaminedExecution.getCurrentFlowElement() !is null) {
                parentScopeExecution = currentlyExaminedExecution;
                SubProcess subProcess = cast(SubProcess) currentlyExaminedExecution.getCurrentFlowElement();
                if (subProcess.getLoopCharacteristics() !is null) {
                    ExecutionEntity miExecution = parentScopeExecution.getParent();
                    FlowElement miElement = miExecution.getCurrentFlowElement();
                    if (miElement !is null && miElement.getId() == (subProcess.getId())) {
                        parentScopeExecution = miExecution;
                    }
                }

            } else {
                currentlyExaminedExecution = executionEntityManager.findById(currentlyExaminedExecution.getParentId());
            }
        }

        if (parentScopeExecution is null) {
            throw new FlowableException("No sub process execution found for cancel end event " ~ executionEntity.getCurrentActivityId());
        }

        SubProcess subProcess = cast(SubProcess) parentScopeExecution.getCurrentFlowElement();
        BoundaryEvent cancelBoundaryEvent = null;
        if (subProcess.getBoundaryEvents() !is null && !subProcess.getBoundaryEvents().isEmpty()) {
            foreach (BoundaryEvent boundaryEvent ; subProcess.getBoundaryEvents()) {
                if ((!boundaryEvent.getEventDefinitions().isEmpty()) &&
                        cast(CancelEventDefinition)(boundaryEvent.getEventDefinitions().get(0)) !is null) {

                    cancelBoundaryEvent = boundaryEvent;
                    break;
                }
            }
        }

        if (cancelBoundaryEvent is null) {
            throw new FlowableException("Could not find cancel boundary event for cancel end event " ~ executionEntity.getCurrentActivityId());
        }

        ExecutionEntity newParentScopeExecution = null;
        currentlyExaminedExecution = executionEntityManager.findById(parentScopeExecution.getParentId());
        while (currentlyExaminedExecution !is null && newParentScopeExecution is null) {
            if (currentlyExaminedExecution.isScope()) {
                newParentScopeExecution = currentlyExaminedExecution;
            } else {
                currentlyExaminedExecution = executionEntityManager.findById(currentlyExaminedExecution.getParentId());
            }
        }

        if (newParentScopeExecution is null) {
            throw new FlowableException("Programmatic error: no parent scope execution found for boundary event " ~ cancelBoundaryEvent.getId());
        }

        ScopeUtil.createCopyOfSubProcessExecutionForCompensation(parentScopeExecution);

        if (subProcess.getLoopCharacteristics() !is null) {
            List!ExecutionEntity multiInstanceExecutions = parentScopeExecution.getExecutionEntities();
            List!ExecutionEntity executionsToDelete = new ArrayList!ExecutionEntity();
            foreach (ExecutionEntity multiInstanceExecution ; multiInstanceExecutions) {
                if (multiInstanceExecution.getId() != (parentScopeExecution.getId())) {
                    ScopeUtil.createCopyOfSubProcessExecutionForCompensation(multiInstanceExecution);

                    // end all executions in the scope of the transaction
                    executionsToDelete.add(multiInstanceExecution);
                    deleteChildExecutions(multiInstanceExecution, executionEntity, commandContext, DeleteReason.TRANSACTION_CANCELED);

                }
            }

            foreach (ExecutionEntity executionEntityToDelete ; executionsToDelete) {
                deleteChildExecutions(executionEntityToDelete, executionEntity, commandContext, DeleteReason.TRANSACTION_CANCELED);
            }
        }

        // The current activity is finished (and will not be ended in the deleteChildExecutions)
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityEnd(executionEntity, null);

        // set new parent for boundary event execution
        executionEntity.setParent(newParentScopeExecution);
        executionEntity.setCurrentFlowElement(cancelBoundaryEvent);

        // end all executions in the scope of the transaction
        deleteChildExecutions(parentScopeExecution, executionEntity, commandContext, DeleteReason.TRANSACTION_CANCELED);

        CommandContextUtil.getAgenda(commandContext).planTriggerExecutionOperation(executionEntity);
    }

    protected void deleteChildExecutions(ExecutionEntity parentExecution, ExecutionEntity notToDeleteExecution,
            CommandContext commandContext, string deleteReason) {
        // Delete all child executions
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        Collection!ExecutionEntity childExecutions = executionEntityManager.findChildExecutionsByParentExecutionId(parentExecution.getId());
        if (childExecutions !is null && !childExecutions.isEmpty()) {
            foreach (ExecutionEntity childExecution ; childExecutions) {
                if (childExecution.getId() != (notToDeleteExecution.getId())) {
                    deleteChildExecutions(childExecution, notToDeleteExecution, commandContext, deleteReason);
                }
            }
        }

        executionEntityManager.deleteExecutionAndRelatedData(parentExecution, deleteReason, false);
    }

}
