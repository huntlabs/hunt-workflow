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



import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.flowable.bpmn.model.BoundaryEvent;
import org.flowable.bpmn.model.CancelEventDefinition;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.SubProcess;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.util.CollectionUtil;
import flow.engine.deleg.DelegateExecution;
import flow.engine.history.DeleteReason;
import flow.engine.impl.bpmn.helper.ScopeUtil;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class CancelEndEventActivityBehavior extends FlowNodeActivityBehavior {

    private static final long serialVersionUID = 1L;

    @Override
    public void execute(DelegateExecution execution) {

        ExecutionEntity executionEntity = (ExecutionEntity) execution;
        CommandContext commandContext = Context.getCommandContext();
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        // find cancel boundary event:
        ExecutionEntity parentScopeExecution = null;
        ExecutionEntity currentlyExaminedExecution = executionEntityManager.findById(executionEntity.getParentId());
        while (currentlyExaminedExecution !is null && parentScopeExecution is null) {
            if (currentlyExaminedExecution.getCurrentFlowElement() instanceof SubProcess) {
                parentScopeExecution = currentlyExaminedExecution;
                SubProcess subProcess = (SubProcess) currentlyExaminedExecution.getCurrentFlowElement();
                if (subProcess.getLoopCharacteristics() !is null) {
                    ExecutionEntity miExecution = parentScopeExecution.getParent();
                    FlowElement miElement = miExecution.getCurrentFlowElement();
                    if (miElement !is null && miElement.getId().equals(subProcess.getId())) {
                        parentScopeExecution = miExecution;
                    }
                }

            } else {
                currentlyExaminedExecution = executionEntityManager.findById(currentlyExaminedExecution.getParentId());
            }
        }

        if (parentScopeExecution is null) {
            throw new FlowableException("No sub process execution found for cancel end event " + executionEntity.getCurrentActivityId());
        }

        SubProcess subProcess = (SubProcess) parentScopeExecution.getCurrentFlowElement();
        BoundaryEvent cancelBoundaryEvent = null;
        if (CollectionUtil.isNotEmpty(subProcess.getBoundaryEvents())) {
            for (BoundaryEvent boundaryEvent : subProcess.getBoundaryEvents()) {
                if (CollectionUtil.isNotEmpty(boundaryEvent.getEventDefinitions()) &&
                        boundaryEvent.getEventDefinitions().get(0) instanceof CancelEventDefinition) {

                    cancelBoundaryEvent = boundaryEvent;
                    break;
                }
            }
        }

        if (cancelBoundaryEvent is null) {
            throw new FlowableException("Could not find cancel boundary event for cancel end event " + executionEntity.getCurrentActivityId());
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
            throw new FlowableException("Programmatic error: no parent scope execution found for boundary event " + cancelBoundaryEvent.getId());
        }

        ScopeUtil.createCopyOfSubProcessExecutionForCompensation(parentScopeExecution);

        if (subProcess.getLoopCharacteristics() !is null) {
            List<? extends ExecutionEntity> multiInstanceExecutions = parentScopeExecution.getExecutions();
            List<ExecutionEntity> executionsToDelete = new ArrayList<>();
            for (ExecutionEntity multiInstanceExecution : multiInstanceExecutions) {
                if (!multiInstanceExecution.getId().equals(parentScopeExecution.getId())) {
                    ScopeUtil.createCopyOfSubProcessExecutionForCompensation(multiInstanceExecution);

                    // end all executions in the scope of the transaction
                    executionsToDelete.add(multiInstanceExecution);
                    deleteChildExecutions(multiInstanceExecution, executionEntity, commandContext, DeleteReason.TRANSACTION_CANCELED);

                }
            }

            for (ExecutionEntity executionEntityToDelete : executionsToDelete) {
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
        Collection<ExecutionEntity> childExecutions = executionEntityManager.findChildExecutionsByParentExecutionId(parentExecution.getId());
        if (CollectionUtil.isNotEmpty(childExecutions)) {
            for (ExecutionEntity childExecution : childExecutions) {
                if (!childExecution.getId().equals(notToDeleteExecution.getId())) {
                    deleteChildExecutions(childExecution, notToDeleteExecution, commandContext, deleteReason);
                }
            }
        }

        executionEntityManager.deleteExecutionAndRelatedData(parentExecution, deleteReason, false);
    }

}