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

module flow.engine.impl.cmd.GetActiveAdhocSubProcessesCmd;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.AdhocSubProcess;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.Execution;

/**
 * @author Tijs Rademakers
 */
class GetActiveAdhocSubProcessesCmd : Command!(List!Execution) {

    protected string processInstanceId;

    this(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public List!Execution execute(CommandContext commandContext) {
        List!Execution adhocExecutions = new ArrayList!Execution();
        List!ExecutionEntity executions = CommandContextUtil.getExecutionEntityManager(commandContext).findChildExecutionsByProcessInstanceId(processInstanceId);
        foreach (ExecutionEntity execution ; executions) {
            if (cast(AdhocSubProcess)(execution.getCurrentFlowElement()) !is null) {
                adhocExecutions.add(execution);
            }
        }

        return adhocExecutions;
    }

}
