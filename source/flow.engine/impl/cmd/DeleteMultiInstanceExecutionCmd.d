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


import java.io.Serializable;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.common.api.FlowableException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;
import flow.engine.impl.bpmn.behavior.SequentialMultiInstanceBehavior;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;

/**
 * @author Tijs Rademakers
 */
class DeleteMultiInstanceExecutionCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;

    protected static final string NUMBER_OF_INSTANCES = "nrOfInstances";
    protected static final string NUMBER_OF_COMPLETED_INSTANCES = "nrOfCompletedInstances";

    protected string executionId;
    protected bool executionIsCompleted;

    public DeleteMultiInstanceExecutionCmd(string executionId, bool executionIsCompleted) {
        this.executionId = executionId;
        this.executionIsCompleted = executionIsCompleted;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();
        ExecutionEntity execution = executionEntityManager.findById(executionId);

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(execution.getProcessDefinitionId());
        Activity miActivityElement = (Activity) bpmnModel.getFlowElement(execution.getActivityId());
        MultiInstanceLoopCharacteristics multiInstanceLoopCharacteristics = miActivityElement.getLoopCharacteristics();

        if (miActivityElement.getLoopCharacteristics() is null) {
            throw new FlowableException("No multi instance execution found for execution id " + executionId);
        }

        if (!(miActivityElement.getBehavior() instanceof MultiInstanceActivityBehavior)) {
            throw new FlowableException("No multi instance behavior found for execution id " + executionId);
        }

        if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, execution.getProcessDefinitionId())) {
            throw new FlowableException("Flowable 5 process definitions are not supported");
        }

        ExecutionEntity miExecution = getMultiInstanceRootExecution(execution);
        executionEntityManager.deleteChildExecutions(execution, "Delete MI execution", false);
        executionEntityManager.deleteExecutionAndRelatedData(execution, "Delete MI execution", false);

        int loopCounter = 0;
        if (multiInstanceLoopCharacteristics.isSequential()) {
            SequentialMultiInstanceBehavior miBehavior = (SequentialMultiInstanceBehavior) miActivityElement.getBehavior();
            loopCounter = miBehavior.getLoopVariable(execution, miBehavior.getCollectionElementIndexVariable());
        }

        if (executionIsCompleted) {
            Integer numberOfCompletedInstances = (Integer) miExecution.getVariable(NUMBER_OF_COMPLETED_INSTANCES);
            miExecution.setVariableLocal(NUMBER_OF_COMPLETED_INSTANCES, numberOfCompletedInstances + 1);
            loopCounter++;

        } else {
            Integer currentNumberOfInstances = (Integer) miExecution.getVariable(NUMBER_OF_INSTANCES);
            miExecution.setVariableLocal(NUMBER_OF_INSTANCES, currentNumberOfInstances - 1);
        }

        ExecutionEntity childExecution = executionEntityManager.createChildExecution(miExecution);
        childExecution.setCurrentFlowElement(miExecution.getCurrentFlowElement());

        if (multiInstanceLoopCharacteristics.isSequential()) {
            SequentialMultiInstanceBehavior miBehavior = (SequentialMultiInstanceBehavior) miActivityElement.getBehavior();
            miBehavior.continueSequentialMultiInstance(childExecution, loopCounter, childExecution);
        }

        return null;
    }

    protected ExecutionEntity getMultiInstanceRootExecution(ExecutionEntity executionEntity) {
        ExecutionEntity multiInstanceRootExecution = null;
        ExecutionEntity currentExecution = executionEntity;
        while (currentExecution !is null && multiInstanceRootExecution is null && currentExecution.getParent() !is null) {
            if (currentExecution.isMultiInstanceRoot()) {
                multiInstanceRootExecution = currentExecution;
            } else {
                currentExecution = currentExecution.getParent();
            }
        }
        return multiInstanceRootExecution;
    }
}
