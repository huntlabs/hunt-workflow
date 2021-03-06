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

module flow.engine.impl.event.BreakpointJobHandler;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.agenda.ContinueProcessOperation;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.JobHandler;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 * Continue in the broken process execution
 *
 * @author martin.grofcik
 */
class BreakpointJobHandler : JobHandler {

    public static  string JOB_HANDLER_TYPE = "breakpoint";

    public string getType() {
        return JOB_HANDLER_TYPE;
    }

    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        ExecutionEntity executionEntity = cast(ExecutionEntity) variableScope;
        CommandContextUtil.getAgenda(commandContext).planOperation(new ContinueProcessOperation(commandContext, executionEntity, true, false), executionEntity);
    }
}
