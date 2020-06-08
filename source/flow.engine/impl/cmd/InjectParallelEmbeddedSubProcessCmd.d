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


import hunt.collection.List;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Process;
import flow.bpmn.model.SubProcess;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.dynamic.DynamicEmbeddedSubProcessBuilder;
import flow.engine.impl.dynamic.DynamicSubProcessJoinInjectUtil;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.task.service.impl.persistence.entity.TaskEntity;

class InjectParallelEmbeddedSubProcessCmd : AbstractDynamicInjectionCmd implements Command!Void {

    protected string taskId;
    protected DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder;

    public InjectParallelEmbeddedSubProcessCmd(string taskId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder) {
        this.taskId = taskId;
        this.dynamicEmbeddedSubProcessBuilder = dynamicEmbeddedSubProcessBuilder;
    }

    override
    public Void execute(CommandContext commandContext) {
        createDerivedProcessDefinitionForTask(commandContext, taskId);
        return null;
    }

    override
    protected void updateBpmnProcess(CommandContext commandContext, Process process,
            BpmnModel bpmnModel, ProcessDefinitionEntity originalProcessDefinitionEntity, DeploymentEntity newDeploymentEntity) {

        DynamicSubProcessJoinInjectUtil.injectSubProcessWithJoin(taskId, process, bpmnModel, dynamicEmbeddedSubProcessBuilder,
                        originalProcessDefinitionEntity, newDeploymentEntity, commandContext);
    }

    override
    protected void updateExecutions(CommandContext commandContext, ProcessDefinitionEntity processDefinitionEntity,
                                    ExecutionEntity processInstance, List!ExecutionEntity childExecutions) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);

        TaskEntity taskEntity = CommandContextUtil.getTaskService().getTask(taskId);
        ExecutionEntity executionAtTask = executionEntityManager.findById(taskEntity.getExecutionId());

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionEntity.getId());
        FlowElement taskElement = bpmnModel.getFlowElement(executionAtTask.getCurrentActivityId());
        FlowElement subProcessElement = bpmnModel.getFlowElement(((SubProcess) taskElement.getParentContainer()).getId());
        ExecutionEntity subProcessExecution = executionEntityManager.createChildExecution(executionAtTask.getParent());
        subProcessExecution.setScope(true);
        subProcessExecution.setCurrentFlowElement(subProcessElement);
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(subProcessExecution);

        executionAtTask.setParent(subProcessExecution);

        ExecutionEntity execution = executionEntityManager.createChildExecution(subProcessExecution);
        FlowElement newSubProcess = bpmnModel.getMainProcess().getFlowElement(dynamicEmbeddedSubProcessBuilder.getDynamicSubProcessId(), true);
        execution.setCurrentFlowElement(newSubProcess);

        CommandContextUtil.getAgenda().planContinueProcessOperation(execution);
    }

}
