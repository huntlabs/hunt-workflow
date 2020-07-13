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
module flow.engine.impl.cmd.AddMultiInstanceExecutionCmd;

import flow.variable.service.api.deleg.VariableScope;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.common.api.FlowableException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.runtime.Execution;
import hunt.Integer;
/**
 * @author Tijs Rademakers
 */
class AddMultiInstanceExecutionCmd : Command!Execution {


    protected static  string NUMBER_OF_INSTANCES = "nrOfInstances";

    protected string activityId;
    protected string parentExecutionId;
    protected Map!(string, Object) executionVariables;

    this(string activityId, string parentExecutionId, Map!(string, Object) executionVariables) {
        this.activityId = activityId;
        this.parentExecutionId = parentExecutionId;
        this.executionVariables = executionVariables;
    }

    override
    public Execution execute(CommandContext commandContext) {
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

        ExecutionEntity miExecution = searchForMultiInstanceActivity(activityId, parentExecutionId, executionEntityManager);

        if (miExecution is null) {
            throw new FlowableException("No multi instance execution found for activity id " ~ activityId);
        }

        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, miExecution.getProcessDefinitionId())) {
        //    throw new FlowableException("Flowable 5 process definitions are not supported");
        //}

        ExecutionEntity childExecution = executionEntityManager.createChildExecution(miExecution);
        childExecution.setCurrentFlowElement(miExecution.getCurrentFlowElement());

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(miExecution.getProcessDefinitionId());
        Activity miActivityElement = cast(Activity) bpmnModel.getFlowElement(miExecution.getActivityId());
        MultiInstanceLoopCharacteristics multiInstanceLoopCharacteristics = miActivityElement.getLoopCharacteristics();

        Integer currentNumberOfInstances = cast(Integer) miExecution.getVariable(NUMBER_OF_INSTANCES);
        (cast(VariableScope)miExecution).setVariableLocal(NUMBER_OF_INSTANCES, new Integer(currentNumberOfInstances.intValue + 1));

        if (executionVariables !is null) {
            childExecution.setVariablesLocal(executionVariables);
        }

        if (!multiInstanceLoopCharacteristics.isSequential()) {
            miExecution.setActive(true);
            miExecution.setScope(false);

            childExecution.setCurrentFlowElement(miActivityElement);
            CommandContextUtil.getAgenda().planContinueMultiInstanceOperation(childExecution, miExecution, currentNumberOfInstances.intValue);
        }

        return childExecution;
    }

    protected ExecutionEntity searchForMultiInstanceActivity(string activityId, string parentExecutionId, ExecutionEntityManager executionEntityManager) {
        List!ExecutionEntity childExecutions = executionEntityManager.findChildExecutionsByParentExecutionId(parentExecutionId);

        ExecutionEntity miExecution = null;
        foreach (ExecutionEntity childExecution ; childExecutions) {
            if (activityId == (childExecution.getActivityId()) && childExecution.isMultiInstanceRoot()) {
                if (miExecution !is null) {
                    throw new FlowableException("Multiple multi instance executions found for activity id " ~ activityId);
                }
                miExecution = childExecution;
            }

            ExecutionEntity childMiExecution = searchForMultiInstanceActivity(activityId, childExecution.getId(), executionEntityManager);
            if (childMiExecution !is null) {
                if (miExecution !is null) {
                    throw new FlowableException("Multiple multi instance executions found for activity id " ~ activityId);
                }
                miExecution = childMiExecution;
            }
        }

        return miExecution;
    }
}
