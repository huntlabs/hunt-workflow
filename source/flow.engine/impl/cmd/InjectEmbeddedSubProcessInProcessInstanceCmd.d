///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection.List;
//
//import flow.bpmn.model.BpmnModel;
//import flow.bpmn.model.FlowElement;
//import flow.bpmn.model.Process;
//import flow.bpmn.model.StartEvent;
//import flow.bpmn.model.SubProcess;
//import flow.common.api.FlowableException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.context.Context;
//import flow.engine.impl.dynamic.DynamicEmbeddedSubProcessBuilder;
//import flow.engine.impl.dynamic.DynamicSubProcessParallelInjectUtil;
//import flow.engine.impl.persistence.entity.DeploymentEntity;
//import flow.engine.impl.persistence.entity.ExecutionEntity;
//import flow.engine.impl.persistence.entity.ExecutionEntityManager;
//import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.ProcessDefinitionUtil;
//
//class InjectEmbeddedSubProcessInProcessInstanceCmd : AbstractDynamicInjectionCmd implements Command!Void {
//
//    protected string processInstanceId;
//    protected DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder;
//
//    public InjectEmbeddedSubProcessInProcessInstanceCmd(string processInstanceId, DynamicEmbeddedSubProcessBuilder dynamicEmbeddedSubProcessBuilder) {
//        this.processInstanceId = processInstanceId;
//        this.dynamicEmbeddedSubProcessBuilder = dynamicEmbeddedSubProcessBuilder;
//    }
//
//    override
//    public Void execute(CommandContext commandContext) {
//        createDerivedProcessDefinitionForProcessInstance(commandContext, processInstanceId);
//        return null;
//    }
//
//    override
//    protected void updateBpmnProcess(CommandContext commandContext, Process process,
//            BpmnModel bpmnModel, ProcessDefinitionEntity originalProcessDefinitionEntity, DeploymentEntity newDeploymentEntity) {
//
//        DynamicSubProcessParallelInjectUtil.injectParallelSubProcess(process, bpmnModel, dynamicEmbeddedSubProcessBuilder,
//                        originalProcessDefinitionEntity, newDeploymentEntity, commandContext);
//    }
//
//    override
//    protected void updateExecutions(CommandContext commandContext, ProcessDefinitionEntity processDefinitionEntity,
//                                    ExecutionEntity processInstance, List!ExecutionEntity childExecutions) {
//
//        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
//
//        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionEntity.getId());
//        SubProcess subProcess = (SubProcess) bpmnModel.getFlowElement(dynamicEmbeddedSubProcessBuilder.getDynamicSubProcessId());
//        ExecutionEntity subProcessExecution = executionEntityManager.createChildExecution(processInstance);
//        subProcessExecution.setScope(true);
//        subProcessExecution.setCurrentFlowElement(subProcess);
//        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(subProcessExecution);
//
//        ExecutionEntity childExecution = executionEntityManager.createChildExecution(subProcessExecution);
//
//        StartEvent initialEvent = null;
//        for (FlowElement subElement : subProcess.getFlowElements()) {
//            if (subElement instanceof StartEvent) {
//                StartEvent startEvent = (StartEvent) subElement;
//                if (startEvent.getEventDefinitions().size() == 0) {
//                    initialEvent = startEvent;
//                    break;
//                }
//            }
//        }
//
//        if (initialEvent is null) {
//            throw new FlowableException("Could not find a none start event in dynamic sub process");
//        }
//
//        childExecution.setCurrentFlowElement(initialEvent);
//
//        Context.getAgenda().planContinueProcessOperation(childExecution);
//    }
//
//}
