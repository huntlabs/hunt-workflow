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

module flow.engine.impl.cmd.CompleteAdhocSubProcessCmd;

import hunt.collection.List;

import flow.bpmn.model.AdhocSubProcess;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
/**
 * @author Tijs Rademakers
 */
class CompleteAdhocSubProcessCmd : Command!Void {

    protected string executionId;

    this(string executionId) {
        this.executionId = executionId;
    }

    public Void execute(CommandContext commandContext) {
        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager(commandContext);
        ExecutionEntity execution = executionEntityManager.findById(executionId);
        if (execution is null) {
            throw new FlowableObjectNotFoundException("No execution found for id '" ~ executionId ~ "'");
        }

        //if (!(execution.getCurrentFlowElement() instanceof AdhocSubProcess)) {
        //    throw new FlowableException("The current flow element of the requested execution is not an ad-hoc sub process");
        //}

        List!ExecutionEntity childExecutions = execution.getExecutionEntities();
        if (childExecutions.size() > 0) {
            throw new FlowableException("Ad-hoc sub process has running child executions that need to be completed first");
        }

        ExecutionEntity outgoingFlowExecution = executionEntityManager.createChildExecution(execution.getParent());
        outgoingFlowExecution.setCurrentFlowElement(execution.getCurrentFlowElement());

        executionEntityManager.deleteExecutionAndRelatedData(execution, null, false);

        CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation(outgoingFlowExecution, true);

        return null;
    }

}
