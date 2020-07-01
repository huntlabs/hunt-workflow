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
module flow.engine.impl.cmd.StartProcessInstanceAsyncCmd;

import flow.bpmn.model.Process;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.jobexecutor.AsyncContinuationJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.runtime.ProcessInstanceBuilderImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.cmd.StartProcessInstanceCmd;
/**
 * author martin.grofcik
 */
class StartProcessInstanceAsyncCmd : StartProcessInstanceCmd {

    this(ProcessInstanceBuilderImpl processInstanceBuilder) {
        super(processInstanceBuilder);
    }


    override
    public ProcessInstance execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ProcessDefinition processDefinition = getProcessDefinition(processEngineConfiguration);
        processInstanceHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();
        ExecutionEntity processInstance = cast(ExecutionEntity) processInstanceHelper.createProcessInstance(processDefinition, businessKey, processInstanceName,
            overrideDefinitionTenantId, predefinedProcessInstanceId, variables, transientVariables,
            callbackId, callbackType, referenceId, referenceType, stageInstanceId, false);
        ExecutionEntity execution = processInstance.getExecutions().get(0);
        Process process = ProcessDefinitionUtil.getProcess(processInstance.getProcessDefinitionId());

        processInstanceHelper.processAvailableEventSubProcesses(processInstance, process, commandContext);

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createProcessStartedEvent(cast(Object)execution, variables, false));
        }

        executeAsynchronous(execution, process);

        return processInstance;
    }

    protected void executeAsynchronous(ExecutionEntity execution, Process process) {
        JobService jobService = CommandContextUtil.getJobService();

        JobEntity job = jobService.createJob();
        job.setExecutionId(execution.getId());
        job.setProcessInstanceId(execution.getProcessInstanceId());
        job.setProcessDefinitionId(execution.getProcessDefinitionId());
        job.setElementId(process.getId());
        job.setElementName(process.getName());
        job.setJobHandlerType(AsyncContinuationJobHandler.TYPE);

        // Inherit tenant id (if applicable)
        if (execution.getTenantId() !is null && execution.getTenantId().length != 0) {
            job.setTenantId(execution.getTenantId());
        }

        execution.getJobs().add(job);

        jobService.createAsyncJob(job, false);
        jobService.scheduleAsyncJob(job);
    }

}
