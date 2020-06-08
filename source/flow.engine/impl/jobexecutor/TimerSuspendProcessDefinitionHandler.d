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


import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.cmd.SuspendProcessDefinitionCmd;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

import com.fasterxml.jackson.databind.JsonNode;

/**
 * @author Joram Barrez
 */
class TimerSuspendProcessDefinitionHandler : TimerChangeProcessDefinitionSuspensionStateJobHandler {

    public static final string TYPE = "suspend-processdefinition";

    override
    public string getType() {
        return TYPE;
    }

    override
    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);

        bool suspendProcessInstances = false;
        try {
            JsonNode configNode = processEngineConfiguration.getObjectMapper().readTree(configuration);
            suspendProcessInstances = getIncludeProcessInstances(configNode);
        } catch (Exception e) {
            throw new FlowableException("Error reading json value " + configuration, e);
        }

        string processDefinitionId = job.getProcessDefinitionId();

        SuspendProcessDefinitionCmd suspendProcessDefinitionCmd = new SuspendProcessDefinitionCmd(processDefinitionId, null, suspendProcessInstances, null, job.getTenantId());
        suspendProcessDefinitionCmd.execute(commandContext);
    }

}
