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
import java.util.ArrayList;
import java.util.List;

import org.flowable.bpmn.model.AdhocSubProcess;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.Execution;

/**
 * @author Tijs Rademakers
 */
class GetActiveAdhocSubProcessesCmd implements Command<List<Execution>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processInstanceId;

    public GetActiveAdhocSubProcessesCmd(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public List<Execution> execute(CommandContext commandContext) {
        List<Execution> adhocExecutions = new ArrayList<>();
        List<ExecutionEntity> executions = CommandContextUtil.getExecutionEntityManager(commandContext).findChildExecutionsByProcessInstanceId(processInstanceId);
        for (Execution execution : executions) {
            if (((ExecutionEntity) execution).getCurrentFlowElement() instanceof AdhocSubProcess) {
                adhocExecutions.add(execution);
            }
        }

        return adhocExecutions;
    }

}
