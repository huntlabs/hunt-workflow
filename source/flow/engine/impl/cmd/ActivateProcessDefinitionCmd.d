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

module flow.engine.impl.cmd.ActivateProcessDefinitionCmd;
import hunt.time.LocalDateTime;

import flow.common.db.SuspensionState;
//import flow.engine.impl.jobexecutor.TimerActivateProcessDefinitionHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.runtime.ProcessInstance;
import flow.engine.impl.cmd.AbstractSetProcessDefinitionStateCmd;
import flow.engine.impl.cmd.AbstractSetProcessInstanceStateCmd;
import flow.engine.impl.cmd.ActivateProcessInstanceCmd;
import hunt.Exceptions;
/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class ActivateProcessDefinitionCmd : AbstractSetProcessDefinitionStateCmd {

    this(ProcessDefinitionEntity processDefinitionEntity, bool includeProcessInstances, Date executionDate, string tenantId) {
        super(processDefinitionEntity, includeProcessInstances, executionDate, tenantId);
    }

    this(string processDefinitionId, string processDefinitionKey, bool includeProcessInstances, Date executionDate, string tenantId) {
        super(processDefinitionId, processDefinitionKey, includeProcessInstances, executionDate, tenantId);
    }

    override
    protected SuspensionState getProcessDefinitionSuspensionState() {
        return ACTIVE;
    }

    override
    protected string getDelayedExecutionJobHandlerType() {
        implementationMissing(false);
        return "";
       // return TimerActivateProcessDefinitionHandler.TYPE;
    }

    override
    protected AbstractSetProcessInstanceStateCmd getProcessInstanceChangeStateCmd(ProcessInstance processInstance) {
        return new ActivateProcessInstanceCmd(processInstance.getId());
    }
}
