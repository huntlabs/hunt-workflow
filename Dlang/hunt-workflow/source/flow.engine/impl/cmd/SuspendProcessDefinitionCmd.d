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


import java.util.Date;

import flow.common.db.SuspensionState;
import flow.engine.impl.jobexecutor.TimerSuspendProcessDefinitionHandler;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.runtime.ProcessInstance;

/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class SuspendProcessDefinitionCmd extends AbstractSetProcessDefinitionStateCmd {

    public SuspendProcessDefinitionCmd(ProcessDefinitionEntity processDefinitionEntity, bool includeProcessInstances, Date executionDate, string tenantId) {
        super(processDefinitionEntity, includeProcessInstances, executionDate, tenantId);
    }

    public SuspendProcessDefinitionCmd(string processDefinitionId, string processDefinitionKey, bool suspendProcessInstances, Date suspensionDate, string tenantId) {
        super(processDefinitionId, processDefinitionKey, suspendProcessInstances, suspensionDate, tenantId);
    }

    @Override
    protected SuspensionState getProcessDefinitionSuspensionState() {
        return SuspensionState.SUSPENDED;
    }

    @Override
    protected string getDelayedExecutionJobHandlerType() {
        return TimerSuspendProcessDefinitionHandler.TYPE;
    }

    @Override
    protected AbstractSetProcessInstanceStateCmd getProcessInstanceChangeStateCmd(ProcessInstance processInstance) {
        return new SuspendProcessInstanceCmd(processInstance.getId());
    }

}
