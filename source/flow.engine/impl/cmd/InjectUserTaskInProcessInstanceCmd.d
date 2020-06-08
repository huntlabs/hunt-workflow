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
import hunt.collection.Map;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.EndEvent;
import flow.bpmn.model.GraphicInfo;
import flow.bpmn.model.ParallelGateway;
import flow.bpmn.model.Process;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.StartEvent;
import flow.bpmn.model.UserTask;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.context.Context;
import flow.engine.impl.dynamic.BaseDynamicSubProcessInjectUtil;
import flow.engine.impl.dynamic.DynamicUserTaskBuilder;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;

class InjectUserTaskInProcessInstanceCmd : AbstractDynamicInjectionCmd implements Command!Void {

    protected string processInstanceId;
    protected DynamicUserTaskBuilder dynamicUserTaskBuilder;

    public InjectUserTaskInProcessInstanceCmd(string processInstanceId, DynamicUserTaskBuilder dynamicUserTaskBuilder) {
        this.processInstanceId = processInstanceId;
        this.dynamicUserTaskBuilder = dynamicUserTaskBuilder;
    }

    override
    public Void execute(CommandContext commandContext) {
        createDerivedProcessDefinitionForProcessInstance(commandContext, processInstanceId);
        return null;
    }

    override
    protected void updateBpmnProcess(CommandContext commandContext, Process process,
            BpmnModel bpmnModel, ProcessDefinitionEntity originalProcessDefinitionEntity, DeploymentEntity newDeploymentEntity) {

        List!StartEvent startEvents = process.findFlowElementsOfType(StartEvent.class);
        StartEvent initialStartEvent = null;
        for (StartEvent startEvent : startEvents) {
            if (startEvent.getEventDefinitions().size() == 0) {
                initialStartEvent = startEvent;
                break;

            } else if (initialStartEvent is null) {
                initialStartEvent = startEvent;
            }
        }

        ParallelGateway parallelGateway = new ParallelGateway();
        parallelGateway.setId(dynamicUserTaskBuilder.nextForkGatewayId(process.getFlowElementMap()));
        process.addFlowElement(parallelGateway);

        UserTask userTask = new UserTask();
        if (dynamicUserTaskBuilder.getId() !is null) {
            userTask.setId(dynamicUserTaskBuilder.getId());
        } else {
            userTask.setId(dynamicUserTaskBuilder.nextTaskId(process.getFlowElementMap()));
        }
        dynamicUserTaskBuilder.setDynamicTaskId(userTask.getId());

        userTask.setName(dynamicUserTaskBuilder.getName());
        userTask.setAssignee(dynamicUserTaskBuilder.getAssignee());
        process.addFlowElement(userTask);

        EndEvent endEvent = new EndEvent();
        endEvent.setId(dynamicUserTaskBuilder.nextEndEventId(process.getFlowElementMap()));
        process.addFlowElement(endEvent);

        SequenceFlow flowToUserTask = new SequenceFlow(parallelGateway.getId(), userTask.getId());
        flowToUserTask.setId(dynamicUserTaskBuilder.nextFlowId(process.getFlowElementMap()));
        process.addFlowElement(flowToUserTask);

        SequenceFlow flowFromUserTask = new SequenceFlow(userTask.getId(), endEvent.getId());
        flowFromUserTask.setId(dynamicUserTaskBuilder.nextFlowId(process.getFlowElementMap()));
        process.addFlowElement(flowFromUserTask);

        SequenceFlow initialFlow = initialStartEvent.getOutgoingFlows().get(0);
        initialFlow.setSourceRef(parallelGateway.getId());

        SequenceFlow flowFromStart = new SequenceFlow(initialStartEvent.getId(), parallelGateway.getId());
        flowFromStart.setId(dynamicUserTaskBuilder.nextFlowId(process.getFlowElementMap()));
        process.addFlowElement(flowFromStart);

        GraphicInfo elementGraphicInfo = bpmnModel.getGraphicInfo(initialStartEvent.getId());
        if (elementGraphicInfo !is null) {
            double yDiff = 0;
            double xDiff = 80;
            if (elementGraphicInfo.getY() < 173) {
                yDiff = 173 - elementGraphicInfo.getY();
                elementGraphicInfo.setY(173);
            }

            Map!(string, GraphicInfo) locationMap = bpmnModel.getLocationMap();
            for (string locationId : locationMap.keySet()) {
                if (initialStartEvent.getId().equals(locationId)) {
                    continue;
                }

                GraphicInfo locationGraphicInfo = locationMap.get(locationId);
                locationGraphicInfo.setX(locationGraphicInfo.getX() + xDiff);
                locationGraphicInfo.setY(locationGraphicInfo.getY() + yDiff);
            }

            Map<string, List!GraphicInfo> flowLocationMap = bpmnModel.getFlowLocationMap();
            for (string flowId : flowLocationMap.keySet()) {
                if (flowFromStart.getId().equals(flowId)) {
                    continue;
                }

                List!GraphicInfo flowGraphicInfoList = flowLocationMap.get(flowId);
                for (GraphicInfo flowGraphicInfo : flowGraphicInfoList) {
                    flowGraphicInfo.setX(flowGraphicInfo.getX() + xDiff);
                    flowGraphicInfo.setY(flowGraphicInfo.getY() + yDiff);
                }
            }

            GraphicInfo forkGraphicInfo = new GraphicInfo(elementGraphicInfo.getX() + 75, elementGraphicInfo.getY() - 5, 40, 40);
            bpmnModel.addGraphicInfo(parallelGateway.getId(), forkGraphicInfo);

            bpmnModel.addFlowGraphicInfoList(flowFromStart.getId(), createWayPoints(elementGraphicInfo.getX() + 30, elementGraphicInfo.getY() + 15,
                            elementGraphicInfo.getX() + 75, elementGraphicInfo.getY() + 15));

            GraphicInfo newTaskGraphicInfo = new GraphicInfo(elementGraphicInfo.getX() + 185, elementGraphicInfo.getY() - 163, 80, 100);
            bpmnModel.addGraphicInfo(userTask.getId(), newTaskGraphicInfo);

            bpmnModel.addFlowGraphicInfoList(flowToUserTask.getId(), createWayPoints(elementGraphicInfo.getX() + 95, elementGraphicInfo.getY() - 5,
                            elementGraphicInfo.getX() + 95, elementGraphicInfo.getY() - 123, elementGraphicInfo.getX() + 185, elementGraphicInfo.getY() - 123));

            GraphicInfo endGraphicInfo = new GraphicInfo(elementGraphicInfo.getX() + 335, elementGraphicInfo.getY() - 137, 28, 28);
            bpmnModel.addGraphicInfo(endEvent.getId(), endGraphicInfo);

            bpmnModel.addFlowGraphicInfoList(flowFromUserTask.getId(), createWayPoints(elementGraphicInfo.getX() + 285, elementGraphicInfo.getY() - 123,
                            elementGraphicInfo.getX() + 335, elementGraphicInfo.getY() - 123));
        }

        BaseDynamicSubProcessInjectUtil.processFlowElements(commandContext, process, bpmnModel, originalProcessDefinitionEntity, newDeploymentEntity);
    }

    override
    protected void updateExecutions(CommandContext commandContext, ProcessDefinitionEntity processDefinitionEntity,
            ExecutionEntity processInstance, List!ExecutionEntity childExecutions) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity execution = executionEntityManager.createChildExecution(processInstance);

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionEntity.getId());
        UserTask userTask = (UserTask) bpmnModel.getProcessById(processDefinitionEntity.getKey()).getFlowElement(dynamicUserTaskBuilder.getDynamicTaskId());
        execution.setCurrentFlowElement(userTask);

        Context.getAgenda().planContinueProcessOperation(execution);
    }

}
