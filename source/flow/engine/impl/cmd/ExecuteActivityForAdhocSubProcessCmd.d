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
module flow.engine.impl.cmd.ExecuteActivityForAdhocSubProcessCmd;



import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.Execution;

/**
 * @author Tijs Rademakers
 */
class ExecuteActivityForAdhocSubProcessCmd : Command!Execution {

    protected string executionId;
    protected string activityId;

    this(string executionId, string activityId) {
        this.executionId = executionId;
        this.activityId = activityId;
    }

    public Execution execute(CommandContext commandContext) {
        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
        if (execution is null) {
            throw new FlowableObjectNotFoundException("No execution found for id '" ~ executionId ~ "'");
        }

        //if (!(execution.getCurrentFlowElement() instanceof AdhocSubProcess)) {
        //    throw new FlowableException("The current flow element of the requested execution is not an ad-hoc sub process");
        //}

        FlowNode foundNode = null;
        AdhocSubProcess adhocSubProcess = cast(AdhocSubProcess) execution.getCurrentFlowElement();

        // if sequential ordering, only one child execution can be active
        if (adhocSubProcess.hasSequentialOrdering()) {
            if (execution.getExecutions().size() > 0) {
                throw new FlowableException("Sequential ad-hoc sub process already has an active execution");
            }
        }

        foreach (FlowElement flowElement ; adhocSubProcess.getFlowElements()) {
            if (activityId == (flowElement.getId()) && cast(FlowNode)flowElement !is null) {
                FlowNode flowNode = cast(FlowNode) flowElement;
                if (flowNode.getIncomingFlows().size() == 0) {
                    foundNode = flowNode;
                }
            }
        }

        if (foundNode is null) {
            throw new FlowableException("The requested activity with id " ~ activityId ~ " can not be enabled");
        }

        ExecutionEntity activityExecution = CommandContextUtil.getExecutionEntityManager().createChildExecution(execution);
        activityExecution.setCurrentFlowElement(foundNode);
        CommandContextUtil.getAgenda().planContinueProcessOperation(activityExecution);

        return activityExecution;
    }

}
