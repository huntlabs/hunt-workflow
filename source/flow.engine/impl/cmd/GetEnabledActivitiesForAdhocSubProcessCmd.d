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
module flow.engine.impl.cmd.GetEnabledActivitiesForAdhocSubProcessCmd;


import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.AdhocSubProcess;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class GetEnabledActivitiesForAdhocSubProcessCmd : Command!(List!FlowNode) {

    protected string executionId;

    this(string executionId) {
        this.executionId = executionId;
    }

    public List!FlowNode execute(CommandContext commandContext) {
        ExecutionEntity execution = CommandContextUtil.getExecutionEntityManager(commandContext).findById(executionId);
        if (execution is null) {
            throw new FlowableObjectNotFoundException("No execution found for id '" ~ executionId ~ "'");
        }

        //if (!(execution.getCurrentFlowElement() instanceof AdhocSubProcess)) {
        //    throw new FlowableException("The current flow element of the requested execution is not an ad-hoc sub process");
        //}

        List!FlowNode enabledFlowNodes = new ArrayList!FlowNode();

        AdhocSubProcess adhocSubProcess = cast(AdhocSubProcess) execution.getCurrentFlowElement();

        // if sequential ordering, only one child execution can be active, so no enabled activities
        if (adhocSubProcess.hasSequentialOrdering()) {
            if (execution.getExecutions().size() > 0) {
                return enabledFlowNodes;
            }
        }

        foreach (FlowElement flowElement ; adhocSubProcess.getFlowElements()) {
            if (cast(FlowNode)flowElement !is null) {
                FlowNode flowNode = cast(FlowNode) flowElement;
                if (flowNode.getIncomingFlows().size() == 0) {
                    enabledFlowNodes.add(flowNode);
                }
            }
        }

        return enabledFlowNodes;
    }

}
