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
module flow.engine.impl.cmd.SuspendProcessDefinitionCmd;

import hunt.time.LocalDateTime;

import flow.common.db.SuspensionState;
import flow.engine.impl.jobexecutor.TimerSuspendProcessDefinitionHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.runtime.ProcessInstance;
import flow.engine.impl.cmd.AbstractSetProcessDefinitionStateCmd;
/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class SuspendProcessDefinitionCmd : AbstractSetProcessDefinitionStateCmd {

    this(ProcessDefinitionEntity processDefinitionEntity, bool includeProcessInstances, Date executionDate, string tenantId) {
        super(processDefinitionEntity, includeProcessInstances, executionDate, tenantId);
    }

    this(string processDefinitionId, string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate, string tenantId) {
        super(processDefinitionId, processDefinitionKey, suspendProcessInstances, suspensionDate, tenantId);
    }

    override
    protected SuspensionState getProcessDefinitionSuspensionState() {
        return SuspensionState.SUSPENDED;
    }

    override
    protected string getDelayedExecutionJobHandlerType() {
        return TimerSuspendProcessDefinitionHandler.TYPE;
    }

    override
    protected AbstractSetProcessInstanceStateCmd getProcessInstanceChangeStateCmd(ProcessInstance processInstance) {
        return new SuspendProcessInstanceCmd(processInstance.getId());
    }

}
