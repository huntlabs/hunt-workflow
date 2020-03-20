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
module flow.engine.impl.agenda.DebugContinueProcessOperation;

import flow.bpmn.model.FlowNode;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.ProcessDebugger;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.agenda.ContinueProcessOperation;

/**
 * This class extends {@link ContinueProcessOperation} with the possibility to check whether execution is trying to
 * execute a breakpoint
 *
 * @author martin.grofcik
 */
class DebugContinueProcessOperation : ContinueProcessOperation {

    public static  string HANDLER_TYPE_BREAK_POINT = "breakpoint";
    protected ProcessDebugger debugger;

    this(ProcessDebugger debugger, CommandContext commandContext,
                                         ExecutionEntity execution, bool forceSynchronousOperation,
                                         bool inCompensation) {
        super(commandContext, execution, forceSynchronousOperation, inCompensation);
        this.debugger = debugger;
    }

    this(ProcessDebugger debugger, CommandContext commandContext, ExecutionEntity execution) {
        super(commandContext, execution);
        this.debugger = debugger;
    }

    override
    protected void continueThroughFlowNode(FlowNode flowNode) {
        if (debugger.isBreakpoint(execution)) {
            breakExecution(flowNode);
        } else {
            super.continueThroughFlowNode(flowNode);
        }
    }

    protected void breakExecution(FlowNode flowNode) {
        JobService jobService = CommandContextUtil.getJobService();
        JobEntity brokenJob = jobService.createJob();
        brokenJob.setJobType(JobEntity.JOB_TYPE_MESSAGE);
        brokenJob.setRevision(1);
        brokenJob.setRetries(1);
        brokenJob.setExecutionId(execution.getId());
        brokenJob.setProcessInstanceId(execution.getProcessInstanceId());
        brokenJob.setProcessDefinitionId(execution.getProcessDefinitionId());
        brokenJob.setExclusive(false);
        brokenJob.setJobHandlerType(HANDLER_TYPE_BREAK_POINT);

        // Inherit tenant id (if applicable)
        if (execution.getTenantId() !is null) {
            brokenJob.setTenantId(execution.getTenantId());
        }

        jobService.insertJob(brokenJob);
        jobService.moveJobToSuspendedJob(brokenJob);
    }
}
